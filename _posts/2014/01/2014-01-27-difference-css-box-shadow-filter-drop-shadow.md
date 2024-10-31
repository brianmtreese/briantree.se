---
layout: post
title: "The Difference Between CSS box-shadow and filter: drop-shadow();"
date: "2014-01-27"
tags: 
  - "CSS"
---

<p class="intro"><span class="dropcap">N</span>ormally when I need to add a drop shadow to an element I will use CSS box-shadow. There's another way that I can handle this though. I can use CSS filters. They allow me to do many different things like apply gray-scale, apply sepia, blur, adjust brightness, adjust contrast, adjust hue, invert colors, saturate colors, and alter opacity.</p>

The easiest way to think about CSS filters is to compare them to Adobe PhotoShop filters. The two apply themselves similarly. There's a lot to CSS filters, so much so that they are deserving of their own post. In this article I'm going to focus on drop-shadow and explain the difference between CSS box-shadow and filter: drop-shadow();.

<style>
.demoTriangle { border-left: solid 120px transparent; border-right: solid 120px transparent; border-top: solid 120px #fff; height: 0; margin: 0 auto; width: 0; } .boxShadow { box-shadow: 4px 4px 5px rgba(50, 50, 50, 0.75); } .dropShadow { -webkit-filter: drop-shadow(4px 4px 5px rgba(50, 50, 50, 0.75)); filter: drop-shadow(4px 4px 5px rgba(50, 50, 50, 0.75)); }
</style>

## Let's Start With box-shadow

The box-shadow property will work fine for a lot of things. For example, If you are applying a box-shadow to a square, rectangle, or even a circle using border radius, it will suit your needs just fine. But if you are doing something else like using a CSS triangle or png image with transparency, your're going to run into problems.

```css
.demoTriangle { 
    border-left: solid 120px transparent; 
    border-right: solid 120px transparent; 
    border-top: solid 120px #fff; 
    box-shadow: 4px 4px 5px rgba(50, 50, 50, 0.75);
    height: 0; 
    width: 0; 
}
```

<style>
#demo1 { display: flex; justify-content: center; } #demo1 .demoTriangle { border-left: solid 120px transparent; border-right: solid 120px transparent; border-top: solid 120px #fff; box-shadow: 4px 4px 5px rgba(50, 50, 50, 0.75); height: 0; width: 0; }
</style>

<div id="demo1" class="demoBox demoBox--alt02">
<div class="demoTriangle boxShadow">&nbsp;</div>
</div>

## Problem Solved, Use filter: drop-shadow();

We can solve this issue by using the new CSS `filter: drop-shadow();` property.

```css
.demoTriangle { 
    -webkit-filter: drop-shadow(4px 4px 5px rgba(50, 50, 50, 0.75));
    filter: drop-shadow(4px 4px 5px rgba(50, 50, 50, 0.75));
}
```

<style>
#demo2 { display: flex; justify-content: center; } #demo2 .demoTriangle { border-left: solid 120px transparent; border-right: solid 120px transparent; border-top: solid 120px #fff; height: 0; width: 0; -webkit-filter: drop-shadow(4px 4px 5px rgba(50, 50, 50, 0.75)); filter: drop-shadow(4px 4px 5px rgba(50, 50, 50, 0.75)); }
</style>

<div id="demo2" class="demoBox demoBox--alt03">
<div class="demoTriangle dropShadow">&nbsp;</div>
</div>

### How Does it Work?

The CSS drop-shadow filter accepts the same values as the CSS box-shadow property.

- `x-offset` — this value is required - it sets the distance, in a value of %, px, or em, that the shadow will be offset along the x-axis

- `x-offset` — this value is required - it sets the distance, in a value of %, px, or em, that the shadow will be offset along the y-axis

- `blur-radius` — this value is optional - it controls the sharpness of the drop-shadow's edge, larger values will make the shadow more blurred

- `spread-radius` — this value is optional - it controls how the drop-shadow grows and shrinks, positive values cause it to grow and negative values cause it to shrink

- `color` — this value is optional - it sets the color of the shadow

### Pros

- Works the same as box-shadow so there's not much to learn

- Solves problems like the ones noted above

### Cons

- Lack of browser support

- Spec is still in the working draft phase so things may change

* * *

## Browser Support

<div class="browserSupport__list">
<img src="../../assets/img/chrome.svg" alt="Chrome 18 and above using -webkit-" title="Chrome 18 and above using -webkit-">
<img src="../../assets/img/safari.svg" alt="Safari 7 and above" title="Safari 7 and above using -webkit-">
</div>

Browser support is not great. CSS filters are still considered experimental because the spec is still in the working draft phase. There is currently no support in Firefox and ie, nope not even ie11.

* * *

## Sources

- [http://caniuse.com/](http://caniuse.com/)

- [https://developer.mozilla.org/en-US/docs/Web/CSS/filter](https://developer.mozilla.org/en-US/docs/Web/CSS/filter)

- [http://bricss.net/post/33158273857/box-shadow-vs-filter-drop-shadow](http://bricss.net/post/33158273857/box-shadow-vs-filter-drop-shadow)
