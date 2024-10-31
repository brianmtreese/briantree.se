---
layout: post
title: "Flexbox: Modern Web Layouts Simplified"
date: "2013-12-20"
tags: 
  - "CSS"
  - "CSS Layout"
  - "Flexbox"
---

<p class="intro"><span class="dropcap">N</span>ew in the world of web layouts is the CSS3 "Flexible Box Layout Module" known as Flexbox. It is so new in fact that at the time of writing this post it is still just a W3C Recommendation and is still in flux with different browsers implementing things a little differently. That being said, it actually has been around since 2009 although the syntax was different. The most recent version of the module seems to be fairly stable with solid support among the latest versions of all major browsers.</p>

If you are used to current layout methods then you are familiar with the vertical nature of `display: block` and horizontal nature of `display: inline-block`. And, if you are familiar with these you are probably also familiar with all of their quirks like collapsing margins and what happens when the content extends out of a container with text-align: center.

You are probably also familiar with float-based layouts and all the issues with them as well. Float-based layouts are essentially a "best available" technique at the moment, but in all reality floats were created to deal with things like wrapping text and content around images.

All of these little things can make the current layout methods extremely tricky, inconsistent, and unpredictable at times. Flexbox is aimed to fix these things and simplify the process.

* * *

## What Exactly is Flexbox?

Flexbox is a set of new style properties that can be applied to good ol' every day HTML elements such as <div> tags. It allows for elements to be laid out either horizontally or vertically with the flexibility to appropriately fill the space available. Flexbox is intended to reduce the trickiness, inconsistencies, and unpredictability of the block, float, and inline-block methods. Using Flexbox creates a relationship between a containing element and its children elements. It shares some similarities with both float and table style layouts.

* * *

## Let's Start With Some Examples

For me it was a little easier to understand once I saw a few examples of Flexbox before I really understood how it works.

### 3 Evenly Spaced Horizontal Containers

This is a basic example using `display: flex` on the parent container which lets the browser know that we are using Flexbox for this div and its children. The children items use the `flex` property with a value of 1, `flex: 1`, which sets the children elements to take up 1 third of their parent since there are a total of three flex items.

#### HTML

```html
<div class="example__flexbox">
    <div class="example__flexboxItem example__flexboxItem--1">
        Item 1
    </div>
    <div class="example__flexboxItem example__flexboxItem--2">
        Item 2
    </div>
    <div class="example__flexboxItem example__flexboxItem--3">
        Item 3
    </div>
</div>
```

#### The CSS

```css
.example__flexbox {         
    display: -ms-flexbox; /* For IE10 Mobile */        
    display: -webkit-flex; /* For Safari */ 
    display: flex; /* For Everything Else */
}

.example__flexboxItem {
    margin: 5px;
    -ms-flex: 1; /* For IE10 Mobile */
    -webkit-flex: 1; /* For Safari */
    flex: 1; /* For Everything Else */
}
```

#### The Demo

<style>
.example__flexbox1 { 
    display: -ms-flexbox; 
    display: -webkit-flex; 
    display: flex;
} 

.example__flexbox1--item { 
    margin: 5px; 
    padding: 40px 10px; 
    text-align: center; 
    -ms-flex: 1; 
    -webkit-flex: 1; 
    flex: 1;
}
</style>

<div class="demoBox">
    <div class="example__flexbox1">
        <div class="demoBox__item example__flexbox1--item example__flexbox1--item--1">Item 1</div>
        <div class="demoBox__item example__flexbox1--item example__flexbox1--item--2">Item 2</div>
        <div class="demoBox__item example__flexbox1--item example__flexbox1--item--3">Item 3</div>
    </div>
</div>

### 1 Large & 2 Smaller Containers

By specifying a different `flex` value for one of the containers you can easily change the width of the columns. In this case I changed the `flex` value of the first item to 2, `flex: 2`, causing it to take up 2/4 of the width of the parent container with the other two items taking up 1/4 of the width.

The flex property simply sets the proportions of the free space to be divided up by the items. It will differ by the number of items you have and the value that you set.

#### The CSS

```css
.example__flexboxItem--1 {
    -ms-flex: 2; /* For IE10 Mobile */
    -webkit-flex: 2; /* For Safari */
    flex: 2; /* For Everything Else */
}
```

#### The Demo

<style>
.example__flexbox2 { 
    display: -ms-flexbox; 
    display: -webkit-flex; 
    display: flex;
} 
    
.example__flexbox2--item { 
    margin: 5px; 
    padding: 40px 10px; 
    text-align: center; 
    -ms-flex: 1; 
    -webkit-flex: 1; 
    flex: 1;
} 

