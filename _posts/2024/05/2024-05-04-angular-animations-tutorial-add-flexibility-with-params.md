---
layout: post
title: "Angular Animations: Adding Flexibility with Params!"
date: "2024-05-04"
video_id: "ZNZ1JvrUdhE"
tags: 
  - "Angular"
  - "Angular Animations"
---

<p class="intro"><span class="dropcap">W</span>hen working with Angular animations, have you ever found yourself needing to provide custom configurations to a specific animation? Like, what if you have something that uses a next button and you want to animate to the right in that case, but then you also have a previous button, in which case you want to animate to the left instead? Well, if you didn’t know this already, this is totally doable with Angular <a href="https://angular.io/api/animations/AnimationOptions">animation options</a> and the <a href="https://angular.io/api/animations/AnimationOptions#params">params object</a> specifically. And in this post, I’ll show you exactly how to set them up, and use them. Alright, let’s get to it.</p>

<iframe width="1280" height="720" src="https://www.youtube.com/embed/ZNZ1JvrUdhE" title="" frameborder="0" allow="accelerometer; autoplay; clipboard-write; encrypted-media; gyroscope; picture-in-picture; web-share" allowfullscreen></iframe>

## Before We Get Started

Now, before we get too far along, it’s important to note that I’ve already created several posts focused on the animation framework in Angular. They cover the basics of setting up and using animations in Angular, creating state-based and [`enter`/`leave`](https://angular.io/guide/transition-and-triggers#aliases-enter-and-leave) animations, using the [`keyframes()`](https://angular.io/api/animations/keyframes), [`query()`](https://angular.io/api/animations/query), and [`stagger()`](https://angular.io/api/animations/stagger) functions to create more complex animation sequences, using the [`start`/`done`](https://angular.io/api/animations/AnimationEvent) animation events, creating animations that run in parallel versus in sequence, and even animating to an unknown height.

So, if any of those concepts are unfamiliar to you, you’ll probably want to check those posts out first so that you’re not lost in this post.

#### Angular Animation Tutorials:
- [Learn the Basics]({% post_url /2024/02/2024-02-09-angular-animations-tutorial-learn-the-basics %})
- [Enter and Leave Animations]({% post_url /2024/02/2024-02-16-angular-animations-tutorial-enter-and-leave %}) 
- [The Keyframes Function]({% post_url /2024/02/2024-02-23-angular-animations-tutorial-the-keyframes-function %})
- [Query and Stagger Function]({% post_url /2024/03/2024-03-01-angular-animations-tutorial-query-and-stagger %})
- [Start and Done Events]({% post_url /2024/03/2024-03-08-angular-animations-tutorial-start-and-done-events %})
- [Parallel Animations]({% post_url /2024/03/2024-03-15-angular-animations-tutorial-parallel-animations %})
- [Animating to an unknown height]({% post_url /2024/03/2024-03-29-angular-animations-tutorial-animating-height %})

And, to make them easier to find, I’ve created an [Angular Animations playlist](https://youtube.com/playlist?list=PLp-SHngyo0_ikgEN5d9VpwzwXA-eWewSM&si=3WnQgeDxdAZJGGFy) on my [YouTube channel](https://www.youtube.com/@briantreese) to help, so check it out!

Ok, enough of that, onto the example for this post.

<div class="shirt-ad">
<a href="https://www.teepublic.com/user/dev-drip" title="Click to get yourself some fresh Angular merch!">
<img src="{{ '/assets/img/dev-drip-banner.png' | relative_url }}" alt="Swoop up some hip new Angular drip! - Dev Drip Merch Shop" width="960" height="275" style="width: 100%; height: auto;"></a>
</div>

## The Demo Application

Here we have little [demo image gallery slider component](https://stackblitz.com/edit/stackblitz-starters-sdtxdr?file=src%2Fslider%2Fslider.component.ts). When we click the “next image” button we cycle to the next image in the gallery. As we cycle through these images, we notice that we’re transitioning the images and it works pretty nicely. But what happens when we navigate to the previous image? We’ll they animate the same direction.

<div>
<img src="{{ '/assets/img/content/uploads/2024/05-04/demo-1.gif' | relative_url }}" alt="Example of an image gallery animating a single direction before adding configurable Angular animation params" width="592" height="528" style="width: 100%; height: auto;">
</div>

But this makes it less intuitive right? It would be better if they transitioned opposite direction when navigating to previous images in the gallery.

<div>
<img src="{{ '/assets/img/content/uploads/2024/05-04/demo-2.gif' | relative_url }}" alt="Example of an image gallery animating both single direction after adding configurable Angular animation params" width="592" height="530" style="width: 100%; height: auto;">
</div>

So, we need a way to animate one direction when cycling through the next images and then we need to transition all the same elements in the opposite direction based on some sort of logic.

### The Existing Image Slider Animation

Before we’ll be able to pull this off, we first need to understand what we’re working with. Let’s start by taking a look at the markup for this image gallery.

In this demo we have a [slider component](https://stackblitz.com/edit/stackblitz-starters-sdtxdr?file=src%2Fslider%2Fslider.component.html) that contains all the markup, logic, and animations for the gallery. Let’s look at the template first. Here we have a div container that wraps a switch statement for our images.

#### slider.component.html
```html
<div
    [@slideToggle]="selectedImage()"
    class="image">
    @switch(selectedImage()) {
        @case(1) { <img src="/assets/1.jpg" alt="A neon frog" /> }
        @case(2) { <img src="/assets/2.jpg" alt="A dog on a surfboard" /> }
        @case(3) { <img src="/assets/3.jpg" alt="A chinchilla with sunglasses" /> }
        @case(4) { <img src="/assets/4.jpg" alt="A cool cat wearing a jacket" /> }
    }
</div>
```

The logic to control which image to show is based off this “selectedImage()” property. This means that these images are included conditionally so our animation for switching between them must use an `:enter` and `:leave` animation.

The animation trigger is applied to the container wrapping the images, meaning it must use a [`query()`](https://angular.io/api/animations/query) to query for items entering and leaving every time the “selectedImage()” value changes.

And, for the final piece that makes all of this work, we have our “next” and “previous” image buttons that call a next and previous function when they are clicked, unless we’re at the end of the list for the next button, or we’re at the beginning of the list for the previous button. In those cases we are disabling the button.

```html
<button
    (click)="previous()" 
    [disabled]="this.selectedImage() === 1">
    Previous Image
</button>
<button 
    (click)="next()"
    [disabled]="this.selectedImage() === 4">
    Next Image
</button>
```

Ok, so that’s the markup, now let’s look at the code that makes it all work.

Here we have the “selectedImage()” property. It’s set using a [signal](https://angular.io/guide/signals) with an initial value of one, meaning that, when the component is loaded initially, our first image, the one named one dot jpg, will be displayed.

#### slider.component.ts
```typescript
export class SliderComponent {
    protected selectedImage = signal(1);
    ...
}
```

Then we have the “previous()” function that, as long as the “selectedImage()” is greater than one, will decrement the value of the “selectedImage()” signal to display the previous image in the list.

```typescript
export class SliderComponent {
    ...
    previous() {
        if (this.selectedImage() > 1) {
            this.selectedImage.set(this.selectedImage() - 1);
        }
    }
}
```

Likewise, we have the “next()” function that, as long as the “selectedImage()” is less than four, will increment the value of the “selectedImage()” [signal](https://angular.io/guide/signals) to display the next image in the list.

```typescript
export class SliderComponent {
    ...
    next() {
        if (this.selectedImage() < 4) {
            this.selectedImage.set(this.selectedImage() + 1);
        }
    }
}
```

So that’s how we control which image to show and how we switch between them with the next and previous buttons.

Then, we have the animation that runs as the images enter and leave the container. There's the “slideToggle” trigger name which was bound on the image container to the value of the “selectedImage()” signal in the template. This animation transitions from any value of the signal to any other value, meaning it will fire any time the value changes. And when this transition runs, we use the group function to run several animation steps in parallel.

First, we query for the item entering. That would be the image we’re switching to. We set it to begin translated completely out of view with `translateX(-100%)`. It also starts out scaled down. Next, we animate the image that is leaving off to the right with `translateX(100%)`. And we also scale it down too. And finally, we animate the image entering by setting `translateX(0)` and fully scaling it up.

```typescript
trigger('slideToggle', [
    transition('* => *', [
        group([
            query(':enter', style({ transform: 'translateX(-100%) scale(0.25)' })),
            query(':leave', [
                animate('750ms ease-in-out', style({ transform: 'translateX(100%) scale(0.25)' }))
            ]),
            query(':enter', [
                animate('750ms ease-in-out', style({ transform: 'translateX(0) scale(1)' }))
            ])
        ])
    ])
])
```

So that’s how everything works currently, and it looks pretty smooth as long as we’re navigating forward So how can we animate in the opposite direction like we want to when hitting the previous button?

## Passing Override Parameter Values to Angular Animations with the Params Object

<div>
<img src="{{ '/assets/img/content/uploads/2024/05-04/params-slide.gif' | relative_url }}" alt="Angular Animation override parameters example slide" width="1280" height="720" style="width: 100%; height: auto;">
</div>

We’ll it's actually pretty simple. We can set our animation up to use override params with the [params object](https://angular.io/api/animations/AnimationOptions#params). This object allows us to override parts of the animation programmatically when needed.

### Adding the Animation Direction Property to Control the Params Programmatically

Ok, the first thing we need to do is we need to add a property to tell us which direction we want to animate. So, let’s add an “animationDirection” property. It will be a [signal](https://angular.io/guide/signals), and we’ll either want to navigate to the “right”, or to the “left”. And, let’s give it an initial value of “right”.

#### slider.component.ts
```typescript
export class SliderComponent {
    ...
    protected animationDirection = signal<'right' | 'left'>('right');
}
```

Ok, now within the “previous()” function, when navigating, let’s set this [signal](https://angular.io/guide/signals) to “left” because we want to navigate in the opposite direction when navigating to the previous image.

```typescript
export class SliderComponent {
    ...
    previous() {
        if (this.selectedImage() > 1) {
            this.animationDirection.set('left');
            ...
        }
    }
}
```

And then we’ll make sure to set it to “right” in the “next()” function.

```typescript
export class SliderComponent {
    ...
    next() {
        if (this.selectedImage() < 4) {
            this.animationDirection.set('right');
            ...
        }
    }
}
```

Ok, now we can add the params to our animation.

### Adding Custom Params to the Animation

Ok, so we know that the final resting place for our visible image will always be a `translateX` value of zero, so we don’t need to worry about that. All that we need to do is control where the leaving image ends, and where the entering image starts.

Let's start by adding our `params` object within the options object for the `transition()` function. Let’s add “leaveEnd” and “enterStart” params. In our case, we’ll just default them to empty strings since we’ll make sure they're always set correctly in our logic. We could place a default value here and the animation would then fall back to that value if one was not passed to the animation.

```typescript
trigger('slideToggle', [
    transition('* => *', [
        ...
    ],
    { 
        params: {
            leaveEnd: '',
            enterStart: ''
        }
    })
])
```

Ok, now to use these params in our animation we just need to wrap the param name in double curly braces. So, let’s add the “enterStart” param to our `:enter` initial state.

```typescript
query(':enter', style({ transform: 'translateX({% raw %}{{ enterStart }}{% endraw %}) scale(0.25)' }))
```

And let’s add the “leaveEnd” param to our `:leave` animation end state.

```typescript
query(':leave', [
    animate(
        '750ms ease-in-out',
        style({ transform: 'translateX({% raw %}{{ leaveEnd }}{% endraw %}) scale(0.25)' })
    )
])
```

Ok, at this point, our animation is now all set up to receive the override parameters, all we need to is wire them up in the template.

### Wiring Up the Animation Params in the Component Template

Ok, first thing we need to do is convert this binding to an object instead. In this object there’s a value that will be used to trigger the animation so, that will be set to our “selectedImage()” [signal](https://angular.io/guide/signals) Next, we can add a params object.

#### slider.component.html
```html
<div
    [@slideToggle]="{
        value: selectedImage(),
        params: {}
    }">
    ...
</div>
```

Within this object, let’s add our “leaveEnd” param. Then we’ll check if our “animationDirection()” [signal](https://angular.io/guide/signals) is “right”, if so we’ll end with `tranlateX(100%)`, so off to the right. And if not, we’ll end at `tranlateX(100%)`, or off to the left.

```html
<div
    [@slideToggle]="{
        value: selectedImage(),
        params: {
            leaveEnd: animationDirection() === 'right' ? '100%' : '-100%'
        }
    }">
    ...
</div>
```

Ok, now let’s add the “enterStart” param. Again, we’ll check if our “animationDirection” [signal](https://angular.io/guide/signals) is “right”. If so, we’ll start with `tranlateX(-100%)`, so off to the left. And if not, we’ll start at `tranlateX(100%)` instead, or off to the right.

```html
<div
    [@slideToggle]="{
        value: selectedImage(),
        params: {
            leaveEnd: animationDirection() === 'right' ? '100%' : '-100%',
            enterStart: animationDirection() === 'right' ? '-100%' : '100%'
        }
    }">
    ...
</div>
```

Ok, that’s it. Let’s save and see how it looks now.

<div>
<img src="{{ '/assets/img/content/uploads/2024/05-04/demo-2.gif' | relative_url }}" alt="Example of an image gallery animating both single direction after adding configurable Angular animation params" width="592" height="530" style="width: 100%; height: auto;">
</div>

Nice, looks like it still animated correctly as we navigated to the next image and it’s now animating correctly back to the left when we hit the previous button.

## Conclusion

So, the example we have here is pretty simple, but it demonstrates how and why you may need to use params in your animations going forward. I hope you found all of this useful.

Now remember, there’s a lot to the animation framework, so I’ll go ahead and stop here for now, but I’ll likely create more posts on Angular animations in the future so stay tuned!

## Want to See It in Action?
Check out the demo code and examples of these techniques in the in the Stackblitz example below. If you have any questions or thoughts, don’t hesitate to leave a comment.

<iframe src="https://stackblitz.com/edit/stackblitz-starters-b9esaz?ctl=1&embed=1&file=src%2Fslider%2Fslider.component.ts" style="height: 500px; width: 100%; margin-bottom: 1.5em; display: block;">

