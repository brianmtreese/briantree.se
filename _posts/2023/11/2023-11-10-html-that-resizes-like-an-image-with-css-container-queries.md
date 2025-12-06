---
layout: post
title: "HTML: How to Resize Markup Like an Image With CSS Container Queries!"
date: "2023-11-10"
video_id: "5ugwp7HlpGs"
tags:
  - "CSS"
  - "HTML"
---

<p class="intro"><span class="dropcap">R</span>eplacing images with HTML and CSS improves maintainability and accessibility, but making HTML elements scale proportionally like images requires responsive techniques. CSS Container Queries enable elements to respond to their container's dimensions rather than the viewport, creating truly responsive components. This tutorial demonstrates how to build an HTML/CSS ad that scales proportionally like an image, adapting to different container sizes automatically.</p>

{% include youtube-embed.html %}

Ok, so we have this vans ad in the sidebar of the site that we are building and it’s currently an image.

<div>
<img src="{{ '/assets/img/content/uploads/2023/11-10/image-ad.png' | relative_url }}" alt="Ad as an image" width="1920" height="1080" style="width: 100%; height: auto;">
</div>

This makes it difficult to edit, a designer would need to update it and provide us with a new image if something needed to change.

Also, we’d probably need multiple versions to use with source set so that it will look crisp on both high density and low res displays.

So, we’re tasked with converting it to HTML, how can we do this?

## Some Downsides to Using Images and Viewport Units

Well, we could probably use viewport units, but we’d need to add extra code if we were to put the ad in different locations where its dimensions would be different since everything would be based off the viewport and not the container dimensions.

So, we could pull it off, but it could get a little messy.

Instead, we could use container queries and container query units.

Container queries are a little like media queries but based off the dimensions of any given container in the page instead of the overall viewport.

## Setting up a Container With the CSS `container-type` Property

Ok, let’s check out what we’re starting with.

<div>
<img src="{{ '/assets/img/content/uploads/2023/11-10/html-ad-not-broken.png' | relative_url }}" alt="Ad as HTML and CSS" width="2038" height="1412" style="width: 100%; height: auto;">
</div>

So, it looks pretty good right here but how does it do as it responds?

<div>
<img src="{{ '/assets/img/content/uploads/2023/11-10/html-ad-broken.png' | relative_url }}" alt="Ad as HTML and CSS with broken styles" width="1363" height="1040" style="width: 100%; height: auto;">
</div>

Uh, the text and borders don’t change size, so it needs some love cause it’s pretty broken as it stands.

Now one thing we’re already doing here is, we’re using an `aspect-ratio` which allows the container to respond as an image would so, that’s all good.

```css
figure {
    aspect-ratio: 1 / 1.5;
}
```

We just need to change all the dimensions for the content to make it respond correctly too. The first step here is to provide a container to monitor our dimensions. This will be our figure element.

To use container queries here, we need to define what is known as a containment context. We can do this with the `container-type` property. For this example, we can use a value of inline size.

```css
figure {
    ...
    container-type: inline-size;
}
```

This is going to set up a container that will size things based off its inline size which, in this case, will be the width of the figure.

Alright, so now we have a container to monitor, so we’re now free to use container query units.

And, there’s lot’s to choose from. We can use any of these unit values:

- `cqw`
- `cqh`
- `cqi`
- `cqb`
- `cqmin`
- `cqmax`

Here we’re going to use `cqi` which, I believe, stands for container query inline. One `cqi` unit is equal to one percent of the width of the container. Ok, that’s all we need, from here we’re just setting units as needed.

Here we have a couple of custom properties that are used on several elements within this ad.

```css
figure {
    ...
    --frameInset: 0.5rem;
    --frameStyle: solid 0.25rem currentColor;
}
```

Let’s start with the amount this frame is inset from the outer edge of the container. Let’s make it three `cqi`.

```css
figure {
    ...
    --frameInset: 3cqi;
}
```

Next, let’s set the thickness of the borders here. In this case, I’m going to use the `max` function to prevent the borders from ever shrinking under one pixel, but I want them to be dynamic as long as they are larger than that one pixel value. So, the first value is one pixel, then the second is the dynamic value. Let’s make it one `cqi`.

```css
figure {
    ...
    --frameStyle: solid max(1px, 1cqi) currentColor;
}
```

