---
layout: post
title: "Step-by-Step: Create a Click Outside Directive in Angular"
date: "2025-06-12"
video_id: "grlrOnommJI"
tags:
  - "Angular"
  - "Angular Components"
  - "Angular Directives"
  - "Angular Signals"
---

<p class="intro"><span class="dropcap">D</span>ropdown menus and popovers need to close when users click outside them, but implementing click-outside detection requires handling event propagation, component references, and edge cases. This tutorial demonstrates how to build a reusable click-outside directive in Angular that detects clicks outside target elements, handles common bugs like immediate closure, and provides a clean API for any component that needs outside-click detection.</p>

{% include youtube-embed.html %}

## The Problem

First, let’s take a look at the app:

<div>
<img src="{{ '/assets/img/content/uploads/2025/06-12/demo-1.gif' | relative_url }}" alt="An example of a dropdown menu that doesn't close when clicked outside of it in Angular" width="1074" height="834" style="width: 100%; height: auto;">
</div>

This is a simple dashboard. 

It has a top nav, a sidebar, and in the top right corner, we’ve got a user menu.

When we click this avatar, it opens a dropdown with a few links. 

So far, so good. 

But there’s one big problem: there’s no way to close it.

## How the Dropdown Works Now

Let’s open the [user-dropdown component template](https://stackblitz.com/edit/stackblitz-starters-o8b2y9wt?file=src%2Fuser-dropdown%2Fuser-dropdown.html){:target="_blank"} to better understand how this all works currently.

Here’s the button that opens the menu, it just sets a [signal](https://angular.dev/guide/signals){:target="_blank"} called “isOpen” to true when clicked:

```html
<button (click)="isOpen.set(true)">
    ...
</button>
```

And here’s the menu itself, it’s wrapped in a condition based on this “isOpen” [signal](https://angular.dev/guide/signals){:target="_blank"} so it only renders when it's true.

```html
@if (isOpen()) {
    <div class="dropdown">
        ...
    </div>
}
```

But we don’t have anything set up to switch that [signal](https://angular.dev/guide/signals){:target="_blank"} back to false.

So how should we fix this?

## Let’s Try the Shield Method

Probably the best way to do this is to add a full-page invisible element behind the menu, a “shield”, and when you click it, we close the menu.

Let’s try it.

Let's drop in a simple button.

We’re just going to test this out to see if it’ll actually work, so let's add some inline styles — a background color and a fixed position to attach to the viewport:

```html
@if (isOpen()) {
    <button style="background: red; position: fixed; inset: 0;"></button>
    <div class="dropdown">
        ...
    </div>
}
```

Okay, let’s save and see how this works:

<div>
<img src="{{ '/assets/img/content/uploads/2025/06-12/demo-2.gif' | relative_url }}" alt="An example of a shield element that doesn't cover the entire page in Angular due to styles applied to parent components" width="1040" height="764" style="width: 100%; height: auto;">
</div>

Now, when we open the menu… bummer.

The shield is here but it only covers the header, not the entire page.

This happens because of how certain styles are set up.

I think in this case, it’s a CSS [filter](https://developer.mozilla.org/en-US/docs/Web/CSS/filter){:target="_blank"} with a [drop shadow](https://developer.mozilla.org/en-US/docs/Web/CSS/filter-function/drop-shadow){:target="_blank"} that is preventing this from applying like we want it to.

This is often the challenge with pop-ups in a framework like Angular.

When it’s in a component, that component can be used anywhere. 

And we don’t always know, or have the ability to change the styles on the parent components that affect it.

So, this approach works sometimes, but in this layout it fails.

We’re going to build something better.

We’re going to create a [directive](https://angular.dev/guide/directives){:target="_blank"} that monitors elements for clicks outside.

## Create the clickOutside Directive

I’ve already stubbed out a basic “clickOutside” [directive](https://angular.dev/guide/directives){:target="_blank"}, it looks like this:

```typescript
import { Directive } from '@angular/core';

@Directive({
    selector: '[clickOutside]'
})
export class ClickOutsideDirective {

}
```

Right now, it’s just an empty [directive](https://angular.dev/guide/directives){:target="_blank"} with a “clickOutside” attribute as the selector.

We’ll start by adding an output called “clickOutside”:

```typescript
import { ..., output } from '@angular/core';

export class ClickOutsideDirective {
    clickOutside = output<void>();
}
```

This will be emitted when the user clicks outside.

Now we need to access the [host element](https://angular.dev/guide/components/host-elements){:target="_blank"} that this [directive](https://angular.dev/guide/directives){:target="_blank"} gets applied to in order to later determine if the click occurred inside or outside of the element, so let’s inject [ElementRef](https://angular.dev/api/core/ElementRef){:target="_blank"}:

```typescript
import { ..., ElementRef } from '@angular/core';

export class ClickOutsideDirective {
    ...
    private readonly elementRef = inject(ElementRef);
}
```

To listen to a [document](https://developer.mozilla.org/en-US/docs/Web/API/Document/click_event){:target="_blank"} [click event](https://developer.mozilla.org/en-US/docs/Web/API/Element/click_event){:target="_blank"} in Angular, we'll use the [Renderer2](https://angular.dev/api/core/Renderer2){:target="_blank"} class, so we’ll need to inject it as well:

```typescript
import { ..., Renderer2 } from '@angular/core';

export class ClickOutsideDirective {
    ...
    private readonly renderer = inject(Renderer2);
}
```

For this concept, we will be using the [listen](https://angular.dev/api/core/Renderer2#listen){:target="_blank"} method from the [Renderer2](https://angular.dev/api/core/Renderer2){:target="_blank"} class. 

This method returns a function that, when called, removes the event listener to avoid performance issues and memory leaks.

So, let’s add a property called “listener”:

```typescript
export class ClickOutsideDirective {
    ...
    private listener: (() => void) | null = null;
}
```

Now, let’s add a constructor.

Within it, we’ll use this “listener” property to store the event listener, and we’ll use the “renderer” property to call the [listen](https://angular.dev/api/core/Renderer2#listen) method.

The first parameter is the node we want to listen to events on in this case, it’ll be the [document](https://developer.mozilla.org/en-US/docs/Web/API/Document){:target="_blank"}.

The second parameter is the event, in this case, we want to listen for [click](https://developer.mozilla.org/en-US/docs/Web/API/Element/click_event){:target="_blank"} events on the [document](https://developer.mozilla.org/en-US/docs/Web/API/Document){:target="_blank"}.

The third parameter is the callback function that will be called when the event is triggered, and in this callback, we’ll have access to the event that fired:

```typescript
export class ClickOutsideDirective {
    ...
    constructor() {
        this.listener = this.renderer
            .listen('document', 'click', (e: Event) => {
        });
    }
}
```

At this point, what we have is a function that will be called anytime there is a [click](https://developer.mozilla.org/en-US/docs/Web/API/Element/click_event){:target="_blank"} event that happens anywhere in the [document](https://developer.mozilla.org/en-US/docs/Web/API/Document){:target="_blank"}.

What we need to do now is determine if that [click](https://developer.mozilla.org/en-US/docs/Web/API/Element/click_event){:target="_blank"} occurred inside of our [host element](https://angular.dev/guide/components/host-elements){:target="_blank"} or outside.

If it occurred outside, we can emit our “clickOutside” event, if not, we don’t need to do anything.

So, let’s add a condition to make sure that the [host element](https://angular.dev/guide/components/host-elements){:target="_blank"} does not contain the element from the [event target](https://developer.mozilla.org/en-US/docs/Web/API/Event/target){:target="_blank"}.

Then, within this condition, we just need to emit our event:

```typescript
export class ClickOutsideDirective {
    ...
    ...
    constructor() {
        this.listener = this.renderer
            .listen('document', 'click', (e: Event) => {
                if (!this.elementRef.nativeElement.contains(e.target)) {
                    this.clickOutside.emit();
                }
        });
    }
}
```

Now, when using [event listeners](https://developer.mozilla.org/en-US/docs/Web/API/EventTarget/addEventListener){:target="_blank"}, it’s really crucial to clean them up when they’re no longer needed to prevent performance issues.

So we need to be sure to remove this listener when the [directive](https://angular.dev/guide/directives){:target="_blank"} is destroyed.

To do this, let’s implement the [OnDestroy](https://angular.dev/api/core/OnDestroy){:target="_blank"} interface on the [directive](https://angular.dev/guide/directives){:target="_blank"}:

```typescript
import { ...t, OnDestroy } from '@angular/core';

export class ClickOutsideDirective implements OnDestroy {
    ...
}
```

Then, let’s add the [ngOnDestroy()](https://angular.dev/api/core/OnDestroy#api){:target="_blank"} method and then call the "listener" function:

```typescript
export class ClickOutsideDirective implements OnDestroy {
    ...
    ngOnDestroy() {
        this.listener?.();
    }
}
```

Now, the listener will be removed when this [directive](https://angular.dev/guide/directives){:target="_blank"} is removed from the DOM.

So that’s pretty much everything we need in the [directive](https://angular.dev/guide/directives){:target="_blank"}.

### Hook It Up in the Component

Let’s switch to the [user-dropdown.ts](https://stackblitz.com/edit/stackblitz-starters-gkp8jkoc?file=src%2Fuser-dropdown%2Fuser-dropdown.ts){:target="_blank"}.

Before we can use the "clickOutside" [directive](https://angular.dev/guide/directives){:target="_blank"}, we need to import it:

```typescript
import { ClickOutsideDirective } from '../click-outside';

@Component({
    selector: 'app-user-dropdown',
    imports: [
        ...,
        ClickOutsideDirective
    ]
})
```

Now we can switch to [the template](https://stackblitz.com/edit/stackblitz-starters-gkp8jkoc?file=src%2Fuser-dropdown%2Fuser-dropdown.html){:target="_blank"} and use this [directive](https://angular.dev/guide/directives){:target="_blank"}.

Let’s add it to the div that contains our dropdown.

In this case, since the [output](https://angular.dev/api/core/output){:target="_blank"} and the [directive](https://angular.dev/guide/directives){:target="_blank"} selector are named the same, we can combine them with the [event binding syntax](https://angular.dev/guide/templates/event-listeners#listening-to-native-events){:target="_blank"}.

Then, when the "clickOutside" event fires, we just need to flip the value of the "isOpen" [signal](https://angular.dev/guide/signals){:target="_blank"}:

```html
@if (isOpen()) {
    <div
        (clickOutside)="isOpen.set(false)"
        class="dropdown">
        ...
    </div>
}
```

Okay, that should be everything, so let’s save and try this out:

<div>
<img src="{{ '/assets/img/content/uploads/2025/06-12/demo-3.gif' | relative_url }}" alt="An example of a dropdown that won't open after applying a custom click outside directive in Angular" width="890" height="788" style="width: 100%; height: auto;">
</div>

Now when I click to open the menu… nothing happens. That’s weird.

Let’s inspect what’s going on.

### Debug the Bug

When we click the button... yep, you can actually see the menu does open, but it closes instantly:

<div>
<img src="{{ '/assets/img/content/uploads/2025/06-12/demo-4.gif' | relative_url }}" alt="Inspecting the dropdown menu in Angular to see that it closes instantly after opening" width="1544" height="840" style="width: 100%; height: auto;">
</div>

Here’s what’s happening: the click event that opens the menu also bubbles up to the document, and our clickOutside directive sees that click after the menu is rendered. 

So it thinks we just clicked outside, and immediately closes it again.

We need to prevent the [directive](https://angular.dev/guide/directives){:target="_blank"} from responding to the very first click that triggered the menu to open.

### Prevent the Immediate Close Bug

Let’s head back to the directive.

First, let’s add an "isFirstClick" Boolean property and set it to true:

```typescript
export class ClickOutsideDirective implements OnDestroy {
    ...
    private isFirstClick = true;
}
```

This will be used to track whether it’s the first click event or not.

Now, within our listener callback, let’s add a condition based on this property.

If it’s true, we’ll set it to false, and just return to avoid emitting the click event:

```typescript
export class ClickOutsideDirective {
    ...
    ...
    constructor() {
        this.listener = this.renderer
            .listen('document', 'click', (e: Event) => {
                if (this.isFirstClick) {
                    this.isFirstClick = false;
                    return;
                }
                ...
        });
    }
}
```

This should now skip the first [document](https://developer.mozilla.org/en-US/docs/Web/API/Document){:target="_blank"} [click event](https://developer.mozilla.org/en-US/docs/Web/API/Element/click_event){:target="_blank"} that happens right after the menu appears.

Now let's save and try it again:

<div>
<img src="{{ '/assets/img/content/uploads/2025/06-12/demo-5.gif' | relative_url }}" alt="Example of a cooldown button with a custom duration using a signal input in Angular" width="908" height="776" style="width: 100%; height: auto;">
</div>

Now when we click the avatar, the dropdown opens, and when we click anywhere else it closes.

Perfect.

## Why stopPropagation() Can Break Everything

This works… but there’s one sneaky edge case.

Let’s say we have an element somewhere on the page that uses [stopPropagation()](https://developer.mozilla.org/en-US/docs/Web/API/Event/stopPropagation){:target="_blank"}.

For example, maybe a sidebar item needs to prevent [bubbling](https://developer.mozilla.org/en-US/docs/Learn_web_development/Core/Scripting/Event_bubbling){:target="_blank"} for some reason.

Let’s open the [main component template](https://stackblitz.com/edit/stackblitz-starters-o8b2y9wt?file=src%2Fmain.html){:target="_blank"} and find the first link in the sidebar.

Let’s add a [click event](https://developer.mozilla.org/en-US/docs/Web/API/Element/click_event){:target="_blank"} handler here that calls [stopPropagation()](https://developer.mozilla.org/en-US/docs/Web/API/Event/stopPropagation){:target="_blank"}:

```html
<aside class="sidebar">
    <a (click)="handleClick($event)">
        📊 Overview
    </a>
    ...
</aside>
```

Now, let’s save and try it out:

<div>
<img src="{{ '/assets/img/content/uploads/2025/06-12/demo-6.gif' | relative_url }}" alt="Example of stopping propagation of a click event in Angular interfering with the click outside directive" width="902" height="794" style="width: 100%; height: auto;">
</div>


Now when we open the menu and click that link, it doesn’t close.

Why? Because the [document](https://developer.mozilla.org/en-US/docs/Web/API/Document){:target="_blank"} [click event](https://developer.mozilla.org/en-US/docs/Web/API/Element/click_event){:target="_blank"} never fires, [stopPropagation()](https://developer.mozilla.org/en-US/docs/Web/API/Event/stopPropagation){:target="_blank"} blocked it.

This isn’t a bug in our [directive](https://angular.dev/guide/directives){:target="_blank"}, it’s just something to be aware of.

The [directive](https://angular.dev/guide/directives){:target="_blank"} depends on the [document](https://developer.mozilla.org/en-US/docs/Web/API/Document){:target="_blank"} event firing.

If another part of your app cancels that event, it won’t work.

This is why I prefer the first example, the “shield” concept, if possible.

It’s often a more bulletproof choice when layering modals, dropdowns, or overlays.

But, sometimes it just won’t work, and you need a global "click outside" event.

### The Bottom Line

The bottom line is that while this [directive](https://angular.dev/guide/directives){:target="_blank"} works great for most use cases. 

Just be aware that if other parts of your app are interfering with event propagation, it might not behave as expected.

## Final Recap: Shield vs. Directive

Alright, we've built a fully functional "click outside" [directive](https://angular.dev/guide/directives){:target="_blank"} in Angular. 

We walked through the pitfalls, fixed the immediate-close bug, and even looked at why [stopPropagation()](https://developer.mozilla.org/en-US/docs/Web/API/Event/stopPropagation){:target="_blank"} can quietly break everything when you least expect it.

You now have two solid patterns in your toolkit:

- A shield element, which works reliably for overlays and modals.
- And a [directive](https://angular.dev/guide/directives){:target="_blank"} that’s clean and reusable, when that shield concept doesn’t work.

If this helped you out, do me a favor, share it with someone who’s probably fighting this exact bug right now, and [subscribe](https://www.youtube.com/c/briantreese?sub_confirmation=1){:target="_blank"} if you want to see [more tutorials like this](https://www.youtube.com/@briantreese){:target="_blank"}.

{% include banner-ad.html %}

## Additional Resources
- [The demo app BEFORE any changes](https://stackblitz.com/edit/stackblitz-starters-o8b2y9wt?file=src%2Fclick-outside.ts){:target="_blank"}
- [The demo app AFTER making changes](https://stackblitz.com/edit/stackblitz-starters-gkp8jkoc?file=src%2Fclick-outside.ts){:target="_blank"}
- [Angular Official Docs – Directives](https://angular.dev/guide/directives){:target="_blank"}
- [Angular Renderer2 API](https://angular.dev/api/core/Renderer2){:target="_blank"}
- [Understanding Event Propagation in JavaScript](https://developer.mozilla.org/en-US/docs/Learn_web_development/Core/Scripting/Events#event_bubbling_and_capture){:target="_blank"}
- [Angular Signals](https://angular.dev/guide/signals){:target="_blank"}
- [Clean Up with OnDestroy](https://angular.dev/api/core/OnDestroy){:target="_blank"}
- [My course: "Angular: Styling Applications"](https://www.pluralsight.com/courses/angular-styling-applications){:target="_blank"}

## Get Ahead of Angular's Next Shift

Most Angular apps today still rely on reactive forms, but that's starting to shift.

Signal Forms are new, and not widely adopted yet, which makes this a good time to get ahead of the curve.

I created a course that walks through everything in a real-world context if you want to get up to speed early: 👉 [Angular Signal Forms Course](https://www.udemy.com/course/angular-signal-forms/?couponCode=021409EC66FC6440B867){:target="_blank"}

<div class="youtube-embed-wrapper">
	<iframe 
		width="1280" 
		height="720"
		src="https://www.youtube.com/embed/fZZ1UVkyB4I?rel=1&modestbranding=1" 
		frameborder="0" 
		allow="accelerometer; autoplay; clipboard-write; encrypted-media; gyroscope; picture-in-picture; web-share" 
		allowfullscreen
		loading="lazy"
		title="Signal Forms Course Preview"
	></iframe>
</div>

## Want to See It in Action?

Want to experiment with the final version? Explore the full StackBlitz demo below. If you have any questions or thoughts, don’t hesitate to leave a comment.

<iframe src="https://stackblitz.com/edit/stackblitz-starters-gkp8jkoc?ctl=1&embed=1&file=src%2Fclick-outside.ts" style="height: 500px; width: 100%; margin-bottom: 1.5em; display: block;"></iframe>
