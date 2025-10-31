---
layout: post
title: "Animation Start/Done? Dead. Long Live CSS + DOM Events"
date: "2025-10-02"
video_id: "8yBHsnFhmBE"
tags:
    - "Angular"
    - "Animation"
    - "Angular Animations"
    - "Angular Styles"
    - "Angular Components"
---

<p class="intro"><span class="dropcap">A</span> while back, I made <a href="https://youtu.be/OLtDcBG9M_4" target="_blank">a tutorial</a> showing how to hook into Angular’s animation start and done events. That example has helped a lot of people, but since then, Angular officially deprecated the animations module. So in this updated tutorial, we’re going to take that same example and modernize it using pure CSS keyframes, <a href="https://angular.dev/guide/signals" target="_blank">Angular signals</a>, and standard DOM events.</p>

By the end, you’ll see exactly how you’d write this code today, and how to move away from the old API without losing any functionality.  

Let’s jump in!

{% include youtube-embed.html %}

## The Current Behavior

Here’s the current app: 

<div>
<img src="{{ '/assets/img/content/uploads/2025/10-02/demo-1.gif' | relative_url }}" alt="The original demo application with the wobble animation built using the since-deprecated Angular animations module" width="860" height="928" style="width: 100%; height: auto;">
</div>

When we click the "Continue" button without typing in an email, the field wobbles side to side. 

Fun, right?  

This behavior is created with the old Angular animations module, so let’s take a peek under the hood.

### How Angular’s Deprecated Animation DSL Works

