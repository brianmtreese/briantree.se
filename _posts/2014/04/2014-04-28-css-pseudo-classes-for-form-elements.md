---
layout: post
title: "CSS Pseudo Classes for Form Elements"
date: "2014-04-28"
tags: 
  - "CSS"
  - "HTML"
  - "Forms"
---

<p class="intro"><span class="dropcap">C</span>SS provides us with a handful of pseudo classes that are specific to HTML5 forms. They allow us to create forms that are easier to fill out by highlighting fields that are required, optional, valid, invalid, etc.</p> 

<style>
.browserSupport__list div {padding-bottom: 0.6em; padding-left: 0.6em} iframe {margin-top: 0;}
</style>

## Pseudo Classes for Forms

The following pseudo classes are all related to form elements with examples on how they are used.

### :default

The `:default` pseudo class applies to the default element in a group of similar elements within a given form. For example, if you have a form that has a submit and cancel button you could select the default button using :default.

<p class="codepen" data-height="225" data-theme-id="0" data-slug-hash="gsilz" data-default-tab="result">See the Pen <a href="http://codepen.io/brianmtreese/pen/gsilz/">gsilz</a> by Brian (<a href="http://codepen.io/brianmtreese">@brianmtreese</a>) on <a href="http://codepen.io">CodePen</a>.</p>

`:default` is supported in

<div class="browserSupport__list">
  <img title="Chrome 10 and above" src="../../assets/img/chrome.svg" alt="Chrome 10 and above">
  <img title="Fire Fox 4 and above" src="../../assets/img/firefox.svg" alt="Fire Fox 4 and above">
  <img title="Opera 10 and above" src="../../assets/img/opera.svg" alt="Opera 10 and above">
  <img title="Safari 5 and above" src="../../assets/img/safari.svg" alt="Safari 5 and above">
</div> 

### :required

The `:required` pseudo class applies to any input with the _required_ attribute set within a given form. This can be very useful to highlight the required fields within a form.

<p class="codepen" data-height="225" data-theme-id="0" data-slug-hash="dynGK" data-default-tab="result">See the Pen <a href="http://codepen.io/brianmtreese/pen/dynGK/">dynGK</a> by Brian (<a href="http://codepen.io/brianmtreese">@brianmtreese</a>) on <a href="http://codepen.io">CodePen</a>.</p>

`:required` is supported in

<div class="browserSupport__list">
  <img title="ie10 and above" src="../../assets/img/ie.svg" alt="ie10 and above">
  <img title="Chrome 10 and above" src="../../assets/img/chrome.svg" alt="Chrome 10 and above">
  <img title="Fire Fox 4 and above" src="../../assets/img/firefox.svg" alt="Fire Fox 4 and above">
  <img title="Opera 10 and above" src="../../assets/img/opera.svg" alt="Opera 10 and above">
  <img title="Safari 5 and above" src="../../assets/img/safari.svg" alt="Safari 5 and above"> 
</div>

### :optional

The `:optional` pseudo class applies to any input without the _required_ attribute set within a given form. May or may not be useful since most of the time simply highlighting the required fields will be enough.

<p class="codepen" data-height="225" data-theme-id="0" data-slug-hash="vCgpo" data-default-tab="result">See the Pen <a href="http://codepen.io/brianmtreese/pen/vCgpo/">vCgpo</a> by Brian (<a href="http://codepen.io/brianmtreese">@brianmtreese</a>) on <a href="http://codepen.io">CodePen</a>.</p>

`:optional` is supported in

<div class="browserSupport__list">
  <img title="ie10 and above" src="../../assets/img/ie.svg" alt="ie10 and above">
  <img title="Chrome 10 and above" src="../../assets/img/chrome.svg" alt="Chrome 10 and above">
  <img title="Fire Fox 4 and above" src="../../assets/img/firefox.svg" alt="Fire Fox 4 and above">
  <img title="Opera 10 and above" src="../../assets/img/opera.svg" alt="Opera 10 and above">
  <img title="Safari 5 and above" src="../../assets/img/safari.svg" alt="Safari 5 and above">
