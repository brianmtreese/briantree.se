---
layout: post
title: "\"Reactive Forms Are Just as Good.\" Okay, Watch This."
date: "2025-11-06"
video_id: "JL0QWZokLz8"
tags: 
  - "Angular"
  - "Signal Forms"
  - "Reactive Forms"
  - "Forms"
---

<p class="intro"><span class="dropcap">I</span>'ve made a few tutorials on Signal Forms now, and I've seen the comments. Some of you said the old Reactive Forms way is just as good — or you just still like it better. And I get it. Maybe the benefit hasn't been obvious. So today, I'm going to show you a real-world form — the kind that gets messy fast — and we're going to rebuild it using Signal Forms. By the end of this post, hopefully you'll see the advantage, not just hear me say it.</p>

{% include youtube-embed.html %}

## What This Form Needs to Do

Let me show you what this form does before we look at any code.

When I switch this account type to Business, we automatically get a Company Name field added. This is what we call conditional form structure. Super common, but can get super messy.

Then we have this password field. Now check out the password strength meter — the stronger the password becomes, the more this fills.

The form also knows when it should not submit. We can't submit yet because it's still not in a valid state.

Let's add a company name.

And now when we type in an email, if it's not valid, we get an error message.

Then, once it's valid, the error message goes away, our form is now valid, and the button activates.

So this is a pretty dynamic form. And it works well.

But the way we currently have this built uses Reactive Forms, and to get all of this behavior working… the code gets a little wild.

## How This Was Built With Reactive Forms

Let's take a look at what it takes to make all of that actually work.

First, let's open our form component TypeScript.

Here we're importing the Reactive Forms module and injecting the Non Nullable Form Builder:

```typescript
import { Component, OnInit, OnDestroy } from '@angular/core';
import { NonNullableFormBuilder, Validators, ReactiveFormsModule } from '@angular/forms';
import { Subject, takeUntil } from 'rxjs';

@Component({
  selector: 'app-account-form',
  standalone: true,
  imports: [ReactiveFormsModule],
  templateUrl: './account-form.component.html'
})
export class AccountFormComponent implements OnInit, OnDestroy {
  private destroy$ = new Subject<void>();
  
  constructor(private fb: NonNullableFormBuilder) {}
```

Then we have a set of variables used to track various states in this component:

```typescript
isBusiness = false;
passwordStrength = 0;
canSubmit = false;
```

And then, below this, we have our form structure created as a form group using the form builder:

```typescript
form = this.fb.group({
  accountType: ['', Validators.required],
  companyName: [''],
  email: ['', [Validators.required, Validators.email]],
  password: ['', [Validators.required, Validators.minLength(8)]]
});
```

We have a control for the account type that's required.

We have a control for the company name that's not required initially.

We have a control for the email that is both required and then uses an email validator to check for the proper format.

Then we have a password control that is required and then has a min length validator as well requiring it to be at least 8 characters long.

So that's how we initialize our form, but after this is where things get spicy.

In order to pull off all of the custom logic that this form has, we now have several observable subscriptions for different aspects of this form.

First, we listen to changes in the account type to decide whether the Company Name should be required, and if not, we clear validators, reset the value, and remember to call update value and validity so the form knows about it:

```typescript
this.form.get('accountType')?.valueChanges.subscribe(value => {
  const companyNameControl = this.form.get('companyName');
  if (value === 'business') {
    companyNameControl?.setValidators(Validators.required);
    this.isBusiness = true;
  } else {
    companyNameControl?.clearValidators();
    companyNameControl?.reset();
    this.isBusiness = false;
  }
  companyNameControl?.updateValueAndValidity();
});
```

Then we subscribe again to compute password strength and update whether the form can submit:

```typescript
this.form.get('password')?.valueChanges.subscribe(() => {
  this.passwordStrength = this.scorePassword(this.form.get('password')?.value || '');
  this.updateCanSubmit();
});
```

And then another subscription to track the overall form validity:

```typescript
this.form.statusChanges.subscribe(() => {
  this.updateCanSubmit();
});
```

At this point, we are no longer just using the form — we're babysitting it. We're keeping all of this state in sync manually.

Then we have a couple of helper methods: one to determine if we can submit, then another to check the strength of the password:

```typescript
updateCanSubmit() {
  this.canSubmit = this.form.valid && this.passwordStrength >= 3;
}

scorePassword(password: string): number {
  // Password strength scoring logic
  let score = 0;
  if (password.length >= 8) score++;
  if (/[a-z]/.test(password) && /[A-Z]/.test(password)) score++;
  if (/\d/.test(password)) score++;
  if (/[^a-zA-Z\d]/.test(password)) score++;
  return score;
}
```

And finally, we have our empty submit function that we're not currently doing anything with.

Okay, so that's the TypeScript. Now let's look at the template.

## The Reactive Forms Template Setup

To start, here at the top, we're wiring up our form with the Form Group directive on the form element that wraps all of our fields:

```html
<form [formGroup]="form">
```

Then, to wire up our form controls, we're using the form Control Name directive and then the name of the control within the form group:

