---
layout: post
title: "Angular Forms: Validation Made Simple"
date: "2024-12-27"
video_id: "iTjafzvkoV4"
tags:
  - "Angular"
  - "Angular Components"
  - "Angular Form Control"
  - "Angular Forms"
  - "Angular Styles"
  - "Forms"
  - "JavaScript"
  - "Reactive Forms"
  - "TypeScript"
---

<p class="intro"><span class="dropcap">H</span>ello, and welcome to this Angular tutorial! Today, we’re diving into one of the most essential topics for forms: validation and error messages. We'll take a basic form and provide several validation messages to help guide users. Plus, we'll level up with additional checks like email validation and even visual feedback for the form's status as a whole.</p>

{% include youtube-embed.html %}

## Adding a Simple Required Field Validator

Ok, the form that we’ll be using in this tutorial looks like this:

<div>
<img src="{{ '/assets/img/content/uploads/2024/12-27/demo-1.png' | relative_url }}" alt="Example of a simple sign-up form component in Angular" width="770" height="699" style="width: 100%; height: auto;">
</div> 

Right now, neither the "name" or "email" fields are required, but we want to make them both required before the user can successfully submit the form.

Also, we want to add validation messages to provide visual feedback when these fields are invalid so that users know what they need to do in order to complete the form.

So, how we do we do this?