</div> 

### :valid

The `:valid` pseudo class applies to any input that contains valid data within a given form. This can be very useful as it will provide the user with feedback as they are filling out the form.

<p class="codepen" data-height="225" data-theme-id="0" data-slug-hash="JcFhe" data-default-tab="result">See the Pen <a href="http://codepen.io/brianmtreese/pen/JcFhe/">JcFhe</a> by Brian (<a href="http://codepen.io/brianmtreese">@brianmtreese</a>) on <a href="http://codepen.io">CodePen</a>.</p>

`:valid` is supported in

<div class="browserSupport__list">
  <img title="ie10 and above" src="../../assets/img/ie.svg" alt="ie10 and above">
  <img title="Chrome 10 and above" src="../../assets/img/chrome.svg" alt="Chrome 10 and above">
  <img title="Fire Fox 4 and above" src="../../assets/img/firefox.svg" alt="Fire Fox 4 and above">
  <img title="Opera 10 and above" src="../../assets/img/opera.svg" alt="Opera 10 and above">
  <img title="Safari 5 and above" src="../../assets/img/safari.svg" alt="Safari 5 and above">
</div>

### :invalid

The `:invalid` pseudo class applies to any input that contains invalid data within a given form. This can be very useful as it will provide the user with feedback as they are filling out the form.

<p class="codepen" data-height="225" data-theme-id="0" data-slug-hash="ItkGn" data-default-tab="result">See the Pen <a href="http://codepen.io/brianmtreese/pen/ItkGn/">ItkGn</a> by Brian (<a href="http://codepen.io/brianmtreese">@brianmtreese</a>) on <a href="http://codepen.io">CodePen</a>.</p>

`:invalid` is supported in

<div class="browserSupport__list">  
  <img title="ie10 and above" src="../../assets/img/ie.svg" alt="ie10 and above">
  <img title="Chrome 10 and above" src="../../assets/img/chrome.svg" alt="Chrome 10 and above">
  <img title="Fire Fox 4 and above" src="../../assets/img/firefox.svg" alt="Fire Fox 4 and above">
  <img title="Opera 10 and above" src="../../assets/img/opera.svg" alt="Opera 10 and above">
  <img title="Safari 5 and above" src="../../assets/img/safari.svg" alt="Safari 5 and above">
</div>

### :in-range

The `:in-range` pseudo class applies to any form element that contains a value within the specified range for the input within a given form. Similar to valid/invalid it can be useful for providing feedback to the user when filling out the form.

<p class="codepen" data-height="225" data-theme-id="0" data-slug-hash="fckHB" data-default-tab="result">See the Pen <a href="http://codepen.io/brianmtreese/pen/fckHB/">fckHB</a> by Brian (<a href="http://codepen.io/brianmtreese">@brianmtreese</a>) on <a href="http://codepen.io">CodePen</a>.</p>

`:in-range` is supported in

<div class="browserSupport__list">
  <img title="Chrome 10 and above" src="../../assets/img/chrome.svg" alt="Chrome 10 and above">
  <img title="Fire Fox 28 and above" src="../../assets/img/firefox.svg" alt="Fire Fox 28 and above">
  <img title="Opera 11 and above" src="../../assets/img/opera.svg" alt="Opera 11 and above">
  <img title="Safari 5.2 and above" src="../../assets/img/safari.svg" alt="Safari 5.2 and above">
</div>

### :out-of-range

The `:out-of-range` pseudo class applies to any form element that contains a value outside the specified range for the input within a given form. Similar to valid/invalid it can be useful for providing feedback to the user when filling out the form.

<p class="codepen" data-height="225" data-theme-id="0" data-slug-hash="yirbF" data-default-tab="result">See the Pen <a href="http://codepen.io/brianmtreese/pen/yirbF/">yirbF</a> by Brian (<a href="http://codepen.io/brianmtreese">@brianmtreese</a>) on <a href="http://codepen.io">CodePen</a>.</p>

