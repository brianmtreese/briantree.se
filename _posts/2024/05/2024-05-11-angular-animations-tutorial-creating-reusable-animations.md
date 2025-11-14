---
layout: post
title: "Angular Animations: Creating Reusable Animations!"
date: "2024-05-11"
video_id: "ObYCutiBOTo"
tags:
  - "Accessibility"
  - "Angular"
  - "Angular Animations"
  - "Angular Components"
---

<p class="intro"><span class="dropcap">A</span>s an Angular application grows over time, you probably find that you constantly need to refactor things so that shared concepts, logic, behavior, etcetera can be reused. You build things, then later down the road, you build something that needs to do something similar and now you want to breakout that concept so that it can be shared right? Well, animations in Angular are the same. Once you start building and using them, you probably find that you need to use them in multiple components. Well, in this post I’ll show you how to do this. Alright, let’s get to it.</p>

{% include youtube-embed.html %}

## Before We Get Started

Now, before we get too far along, it’s important to note that I’ve already created several posts focused on the animation framework in Angular. They cover the basics of setting up and using animations in Angular, creating state-based and [`enter`/`leave`](https://angular.io/guide/transition-and-triggers#aliases-enter-and-leave) animations, using the [`keyframes()`](https://angular.io/api/animations/keyframes), [`query()`](https://angular.io/api/animations/query), and [`stagger()`](https://angular.io/api/animations/stagger) functions to create more complex animation sequences, using the [`start`/`done`](https://angular.io/api/animations/AnimationEvent) animation events, creating animations that run in parallel versus in sequence, animating to unknown heights, and adding configurable animations with [`params`](https://angular.io/api/animations/AnimationOptions#params).

So, if any of those concepts are unfamiliar to you, you’ll probably want to check those posts out first so that you’re not lost in this post.

#### Angular Animation Tutorials:
- [Learn the Basics]({% post_url /2024/02/2024-02-09-angular-animations-tutorial-learn-the-basics %})
- [Enter and Leave Animations]({% post_url /2024/02/2024-02-16-angular-animations-tutorial-enter-and-leave %}) 
- [The Keyframes Function]({% post_url /2024/02/2024-02-23-angular-animations-tutorial-the-keyframes-function %})
- [Query and Stagger Function]({% post_url /2024/03/2024-03-01-angular-animations-tutorial-query-and-stagger %})
- [Start and Done Events]({% post_url /2024/03/2024-03-08-angular-animations-tutorial-start-and-done-events %})
- [Parallel Animations]({% post_url /2024/03/2024-03-15-angular-animations-tutorial-parallel-animations %})
- [Animating to an unknown height]({% post_url /2024/03/2024-03-29-angular-animations-tutorial-animating-height %})
- [Adding Flexibility with Params]({% post_url /2024/05/2024-05-04-angular-animations-tutorial-add-flexibility-with-params %})

And, to make them easier to find, I’ve created an [Angular Animations playlist](https://youtube.com/playlist?list=PLp-SHngyo0_ikgEN5d9VpwzwXA-eWewSM&si=3WnQgeDxdAZJGGFy) on my [YouTube channel](https://www.youtube.com/@briantreese) to help, so check it out!

Ok, enough of that, onto the example for this post.

## The Demo Application

Here we have [this application](https://stackblitz.com/edit/stackblitz-starters-nkmlih?file=src%2Fslider%2Fslider.component.ts) called Petpix. It’s an application where people share cool images of their pets. As you click to look through the images, you can see the nice transition forward as you navigate to the “next” image. And then, when you navigate backwards with the “previous” button you can see that it animates nicely in the opposite direction.

<div>
<img src="{{ '/assets/img/content/uploads/2024/05-11/demo-1.gif' | relative_url }}" alt="Example of an image gallery with sliding animation" width="592" height="641" style="width: 100%; height: auto;">
</div>

Now, if you want to learn in detail about how I created this animation, you’ll want to check out my [post on how to use Angular animation params]({% post_url /2024/05/2024-05-04-angular-animations-tutorial-add-flexibility-with-params %}) because we’re not really going to cover the animation itself in detail in this post.

Now, since we created the animation for that post, we’ve added the header to the application, and the header contains a hamburger menu. When we click on this menu button, we see our menu.

<div>
<img src="{{ '/assets/img/content/uploads/2024/05-11/demo-2.gif' | relative_url }}" alt="Example of the menu opening and closing without any animations" width="592" height="980" style="width: 100%; height: auto;">
</div>

So, that’s cool, but it doesn't look great when it opens. It would be better if we added some animation as it opens and closes, right? Since it’s opening from the right side of the viewport, it would be nice if it slid in as it opens, and then if it slid out when it closes.

Well, this is exactly what we’re going to do in this post. But instead of creating this animation all over again and bloating our code base, we’re going to take the slide left/right animation from our slider component and instead make it shared so that we can use it in the nav component too.

## Creating a Reusable Angular Animation

Ok, so let’s take a look at our animation in the component.ts, the animation that we’re now going to make shared.

#### slider.component.ts
```typescript
@Component({
    selector: 'app-slider',
    ...
    animations: [
        trigger('slideToggle', [
        transition('* => *', [
            group([
                query(':enter', style({ 
                    transform: 'translateX({{ enterStart }}) scale(0.25)' }), 
                    { optional: true }),
                query(':leave', [
                    animate('750ms ease-in-out', 
                    style({ 
                        transform: 'translateX({{ leaveEnd }}) scale(0.25)' 
                    }))
                ], { optional: true }),
                query(':enter', [
                    animate('750ms ease-in-out', 
                    style({ 
                        transform: 'translateX(0) scale(1)' 
                    }))
                ], { optional: true })
                ])
            ],
            { 
                params: {
                    leaveEnd: '',
                    enterStart: ''
                }
            })
        ])
    ]
})
```

When creating a reusable animation, we create it in a separate file that we can then just import from. So, we'll add directory named “animations” to our project. Then, within that directory we'll add file named slide.animation.ts for our new shared animation.

<div>
<img src="{{ '/assets/img/content/uploads/2024/05-11/animationdirectory-and-file.png' | relative_url }}" alt="Example of the new animations directory and slide animation file" width="592" height="980" style="width: 100%; height: auto;">
</div>

When we create a reusable animation, we create it as an exportable `const` that we can then just import, so let’s add a const named “slideAnimation” and to set this const, we’re going to use the [`animation()`](https://angular.io/api/animations/animation) function from the Angular animations module. This function takes in an array of animation steps, so we can copy everything within the transition function from the slider.component.ts, and paste it here. We also need to make sure all of the stuff we’re using from the animations module is properly imported here in this file too.

Ok, at this point we now have a reusable animation. But, in the original animation we have some params that allow us to pass an “enterStart” and an “leaveEnd” translate value.

But, we also had a hard-coded scale value that works nicely in the slider component, but the thing is, we don’t want our menu to scale at all as it animates, we just want it to slide in and out. That’s it. So, what I’m going to do is convert this scale to a parameter too. We'll call it “hiddenScale”.

#### slide.animation.ts
```typescript
import { animate, animation, group, query, style } from "@angular/animations";

export const slideAnimation = animation([
  group([
    query(':enter', style({ transform: 'translateX({{ enterStart }}) scale({{ hiddenScale }})' }), { optional: true }),
    query(':leave', [
      animate('750ms ease-in-out', style({ transform: 'translateX({{ leaveEnd }}) scale({{ hiddenScale }})' }))
    ], { optional: true }),
    query(':enter', [
      animate('750ms ease-in-out', style({ transform: 'translateX(0) scale(1)' }))
    ], { optional: true })
  ])
])
```

Ok, that’s all we need. Now let’s go swap this out in our slider component.

## Using a Reusable Angular Animation

We can start by removing everything within the [`transition()`](https://angular.io/api/animations/transition) function, the imports that are no longer needed, and we can remove the [`params`](https://angular.io/api/animations/AnimationOptions#params) object from the [`transition()`](https://angular.io/api/animations/transition) since they will now be part of the shared animation.

Now, to use our new animation, we will use the [`useAnimation()`](https://angular.io/api/animations/useAnimation) function from the animations module. And then, all we need to do is pass this function our exported “slideAnimation” const.

#### slider.component.ts
```typescript
import { ..., useAnimation } from '@angular/animations';

@Component({
    selector: 'app-slider',
    ...
    animations: [
        trigger('slideToggle', [
            transition('* => *', [
                useAnimation(slideAnimation)
            ])
        ])
    ]
})
```

Ok, almost there. All that’s left now is to go and make sure our animation `params` are being properly passed to our animation in the template. So, both our “leaveEnd” and our “enterStart” params can stay as is but remember that we added a “hiddenScale” param that we need to set here.

#### slider.component.html
```html
<div
    [@slideToggle]="{
        value: selectedImage(),
        params: {
            leaveEnd: animationDirection() === 'right' ? '100%' : '-100%',
            enterStart: animationDirection() === 'right' ? '-100%' : '100%',
            hiddenScale: 0.25
        }
    }">
  ...
</div>
```

There, that should be all we need. Now, if we got it right, after we save, the slider should work exactly as it did.

## Adding the Reusable Animation to the Navigation Component

Next up, we have the whole purpose for creating the shared animation. To make our nav component transition as it’s toggled opened and closed. Let’s switch to the code for our header component because that’s where our navigation component is toggled.

In the template, we have the condition using a “showMenu()” [`signal`](https://angular.io/guide/signals) to toggle the menu. If it’s true it’ll show, if not, it won’t.

#### header.component.html
```html
<div>
    @if (showMenu()) {
        <app-nav (close)="showMenu.set(false)"></app-nav>
    }
</div>
```

Since our animation queries for elements entering and leaving, we’ll bind our animation on the div that wraps the 'app-nav' element. Let’s call the trigger “slideToggle” like we had in our slider component. It doesn’t have to be named the same, but I like that name for this animation trigger.

Then, we’ll want to run this animation every time the “showMenu()” [`signal`](https://angular.io/guide/signals) value changes, so we’ll use that as our value. After that we need to add our “params” object. Within this object, we need our “leaveEnd” param, it’ll be 100% so that it ends outside of the viewport, to the right when it’s closed. Then we can add our “enterStart” param which will also be 100% because, when it’s opening, it will start outside the right edge of the viewport too.

Then, we can add our “hiddenScale” param. In this case, since we don’t want it to scale as it animates, we’ll give it a value of one.

```html
<div
    [@slideToggle]="{
        value: showMenu(),
        params: {
            leaveEnd: '100%',
            enterStart: '100%',
            hiddenScale: 1
        }
    }">
    @if (showMenu()) {
        <app-nav (close)="showMenu.set(false)"></app-nav>
    }
</div>
```

Ok, now we just need to create and import our animation so let’s switch over to the header.component.ts. First, we need to add the `animations` metadata array and then within this array we need to add our “slideToggle” trigger using the [`trigger()`](https://angular.io/api/animations/trigger) function.

Then, we add our transition which will run whenever the “showMenu” value changes using the [`transition()`](https://angular.io/api/animations/transition) function. Then within this transition, we can include the “slideAnimation” using the [`useAnimation()`](https://angular.io/api/animations/useAnimation) function from the animations module.

#### header.component.ts
```typescript
import { transition, trigger, useAnimation } from "@angular/animations";

@Component({
    selector: 'app-header',
    ...
    animations: [
        trigger('slideToggle', [
            transition('* => *', [
                useAnimation(slideAnimation)
            ])
        ])
    ]
})
```

And that should be everything. If we click the hamburger button to toggle the menu now, it it transitions like we want. And if we close it, it should slide out now too.

<div>
<img src="{{ '/assets/img/content/uploads/2024/05-11/demo-3.gif' | relative_url }}" alt="Example of the menu opening and closing width reusable slide animations" width="592" height="980" style="width: 100%; height: auto;">
</div>

{% include banner-ad.html %}

## Conclusion

So, it’s nice that we didn’t need to create a whole new animation within the header component to pull off a very similar animation style to our image slider. Just like everything else, it’s better if we can share and reuse similar concepts. So, hopefully this will help you out as you add more and more animations to your Angular projects. 

Now, believe it or not, there’s still more to Angular animations outside of all of the posts that I’ve already created on them so far. So, we’ll go ahead and call it for this post, but be on the lookout for more on animations in the future.

## Want to See It in Action?
Check out the demo code and examples of these techniques in the Stackblitz example below. If you have any questions or thoughts, don’t hesitate to leave a comment.

<iframe src="https://stackblitz.com/edit/stackblitz-starters-1z78ab?ctl=1&embed=1&file=src%2Fanimations%2Fslide.animation.ts" style="height: 500px; width: 100%; margin-bottom: 1.5em; display: block;">
