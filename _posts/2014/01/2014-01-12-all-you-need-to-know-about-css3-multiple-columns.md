---
layout: post
title: "All You Need to Know About CSS3 Multiple Columns"
date: "2014-01-12"
tags:
  - "Angular"
  - "Angular Styles"
  - "CSS"
  - "CSS Layout"
  - "HTML"
---

<p class="intro"><span class="dropcap">L</span>ayout has traditionally been a pretty difficult thing to get right when it comes to building web sites. With CSS3, however, it looks like things are getting a bit easier. I've written <a href="/flexbox-modern-web-layouts-simplified/" target="_blank">"Flexbox: Modern Web Layouts Simplified"</a> which covered Flexbox layout techniques. That was cool, but there are other great layout features provided for us in CSS3, In this article I'm covering CSS3 Multiple Columns.</p>

One challenge we have in this responsive web design world is maintaining good readability for our content across a variety of displays. It is widely accepted among typographers that a good "measure", characters per line, is between 45 and 75 characters for a single column of text. So, when we expand out to larger displays it may make perfect sense to force our content into columns and this is where CSS Multiple Columns come into play.

## CSS3 Multiple Columns, Wait What Are They?

The easiest way to visualize them is to think of a newspaper layout. The content is always structured in a series of columns that fill a rectangular block of the page.

<div>
    <img style="display: block;" src="../../assets/img/content/uploads/2014/newspaper-1024x682.jpg" alt="Understanding CSS Regions">
</div>

CSS3 Multiple Columns, like Flexbox, provide us with a set of new style properties that can be applied to good ol’ every day HTML elements such as `<div>` or `<p>` tags.

The main difference between CSS3 Multiple Columns and other layout techniques is that they are really geared towards laying out content and not really intended to solve main site layout issues.

<style>
.example__columns { font-size: 80%; padding: 10px 13px; position: relative; } .example__columns--3 { -moz-column-count: 3; -webkit-column-count: 3; column-count: 3; } .example__columns--3 p { margin: 12px 0; }
</style>

## Enough Explanation, Time for an Example

Just like everything else, Multiple Columns are even easier to understand when you see them in action.

#### Basic 3 Column Example

```css
.example__columns--3 {
    -moz-column-count: 3 /* For Firefox */;
    -webkit-column-count: 3 /* For Chrome & Safari */;
    column-count: 3 /* For Everything Else */; 
}
```

<style>
#demo1 .example__columns--3 {
    -moz-column-count: 3 /* For Firefox */;
    -webkit-column-count: 3 /* For Chrome & Safari */;
    column-count: 3 /* For Everything Else */; 
}
</style>

<div id="demo1" class="demoBox">
<div class="example__columns example__columns--3">Lorem ipsum dolor sit amet, consectetuer adipiscing elit. Aenean commodo ligula eget dolor. Aenean massa. Cum sociis natoque penatibus et magnis dis parturient montes, nascetur ridiculus mus. Donec quam felis, ultricies nec, pellentesque eu, pretium quis, sem. Nulla consequat massa quis enim. Donec pede justo, fringilla vel, aliquet nec, vulputate eget, arcu. In enim justo, rhoncus ut, imperdiet a, venenatis vitae, justo. Nullam dictum felis eu pede mollis pretium. Integer tincidunt</div>
</div>
## Margins and Padding, They Get Weird

There are a few little quirks on how browsers implement CSS Multiple Columns that you should know ahead of time if you're going to use them. How margin and padding is handled is probably the most important.

```css
.example__columns--3 {
    -moz-column-count: 3 /* For Firefox */;
    -webkit-column-count: 3 /* For Chrome & Safari */;
    column-count: 3 /* For Everything Else */; 
}

.example__columns--3 p {
    margin: 12px 0;
}
```

<style>
#demo2 .example__columns--3 { -moz-column-count: 3 /\* For Firefox \*/; -webkit-column-count: 3 /\* For Chrome & Safari \*/; column-count: 3 /\* For Everything Else \*/; } #demo2 .example__columns--3 p { margin: 12px 0; }
</style>

<div id="demo2" class="demoBox">
<div class="example__columns example__columns--3" style="margin-bottom: 24px;">
<p>Lorem ipsum dolor sit amet, consectetuer adipiscing elit. Aenean commodo ligula eget dolor. Aenean massa. Cum sociis natoque penatibus et magnis dis parturient montes nascetur ridiculus mus. Donec quam felis, ultricies</p>
<p>nec, pellentesque eu, pretium quis, sem. Nulla consequat massa quis enim. Donec pede justo, fringilla vel, aliquet nec vulputate eget, arcu. In enim justo</p>
<p>rhoncus ut, imperdiet a, venenatis vitae, justo. Nullam dictum felis eu pede mollis pretium. Integer tincidunt</p>
</div>
</div>

