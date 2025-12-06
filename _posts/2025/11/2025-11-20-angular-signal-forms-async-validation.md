---
layout: post
title: "Async Validation in Angular Signal Forms (Complete Guide)"
date: "2025-11-20"
video_id: "-CIHvpCRE88"
tags:
  - "Angular"
  - "Angular Forms"
  - "Angular Signals"
  - "Reactive Forms"
  - "Signal Forms"
  - "TypeScript"
  - "Form Validation"
  - "Async Validation"
---

<p class="intro"><span class="dropcap">A</span>sync validation in Reactive Forms requires separate validator functions, manual debouncing, and complex pending state management. Angular's Signal Forms API simplifies async validation with <code>validateAsync()</code> and <code>resource()</code>, providing built-in debouncing, pending states, and cleaner error handling. This tutorial demonstrates how to implement async validation in Signal Forms, including server-backed username checks, real-time feedback, and proper pending state management.</p>

{% include youtube-embed.html %}

#### Angular Signal Forms Tutorial Series:
- [Migrate to Signal Forms]({% post_url /2025/10/2025-10-16-how-to-migrate-from-reactive-forms-to-signal-forms-in-angular %}) - Start here for migration basics
- [Custom Validators]({% post_url /2025/11/2025-11-13-how-to-migrate-a-form-with-a-custom-validator-to-signal-forms-in-angular %}) - Add custom validation to Signal Forms
- [Cross-Field Validation]({% post_url /2025/11/2025-11-27-angular-signal-forms-cross-field-validation %}) - Validate across multiple fields
- [State Classes]({% post_url /2025/12/2025-12-04-how-to-use-angulars-new-signal-forms-global-state-classes %}) - Use automatic state classes

## Starting with a Basic Signal Form

For this example, we'll be using an Angular form:

<div>
<img src="{{ '/assets/img/content/uploads/2025/11-20/demo-1.jpg' | relative_url }}" alt="Angular signup form built with Signal Forms API showing a username field and email field both filled with valid values, no error messages displayed, and an enabled submit button indicating the form is valid" width="1750" height="1372" style="width: 100%; height: auto;">
</div>

It has a username field and that field should check the server to see if the username exists as the user types. Easy enough, right?

<div>
<img src="{{ '/assets/img/content/uploads/2025/11-20/demo-2.jpg' | relative_url }}" alt="Angular signup form with Signal Forms API showing the username field focused and being typed into, demonstrating the need for async validation to check username availability in real-time" width="1428" height="948" style="width: 100%; height: auto;">
</div>

But there's a twist: this form uses the new Signal Forms API. 

So how do we add async validators with Signal Forms?

Well, that's what you'll learn in this tutorial. 

And don't worry, it's pretty simple.

## Previewing the Angular Form Before Async Validation

But first, let's see how it works before we make any changes.

When we click in and remove the Username and then blur out… we get a required error:

<div>
<img src="{{ '/assets/img/content/uploads/2025/11-20/demo-3.jpg' | relative_url }}" alt="Angular signup form with Signal Forms API showing the username field empty and displaying a required validation error message after the field is blurred, demonstrating client-side validation" width="1124" height="546" style="width: 100%; height: auto;">
</div>

Same thing with Email. Blur it out, and the required message pops in:

<div>
<img src="{{ '/assets/img/content/uploads/2025/11-20/demo-4.jpg' | relative_url }}" alt="Angular signup form with Signal Forms API showing the email field empty and displaying a required validation error message after the field is blurred, demonstrating client-side validation" width="1102" height="576" style="width: 100%; height: auto;">
</div>

And if we type an invalid email… we get the "invalid email" message:

<div>
<img src="{{ '/assets/img/content/uploads/2025/11-20/demo-5.jpg' | relative_url }}" alt="Angular signup form with Signal Forms API showing the email field entered with an invalid email address and displaying an invalid email format validation error message, demonstrating client-side validation" width="1100" height="580" style="width: 100%; height: auto;">
</div>

But what we really want is a way to check whether the username already exists on the server and then show that error immediately while the user is typing.

If you've done this in [Reactive Forms](https://angular.dev/guide/forms/reactive-forms){:target="_blank"} or [Template-Driven Forms](https://angular.dev/guide/forms/template-driven-forms){:target="_blank"}, you know the general idea. 

But with the new experimental Signal Forms API, the pattern is different, and that's what we're about to implement.

