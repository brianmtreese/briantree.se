---
layout: post
title: "Quick Tip - 01: HTML5 A Tags, & Block Level Elements"
date: "2014-01-12"
tags:
  - "HTML"
  - "JavaScript"---

<p class="intro"><span class="dropcap">H</span>TML5 is different than XHTML in many ways. One thing that XHTML never had was a way to make block-level elements clickable without using JavaScript. Well, in HTML5 it's now possible.</p>

That's right, it seems a little weird but it is now valid to wrap block-level elements such as <div>, <h1>, and <p> tags for example within HTML5 a tags.

## So, It's now perfectly acceptable to do this:

```html
<a href="https://briantree.se/">
    <h1>Brian Treese</h1>
    <p>Web Design and Development Tips, Techniques, Inspiration & More</p>
</a>
```

What I didn't know is that this isn't totally new. When using XHTML 2 it was valid to add an href attribute to any element, essentially doing the same thing.

## Sources

- [http://html5doctor.com/block-level-links-in-html-5](http://html5doctor.com/block-level-links-in-html-5)

- [http://davidwalsh.name/html5-elements-links](http://davidwalsh.name/html5-elements-links)
