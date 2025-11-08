---
layout: post
title: "Quick Tip - 02: Use CSS Calc to Properly Position Background Images"
date: "2014-01-17"
tags:
  - "CSS"
  - "HTML"
  - "SVG"
---


<p class="intro"><span class="dropcap">I</span>f you would have asked me about the CSS Calc function six months or so ago I would have said "What's That?". But luckily for me I stumbled across some blog post highlighting the coolest new CSS stuff that's available for us to use and CSS Calc was one of them. It's really a pretty useful item to have at our disposal.</p>

```css
calc(expression)
```

It allows you to do math without the need of a preprocessor. With CSS Calc your imagination is the only limit to what you can do. One of my favorites is that you can use CSS Calc to properly position background images based off of the bottom right corner. Without Calc this just isn't possible unless you add extra blank space to the image or something.

## The HTML:

```html
<div class="item">
    Checkout My Background!
</div>
```

## The CSS:

```css
.item {
    background-image: url(graphic.svg);
    background-position: calc(100% - 20px) calc(100% - 20px);
    background-repeat: no-repeat;
    height: 170px;
}
```

## The Demo:

<div class="demoBox" style="background-image: url('../../assets/img/content/uploads/2014/01/graphic.svg'); background-position: calc(100% - 20px) calc(100% - 20px); background-repeat: no-repeat; height: 170px; margin-bottom: 25px;">Checkout My Background!</div>

## Browser Support

<div class="browserSupport__list">
<img src="../../assets/img/ie.svg" alt="ie9 and above" title="ie9 and above">
<img src="../../assets/img/chrome.svg" alt="Chrome 31 and above" title="Chrome 31 and above">
<img src="../../assets/img/firefox.svg" alt="Fire Fox 25 and above" title="Fire Fox 25 and above">
<img src="../../assets/img/safari.svg" alt="Safari 7 and above" title="Safari 7 and above">
</div>

The CSS Calc function has good browser support working in all modern browsers. Not supported in Internet Explorer 8 and below.

* * *

### Sources

- [http://caniuse.com/](http://caniuse.com/)

- [https://developer.mozilla.org/en-US/docs/Web/CSS/calc](https://developer.mozilla.org/en-US/docs/Web/CSS/calc)

- [http://css-tricks.com/a-couple-of-use-cases-for-calc/](http://css-tricks.com/a-couple-of-use-cases-for-calc/)
