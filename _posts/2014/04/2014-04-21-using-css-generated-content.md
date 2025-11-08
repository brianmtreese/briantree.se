---
layout: post
title: "Using CSS Generated Content"
date: "2014-04-21"
categories: 
  - "css"
tags:
  - "CSS"
  - "HTML"
  - "Pseudo Element"
---

<p class="intro"><span class="dropcap">B</span>ack in the good ol' days, CSS was much more limited than it is today. If we needed to style something it had to be in the page which, in turn, led to bloated markup simply for design purposes. Luckily we are no longer in those days.</p>

CSS Generated Content is one of many advancements in CSS that allows us to do more with less. It has been around for some time now and has good browser support so if you're not using it you may want to consider it.

## What is CSS Generated Content?

CSS Generated content is just content that is not actually in the markup and is not actually part of the DOM. It's added using the CSS `content` property via the _::before_ and _::after_ pseudo elements providing two additional items for every element in the page that can be styled.

<style>
.demoBox { margin-bottom: 50px; } .demoBox a { color: #fff; }
</style>

## You Can Leave Them Empty

If you need to use the `::before` and `::after` pseudo elements for styling purposes only you can just add them and leave the `content` property empty.

```css
p img {
    float: right;
}

p:after {
    border-top: solid 1px red;
    content: '';
    clear: both;
    display: block;
}
```

```html
<p>
    <img src="img.jpg" alt="" width="150" height="150" />
    Lorem ipsum dolor sit amet, consectetuer adipiscing elit. Aenean commodo ligula eget dolor. Aenean massa. Cum sociis natoque penatibus
</p>
```

<style>
#demo1 img { float: right; margin-top: 0; margin-left: 1em; } #demo1 p:after { border-top: solid 1px red; content: ''; clear: both; display: block; }
</style>

<div id="demo1" class="demoBox">
<p class="content-empty" style="margin-bottom: 0;"><img src="../../assets/img/content/uploads/2014/62H-150x150.jpg" alt="Using CSS Generated Content to Clear Floats" width="150" height="150">Lorem ipsum dolor sit amet, consectetuer adipiscing elit. Aenean commodo ligula eget dolor. Aenean massa. Cum sociis natoque penatibus dolor sit amet, consectetuer adipiscing elit. Aenean commodo ligula eget dolor. Aenean massa. Cum sociis natoque penatibus</p>
</div>

## You Can Use Static Text

If you want to add static text before or after elements you can simply set a text string value on the content property.

```css
a:before {
    border: solid 1px red;
    content: '(.doc) ';
}
```

```html
<a href="word-document.doc">A Word Document</a>
```

<style>
#demo2 a:before { border: solid 1px red; content: '(.doc) '; }
</style>

<div id="demo2" class="demoBox content-text"><a href="#">A Word Document</a></div>

## You Can Use Dynamic Attribute Values

If you have attributes on elements you can output their values before or after them.

```css
a:after {
    border: solid 1px red;
    content: " ("attr(href)")";
}
```

```html
<a href="https://briantree.se">My Website</a>
```

<style>
#demo3 a:after { border: solid 1px red; content: " ("attr(href)")"; }
</style>

<div id="demo3" class="demoBox content-attribute"><a href="/">My Website</a></div>

## You Can Use CSS Counters

You can generate cool customized listings using [CSS Counters](/make-count-css-counters/). To learn even more about them you can check out my previous article "[Make it Count with CSS Counters](/make-count-css-counters/)".

```css
.tableOfContents ol { 
    counter-reset: tcCount; 
    list-style: none; 
} 

.tableOfContents li:before { 
    border: solid 1px red;
    counter-increment: tcCount; 
    content: counters(tcCount, "."); 
    display: inline-block; 
    margin-right: 20px; 
    text-align: right; 
    width: 80px; } 

.tableOfContents > ol > li:before { 
    border: solid 1px red;
    content: "Part " counter(tcCount); 
} 

.tableOfContents > ol ol { 
    font-size: 75%; 
    margin-bottom: 20px; 
}
```

```html
<ol>
    <li>
        This is the 1st Part
        <ol>
            <li>This is a section</li>
            <li>This is a section</li>
            <li>This is a section</li>
        </ol>
    </li>
    <li>
        This is the 2nd Part
        <ol>
            <li>This is a section</li>
            <li>This is a section</li>
            <li>This is a section</li>
        </ol>
    </li>
    <li>
        This is the 3rd Part
        <ol>
            <li>This is a section</li>
            <li>This is a section</li>
            <li>This is a section</li>
        </ol>
    </li>
</ol>
```

<style>
#demo4 .tableOfContents ol { 
    counter-reset: tcCount; 
    list-style: none; 
} 

