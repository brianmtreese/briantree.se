---
layout: post
title: "Make it Count with CSS Counters"
date: "2014-02-09"
tags:
  - "Accessibility"
  - "CSS"
  - "HTML"
  - "JavaScript"
---

<p class="intro"><span class="dropcap">O</span>ften I've found myself in a spot where I've needed to style an ordered list in a way that I just couldn't do with CSS. So I either had to live with it as it was or get tricky with JavaScript or something to create a custom list with the necessary markup. Then I stumbled across CSS Counters and that all changed.</p>

CSS Counters are very similar to variables in other languages. You have to set the counter to zero for the element containing your list items and then increment it over the set which can be any tag. They don't have to be used in an HTML list. Then using CSS generated content you can loop out whatever content you like. You are still bound to a single element because you'll have to use a pseudo element but it helps to give you more control to style things consistently across browsers.

## Here's a Basic Example

This is the markup that I'll be using:

```html
<div class="counterItems">
    <div>This is an Item Here</div>
    <div>This is Another Item Here</div>
    <div>This is Yet Another Item Here</div>
    <div>This is Even Another Item Here</div>
</div>
```

### First, Set Counter to Zero

First I have to set a counter variable to zero on the container element by doing something like this:

```css
.counterItems {
    counter-reset: myCount; 
}
```

### Next, Increment the Counter and Set Generated Content

Then I have to increment the count and set up the generated content for the items. In this case I'm setting it to the count plus a period and a paren:

```css
.counterItems div:before {
    counter-increment: myCount; 
    content: counter(myCount)".) ";
}
```

### The Demo

This is what the result looks like:

<style>
.counterItems { counter-reset: myCount; } .counterItems div { clear: both; } .counterItems div:before { counter-increment: myCount; content: counter(myCount)".) ";}
</style>

<div class="demoBox demoBox--content">
<div class="counterItems">
<div>This is an Item Here</div>
<div>This is Another Item Here</div>
<div>This is Yet Another Item Here</div>
<div>This is Even Another Item Here</div>
</div>
</div>

## Making it Look Better

So, now that we have the incremented numbering in place, we can make it look how ever we want.

### Squares

```css
.counterSquares div:before {
    border-radius: 25px;
    counter-increment: squaresCount; 
    content: counter(squaresCount);
    display: block;
    float: left;
    height: 25px;
    line-height: 25px;
    margin: 7px 10px 0 0;
    text-align: center;
    width: 25px;
}
```

<style>
.counterSquares { counter-reset: squaresCount; } .counterSquares div { clear: both; } .counterSquares div:before { background-color: #fff; counter-increment: squaresCount; content: counter(squaresCount); color: #424242; display: block; float: left; font-family: arial, sans-serif; font-size: 16px; font-weight: bold; height: 25px; line-height: 25px; margin: 7px 10px 0 0; text-align: center; width: 25px; }
</style>

<div class="demoBox demoBox--content">
<div class="counterSquares">
<div>This is an Item Here</div>
<div>This is Another Item Here</div>
<div>This is Yet Another Item Here</div>
<div>This is Even Another Item Here</div>
</div>
</div>

### Circles

```css
.counterCircles div:before {
    border-radius: 25px;
    counter-increment: circlesCount; 
    content: counter(circlesCount);
    display: block;
    float: left;
    height: 25px;
    line-height: 25px;
    margin: 7px 10px 0 0;
    text-align: center;
    width: 25px;
}
```

<style>
.counterCircles { counter-reset: circlesCount; } .counterCircles div { clear: both; } .counterCircles div:before { background-color: #fff; border-radius: 25px; counter-increment: circlesCount; content: counter(circlesCount); color: #424242; display: block; float: left; font-family: arial, sans-serif; font-size: 16px; font-weight: bold; height: 25px; line-height: 25px; margin: 7px 10px 0 0; text-align: center; width: 25px; }
</style>

<div class="demoBox demoBox--content">
<div class="counterCircles">
<div>This is an Item Here</div>
<div>This is Another Item Here</div>
<div>This is Yet Another Item Here</div>
<div>This is Even Another Item Here</div>
</div>
</div>

These are just a couple of examples but really you are only bound by your imagination on how you can style these things.

## Use Nested Counters to Make a Table of Contents List

CSS Counters can be nested within each other. We can use this functionality do some pretty cool and complex stuff like create a unique table of contents.

### The CSS

```css
.tableOfContents ol { 
    counter-reset: tcCount; 
    list-style: none; 
} 

.tableOfContents li:before { 
    counter-increment: tcCount; 
    content: counters(tcCount, "."); 
    display: inline-block; 
    margin-right: 20px; 
    text-align: right; 
    width: 80px; } 

.tableOfContents > ol > li:before { 
    content: "Part " counter(tcCount); 
} 

.tableOfContents > ol ol { 
    font-size: 75%; 
    margin-bottom: 20px; 
}
```

### The HTML

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

### The Demo

<style>
.tableOfContents ol { counter-reset: tcCount; list-style: none; margin-left: 0; } .tableOfContents li:before { counter-increment: tcCount; content: counters(tcCount, "."); display: inline-block; font-family: arial, sans serif; color: #999; margin-right: 20px; text-align: right; width: 80px; } .tableOfContents > ol > li:before { content: "Part " counter(tcCount); } .tableOfContents > ol ol { font-size: 75%; margin-bottom: 20px; }
</style>

<div class="demoBox demoBox--content">
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

## Browser Support:

<div class="browserSupport__list">
<img src="../../assets/img/ie.svg" alt="ie8 and above" title="ie8 and above">
<img src="../../assets/img/chrome.svg" alt="Chrome 31 and above" title="Chrome 31 and above">
<img src="../../assets/img/firefox.svg" alt="Fire Fox 26 and above" title="Fire Fox 26 and above">
<img src="../../assets/img/safari.svg" alt="Safari 5.1 and above" title="Safari 5.1 and above">
</div>

CSS Counters have good browser support working in all modern browsers. Not supported in Internet Explorer 7 and below.

* * *

## Sources

- [http://caniuse.com](http://caniuse.com/)

- [https://developer.mozilla.org/en-US/docs/Web/Guide/CSS/Counters](https://developer.mozilla.org/en-US/docs/Web/Guide/CSS/Counters)

- [http://www.w3.org/TR/CSS21/generate.html](http://www.w3.org/TR/CSS21/generate.html)

- [http://davidwalsh.name/css-counters](http://davidwalsh.name/css-counters)
