---
layout: post
title: "Quick Tip – 13: Quickly Apply Colors Using currentColor"
date: "2014-04-04"
tags:
  - "CSS"
  - "SVG"---

<p class="intro"><span class="dropcap">I</span>f you've ever wanted to do something like set the borders on a container to the same color as the text within it you can easily do it using <code>currentColor</code>.</p>

`currentColor` can be used for anything that accepts a color value like box-shadow, background-color, etc.

## The CSS

```css
.parent {
    color: red;
}

.child {
    border: solid 3px currentColor;
}
```

## The Demo

<div class="demoBox demoBox--content" style="color: red; margin-bottom: 30px;">
<div style="border: solid 3px currentColor; padding: 8px 12px;">My border should have a color of red which matches the color of my text</div>
</div>

## Browser Support

<div class="browserSupport__list">
<img src="../../assets/img/ie.svg" alt="ie9 and above" title="ie9 and above">
<img src="../../assets/img/chrome.svg" alt="Chrome 1 and above" title="Chrome 1 and above">
<img src="../../assets/img/firefox.svg" alt="Fire Fox 3.5 and above" title="Fire Fox 3.5 and above">
<img src="../../assets/img/safari.svg" alt="Safari 4 and above" title="Safari 4 and above">
</div>

CSS currentColor has pretty good browser support working in all modern browsers. Not supported in ie8 and below.
