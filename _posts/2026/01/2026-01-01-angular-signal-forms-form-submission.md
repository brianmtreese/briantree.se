---
layout: post
title: "Submit Forms the Modern Way in Angular Signal Forms"
date: "2026-01-01"
video_id: "3beFbUwT_hg"
tags:
  - "Angular"
  - "Angular Forms"
  - "Angular Signals"
  - "Signal Forms"
  - "TypeScript"
  - "Form Validation"
---

<p class="intro"><span class="dropcap">A</span>ngular <a href="https://angular.dev/essentials/signal-forms" target="_blank">Signal Forms</a> make client-side validation feel clean and reactive, but how do you actually submit them? Without proper submission handling, forms refresh the page, ignore server validation errors, and lack loading states. Angular's new <a href="https://angular.dev/api/forms/signals/submit" target="_blank">submit()</a> API solves this by providing async submission, automatic loading state tracking, touched field handling, and seamless server-side error mapping. This guide shows you how to implement Angular Signal Forms form submission the right way.</p>

{% include youtube-embed.html %}

#### Angular Signal Forms Tutorial Series:
- [Migrate to Signal Forms]({% post_url /2025/10/2025-10-16-how-to-migrate-from-reactive-forms-to-signal-forms-in-angular %}) - Start here for migration basics
- [Signal Forms vs Reactive Forms]({% post_url /2025/11/2025-11-06-signal-forms-are-better-than-reactive-forms-in-angular %}) - See why Signal Forms are better
- [Custom Validators]({% post_url /2025/11/2025-11-13-how-to-migrate-a-form-with-a-custom-validator-to-signal-forms-in-angular %}) - Add custom validation to Signal Forms
- [Async Validation]({% post_url /2025/11/2025-11-20-angular-signal-forms-async-validation %}) - Handle async validation in Signal Forms
- [Cross-Field Validation]({% post_url /2025/11/2025-11-27-angular-signal-forms-cross-field-validation %}) - Validate across multiple fields
- [State Classes]({% post_url /2025/12/2025-12-04-how-to-use-angulars-new-signal-forms-global-state-classes %}) - Use automatic state classes
- [Zod Validation]({% post_url /2025/12/2025-12-11-angular-signal-forms-zod-validation %}) - Schema validation with Zod
- [Zod with validateStandardSchema]({% post_url /2025/12/2025-12-25-angular-signal-forms-zod-validation-validatestandardschema %}) - Simplified Zod integration

## How Signal Forms Handle Client-Side Validation

Let's start by examining what Signal Forms already do well.

Here's a simple signup form built entirely with the Signal Forms API:

<div>
<img src="{{ '/assets/img/content/uploads/2026/01-01/demo-1.jpg' | relative_url }}" alt="A signup form with username and email input fields" width="1294" height="912" style="width: 100%; height: auto;">
</div>

Notice that the "Create account" button is disabled out of the gate:

<div>
<img src="{{ '/assets/img/content/uploads/2026/01-01/demo-2.jpg' | relative_url }}" alt="The signup form submit button disabled because the form is invalid" width="1364" height="358" style="width: 100%; height: auto;">
</div>

That's because the form is invalid. We haven't entered a username or email yet.

When I click into the username field and blur it, a validation error appears:

<div>
<img src="{{ '/assets/img/content/uploads/2026/01-01/demo-3.jpg' | relative_url }}" alt="The signup form showing validation error for username field" width="1302" height="464" style="width: 100%; height: auto;">
</div>

This is client-side validation running immediately. 

And we have the same behavior with the email field.

Click in, blur out, and an error appears:

<div>
<img src="{{ '/assets/img/content/uploads/2026/01-01/demo-4.jpg' | relative_url }}" alt="The signup form showing validation error for email field" width="1266" height="446" style="width: 100%; height: auto;">
</div>

After entering valid values, the errors disappear and the submit button becomes enabled:

<div>
<img src="{{ '/assets/img/content/uploads/2026/01-01/demo-5.jpg' | relative_url }}" alt="The signup form with valid username and email, submit button enabled" width="1232" height="744" style="width: 100%; height: auto;">
</div>

