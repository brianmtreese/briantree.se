---
layout: post
title: "Just Another Angular CDK Feature Nobody Talks About"
date: "2025-07-17"
video_id: "iO81nlnNQBQ"
tags:
  - "Accessibility"
  - "Angular"
  - "Angular CDK"
  - "Angular Material"
  - "Focus Monitor"
---

<p class="intro"><span class="dropcap">Y</span>our UI treats every user exactly the same, and it might be driving them crazy. Keyboard users get identical experiences to mouse users. Code programmatically focuses elements and triggers the same aggressive responses as intentional user actions. The Angular CDK's <a href="https://material.angular.dev/cdk/a11y/api#FocusMonitor" target="_blank">Focus Monitor</a> can detect exactly how users interact with any element: mouse clicks, keyboard navigation, touch, or programmatic focus. And I’ll bet 90% of Angular developers have never heard of it.</p>

Today, I'll show you how this one service creates adaptive user experiences that respond intelligently to different interaction patterns. Let's dive in!

{% include youtube-embed.html %}

## The Problem Our Users Are Facing

Alright, let's start by exposing the problem. I've got what looks like a simple email input field: 

<div>
<img src="{{ '/assets/img/content/uploads/2025/07-17/demo-1.png' | relative_url }}" alt="An Angular form with an simple email input field" width="1016" height="476" style="width: 100%; height: auto;">
</div>

But watch what happens when we interact with it in different ways:

<div>
<img src="{{ '/assets/img/content/uploads/2025/07-17/demo-2.gif' | relative_url }}" alt="Showing the full functionality of the Angular form" width="822" height="554" style="width: 100%; height: auto;">
</div>

When we click into the field and then blur, an error message appears. 

That seems reasonable for a mouse user, right?

Then, when we tab into the field using the keyboard and blur, the error shows up immediately again.

But then things get problematic. 

When we click this "Focus Email" button, it programmatically focuses the input field and that error message is still staring at us!

This might seem fine, but it could actually be a problem. 

Think about it, if our code is automatically focusing this field, maybe as part of a form validation flow or user guidance, we probably don't want to spam the user with error messages. 

That's just a bad user experience.

What we really want here is smart validation that behaves differently based on how the user focused the field. 

And that's exactly what the Angular CDK [Focus Monitor](https://material.angular.dev/cdk/a11y/api#FocusMonitor){:target="_blank"} can help us achieve.

## What We're Working With

Let's look to our [component HTML](https://stackblitz.com/edit/stackblitz-starters-oivbnpoo?file=src%2Fform%2Fform.html){:target="_blank"} to see what we're dealing with.

Looking at this template, it's pretty standard stuff. 

On our input element we have a template reference variable called "emailInput", we'll need this in a moment:

```html
<input #emailInput ... />
```

We have a blur event that calls an `onBlur()` method:

```html
<input (blur)="onBlur()" ... />
```

This is our current validation trigger, and it's the source of our one-size-fits-all problem.