.example__flexbox2--item--1 { 
    -ms-flex: 2; 
    -webkit-flex: 2; 
    flex: 2;
}
</style>

<div class="demoBox"> 
    <div class="example__flexbox2">
        <div class="demoBox__item example__flexbox2--item example__flexbox2--item--1">Item 1</div>
        <div class="demoBox__item example__flexbox2--item example__flexbox2--item--2">Item 2</div>
        <div class="demoBox__item example__flexbox2--item example__flexbox2--item--3">Item 3</div>
    </div>
</div>

### Reordering Containers

With Flexbox it's very easy to switch the ordering of containers without having to modify the markup. You just need to use the order property. In this case I gave the second item an `order` value of -1, `order: -1`, which tells the browser to move it -1 position over. Since the default flow direction is left to right, this means that the container will move to the left.

#### The CSS

```css
.example__flexboxItem--2 {
    -ms-flex-order: -1; /* For IE10 Mobile */
    -webkit-order: -1; /* For Safari */
    order: -1; /* For Everything Else */
}
```

#### The Demo

<style>
.example__flexbox3 {
    display: -ms-flexbox; 
    display: -webkit-flex; 
    display: flex; 
} 

.example__flexbox3--item { 
    margin: 5px; 
    padding: 40px 10px; 
    text-align: center; 
    -ms-flex: 1; 
    -webkit-flex: 1; 
    flex: 1;
} 

.example__flexbox3--item--1 { 
    -ms-flex: 2; 
    -webkit-flex: 2; 
    flex: 2;
}

.example__flexbox3--item--2 { 
    -ms-flex-order: -1; 
    -webkit-order: -1; 
    order: -1; 
}
</style>

<div class="demoBox">
    <div class="example__flexbox3">
        <div class="demoBox__item example__flexbox3--item example__flexbox3--item--1">Item 1</div>
        <div class="demoBox__item example__flexbox3--item example__flexbox3--item--2">Item 2</div>
        <div class="demoBox__item example__flexbox3--item example__flexbox3--item--3">Item 3</div>
    </div>
</div>

### Simple Vertical Alignment, It's About Darn Time!

Vertical alignment for layout has been extremely difficult if not impossible since we stopped using tables. But, the good news is, Flexbox makes it a breeze all over again! There are two levels of granularity when it comes to vertical alignment: 1. Applies to the parent container which will affect all children flex items and 2. Which applies to the individual flex items themselves and will override that from the parent.

### Center Alignment

To align items in the middle use `align-items: center`

#### The CSS

```css
.example__flexbox {
    -ms-flex-align: center; /* For IE10 Mobile */
    -webkit-align-items: center; /* For Safari */
    align-items: center; /* For Everything Else */
}
```

#### The Demo

<style>
.example__flexbox4 { 
    height: 300px; 
    padding: 0 10px; 
    display: -ms-flexbox; 
    display: -webkit-flex; 
    display: flex; 
    -ms-flex-align: center; 
    -webkit-align-items: center; 
    align-items: center;
} 

.example__flexbox4--item { 
    margin: 5px; 
    padding: 40px 10px; 
    text-align: center; 
    -ms-flex: 1; 
    -webkit-flex: 1; 
    flex: 1; 
} 

.example__flexbox4--item--1 { 
    padding-top: 50px; 
    padding-bottom: 50px; 
} 

.example__flexbox4--item--3 { 
    padding-top: 70px; 
    padding-bottom: 70px; 
}
</style>

<div class="demoBox">
    <div class="demoBox__item example__flexbox4">
        <div class="demoBox__item--alt example__flexbox4--item example__flexbox4--item--1">Item 1</div>
        <div class="demoBox__item--alt example__flexbox4--item example__flexbox4--item--2">Item 2</div>
        <div class="demoBox__item--alt example__flexbox4--item example__flexbox4--item--3">Item 3</div>
    </div>
</div>

### Top Alignment

To align items to the top use `align-items: flex-start`

#### The CSS

```css
.example__flexbox {
    -ms-flex-align: start; /* For IE10 Mobile */
    -webkit-align-items: flex-start; /* For Safari */
    align-items: flex-start; /* For Everything Else */
}
```

#### The Demo

<style>
.example__flexbox5 { 
    height: 290px; 
    padding: 10px 10px 0; 
    display: -ms-flexbox; 
    display: -webkit-flex; 
    display: flex; 
    -ms-flex-align: start; 
    -webkit-align-items: flex-start; 
    align-items: flex-start;
}

.example__flexbox5--item { 
    margin: 5px; 
    padding: 40px 10px; 
    text-align: center; 
    -ms-flex: 1; 
    -webkit-flex: 1; 
    flex: 1;
} 

