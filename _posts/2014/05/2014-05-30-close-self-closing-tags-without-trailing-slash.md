---
layout: post
title: "Quick Tip - 19: Close Self-Closing Tags Without a Trailing Slash"
date: "2014-05-30"
tags: 
  - "HTML"
---

<p class="intro"><span class="dropcap">F</span>or those of us who are used to working with XHTML this is going to seem a little odd but, with HTML5, we no longer need to add a trailing slash on self closing tags like images and inputs.</p>

When using an img tag do you tend to set it up like this?

```html
<img src="img.jpg" alt="Image" />
```

Well, that little trailing slash is no longer needed on self closing tags with HTML5. So you can now just do this:

```html
<img src="img.jpg" alt="Image">
```

However, you don't have to remove it, the [spec says](http://dev.w3.org/html5/spec-author-view/syntax.html#syntax-start-tag) it is optional. Still you may want to consider it since it is now really just extra.
