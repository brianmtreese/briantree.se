---
layout: post
title: "Your First Custom Validator in Angular Signal Forms (Step-By-Step)"
date: "2025-11-13"
video_id: "X7yuPJKy61o"
tags:
  - "Angular"
  - "Angular Forms"
  - "Angular Signals"
  - "Reactive Forms"
  - "Signal Forms"
  - "Form Validation"
  - "TypeScript"
---

<p class="intro"><span class="dropcap">C</span>ustom validators are essential for real-world forms, but implementing them with Reactive Forms requires separate validator functions and complex error handling. Angular's Signal Forms API simplifies custom validation by integrating validators directly into form definitions with cleaner syntax and better type safety. This tutorial demonstrates how to migrate custom validators from Reactive Forms to Signal Forms, showing how the new API makes validation logic more maintainable and reactive.</p>

{% include youtube-embed.html %}

#### Angular Signal Forms Tutorial Series:
- [Migrate to Signal Forms]({% post_url /2025/10/2025-10-16-how-to-migrate-from-reactive-forms-to-signal-forms-in-angular %}) - Start here for migration basics
- [Signal Forms vs Reactive Forms]({% post_url /2025/11/2025-11-06-signal-forms-are-better-than-reactive-forms-in-angular %}) - See why Signal Forms are better
- [Async Validation]({% post_url /2025/11/2025-11-20-angular-signal-forms-async-validation %}) - Handle async validation in Signal Forms
- [Cross-Field Validation]({% post_url /2025/11/2025-11-27-angular-signal-forms-cross-field-validation %}) - Validate across multiple fields
- [State Classes]({% post_url /2025/12/2025-12-04-how-to-use-angulars-new-signal-forms-global-state-classes %}) - Use automatic state classes

## Preview: Angular Reactive Form Behavior We'll Rebuild with Signal Forms

Ok, here's the form for today's example:

<div>
<img src="{{ '/assets/img/content/uploads/2025/11-13/angular-signal-forms-signup-form.jpg' | relative_url }}" alt="The signup form with a username, email, and a submit button" width="1750" height="1274" style="width: 100%; height: auto;">
</div>

It's pretty standard, just a username, email, and a submit button.

Let's walk through the validation quickly so we can see what behavior we're going to replicate.

When we click into the username field and blur out, we immediately get a required message letting us know we need to fill out this field:

<div><img src="{{ '/assets/img/content/uploads/2025/11-13/angular-signal-forms-username-required-validation.jpg' | relative_url }}" alt="The signup form with a username field blurred showing the required error message" width="1544" height="590" style="width: 100%; height: auto;"></div>

Then, when we type a special character, we get an invalid format message:

<div><img src="{{ '/assets/img/content/uploads/2025/11-13/angular-signal-forms-username-format-validation.jpg' | relative_url }}" alt="The signup form with a username field entered with a special character showing the invalid format error message" width="1548" height="608" style="width: 100%; height: auto;"></div>

If we replace this with a letter or number, now we get an invalid length message:

<div><img src="{{ '/assets/img/content/uploads/2025/11-13/angular-signal-forms-username-length-validation.jpg' | relative_url }}" alt="The signup form with a username field entered with a valid username showing the invalid length error message" width="1538" height="612" style="width: 100%; height: auto;"></div>

So we've got multiple validation rules layered here.

Let's finish typing a valid username:

<div><img src="{{ '/assets/img/content/uploads/2025/11-13/angular-signal-forms-username-valid.jpg' | relative_url }}" alt="The signup form with a username field entered with a valid username showing the error message disappearing" width="1328" height="506" style="width: 100%; height: auto;"></div>

Great, that error clears!

Now notice how the submit button is still disabled?

<div><img src="{{ '/assets/img/content/uploads/2025/11-13/angular-signal-forms-form-invalid-disabled-button.jpg' | relative_url }}" alt="The signup form with a username field entered with a valid username showing the button is still disabled because the email field is still empty" width="1586" height="484" style="width: 100%; height: auto;"></div>

