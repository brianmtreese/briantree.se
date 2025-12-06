---
layout: post
title: "Angular CDK Overlay Animations: Animate Open and Close Transitions (v19+)"
date: "2024-01-26"
video_id: "JEKQ21mXyA0"
tags:
  - "Angular"
  - "Angular CDK"
  - "Angular Directives"
  - "Angular Styles"
  - "Animations"
  - "CDK Overlay"
  - "CSS"
---

<p class="intro"><span class="dropcap">A</span>dding smooth open and close animations to Angular CDK Overlays requires Angular's animation framework. CSS transitions alone won't work because overlays are dynamically inserted and removed from the DOM. In this tutorial, you'll learn why <code>:enter</code>/<code>:leave</code> animations fail for overlays, how to use state-based animations instead, coordinate animation completion with overlay detachment, and leverage <code>transform-origin</code> for more natural animations. This guide builds on CDK Overlay basics, positioning, and scroll strategies. All examples work with Angular v19+.</p>

{% include youtube-embed.html %}

{% capture banner_message %}This post uses Angular's deprecated animations module. For modern animation approaches, see: <a href="{% post_url 2025/09/2025-09-04-angular-20-modern-advanced-animation-concepts %}">Modern Angular Animations: Ditch the DSL, Keep the Power</a>, <a href="{% post_url 2025/07/2025-07-31-angulars-new-enter-leave-animation-api %}">Angular Enter/Leave Animations in 2025: Old vs New</a>, or <a href="{% post_url 2025/10/2025-10-02-modern-angular-animation-start-done-events %}">Modern Angular Animation Start/Done Events</a>.{% endcapture %}
{% include update-banner.html title="Note" message=banner_message %}

#### Angular CDK Overlay Tutorial Series:
- [Learn the Basics]({% post_url /2024/01/2024-01-05-angular-cdk-overlay-tutorial-learn-the-basics %}) - Start here for overlay fundamentals
- [How Positioning Works]({% post_url /2024/01/2024-01-12-angular-cdk-overlay-tutorial-positioning %}) - Learn custom positioning strategies
- [Scroll Strategies]({% post_url /2024/01/2024-01-19-angular-cdk-overlay-tutorial-scroll-strategies %}) - Control overlay behavior during scrolling
- [Adding Accessibility]({% post_url /2024/02/2024-02-02-angular-cdk-overlay-tutorial-adding-accessibility %}) - Make overlays accessible with ARIA and focus management

Ok, before we get too far along, I've created several posts on the Angular CDK Overlay module where I demonstrate how to setup overlays for some common scenarios, how they are positioned, and how they react when scrolling the containers they are contained within.

So, if you’re new to these concepts, you’ll probably want to check them out first because everything we’ll see in this post will build off the concepts from those videos.

## The Demo Application

Ok, here we have the example that we’ve been working on throughout the videos on the Overlay module.

<div>
<img src="{{ '/assets/img/content/uploads/2024/01-26/demo-application.gif' | relative_url }}" alt="Demo application using Angular CDK Overlay to create a pop-up with the cdkScrollable directive" width="680" height="540" style="width: 100%; height: auto;">
</div>

It’s a list of NBA players and when we click the button on the right, we get a pop-up that’s created with the Overlay module with more details about the player. It works well, but we want to ease in the pop-up when it opens and then we want to ease it out when it closes. This should be easy right?

## Using an Angular `:enter` and `:leave` Animation to Animate the CDK Overlay

If you’ve used Angular animations in the past, you’d probably expect to use a simple `:enter` and `:leave` animation. This type of animation in Angular allows us to animate items that are physically entering into and out of the DOM. This is something that CSS currently does not support.

So, let’s try this and see what happens.

### Creating an :enter/:leave Animation in the Component Animations Metadata

Let's start by adding the animations array. Within this array, let’s add a trigger, we’ll call it “animation”.

#### player-details.component.ts

```typescript
@Component({
    selector: 'app-player-details',
    ...
    animations: [
        trigger('animation', [
        ])
    ]
})
```

Then let’s add a transition for our `:enter` event. Well use the `style()` method to add the style we’ll start from. We’ll add a style object where we’ll start from an opacity of zero. And, we’ll start from a scale of point eight. Then, we’ll use the `animate()` method, for the timings we’ll use a duration of zero point one five seconds and we’ll use `ease-in-out` for our timing function. And we’ll animate to another style object. This time we’ll be transitioning to an opacity of one and a scale of one as well.