The input uses [ngModel](https://angular.dev/api/forms/NgModel){:target="_blank"} to bind to an "email" [signal](https://angular.dev/guide/signals){:target="_blank"}, which is how we're storing the value the user types:

```html
<input [ngModel]="email" ... />
```

This input also gets an "error" class when a "showError" signal is true, which provides visual feedback:

```html
<input [class.error]="showError()" ... />
```

Below the input, we have our error message that only shows when the "showError" signal is true, that's this [@if](https://angular.dev/api/core/@if){:target="_blank"} block:

```html
@if (showError()) {
    <div class="error">
        Invalid email
    </div>
}
```

And finally, there's the button that focuses the input using that template reference variable simulating what your application might do to guide users:

```html
<button (click)="emailInput.focus()">
    Focus Email
</button>
```

Now let's switch to the [component TypeScript](https://stackblitz.com/edit/stackblitz-starters-oivbnpoo?file=src%2Fform%2Fform.ts){:target="_blank"} to see the logic behind this.

First, we have the "showError" signal initialized to false... no errors by default:

```typescript
protected showError = signal(false);
```

Next, we have the "email" signal initialized to an empty string:

```typescript
protected email = signal('');
```

Remember, that's where we store what the user types.

Then we have the `onBlur()` method:

```typescript
protected onBlur() {
    if (this.hasInvalidEmail()) {
        this.showError.set(true);
    }
}
```

It's pretty straightforward.

It checks if we have an invalid email using this helper method:

```typescript
private hasInvalidEmail(): boolean {
    return !this.email().includes('@');
}
```

If it is invalid, it sets the "showError" signal to true.

This validation itself is super simple, it's just looking for an @ symbol. 

Obviously you'd want something more robust in production, but this works for our demo.

The problem is this function has no idea how the user focused the field. 

Mouse click? Keyboard navigation? Touch gesture? Programmatic focus? It treats them all identically.

## The Solution That Changes Everything

So here's what we want to achieve instead: when a user tabs into the field with their keyboard or clicks with their mouse, and then leaves the field, if it's invalid, we want to show the error message. 

If it's valid, we want to make sure the error is hidden.

But here's the key difference, if our code programmatically focuses the field, like when someone clicks that "Focus Email" button, we don't want to show any error messages. 

In fact, if the error message is already showing, we want to hide it.

This is where the Angular CDK Focus Monitor service comes into play. 

It can tell us exactly how an element received focus, which lets us create smarter, more user-friendly validation.

## Building Something Better

First, a quick note, you'll need the [Angular CDK](https://material.angular.dev/guide/getting-started) installed. 

You'll just need to run this command in your project root to install it:

```bash
npm install @angular/cdk
```

Okay, I'm going to start by injecting the `FocusMonitor` service from the [CDK A11y module](https://material.angular.dev/cdk/a11y/overview){:target="_blank"} using Angular's [inject](https://angular.dev/api/core/inject){:target="_blank"} function:

```typescript
import { FocusMonitor } from '@angular/cdk/a11y';
...
protected focusMonitor = inject(FocusMonitor);
```

Next, let’s add a constructor with an [effect](https://angular.dev/api/core/effect){:target="_blank"}:

```typescript
import { ..., effect } from "@angular/core";
...
constructor() {
    effect(() => {
    });
}
```

Within this effect, we can use the `FocusMonitor` service to monitor the focus state with the `monitor()` function.

This monitor method needs an [ElementRef](https://angular.dev/api/core/ElementRef){:target="_blank"} to monitor focus on, in our case that's our email input.

So, we’ll use Angular's new [viewChild()](https://angular.dev/api/core/viewChild){:target="_blank"} signal function to get a reference to it:

```typescript
import { ..., viewChild } from "@angular/core";
...
private emailInput = viewChild.required<ElementRef>('emailInput');
```

This creates a signal that will hold a reference to the element with the template reference variable "emailInput".

Then we can pass this element to our `monitor()` function:

```typescript
constructor() {
    effect(() => {
        this.focusMonitor
            .monitor(this.emailInput())
    });
}
```

This method returns an observable, so we need to subscribe to it. 

But first, let's add proper cleanup using [takeUntilDestroyed()](https://angular.dev/api/core/rxjs-interop/takeUntilDestroyed){:target="_blank"}.

We'll also need to inject [DestroyRef](https://angular.dev/api/core/DestroyRef){:target="_blank"} for this to work and then pass it to the `takeUntilDestroyed()` function:

```typescript
import { ..., DestroyRef } from "@angular/core";
import { takeUntilDestroyed } from '@angular/core/rxjs-interop';
...
private destroyRef = inject(DestroyRef);

constructor() {
    effect(() => {
        this.focusMonitor
            .monitor(this.emailInput());
            .pipe(takeUntilDestroyed(this.destroyRef))
    });
}
```

Ok, now we're ready to subscribe:

```typescript
constructor() {
    effect(() => {
        this.focusMonitor
            .monitor(this.emailInput());
            .pipe(takeUntilDestroyed(this.destroyRef))
            .subscribe(origin => {
            });
    });
}
```

Now, let me explain what this observable gives us. 

The result will be a [FocusOrigin](https://material.angular.dev/cdk/a11y/api#FocusOrigin){:target="_blank"}. 

This observable fires every time focus on the element changes.

When the element gets focused, we'll receive `"mouse"` for mouse clicks, `"keyboard"` for tab navigation or arrow key movements, `"touch"` for touch events on mobile devices, or `"program"` when our code focuses it programmatically.

When the element loses focus, we get `null`.

What we want to do in this example is track the last origin state for some of our logic. 

Let's add a new signal for this using the `FocusOrigin` interface for this signal since that’s what we get from the observable:

```typescript
import { ..., FocusOrigin } from '@angular/cdk/a11y';
...
protected lastFocusOrigin = signal<FocusOrigin>(null);
```

Now, let's set this signal in our subscription:

```typescript
constructor() {
    effect(() => {
        this.focusMonitor
            .monitor(this.emailInput());
            .pipe(takeUntilDestroyed(this.destroyRef))
            .subscribe(origin => 
                this.lastFocusOrigin.set(origin));
    });
}
```

Also, let's temporarily comment out the `onBlur()` method so we can see the focus monitor in action:

```typescript
protected onBlur() {
//    if (this.hasInvalidEmail()) {
//        this.showError.set(true);
//    }
}
```

## The Magic Revealed

Let's switch to the HTML and add a way to see what's happening behind the scenes.

To do this let's add a paragraph that shows the current focus origin:

```html
<p>
    Focus Origin: {% raw %}{{ lastFocusOrigin() ?? 'none' }}{% endraw %}
</p>
```

If it's null, we'll display "none" to make it crystal clear.

Okay let's save and see this in action:

<div>
<img src="{{ '/assets/img/content/uploads/2025/07-17/demo-3.gif' | relative_url }}" alt="Demonstrating the different focus origins available when using the Angular CDK Focus Monitor" width="818" height="780" style="width: 100%; height: auto;">
</div>

Perfect! When I click into the field, it shows `"mouse"` as the focus origin.

When I blur, it shows `"none"` because focus was lost.

When I tab into the field, it shows `"keyboard"`.

This tells us the user is navigating intentionally.

And when I click the "Focus Email" button, we get `"program"` because we focused it programmatically.

This is incredible information. 

We now know exactly how users are interacting with our interface, and we can create experiences tailored to their interaction style.

## Creating Adaptive Experiences

Now let's use this focus origin information to create our smart validation. 

Let's switch back to the component TypeScript and in our subscription, let's add some adaptive logic. 

First, let me create some readable constants.

One for keyboard interactions, and another for mouse interactions:

```typescript
const keyboardError = this.lastFocusOrigin() === 'keyboard';
const mouseError = this.lastFocusOrigin() === 'mouse';
```

Now here's the adaptive part, if the user focused with keyboard or mouse, we want to provide validation feedback when focus changes.

Let’s set `showError()` based on whether the email is actually invalid. True for invalid, false for valid:

```typescript
if (keyboardError || mouseError) {
    this.showError.set(this.hasInvalidEmail());
}
```

Then, if the origin is `"program"`, meaning our application focused it, we hide any error messages:

```typescript
if (origin === 'program') {
    this.showError.set(false);
}
```

Here's what the complete final code looks like:

```typescript
constructor() {
    effect(() => {
        this.focusMonitor
            .monitor(this.emailInput());
            .pipe(takeUntilDestroyed(this.destroyRef))
            .subscribe(origin => {
                const keyboardError = this.lastFocusOrigin() === 'keyboard';
                const mouseError = this.lastFocusOrigin() === 'mouse';
                if (keyboardError || mouseError) {
                    this.showError.set(this.hasInvalidEmail());
                }
                if (origin === 'program') {
                    this.showError.set(false);
                }
                this.lastFocusOrigin.set(origin);
            });
    });
}
```

And we can now completely remove that old `onBlur()` method since we're handling everything in our adaptive focus monitor.

Let's save and see our adaptive interface in action:

<div>
<img src="{{ '/assets/img/content/uploads/2025/07-17/demo-4.gif' | relative_url }}" alt="Showcasing the adaptive validation logic created with the Angular CDK Focus Monitor" width="820" height="686" style="width: 100%; height: auto;">
</div>

Now when we click into the field and type an invalid email and then click outside, the error appears because this was a mouse interaction. Perfect!

Then when we click back in and make it valid and blur again, the error disappears because the email is now valid.

With keyboard navigation, if we tab to the field and make it invalid again and then tab away, the error shows up because this was a keyboard interaction.

When we shift-tab back, and fix the email to make it valid, then tab away, the error disappears because the email is valid.

Then for the moment of truth, when we make it invalid again and blur to show the error message and then click the "Focus Email" button, the error message vanishes!

That's our programmatic focus logic working perfectly. 

No more interrupting user workflows when our application is trying to be helpful.

## Final Thoughts: Put It to Work

And there you have it, the Angular CDK Focus Monitor in action! 

This tiny but powerful service gives you incredible insight into how users interact with your UI.

Think about all the possibilities this opens up: 
- Different validation timing for keyboard vs mouse users 
- Better accessibility for screen reader users
- Preventing validation spam during programmatic focus
- Creating more intuitive user experiences, and more!

The best part? Your users will never even notice the difference. 

Things will just work like they’re expecting them to.

The Focus Monitor is just one of many hidden gems in the Angular CDK. 

If you want to see more lesser-known Angular features that can level up your applications, don't forget to [subscribe](https://www.youtube.com/c/briantreese?sub_confirmation=1) and check out [my other Angular tutorials](https://www.youtube.com/@briantreese) for more tips and tricks!

{% include banner-ad.html %}

## Additional Resources
- [Angular CDK Focus Monitor](https://material.angular.dev/cdk/a11y/api#FocusMonitor){:target="_blank"}
- [Angular CDK A11y Module](https://material.angular.dev/cdk/a11y/overview){:target="_blank"}
- [Web Accessibility Guidelines](https://www.w3.org/WAI/WCAG21/quickref/){:target="_blank"}
- [Angular CDK Installation Guide](https://material.angular.dev/guide/getting-started){:target="_blank"}
- [My course "Angular: Styling Applications"](https://www.pluralsight.com/courses/angular-styling-applications){:target="_blank"}

## Want to See It in Action?

Want to experiment with the final version? Explore the full StackBlitz demo below. If you have any questions or thoughts, don’t hesitate to leave a comment.

<iframe src="https://stackblitz.com/edit/stackblitz-starters-q4vduemg?ctl=1&embed=1&file=src%2Fform%2Fform.ts" style="height: 500px; width: 100%; margin-bottom: 1.5em; display: block;"></iframe>