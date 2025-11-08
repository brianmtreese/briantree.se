---
layout: post
title: "Angular Enter/Leave Animations in 2025: Old vs New"
date: "2025-07-31"
video_id: "pLSqA6u7J3U"
tags:
  - "Angular"
  - "Angular Animations"
  - "Angular Components"
  - "Angular Signals"
  - "Angular Styles"
  - "Animation"
  - "CSS"
  - "HTML"
---

<p class="intro"><span class="dropcap">A</span>ngular just released a brand new animation API that's lighter, allows for hardware acceleration, and is flat-out simpler than the old system. In this tutorial, we're updating my previous <a href="https://www.youtube.com/watch?v=tDXkcITKDDY&t=209s" target="_blank">:enter and :leave animations guide</a> to use this cutting-edge approach available in Angular <a href="https://github.com/angular/components/releases/tag/20.2.0-next.2" target="_blank">20.2.0-next.2</a>. Ready to get ahead of the curve? Let's go!</p>

{% include youtube-embed.html %}

## The Current App: What We're Working With

We'll be using the same sliding menu demo from [my previous tutorial](https://youtu.be/tDXkcITKDDY){:target="_blank"}, and right now it's working perfectly with [traditional Angular animations](https://www.youtube.com/watch?v=CGBcIz1tYec&t=8s){:target="_blank"}:

<div>
<img src="{{ '/assets/img/content/uploads/2025/07-31/demo-1.gif' | relative_url }}" alt="The original application with :enter and :leave animations from the old Angular animations module" width="844" height="990" style="width: 100%; height: auto;">
</div>

The menu slides in from the right when we click the hamburger icon, and slides back out when we click outside to close it.

This is all working great, so let's open the [root component](https://stackblitz.com/edit/stackblitz-starters-s1qpbh9b?file=src%2Fmain.ts) and take a look at the code.

First, we have an [@if](https://angular.dev/api/core/@if){:target="_blank"} condition that controls whether to show the menu or not:

```html
@if (menuOpen()) {
    <app-page-menu 
        @openClose 
        (close)="menuOpen.set(false)">
    </app-page-menu>
}
```

This means the component is being completely added and removed from the DOM, not just hidden and shown.

The @openClose animation trigger is attached to the menu component, handling enter and leave animations using Angular's traditional animations framework.

The existing animation has an "enter" transition when the item is added and a "leave" transition when it's removed:

```typescript
animations: [
    trigger('openClose',[
        transition(':enter', [
            style(hidden),
            animate(timing, style(visible))
        ]),
        transition(':leave', [
            style(visible),
            animate(timing, style(hidden))
        ])
    ])
]
```

And we're using variables to make the states easier to maintain:

```typescript
const hidden = { transform: 'translateX(120%)' };
const visible = { transform: 'translateX(0)' };
const timing = '1s ease-in';
```

When hidden, it's translated out of the viewport and we transition this translate value when opening and closing the menu.

Pretty straightforward, right? 

But here's why we're about to completely change this approach...

## Why the Old Animation System Falls Short

The Angular team no longer recommends using the animations module for most use cases, and there are several compelling reasons:

- First, the animations package adds about 60kb to your bundle size. Every kb counts, especially for mobile users.
- Second, these animations run without hardware acceleration. Meaning they run on the CPU, not the GPU, making them less smooth, especially on older or mobile devices.
- Third, the Angular animations API is Angular-specific. These skills don't transfer easily to other frameworks or vanilla JavaScript projects.

The Angular team now recommends that we handle as much as possible through CSS, which is faster, more widely supported, and gives us buttery-smooth GPU acceleration out of the box.

But some things are still difficult with CSS alone, especially when items are removed from the DOM. 

There’s a [@starting-style](https://developer.mozilla.org/en-US/docs/Web/CSS/@starting-style){:target="_blank"} for when items are added, but nothing for when they’re removed.

That’s why the Angular team is working on a new animations API to bridge this gap, and that’s what we’re exploring today.

## How the New Animation API Works 

With the new API, instead of animation triggers and transition arrays, we get some simple new features.

We can now add `animate.enter` and pass it a CSS class to apply when the item enters the DOM instead of the old animation trigger:

```html
@if (menuOpen()) {
    <app-page-menu 
        animate.enter="slide-in"
        (close)="menuOpen.set(false)">
    </app-page-menu>
}
```

The beauty of this approach is that we now get to define our animations using plain ol' CSS.

## Building Hardware Accelerated CSS Animations

Let's switch to the [SCSS for this component](https://stackblitz.com/edit/stackblitz-starters-s1qpbh9b?file=src%2Fmain.scss){:target="_blank"}.

Here we'll create our "slide-in" keyframe animation:

```scss
@keyframes slide-in {
    from {
        transform: translateX(120%);
    }
    to {
        transform: translateX(0);
    }
}
```

It'll start translated out of the view and end in the default position, just like the old animation.

Then, we can use the "slide-in" class to trigger this animation:

```scss
.slide-in {
    animation: slide-in 1s ease-in;
}
```

And that's it. Now it's pure CSS!

### Creating the Exit Animation

Now we need to handle the leave animation.

Let's switch back to the code and add this to our component:

```html
@if (menuOpen()) {
    <app-page-menu 
        animate.enter="slide-in"
        animate.leave="slide-out"
        (close)="menuOpen.set(false)">
    </app-page-menu>
}
```

We'll use a "slide-out" class for this.

Now let’s switch back over and add the styles.

The leave keyframe animation looks like this:

```scss
@keyframes slide-out {
    from {
        transform: translateX(0);
    }
    to {
        transform: translateX(120%);
    }
}
```

It's just the inverse of the "slide-in" animation.

Then we use the "slide-out" class to trigger this animation:

```scss
.slide-out {
    animation: slide-out 1s ease-out;
}
```

So, it starts from the normal position and slides out 120%, ending up off-screen.

We’ve now recreated the same animation behavior, but with modern CSS.

### Cleaning Up the Old Code

At this point, we can clean up the old animation system.

We can remove the entire animations array:

<div class="deprecated-code"></div>

```typescript
animations: [
    trigger('openClose',[
        transition(':enter', [
            style(hidden),
            animate(timing, style(visible))
        ]),
        transition(':leave', [
            style(visible),
            animate(timing, style(hidden))
        ])
    ])
]
```

We can also remove the animation imports and constants: 

<div class="deprecated-code"></div>

```typescript
import { animate, style, transition, trigger } from '@angular/animations';

const hidden = { transform: 'translateX(120%)' };
const visible = { transform: 'translateX(0)' };
const timing = '1s ease-in';
```

And we can remove `provideAnimationsAsync()` from our bootstrap providers and its import too:

<div class="deprecated-code"></div>

```typescript
import { provideAnimationsAsync } from '@angular/platform-browser/animations/async';

providers: [
    provideAnimationsAsync()
]
```

The code is easier to understand, it's now pretty much just standard CSS.

## Testing Reveals an Unexpected Issue

Let's save everything and test it out.

Let's try opening the menu:

<div>
<img src="{{ '/assets/img/content/uploads/2025/07-31/demo-2.gif' | relative_url }}" alt="An enter animation functioning correctly using the new Angular animation API" width="832" height="1074" style="width: 100%; height: auto;">
</div>

Perfect! The "slide-in" animation works beautifully. 

But now let's try closing it:

<div>
<img src="{{ '/assets/img/content/uploads/2025/07-31/demo-3.gif' | relative_url }}" alt="A leave animation not functioning correctly using the new Angular animation API" width="832" height="1080" style="width: 100%; height: auto;">
</div>

Hmm, it opens perfectly, but when it closes, the animation doesn't work properly. 

The menu just disappears instead of sliding out.

It took me a while to figure out what was happening here, because in theory, this should work perfectly.

But I think this might be a bug in the current implementation.

What I determined is that the component's styles are being removed immediately as soon as the "menuOpen()" [signal](https://angular.dev/guide/signals){:target="_blank"} changes to false. 

The new animation API keeps the DOM element around during the animation, which is exactly what we want, but without the component's styles, the element isn't rendered properly.

Hopefully this will be fixed in a future Angular release. 

In the meantime however, I found a workaround.

## A Workaround for the Bug

The solution: move the conditional logic into the page-menu component itself, so the component and its styles stay in the DOM always.

Just the guts of the component are added and removed conditionally.

To do this we need to add a conditional wrapper inside the component template, with a signal controlling open state.

So let's switch to the [menu component](https://stackblitz.com/edit/stackblitz-starters-s1qpbh9b?file=src%2Fpage-menu%2Fpage-menu.component.ts){:target="_blank"}, add a "menuOpen" signal initialized to false:

```typescript
import { ..., signal } from '@angular/core';

export class PageMenuComponent {
    ...
    protected menuOpen = signal(false);
}
```

### Restructuring the Component Template 

Now let's go back to the template and wire up this new signal.

First, we'll wrap everything in an @if block using the new signal:

```html
@if (menuOpen()) {
    <ul (click)="close.emit()">
        @for (item of items; track item) {
            <li>
                <a>{% raw %}{{ item }}{% endraw %}</a>
            </li>
        }
    </ul>
    <button (click)="close.emit()">
        <span class="visually-hidden">Close Menu</span>
    </button>
}
```

Inside this block, we'll add a `<div>` that wraps all the content, then apply the animation directives to that `<div>`:

```html
@if (menuOpen()) {
    <div 
        animate.enter="slide-in" 
        animate.leave="slide-out">
        ...
    </div>
}
```

Next, we need to update the button click event. 

Instead of emitting the close event, we'll directly set the signal to false:

#### Before:
```html
<button (click)="close.emit()">
    ...
</button>
```

#### After:
```html
<button (click)="menuOpen.set(false)">
    ...
</button>
```

And we'll do the same for the click event on the list:

#### Before:
```html
<ul (click)="close.emit()">
    ...
</ul>
```

#### After:
```html
<ul (click)="menuOpen.set(false)">
    ...
</ul>
```

### Moving Styles to the Right Place 

Next, we need to move our animation styles and update the component.

Let’s copy the styles we added in the root component into the menu component:

```scss
.slide-in {
    animation: slide-in 1s ease-in;
}

@keyframes slide-in {
    from {
        transform: translateX(120%);
    }
    to {
        transform: translateX(0);
    }
}

.slide-out {
    animation: slide-out 1s ease-out;
}

@keyframes slide-out {
    from {
        transform: translateX(0);
    }
    to {
        transform: translateX(120%);
    }
}
```

Next, we need to update the component styles since we added the wrapper `<div>` for the animations.

Currently, all the positioning and styling is applied to `:host`, but now we need to apply it to the `<div>` inside instead:

#### Before:
```scss
:host {
    ...
}
```

#### After:
```scss
:host > div {
    ...
}
```

## Wiring Up the Final Connections

At this point, we can remove the animations that we added in the root component.

<div class="deprecated-code ln-2 ln-3 ln-4 ln-5"></div>

```html
@if (menuOpen()) {
    <app-page-menu 
        animate.enter="slide-in" 
        animate.leave="slide-out"
        (close)="menuOpen.set(false)">
    </app-page-menu>
}
```

Now, looking at how this menu currently toggles, it opens when the "menuClick" [output](https://angular.dev/api/core/output){:target="_blank"} event fires from the page-content component:

```html
<app-page-content (menuClick)="menuOpen.set(true)"></app-page-content>
```

And closes with the "close" output from the menu component:

```html
<app-page-menu 
    ...
    (close)="menuOpen.set(false)">
</app-page-menu>
```

The state was previously managed here, but it’s now handled within the menu component.

Now we need to add a mechanism to open the menu externally.

Let’s switch back to the menu component and add this.

We'll add a public "open()" method that other components can call to open this menu and all it needs to do is set the signal to true:

```typescript
open() {
    this.menuOpen.set(true);
}
```

We can also remove the output since we don’t need it anymore:

<div class="deprecated-code"></div>

```typescript
close = output<void>();
```

Now, let's switch back to the root component and add a [template reference variable](https://angular.dev/guide/templates/variables#template-reference-variables){:target="_blank"} for the menu component.

Also, we need to remove the old "click" event and the condition around the component:

#### Before:
```html
@if (menuOpen()) {
    <app-page-menu (close)="menuOpen.set(false)"></app-page-menu>
}
```

#### After:
```html
<app-page-menu #menu></app-page-menu>
```

Next we need to update the "menuClick" event to call the "open()" method on the menu component using the reference variable:

#### Before:
```html
<app-page-content (menuClick)="menuOpen.set(true)"></app-page-content>
```

#### After:
```html
<app-page-content (menuClick)="menu.open()"></app-page-content>
```

Okay let’s save and try it out.

## Testing the Complete Solution

Let's try opening and closing the menu now:

<div>
<img src="{{ '/assets/img/content/uploads/2025/07-31/demo-4.gif' | relative_url }}" alt="The final example with both the enter and leave animations working correctly after reworking the logic" width="824" height="1072" style="width: 100%; height: auto;">
</div>

Perfect! It slides in and out correctly now.

The best part? This is now using the new animations API with CSS animations, letting us leverage hardware acceleration for better performance.

## What This Means for Your Projects

That’s it! We’ve successfully migrated to Angular's new animation API.

We replaced complex animation triggers with simple directives, moved to hardware accelerated CSS animations, and reduced our bundle size.

Keep in mind though, this API is brand new and subject to change!

If you found this helpful, don't forget to [subscribe](https://www.youtube.com/c/briantreese?sub_confirmation=1) and check out [my other Angular tutorials](https://www.youtube.com/@briantreese) for more tips and tricks!

{% include banner-ad.html %}

## Additional Resources
- [The original Angular Animations Tutorial](https://youtu.be/tDXkcITKDDY){:target="_blank"}
- [Angular 20.2.0-next.2 Release Notes](https://github.com/angular/angular/releases/tag/20.2.0-next.2){:target="_blank"}
- [Angular Animation Documentation](https://angular.dev/guide/animations){:target="_blank"}
- [CSS @starting-style Documentation](https://developer.mozilla.org/en-US/docs/Web/CSS/@starting-style){:target="_blank"}
- [More on Angular Animations](https://www.youtube.com/playlist?list=PLp-SHngyo0_ikgEN5d9VpwzwXA-eWewSM){:target="_blank"}
- [My course "Angular: Styling Applications"](https://www.pluralsight.com/courses/angular-styling-applications){:target="_blank"}

## Want to See It in Action?
Want to experiment? Explore the full StackBlitz demo below. If you have any questions or thoughts, don't hesitate to leave a comment.

<iframe src="https://stackblitz.com/edit/stackblitz-starters-v2pehw1d?ctl=1&embed=1&file=src%2Fpage-menu%2Fpage-menu.component.html" style="height: 500px; width: 100%; margin-bottom: 1.5em; display: block;"></iframe>