## Understanding the HTML Setup with Signal Forms

Okay, let's look at [the template](https://stackblitz.com/edit/stackblitz-starters-dcnkp3rt?file=src%2Fform%2Fform.component.html){:target="_blank"} so we can see what's powering all of this.

First, we have our username field:

```html
<input
    id="username"
    type="text"
    [field]="form.username"
    [class.error]="showUsernameError"/>
```

With Signal Forms, we use the [field](https://angular.dev/essentials/signal-forms#3-bind-html-inputs-with-field-directive){:target="_blank"} directive to bind the control to the input.

Then we have a couple of template variables, one that stores the control signal: 

```html
@let username = form.username();
```

And another that makes it easy to check whether the field is in an error state after the user interacts with it using the `touched` and `invalid` states of the control:

```html
@let showUsernameError = username.invalid() && username.touched();
```

Below that, we loop through the field's validation errors and display them based on the value of this variable:

```html
@if (showUsernameError) {
    <ul class="error-message">
        @for (error of username.errors(); track error.kind) {
            <li>{% raw %}{{ error.message }}{% endraw %}</li>
        }
    </ul>
}
```

And it's the same setup for the email field. 

We have the input with the field binding:

```html
<input
    id="email"
    type="email"
    [field]="form.email"
    [class.error]="showEmailError"/>
```

The variables:

```html
@let email = form.email();
@let showEmailError = email.invalid() && email.touched();
```

And the conditional error messages:

```html
@if (showEmailError) {
    <ul class="error-message">
        @for (error of email.errors(); track error.kind) {
            <li>{% raw %}{{ error.message }}{% endraw %}</li>
        }
    </ul>
}
```

Right now, everything is purely client-side. Nothing async yet.

## How the Form Model and Validators Work in Signal Forms

Alright, now let's look to [the component TypeScript](https://stackblitz.com/edit/stackblitz-starters-dcnkp3rt?file=src%2Fform%2Fform.component.ts){:target="_blank"} to see how this all works.

At the top, we've got our "model" [signal](https://angular.dev/guide/signals#writable-signals){:target="_blank"}:

```typescript
interface SignUpForm {
  username: string;
  email: string;
}

protected model = signal<SignUpForm>({
    username: '',
    email: ''
});
```

This is the source of truth for the form, and it stores the form state as a signal.

Then we create the form using the new [form()](https://angular.dev/api/forms/signals/form){:target="_blank"} function, from the Signal Forms API, where we define our validation:

```typescript
import { form, required, email } from '@angular/forms/signals';

protected form = form(this.model, s => {
    required(s.username, {message: 'A username is required'});
		required(s.email, {message: 'An email address is required'});
		email(s.email, {message: 'Please enter a valid email address'});
});
```

We've got a [required()](https://angular.dev/api/forms/signals/required){:target="_blank"} validator on the username and email fields.

Then we have an [email()](https://angular.dev/api/forms/signals/email){:target="_blank"} validator to check for a valid email format.

This is how you apply built-in validators with Signal Forms.

Then below that, we have a method that simulates a server call to check whether a username already exists:

```typescript
private checkUsernameAvailability(username: string): Promise<boolean> {
    return new Promise(resolve => {
        setTimeout(() => {
            const taken = ['admin', 'test', 'brian'];
            resolve(!taken.includes(username.toLowerCase()));
        }, 2500);
    });
}
```

On the mock server, "admin", "test", and "brian" are all taken.

Right now this method isn't used at all, so let's fix that.

## How Async Validation Works in Angular Signal Forms

Async validation means we want Angular to check the server after the user types their username automatically.

We'll add this validator inside our form setup, right alongside the other validators.

And for this, Signal Forms gives us a `validateAsync()` method:

```typescript
import { validateAsync } from '@angular/forms/signals';

protected form = form(this.model, s => {
    required(s.username);
    required(s.email);
    email(s.email);

    validateAsync(s.username, {
        // ... async validation config
    });
});
```

We pass in the field we want to validate, in this case `username`, and then an options object.

### Creating Params to Control When Validation Runs

Next, let's define the `params` function. This lets us customize what value gets passed into the async process:

```typescript
validateAsync(s.username, {
    params: ({ value }) => {
        const val = value();
        // ...
    }
});
```

`value()` gives us the current username value.

We only want to run the async validator if the user has typed something meaningful.

So if the value is empty or shorter than 3 characters, we return `undefined`:

```typescript
params: ({ value }) => {
    const val = value();
    if (!val || val.length < 3) return undefined;
    return val;
}
```

Returning `undefined` tells Angular: "Hey, don't run the async validator right now." 

Returning the value means: "Yes, go validate this."

### Building an Async Resource with Factory and resource()

Next up, we need a factory. This creates the actual async resource Angular will use.

For this, we'll use a [resource()](https://angular.dev/api/core/resource){:target="_blank"}. This is Angular's way of handling async data over time. It's like a signal designed for async operations:

```typescript
import { resource } from '@angular/core';

validateAsync(s.username, {
    params: ({ value }) => {
        const val = value();
        if (!val || val.length < 3) return undefined;
        return val;
    }
    factory: username => resource({
        params: username
    })
});
```

Inside the `resource`, we need a "loader". 

This is the async function that actually hits the server, or in our case, the fake server:

```typescript
factory: username => resource({
    params: username,
    loader: async ({ params: username }) => {
        const available = await this.checkUsernameAvailability(username);
        return available;
    }
})
```

So "available" is going to be either `true` or `false`. If `false`, that means the username is taken and we need to show an error.

### Handling Async Results with onSuccess and customError

Now we need to turn that boolean result into an actual error if needed.

For this, we add the `onSuccess` property:

```typescript
validateAsync(s.username, {
    params: ({ value }) => {
        const val = value();
        if (!val || val.length < 3) return undefined;
        return val;
    },
    factory: username => resource({
        params: username,
        loader: async ({ params: username }) => {
            const available = await this.checkUsernameAvailability(username);
            return available;
        }
    }),
    onSuccess: (result: boolean) => {
      // ...
    }
});
```

If the username is taken, we return a custom error.

To do this we'll use the new `customError` function:

```typescript
import { customError } from '@angular/forms/signals';

onSuccess: (result: boolean) => {
    if (!result) {
        return customError({
            kind: 'username_taken',
            message: 'This username is already taken'
        });
    }
    return null;
}
```

For this, we add an error `kind` property. Essentially the type of error. In this case, `username_taken`.

Then we need to provide a `message` to display for this error.

Then, if we don't have an error, we'll return `null` because everything is good.

This "kind" property is super helpful because we can look for it in the template later. More on this in a minute.

### Adding onError for Failed Async Validation Requests

Finally, we add an `onError` handler in case the async operation has any issues:

```typescript
validateAsync(s.username, {
    params: ({ value }) => {
        const val = value();
        if (!val || val.length < 3) return undefined;
        return val;
    },
    factory: username => resource({
        params: username,
        loader: async ({ params: username }) => {
            const available = await this.checkUsernameAvailability(username);
            return available;
        }
    }),
    onSuccess: (result: boolean) => {
        if (!result) {
            return customError({
                kind: 'username_taken',
                message: 'This username is already taken'
            });
        }
        return null;
    },
    onError: (error: unknown) => {
        console.error('Async validation error:', error);
        return null;
    }
});
```

If anything unexpected happens during validation, we'll log it and return `null` so the field doesn't stay invalid.

And at this point, our async validator is ready!

## Updating the Template for Pending States and Async Errors

Now let's switch back to the template to add this to the UI.

With the async validator, we have access to a "pending" signal, which becomes true whenever the validator is running.

So, after our username input, let's add a pending message using this new signal:

```html
@if (username.pending()) {
    <p class="info">Checking availability...</p>
}
```

This will now show up while the async validator is running.

Then, we already have a condition to list out any error messages, but unfortunately we can't use this same loop.

Async errors feel different. We don't want to force people to blur the field before they see them. So instead of `touched`, we need to use `dirty`:

```html
@if (username.dirty()) {
    <!-- New error here -->
} @else if (showUsernameError) {
    ...
}
```

Then, within this we'll use our same errors loop and we'll check if it's the "username_taken" error. 

If it is, we'll add the string interpolated value of our error message:

```html
@if (username.dirty()) {
    @for (error of username.errors(); track error.kind) {
        @if (error.kind === 'username_taken') {
            <p class="error-message">{% raw %}{{ error.message }}{% endraw %}</p>
        }
    }
} @else if (showUsernameError) {
    ...
}
```

This gives the user immediate feedback as they type.

Okay, that should be everything we need so let's try it out!

## Testing the Async Username Validation in the App

Alright, let's type a username we know is already taken:

<div>
<img src="{{ '/assets/img/content/uploads/2025/11-20/demo-6.jpg' | relative_url }}" alt="Angular signup form with Signal Forms API showing the username field entered with a username that is already taken and displaying a pending message while the async validation is running, demonstrating the need for async validation to check username availability in real-time" width="1214" height="618" style="width: 100%; height: auto;">
</div>

As we do, we can see the pending message below the field.

Then, once the request is received, we get the error message letting us know this username already exists:

<div>
<img src="{{ '/assets/img/content/uploads/2025/11-20/demo-7.jpg' | relative_url }}" alt="Angular signup form with Signal Forms API showing the username field entered with a username that is already taken and displaying an error message letting us know this username already exists, demonstrating the need for async validation to check username availability in real-time" width="1236" height="592" style="width: 100%; height: auto;">
</div>

Once we add one that's available, the error disappears.

<div>
<img src="{{ '/assets/img/content/uploads/2025/11-20/demo-8.jpg' | relative_url }}" alt="Angular signup form with Signal Forms API showing the username field entered with a username that is available and displaying no error message, demonstrating the need for async validation to check username availability in real-time" width="1034" height="428" style="width: 100%; height: auto;">
</div>

Our async validation is working exactly how we expect, but we probably should debounce this right? 

We shouldn't be hitting our server on every keystroke.

## Debouncing the Async Username Check

Debouncing this validator is now incredibly easy with Signal Forms.

All we have to do is go back into our form configuration and add the [debounce](https://angular.dev/api/forms/signals/debounce){:target="_blank"} helper the same way we use the built-in validator helpers:

```typescript
import { debounce } from '@angular/forms/signals';

protected form = form(this.model, s => {
    required(s.username);
    required(s.email);
    email(s.email);
    
    debounce(s.username, 500);
    
    validateAsync(s.username, {
        ...
    });
});
```

We just pass in the username field, followed by the duration we want to debounce, 500 milliseconds.

Pretty cool, right?

With Signal Forms it's just that easy!

## Final Thoughts: Async Validation in Signal Forms

And that's how you add async validation to Signal Forms. 

Clean code, great UX, and hopefully a simpler flow than the old form setups.

You learned how to use `validateAsync()`, how to hook it into a `resource()`, how to show pending states, how to display custom async errors, and how to debounce your validator to avoid unnecessary server calls.

If you enjoyed this, be sure to [subscribe](https://www.youtube.com/c/briantreese?sub_confirmation=1) and leave a comment, it really helps other Angular developers find this content.

And hey, if you want to show a little Angular pride, check out the Shieldworks tees and hoodies [here](https://shop.briantree.se/){:target="_blank"}. They're built for devs who treat this work like a real craft.

## Additional Resources
- [The demo app BEFORE any changes](https://stackblitz.com/edit/stackblitz-starters-dcnkp3rt?file=src%2Fform%2Fform.component.ts){:target="_blank"}
- [The demo app AFTER making changes](https://stackblitz.com/edit/stackblitz-starters-pfzstgbv?file=src%2Fform%2Fform.component.ts){:target="_blank"}
- [Official Signal Forms Docs](https://angular.dev/essentials/signal-forms){:target="_blank"}
- [Angular Reactive Forms Docs](https://angular.dev/guide/forms/reactive-forms){:target="_blank"}
- [Angular Signals Overview](https://angular.dev/guide/signals){:target="_blank"}
- [My course "Angular: Styling Applications"](https://www.pluralsight.com/courses/angular-styling-applications){:target="_blank"}
- [My course "Angular in Practice: Zoneless Change Detection"](https://app.pluralsight.com/library/courses/angular-practice-zoneless-change-detection){:target="_blank"}
- [Get a Pluralsight FREE TRIAL HERE!](https://www.jdoqocy.com/click-101557355-17135603){:target="_blank"}

## Try It Yourself

Want to experiment with async validation in Signal Forms? Explore the full StackBlitz demo below. 

If you have any questions or thoughts, don't hesitate to leave a comment.

<iframe src="https://stackblitz.com/edit/stackblitz-starters-pfzstgbv?ctl=1&embed=1&file=src%2Fform%2Fform.component.ts" style="height: 500px; width: 100%; margin-bottom: 1.5em; display: block;"></iframe>

