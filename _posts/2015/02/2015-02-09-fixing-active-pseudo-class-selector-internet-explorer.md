---
layout: post
title: "Fixing the :active Pseudo Class Selector in Internet Explorer"
date: "2015-02-09"
tags:
  - "Animation"
  - "CSS"
  - "HTML"
  - "Pseudo Element"
  - "SVG"
---

<p class="intro"><span class="dropcap">S</span>ometimes it's necessary to have a link that contains some children elements. Say, for example, you have a link that contains some text and an inline SVG icon that's styled using CSS. This set up allows you to style the icon for all of the link states `:hover`, `:visited`, and `:active` right? Well yes, with the exception of the `:active` state in Internet Explorer. Well, not without a work around at least.</p>

<style>
.demoBox svg {fill: currentColor; height: 4em; width: 4em;}.demoBox a {display: inline-block; width: 4em;}.demoBox a:active {background: transparent !important;}.demoBox a:active span {color: pink !important}
.demoBox span {
    white-space: nowrap;
}
</style>

## How it Should Work

Say I want apply a `transform: scale(0.7);` to an inline svg when the link is active.

### The HTML

```html
<a href="/info.html">
    <svg viewBox="2.672 2.672 26.656 26.656">
        <path d="M16,2.672C8.639,2.672,2.672,8.64,2.672,16c0,7.361,5.968,13.328,13.328,13.328c7.359,0,13.328-5.967,13.328-13.328 C29.328,8.639,23.359,2.672,16,2.672z M16,28.262C9.239,28.262,3.738,22.761,3.738,16S9.238,3.738,16,3.738 c6.762,0,12.262,5.501,12.262,12.262S22.762,28.262,16,28.262z"/>
        <path d="M14.974,9.978c0-0.286,0.087-0.528,0.262-0.726c0.175-0.196,0.435-0.295,0.778-0.295c0.344,0,0.604,0.099,0.784,0.295 c0.178,0.197,0.266,0.439,0.266,0.726s-0.088,0.525-0.266,0.716c-0.18,0.191-0.439,0.286-0.784,0.286 c-0.343,0-0.603-0.095-0.778-0.286C15.062,10.503,14.974,10.264,14.974,9.978z M16.884,23.043h-1.767V12.717h1.767V23.043z"/>
    </svg>
    Click Me!
</a>
```

### The CSS

```css
a:active svg {
    transform: scale(0.7);
    transition: transform 0.1s ease;
}
```

<style>
.svgTransform__example-01 a:active svg {transform: scale(0.7); transition: transform 0.1s ease;}
</style>

### The Result

<div class="demoBox svgTransform__example-01" style="text-align: center;">
    <a>
        <svg viewBox="2.672 2.672 26.656 26.656">
            <path d="M16,2.672C8.639,2.672,2.672,8.64,2.672,16c0,7.361,5.968,13.328,13.328,13.328c7.359,0,13.328-5.967,13.328-13.328 C29.328,8.639,23.359,2.672,16,2.672z M16,28.262C9.239,28.262,3.738,22.761,3.738,16S9.238,3.738,16,3.738 c6.762,0,12.262,5.501,12.262,12.262S22.762,28.262,16,28.262z"/>
            <path d="M14.974,9.978c0-0.286,0.087-0.528,0.262-0.726c0.175-0.196,0.435-0.295,0.778-0.295c0.344,0,0.604,0.099,0.784,0.295 c0.178,0.197,0.266,0.439,0.266,0.726s-0.088,0.525-0.266,0.716c-0.18,0.191-0.439,0.286-0.784,0.286 c-0.343,0-0.603-0.095-0.778-0.286C15.062,10.503,14.974,10.264,14.974,9.978z M16.884,23.043h-1.767V12.717h1.767V23.043z"/>
        </svg>
        <span>Click Me!</span>
    </a>
</div>

## The Problem: This Doesn't Work in IE

If you try the example above in Internet Explorer the transform will not be applied, even in ie11. Well, actually it will be applied if you click on the link anywhere that is not the inline SVG. If you click the text for example you will see the transition occur.

## The Fix

To fix this I can simply place a pseudo element `:before` or `:after` on the link above all of its contents. This will effectively set the clickable area of the link on a layer above its contents meaning that the click will occur on the link and not the SVG.

### First, Set the Stacking Context

```css
a {
    position: relative;
}
```

### Then, Style the Pseudo Element

```css
a:before {
    content: "";
    display: block;
    position: absolute;
    top: 0;
    right: 0;
    bottom: 0;
    left: 0;
}
```

### The Result

<style>
.svgTransform__example-02 a {position: relative;}.svgTransform__example-02 a:before {content: ""; display: block; position: absolute; top: 0; right: 0; bottom: 0; left: 0;}.svgTransform__example-02 a:active svg {transform: scale(0.7); transition: transform 0.1s ease;}
</style>

<div class="demoBox svgTransform__example-02" style="text-align: center;">
    <a>
        <svg viewBox="2.672 2.672 26.656 26.656">
            <path d="M16,2.672C8.639,2.672,2.672,8.64,2.672,16c0,7.361,5.968,13.328,13.328,13.328c7.359,0,13.328-5.967,13.328-13.328 C29.328,8.639,23.359,2.672,16,2.672z M16,28.262C9.239,28.262,3.738,22.761,3.738,16S9.238,3.738,16,3.738 c6.762,0,12.262,5.501,12.262,12.262S22.762,28.262,16,28.262z"/>
            <path d="M14.974,9.978c0-0.286,0.087-0.528,0.262-0.726c0.175-0.196,0.435-0.295,0.778-0.295c0.344,0,0.604,0.099,0.784,0.295 c0.178,0.197,0.266,0.439,0.266,0.726s-0.088,0.525-0.266,0.716c-0.18,0.191-0.439,0.286-0.784,0.286 c-0.343,0-0.603-0.095-0.778-0.286C15.062,10.503,14.974,10.264,14.974,9.978z M16.884,23.043h-1.767V12.717h1.767V23.043z"/>
        </svg>
        <span>Click Me!</span>
    </a>
</div>