#demo4 .tableOfContents li:before { 
    border: solid 1px red;
    counter-increment: tcCount; 
    content: counters(tcCount, "."); 
    display: inline-block; 
    margin-right: 20px; 
    text-align: right; 
    width: 80px; } 

#demo4 .tableOfContents > ol > li:before { 
    border: solid 1px red;
    content: "Part " counter(tcCount); 
} 

#demo4 .tableOfContents > ol ol { 
    font-size: 75%; 
    margin-bottom: 20px; 
}
</style>

<div id="demo4" class="demoBox">
<div class="tableOfContents">
<ol style="margin-bottom: 0;">
<li>This is the 1st Part
<ol>
<li>This is a section</li>
<li>This is a section</li>
<li>This is a section</li>
</ol>
</li>
<li>This is the 2nd Part
<ol>
<li>This is a section</li>
<li>This is a section</li>
<li>This is a section</li>
</ol>
</li>
<li>This is the 3rd Part
<ol style="margin-bottom: 0;">
<li>This is a section</li>
<li>This is a section</li>
<li>This is a section</li>
</ol>
</li>
</ol>
</div>
</div> 

## You Can Do More: CSS Generated Content Values

With the _content_ property you can do more than what I've mentioned in this article. There are several values that can be used with the property.

### none

When setting content to none the pseudo elements will not be generated

### normal

This is the default value and equals a value of none for the pseudo elements

### string

This creates static text content for the pseudo elements

### uri

This links to an external resource like an image

### counter

This specifies incremented counters for each item in the group of matched elements

### attr

This displays the value of the attributes on the matched elements

### open-quote | close-quote

This displays the proper open or close quote for the matched elements

### no-open-quote | no-close-quote

This does not render any content but continues to increment the nesting of quotes

* * *

## When Not To Use CSS Generated Content

The _content_ property is powerful but just like everything else it can easily be used in ways that it shouldn't be. As I mentioned above CSS Generated Content is not part of the DOM so it should not be used to add any content that would need to be accessible in the absence of CSS. This means that any sort of body copy, button text, form labels, or anything similar should not be added using the _content_ property.

* * *

## Browser Support

<div class="browserSupport__list">
<img src="../../assets/img/ie.svg" alt="ie8 and above" title="ie8 and above">
<img src="../../assets/img/chrome.svg" alt="Chrome 31 and above" title="Chrome 31 and above">
<img src="../../assets/img/firefox.svg" alt="Fire Fox 27 and above" title="Fire Fox 27 and above">
<img src="../../assets/img/safari.svg" alt="Safari 7 and above" title="Safari 7 and above"></div>

CSS Generated Content has good browser support working in all modern browsers. Not supported in Internet Explorer 7 and below.

* * *

## Sources

- [http://caniuse.com](http://caniuse.com/)

- [https://developer.mozilla.org/en-US/docs/Web/CSS/content](https://developer.mozilla.org/en-US/docs/Web/CSS/content)

- [http://css-tricks.com/css-content](http://css-tricks.com/css-content/)

- [http://meiert.com/en/blog/20140224/generated-content](http://meiert.com/en/blog/20140224/generated-content/)
