---
layout: post
title: "Normal, Condensed, or Expanded Font Faces With CSS font-stretch"
date: "2014-05-20"
tags:
  - "CSS"
  - "SVG"---

<p class="intro"><span class="dropcap">H</span>ave you ever attempted to use a condensed or expanded font face from a particular font family using CSS? How did you do it? Did you create a new web font with a subset of the condensed or expanded versions? Well, thanks to CSS3 there's now a better way, [sort of](#sortof).</p>

<style>
.demoBox { text-align: center; }
</style>

## CSS font-stretch

The CSS font-stretch property will properly select the specified font face, normal, condensed or expanded if one exists.

<div class="demoBox">
  <img src="../../assets/img/content/uploads/2014/05/normal.svg" alt="CSS font-stretch normal">
</div>

<div class="demoBox">
  <img src="../../assets/img/content/uploads/2014/05/condensed.svg" alt="CSS font-stretch condensed">
</div>

This property does not physically stretch or squish the type, it simply selects the proper font face.

## font-stretch Properties

The available font-stretch properties are:

- `ultra-condensed` — uses the most condensed font face available
- `extra-condensed` — uses the next most condensed font face available after `ultra-condensed`
- `condensed` — uses the next most condensed font face available after `extra-condensed`
- `semi-condensed` — uses the next most condensed font face available after `condensed`
- `normal` — uses the normal font face
- `semi-expanded` — uses the next expanded font face available after `normal`
- `expanded` — uses the next expanded font face available after `semi-expanded`
- `extra-expanded` — uses the next expanded font face available after `expanded`
- `ultra-expanded` — uses the most expanded font face available after `extra-expanded`
- `inherit` — inherits its font-stretch value from its parent

## The Sort of...

So, this is a better solution, sort of. The problem is that the font-stretch property is currently in the W3C Candidate Recommendation phase. This means that it is considered an experimental technology and is subject to change. Thus, the font-stretch property has pretty spotty browser support so it's not quite ready for prime time.

* * *

## Browser Support

<div class="browserSupport__list">
<img title="ie9 and above" src="../../assets/img/ie.svg" alt="ie9 and above">
<img title="Fire Fox 9 and above" src="../../assets/img/firefox.svg" alt="Fire Fox 9 and above"></div> 

The font-stretch property doesn't have very good browser support only working in internet explorer 9+ and Firefox 9+.

* * *

## Sources

- [https://developer.mozilla.org/en-US/docs/Web/CSS/font-stretch#Browser\_compatibility](https://developer.mozilla.org/en-US/docs/Web/CSS/font-stretch#Browser_compatibility)
- [http://css-tricks.com/almanac/properties/f/font-stretch/](http://css-tricks.com/almanac/properties/f/font-stretch/)
