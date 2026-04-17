---
layout: post
title: "Better Numeric Inputs in Angular (Signal Forms + Angular 22)"
date: 2026-04-16
video_id: oHC9CiZTnFk
tags: [Angular, Angular Forms, Angular Signals, Signal Forms, TypeScript]
---

<p class="intro"><span class="dropcap">S</span>ignal Forms just fixed a subtle, but important, issue you’ve likely shipped without realizing. If you’re using <code>&lt;input type="number"&gt;</code>, it's likely that you're introducing UX issues that only show up during real interaction. In this example, I'll show you a better approach that will be available in Angular v22.</p>

{% include youtube-embed.html %}

## Why Number Inputs Break UX in Angular Forms 

Let's start with a typical setup.

We have a typed form model where age is a number and can be null:

```typescript
interface SignupFormData {
  username: string;
  email: string;
  age: number | null;
}
```

Then we have a signal-backed model to store the form data where the age field is initialized to null:

```typescript
protected model = signal<SignupFormData>({
  username: '',
  email: '',
  age: null,
});
```

After this, we have the form configuration created with the [form()](https://angular.dev/api/forms/signals/form?utm_campaign=deveco_gdemembers&utm_source=deveco){:target="_blank"} function from the Signal Forms API and our model signal:

```typescript
protected signupForm = form(this.model, s => {
  required(s.username, { message: 'Username is required' });
  required(s.email, { message: 'Email is required' });
  required(s.age, { message: 'Age is required' });
});
```

This form is already setup with basic [required()](https://angular.dev/api/forms/signals/required?utm_campaign=deveco_gdemembers&utm_source=deveco){:target="_blank"} validators for the username, email, and age fields.

So this is what we're starting with. 

Now let's finish adding the logic for the age field.

First, we want to prevent folks from joining if they're under 18, so let's add a [min()](https://angular.dev/api/forms/signals/min?utm_campaign=deveco_gdemembers&utm_source=deveco){:target="_blank"} validator.

```typescript
min(s.age, 18, { message: 'You must be at least 18' });
```

Then, we want to ensure the age entered is valid.

If it's greater than 120, it's probably not valid, so let's add a [max()](https://angular.dev/api/forms/signals/max?utm_campaign=deveco_gdemembers&utm_source=deveco){:target="_blank"} validator:

```typescript
max(s.age, 120, { message: 'Please enter a valid age' });
```

That’s all we need here. 

Now let’s switch over to [the template](https://github.com/brianmtreese/angular-signal-forms-number-inputs/blob/main/src/form/form.component.html){:target="_blank"} and add the field itself.

Since age will always be a number, we should use a number input, right?

Let's try it!

We'll add a number type input and bind it to the age field using the [formField](https://angular.dev/api/forms/signals/formField?utm_campaign=deveco_gdemembers&utm_source=deveco){:target="_blank"} directive.

```html
<input 
  type="number" 
  [formField]="signupForm.age" />
```

Now, this probably looks correct, but it really isn’t.

This is one of those cases where the default looks right but causes subtle issues in real use.

For one, the browser will automatically add a spinner control to the input:

<div><img src="{{ '/assets/img/content/uploads/2026/04-16/number-input-spinner.jpg' | relative_url }}" alt="The number input with a spinner control" width="1090" height="390" style="width: 100%; height: auto;"></div>

These are rarely useful except in cases where you actually have an incremental number.

Which maybe you could argue we have here, but who wants to enter their age this way?

Also, if you use your mousewheel over the input, it will change the value too.

<div><img src="{{ '/assets/img/content/uploads/2026/04-16/number-input-mousewheel.gif' | relative_url }}" alt="The number input with a mousewheel" width="1124" height="384" style="width: 100%; height: auto;"></div>

In our case this isn't too bad but think of something like a postal code or credit card CVV number.

It just wouldn't make sense.

And this isn't just something I'm making up, [MDN explicitly recommends avoiding number inputs in many cases](https://developer.mozilla.org/en-US/docs/Web/HTML/Reference/Elements/input/number#using_number_inputs){:target="_blank"}.

So, let's switch over to the recommended approach.

## Step 1: Switch to a Text Input

For this, all we need to do is replace this:

```html
<input 
  type="number" 
  [formField]="signupForm.age" />
```

With this:

```html
<input 
  type="text" 
  inputmode="numeric" 
  [formField]="signupForm.age" />
```

This removes browser-controlled behavior while still triggering the numeric keyboard on mobile thanks to the [inputmode attribute](https://developer.mozilla.org/en-US/docs/Web/HTML/Global_attributes/inputmode){:target="_blank"}.

At this point (pre-Angular 22), this breaks typing:

<div><img src="{{ '/assets/img/content/uploads/2026/04-16/number-input-typing.jpg' | relative_url }}" alt="The number input with a typing issue" width="1542" height="528" style="width: 100%; height: auto;"></div>

## Step 2: Angular 22 Fix: Number ↔ Text Binding

Previously, with Signal Forms:
- Text input → `string`  
- Model expects → `number | null`  
- Result → type mismatch  

Angular 22 fixes this.

After upgrading, Signal Forms:
- Accept text inputs for numeric fields  
- Convert values to `number`  
- Map empty input to `null` (not `''`)  

This is the key improvement.

## Step 3: Keep Validation in the Schema

If we want to strictly adhere to the MDN guidance we would add attributes like these:

```html
<input 
  pattern="[0-9]*" 
  min="18" 
  max="120" />
```

But these aren’t needed here.

With Signal Forms:
- Validation belongs in the schema  
- Template stays declarative  

So we'll keep the validation where we have it, and we'll remove these attributes.

## Step 4: Restrict Input via Keyboard Handling

According to MDN, browsers are inconsistent at enforcing numeric input, even with the correct `inputmode`.

So we need to enforce it ourselves.

To do this, we'll add a (keydown) event handler to the input.

We'll call it onAgeKeydown and it will take a KeyboardEvent parameter.

```html
<input
  type="text"
  inputmode="numeric"
  [formField]="signupForm.age"
  (keydown)="onAgeKeydown($event)"
/>
```

Then, we'll switch over to [the component TypeScript](https://github.com/brianmtreese/angular-signal-forms-number-inputs/blob/main/src/form/form.component.ts){:target="_blank"} and add this new method:

```ts
protected onAgeKeydown(event: KeyboardEvent) {
  const allowedKeys = [
    'Backspace',
    'Delete',
    'Tab',
    'Escape',
    'Enter',
    'ArrowLeft',
    'ArrowRight'
  ];

  if (allowedKeys.includes(event.key)) {
    return;
  }

  if (!/^\d$/.test(event.key)) {
    event.preventDefault();
  }
}
```

This ensures:
- Only digits are entered  
- Navigation keys still work  

## The Final Result

So now, we no longer have the spinner UI or scroll-wheel side effects:

<div><img src="{{ '/assets/img/content/uploads/2026/04-16/number-input-final-result.jpg' | relative_url }}" alt="The number input with the final result" width="1030" height="382" style="width: 100%; height: auto;"></div>

We still can't add any non-numeric characters.

If we add invalid age values, we'll get the validation errors we added earlier:

<div><img src="{{ '/assets/img/content/uploads/2026/04-16/number-input-validation-errors.jpg' | relative_url }}" alt="The number input with validation errors" width="1010" height="408" style="width: 100%; height: auto;"></div>

Then, when we clear the field, we'll get the correct null value:

<div><img src="{{ '/assets/img/content/uploads/2026/04-16/number-input-clear-field.jpg' | relative_url }}" alt="The number input with the clear field" width="1136" height="770" style="width: 100%; height: auto;"></div> 

Previously, a text field would give you an empty string, but Angular now handles the conversion to `null` for us perfectly!

## Clean, Typed Numeric Input in Angular 22

`<input type="number">` looks correct but introduces avoidable UX issues.

Angular 22 removes the main blocker:
- You can bind numeric models to text inputs cleanly  
- You retain strict typing and schema validation  

For real applications, this is the better default (in many cases):
- `type="text"`  
- `inputmode="numeric"`  
- Schema validation  
- Explicit keyboard handling  

It’s a small change that eliminates a class of subtle UX bugs that often slip through reviews.

## Taking This Further with Signal Forms

This example is just one piece of what Signal Forms are starting to simplify.

If you want to go deeper, I put together a full course that walks through building real-world forms step by step.

You can access it either directly or through YouTube membership, depending on what works best for you:

👉 [Buy the course](https://www.udemy.com/course/angular-signal-forms/?couponCode=021409EC66FC6440B867){:target="_blank"}<br />
👉 [Get it with YouTube membership](https://www.youtube.com/channel/UCdPhLDznZzUeEtshDUe0R_A/join){:target="_blank"}

<div class="youtube-embed-wrapper">
	<iframe 
		width="1280" 
		height="720"
		src="https://www.youtube.com/embed/fZZ1UVkyB4I?rel=1&modestbranding=1" 
		frameborder="0" 
		allow="accelerometer; autoplay; clipboard-write; encrypted-media; gyroscope; picture-in-picture; web-share" 
		allowfullscreen
		loading="lazy"
		title="Angular 22: Mix Signal Forms and Reactive Forms Seamlessly"
	></iframe>
</div>

## Additional Resources
- [The source code for this example](https://github.com/brianmtreese/angular-signal-forms-number-inputs){:target="_blank"}
- [The commit that makes this all possible](https://github.com/angular/angular/commit/41b1410cb8a333a2ce6569483cd10866effc154d#diff-274ce409fbc7e4a00a7b038f6468db85cd1fa6590c60d39a8e138e9a98410484){:target="_blank"}
- [MDN guidance on number inputs](https://developer.mozilla.org/en-US/docs/Web/HTML/Reference/Elements/input/number#using_number_inputs){:target="_blank"}
- [My course "Angular Signal Forms: Build Modern Forms with Signals"](https://www.udemy.com/course/angular-signal-forms/?couponCode=021409EC66FC6440B867){:target="_blank"}
- [My course "Angular: Styling Applications"](https://www.pluralsight.com/courses/angular-styling-applications){:target="_blank"}
- [My course "Angular in Practice: Zoneless Change Detection"](https://app.pluralsight.com/library/courses/angular-practice-zoneless-change-detection){:target="_blank"}
