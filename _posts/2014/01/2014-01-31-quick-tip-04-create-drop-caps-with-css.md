---
layout: post
title: "Quick Tip - 04: Create Drop Caps With CSS"
date: "2014-01-31"
tags: 
  - "CSS"
  - "Typography"
---

<p class="intro"><span class="dropcap">C</span>SS drop caps came up in a discussion with a co-worker the other day. I don't use drop caps in web sites I design, but there's really no reason why I shouldn't.</p>

## Example

Here's how you can create drop caps with CSS using the :first-letter pseudo-class:

### The Code:

```css
.sample:first-letter {
     font-size: 490%; 
     float: left; 
     line-height: 0.9;
     margin: 0 12px -8px 0;
}
```

### Demo:

<style>
.sample1:first-letter { font-size: 490%; line-height: 0.9; float: left; margin: 0.07em 12px -8px 0; }

#demo1 .sample:first-letter { font-size: 490%; float: left; line-height: 0.9; margin: 0 12px -8px 0; } #demo1 p { margin-bottom: 0; }
</style>

<div id="demo1" class="demoBox demoBox--content">
<p class="sample1">Lorem ipsum dolor sit amet, consectetuer adipiscing elit. Aenean commodo ligula eget dolor. Aenean massa. Cum sociis natoque penatibus et magnis dis parturient montes, nascetur ridiculus mus. Donec quam felis, ultricies nec, pellentesque eu, pretium quis, sem. Nulla consequat massa quis enim. Donec pede justo, fringilla vel, aliquet nec, vulputate eget, arcu. In enim justo, rhoncus ut, imperdiet a, venenatis vitae, justo. Nullam dictum felis eu pede mollis pretium. Integer tincidunt.</p>
</div>

## Different Styles

You can even spice it up by applying a background color so that it will be contained within a square.

### The Code:

```css
.sample:first-letter {
    background: #3dc0d1; 
    color: #fff; 
    font-size: 380%; 
    line-height: 0.9; 
    float: left; 
    margin: 12px 12px -8px 0; 
    padding: 0 9px 0 4px;
}
```

### Demo:

<style>
.sample2:first-letter { background: #3dc0d1; color: #fff; font-size: 380%; line-height: 0.9; float: left; margin: 12px 12px -8px 0; padding: 0 9px 0 4px; }

#demo2 .sample:first-letter { background: #3dc0d1; color: #fff; font-size: 380%; line-height: 0.9; float: left; margin: 12px 12px -8px 0; padding: 0 9px 0 4px; } #demo2 p { margin-bottom: 0; }
</style>

<div id="demo2" class="demoBox demoBox--content">
<p class="sample2">Lorem ipsum dolor sit amet, consectetuer adipiscing elit. Aenean commodo ligula eget dolor. Aenean massa. Cum sociis natoque penatibus et magnis dis parturient montes, nascetur ridiculus mus. Donec quam felis, ultricies nec, pellentesque eu, pretium quis, sem. Nulla consequat massa quis enim. Donec pede justo, fringilla vel, aliquet nec, vulputate eget, arcu. In enim justo, rhoncus ut, imperdiet a, venenatis vitae, justo. Nullam dictum felis eu pede mollis pretium. Integer tincidunt.</p>
</div>

## Browser Support

<div class="browserSupport__list">
<img src="../../assets/img/ie.svg" alt="ie7 and above" title="ie7 and above">
<img src="../../assets/img/chrome.svg" alt="Chrome 5 and above" title="Chrome 5 and above">
<img src="../../assets/img/firefox.svg" alt="Fire Fox 3 and above" title="Fire Fox 3 and above">
<img src="../../assets/img/safari.svg" alt="Safari 3 and above" title="Safari 3 and above">
</div>

The `:first-letter` pseudo class has good browser support working in all modern browsers. Not supported in Internet Explorer 6 and below.