```typescript
@Component({
    selector: 'app-player-details',
    ...
    animations: [
        transition(':enter', [
            style({
                opacity: 0,
                transform: 'scale(0.8)'
            }),
            animate('0.15s ease-in-out', style({
                opacity: 1,
                transform: 'scale(1)'
            }))
        ])
    ]
})
```

Now we’ll add another transition for our :leave state. This time we’ll start from our open state with a style object containing an opacity of one and a scale of one too. Then we’ll add another animation function. We’ll add the same timing, zero point one five seconds with an `ease-in-out` timing function. We’ll add another style object to animate to an opacity of zero and a scale of zero point eight, so the inverse of our enter animation.

```typescript
@Component({
    selector: 'app-player-details',
    ...
    animations: [
        trigger('animation', [
            transition(':enter', [
                style({
                    opacity: 0,
                    transform: 'scale(0.8)'
                }),
                animate('0.15s ease-in-out', style({
                    opacity: 1,
                    transform: 'scale(1)'
                }))
            ]),
            transition(':leave', [
                style({
                    opacity: 1,
                    transform: 'scale(1)'
                }),
                animate('0.15s ease-in-out', style({
                    opacity: 0,
                    transform: 'scale(0.8)'
                }))
            ])
        ])
    ]
})
```
### Binding the Animation to the Component Host Using Host Metadata

Ok, now we have the animation setup, but we need to bind it to our player details host element. We'll use the `host` property in the component metadata to bind the animation trigger. We'll create an "animationState" property and set it to true so that our animation will properly be bound on the host.

```typescript
@Component({
    selector: 'app-player-details',
    ...
    host: {
        '[@animation]': 'animationState'
    },
    ...
})
export class PlayerDetailsComponent {
    animationState = true;
}
```

Ok, now let’s check this out and see what happens.

<div>
<img src="{{ '/assets/img/content/uploads/2024/01-26/demo-close-animation-not-working.gif' | relative_url }}" alt="Angular CDK Overlay pop-up with the using :enter and :leave animations" width="678" height="540" style="width: 100%; height: auto;">
</div>

Nice, the animation on open looks great but when we close it looks like it didn’t animate. And, this is because a leave event didn’t fire for this inner component that we’re trying to animate. The overlay is destroyed and removed before the close animation can run. The overlay is detached before the animation completes.

We need to complete the close animation before the overlay is detached. So, we’re going to need to do this a different way.

## Using an Angular State-based Animation to Animate the CDK Overlay

What we can do here is actually switch to a state-based animation. We’ll go with a concept of having a “hidden” state and a “visible” state for our overlay content.

### Creating a State-based Animation in the Component Animations Metadata

Let’s remove the code for the :enter/:leave animation and then replace it with our hidden state. We’ll add a style object with opacity zero and scale of zero point eight.

```typescript
@Component({
    selector: 'app-player-details',
    ...
    animations: [
        trigger('animation', [
            state('hidden', style({
                opacity: 0,
                transform: 'scale(0.8)'
            })
        ])
    ]
})
```

Then we’ll add another state call for our visible state. This state will have a style object with opacity of one and a scale of one as well.

```typescript
@Component({
    selector: 'app-player-details',
    ...
    animations: [
        trigger('animation', [
            state('hidden', style({
                opacity: 0,
                transform: 'scale(0.8)'
            }),
            state('visible', style({
                opacity: 1,
                transform: 'scale(1)'
            }))
        ])
    ]
})
```

Alright, now we just need to add the transition between these states, so let’s add the transition function. And we’ll transition between hidden and visible states. We’ll also animate this transition with the animation function. Our animation will run over zero point one five seconds and will use an `ease-in-out` timing function.

```typescript
@Component({
    selector: 'app-player-details',
    ...
    animations: [
        trigger('animation', [
            state('hidden', style({
                opacity: 0,
                transform: 'scale(0.8)'
            }),
            state('visible', style({
                opacity: 1,
                transform: 'scale(1)'
            })),
            transition('hidden <=> visible', animate('0.15s ease-in-out'))
        ])
    ]
})
```

Ok, now for this animation to work correctly, we'll need to switch our `animationState` from a Boolean to a hidden/visible string instead, so we'll initialize it to hidden.

```typescript
@Component({
    selector: 'app-player-details',
    ...
    host: {
        '[@animation]': 'animationState'
    },
    ...
})
export class PlayerDetailsComponent {
    animationState = 'hidden';
}
```

### Triggering the State-based Animation When Opening and Closing the CDK Overlay

Now, when the component is created, we'll set this property to visible which will then trigger the open animation to run. We can use the `afterNextRender` function to set the animation state after the view is initialized.

