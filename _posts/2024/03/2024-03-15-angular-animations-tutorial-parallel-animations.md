---
layout: post
title: "Angular Animations: Animating Multiple Items in Parallel"
date: "2024-03-15"
video_id: "RPdR7HzNQIw"
tags: 
  - "Angular"
  - "Angular Animations"
---

<p class="intro"><span class="dropcap">I</span>f you’ve spent any time creating animations in Angular, you may have noticed that the animations added within component metadata run sequentially. Meaning, they’ll run in the order they are added within the array. Well, sometimes this works fine, but sometimes it doesn’t. Sometimes, we need multiple animations to run in parallel to orchestrate them properly. Well, good news for us, Angular has a solution for this. In this post I’ll show you why, and I’ll show how you can animate things in parallel. Alright, let’s get to it.</p>

<iframe width="1280" height="720" src="https://www.youtube.com/embed/RPdR7HzNQIw" title="" frameborder="0" allow="accelerometer; autoplay; clipboard-write; encrypted-media; gyroscope; picture-in-picture; web-share" allowfullscreen></iframe>

## Before We Get Started

Now, before we get too far along, it’s important to note that I’ve already created several posts focused on the animation framework in Angular. They cover the basics of setting up and using Angular animations, creating state-based and `:enter`/`:leave` animations, using the `keyframes()`, `query()`, and `stagger()` functions to create more complex animation sequences, and using the `start`/`done` animation events.

So, if any of those concepts are unfamiliar to you, you’ll probably want to check those posts out first so that you’re not lost in this one.

#### Angular Animation Tutorials:
- [Learn the Basics]({% post_url /2024/02/2024-02-09-angular-animations-tutorial-learn-the-basics %})
- [Enter and Leave Animations]({% post_url /2024/02/2024-02-16-angular-animations-tutorial-enter-and-leave %}) 
- [The Keyframes Function]({% post_url /2024/02/2024-02-23-angular-animations-tutorial-the-keyframes-function %})
- [Query and Stagger Function]({% post_url /2024/03/2024-03-01-angular-animations-tutorial-query-and-stagger %})
- [Start and Done Events]({% post_url /2024/03/2024-03-08-angular-animations-tutorial-start-and-done-events %})

