---
layout: post
title: "How to Create a Text Glow Effect Using CSS3"
date: "2013-12-04"
tags: 
  - "CSS"
---

<p class="intro"><span class="dropcap">I</span>'ve often found myself in a position where I want to add a simple text glow effect to some text when hovering over a link. Before CSS3 the only way this was possible was to use some sort of image replacement technique or something.</p>

Well, now it can all be done with the CSS `text-shadow` property. Here's how to create a text glow effect using CSS3.

### The Code:

```css
h1:hover {
    text-shadow: -1px 1px 8px #ffc, 1px -1px 8px #fff;
}
```

### Demo:

<style>
.exampleHover__textShaddow { font-size: 250%; text-align: center; padding: 1.5em 0; } .exampleHover__textShaddow--text:hover { text-shadow: -1px 1px 8px #ffc, 1px -1px 8px #fff; }
</style>

<div class="demoBox exampleHover__textShaddow">
  <div class="exampleHover__textShaddow--text">Hover Over Me</div>
</div>

### Browser Support

<div class="browserSupport__list">
  <img src="../../assets/img/ie.svg" alt="ie10 and above" title="ie10 and above">
  <img src="../../assets/img/chrome.svg" alt="Chrome 29 and above" title="Chrome 29 and above">
  <img src="../../assets/img/firefox.svg" alt="Fire Fox 24 and above" title="Fire Fox 24 and above">
  <img src="../../assets/img/safari.svg" alt="Safari 5.1 and above" title="Safari 5.1 and above">
</div>

The text-shadow property has good browser support working in all modern browsers. Not supported in Internet Explorer 9 and below.

* * *

## Sources

- [http://caniuse.com/](http://caniuse.com/)
