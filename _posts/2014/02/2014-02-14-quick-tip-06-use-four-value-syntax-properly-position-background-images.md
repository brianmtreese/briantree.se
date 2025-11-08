---
layout: post
title: "Quick Tip - 06: Use the Four-Value Syntax to Properly Position Background Images"
date: "2014-02-14"
tags:
  - "CSS"
  - "HTML"
  - "SVG"
---

<p class="intro"><span class="dropcap">A</span>fter writing my post <a href="/quick-tip-02-use-css-calc-properly-position-background-images/">Use CSS Calc to Properly Position Background Images</a> I had some folks point out that you can now use the new Four-Value syntax for the background-position property to achieve the same effect. I was absolutely blown away when I saw that this was finally possible. I'm mean, this just makes sense and it's something that I've wanted for years.</p>

## Here's How You Use it

The Four-Value syntax supports offsets from any edge, in this case I'm using right, bottom.

### The HTML:

```html
<div class="item">
    Checkout My Background!
</div>
```

### The CSS:

```css
.item {
    background-image: url(graphic.svg);
    background-position: right 20px bottom 20px;
    background-repeat: no-repeat;
    height: 170px;
}
```

### The Demo:

<div class="demoBox" style="background-image: url('../../assets/img/content/uploads/2014/01/graphic.svg'); background-position: right 20px bottom 20px; background-repeat: no-repeat; height: 170px; margin-bottom: 25px;">Checkout My Background!</div>

## Browser Support

<div class="browserSupport__list">
<img src="../../assets/img/ie.svg" alt="ie9 and above" title="ie9 and above">
<img src="../../assets/img/chrome.svg" alt="Chrome 25 and above" title="Chrome 25 and above">
<img src="../../assets/img/safari.svg" alt="Safari Nightly" title="Safari Nightly">
<img src="../../assets/img/firefox.svg" alt="Fire Fox 13 and above" title="Fire Fox 13 and above">
</div>

The Four-Value syntax has pretty good browser support working in all modern browsers with the exception of Safari. From what I've been able to find it works in Safari Nightly but is not yet supported in safari mobile or android mobile. Although, I've tested it in Safari mobile and it appears to work just fine.

* * *

### Sources

- [https://developer.mozilla.org/en-US/docs/Web/CSS/background-position](https://developer.mozilla.org/en-US/docs/Web/CSS/background-position)