.example__flexbox5--item--1 {
    padding-top: 50px; 
    padding-bottom: 50px;
} 

.example__flexbox5--item--3 { 
    padding-top: 70px; 
    padding-bottom: 70px; 
}
</style>

<div class="demoBox">
    <div class="demoBox__item example__flexbox5">
        <div class="demoBox__item--alt example__flexbox5--item example__flexbox5--item--1">Item 1</div>
        <div class="demoBox__item--alt example__flexbox5--item example__flexbox5--item--2">Item 2</div>
        <div class="demoBox__item--alt example__flexbox5--item example__flexbox5--item--3">Item 3</div>
    </div>
</div>

### Bottom Alignment

To align items to the bottom use `align-items: flex-end`

#### The CSS

```css
.example__flexbox {
    -ms-flex-align: end; /* For IE10 Mobile */
    -webkit-align-items: flex-end; /* For Safari */
    align-items: flex-end; /* For Everything Else */
}
```

#### The Demo

<style>
.example__flexbox6 {
    height: 290px;
    padding: 0 10px 10px; 
    display: -ms-flexbox; 
    display: -webkit-flex; 
    display: flex; 
    -ms-flex-align: end; 
    -webkit-align-items: flex-end; 
    align-items: flex-end;
} 

.example__flexbox6--item { 
    margin: 5px; 
    padding: 40px 10px; 
    text-align: center; 
    -ms-flex: 1; 
    -webkit-flex: 1; 
    flex: 1;
} 

.example__flexbox6--item--1 { 
    padding-top: 50px; 
    padding-bottom: 50px;
} 

.example__flexbox6--item--3 { 
    padding-top: 70px; 
    padding-bottom: 70px;
}
</style>

<div class="demoBox">
    <div class="demoBox__item example__flexbox6">
        <div class="demoBox__item--alt example__flexbox6--item example__flexbox6--item--1">Item 1</div>
        <div class="demoBox__item--alt example__flexbox6--item example__flexbox6--item--2">Item 2</div>
        <div class="demoBox__item--alt example__flexbox6--item example__flexbox6--item--3">Item 3</div>
    </div>
</div> 

### Individual Item Alignment

To align individual items use the `align-self` property on the actual items

#### The CSS

```css
.example__flexboxItem--1  {
    -ms-flex-item-align: start; /* For IE10 Mobile */
    -webkit-align-self: flex-start; /* For Safari */
    align-self: flex-start; /* For Everything Else */
}

.example__flexboxItem--2  {
    -ms-flex-item-align: center; /* For IE10 Mobile */
    -webkit-align-self: center; /* For Safari */
    align-self: center; /* For Everything Else */
}

.example__flexboxItem--3  {
    -ms-flex-item-align: end; /* For IE10 Mobile */
    -webkit-align-self: flex-end; /* For Safari */
    align-self: flex-end; /* For Everything Else */
}
```

#### The Demo

<style>
.example__flexbox7 { height: 280px; padding: 10px; display: -ms-flexbox; display: -webkit-flex; display: flex; } .example__flexbox7--item { margin: 5px; padding: 40px 10px; text-align: center; -ms-flex: 1; -webkit-flex: 1; flex: 1; } .example__flexbox7--item--1 { padding-top: 50px; padding-bottom: 50px; -ms-flex-item-align: start; -webkit-align-self: flex-start; align-self: flex-start; } .example__flexbox7--item--2 { -ms-flex-item-align: center; -webkit-align-self: center; align-self: center; } .example__flexbox7--item--3 { padding-top: 70px; padding-bottom: 70px; -ms-flex-item-align: end; -webkit-align-self: flex-end; align-self: flex-end; }
</style>

<div class="demoBox">
    <div class="demoBox__item example__flexbox7">
        <div class="demoBox__item--alt example__flexbox7--item example__flexbox7--item--1">Item 1</div>
        <div class="demoBox__item--alt example__flexbox7--item example__flexbox7--item--2">Item 2</div>
        <div class="demoBox__item--alt example__flexbox7--item example__flexbox7--item--3">Item 3</div>
    </div>
</div>

## Flexbox Axes

Flexbox items will flex along the specified axis or "Main Axis". The default axis is horizontal and the "Cross Axis" is vertical but these can be easily switched with the Flexbox property `flex-direction` applied to the main flex container.

* * *

## Flexbox Properties

The Flexbox syntax is full of various CSS style properties that can be applied to both the main flex container as well as the individual flex items. The examples above are just a small subset of the options available with Flexbox.

### For the Flex Container

#### display: flex 

This lets the browser know that this item is a flex container

#### flex-direction: row

This lets the browser know which direction items should flow. `row` is the default.

