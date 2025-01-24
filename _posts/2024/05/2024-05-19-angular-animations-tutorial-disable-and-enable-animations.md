---
layout: post
title: "Angular Animations: Disable/Enable Animations"
date: "2024-05-19"
video_id: "dzeJGyGI4BY"
tags: 
  - "Angular"
  - "Angular Animations"
---

<p class="intro"><span class="dropcap">I</span>’m willing to bet, that if you’ve spent very much time working with Angular animations, you’ve had the need or desire to disable them for one reason or another. Something that I encounter quite a bit are animations that run on component initialization. I may only expect them to run when an interaction occurs, or when data changes, or something along those lines. I don’t expect them to run on initialization, but they do anyway. Well, this is something that I’m going to show you how to fix in this post. Alright, let’s get to it.</p>

<iframe width="1280" height="720" src="https://www.youtube.com/embed/dzeJGyGI4BY" title="" frameborder="0" allow="accelerometer; autoplay; clipboard-write; encrypted-media; gyroscope; picture-in-picture; web-share" allowfullscreen></iframe>

## Before We Get Started

Now, before we get too far along, it’s important to note that I’ve already created several posts focused on the animation framework in Angular.

#### Angular Animation Tutorials:
- [Learn the Basics]({% post_url /2024/02/2024-02-09-angular-animations-tutorial-learn-the-basics %})
- [Enter and Leave Animations]({% post_url /2024/02/2024-02-16-angular-animations-tutorial-enter-and-leave %}) 
- [The Keyframes Function]({% post_url /2024/02/2024-02-23-angular-animations-tutorial-the-keyframes-function %})
- [Query and Stagger Function]({% post_url /2024/03/2024-03-01-angular-animations-tutorial-query-and-stagger %})
- [Start and Done Events]({% post_url /2024/03/2024-03-08-angular-animations-tutorial-start-and-done-events %})
- [Parallel Animations]({% post_url /2024/03/2024-03-15-angular-animations-tutorial-parallel-animations %})
- [Animating to an unknown height]({% post_url /2024/03/2024-03-29-angular-animations-tutorial-animating-height %})
- [Adding Flexibility with Params]({% post_url /2024/05/2024-05-04-angular-animations-tutorial-add-flexibility-with-params %})
- [Creating Reusable Animations]({% post_url /2024/05/2024-05-11-angular-animations-tutorial-creating-reusable-animations %})

These posts cover many different animation topics so if any of these concepts look unfamiliar to you, you’ll probably want to check these posts out first so that you’re not lost in this example.

