---
layout: post
title: "Quick Tip - 03: Prevent Mobile Device Text Inflation With the text-size-adjust Property"
date: "2014-01-24"
tags: 
  - "CSS"
  - "Typography"
---

<p class="intro"><span class="dropcap">Y</span>ou may have noticed that your phone tends to scale up text automatically in an attempt to make things more readable on the smaller screen. The intentions are great but the effects may be undesired for the person in charge of the design. Well, you have the ability to prevent mobile device text inflation with the text-size-adjust property.</p>

Most mobile browsers implement some sort of text inflation algorithm but if your site is set up to properly size the text you can disable this behavior. The text-size-adjust property is non-standard so, at the moment, it can only be used with vendor specific prefixes.

```css
h1 {
    -moz-text-size-adjust: none;
    -webkit-text-size-adjust: none;
    -ms-text-size-adjust: none;
}
```

## text-size-adjust Values

There are a few different values that can be passed to the text-size-adjust property for differing effects.

- `none` — disables the default browser text inflation

- `auto` — is intended as an override for the none value, it lets the browser know to go ahead and apply its text inflation

- `percentage` — this value is a percentage of the browser's default text inflation, when set it will increase or decrease the default browser font size by the percentage specified

* * *

## Browser Support

<div class="browserSupport__list">
<img src="../../assets/img/ie.svg" alt="ie mobile using -ms-" title="ie mobile using -ms-">
<img src="../../assets/img/firefox.svg" alt="Fire Fox mobile using -moz-" title="Fire Fox mobile using -moz-">
<img src="../../assets/img/safari.svg" alt="Safari mobile using -webkit-" title="Safari mobile using -webkit-">
</div>

The text-size-adjust property is non-standard, but luckily the most popular mobile browsers do support it using vendor specific prefixes.

* * *

## Sources

- [https://developer.mozilla.org/en-US/docs/Web/CSS/text-size-adjust](https://developer.mozilla.org/en-US/docs/Web/CSS/text-size-adjust)
