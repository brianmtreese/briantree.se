---
layout: post
title: "Modern Web Typography: Kerning"
date: "2014-02-24"
tags:
  - "Accessibility"
  - "CSS"
  - "JavaScript"
  - "SVG"
  - "Typography"
---

<p class="intro"><span class="dropcap">K</span>erning is a very important aspect when it comes to setting type. Unfortunately, until more recent times, it has been left out when it comes to the web.</p>

For those of you that may not be clear on what kerning is, it deals with the spacing between certain pairs of letters letters such as W and A.

<style>
  .demoBox img { display: block; width: 100%; margin-bottom: 0 }
</style>

<div class="demoBox">
  <img src="../../assets/img/content/uploads/2014/without-kerning.svg" alt="Without Kerning">
</div>
<div class="demoBox">
  <img src="../../assets/img/content/uploads/2014/with-kerning.svg" alt="With Kerning">
</div>

Kerning can be built into a font by the font designer or it can be added by the person setting the type. It can increase legibility and is very useful when using large type in a design. Kerning only deals with pairs of letters and is different than letter-spacing/tracking because they deal with the spacing between all letters.

## How to Enable Kerning For An Entire Font Family

As I mentioned, kerning can be built into a font by the font designer. We as web designers and developers just have to let browsers know that we want to use it. This can now be done with CSS although there are some tricks to it. Browser support is currently a little finicky at the moment and will require two properties and vendor prefixes to get the best support.

### text-rendering

The `text-rendering` property was included with the SVG specification and is supported by Chrome, Safari, and Firefox.

```css
p {
  text-rendering: optimizeLegibility;
}
```

The `text-rendering` property has other values that can be passed to it that do other things. Here's all of them and what they do:

- `optimizeSpeed` — Applies focus to speed over the other text-rendering properties when rendering text and disables kerning and ligatures.

- `optimizeLegibility` — Applies focus to legibility over the other text-rendering properties when rendering text and enables kerning and ligatures.

- `geometricPrecision` — Applies focus to geometric precision over the other text-rendering properties when rendering text. Allows the aspects of certain fonts that don't scale well to look better.

- `auto` — Allows the browser to determine how all of the text-rendering properties are applied when rendering text.

### font-feature-settings

The `font-feature-settings` property is a new and experimental CSS property and is in the working draft phase. This property is used to enable/disable certain OpenType features for fonts that have them. Kerning is one of the font features that can be enabled/disabled with the `font-feature-settings` property. Due to its new-ness it requires vendor specific prefixes and syntax.

```css
p {
  text-rendering: optimizeLegibility;
  font-feature-settings: "kern";
  -webkit-font-feature-settings: "kern";
  -moz-font-feature-settings: "kern";
  -moz-font-feature-settings: "kern=1";
}
```

## How to Fine Tune Kerning For Specific Font Pairs

Enabling kerning for legibility in body text is all fine and dandy but what if you want to fine tune the kerning and have absolute control over a specific paring in a particular heading? This can not be done with plain ol' CSS just yet. It will require something else like extra html or JavaScript. There are a couple of really handy tools available that can give you this control where you need it.

### [Kernjs](http://www.kernjs.com/)

This is a bookmarklet that lets you click on individual characters on your own website and then drag until you are happy with the way it looks. Once you are done you can simply click on an icon and then copy the CSS. It requires you to add a span for each character that you want to adjust the kerning on and it generates the CSS via negative and positive margins that will be applied to the characters.

### [Letteringjs](http://letteringjs.com/)

This is a JavaScript library that allows for absolute control over aspects of individual characters. It basically provides a JavaScript function that can be passed to an html element to generate spans with incremented numeric class names for each individual character in the element. Those spans can then be manipulated with CSS however you'd like. It is advised to use this plugin sparingly due to the performance issues that could arise by wrapping too many characters in a page in spans with JavaScript.

* * *

## Browser Support

<div class="browserSupport__list">
<img src="../../assets/img/ie.svg" alt="ie10 and above" title="ie10 and above">
<img src="../../assets/img/chrome.svg" alt="Chrome 31 and above" title="Chrome 31 and above">
<img src="../../assets/img/firefox.svg" alt="Fire Fox 26 and above" title="Fire Fox 26 and above">
<img src="../../assets/img/safari.svg" alt="Safari 6 and above" title="Safari 6 and above">
</div>

This CSS text-rendering and font-feature-settings combination has pretty good browser support working in all modern browsers. It is, however, not supported at all in Chrome on Windows at the moment but likely will be in the near future. Not supported in ie9 and below.

* * *

## Sources

- [http://caniuse.com](http://caniuse.com/)

- [http://blog.typekit.com/2014/02/05/kerning-on-the-web](http://blog.typekit.com/2014/02/05/kerning-on-the-web/)

- [http://adamdscott.com/kerning-for-the-web](http://adamdscott.com/kerning-for-the-web/)

- [https://developer.mozilla.org/en-US/docs/Web/CSS/text-rendering](https://developer.mozilla.org/en-US/docs/Web/CSS/text-rendering)

- [https://developer.mozilla.org/en-US/docs/Web/CSS/font-feature-settings](https://developer.mozilla.org/en-US/docs/Web/CSS/font-feature-settings)
