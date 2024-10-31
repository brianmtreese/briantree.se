---
layout: post
title: "Quick Tip - 07: Autofocus Fields With HTML5 Form Attributes"
date: "2014-02-21"
tags: 
  - "HTML"
  - "Forms"
---

<p class="intro"><span class="dropcap">H</span>ave you ever wanted to automatically place the cursor in a field when the page is rendered? I know I have.</p>

This sort of thing used to require more than just HTML to accomplish but with now HTML5 it's a breeze. Here's how you can autofocus fields with HTML5 form attributes.

```html
<input autofocus="autofocus" id="username" type="text" />
```

Yep, it's that easy. HTML5 form attributes have pretty good browser support and older browsers that don't support them will simply ignore them.

## It can be added in the following ways:

- `autofocus`

- `autofocus=""`

- `autofocus="autofocus"`

All three do the exact same thing.

* * *

## Browser Support

<div class="browserSupport__list">
<img src="../../assets/img/ie.svg" alt="ie10 and above" title="ie10 and above">
<img src="../../assets/img/chrome.svg" alt="Chrome 31 and above" title="Chrome 31 and above">
<img src="../../assets/img/firefox.svg" alt="Fire Fox 26 and above" title="Fire Fox 26 and above"><img src="../../assets/img/safari.svg" alt="5.1 and above" title="5.1 and above">
</div>

HTML5 autofocus has pretty good browser support working in all modern browsers. Not supported in ie9 and below.

* * *

### Sources

- [http://caniuse.com](http://caniuse.com/)

- [http://html5doctor.com/html5-forms-introduction-and-new-attributes](http://html5doctor.com/html5-forms-introduction-and-new-attributes/)
