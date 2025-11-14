---
layout: post
title: "Angular Animations: Keyframe Animations"
date: "2024-02-23"
video_id: "w7uylEcAtJ8"
tags:
  - "Accessibility"
  - "Angular"
  - "Angular Animations"
  - "Angular Styles"
  - "CSS"
---

<p class="intro"><span class="dropcap">A</span>s you probably already know, when you build apps today, you’ll likely need to use animations and transitions to enhance the UI where possible. With Angular’s animation framework we have access to some pretty powerful features which allow us to do things that may not be possible with CSS alone. In this post we’re going to look at a little, fun and crazy example using the Angular <code>keyframes()</code> animation function. Alright, let’s get to it!</p>

{% include youtube-embed.html %}

Before we get too far along, it’s important to note here that I’ve already created a couple of posts focused on the animation framework. First, I’ve got an [animation basics post]({% post_url /2024/02/2024-02-09-angular-animations-tutorial-learn-the-basics %}) where I cover how to include the animations module and then how to use some of the basic functions of the API to create a simple state-based animation.

Then [I’ve got a post]({% post_url /2024/02/2024-02-16-angular-animations-tutorial-enter-and-leave %}) where we build off the example in the first post and change to animate items as they are added to and removed from the DOM with the `:enter` and `:leave` aliases. So, if you’re not familiar with these concepts, the examples in this post might not make as much sense as they would if you were to watch them first.

#### Angular Animation Tutorials:
- [Learn the Basics]({% post_url /2024/02/2024-02-09-angular-animations-tutorial-learn-the-basics %})
- [Enter and Leave Animations]({% post_url /2024/02/2024-02-16-angular-animations-tutorial-enter-and-leave %})

Ok, onto the example for this post.

## The Demo Application

We’ve been working on this demo application for the Vans shoe brand. We have this menu that we’ve set up to transition in from the right when it’s opened and then out to the right when it’s closed.

<div>
<img src="{{ '/assets/img/content/uploads/2024/02-23/ease-animation.gif' | relative_url }}" alt="Example of a menu animating open with an easing animation" width="750" height="826" style="width: 100%; height: auto;">
</div>

What we want to do now is, we want to change this animation to something a little more crazy like this where it has multiple different things going on as it transitions from one state to another.

<div>
<img src="{{ '/assets/img/content/uploads/2024/02-23/flip-animation.gif' | relative_url }}" alt="Example of a menu animating open with a crazy flipping animation" width="748" height="828" style="width: 100%; height: auto;">
</div>

I know this is a pretty crazy example and we probably wouldn’t really want to do this sort of thing in the real world, but in this case, it’s a perfect opportunity to explore the keyframes() function.

## How the Angular Animation `keyframes()` Function Works

This function is yet another powerful piece of the animations API. It accepts a parameter of `steps`. These steps consist of an array of `AnimationStyleMetadata` objects which are essentially objects of styles for each keyframe step.

```typescript
  keyframes(steps: AnimationStyleMetadata[]) {}
```

## Converting an Existing Basic Open Transition to a More Complex Keyframe Animation

Ok, let’s start by modifying our existing animation to use keyframes to see if we can pull off this crazy animation. Here we can see the `:enter` and `:leave` animation that we added in the previous post.

#### main.ts
```typescript
const hidden = { transform: 'translateX(120%)' };
const visible = { transform: 'translateX(0)' };
const timing = '1s ease-in';
...

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

There’s no need for us to change this away from an `:enter` and `:leave` animation so we’ll leave that aspect alone for now. Let’s start with the `:enter` transition. We can remove the old `style()` function because it’s not needed with the way keyframes work. To use the `keyframes()` function, we still need to use the `animation()` function. So we can add the `keyframes()` function as the second parameter, and we need to be sure that it gets imported too.

```typescript
import { ..., keyframes } from '@angular/animations';