In the [sign-up form component](https://stackblitz.com/edit/stackblitz-starters-mngxgefx?file=src%2Fsign-up-form%2Fsign-up-form.component.ts){:target="_blank"}, the wobble animation is defined right in the metadata using Angular’s old keyframe DSL:

```typescript
import { animate, keyframes, style, transition, trigger, AnimationEvent } from '@angular/animations';

@Component({
    selector: 'app-sign-up-form',
    ...
    changeDetection: ChangeDetectionStrategy.OnPush,
    animations: [
    trigger('wobble', [
        transition('false => true', [
        animate('0.75s', keyframes([
            style({transform: 'translateX(-5%)', offset: 0.1}),
            style({transform: 'translateX(5%)', offset: 0.3}),
            style({transform: 'translateX(-5%)', offset: 0.5}),
            style({transform: 'translateX(5%)', offset: 0.7}),
            style({transform: 'translateX(-5%)', offset: 0.9}),
            style({transform: 'translateX(0)', offset: 1})
        ]))
        ])
    ])
    ]
})
```

We also have a "wobbleField" signal, a boolean flag to control when the animation should fire:

```typescript
protected wobbleField = signal(false);
```

Then, there’s an "onWobbleStart()" function:

```typescript
protected onWobbleStart(event: AnimationEvent) {
    console.log(event);
    if (event.fromState !== 'void') {
        this.renderer.addClass(event.element, 'invalid');
    }
}
```

It logs the old Angular [AnimationEvent](https://angular.dev/api/animations/AnimationEvent){:target="_blank"} and adds an "invalid" CSS class when the animation starts.  

This is all tied together in the HTML with and animation trigger along with animation "start" and "done" events.

### HTML Setup with Old Animation Triggers 

Here we have the “wobble” animation bound on this label element:

```html
<label [@wobble]="wobbleField()" ...>
    ...
</label>
```

This connects to the animation trigger we just saw.

It fires when the "wobbleField" signal is true.

This signal is toggled when we click this button if the form is invalid:

```html
<button
    (click)="form.valid ? formSubmitted.emit() : wobbleField.set(true)"
    ...>
    Continue
</button>
```

Then we have the old animation "done" event:

```html
<label ... (@wobble.done)="wobbleField.set(false)" ...>
    ...
</label>
```

Currently, this event fires when the animation is done and when this happens, we're setting the "wobbleField" signal back to false.

Then we have the "start" event which calls the “onWobbleStart()” function to log the event and set the "invalid" class:

```html
<label ... (@wobble.start)="onWobbleStart($event)" ...>
    ...
</label>
```

So, all of this is what I added in my original tutorial.

But now that the animations module is deprecated, let’s update this to a modern approach.

## Why Switch from Angular Animations to CSS

We’ll keep the same wobble effect, but instead of Angular’s animation DSL, we’ll use plain [CSS keyframes](https://developer.mozilla.org/en-US/docs/Web/CSS/@keyframes){:target="_blank"}.  

Then we’ll use the "wobbleField" signal to toggle the CSS class, and native DOM [animation events](https://developer.mozilla.org/en-US/docs/Web/API/AnimationEvent){:target="_blank"} to run our start and end logic.  

It’s simpler, future-proof, more versatile, and easier for new devs to understand.

## Step 1: Build the Wobble Effect with CSS Keyframes

To do this, first in [the component's CSS](https://stackblitz.com/edit/stackblitz-starters-mngxgefx?file=src%2Fsign-up-form%2Fsign-up-form.component.scss){:target="_blank"}, we’ll recreate the wobble animation sequence with keyframes:

```css
@keyframes wobble {
    0% { translate: 0 0; }
    10% { translate: -5% 0; }
    30% { translate: 5% 0; }
    50% { translate: -5% 0; }
    70% { translate: 5% 0; }
    90% { translate: -5% 0; }
    100% { translate: 0 0; }
}
```

Then we add a "wobble" class that runs this animation:

```css
.wobble {
    animation: wobble 0.75s;
}
```

This class will be bound whenever the "wobbleField" signal is true.

## Step 2: Replace Angular Trigger with CSS Class Binding

Back in the template, we swap out the old Angular animation trigger with a CSS class binding:

```html
<label [class.wobble]="wobbleField()" ...>
    ...
</label>
```

We can also remove the `(@wobble.start)` and `(@wobble.done)` events for now, just to test the class toggle first.

## Step 3: Remove Angular Animation Imports, Metadata, and App Include

Next, we clean up the TypeScript.

No more animations metadata in the component, and we delete the old imports for trigger, animate, style, and keyframes.  

Nice and clean.

Also, since Angular animations are gone completely, we can also remove `provideAnimationsAsync()` from [main.ts](https://stackblitz.com/edit/stackblitz-starters-mngxgefx?file=src%2Fmain.ts){:target="_blank"} along with its import.  

That drops the old module entirely from our app.

## Step 4: Testing the New CSS Animation (First Try)

Okay, that’s it. Let’s save everything and try it out:

<div>
<img src="{{ '/assets/img/content/uploads/2025/10-02/demo-2.gif' | relative_url }}" alt="The new demo application with the wobble animation built using pure CSS keyframes" width="860" height="872" style="width: 100%; height: auto;">
</div>

Clicking the button works once... the field wobbles, but it won’t fire again because the class never resets.  

And the red glow is missing too, because we’re no longer running the "invalid" class logic from the start event.  

Let’s fix that.

## Step 5: Add DOM animationstart and animationend Events

Back over in the HTML, while we can’t use the old animation "start" and "done" events, we can use native DOM animation events instead.

So, instead of the old "done" event, we’ll use the native [animationend](https://developer.mozilla.org/en-US/docs/Web/API/Element/animationend_event){:target="_blank"} event to reset the "wobbleField" signal so the animation can replay:

```html
<label ... (animationend)="wobbleField.set(false)" ...>
    ...
</label>
```

And instead of the old "start" event, we’ll use the native [animationstart](https://developer.mozilla.org/en-US/docs/Web/API/Element/animationstart_event){:target="_blank"} event to call the "onWobbleStart()" function again and apply the invalid class:

```html
<label ... (animationstart)="onWobbleStart($event)" ...>
    ...
</label>
```

## Step 6: Update onWobbleStart() for DOM Events

Now, let’s switch back to the TypeScript where we need to make a few changes to the "onWobbleStart()" method.

First, it used to take in an Angular AnimationEvent, but that’s gone now, so we’ll just switch to a regular [Event](https://developer.mozilla.org/en-US/docs/Web/API/Event){:target="_blank"} instead:

```typescript
protected onWobbleStart(event: Event) {
    ...
}
```

Then, we can drop the old unused check `if (event.fromState !== 'void')` since we're no longer using Angular's AnimationEvent.

After this, we just need to switch to `event.target`, passing it to [Renderer2](https://angular.dev/api/core/Renderer2){:target="_blank"} to apply the "invalid" class:

```typescript
protected onWobbleStart(event: Event) {
    ...
    this.renderer.addClass(event.target as Element, 'invalid');
}
```

## Final Test: Wobble Animation with CSS + Signals

Okay, that should be everything, let’s save and try again:

<div>
<img src="{{ '/assets/img/content/uploads/2025/10-02/demo-1.gif' | relative_url }}" alt="The final demo application with the wobble animation built using pure CSS keyframes and DOM events" width="860" height="928" style="width: 100%; height: auto;">
</div>

Now when we click, the field wobbles and highlights red again.  

And when we click again, it wobbles again.

Every time the signal resets, the class reapplies, and everything behaves like before.

## Conclusion: Modern Angular Animations with CSS

And that’s it... we’ve officially taken the old Angular animation event demo and brought it into the modern Angular era.  

If you're familiar with my original tutorial, this is the updated way you’d write it today.  

If you’re new here, be sure to subscribe, and let me know in the comments what other old Angular features you’d like me to revisit and modernize.  

Maybe we’ll wobble our way into another demo together!

{% include banner-ad.html %}

## Additional Resources
- [The demo app BEFORE any changes](https://stackblitz.com/edit/stackblitz-starters-mngxgefx?file=src%2Fsign-up-form%2Fsign-up-form.component.ts){:target="_blank"}
- [The demo app AFTER making changes](https://stackblitz.com/edit/stackblitz-starters-zr3njyd2?file=src%2Fsign-up-form%2Fsign-up-form.component.ts){:target="_blank"}
- [The original Angular Animation Events Video](https://youtu.be/OLtDcBG9M_4){:target="_blank"}
- [The updated Angular animations docs](https://angular.dev/guide/animations){:target="_blank"}
- [The Angular animations migration guide](https://angular.dev/guide/animations/migration){:target="_blank"}
- [Web Animations API docs](https://developer.mozilla.org/en-US/docs/Web/API/Web_Animations_API){:target="_blank"}
- [My course "Angular: Styling Applications"](https://www.pluralsight.com/courses/angular-styling-applications){:target="_blank"}
- [My course "Angular in Practice: Zoneless Change Detection"](https://app.pluralsight.com/library/courses/angular-practice-zoneless-change-detection){:target="_blank"}

## Want to See It in Action?

Want to experiment with the final version? Explore the full StackBlitz demo below. If you have any questions or thoughts, don’t hesitate to leave a comment.

<iframe src="https://stackblitz.com/edit/stackblitz-starters-zr3njyd2?ctl=1&embed=1&file=src%2Fsign-up-form%2Fsign-up-form.component.ts" style="height: 500px; width: 100%; margin-bottom: 1.5em; display: block;"></iframe>