Now, for the `strong` element, which is the main title, the "Vans" text, let’s make it twenty-five `cqi`. And, for the space underneath the title, let’s make it three `cqi`.

```css
strong {
    font-size: 25cqi;
    padding-bottom: 3cqi;
}
```

Now let’s move to the "Off the Wall" subtitle. It should be about half the size of the main title so let’s try twelve `cqi`. And, for the space above the text, let’s go with three `cqi` again.

```css
em {
    font-size: 12cqi;
    padding-top: 3cqi;
}
```

Alright, for the last piece, the "Since 1966" label, let’s go with a font size of six `cqi`. And, for the space above and below, we’re using the logical property for `padding-block` which takes up to two values. The first value is the value above the text and the second value is for the space below. So, let’s go with two `cqi` above. And, in our calculation, we’ll leave the `--frameInset` as is, but we’ll go with five `cqi` of additional space.

```css
time {
    font-size: 6cqi;
    padding-block: 2cqi calc(5cqi + var(--frameInset));
}
```

Ok cool, this looks good.

<div>
<img src="{{ '/assets/img/content/uploads/2023/11-10/html-css-ad-large.png' | relative_url }}" alt="Ad as HTML and CSS Container Queries in large viewports" width="3233" height="1427" style="width: 100%; height: auto;">
</div>

Let’s take a look at how it responds. As we squeeze it everything is properly responding uniformly like we wanted. It looks a lot like an image.

<div>
<img src="{{ '/assets/img/content/uploads/2023/11-10/html-css-ad-small.png' | relative_url }}" alt="Ad as HTML and CSS Container Queries in smaller viewports" width="3237" height="988" style="width: 100%; height: auto;">
</div>

It looks pretty good even when it’s small and you can see that the borders never shrink below one pixel.

Then, when we get into really narrow widths it gets wider and everything still looks great.

<div>
<img src="{{ '/assets/img/content/uploads/2023/11-10/html-css-ad-mini.png' | relative_url }}" alt="Ad as HTML and CSS Container Queries in mobile viewports" width="3232" height="1271" style="width: 100%; height: auto;">
</div>

How cool is this? One set of styles and it just works all the way through. As we scale it back and forth it looks great.

Now, what’s even more cool is that we can take our ad mark-up, move it to or main column region here, and everything continues to work just like it would if it were an image.

```html
<header><h1>A Brief History of Vans</h1></header>
<div class="content">
    <main>
        <figure>
            <svg viewBox="0 0 256 256">
                <path d="M90.4,67.9C88,69,87.1,70.6,83,80c-4.4,10.2-4.8,12.3-3.1,15"/>
                <path d="M97.4,95.2c-0.6,0.6-1.2,1.7-1.2,2.3s0"/>
            </svg>
            <figcaption>
                <strong>Vans</strong>
                <em>Off the Wall</em>
                <time>Since 1966</time>
            </figcaption>
        </figure>
        ...
    </main>
</div>
```

<div>
<img src="{{ '/assets/img/content/uploads/2023/11-10/ad-main-content.png' | relative_url }}" alt="Ad as HTML and CSS Container Queries moved to main content area" width="3223" height="1614" style="width: 100%; height: auto;">
</div>

This is just so nice and so cool. Remember, there’s only one set of styles to pull all of this off. And, zero media queries involved.

There’s quite a bit more to container queries as a whole so be on the lookout for future posts where I cover different aspects.

## Want to See It in Action?
Check out the demo code and examples of these techniques in the Codepen example below. If you have any questions or thoughts, don’t hesitate to leave a comment.

<p class="codepen" data-height="600" data-slug-hash="poGegXB" data-user="brianmtreese" style="height: 600px; box-sizing: border-box; display: flex; align-items: center; justify-content: center; border: 2px solid; margin: 1em 0; padding: 1em;">
  <span>See the Pen <a href="https://codepen.io/brianmtreese/pen/poGegXB">
  Container Queries: HTML That Looks and Acts Like an Image</a> by Brian (<a href="https://codepen.io/brianmtreese">@brianmtreese</a>)
  on <a href="https://codepen.io">CodePen</a>.</span>
</p>
<script async src="https://cpwebassets.codepen.io/assets/embed/ei.js"></script>