That's because the email field is still empty, and therefore the overall form is invalid.

Just like our username, when we click into the email field and blur, we get a required message because the email is required:

<div><img src="{{ '/assets/img/content/uploads/2025/11-13/angular-signal-forms-email-required-validation.jpg' | relative_url }}" alt="The signup form with an email field blurred showing the required error message" width="1536" height="574" style="width: 100%; height: auto;"></div>

If we type an invalid email address, we get an invalid format message:

<div><img src="{{ '/assets/img/content/uploads/2025/11-13/angular-signal-forms-email-format-validation.jpg' | relative_url }}" alt="The signup form with an email field entered with an invalid email address showing the invalid format error message" width="1526" height="542" style="width: 100%; height: auto;"></div>

But once we type a valid email in, the message goes away and the form becomes valid, so the button enables:

<div><img src="{{ '/assets/img/content/uploads/2025/11-13/angular-signal-forms-form-valid-enabled-button.jpg' | relative_url }}" alt="The signup form with a username and email field entered with valid values showing the form is valid and the button is enabled" width="1534" height="566" style="width: 100%; height: auto;"></div>

So this is the behavior we'll need to replicate when we switch over to Signal Forms.

## How Angular Reactive Forms Work (FormGroup, Controls, and Custom Validators)

Let's look at some code and walk through how this works before making any changes.