```typescript
import { afterNextRender } from '@angular/core';

@Component({
    selector: 'app-player-details',
    ...
    host: {
        '[@animation]': 'animationState'
    },
    ...
})
export class PlayerDetailsComponent {
    animationState = 'hidden';

    constructor() {
        afterNextRender(() => {
            this.animationState = 'visible';
        });
    }
}
```

That will trigger the animation on open. Now, we need to handle the close. To do this, we need to do a few things.

First, let's add a public close method. Inside of this method, let's set our animationState to hidden.

```typescript
export class PlayerDetailsComponent {
    animationState = 'hidden';
    closed = output<void>();

    constructor() {
        afterNextRender(() => {
            this.animationState = 'visible';
        });
    }

    close() {
        this.animationState = 'hidden';
    }

    handleAnimationDone(event: AnimationEvent) {
        if (event.toState === 'hidden') {
            this.closed.emit();
        }
    }
}
```

Ok, now in our player component that opens this pop-up, we need to be able to access the instance of our player details component so that we can call the close method that we just added.

We'll use the signal query function `viewChild()` to do this. We'll pass it the `PlayerDetailsComponent` class, and we'll name this property `detailsComponent`.

#### player.component.ts

```typescript
import { viewChild } from '@angular/core';

export class PlayerComponent {
    detailsComponent = viewChild.required(PlayerDetailsComponent);
    ...
}
```

Ok, now in our component template, in the `overlayOutsideClick` event, we'll now call our `detailsComponent().close()` method instead of setting our `detailsOpen` property to false. Since `detailsComponent` is now a signal, we need to call it as a function.

#### player.component.html

```html
<ng-template
    cdkConnectedOverlay
    ...
    (overlayOutsideClick)="detailsComponent().close()">
</ng-template>
```

So, this will trigger the close animation to run but it will not actually detach the overlay. In order to properly detach the overlay, we need to wait until the close animation completes and then notify the player component so that it can properly detach the overlay.

### Using the Angular Animation Done Event and the output() Function to Close the CDK Overlay

So, back over in the player details component, we need to add an output that will emit when the animation completes. We'll use the `output()` function to create a void output. We'll fire it when the close animation completes.

#### player-details.component

```typescript
import { output } from '@angular/core';

@Component({
    selector: 'app-player-details',
    ...
    host: {
        '[@animation]': 'animationState',
        '(@animation.done)': 'handleAnimationDone($event)'
    },
    ...
})
export class PlayerDetailsComponent {
    animationState = 'hidden';
    closed = output<void>();

    constructor() {
        afterNextRender(() => {
            this.animationState = 'visible';
        });
    }

    handleAnimationDone(event: AnimationEvent) {
        if (event.toState === 'hidden') {
            this.closed.emit();
        }
    }
    ...
}
```

The last thing we need to do is detach the overlay when this event fires. So, let’s go back to the player component template. On our player details component, let’s add our closed event. When it fires, we’ll set the `detailsOpen` property to false.

```html
<ng-template
    cdkConnectedOverlay
    ...>
    <app-player-details [player]="player" (closed)="detailsOpen = false"></app-player-details>
</ng-template>
```

Ok, now it will still transition as it opens and it will now transition when when it closes too.

Cool, so now we have a working open and close animation for our pop-ups but we can make it even better.

### Making the Animation Better With the `cdkConnectedOverlayTransformOriginOn` @Input

The `cdkConnectedOverlay` directive provides the ability for us to specify the item to place a `transform-origin` on in order to better animate the overlay from the origin element. To do this we can add the `cdkConnectedOverlayTransformOriginOn` `@Input` and in this case we are animating the `app-player-details` element so we’ll set that as the selector for this input.

```html
<ng-template
    cdkConnectedOverlay
    ...
    cdkConnectedOverlayTransformOriginOn="app-player-details">
</ng-template>
```

Nice, now our pop-up will animate from and to the attachment point on the origin.

{% include banner-ad.html %}

Ok, so now you know how to animate the opening and closing of overlays. I hope this helps you as you build out modals, pop-ups, tool tips and similar items in your angular apps. Keep an eye out for more videos on the Overlay module in the future.

## Want to See It in Action?
Check out the demo code and examples of these techniques in the stackblitz example below. If you have any questions or thoughts, don’t hesitate to leave a comment.

<iframe src="https://stackblitz.com/edit/stackblitz-starters-hi2gdg?ctl=1&embed=1&file=src%2Fplayer%2Fplayer-details%2Fplayer-details.component.ts" style="height: 500px; width: 100%; margin-bottom: 1.5em; display: block;">