animations: [
    trigger('openClose',[
        transition(':enter', [
            animate(timing, keyframes())
        ]),
        ...
    ])
]
```

### Adding Steps to the `keyframes()` Function With the Animations `style()` Function

Ok so we need to pass this function an array of steps.And guess what, these steps are going to look super familiar from our previous examples because we use the `style()` function to define the styles for each step in our animation.

To pull off this animation, we should be able to do it all with transforms, so let’s add a `transform`.  We’ll pass it the transform styles as a string. We need it to start off the screen to the right so let’s go with a `translateX` of one hundred twenty percent like we used in our old example. Also, let’s add a `scale` of point five to shrink it down.

```typescript
animations: [
    trigger('openClose',[
        transition(':enter', [
            animate(timing, keyframes([
                style({ transform: 'translateX(120%) scale(0.5)' })
            ]))
        ]),
        ...
    ])
]
```

Ok, that’s our first step. For the second step, let’s bring it into our page before we rotate it. Let’s go ahead and duplicate our first step. Then, let’s change our `translateX` value to negative one hundred twenty percent this time. And we’ll leave the scale as is.

```typescript
animations: [
    trigger('openClose',[
        transition(':enter', [
            animate(timing, keyframes([
                ...
                style({ transform: 'translateX(-120%) scale(0.5)' })
            ]))
        ]),
        ...
    ])
]
```

Let’s duplicate this step now. This is going to be the step where we rotate the menu. So, we’ll leave the `translateX` value at negative one twenty. Let’s increase the `scale` a little to zero point six five. And now, let’s add a `rotate` function. Here, we’ll rotate the menu three hundred and sixty degrees to rotate in a complete circle.

```typescript
animations: [
    trigger('openClose',[
        transition(':enter', [
            animate(timing, keyframes([
                ...
                style({ transform: 'translateX(-120%) scale(0.65) rotate(360deg)' })
            ]))
        ]),
        ...
    ])
]
```

Ok, for the last step, let’s duplicate this again. Here we’ll want to `translate` to our final position, so we’ll give it a value of zero. We’ll also want to scale to our final value, so we’ll give it a value of one. And, we’ll leave the `rotate` as is because if we were to remove it, the menu would rotate back to zero which we don’t want it to do.

```typescript
animations: [
    trigger('openClose',[
        transition(':enter', [
            animate(timing, keyframes([
                ...
                style({ transform: 'translateX(0) scale(1) rotate(360deg)' })
            ]))
        ]),
        ...
    ])
]
```

Ok, let’s save this and see how we did.

<div>
<img src="{{ '/assets/img/content/uploads/2024/02-23/flip-animation.gif' | relative_url }}" alt="Example of a menu animating open with a crazy flipping animation" width="748" height="828" style="width: 100%; height: auto;">
</div>

Ok, that looks great, much like the original example. One thing I don’t like though is that I feel like the rotation happens really fast. Id rather slow down that chunk of the animation. Well, with `CSS` keyframes this is possible because we can just adjust the percentage of time a specific range in a keyframe animation will take.

Well, we can do the same with the `keyframes()` function. As part of the `AnimationStyleMetadata` object, we have an offset property that we can use. This defines the point in the animation where the style change occurs.

## Altering the Timing of the Keyframes With the Offset Property

When we leave the offsets off like we did here, each change is offset an equal amount. So, the first change happens at an offset of zero. The second change occurs at an offset of point three, three. The third change occurs at an offset of point six, six. And the final change occurs at one.

```typescript
animations: [
    trigger('openClose',[
        transition(':enter', [
            animate(timing, keyframes([
                style({ transform: 'translateX(120%) scale(0.5)', offset: 0 }),
                style({ transform: 'translateX(-120%) scale(0.5)', offset: 0.33 }),
                style({ transform: 'translateX(-120%) scale(0.65) rotate(360deg)', offset: 0.66 }),
                style({ transform: 'translateX(0) scale(1) rotate(360deg)', offset: 1 })
            ]))
        ]),
        ...
    ])
]
```

So, let’s change these a little so the rotation period takes a little longer. We’ll leave the first step at zero, but we’ll change the second step to zero point one so that it’ll happen much quicker. Also, let’s adjust the third step so that it takes a little longer, let’s go with point six instead.

```typescript
animations: [
    trigger('openClose',[
        transition(':enter', [
            animate(timing, keyframes([
                style({ transform: 'translateX(120%) scale(0.5)', offset: 0 }),
                style({ transform: 'translateX(-120%) scale(0.5)', offset: 0.1 }),
                style({ transform: 'translateX(-120%) scale(0.65) rotate(360deg)', offset: 0.6 }),
                style({ transform: 'translateX(0) scale(1) rotate(360deg)', offset: 1 })
            ]))
        ]),
        ...
    ])
]
```

Ok, let’s save and try this again.

<div>
<img src="{{ '/assets/img/content/uploads/2024/02-23/flip-animation.gif' | relative_url }}" alt="Example of a menu animating open with a crazy flipping animation" width="748" height="828" style="width: 100%; height: auto;">
</div>

Nice, that’s a little better. It’s pretty subtle but you get the point right? You can adjust the keyframe durations as needed for your animations. Ok, let’s add the close animation now.

## Adding the Close Keyframe Animation in Reverse Order

We can start by copying our open animation, and we’ll paste that over our existing close animation code. Then we pretty much just need to reverse the order here to do the opposite transition on close.

So, let’s move the last step to the top and we’ll switch its offset to zero. Then, let’s move up the rotation step, and then change its offset to zero point one. Then, we need to flip the last two steps and update their offsets too.

```typescript
animations: [
    trigger('openClose',[
        ...,
        transition(':leave', [
            animate(timing, keyframes([
                style({ transform: 'translateX(0) scale(1) rotate(360deg)', offset: 0 }),
                style({ transform: 'translateX(-120%) scale(0.65) rotate(360deg)', offset: 0.1 }),
                style({ transform: 'translateX(-120%) scale(0.5)', offset: 0.6 }),
                style({ transform: 'translateX(120%) scale(0.5)', offset: 1 })
            ]))
        ])
    ])
]
```

Ok, now that we have these inverted, let’s save and see if we got it right.

<div>
<img src="{{ '/assets/img/content/uploads/2024/02-23/flip-animation.gif' | relative_url }}" alt="Example of a menu animating open and closed with a crazy flipping animation" width="676" height="894" style="width: 100%; height: auto;">
</div>

Nice, looks right when we close now, right? So again, this is a pretty crazy example. It’s really just used, in this case, to illustrate how keyframes work in Angular. I don’t recommend that you make menus that transition like this in production applications. But now, at least, you should have an understanding of how keyframes() can be used.

{% include banner-ad.html %}

Now, just like I mentioned in the last two posts on Angular Animations, there’s a lot to the animation framework so I’ll go ahead and stop here for now, but I will be creating several more posts covering much more on Angular animations very soon. 

## Want to See It in Action?
Check out the demo code and examples of these techniques in the stackblitz example below. If you have any questions or thoughts, don’t hesitate to leave a comment.

<iframe src="https://stackblitz.com/edit/stackblitz-starters-m74cri?ctl=1&embed=1&file=src%2Fmain.ts" style="height: 500px; width: 100%; margin-bottom: 1.5em; display: block;">
