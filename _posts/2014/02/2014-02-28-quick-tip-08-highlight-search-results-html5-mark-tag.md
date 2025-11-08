---
layout: post
title: "Quick Tip - 08: Highlight Search Results With the HTML5 Mark Tag"
date: "2014-02-28"
tags:
  - "CSS"
  - "HTML"
  - "SEO"
---

<p class="intro"><span class="dropcap">T</span>he HTML5 mark tag was created in order to highlight text within a document that is relative to another context. This is perfect for highlighting the search term in a list of results.</p>

## For Example...

Google currently does this using an em tag:

![Google search results using em tag](../../assets/img/content/uploads/2014/google-results.webp)

When it comes to semantics, the HTML5 mark tag is a better way to handle this sort of thing going forward.

## Demo

```html
<mark>HTML5</mark> is a markup language used for structuring 
and presenting content for the World Wide Web and a core 
technology of the Internet. It is the fifth revision of...
```

<style>
.demoBox mark {
  background-color: yellow; color: black; font-weight: bold; padding: 0 4px;}
</style>

<div class="demoBox demoBox--content" style="margin-bottom: 40px;">
<mark>HTML5</mark> is a markup language used for structuring and presenting content for the World Wide Web and a core technology of the Internet. It is the fifth revision of …
</div>

## Sources

- [http://html5doctor.com/draw-attention-with-mark](http://html5doctor.com/draw-attention-with-mark/)