`:out-of-range` is supported in

<div class="browserSupport__list">
  <img title="Chrome 10 and above" src="../../assets/img/chrome.svg" alt="Chrome 10 and above">
  <img title="Fire Fox 28 and above" src="../../assets/img/firefox.svg" alt="Fire Fox 28 and above">
  <img title="Opera 11 and above" src="../../assets/img/opera.svg" alt="Opera 11 and above">
  <img title="Safari 5.2 and above" src="../../assets/img/safari.svg" alt="Safari 5.2 and above">
</div>

### :read-only

The `:read-only` pseudo class applies to any input with the _readonly_ attribute set on it in a given form. It can be useful to gray out disabled fields for forms.

<p class="codepen" data-height="225" data-theme-id="0" data-slug-hash="BodAt" data-default-tab="result">See the Pen <a href="http://codepen.io/brianmtreese/pen/BodAt/">BodAt</a> by Brian (<a href="http://codepen.io/brianmtreese">@brianmtreese</a>) on <a href="http://codepen.io">CodePen</a>.</p>

`:read-only` is supported in

<div class="browserSupport__list">
  <img title="Chrome" src="../../assets/img/chrome.svg" alt="Chrome">
  <img title="Fire Fox" src="../../assets/img/firefox.svg" alt="Fire Fox">
  <img title="Safari" src="../../assets/img/safari.svg" alt="Safari">
</div>

### :read-write

The `:read-write` pseudo class applies to any input without the _readonly_ attribute set on it in a given form.

<p class="codepen" data-height="225" data-theme-id="0" data-slug-hash="GmAwz" data-default-tab="result">See the Pen <a href="http://codepen.io/brianmtreese/pen/GmAwz/">GmAwz</a> by Brian (<a href="http://codepen.io/brianmtreese">@brianmtreese</a>) on <a href="http://codepen.io">CodePen</a>.</p>

`:read-write` is supported in

<div class="browserSupport__list">
  <img title="Chrome" src="../../assets/img/chrome.svg" alt="Chrome">
  <img title="Fire Fox" src="../../assets/img/firefox.svg" alt="Fire Fox">
  <img title="Safari" src="../../assets/img/safari.svg" alt="Safari">
</div> 

* * *

## Client Side Only

The important thing to remember when using CSS and HTML validation to style your forms is that they are only client side validation. You will still need to validate on the server as well. The role that CSS and these pseudo classes play is to simply enhance the form and make it easier for users to fill out.

* * *

## Sources

- [http://html5doctor.com/css3-pseudo-classes-and-html5-forms](http://html5doctor.com/css3-pseudo-classes-and-html5-forms/)
- [https://developer.mozilla.org/en-US/docs/Web/CSS/:default](https://developer.mozilla.org/en-US/docs/Web/CSS/:default)
- [https://developer.mozilla.org/en-US/docs/Web/CSS/:required](https://developer.mozilla.org/en-US/docs/Web/CSS/:required)
- [https://developer.mozilla.org/en-US/docs/Web/CSS/:optional](https://developer.mozilla.org/en-US/docs/Web/CSS/:optional)
- [https://developer.mozilla.org/en-US/docs/Web/CSS/:valid](https://developer.mozilla.org/en-US/docs/Web/CSS/:valid)
- [https://developer.mozilla.org/en-US/docs/Web/CSS/:invalid](https://developer.mozilla.org/en-US/docs/Web/CSS/:invalid)
- [https://developer.mozilla.org/en-US/docs/Web/CSS/:in-range](https://developer.mozilla.org/en-US/docs/Web/CSS/:in-range)
- [https://developer.mozilla.org/en-US/docs/Web/CSS/:out-of-range](https://developer.mozilla.org/en-US/docs/Web/CSS/:out-of-range)
- [https://developer.mozilla.org/en-US/docs/Web/CSS/:read-write](https://developer.mozilla.org/en-US/docs/Web/CSS/:read-write)

<script src="//codepen.io/assets/embed/ei.js" async></script>