- `row` \- items flow in a horizontal row left to right

- `row-reverse` - items flow in a horizontal row right to left

- `column` \- items flow in a vertical column top to bottom

- `column-reverse` - items flow in a vertical column bottom to top

#### align-items: flex-start

This globally sets the alignment for the flex items within the container. `flex-start` is the default.

- `flex-start` - items aligned to the start of the flex container based on the flex direction

- `flex-end` - items aligned to the end of the flex container based on the flex direction

- `center` - items aligned in the middle of the flex container

- `baseline` - items aligned to the baseline of the content baseline within all of the items

- `stretch` - items aligned by stretching them along the cross axis to fill the available space within the container

#### justify-content: flex-start

Similar to alignment justify-content controls how the flex items are positioned within the flex container. In fact, flex-start, flex-end, and center all appear to work in a very similar manner. `flex-start` is the default.

- `flex-start` - items justified to the start of the flex container based on the flex direction

- `flex-end` - items justified to the end of the flex container based on the flex direction

- `center` - items justified in the middle of the flex container

- `space-between` - extra space around the flex items gets evenly distributed between them

- `space-around` - extra space around the flex items gets evenly distributed on all sides of them

#### flex-wrap: nowrap

Flex-wrap simply controls how flex items wrap along the main axis within the flex container. `nowrap` is the default.

- `nowrap` - prevents items from wrapping at all

- `wrap` - allows items to wrap to new rows or columns based on the flex direction

- `wrap-reverse` - allows items to wrap to new rows or columns opposite the flex direction

### For the Flex Item

#### flex: nowrap

Flex-wrap controls how much proportional space an individual flex item should take up within the flex container.

- `number` - a value of "1" means it will essentially "add" one more flex item by making one item contain 2 and then its space will be determined by taking the "2" items and dividing it by the total number of items.

- `none` - prevents items from flexing completely

- `initial` - will only flex when there is no space around items

- `auto` - will always flex even when there is space around items

#### order

This controls the order of an individual flex item along the main axis regardless of their order in the markup.

- `number` - a value of "-1" means the item will be placed before the item that comes before it in the actual markup.

#### align-self: stretch

This controls the alignment of an individual flex item along the main axis. `stretch` is the default.

- `stretch` - item is aligned by stretching it along the cross axis to fill the available space within the container.

- `flex-start` - item is aligned to the end of the flex container based on the flex direction

- `flex-end` - item is aligned to the end of the flex container based on the flex direction

- `center` - item is aligned in the middle of the flex container

- `baseline` - item is aligned to the baseline of the content baseline within the items

* * *

## Browser Support

<div class="browserSupport__list">
    <img src="../../assets/img/ie.svg" alt="ie10 and above" title="ie10 and above">
    <img src="../../assets/img/chrome.svg" alt="Chrome 29 and above" title="Chrome 29 and above">
    <img src="../../assets/img/firefox.svg" alt="Fire Fox 22 and above" title="Fire Fox 22 and above">
    <img src="../../assets/img/safari.svg" alt="Safari 6.1 and above" title="Safari 6.1 and above">
</div> 

Flexbox has good browser support working in all modern browsers. But, remember there are two different versions of the syntax. There is the old version and the new version. Chris Coyier, on his site [css-tricks.com](http://css-tricks.com/) has written a great article to mix the "Old" and "New" syntax to get better browser support: [css-tricks.com/using-flexbox/](http://css-tricks.com/using-flexbox/). Not supported in Internet Explorer 9 and below.

* * *

## Sources

- [http://caniuse.com/](http://caniuse.com/)

- [https://developer.mozilla.org/en-US/docs/Web/Guide/CSS/Flexible\_boxes](https://developer.mozilla.org/en-US/docs/Web/Guide/CSS/Flexible_boxes)

- [http://coding.smashingmagazine.com/2013/05/22/centering-elements-with-flexbox/](http://coding.smashingmagazine.com/2013/05/22/centering-elements-with-flexbox/)

- [http://blog.teamtreehouse.com/responsive-design-of-the-future-with-flexbox](http://blog.teamtreehouse.com/responsive-design-of-the-future-with-flexbox)

- [http://css-tricks.com/snippets/css/a-guide-to-flexbox/](http://css-tricks.com/snippets/css/a-guide-to-flexbox/)

- [http://css-tricks.com/old-flexbox-and-new-flexbox/](http://css-tricks.com/old-flexbox-and-new-flexbox/)

- [http://msdn.microsoft.com/en-us/library/ie/hh673531(v=vs.85).aspx](http://msdn.microsoft.com/en-us/library/ie/hh673531(v=vs.85).aspx)