You can see in the example above the `<p>` tags get margin applied to both the top and bottom and the first paragraph gets space above it. Then in the second column, since the first line is not the start of a new paragraph, it doesn't get the same space above it making the alignment off. In this case, margin should just be set on the bottom and that would fix the issue.

## CSS3 Multiple Column Properties

The CSS3 Multiple Column spec is full of various CSS style properties that can be applied to your content. What I've shown above is just the tip of the iceberg.

### column-count

This sets how many columns the browser needs to evenly display the content into. `auto` is the default.

- `auto` — The column count will be determined by properties such as `column-width`

- `number` — This will explicitly set the number of columns to show

### column-fill

This specifies how the content should fill the columns. `balance` is the default.

- `balance` — The content is evenly distributed among the columns forcing them to have similar heights

- `auto` — The content is distributed sequentially among the columns forcing them to have variable heights

### column-gap

This specifies the amount of space to add between columns. `normal` is the default.

- `length` — Sets the gap based on a specific value of %, px, or em

- `normal` — Lets the browser determine a "normal" value

### column-rule

This is the shorthand property for setting how rules, separators between columns, are styled. `medium none black` is the default.

- `column-rule-width` — Sets the width of the rule based on a value of %, px, or em

- `column-rule-style` — Sets the style of the rule

- `column-rule-color` — Sets the color of the rule

### column-rule-color

This specifies the color of the rules. `black` is the default.

- `color` — Sets a specific color value for the rule

### column-rule-style

This specifies the border style of the rules. `none` is the default.

- `none` — Sets the columns to have no rules

- `hidden` — Hides the rules between columns

- `dotted` — Sets the rule between columns to be dotted

- `dashed` — Sets the rule between columns to be dashed

- `solid` — Sets the rule between columns to be solid

- `double` — Sets the rule between columns to have double parallel lines

- `groove` — Sets the rule between columns to have a 3D groove style

- `ridge` — Sets the rule between columns to have a 3D ridge style

- `inset` — Sets the rule between columns to have a 3D inset style

- `outset` — Sets the rule between columns to have a 3D outset style

### column-rule-width

This specifies the width of the rules. `medium` is the default.

- `thin` — Sets the width of the rule between columns to be thin

- `medium` — Sets the width of the rule between columns to be medium

- `thick` — Sets the width of the rule between columns to be thick

- `length` — Sets the width of the rule based on a specific value of %, px, or em

### column-span

This sets the amount of columns for a column to span across. `1` is the default.

- `1` — Sets the elements to span across 1 column

- `all` — Sets the elements to span across all columns

### column-width

This specifies the width that the individual columns should have. `auto` is the default.

- `auto` — Allows the browser to automatically set the width of the columns

- `length` — Sets the width of the individual columns based on a specific value of %, px, or em

### columns

This is the shorthand property for setting `column-span` and `column-width`. `auto auto` is the default.

- `column-width` — Specifies the width that the individual columns based a specific value of %, px, or em

- `column-span` — Sets the amount of columns for a column to span across

* * *

## In Conclusion

All in all, CSS Columns are pretty awesome and are a nice tool to have in your web design toolbox.

* * *

## Browser Support

<div class="browserSupport__list">
<img src="../../assets/img/ie.svg" alt="ie10 and above" title="ie10 and above">
<img src="../../assets/img/chrome.svg" alt="Chrome 31 and above using -webkit-" title="Chrome 31 and above using -webkit-">
<img src="../../assets/img/firefox.svg" alt="Fire Fox 25 and above using -moz-" title="Fire Fox 25 and above using -moz-">
<img src="../../assets/img/safari.svg" alt="Safari 7 and above using -webkit-" title="Safari 7 and above using -webkit-">
</div>

CSS3 Multiple Columns have good browser support working in all modern browsers. Not supported in Internet Explorer 9 and below. There are a few things to note:

- Fire Fox requires the "-moz-" prefix

- Chrome and Safari require the "-webkit-" prefix.

- The `column-fill` property is not yet supported in any major browser

* * *

## Sources

- [http://caniuse.com/](http://caniuse.com/)

- [http://webtypography.net/Rhythm\_and\_Proportion/Horizontal\_Motion/2.1.2/](http://webtypography.net/Rhythm_and_Proportion/Horizontal_Motion/2.1.2/)

- [http://www.webdesignerdepot.com/2013/03/how-to-use-css3-columns/](http://www.webdesignerdepot.com/2013/03/how-to-use-css3-columns/)

- [http://css-tricks.com/snippets/css/multiple-columns/](http://css-tricks.com/snippets/css/multiple-columns/)

- [http://www.w3schools.com/css/css3\_multiple\_columns.asp](http://www.w3schools.com/css/css3_multiple_columns.asp)
