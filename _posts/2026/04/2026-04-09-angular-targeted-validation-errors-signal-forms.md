---
layout: post
title: "How to Get Specific Validation Errors with Angular Signal Forms"
date: "2026-04-09"
video_id: "gfYXk9p_PG4"
tags:
  - "Angular"
  - "Angular v22"
  - "Signal Forms"
  - "Angular Forms"
  - "Form Validation"
---

<p class="intro"><span class="dropcap">I</span>f you’ve ever tried to build something like a password checklist in Signal Forms, you’ve probably run into a frustrating limitation. You need to know if a specific validation rule failed, but the errors API doesn’t make that easy. And if you try to rely on error indexes, things can break pretty quickly as errors come and go. This post walks through how Angular v22 gives us a simple fix for this with the new <code>getError()</code> function.</p>

{% include youtube-embed.html %}

## A Password Checklist with Angular Signal Forms 

Here we have a simple sign-up form with a username and password field:

<div><img src="{{ '/assets/img/content/uploads/2026/04-09/password-checklist-form.jpg' | relative_url }}" alt="A sign-up form with a password checklist showing requirements for uppercase, number, special character, and length" width="1370" height="1088" style="width: 100%; height: auto;"></div>

For the password field, we have a list of requirements: 
- One uppercase letter 
- One number
- One special character
- And at least 8 characters 

As we add each required piece to the password, the UI updates letting us know each requirement has been met:

<div><img src="{{ '/assets/img/content/uploads/2026/04-09/password-checklist-form-success.gif' | relative_url }}" alt="A sign-up form with a password checklist showing requirements for uppercase, number, special character, and length" width="1370" height="934" style="width: 100%; height: auto;"></div>

We’re going to implement this specific functionality using the Signal Forms API. 

The tricky part here is that this UI isn’t just showing errors, we need to track each rule individually.

## Why Error Indexes Break in Angular Signal Forms

The validators on this form look like this:

```typescript
protected form = form(this.model, s => {
  // ...
  minLength(s.password, 8);

  // Password must include at least one number
  validate(s.password, ({ value }) => {
  	if (!/\d/.test(value())) {
  	  return { kind: 'missingNumber' };
  	}
  	return null;
  });

  // Password must include at least one uppercase letter
  validate(s.password, ({ value }) => {
    if (!/[A-Z]/.test(value())) {
      return { kind: 'missingUppercase' };
    }
    return null;
  });

  // Password must include at least one special character
  validate(s.password, ({ value }) => {
    if (!/[^A-Za-z0-9]/.test(value())) {
      return { kind: 'missingSpecialChar' };
    }
    return null;
  });
});
```

There are four validators on the password field:

