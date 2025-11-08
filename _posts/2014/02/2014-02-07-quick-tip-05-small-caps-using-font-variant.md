---
layout: post
title: "Quick Tip - 05: Small Caps Using font-variant"
date: "2014-02-07"
tags:
  - "Accessibility"
  - "CSS"
  - "HTML"
  - "SVG"
  - "Typography"
---

<p class="intro"><span class="dropcap">E</span>ver needed to use small caps in a website? They can add a really nice typographic touch in certain circumstances, but I've never really taken advantage of them with CSS.</p>

It's really easy to add small caps using `font-variant`, here's how:

## The CSS:

```css
h2 {
    font-variant: small-caps
}
```

## The HTML:

```html
<h2>See I'm Using Small Caps</h2>
```

## The Demo:

<style>
.demoBox h2 { font-variant: small-caps; margin-top: 17px; text-align: center; }
</style>

<div class="demoBox">
<h2>See I’m Using Small Caps</h2>
</div>

## Browser Support:

<div class="browserSupport__list">
<img src="../../assets/img/ie.svg" alt="ie10 and above" title="ie10 and above">
<img src="../../assets/img/chrome.svg" alt="Chrome 31 and above" title="Chrome 31 and above">
<img src="../../assets/img/firefox.svg" alt="Fire Fox 26 and above" title="Fire Fox 26 and above">
<img src="../../assets/img/safari.svg" alt="Safari 7 and above" title="Safari 7 and above">
</div>

The font-variant property has good browser support working in all modern browsers. Not supported in Internet Explorer 9 and below.

* * *

## Sources

- [http://caniuse.com/](http://caniuse.com/)

- [https://developer.mozilla.org/en-US/docs/Web/CSS/font-variant](https://developer.mozilla.org/en-US/docs/Web/CSS/font-variant)
