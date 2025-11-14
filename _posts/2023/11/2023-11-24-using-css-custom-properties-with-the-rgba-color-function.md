---
layout: post
title: "Alpha Transparency in CSS Custom Properties"
date: "2023-11-24"
video_id: "RduB0gmxsxM"
tags:
  - "CSS"
---

<p class="intro"><span class="dropcap">C</span>ustom properties have been a pretty big deal for us who use CSS regularly. Many of us are probably starting to use them quite a bit, especially as part of a color or theming system. They really work great for this. But what about when we need alpha transparency for a color set with a custom property? Well, in this post I’ll show you how it works. Alright, let’s check it out!</p>

{% include youtube-embed.html %}

Here in this example, we have this title here.

<div>
<img src="{{ '/assets/img/content/uploads/2023/11-24/title-example.png' | relative_url }}" alt="Example of a generic title" width="1822" height="1448" style="width: 100%; height: auto;">
</div>

Currently it’s just using the color red to give it its color.

```css
h1 {
    color: red;
}
```

## Creating and Using a Basic CSS Custom Property for a Color Value

Let’s say we’re converting over to use custom properties for our colors in order to make it easier to change the overall theme when needed. In our theme, red will be our primary color, so on our `html` element we’ll create a custom property called "primary".

```css
html {
    --primary: red;
}
```

Now, we’ll switch our `h1` to use this primary custom property.

```css
h1 {
    color: var(--primary);
}
```

There we go, now what if we need use this custom property with the `rgba()` color function so that we can change the opacity? Can this be done? Well, let’s find out. Let’s wrap our custom property in the rgba color function.

```css
h1 {
    color: rgba(var(--primary));
}
```

Ugh, bummer, looks like that doesn’t work for us.

<div>
<img src="{{ '/assets/img/content/uploads/2023/11-24/rgba-with-standard-color-example.png' | relative_url }}" alt="Example using a standard custom property with the rgba color function" width="1742" height="946" style="width: 100%; height: auto;">
</div>

## Using the CSS rgba() Color Function With a Custom Property

The good news is that it is possible though. We can actually use custom properties with the `rgba()` color function if the property is set to an `rgb` value. So, this means we just need to add a custom property that is set to the `rgb` value of red.

Let’s add a new property called "primary-rgb". And we’ll set it to two fifty-five, zero, zero.

```css
html {
    ...
    --primary-rgb: 255, 0, 0;
}
```

Now, let’s add another header to make them easier to compare.

```html
<div>
    <h1>Change My Color</h1>
    <h1>I'm Using RGBA</h1>
</div>
```

And, on our second header we’ll use the `rgba()` color function, then inside we’ll use our new primary `rgb` custom property, and let’s give it an alpha value of point five.

```css
h1:last-child {
    color: rgba(var(--primary-rgb), 0.5);
}
```

And there we go, now it works.

<div>
<img src="{{ '/assets/img/content/uploads/2023/11-24/rgba-with-rgb-custom-property-example.png' | relative_url }}" alt="Example using an rgb color as a custom property with the rgba color function" width="1674" height="894" style="width: 100%; height: auto;">
</div>

So, in order to use the `rgba()` color function with custom properties all we need to do is start with `rgb` values.

## Want to See It in Action?
Check out the demo code and examples of these techniques in the Codepen example below. If you have any questions or thoughts, don’t hesitate to leave a comment.

<p class="codepen" data-height="600" data-slug-hash="qBgoapN" data-user="brianmtreese" style="height: 600px; box-sizing: border-box; display: flex; align-items: center; justify-content: center; border: 2px solid; margin: 1em 0; padding: 1em;">
  <span>See the Pen <a href="https://codepen.io/brianmtreese/pen/qBgoapN">
  CSS Custom Properties With the rgba() Color Function</a> by Brian (<a href="https://codepen.io/brianmtreese">@brianmtreese</a>)
  on <a href="https://codepen.io">CodePen</a>.</span>
</p>
<script async src="https://cpwebassets.codepen.io/assets/embed/ei.js"></script>