```html
<select formControlName="accountType">
  <option value="personal">Personal</option>
  <option value="business">Business</option>
</select>
```

Then here we can see that we have a condition for when we do have a business account which controls the visibility of the company name field:

```html
@if (isBusiness) {
  <input formControlName="companyName" placeholder="Company Name" />
}
```

Below this we have the email field where we also have a condition based on the touched and invalid status of the control that determines whether to show the email validation message:

```html
<input formControlName="email" type="email" placeholder="Email" />
@if (form.get('email')?.touched && form.get('email')?.invalid) {
  <span class="error">Please enter a valid email address</span>
}
```

Then we have our password field where we also have our password strength meter:

```html
<input formControlName="password" type="password" placeholder="Password" />
<div class="strength-meter">
  <div class="strength-bar" [style.width.%]="(passwordStrength / 4) * 100"></div>
</div>
```

And below all of this we have our submit button, which is disabled when our "can submit" property is false:

```html
<button [disabled]="!canSubmit">Create Account</button>
```

This is all fine and dandy. It all works, and has worked well in the past.

The complicated part isn't here in the template… it's everything we had to write to support it.

Let's redo this using Signal Forms — and watch how much of this code disappears.

## What Signal Forms Is (and Isn't)

[Signal Forms](https://angular.dev/guide/forms/signal-forms) is a new experimental forms API in Angular that models forms using Signals instead of FormGroups and FormControls.

It's not production-ready yet — so don't go replacing your company's checkout flow tomorrow — but it's far enough along to understand the direction Angular is heading.

And the direction is: Less wiring. Less bookkeeping. More direct state.

Let's convert this.

## Rewriting the Form Using Signal Forms

Let's switch back over to our TypeScript.

Let's start by removing this Form Builder and Destroy Ref. We won't need these anymore.

We can also remove the entire form group now too.

And along with this, we can remove all of the observable subscriptions, and even the On Init method.

This means we can also remove the On Init interface, and we can also remove the reactive forms module import.

And then we can remove all unused imports from the top now as well.

Now we need to add the Signal Forms imports:

```typescript
import { signal, computed } from '@angular/core';
import { form, field, required, email, minLength, applyWhenValue } from '@angular/forms';
import { FieldDirective } from '@angular/forms';
```

Okay, that's all we're going to remove. Now the first thing we need to do is update our account form interface.

Instead of form controls, these will just be the account type for the account type control and strings for everything else:

```typescript
interface AccountForm {
  accountType: 'personal' | 'business';
  companyName: string;
  email: string;
  password: string;
}
```

## Defining the Form Model as a Signal

Now with reactive forms, we use the Form Builder and groups and controls, but with signal forms we use a signal to track the form state. So let's create a new signal called form model and type it with our account form interface:

```typescript
formModel = signal<AccountForm>({
  accountType: 'personal',
  companyName: '',
  email: '',
  password: ''
});
```

Okay, then we can initialize each of the properties in this object. So for our account type we'll make it "personal", and then for all other fields we'll initialize them as an empty string.

## Creating the Signal-Based Form Structure

Ok, so that's the signal to store our form state. Now, in order to make this into a form when using Signal Forms, we need to create another property where we use the new [form()](https://angular.dev/api/forms/form) function to wrap this form state signal:

```typescript
form = form({
  accountType: field(this.formModel().accountType, { validators: [required()] }),
  companyName: field(this.formModel().companyName, {
    validators: [
      applyWhenValue(
        () => this.form.accountType.value() === 'business',
        [required()]
      )
    ]
  }),
  email: field(this.formModel().email, { validators: [required(), email()] }),
  password: field(this.formModel().password, { validators: [required(), minLength(8)] })
});
```

This function creates what's known as a field tree, but uses our signal as the source of truth for the values of our form.

To add validation, we need to pass in some options.

First, we'll use the new [required()](https://angular.dev/api/forms/required) method to make our account type field required.

Then we'll use the required method again to make our email field required.

Next, we'll use the new [email()](https://angular.dev/api/forms/email) function to make sure our email is in the proper format.

Then we'll use the required method again to make our password field required.

Then we'll use the [minLength()](https://angular.dev/api/forms/minLength) function on our password field to set the min length to eight characters again.

OK, the last thing we need to do in our form is make the company name required when our account type equals 'business'.

With reactive forms, we used to listen to the value change of the account type control and then add or remove the validators and update the validation state.

Well, this gets more simplistic with signal forms. We can use the ["apply-when-value"](https://angular.dev/api/forms/applyWhenValue) method to conditionally apply validation to our company name control. This is already included in the form definition above.

This one function here replaces the entire account type subscription from earlier.

No updating validators. No resetting. Just describe the rule once.

Okay, so that's our form. Now we need to update the rest of these properties as well.

## Deriving UI State with Computed Signals

We'll switch the "is business" property to a computed signal where we can use the "account type" control value since it's a signal to check if it's value is "business":

```typescript
isBusiness = computed(() => this.form.accountType.value() === 'business');
```

This property now derives itself. We never set it manually.

This is one of the main benefits of using signal forms. They are now signals. So we can do things like use computed signals, or linked signals, or even effects if we need to along with form controls.

Okay, now for our passwordStrength field, we will also convert this to a computed signal:

```typescript
passwordStrength = computed(() => {
  const password = this.form.password.value();
  let score = 0;
  if (password.length >= 8) score++;
  if (/[a-z]/.test(password) && /[A-Z]/.test(password)) score++;
  if (/\d/.test(password)) score++;
  if (/[^a-zA-Z\d]/.test(password)) score++;
  return score;
});
```

And here we will actually copy the guts of the "score" method and then we can remove that method.

Instead, we'll use this in our computed signal, but we'll use the password control value as a signal now.

Okay, now we will update the "can submit" property to also be a computed signal:

```typescript
canSubmit = computed(() => 
  this.form.valid() && this.passwordStrength() >= 3
);
```

This signal will update based on our form signal validity and also whether the password strength value is greater than or equal to 3.

OK, now we can remove the old "update Can Submit" method, since it's not needed anymore.

Now the last thing we need to do here is we're going to use the new [field()](https://angular.dev/api/forms/field) directive from the signal forms API in the template. So we need to add this to our component imports array:

```typescript
@Component({
  selector: 'app-account-form',
  standalone: true,
  imports: [FieldDirective],
  templateUrl: './account-form.component.html'
})
export class AccountFormComponent {
  // ... form code here
}
```

OK, that should be everything we need here.

I'm hoping if you didn't see the overall benefit and gains before that you see them clearly now.

This is quite a bit less code than it was before and it integrates seamlessly with Angular's new reactivity model, signals.

Okay, now it's time to switch over and update the template.

## Updating the Template to Use the Field Directive

Now the changes here will not be near as significant as they were in the TypeScript, but we'll go through them step by step.

First up, we can remove the form group directive that was bound to our old form property:

```html
<!-- Remove: [formGroup]="form" -->
<form>
```

Now on every input that uses the old formControlName directive, we need to update these to all use the new field directive and then access the control off of our new form property:

```html
<select [field]="form.accountType">
  <option value="personal">Personal</option>
  <option value="business">Business</option>
</select>
```

Okay, now we need to update the "is business" condition to use the signal:

```html
@if (isBusiness()) {
  <input [field]="form.companyName" placeholder="Company Name" />
}
```

We also need to update the email validation message logic to use signals now too:

```html
<input [field]="form.email" type="email" placeholder="Email" />
@if (form.email.touched() && form.email.invalid()) {
  <span class="error">Please enter a valid email address</span>
}
```

And we also need to update the password field to use the field directive:

```html
<input [field]="form.password" type="password" placeholder="Password" />
```

And then we need to switch the password strength property to a signal too:

```html
<div class="strength-meter">
  <div class="strength-bar" [style.width.%]="(passwordStrength() / 4) * 100"></div>
</div>
```

Then all we need to do is update the disabled binding on our submit button:

```html
<button [disabled]="!canSubmit()">Create Account</button>
```

So the situation here in the template is not really all that different. It's not like a great reduction of code or anything. It's just converted over to signals and the new syntax.

Overall, not much of a change here, but this is how you do it with Signal Forms.

## Side-by-Side Behavior Check (Reactive vs Signal)

Okay, this should be everything we need to change, so let's go ahead and save and try this out. And what we should see is the Same UI. Same behavior. Just, using signals now.

Alright, let's click to switch the type, nice, this still works. It now shows the company name field just like it should.

All right, let's try the password. And that still works too, great!

And we can see that the create account button is still disabled.

Let's add a company name.

Then, let's try our email validation. Nice, that still works!

And then, once it's valid, the form becomes valid, and the button is enabled!

So the code went from: "Listen… check… update… sync… track… remember…" to "Describe the state. The UI follows it."

## Why This Matters (The Real Benefit)

So the form didn't change — the work did.

With Reactive Forms, we had to wire everything together: subscribe here, toggle validators there, track UI state manually.

With Signal Forms, we just describe the state once, and the UI follows automatically.

Same behavior. Less code. Clearer logic.

And as your forms get more complex, that benefit only gets bigger.

## In Conclusion

Signal Forms represents a significant shift in how we think about forms in Angular. Instead of managing subscriptions and manually syncing state, we describe the form's behavior declaratively, and Angular's reactivity system handles the rest.

The benefits become even more apparent as forms grow in complexity. Less boilerplate, clearer intent, and seamless integration with Angular's signal-based reactivity model make Signal Forms the future of form handling in Angular.

While it's still experimental, it's worth exploring now to understand where Angular is heading. The patterns you learn today will serve you well as the API matures.

## Additional Resources

* [The demo app BEFORE any changes (Reactive Forms)](https://stackblitz.com/edit/stackblitz-starters-zfhhuenu)
* [The demo app AFTER making changes (Signal Forms)](https://stackblitz.com/edit/stackblitz-starters-gx4z9aho)
* [Signal Forms documentation](https://angular.dev/guide/forms/signal-forms)
* [Angular Forms API reference](https://angular.dev/api/forms)
* [Angular Signals documentation](https://angular.dev/guide/signals)