So far, so good. This is exactly what we'd expect from a properly validated form.

## Why Form Submission Breaks

Now let's try submitting the form.

When I click "Create account", the browser actually refreshes:

<div>
<img src="{{ '/assets/img/content/uploads/2026/01-01/demo-6.gif' | relative_url }}" alt="Browser page refresh after form submission" width="1000" height="601" style="width: 100%; height: auto;">
</div>

That's obviously not what we want.

There's no submission logic, no async handling, and no way to surface server validation errors. 

This is the gap we need to fix.

## How the Signal Form Template Works

Let's examine [the component template](https://stackblitz.com/edit/stackblitz-starters-mtaw9y7j?file=src%2Fform%2Fform.component.html){:target="_blank"} to understand why this is happening.

At the top, we have a plain `<form>` element with no submit handler attached:

```html
<form>
  ...
</form>
```

The username input is wired up using the [field directive](https://angular.dev/essentials/signal-forms#3-bind-html-inputs-with-field-directive){:target="_blank"}, which connects the input to the Signal Form:

```html
<input
    id="username"
    type="text"
    [field]="form.username" />
```

Below that, we conditionally render validation errors only when the field has been touched and is invalid:

```html
@if (form.username().touched() && form.username().invalid()) {
    <ul class="error-list">
        @for (err of form.username().errors(); track $index) {
            <li>{% raw %}{{ err.message }}{% endraw %}</li>
        }
    </ul>
}
```

The email field follows the same pattern.

It uses the field directive to connect the input to the Signal Form:

```html
<input
    id="email"
    type="email"
    [field]="form.email" />
```

And it conditionally renders validation errors only when the field has been touched and is invalid:

```html
@if (form.email().touched() && form.email().invalid()) {
    <ul class="error-list">
        @for (err of form.email().errors(); track $index) {
            <li>{% raw %}{{ err.message }}{% endraw %}</li>
        }
    </ul>
}
```

At this point, the submit button is disabled because the form is invalid:

```html
<button type="submit" [disabled]="form.invalid()">
    Create account
</button>
```

Everything here works perfectly for client-side validation. 

We just don't have submission logic yet.

## How Signal Forms Are Built in TypeScript

Now let's look at [the component TypeScript](https://stackblitz.com/edit/stackblitz-starters-mtaw9y7j?file=src%2Fform%2Fform.component.ts){:target="_blank"}.

One of the first things we see is the `model` signal:

```typescript
protected readonly model = signal<SignupModel>({
    username: '',
    email: '',
});
```

This is the backing data for the form.

Next, we create the Signal-based form using the [form()](https://angular.dev/api/forms/signals/form){:target="_blank"} function and pass in the model:

```typescript
protected readonly form = form(this.model, s => {
    ...
});
```

Inside this function, we define our field-level validators:

```typescript
protected readonly form = form(this.model, s => {
		required(s.username, { message: 'Please enter a username' });
		minLength(s.username, 3,
        { message: 'Your username must be at least 3 characters' });
		required(s.email, { message: 'Please enter an email address' });
});
```

- Required validator on username
- Minimum length validator on username  
- Required validator on email

All of this is client-side validation. 

It's fast, synchronous, and runs before we ever attempt to submit anything.

## Simulating Server-Side Validation Errors

In a real application, form submission usually means calling a service.

For this demo, I've created [a mock signup service](https://stackblitz.com/edit/stackblitz-starters-mtaw9y7j?file=src%2Fform%2Fsignup.service.ts){:target="_blank"} that simulates a backend call:

```typescript
import { Injectable } from '@angular/core';

export interface SignupModel {
	username: string;
	email: string;
}

export type SignupResult =
  | { status: 'ok' }
  | {
      status: 'error';
      fieldErrors: Partial<Record<keyof SignupModel, string>>;
    };

@Injectable({ providedIn: 'root' })
export class SignupService {
  async signup(value: SignupModel): Promise<SignupResult> {
    await new Promise((r) => setTimeout(r, 700));
  
    const fieldErrors: Partial<Record<keyof SignupModel, string>> = {};
  
    // Username rules
    if (value.username.trim().toLowerCase() === 'brian') {
      fieldErrors.username = 'That username is already taken.';
    }
  
    // Email rules
    if (value.email.trim().toLowerCase() === 'brian@test.com') {
      fieldErrors.email = 'That email is already taken.';
    }
  
    if (Object.keys(fieldErrors).length > 0) {
      return { status: 'error', fieldErrors };
    }
  
    return { status: 'ok' };
  }  
}

```

This service returns either a successful result or an object containing field-specific server errors.

This distinction is important because server validation is very different from client validation:
- **Client validation** checks shape and format (required fields, email format, minimum length)
- **Server validation** enforces business rules (reserved usernames, blocked email domains, uniqueness checks)

Now it’s time to actually make this form submit. 

This is where things get interesting.

## Using submit() for Async Form Submission

Signal Forms provides a new `submit()` API that handles a lot of the hard stuff for us.

Back over in the component TypeScript, I'll start by injecting the signup service:

```typescript
import { inject } from '@angular/core';
import { ..., SignupService } from './signup.service';

export class SignupComponent {
    ...

    private readonly signupService = inject(SignupService);
}
```

Next, I'll add an `onSubmit` method:

```typescript
protected onSubmit(event: Event) {
}
```

The first thing we do is call `preventDefault()` on the event to prevent the browser from performing a full page refresh:

```typescript
protected onSubmit(event: Event) {
    event.preventDefault();
}
```

Then we use the new `submit()` function and pass in our form.

```typescript
import { ..., submit } from '@angular/forms/signals';

protected onSubmit(event: Event) {
    ...
    submit(this.form);
}
```

The second argument is an async callback:

```typescript
protected onSubmit(event: Event) {
    ...
    submit(this.form, async f => {
    });
}
```

What's really nice about this is that Angular will:
- Only call this callback if the form is valid
- Automatically mark all fields as touched
- Track submission state for us

Inside this callback, we get access to the form's field tree via `f`.

### Getting the Form Value

Let's create a variable to store the current value:

```typescript
submit(this.form, async f => {
    const value = f().value();
});
```

This gives us the current form value, already validated by client-side rules.

### Calling the Backend Service

Next, we pass that value into the signup service:

```typescript
submit(this.form, async f => {
    ...
    const result = await this.signupService.signup(value);
});
```

This simulates calling the backend.

### Handling Server Validation Errors

Now here's where the real power of `submit()` shows up.

If the server rejects the submission, we return validation errors instead of throwing errors or manually setting state:

```typescript
submit(this.form, async f => {
    ...
    if (result.status === 'error') {
        ...
    }
});
```

We'll create a variable to push errors into using the [ValidationError](https://angular.dev/api/forms/signals/ValidationError){:target="_blank"} interface:

```typescript
import { ..., ValidationError } from '@angular/forms/signals';

submit(this.form, async f => {
    ...
    if (result.status === 'error') {
        const errors: ValidationError.WithOptionalField[] = [];
    }
});
```

This interface represents a validation error that can optionally target a specific field.

Now let's add a condition to check if there are errors on the username field:

```typescript
submit(this.form, async f => {
    ...
    if (result.status === 'error') {
        ...
        if (result.fieldErrors.username) {
        }
    }
});
```

If so, we push an error object into the `errors` array with the following properties:
- The `field` reference (our username field)
- An error `kind` which is a unique category for these messages (we'll call it "server")
- The error `message` to display

```typescript
submit(this.form, async f => {
    ...
    if (result.status === 'error') {
        ...
        if (result.fieldErrors.username) {
            errors.push({
                field: f.username,
                kind: 'server',
                message: result.fieldErrors.username,
            });
        }
    }
});
```

Let's do the same for email:

```typescript
submit(this.form, async f => {
    ...
    if (result.status === 'error') {
        ...
        if (result.fieldErrors.email) {
            errors.push({
                field: f.email,
                kind: 'server',
                message: result.fieldErrors.email,
            });
        }
    }
});
```

### Returning Errors vs Success

Now comes the key decision point.

If we have errors we return them, if not we return `undefined`:

```typescript
submit(this.form, async f => {
    ...
    if (result.status === 'error') {
        ...
        return errors.length ? errors : undefined;
    }
});
```

Returning errors tells Angular: "Do not submit the form, surface these errors instead."

Returning `undefined` tells Angular: "Everything's good. The form submitted successfully."

## Connecting submit() to the Template

Now we need to wire up our new `onSubmit` method in the template.

The main thing we need to do is add the submit event handler to the form element:

```html
<form (submit)="onSubmit($event)">
    ...
</form>
```

This connects the native form submit to our custom handler.

At this point, we're good to go. 

Our form should submit properly.

But there are a few small adjustments we should make to the submit button to make it more useful to the end user.

### Enhancing the Submit Button with Loading State

For one, we should make the button disabled while the form is submitting to prevent multiple submissions while we communicate with the server.

With Signal Forms, this is easy. 

We just need to use the `submitting` property:

```html
<button 
    type="submit" 
    [disabled]="form.invalid() || form.submitting()">
    ...
</button>
```

Then let’s also use this to swap out the button label during this period as well:

```html
<button 
    type="submit" 
    [disabled]="form.invalid() || form.submitting()">
    ...
    @if (form.submitting()) {
        Creating...
    } @else {
        Create account
    }
</button>
```

Now the button will be disabled during submission and show "Creating..." instead of "Create account".

## End-to-End Demo: Client + Server Validation

Let's test the complete flow.

When we click into and blur the fields, the client validation still works:

<div>
<img src="{{ '/assets/img/content/uploads/2026/01-01/demo-7.jpg' | relative_url }}" alt="Client-side validation errors appearing on form fields" width="1218" height="1004" style="width: 100%; height: auto;">
</div>

Now let's enter values that pass client validation but fail server validation:

<div>
<img src="{{ '/assets/img/content/uploads/2026/01-01/demo-8.jpg' | relative_url }}" alt="Form with valid client-side values, ready to submit" width="1176" height="912" style="width: 100%; height: auto;">
</div>

The client errors disappear because the form is technically valid based on the required and minLength validators in our Signal Form. 

The button is now enabled, so let's try to submit the form.

Nice! The button is disabled and the label changes to "Creating..." while we communicate with the mock server:

<div>
<img src="{{ '/assets/img/content/uploads/2026/01-01/demo-9.jpg' | relative_url }}" alt="Form submitting with loading state, button disabled and showing Creating..." width="1148" height="368" style="width: 100%; height: auto;">
</div>

And there we go! Server validation errors appear in the same UI as client validation:

<div>
<img src="{{ '/assets/img/content/uploads/2026/01-01/demo-10.jpg' | relative_url }}" alt="Server validation errors displayed on form fields" width="1334" height="1024" style="width: 100%; height: auto;">
</div>

The form didn't submit successfully because we returned errors.

We can see this because there's nothing logged to the console after the form submission:

<div>
<img src="{{ '/assets/img/content/uploads/2026/01-01/demo-11.jpg' | relative_url }}" alt="Browser console showing no log output after form submission" width="1236" height="514" style="width: 100%; height: auto;">
</div>

With the `submit()` function, Angular internally knows when the form submits successfully. 

We don't need to do anything separate to handle it.

Let's add a valid username and email and try again:

<div>
<img src="{{ '/assets/img/content/uploads/2026/01-01/demo-12.jpg' | relative_url }}" alt="Form successfully submitted with valid data" width="1218" height="444" style="width: 100%; height: auto;">
</div>

Perfect! This time the form actually submitted the data.

## Complete Implementation Example

Here's the complete component code:

```typescript
import { ChangeDetectionStrategy, Component, inject, signal } from '@angular/core';
import { CommonModule } from '@angular/common';
import { Field, form, minLength, required, submit, ValidationError } from '@angular/forms/signals';
import { SignupModel, SignupService } from './signup.service';

@Component({
  selector: 'app-form',
  imports: [CommonModule, Field],
  templateUrl: './form.component.html',
  styleUrl: './form.component.scss',
  changeDetection: ChangeDetectionStrategy.OnPush,
})
export class FormComponent {
  protected readonly model = signal<SignupModel>({
    username: '',
    email: '',
  });

  protected readonly form = form(this.model, s => {
		required(s.username, { message: 'Please enter a username' });
		minLength(s.username, 3, 
			{ message: 'Your username must be at least 3 characters' });
		required(s.email, { message: 'Please enter an email address' });
  });

	private readonly signupService = inject(SignupService);

	protected onSubmit(event: Event) {
		event.preventDefault();
		
		submit(this.form, async f => {
			const value = f().value();
			const result = await this.signupService.signup(value);
	
			if (result.status === 'error') {
				const errors: ValidationError.WithOptionalField[] = [];
	
				if (result.fieldErrors.username) {
					errors.push({
						field: f.username,
						kind: 'server',
						message: result.fieldErrors.username,
					});
				}
	
				if (result.fieldErrors.email) {
					errors.push({
						field: f.email,
						kind: 'server',
						message: result.fieldErrors.email,
					});
				}
	
				return errors.length ? errors : undefined;
			}
	
			console.log('Submitted:', value);
			return undefined;
		});
	}
}
```

And the template:

```html
<div class="form-container">
  <h2>Sign up</h2>
  <form (submit)="onSubmit($event)">
    <div class="field">
      <label for="username">Username</label>
      <input
        id="username"
        type="text"
        [field]="form.username" />
      @if (form.username().touched() && form.username().invalid()) {
        <ul class="error-list">
          @for (err of form.username().errors(); track $index) {
            <li>{{ err.message }}</li>
          }
        </ul>
      }
    </div>

    <div class="field">
      <label for="email">Email</label>
      <input
        id="email"
        type="email"
        [field]="form.email" />
      @if (form.email().touched() && form.email().invalid()) {
        <ul class="error-list">
          @for (err of form.email().errors(); track $index) {
            <li>{{ err.message }}</li>
          }
        </ul>
      }
    </div>

    <div class="actions">
      <button type="submit" [disabled]="form.invalid() || form.submitting()"> 
        @if (form.submitting()) {
          Creating… 
        } @else { 
          Create account
        }
      </button>
    </div>
  </form>
</div>
```

## When to Use submit() in Signal Forms

This is why the new `submit()` API matters.

It gives you:
- **Async submission**: Handle backend calls naturally with async/await
- **Loading state**: Automatic `submitting()` signal tracks submission status
- **Automatic touched handling**: All fields marked as touched on submit attempt
- **Server error mapping**: Errors land exactly where users expect them
- **Validation gating**: Callback only executes if form is valid

It kind of "completes" the Signal Forms story.

If you're building real Angular apps for the future, this is going to be the pattern you want.

## Additional Resources
- [The demo BEFORE any changes](https://stackblitz.com/edit/stackblitz-starters-mtaw9y7j?file=src%2Fform%2Fform.component.ts){:target="_blank"}
- [The demo AFTER making changes](https://stackblitz.com/edit/stackblitz-starters-afwjuhay?file=src%2Fform%2Fform.component.ts){:target="_blank"}
- [Angular submit() documentation](https://angular.dev/api/forms/signals/submit){:target="_blank"}
- [Angular form submission example](https://angular.dev/tutorials/signal-forms/5-add-submission){:target="_blank"}
- [Angular Signal Forms documentation](https://angular.dev/essentials/signal-forms){:target="_blank"}
- [My course "Angular: Styling Applications"](https://www.pluralsight.com/courses/angular-styling-applications){:target="_blank"}
- [My course "Angular in Practice: Zoneless Change Detection"](https://app.pluralsight.com/library/courses/angular-practice-zoneless-change-detection){:target="_blank"}
- [Get a Pluralsight FREE TRIAL HERE!](https://www.jdoqocy.com/click-101557355-17135603){:target="_blank"}

## Try It Yourself

Want to experiment with `submit()`? The integration is straightforward once you understand how it works.

If you have any questions or spot improvements to this approach, please leave a comment.

<iframe src="https://stackblitz.com/edit/stackblitz-starters-afwjuhay?ctl=1&embed=1&file=src%2Fform%2Fform.component.ts" style="height: 500px; width: 100%; margin-bottom: 1.5em; display: block;"></iframe>