1. The first is the [minLength validator](https://angular.dev/api/forms/signals/minLength?utm_campaign=deveco_gdemembers&utm_source=deveco){:target="_blank"}
2. The second is a [custom validator](https://angular.dev/api/forms/signals/validate?utm_campaign=deveco_gdemembers&utm_source=deveco){:target="_blank"} that checks for a number
3. The third is a custom validator that checks for an uppercase letter
4. And the fourth is a custom validator that checks for a special character

To make this concept work, we need to bind a `valid` class on each list item when its specific validation error does not exist. 

One way we might try to do this is by accessing the form field, then using the errors array to get the validator by index:

```html
<ol>
  <li [class.valid]="!form.password().errors()[2]">
    One uppercase letter
  </li>
  <!-- ... -->
</ol>
```

We’ll access the password field from the form, then use the errors array to grab a validator by index.

In this case, the minlength was first, the missing number was second, and this error was third 

Arrays are zero-based, so we’ll go with an index of `2`.

If we save and look at this in the browser, already we can see we have a problem:

<div><img src="{{ '/assets/img/content/uploads/2026/04-09/error-index-bug.jpg' | relative_url }}" alt="The minLength error is not showing up yet because the field is empty" width="1468" height="1054" style="width: 100%; height: auto;"></div>

Notice the minLength error isn't showing up yet. 

That's because the field is currently empty, and minLength only triggers when there's actually a value. 

This means that the index of `2` that we used for our uppercase error is already incorrect.

If I click into the password field and add an uppercase character, watch what happens:

<div><img src="{{ '/assets/img/content/uploads/2026/04-09/error-index-bug-2.jpg' | relative_url }}" alt="Typing in the password field causes the error array order to change, breaking the UI logic" width="1406" height="1230" style="width: 100%; height: auto;"></div>

The uppercase error is removed from the array, and the minLength error is added. 

The order of the array completely changes! 

The problem is that the errors array isn’t stable.

It changes based on which validators are currently failing. 

So not only is this fragile, it’s fundamentally the wrong way to model this UI.

But, luckily we’ve got more options!

## Using errors().find() to Check Validation Rules

At this point, you might think “okay, I’ll just search the array.” 

Let’s switch to the [find()](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/Array/find){:target="_blank"} method instead where the kind equals `missingUppercase`.

```html
<ol>
  <li [class.valid]="!form.password().errors().find(e => e.kind === 'missingUppercase')">
    One uppercase letter
  </li>
  <!-- ... -->
</ol>
```

Now this explicitly looks for the error with the kind we care about, regardless of its position in the array. 

After saving, if I click into the field and type an uppercase letter, you can see this worked correctly:

<div><img src="{{ '/assets/img/content/uploads/2026/04-09/find-success.jpg' | relative_url }}" alt="Typing in the password field successfully checks off each requirement one by one" width="1460" height="724" style="width: 100%; height: auto;"></div>

The uppercase letter requirement is properly colored and checked.

So this works, but now we’re scanning the entire error array every time we want to check a single rule. 

It gets repetitive, and it doesn’t really match what we’re trying to do. 

Well, in Angular 22, there's going to be an even better way!

## Angular 22: Using getError() for Clean Validation Checks

Now, with reactive forms, we had a feature that allowed us to do this pretty easily. 

We would set this up using the `hasError()` function:

```html
<ol>
  <li [class.valid]="!signUpForm.controls.password.hasError('missingUppercase')">
    One uppercase letter
  </li>
  <!-- ... -->
</ol>
```

It's pretty clean, readable, and it explicitly checks for the error we want. 

Well, in Angular 22, we're getting something very similar for signal forms.

Instead of scanning the entire array every time, Angular 22 introduces a new `getError()` function. 

Now we can directly ask: “does this specific error exist?”

Which is exactly what this UI needs.

```html
<ol [class.dirty]="form.password().dirty()">
  <li [class.valid]="!form.password().getError('missingUppercase')">
    One uppercase letter
  </li>
  <li [class.valid]="!form.password().getError('missingNumber')">
    One number
  </li>
  <li [class.valid]="!form.password().getError('missingSpecialChar')">
    One special character
  </li>
  <li [class.valid]="!form.password().getError('minLength') && form.password().value()">
    At least 8 characters
  </li>
</ol>
```

Much cleaner, right? 

One important detail, Signal Forms can have multiple errors with the same kind, and `getError()` will only return the first one. 

Also, for the `minLength` requirement, this rule is a little different. 

We only want to evaluate it once the user has actually entered something. 

If we leave that off, we could add an 8-character value, then completely delete it, and the requirement would still show as satisfied.

## The Final Result

Let’s try it out:

<div><img src="{{ '/assets/img/content/uploads/2026/04-09/geterror-success.gif' | relative_url }}" alt="Typing in the password field successfully checks off each requirement one by one" width="1460" height="930" style="width: 100%; height: auto;"></div>

And there we go! Each item is now properly checked off as each requirement is met.

This is the key idea: instead of working with the entire error list, we’re working with individual validation states.

## Why getError() Makes Signal Forms Easier to Use

So `getError()` brings Signal Forms much closer to the ergonomics we had with `hasError()` in reactive forms, but with a more flexible error model. 

And when you're building UIs like this, where each validation rule matters individually, it makes a big difference.

## Get Ahead of Angular's Next Shift

Most Angular apps today still rely on the old reactive or template-driven forms, but that's starting to shift.

Signal Forms are new, and not widely adopted yet, which makes this a good time to get ahead of the curve.

I created a course that walks through everything in a real-world context if you want to get up to speed early: 👉 [Angular Signal Forms: Build Modern Forms with Signals](https://www.udemy.com/course/angular-signal-forms/?couponCode=021409EC66FC6440B867){:target="_blank"}

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
- [The source code for this example](https://github.com/brianmtreese/Getting-Specific-Validation-Errors-with-Signal-Forms){:target="_blank"}
- [The commit that makes this all possible](https://github.com/angular/angular/commit/709f5a390ca0de04f8066012a5cb36999f2fd4a6){:target="_blank"}
- [My course "Angular Signal Forms: Build Modern Forms with Signals"](https://www.udemy.com/course/angular-signal-forms/?couponCode=021409EC66FC6440B867){:target="_blank"}
- [My course "Angular: Styling Applications"](https://www.pluralsight.com/courses/angular-styling-applications){:target="_blank"}
- [My course "Angular in Practice: Zoneless Change Detection"](https://app.pluralsight.com/library/courses/angular-practice-zoneless-change-detection){:target="_blank"}
