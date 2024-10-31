---
layout: post
title: "Look ma... no JavaScript!"
date: "2023-10-27"
video_id: "PcyFYILv8TE"
tags: 
  - "CSS"
---

<p class="intro"><span class="dropcap">I</span>n this post we’re going to look at a really exciting new CSS feature, scroll driven animations. We’ll take some, boring, scrolling content, and give it an upgrade to something a little more interesting. And we’ll do it all with CSS. No JavaScript. Alright, let’s get to it!</p>

<iframe width="560" height="315" src="https://www.youtube.com/embed/PcyFYILv8TE?si=Iz5HmntMpXVelLFG" title="YouTube video player" frameborder="0" allow="accelerometer; autoplay; clipboard-write; encrypted-media; gyroscope; picture-in-picture; web-share" allowfullscreen></iframe>

Ok, so here’s what we are starting with. We’ve got this content with some basic info about NBA teams. And, when we scroll down to see the list and it looks, not only a little boring, but almost broken. The headers are sticky but before they stick to the top, they have extra space next to them. As they stick, they sit next to each other and look ok.

<p class="codepen" data-height="600" data-default-tab="result" data-slug-hash="dyrMGBp" data-user="brianmtreese" style="height: 600px; box-sizing: border-box; display: flex; align-items: center; justify-content: center; border: 2px solid; margin: 1em 0; padding: 1em;">
  <span>See the Pen <a href="https://codepen.io/brianmtreese/pen/dyrMGBp">
  Scroll Driven Animations</a> by Brian (<a href="https://codepen.io/brianmtreese">@brianmtreese</a>)
  on <a href="https://codepen.io">CodePen</a>.</span>
</p>
<script async src="https://cpwebassets.codepen.io/assets/embed/ei.js"></script>

Wouldn’t it be great if we could transition these as we scroll? Well, we actually can with scroll driven animations.