Let’s start by taking a look at our [form.component.ts](https://stackblitz.com/edit/stackblitz-starters-x3bggjps?file=src%2Fform%2Fform.component.ts), where the code for this form exists.

Here, we have a form that’s created using a [FormGroup](https://angular.dev/api/forms/FormGroup) from the [Angular forms module](https://angular.dev/api/forms/FormsModule):

```typescript
import { ..., FormGroup } from '@angular/forms';

protected form = new FormGroup<SignUpForm>({
    ...
});
```

Inside of this [FormGroup](https://angular.dev/api/forms/FormGroup) we have our two controls, one for the "name" field, and another for the "email" address:

```typescript
name: new FormControl<string>('', {
    nonNullable: true
}),
email: new FormControl<string>('', {
    nonNullable: true
})
```

These controls are created using [FormControls](https://angular.dev/api/forms/AbstractControl), also from the [forms module](https://angular.dev/api/forms/FormsModule).

This [FormGroup](https://angular.dev/api/forms/FormGroup) and these [FormControls](https://angular.dev/api/forms/AbstractControl) allow us to programmatically interact with and monitor the state of our form and its controls.

Now, let’s look at [the template](https://stackblitz.com/edit/stackblitz-starters-x3bggjps?file=src%2Fform%2Fform.component.html) so we can understand how this all is used.

To wire up our [FormGroup](https://angular.dev/api/forms/FormGroup), we use the [formGroup](https://angular.dev/api/forms/FormGroupDirective) directive, and we pass it our "form" variable:

```html
<div [formGroup]="form">
    ...
</div>
```

Then, nested within this group we provide our [inputs](https://developer.mozilla.org/en-US/docs/Web/HTML/Element/input) where we use the [formControlName](https://angular.dev/api/forms/formControlName) directive:

```html
<div [formGroup]="form">
    <label>
        <strong>Name</strong>
        <input type="text" formControlName="name" />
    </label>
    <label>
        <strong>Email Address</strong>
        <input type="email" formControlName="email" />
    </label>
    ...
</div>
```

That’s all it takes to make this an Angular form.

Ok, now let’s add some validation.

First let’s make our “name” field required.

For this, we add a "validators" property in the options for this [FormControl](https://angular.dev/api/forms/AbstractControl).

Then, we can use the [Validators](https://angular.dev/api/forms/Validators) class, also from the [forms module](https://angular.dev/api/forms/FormsModule).

From this class, we can use the “[required](https://angular.dev/api/forms/Validators#required)” property:

```typescript
import { ..., Validators } from '@angular/forms';

name: new FormControl<string>('', {
    nonNullable: true
})
```

Ok that’s it, this field is now required far as Angular is concerned.

Now, we can use this "[required](https://angular.dev/api/forms/Validators#required)" status to provide some validation in the template.

Let’s start by adding a div with an “error” class.

```html
<div class="error">
    Your name is required!
</div>
```

This class provides basic styles for our error messages.

Ok, now comes the cool part.

By default, this “error” class starts out hidden, but we can provide a “visible” class when we want to show it.

We'll bind this class when the "name" field is invalid.

We can access the invalid state using our [form group](https://angular.dev/api/forms/FormGroup), then accessing its “[controls](https://angular.dev/api/forms/FormGroup#controls)” object, and then our “name” control where we can access the “invalid” status of this control:

```html
<div
    class="error" 
    [class.visible]="form.controls.name.invalid">
    ...
</div>
```

Ok, let’s save and check this out now:

<div>
<img src="{{ '/assets/img/content/uploads/2024/12-27/demo-2.gif' | relative_url }}" alt="Example of a validation message showing and hiding based on the validity of an Angular form control" width="896" height="804" style="width: 100%; height: auto;">
</div> 

Ok, well it looks like it’s working.

Since this field is required, when no value has been added, it’s invalid so we see the message right out of the gate.

Then, as soon as we add content, it’s no longer invalid so the message is hidden.

Now, that’s cool, but we probably don’t want to show it when the user hasn’t even interacted with it yet, right?

Well, we can fix this pretty easily.

### Providing a Validation Message Only After the Control Has Been Interacted With

With [Angular forms](https://angular.dev/guide/forms/reactive-forms), we have access to a “touched” state.

The control will be in this state once a user has interacted with the control and then blurred it.

So, we want to add this check to our condition:

```html
<div 
    class="error" 
    [class.visible]="form.controls.name.invalid && form.controls.name.touched">
    Your name is required!
</div>
```

Also, while we’re doing this, I don’t like that we have to repeat “form.controls.name” for each of these conditions.

So, I’m going to add a template variable with a [@let](https://youtu.be/DYDzf2JOOho) block for this which will allow us to  shorten these to just “name” instead:

```html
@let name = form.controls.name;
<div
    class="error"
    [class.visible]="name.invalid && name.touched">
    ...
</div>
```

Ok, let’s save and try this again:

<div>
<img src="{{ '/assets/img/content/uploads/2024/12-27/demo-3.gif' | relative_url }}" alt="Example of a validation message showing and hiding based on the validity and touched status of an Angular form control" width="770" height="690" style="width: 100%; height: auto;">
</div> 

Ok, that’s better, now we’re not seeing it initially.

Then, if we interact with it and blur, the message displays.

Then, if we enter content, the message hides again.

## Adding a Multiple Validators to a Single Control

Now, the email field is a little different.

Not only does it need to be required, but it also needs to validate that the value is a properly formatted email address.

Well, this is pretty easy too.

Let’s start by adding the “validators” property to this control, but this time, we’re going to make it an array.

The first validator we need will be the [required](https://angular.dev/api/forms/Validators#required) validator.

Then, the [Validators](https://angular.dev/api/forms/Validators) class also provides an [email validator](https://angular.dev/api/forms/Validators#email), which is cool because this means we don’t need to create it from scratch right?

```typescript
import { ..., Validators } from '@angular/forms';

email: new FormControl<string>('', {
    nonNullable: true, 
    validators: [
        Validators.required,
        Validators.email
    ]
})
```

Ok, so that’s how you add multiple validation checks on a single Angular [FormControl](https://angular.dev/api/forms/AbstractControl).

Now, let’s add some messages in the template.

First, let’s add a [template variable](https://youtu.be/DYDzf2JOOho) for this field like we did for the "name" field:

```html
@let email = form.controls.email;
```

Now, let’s add an “error” div again.

This message is a little more complicated than the "name" field since we need to show the "[required](https://angular.dev/api/forms/Validators#required)" message when the user has only interacted and blurred the field, and then we need to show a the "[email](https://angular.dev/api/forms/Validators#email)" message when they’ve added some content, but it’s not in the correct email format.

So, let’s add an [@if](https://angular.dev/guide/templates/control-flow#conditionally-display-content-with-if-else-if-and-else) condition using our “email” variable to call a “[hasError()](https://angular.dev/api/forms/AbstractControl#hasError)” function that we’ll pass the error we want to check against, in this case we’ll check if it’s “required”.

When it is required, we’ll display: “Your email is required!, when it's not, we’ll display: “Please enter a valid email address!”:

```html
<div class="error">
    @if (email.hasError('required')) {
        Your email is required!
    } @else {
        Please enter a valid email address!
    }
</div>
```

So those are the messages that we want to show, now let’s control when we show them.

Let’s bind the “visible” class again, checking for the “invalid” and “touched” statuses of the control:

```html
<div
    class="error"
    [class.visible]="email.invalid && email.touched">
    ...
</div>
```

Ok, let’s save and try this now:

<div>
<img src="{{ '/assets/img/content/uploads/2024/12-27/demo-4.gif' | relative_url }}" alt="Example of an email validation message showing and hiding based on the validity and touched status of an Angular form control" width="772" height="688" style="width: 100%; height: auto;">
</div>

Ok, it’s properly hidden to start.

Then we can trigger the required message.

Then, when we have an invalid email, it displays the invalid email message.

And then, if we make it a valid format, the message is hidden.

Pretty cool stuff right?

And there’s still more!

A lot more actually, but I’m going to point out one more cool thing here.

## Adding Validation Based on the Overall Form Group Status

Let’s say we want to make it a little more apparent when the form is invalid.

Let’s change this border around the form to red when the overall [FormGroup](https://angular.dev/api/forms/FormGroup) is invalid:

<div>
<img src="{{ '/assets/img/content/uploads/2024/12-27/demo-5.png' | relative_url }}" alt="Pointing out the border that goes around the sign-up form" width="768" height="513" style="width: 100%; height: auto;">
</div>

Well, just like with the individual form controls themselves, we can monitor the overall form validity and touched status.

We have an “invalid” class that we can bind to this container.

This class will make the border red.

Then, we can access the “invalid” state directly on the [FormGroup](https://angular.dev/api/forms/FormGroup) itself.

Likewise, we can do the same with the “touched” state:

```html
<article [class.invalid]="form.invalid && form.touched">
    ...
</article>
```

That’s it, let’s save and see it in action:

<div>
<img src="{{ '/assets/img/content/uploads/2024/12-27/demo-6.gif' | relative_url }}" alt="Example of binding a class on an HTML element based on the validity and touched status of an Angular form group" width="772" height="688" style="width: 100%; height: auto;">
</div>

Ok, everything looks normal to start right?

But now once we trigger an error, this border turns red.

Pretty cool stuff right?

{% include banner-ad.html %}

## In Conclusion

Ok now you’ve learned how to add required validation, dynamic error messages, and even group-level visual feedback to your forms.

With these techniques, you can build forms that are not only functional but also user-friendly and intuitive. 

Keep experimenting and applying these concepts to make your Angular forms stand out.

Don't forget to check out [my other Angular tutorials](https://www.youtube.com/@briantreese) for more tips and tricks.

## Additional Resources
* [The demo BEFORE making changes](https://stackblitz.com/edit/stackblitz-starters-x3bggjps?file=src%2Fform%2Fform.component.ts)
* [The demo AFTER making changes](https://stackblitz.com/edit/stackblitz-starters-pup72cav?file=src%2Fform%2Fform.component.ts)
* [Angular forms documentation](https://angular.dev/guide/forms)
* [Angular form validation documentation](https://angular.dev/guide/forms/form-validation)

## Want to See It in Action?
Check out the demo code and examples of these techniques in the Stackblitz example below. If you have any questions or thoughts, don’t hesitate to leave a comment.

<iframe src="https://stackblitz.com/edit/stackblitz-starters-pup72cav?ctl=1&embed=1&file=src%2Fform%2Fform.component.html" style="height: 500px; width: 100%; margin-bottom: 1.5em; display: block;"></iframe>