This form is built using Reactive Forms, and we can see that right here in [the template](https://stackblitz.com/edit/stackblitz-starters-klfvvxxw?file=src%2Fform%2Fform.component.html){:target="_blank"} where we're binding the [form element](https://developer.mozilla.org/en-US/docs/Web/HTML/Reference/Elements/form){:target="_blank"} to our form using the [FormGroup directive](https://angular.dev/api/forms/FormGroupDirective){:target="_blank"}:

```html
<form [formGroup]="form">
    ...
</form>
```

Then we're using the [get()](https://angular.dev/api/forms/FormGroup#get){:target="_blank"} method to access the username field for logic within our template:

```html
@let username = form.get('username'); 
```

This gives us a reference to the control itself without needing to declare it everywhere we use it.

We then use this variable to determine whether or not we should show validation errors based on the touched or invalid status of the username control:

```html
@let showUsernameError = username?.invalid && username?.touched;
```

So we only show errors if the user has interacted with the field.

Next, the input is connected to the form using the [formControlName directive](https://angular.dev/api/forms/FormControlName){:target="_blank"}:

```html
<input
    id="username"
    type="text"
    formControlName="username"
    [class.error]="showUsernameError"
/>
```

We also apply a CSS class if the input should show an error.

And below that, we conditionally render the username error message using the `getUsernameError()` helper from the component:

```html
@if (showUsernameError) {
    <div class="error-message">
        {% raw %}{{ getUsernameError() }}{% endraw %}
    </div>
}
```

Below that, the email field mirrors almost the exact same structure.

Same `form.get()` concept:

```html
@let email = form.get('email'); 
```

Same invalid and touched pattern:

```html
@let showEmailError = email?.invalid && email?.touched;
```

Same `formControlName` directive and error class:

```html
<input
    id="email"
    type="email"
    formControlName="email"
    [class.error]="showEmailError"
/>
```

But the error message logic is a little different:

```html
@if (showEmailError) {
    <div class="error-message">
        @if (email?.hasError('required')) { 
            Email is required 
        }
        @else if (email?.hasError('email')) { 
            Please enter a valid email address
        }
    </div>
}
```

Here we're using the [hasError()](https://angular.dev/api/forms/FormControlName#hasError){:target="_blank"} function to display the correct message for this field.

And at the bottom, if the form is invalid, we add the `disabled` attribute to the submit button:

```html
<button type="submit" [disabled]="form.invalid">
    Create Account
</button>
```

That's all there is to the template, now let's take a look at [the TypeScript](https://stackblitz.com/edit/stackblitz-starters-klfvvxxw?file=src%2Fform%2Fform.component.ts){:target="_blank"}.

At the top, we have a `SignUpForm` interface used to strictly type our form:

```typescript
interface SignUpForm {
    username: FormControl<string>;
    email: FormControl<string>;
}
```

The controls are typed using [FormControl](https://angular.dev/api/forms/FormControl){:target="_blank"}, which pairs nicely with [FormGroup](https://angular.dev/api/forms/FormGroup){:target="_blank"}.

After this, we have our custom validator for the username field:

```typescript
function usernameValidator(
	control: FormControl<string>
): { [key: string]: any } | null {
    // ...
}
```

It returns null when the value is empty, leaving the required validation to the [built-in required validator](https://angular.dev/api/forms/Validators#required){:target="_blank"}:

```typescript
if (!value) {
    return null; // Let required validator handle empty values
}
```

Then it checks if the input is a valid alphanumeric format and if not, it creates a `usernameInvalid` object with the message we want to show:

```typescript
// Must be alphanumeric only
if (!/^[a-zA-Z0-9]+$/.test(value)) {
    return {
        usernameInvalid: {
            message: 'Username must contain only letters and numbers',
        },
    };
}
```

Next, it validates that the length of the username is between 3 and 20 characters.

If not, it provides a `usernameInvalid` error again, with the proper message:

```typescript
// Must be 3-20 characters
if (value.length < 3 || value.length > 20) {
    return {
        usernameInvalid: {
            message: 'Username must be between 3 and 20 characters',
        },
    };
}
```

So that's our custom validator and it's needed because there's no built-in validator that checks both alphanumeric format and the length range we need here.

Next, we can see the `FormGroup`, typed with our `SignUpForm` interface, which creates the reactive form:

```typescript
protected form = new FormGroup<SignUpForm>({
    // ...
});
```

Within this form group, we have our username control using the built-in required validator, followed by our custom username validator:

```typescript
username: new FormControl<string>('', {
    nonNullable: true,
    validators: [Validators.required, usernameValidator],
})
```

Then we have the email control, which uses both the built-in required and [email](https://angular.dev/api/forms/Validators#email){:target="_blank"} validators to ensure the address is valid:

```typescript
email: new FormControl<string>('', {
    nonNullable: true,
    validators: [Validators.required, Validators.email],
})
```

Below that, we have the `getUsernameError()` function that parses the username control's errors and determines which message to show:

```typescript
protected getUsernameError(): string {
    const control = this.form.get('username');
    if (control?.hasError('required')) {
        return 'Username is required';
    }
    if (control?.hasError('usernameInvalid')) {
        return control.getError('usernameInvalid').message;
    }
    return '';
}
```

So, that's our Reactive Forms setup. 

It works, but it doesn't really play nicely with [signals](https://angular.dev/guide/signals){:target="_blank"}.

So, let's switch it over step-by-step.

## What is Angular Signal Forms? (Experimental, Signals + Validation)

Before we start, it's important to note that this is an experimental API that uses signals for form state and validation.

It's more reactive, more type-safe, and integrates naturally with Angular's signal-based reactivity model.

That said, **it's not recommended for production just yet!** 

It's mainly available for testing and feedback.

The main difference for custom validators is how they're written and integrated.

So, let's start migrating this form to the new API.

## Step-by-Step Migration: Angular Reactive Forms → Signal Forms

The first thing we need to do is update our `SignUpForm` interface.

It's currently typed with `FormControl` types, but with Signal Forms, these will just be strings:

```typescript
interface SignUpForm {
  username: string;
  email: string;
}
```

Now we can remove the old `FormGroup` and its controls. We won't be using those anymore.

We can also remove the `ReactiveFormsModule` from the component's imports array and all unused imports at the top of the file.

### Build Angular Signal Forms with form() and a Signal-Backed Model

With Signal Forms, we store the state of the form in a signal.

So let's create a new signal named `model`, and we'll type it using our updated `SignUpForm` interface:

```typescript
import { signal } from '@angular/core';

protected model = signal<SignUpForm>({});
```

Then we'll initialize the username and email properties with empty strings:

```typescript
protected model = signal<SignUpForm>({
  username: '',
  email: ''
});
```

This will now be the source of truth for the form's state.

Next, we'll create the form itself.

For this, we'll use the new `form()` method from the Signal Forms API:

```typescript
import { form } from '@angular/forms/signals';

protected form = form(this.model);
```

This creates a reactive form signal wrapped around our `model` signal.

Now, how do we add validation?

Well, we do that right inside this function.

Instead of passing validators to individual controls, we describe our form's validation inside a schema callback.

To make a field required, we use the new `required()` method from the Signal Forms module:

```typescript
import { ..., required } from '@angular/forms/signals';

protected form = form(this.model, s => {
  required(s.username);
});
```

We'll do the same for our email field:

```typescript
protected form = form(this.model, s => {
  required(s.username);
  required(s.email);
});
```

And then, to validate the format of the email, we'll use the new `email()` method:

```typescript
import { ..., email } from '@angular/forms/signals';

protected form = form(this.model, s => {
  required(s.username);
  required(s.email);
  email(s.email);
});
```

Okay, now what about our custom username validation?

Well, before we can use it, we need to make a couple tweaks to our current custom validator function.

### Custom Validators in Signal Forms: validate() + customError()

First, we need to update what we pass into this validator.

It used to take a `FormControl`, but now it uses a `FieldPath` from the Signal Forms module:

```typescript
import { ..., FieldPath } from '@angular/forms/signals';

function usernameValidator(field: FieldPath<string>) {
    // ...
}
```

A `FieldPath` is just a type-safe reference to a specific field in your form's model.

Essentially, it lets us interact with that field programmatically.

Next, we need to wrap all of this logic in the new `validate()` function from Signal Forms:

```typescript
import { validate } from '@angular/forms/signals';

function usernameValidator(field: FieldPath<SignUpForm, 'username'>) {
  return validate(field, ctx => {
    const value = ctx.value();
    // ...
  });
}
```

This function takes in the field and provides a validation context object that we can use to monitor the field's value.

We'll leave the required validation check as is:

```typescript
if (!value) {
    return null; // Let required validator handle empty values
}
```

Now we just need to update how we handle the errors and messages.

With Signal Forms, we use the new `customError()` function:

```typescript
import { ..., customError } from '@angular/forms/signals';

// Must be alphanumeric only
if (!/^[a-zA-Z0-9]+$/.test(value)) {
    return customError({
        kind: 'usernameInvalid',
        message: 'Username must contain only letters and numbers',
    });
}
```

This takes a `kind` property which identifies the error type and a `message` string to display.

Then we need to do the same for the length rule.

We need to add the `customError()` function, and we'll use the same `usernameInvalid` for the `kind` property:

```typescript
// Must be 3-20 characters
if (value.length < 3 || value.length > 20) {
    return customError({
        kind: 'usernameInvalid',
        message: 'Username must be between 3 and 20 characters',
    });
}
```

That's everything we need to change in our custom validator.

Now we're ready to add it to our form. 

To do so, we simply call the function and pass it the field, just like the built-in validators:

```typescript
protected form = form(this.model, p => {
    // ...  
    usernameValidator(p.username);
});
```

So now our form is configured to use the custom validator during validation.

### Angular Signal Forms Error Handling with Computed Signals (getUsernameError, getEmailError)

Next, let's update how we handle error messages.

We'll replace the `getUsernameError()` function with a [computed](https://angular.dev/api/core/computed){:target="_blank"} signal instead:

```typescript
import { computed } from '@angular/core';

protected getUsernameError = computed(() => {
});
```

Inside it, we'll first grab the errors array from the username field signal on the form:

```typescript
const errors = this.form.username().errors();
```

Then we'll check if there's a required error. If so, we return the required message:

```typescript
const required = errors.find(e => e.kind === 'required');
if (required) {
    return 'Username is required';
}
```

If not, we'll check for a `usernameInvalid` error and return that message instead:

```typescript
const invalid = errors.find(e => e.kind === 'usernameInvalid');
if (invalid) {
    return invalid?.message;
}
```

Finally, we return an empty string as a catch-all if none of these match:

```typescript
return '';
```

Then, we'll handle our email errors in the same way with a new computed signal:

```typescript
protected getEmailError = computed(() => {
    const errors = this.form.email().errors();

    const required = errors.find(e => e.kind === 'required');
    if (required) {
        return 'Email is required';
    }

    const email = errors.find(e => e.kind === 'email');
    if (email) {
        return 'Please enter a valid email address';
    }

    return '';
});
```

This keeps our error logic centralized and reactive. 

There's no need for complex template conditions and honestly, I don't think there's a great way to do this in the template anyway.

Finally, we'll import the new `Field` directive from the Signal Forms module in our component's imports array so we can wire everything up in the template:

```typescript
import { Field } from '@angular/forms/signals';

@Component({
  selector: 'app-form',
  // ...
  imports: [ Field ]
})
```

This is what we'll use in place of the old `formControlName` or `formControl` directives.

That's all we need to do here, now let's switch over to the template.

## Angular Signal Forms Template Wiring: Replace formControlName with [field] Directive

First, we can remove the `formGroup` binding since we're not using it anymore.

Next, to access the username field, we'll use the form property to get the username signal now:

```html
@let username = form.username();
```

We'll also update the invalid and touched checks to use signals now:

```html
@let showUsernameError = username.invalid() && username.touched();
```

Next, we'll switch from the `formControlName` directive to the new `field` directive and bind it to our form's username field:

#### Before:
```html
<input formControlName="username" />
```

#### After:
```html
<input [field]="form.username" />
```

Everything else stays the same until we get to the email control.

Here, we'll do the same updates. 

We'll switch to the email signal:

```html
@let email = form.email();
```

Switch to signals for invalid and touched:

```html
@let showEmailError = email.invalid() && email.touched();
```

And use the `field` directive for the control:

```html
<input [field]="form.email" />
```

And in this case, we also need to simplify the error message to use our new `getEmailError` computed signal:

```html
@if (showEmailError) {
    <div class="error-message">
        {% raw %}{{ getEmailError() }}{% endraw %}
    </div>
}
```

Lastly, we'll update the disabled binding on the button to use signals too:

```html
<button type="submit" [disabled]="form().invalid()">
    Create Account
</button>
```

Ok, that should be everything, let's save and try it out!

## Live Test: Angular Signal Forms Custom Validation (Required, Format, and Length)

Everything looks the same to start which is good!

<div>
<img src="{{ '/assets/img/content/uploads/2025/11-13/angular-signal-forms-signup-form.jpg' | relative_url }}" alt="The signup form showing empty username and email fields with a disabled submit button after converting to Signal Forms" width="1750" height="1274" style="width: 100%; height: auto;">
</div>

When we click in and blur the username field, we get the required error. Nice!

<div>
<img src="{{ '/assets/img/content/uploads/2025/11-13/angular-signal-forms-username-required-validation.jpg' | relative_url }}" alt="The signup form with a username field blurred showing the required error message after converting to Signal Forms" width="1544" height="590" style="width: 100%; height: auto;">
</div>

If we type an invalid character, we get the alphanumeric error message:

<div>
<img src="{{ '/assets/img/content/uploads/2025/11-13/angular-signal-forms-username-format-validation.jpg' | relative_url }}" alt="The signup form with a username field entered with an invalid character showing the alphanumeric error message after converting to Signal Forms" width="1548" height="608" style="width: 100%; height: auto;">
</div>

If the length isn't valid, we get the length error message:

<div>
<img src="{{ '/assets/img/content/uploads/2025/11-13/angular-signal-forms-username-length-validation.jpg' | relative_url }}" alt="The signup form with a username field entered showing the invalid length error message after converting to Signal Forms" width="1538" height="612" style="width: 100%; height: auto;">
</div>

And once we enter a valid username, the error disappears completely:

<div>
<img src="{{ '/assets/img/content/uploads/2025/11-13/angular-signal-forms-username-valid.jpg' | relative_url }}" alt="The signup form with a username field entered with a valid username showing the error message disappearing after converting to Signal Forms" width="1328" height="506" style="width: 100%; height: auto;">
</div>

Now for the email validation: Click into the field and blur: 

<div>
<img src="{{ '/assets/img/content/uploads/2025/11-13/angular-signal-forms-email-required-validation.jpg' | relative_url }}" alt="The signup form with an email field blurred showing the required error message after converting to Signal Forms" width="1536" height="574" style="width: 100%; height: auto;">
</div>

The required error still works!

Enter an invalid email:

<div>
<img src="{{ '/assets/img/content/uploads/2025/11-13/angular-signal-forms-email-format-validation.jpg' | relative_url }}" alt="The signup form with an email field entered with an invalid email address showing the invalid format error message after converting to Signal Forms" width="1526" height="542" style="width: 100%; height: auto;">
</div>

That still works too!

Then, enter a valid email:

<div>
<img src="{{ '/assets/img/content/uploads/2025/11-13/angular-signal-forms-form-valid-enabled-button.jpg' | relative_url }}" alt="The signup form with username and email fields entered with valid values showing the form is valid and the button is enabled after converting to Signal Forms" width="1260" height="572" style="width: 100%; height: auto;">
</div>

The errors disappear, and the submit button enables because the form is now valid.

Everything here is now running on signals, and that's pretty cool.

## Takeaway: Custom Validators Work Great in Angular Signal Forms

So we just saw how custom validators work great in Signal Forms too.

You write them almost the same way, just a few small syntax changes.

If you've built custom validators before, they'll feel instantly familiar in Signal Forms, and that's definitely a good thing.

If you enjoyed this, be sure to [subscribe](https://www.youtube.com/c/briantreese?sub_confirmation=1) and leave a comment, it really helps other Angular developers find this content.

And hey — if you want to rep the Angular builder community, check out the Shieldworks “United by Craft” tees and hoodies [here](https://shop.briantree.se/){:target="_blank"}. They’re built for the ones who code like it’s a trade!

## Additional Resources
- [The demo app BEFORE any changes](https://stackblitz.com/edit/stackblitz-starters-klfvvxxw?file=src%2Fform%2Fform.component.ts){:target="_blank"}
- [The demo app AFTER making changes](https://stackblitz.com/edit/stackblitz-starters-hmhboefo?file=src%2Fform%2Fform.component.ts){:target="_blank"}
- [Angular Signal Forms GitHub (Experimental)](https://github.com/angular/angular/tree/main/packages/forms/signals){:target="_blank"}
- [Angular Reactive Forms Docs](https://angular.dev/guide/forms/reactive-forms){:target="_blank"}
- [Angular Signals Overview](https://angular.dev/guide/signals){:target="_blank"}
- [My course "Angular: Styling Applications"](https://www.pluralsight.com/courses/angular-styling-applications){:target="_blank"}
- [My course "Angular in Practice: Zoneless Change Detection"](https://app.pluralsight.com/library/courses/angular-practice-zoneless-change-detection){:target="_blank"}
- [Get a Pluralsight FREE TRIAL HERE!](https://www.jdoqocy.com/click-101557355-17135603){:target="_blank"}

## Try It Yourself

Want to experiment with Signal Forms and custom validators? Explore the full StackBlitz demo below. 

If you have any questions or thoughts, don't hesitate to leave a comment.

<iframe src="https://stackblitz.com/edit/stackblitz-starters-hmhboefo?ctl=1&embed=1&file=src%2Fform%2Fform.component.ts" style="height: 500px; width: 100%; margin-bottom: 1.5em; display: block;"></iframe>