And, to make them easier to find, I’ve created an [Angular Animations playlist](https://youtube.com/playlist?list=PLp-SHngyo0_ikgEN5d9VpwzwXA-eWewSM&si=3WnQgeDxdAZJGGFy) on my [YouTube channel](https://www.youtube.com/@briantreese) to help, so check it out!

Ok, enough of that, onto the example for this post.

<div class="shirt-ad">
<a href="https://www.teepublic.com/user/dev-drip" title="Click to get yourself some fresh Angular merch!">
<img src="{{ '/assets/img/dev-drip-banner.png' | relative_url }}" alt="Swoop up some hip new Angular drip! - Dev Drip Merch Shop" width="960" height="275" style="width: 100%; height: auto;"></a>
</div>

## The Demo Application

Here, we’re back to the demo application we created in an earlier post on Angular animations where we learned how the [`query()` and `stagger()` functions work]({% post_url /2024/03/2024-03-01-angular-animations-tutorial-query-and-stagger %}). This application lists out various NBA players. It starts off showing only Lebron James, but when we click the add button, we load in several more players.

<div>
<img src="{{ '/assets/img/content/uploads/2024/03-15/demo-app-before-parallel-animations.gif' | relative_url }}" alt="Example of a demo application before adding parallel animations" width="518" height="784" style="width: 100%; height: auto;">
</div>

Now this doesn’t look too bad because we’ve already added some animations. But let’s imagine that the client we’ve built this for now wants to highlight these list items as they’re added and removed. They want them to highlight green when they’re added and then highlight them red as they’re being removed.

<div>
<img src="{{ '/assets/img/content/uploads/2024/03-15/demo-app-after-parallel-animations.gif' | relative_url }}" alt="Example of a demo application after adding parallel animations" width="516" height="784" style="width: 100%; height: auto;">
</div>

Ok, no prob, we can do this.

## Adding Additional Color Change Animations on `:enter`

Ok, let’s get started by adding the new animations needed for the enter state. When we look at this existing enter animation, we can see that this animation happens pretty quickly. Over five hundred milliseconds.

### main.ts
```typescript
animate('500ms ease-in', style({opacity: 1, transform: 'scale(1)'}))
```

That’s going to be way too short of a duration for the color change, they want that to last for a while. So, since we’ll need a different duration, we need a whole new animation. We’ll start by adding another [`query()`](https://angular.io/api/animations/query), and it will query for items that are entering the DOM.

```typescript
query(':enter', [])
```

When items are added, we need them to start with a light green background, so we'll add the [`style()`](https://angular.io/api/animations/style) method. Inside, we’ll add an object with a `backgroundColor`. For its value, we'll use an `rgba()` color function. The red value will be zero, the green value will be two fifty five, the blue value will be zero, and let’s go with point two for the alpha value.

```typescript
query(':enter', [
    style({backgroundColor: 'rgba(0 ,255, 0, 0.2)'})
])
```

Now, we need to animate this background so let’s add the [`animate()`](https://angular.io/api/animations/animate) method. We want this color change to take a little while so let’s add a duration of three seconds, and let’s add an `ease-in` timing function.

```typescript
query(':enter', [
    style({backgroundColor: 'rgba(0 ,255, 0, 0.2)'}),
    animate('3s ease-in')
])
```

Then we need another `style()` function. This time we’ll change the `backgroundColor` to the original rgba value. It’s going to be black, so we’ll add zeros for all of the colors, and then we’ll set the alpha to point one. So, it’s a pretty light gray color in its default state.

```typescript
query(':enter', [
    style({backgroundColor: 'rgba(0 ,255, 0, 0.2)'}),
    animate('3s ease-in', style({backgroundColor: 'rgba(0, 0, 0, 0.1)'}))
])
```

Now we also want to change the text color so let’s add another `query()`. Here, the player’s name is inside of an `h2`, and the player’s stats are inside of a `dl`. So, this time we’ll query for an `h2` within the entering item, and a `dl` too.

```typescript
query(':enter h2, :enter dl', [])
```

For these, we’re going to start with a green color so let’s add another `style()` method. And we’ll make the color green.

```typescript
query(':enter h2, :enter dl', [
    style({color: 'green'})
])
```

Now we need to animate this to the original value so let’s add the `animate()` function. We’ll go with the same animation duration and easing function of three seconds and `ease-in`. Then we’ll add the `style()` function and animate the color to a value of `inherit`.

```typescript
query(':enter h2, :enter dl', [
    style({color: 'green'}),
    animate('3s ease-in', style({color: 'inherit'}))
])
```

Now, the last piece, we need to make both of these queries optional.

```typescript
query(':enter', [
    ...
], { optional: true }),
query(':enter h2, :enter dl', [
    ...
], { optional: true })
```

And, you can see why in the post on [`query()` and `stagger()`]({% post_url /2024/03/2024-03-01-angular-animations-tutorial-query-and-stagger %}) animations if you’re curious.

Ok, let’s save and see where we’re at. Let’s hit the add button to animate the players in.

<div>
<img src="{{ '/assets/img/content/uploads/2024/03-15/multiple-enter-animations-running-sequentially.gif' | relative_url }}" alt="Example of multiple :enter animations running sequentially" width="824" height="1080" style="width: 100%; height: auto;">
</div>

Ugh, that’s super weird right? Probably not at all how you we’re expecting and certainly not what we want.

## How Animations Run by Default

Well, what’s happening here is that we have an array of animation steps. Angular simply processes and executes each animation step in sequence. So the first `:enter` animation runs and it takes a half second. Then, as soon as it completes, the second animation runs which changes the background color over three seconds. Finally, after that animation completes, three and a half seconds in, the text color animation starts.

<div>
<img src="{{ '/assets/img/content/uploads/2024/03-15/animation-sequence-breakdown.gif' | relative_url }}" alt="Breakdown illustration of how the :enter animations run sequentially" width="1360" height="1074" style="width: 100%; height: auto;">
</div>

So essentially, each animation is blocked by the previous animation step. In this case, this is no good. We need them to all animate at the same time, and this is where the Angular animations [`group()`](https://angular.io/api/animations/group) method comes into play.

## Using the `group()` Function to Run Animations in Parallel

To set up animation steps to run at the same time, it’s actually pretty easy. We can use the animation [`group()`](https://angular.io/api/animations/group) function.

This function expects an array of steps consisting of [`AnimationMetadata`](https://angular.io/api/animations/AnimationMetadata) objects which is what we’re used to with many of the other animation functions. [`AnimationOptions`](https://angular.io/api/animations/AnimationOptions) can optionally be passed where needed but we won’t need these in this demo.

<div>
<img src="{{ '/assets/img/content/uploads/2024/03-15/group-function-breakdown.png' | relative_url }}" alt="Example of the group function and its parameters" width="2560" height="1440" style="width: 100%; height: auto;">
</div>

Ok, so how do we use it within our example? Easy, we just need to wrap these three animation steps within the `group()` function.

```typescript
group([
    query(':enter', [
        style({opacity: 0, transform: 'scale(0.7)'}),
        stagger(100, [
            animate('500ms ease-in', style({opacity: 1, transform: 'scale(1)'}))
        ])
    ], { optional: true }),
    query(':enter', [
        style({backgroundColor: 'rgba(0 ,255, 0, 0.2)'}),
        animate('3s ease-in', style({backgroundColor: 'rgba(0, 0, 0, 0.1)'}))
    ], { optional: true }),
    query(':enter h2, :enter dl', [
        style({color: 'green'}),
        animate('3s ease-in', style({color: 'inherit'}))
    ], { optional: true }),
])
```

Ok, now let’s save and try this again.

<div>
<img src="{{ '/assets/img/content/uploads/2024/03-15/multiple-enter-animations-running-in-parallel.gif' | relative_url }}" alt="Example of multiple :enter animations running in parallel" width="824" height="1080" style="width: 100%; height: auto;">
</div>

There, that looks great. They are all animating together at the same time now. Pretty cool right?

Now, that we know all of this, let’s add the red animation as the items leave the DOM.

## Adding Additional Color Change Animations on `:leave`

Let’s add another `query()` here. We’ll query for leaving items this time. We’ll start from the initial gray background and animate to red so we don’t need a starting style. We just need to add the `animate()` function. We’ll want the transition to happen pretty quickly so let’s go with a duration of two hundred fifty milliseconds and we’ll use `ease-in`. Then, we'll add the `style()` function, and animate the `backgroundColor` to an `rgba()` value of two fifty five for red, zero for green, zero for blue, and point two for our alpha value.

```typescript
group([
    ...
)],
group([
    ...
    query(':leave', [
        animate('250ms ease-in', style({backgroundColor: 'rgba(255, 0, 0, 0.2)'}))
    ], { optional: true })
)]
```

Next, we’re going to change the text color so we’ll add another `query()`. We want to query for the `h2` and `dl` within the leaving items this time. This animation is similar to the one, the text is going to start from its initial color so no starting style is needed. We just need to add another `animate()` function with the same two hundred fifty millisecond duration and `ease-in` timing function. Then, we need to add another `style()`, this time with a `color` of red.

```typescript
group([
    ...
)],
group([
    ...
    query(':leave', [
        animate('250ms ease-in', style({backgroundColor: 'rgba(255, 0, 0, 0.2)'}))
    ], { optional: true }),
    query(':leave h2, :leave dl', [
        animate('250ms ease-in', style({color: 'red'}))
    ], { optional: true })
)]
```


Ok, let’s save and try it now.

<div>
<img src="{{ '/assets/img/content/uploads/2024/03-15/final-example-enter-and-leave-parallel-animations.gif' | relative_url }}" alt="The final example of multiple :enter and :leave animations running in parallel" width="824" height="1078" style="width: 100%; height: auto;">
</div>

Ok, everything still looks good when we add, and now they are properly turning red when they leave too. So, it’s pretty cool to see how we can override the default sequential behavior for animations.

## Conclusion

So, this is yet another handy feature when it comes to animations in angular. Hopefully it helps you out somewhere along the way where you need multiple animations to run in parallel.

Now remember, there’s a lot to the animation framework, so I’ll go ahead and stop here for now, but I will be creating more posts on Angular animations in the future so stay tuned!

## Want to See It in Action?
Check out the demo code and examples of these techniques in the in the Stackblitz example below. If you have any questions or thoughts, don’t hesitate to leave a comment.

<iframe src="https://stackblitz.com/edit/stackblitz-starters-z1ppg8?ctl=1&embed=1&file=src%2Fmain.ts" style="height: 500px; width: 100%; margin-bottom: 1.5em; display: block;">