## What are CSS Scroll-Driven animations?
[Scroll-driven animations](https://developer.mozilla.org/en-US/docs/Web/CSS/CSS_scroll-driven_animations) in CSS provide effects that used to require JavaScript to pull off. They allow us to animate items tied to their visibility within a given scroll container. And the possibilities are endless.

## Using the CSS animation-timeline Property and view() Function
The first thing we want to do is animate our headers so that they look better as we scroll. To do this, we start by adding the [`animation-timeline`](https://developer.mozilla.org/en-US/docs/Web/CSS/animation-timeline) property. This is the brand new property that makes all of this possible.
It’s what allows us to bind animations to a scroll container as it scrolls. Now there are many ways to use this property, but for this example we are going to keep it simple.

```css
.title {
    animation-timeline
}
```

We’re going to use the also brand new, [`view()`](https://developer.mozilla.org/en-US/docs/Web/CSS/animation-timeline/view) function. This allows us to tie animations to the nearest parent scrolling container. Now, there are many different options we can pass to the view function, but we’re just going to pass it the direction of scroll that we want to animate along. In our case it’s the block direction because that’s the way that our content scrolls. If it were scrolling horizontally, we could use inline instead.

```css
.title {
    animation-timeline: view(block);
}
```

Ok, now let’s create a key frame animation for how we want these headers to animate. What we’ll do is have the containers start at full width and animate to the final fifty percent width. So, let’s call it shrink. Ok, we’ll go from a width of one hundred percent to a width of fifty percent, but we also have a four pixel gap between the headers when they’re pinned, so we’ll make it a `calc` and subtract half of that gap, 2px.

Let’s also scale from eighty percent to one hundred percent. And, let’s also fade it in from an opacity of zero to an opacity of one.

```css
@keyframes shrink {
    from {
        width: 100%;
        scale: 0.8;
        opacity: 0;
    }
    to {
        width: calc(50% - 2px);
        scale: 1;
        opacity: 1;
    }
}
```

Now, let’s add this animation to our element with the animation name property.

```css
.title {
    ...
    animation-name: shrink;
}
```

## Using the CSS animation-range Property
Ok, the last piece is to add an [`animation-range`](https://developer.mozilla.org/en-US/docs/Web/CSS/animation-range). With this property we can define when we want our animation to begin and when we want it to end. This property is actually a shorthand for the new [`animation-range-start`](https://developer.mozilla.org/en-US/docs/Web/CSS/animation-range-start) and [`animation-range-end`](https://developer.mozilla.org/en-US/docs/Web/CSS/animation-range-end) values.

Now, this is a little tricky to understand, but we’ll give it a value of `entry` negative ten percent for the start, and `contain` forty percent for the end.

```css
.title {
    ...
    animation-range: entry -10% contain 40%;
}
```

Wait what? You can use [this tool](https://scroll-driven-animations.style/tools/view-timeline/ranges/#range-start-name=entry&range-start-percentage=-10&range-end-name=contain&range-end-percentage=40&view-timeline-axis=block&view-timeline-inset=0&subject-size=smaller&subject-animation=reveal&interactivity=clicktodrag&show-areas=yes&show-fromto=yes&show-labels=yes) to explore what this means.This is a tool created by a developer relations engineer at google. It allows us to easily see how the animation range settings work.

When you scroll in that example, you can see where our animation starts and ends while scrolling within the view.
This tool really helped me understand how these settings work.

Ok, when we go back over to our example, when we scroll down, we can see our animation is applied correctly. Much better.

<p class="codepen" data-height="600" data-default-tab="result" data-slug-hash="PoLNNZR" data-user="brianmtreese" style="height: 600px; box-sizing: border-box; display: flex; align-items: center; justify-content: center; border: 2px solid; margin: 1em 0; padding: 1em;">
  <span>See the Pen <a href="https://codepen.io/brianmtreese/pen/PoLNNZR">
  Scroll Driven Animations</a> by Brian (<a href="https://codepen.io/brianmtreese">@brianmtreese</a>)
  on <a href="https://codepen.io">CodePen</a>.</span>
</p>
<script async src="https://cpwebassets.codepen.io/assets/embed/ei.js"></script>

And, if we scroll slowly, we can see how the animation gets applied. As it enters the view, it’s full width and by the time it reaches about two thirds of the scroll height it’s nearly fifty percent wide, fully opaque, and fully scaled in. And if we stop scrolling anywhere in here the items freeze at their current spot in the animation. I mean, to me, this is mind blowing. Crazy that this is all done with a few lines of CSS.

## Adding Scroll Animations to the List Items

Now, this isn’t looking exactly how I want it yet. I want to animate the list items on scroll as well.
For these items, I want to do the opposite of the titles. I want to start them smaller and grow them as they scroll in. So, we start by adding our animation-timeline again. We’ll use the view function again with a value of block.

```css
li {  
    animation-timeline: view(block);
}
```

Now we add our new keyframe animation, let’s call it grow this time. We’ll start with a scale of eighty percent and an opacity of zero. And we’ll animate to a scale of one hundred percent and opacity of one.

```css
@keyframes grow {
    from {
        scale: 0.8;
        opacity: 0;
    }
    to {
        scale: 1;
        opacity: 1;
    }
}
```

Now we can add it with the animation name property.

```css
li {
    ...
    animation-name: grow;
}
```

And, we’ll add our range. We’ll use the same value as our previous animation, to start, `entry` negative ten percent, and to end, `contain` forty percent.

```css
li {
    ...
    animation-range: entry -10% contain 40%;
}
```

Ok so how does it look now?

<p class="codepen" data-height="600" data-default-tab="result" data-slug-hash="rNReeLN" data-user="brianmtreese" style="height: 600px; box-sizing: border-box; display: flex; align-items: center; justify-content: center; border: 2px solid; margin: 1em 0; padding: 1em;">
  <span>See the Pen <a href="https://codepen.io/brianmtreese/pen/rNReeLN">
  Scroll Driven Animations</a> by Brian (<a href="https://codepen.io/brianmtreese">@brianmtreese</a>)
  on <a href="https://codepen.io">CodePen</a>.</span>
</p>
<script async src="https://cpwebassets.codepen.io/assets/embed/ei.js"></script>

Nice, I like this effect. It looks a lot smoother than it did before the animation.

## Adding Scroll Animations to the Scroll Label

Ok, now the last thing I want to do for this example is, I want to do something with the label that says "Scroll Down to See the List" as I scroll down. I think we should animate it out as we scroll since it’s telling us to scroll and that’s what we’re doing.

So, you know the deal by now, let’s add the animation timeline with view, block.

```css
.label {
    animation-timeline: view(block);
}
```

Now we need another keyframe animation, this one we’ll call fadeout.It will start from a scale of one and an opacity of one. And it’ll animate to a vertical translate of negative two hundred and fifty percent, a scale of eighty percent, and an opacity of zero.

```css
@keyframes fadeout {
    from {
        scale: 1;
        opacity: 1;
    }
    to {
        translate: 0 -250%;
        scale: 0.8;
        opacity: 0;
    }
}
```

Now we need to add it to our label element.

```css
.label {
    ...
    animation-name: fadeout;
}
```

And then we need to add our range. This time it’ll be a little different, we’ll start with `contain` at zero percent, and end with `contain` at one hundred percent.

```css
.label {
    ...
    animation-range: contain 0% contain 100%;
}
```

Ok, so how does this look now?

<p class="codepen" data-height="600" data-default-tab="result" data-slug-hash="MWLwdNw" data-user="brianmtreese" style="height: 600px; box-sizing: border-box; display: flex; align-items: center; justify-content: center; border: 2px solid; margin: 1em 0; padding: 1em;">
  <span>See the Pen <a href="https://codepen.io/brianmtreese/pen/MWLwdNw">
  Scroll Driven Animations</a> by Brian (<a href="https://codepen.io/brianmtreese">@brianmtreese</a>)
  on <a href="https://codepen.io">CodePen</a>.</span>
</p>
<script async src="https://cpwebassets.codepen.io/assets/embed/ei.js"></script>

Nice, I like that better.

## Scroll-Driven Animations Browser Support

Hopefully this gets you going and inspires you for what’s possible with the stuff that you’re building.

One last note on scroll-driven animations, browser support is not super great at the moment. Chrome and edge are good, but they are only available behind a flag in firefox and not at all in safari.

Hopefully we’ll get there soon, but in the meantime, you’ll need to keep that in mind.

Ok, I think that’s all for now. Until next time. Thanks for reading.
