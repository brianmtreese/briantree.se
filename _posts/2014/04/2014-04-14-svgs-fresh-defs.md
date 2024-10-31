---
layout: post
title: "SVGs are So Fresh to Defs"
date: "2014-04-14"
tags: 
  - "CSS"
  - "SVG"
---

<p class="intro"><span class="dropcap">N</span>o, this is not a hip hop song about SVGs, sorry to those of you who were expecting that. This is another post about good ol' SVG graphics. So most of us know that there is a lot that you can do with SVGs and it can all be done in many different ways. The SVG `defs` element can be used to make SVG code simpler, cleaner, and better.</p>

## What Exactly is the Defs Element?

The SVG `defs` element is a used to contain items that can be referenced and reused from within the current SVG document.

Items contained within the `defs` element are not actually rendered because they are not part of the "rendering tree" but they are part of the "source tree" so they they are available and are able to be referenced elsewhere.

For performance reasons it is recommended that the `defs` element come before all other elements. Since it contains items that are referenced from other locations within the document it works better when they are created before they are referenced.

It is also recommended to use the `defs` element whenever possible because it's easier to understand from a readability perspective and it's also better for accessibility.

## How is it Used?

Let's say you have a design that makes use of multiple circles. You can just add one circle item in the `defs` element and then call it using the SVG `use` element like so:

```html
<svg height="130px" width="250px">
    <defs>
        <circle id="circle" cx="50" cy="50" r="50" />
    </defs>
    <use xlink:href="#circle" x="10" y="20" fill="#00deb7" />
    <use xlink:href="#circle" x="130" y="20" fill="#ff495d" />
</svg>
```

<div class="demoBox" style="margin-bottom: 40px; text-align: center;">
<svg height="130px" width="250px">
    <defs>
        <circle id="circle" cx="50" cy="50" r="50"></circle>
    </defs>
    <use xlink:href="#circle" x="10" y="20" fill="#00deb7"></use>
    <use xlink:href="#circle" x="130" y="20" fill="#ff495d"></use>
</svg>
</div>

One way that you could use this is if you were to save all of the icons for your website or application into a single SVG. You could then grab all of the reusable elements and toss them into your _defs_ element and then just call them setting them up with CSS for those icons that use them. This could greatly simplify and reduce your overall code within the SVG file itself.

## A Real World Example

<p class="codepen" data-height="600" data-default-tab="html,result" data-slug-hash="jOqaaN" data-user="brianmtreese" style="height: 600px; box-sizing: border-box; display: flex; align-items: center; justify-content: center; border: 2px solid; margin: 1em 0; padding: 1em;">
  <span>See the Pen <a href="https://codepen.io/brianmtreese/pen/jOqaaN">
  SVG Defs and Use</a> by Brian (<a href="https://codepen.io/brianmtreese">@brianmtreese</a>)
  on <a href="https://codepen.io">CodePen</a>.</span>
</p>
<script async src="https://cpwebassets.codepen.io/assets/embed/ei.js"></script>

## Browser Support

<div class="browserSupport__list">
<img src="../../assets/img/ie.svg" alt="ie9 and above" title="ie9 and above">
<img src="../../assets/img/chrome.svg" alt="Chrome 17 and above" title="Chrome 17 and above">
<img src="../../assets/img/firefox.svg" alt="Fire Fox 17 and above" title="Fire Fox 17 and above">
<img src="../../assets/img/safari.svg" alt="Safari 6 and above" title="Safari 6 and above">
</div>

The SVG _defs_ element has good browser support working in all modern browsers. Not supported in Internet Explorer 8 and below. 

* * *

## Sources

- [http://www.w3.org/TR/SVGTiny12/single-page.html#struct-DefsElement](http://www.w3.org/TR/SVGTiny12/single-page.html#struct-DefsElement)

- [http://www.smashingmagazine.com/2014/03/05/rethinking-responsive-svg-2](http://www.smashingmagazine.com/2014/03/05/rethinking-responsive-svg-2/)
