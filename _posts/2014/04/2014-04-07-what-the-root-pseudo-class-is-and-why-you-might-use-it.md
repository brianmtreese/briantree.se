---
layout: post
title: "What the :root Pseudo Class is and Why You Might Use it"
date: "2014-04-07"
tags:
  - "CSS"
  - "HTML"
  - "SVG"
---

<p class="intro"><span class="dropcap">T</span>he <code>:root</code> pseudo class, at first glance, is a little odd. It seems like it's simply a replacement for using the HTML tag as a CSS selector. There's a little bit more to it than that and in this article I will explain what the <code>:root</code> pseudo class is and why you might use it.</p>

## What's Different Between :root and html?

For the most part the :root pseudo class will be referring to the html element. `:root` is the outer most or root element of the document which will always be the HTML tag when styling an HTML document.

The main difference between the two is that when styling HTML, SVG, or XML `:root` will refer to the outer most parent element of the document where as HTML is simply a CSS element selector that will always match the HTML tag. When using CSS to style SVG or XML files the root element will match whatever the parent node is within those files.

Another difference you should keep in mind when using `:root` is that it will have a higher specificity than HTML. :root will have a calculated specificity of 0 0 1 0 while HTML will have a specificity of 0 0 0 1. You can see this calculation in action using [this handy specificity calculator](http://specificity.keegan.st/) by [Keegan Street](http://keegan.st/).

## Some Examples

To better illustrate the differences I've provided a couple of examples below.

### In an HTML Document

This is an example using `:root` in an HTML document where it will target the html tag.

```css
:root { 
    background-color: red; 
}
```

<p class="codepen" data-height="300" data-default-tab="html,result" data-slug-hash="ZEQJKx" data-user="brianmtreese" style="height: 300px; box-sizing: border-box; display: flex; align-items: center; justify-content: center; border: 2px solid; margin: 1em 0; padding: 1em;"><span>See the Pen <a href="https://codepen.io/brianmtreese/pen/ZEQJKx">Untitled</a> by Brian (<a href="https://codepen.io/brianmtreese">@brianmtreese</a>) on <a href="https://codepen.io">CodePen</a>.</span></p>
<script async src="https://cpwebassets.codepen.io/assets/embed/ei.js"></script>

### In an SVG

This is an example using `:root` in an embedded SVG in which it will target the outer svg tag.

```html
<style media="screen">
    <![CDATA[ :root { background-color: #33cccc !important; }]]>
</style>
```

<p class="codepen" data-height="300" data-default-tab="html,result" data-slug-hash="OJMjjR" data-user="brianmtreese" style="height: 300px; box-sizing: border-box; display: flex; align-items: center; justify-content: center; border: 2px solid; margin: 1em 0; padding: 1em;"><span>See the Pen <a href="https://codepen.io/brianmtreese/pen/OJMjjR">Untitled</a> by Brian (<a href="https://codepen.io/brianmtreese">@brianmtreese</a>) on <a href="https://codepen.io">CodePen</a>.</span></p>
<script async src="https://cpwebassets.codepen.io/assets/embed/ei.js"></script> 

## In Conclusion

I've heard some people mention that you should actually be using :root instead of HTML by default now. I'm not sure if I'm sold on this yet but it does make sense if you consider the future of [Web Components](/gettin-modular-web-components/). Besides SVG and XML, Web Components will also use CSS. They will allow us to encapsulate modules of markup, functionality, and style into their own components. Using :root would allow us to easily target the root of those elements regardless of what their outer most tag is.

* * *

## Browser Support

<div class="browserSupport__list">
<img src="../../assets/img/ie.svg" alt="ie9 and above" title="ie9 and above">
<img src="../../assets/img/chrome.svg" alt="Chrome 1 and above" title="Chrome 1 and above">
<img src="../../assets/img/firefox.svg" alt="Fire Fox 1 and above" title="Fire Fox 1 and above">
<img src="../../assets/img/safari.svg" alt="Safari 1 and above" title="Safari 1 and above">
</div>

The CSS :root pseudo class has pretty good browser support working in all modern browsers. Not supported in ie8 and below.

* * *

## Sources

- [http://css-tricks.com/almanac/selectors/r/root/](http://css-tricks.com/almanac/selectors/r/root/)

- [https://developer.mozilla.org/en-US/docs/Web/CSS/:root](https://developer.mozilla.org/en-US/docs/Web/CSS/:root)

- [http://www.w3.org/wiki/CSS/Selectors/pseudo-classes/:root](http://www.w3.org/wiki/CSS/Selectors/pseudo-classes/:root)