And, to make them easier to find, I’ve created an [Angular Animations playlist](https://youtube.com/playlist?list=PLp-SHngyo0_ikgEN5d9VpwzwXA-eWewSM&si=3WnQgeDxdAZJGGFy) on my [YouTube channel](https://www.youtube.com/@briantreese) to help, so check it out!

Ok, enough of that, onto the example for this post.

## The Demo Application

Here, we’ll be using this Petpix demo application where people share cool images of their pets. As you click to look through the images, you can see the nice transition forward as you navigate to the “next” image. Then, when you navigate backwards with the “previous” button you can see that it animates nicely in the opposite direction.

<div>
<img src="{{ '/assets/img/content/uploads/2024/05-19/demo-1.gif' | relative_url }}" alt="Example of an image gallery with sliding animation" width="594" height="696" style="width: 100%; height: auto;">
</div>

So, this animation is cool when navigating between the images, but there is something happening that we don’t want. If we reload the application, we can see that the animation runs when the component is initialized.

<div>
<img src="{{ '/assets/img/content/uploads/2024/05-19/demo-2.gif' | relative_url }}" alt="Example of animation running on initialization" width="594" height="696" style="width: 100%; height: auto;">
</div>

We don’t want this, instead we only want it to run when navigating through the images. So, this is what we’re going to do in this post. We’re going to disable the animation until after the component fully renders, and then we’ll enable it.

## Disabling Animations with the Disabled Animation Control Binding

Now, luckily for us, there’s a pretty simple way to do this built right into the framework. We can use a special [[@.disabled]](https://angular.io/guide/transition-and-triggers#disable-an-animation-on-an-html-element) animation control binding. When this binding is bound with a value of true, it will prevent any animations from running on the element with the binding as well as any nested elements.

So, let’s take a look at our code. Here, in the template for the [slider component](https://stackblitz.com/edit/stackblitz-starters-cyh1p9?file=src%2Fslider%2Fslider.component.html), we have an animation called “slideToggle” bound on the div that contains all of the images.

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
    }"
    class="image">
    ...
</div>
```

So this is where we’ll add our disabled binding, but before we do, we need to add a Boolean property to bind it to. So let’s switch to the slider.component.ts and let’s add a protected property called “animationDisabled”. We'll make it a [`signal`](https://angular.io/guide/signals) with an initial value of true.

#### slider.component.ts
```typescript
import { ..., signal } from "@angular/core";

@Component({
  selector: 'app-slider',
  ...
})
export class SliderComponent {
    protected animationDisabled = signal(true);
}
```

Ok, now we have the property, next we need to enable it after the component has completed its initial render. There are many ways we can do this, but for this example we’re going to use the [`afterNextRender()`](https://angular.io/api/core/afterNextRender) lifecycle hook.

To do this, we need to add a constructor. Then, within the constructor, we add the [`afterNextRender()`](https://angular.io/api/core/afterNextRender) function, and we’ll need to be sure it get’s properly imported from angular/core. Now, within the callback, if `animationDisabled()` is true, let’s set it to false.

```typescript
import { ..., afterNextRender } from "@angular/core";

@Component({
  selector: 'app-slider',
  ...
})
export class SliderComponent {
    ...

    constructor() {
        afterNextRender(() => {
            if (this.animationDisabled()) {
                this.animationDisabled.set(false);
            }
        });
    }
}
```

Ok, that should be the logic we need to properly disable and enable our animation. So, let’s switch back over to the template. And now we can add the [[@.disabled]](https://angular.io/guide/transition-and-triggers#disable-an-animation-on-an-html-element) binding, and we can bind to our new animationDisabled() signal.

#### slider.component.html
```html
<div
    [@.disabled]="animationDisabled()"
    [@slideToggle]="{...}"
    class="image">
    ...
</div>
```

And that's it. Now after we save, the animation should no longer run as the component is initialized. But, they should still run properly when navigating through the images in the gallery.

## Animation Callback Events with Disabled Animations

Now there is something else you’ll want to be aware of, if you’re using the [start and done AnimationEvent](https://angular.io/api/animations/AnimationEvent) callback events for anything, they still run, even when the animation is disabled. They will just run with a zero duration.

To demonstrate this, let’s add a start and done event to our animation. In our slider.component.ts, let’s add a new function, let’s call it “animationEvent()”. Let’s pass it a “state” that will either be “start” or “done”. Then within this function, let’s simply log out the state.

#### slider.component.ts
```typescript
@Component({
  selector: 'app-slider',
  ...
})
export class SliderComponent {
    ...

    protected animationEvent(state: 'start' | 'done') {
        console.log(`slideToggle: ${state}`);
    }
}
```

Ok, now let’s switch over to the template. On the div with our animation, let’s add a start event binding. Then let’s call our new function, and in this case, since it’s the start event, let’s pass it a value of “start”. And, let’s do the same for the done event.

#### slider.component.html
```html
<div
    [@.disabled]="animationDisabled()"
    [@slideToggle]="{...}"
    (@slideToggle.start)="animationEvent('start')"
    (@slideToggle.done)="animationEvent('done')"
    class="image">
    ...
</div>
```

Ok, now after we save save, if we open the dev tools and look at the console, we can see that both our start and done events were logged out, meaning both events ran even though our animation was disabled.

<div>
<img src="{{ '/assets/img/content/uploads/2024/05-19/demo-3.gif' | relative_url }}" alt="Example of animation callback events running on initialization even when animations are disabled" width="1280" height="720" style="width: 100%; height: auto;">
</div>

So, not a huge deal, but something to be aware of for sure. It’s definitely thrown me off in the past.

{% include banner-ad.html %}

## Conclusion

So now you should be able to disable animations whenever you don’t want them to run, and there’s lot’s of different ways you can do this. For example, you could add a setting to your app that allows the user to disable animations, and then you could set them disabled using the disabled control based on this setting.

Probably not something you’ll need every day but should come in handy from time to time.

Now, there’s still plenty more to cover on angular animations so I’ll go ahead and stop here for now, but keep an eye out for more posts in the future.

## Want to See It in Action?
Check out the demo code and examples of these techniques in the in the Stackblitz example below. If you have any questions or thoughts, don’t hesitate to leave a comment.

<iframe src="https://stackblitz.com/edit/stackblitz-starters-sxnevo?ctl=1&embed=1&file=src%2Fslider%2Fslider.component.ts" style="height: 500px; width: 100%; margin-bottom: 1.5em; display: block;">
