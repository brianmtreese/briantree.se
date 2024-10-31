---
layout: post
title: "How and Why to Use the CSS Clip Property"
date: "2014-02-02"
tags: 
  - "Animation"
  - "CSS"
---

<p class="intro"><span class="dropcap">T</span>he CSS Clip property is an odd one. I've been building websites for a long time and didn't know about it even though it's been around for a while. In this article I am going to explore how and why to use the CSS Clip property.</p>

To visualize how the CSS Clip property works think of it as a PhotoShop clipping mask. When using a clipping mask on an image you are specifying the viewable area for the image. That's exactly how the CSS Clip property works. You define, with CSS, the viewable area for an item.

## CSS Clip Example

Here's a basic example of the CSS Clip property in action

```css
.imageContainer {
    border: dotted 5px #bebebe;
    height: 0;
    padding-top: 66.52298850574713%;
    position: relative;
}

.imageContainer img {
    clip: rect(70px, 300px, 250px, 100px);
    position: absolute;
    top: 0;
    right: 0;
    bottom: 0;
    left: 0;
}
```

### Original Image

<div>
<img width="330" height="220" src="../../assets/img/content/uploads/2014/62H.webp" alt="" style="width: 100%; height: auto;">
</div>

### Clipped Image

<style>
#demo1 { border: dotted 5px #bebebe; height: 0; padding-top: 66.52298850574713%; position: relative; margin-bottom: 2em; }
#demo1 img { clip: rect(70px, 300px, 250px, 100px); position: absolute; top: 0; right: 0; bottom: 0; left: 0; width: 100%; height: auto; }
</style>

<div id="demo1" class="imageContainer">
<img width="330" height="220" src="../../assets/img/content/uploads/2014/62H.webp" alt="CSS Clip Example">
</div>

## How Does it Work?

The CSS Clip property will only apply to items using absolute or fixed positioning. Besides that you simply set a shape and a set of values in the order of top, right, bottom, and left in order to specify how the element gets clipped.

<div>
<img width="330" height="220" src="../../assets/img/content/uploads/2014/CSS-Clip-Example.webp" alt="CSS Clip Illustration" style="width: 100%; height: auto;">
</div>

### Properties

Here's the breakdown for the properties of CSS Clip.

- `shape` — first you have to specify a shape and currently the only shape available is the rectangle (rect)

- `top` — specifies where the clip begins based off the top edge of the item

- `right` — specifies where the clip ends based off the left edge of the item

- `bottom` — specifies where the clip end based off the top edge of the item

- `left` — specifies where the clip begins based off the left edge of the item

### Special Considerations

- Currently only works with rectangle shapes.

- Setting any of the parameters to a value of `auto` will undo the clip for that parameter

- Requires commas between top, right, bottom, and left values.

- is supported as far back as ie4. In order to use in ie4 - ie7 you will need to add a duplicate line omitting the commas.

* * *

## Why Use CSS Clip?

Like I said in the beginning of this article the CSS Clip property is an odd one. At this point you may be wondering why you would ever want to use it. Well, here are a few reasons:

### Accessibly Hide Content

If you've ever needed to hide content from the display but not from screen readers then you likely know the various positioning and text-indent techniques and their pros/cons. CSS Clip is a good way, perhaps the best way, to do this at the moment. Here's how you would accessibly hide content using CSS Clip:

```css
.hideContent {
    position: absolute !important;
    clip: rect(1px 1px 1px 1px); /* For ie4 - ie7 */
    clip: rect(1px, 1px, 1px, 1px); /* For everything Else */
}
```

There are a couple of reasons that this CSS Clip method is actually a little better than the others.

1. No performance issues with the browser needing to draw rectangles off the screen even though they are never displayed

3. No layout issues if using a RTL(Right to Left) language

### Also, You Can Do Cool Things Like This:

Since the CSS Clip values are animatable it allows for some pretty nifty user experiences.  

<iframe style="margin-top: 18px;" src="https://jsfiddle.net/zNcTR/4/embedded/result,html,css,js" width="100%" height="350" frameborder="0" allowfullscreen="allowfullscreen"></iframe>

Example Created By: [Hugo Giraudel](http://hugogiraudel.com/)

### And This:

<iframe style="margin-bottom: 0;" src="https://jsfiddle.net/X2pgF/3/embedded/result,html,css,js" width="100%" height="350" frameborder="0" allowfullscreen="allowfullscreen"></iframe>

Example Created By: [Hugo Giraudel](http://hugogiraudel.com/)

* * *

## Browser Support

<div class="browserSupport__list">
<img src="../../assets/img/ie.svg" alt="ie4 and above" title="ie4 and above">
<img src="../../assets/img/chrome.svg" alt="Chrome 1 and above" title="Chrome 1 and above">
<img src="../../assets/img/firefox.svg" alt="Fire Fox 1 and above" title="Fire Fox 1 and above">
<img src="../../assets/img/safari.svg" alt="Safari 1 and above" title="Safari 1 and above">
</div>

The CSS Clip property has great browser support working in all modern browsers. Needs a version without commas for ie7 and below.

* * *

## Sources

- [https://developer.mozilla.org/en-US/docs/Web/CSS/clip](https://developer.mozilla.org/en-US/docs/Web/CSS/clip)

- [http://tympanus.net/codrops/2013/01/16/understanding-the-css-clip-property/](http://tympanus.net/codrops/2013/01/16/understanding-the-css-clip-property/)

- [http://devotepress.com/wordpress-coding/hiding-content-using-css-clip/#.Uu6AMBCwL84](http://devotepress.com/wordpress-coding/hiding-content-using-css-clip/#.Uu6AMBCwL84)

- [http://adaptivethemes.com/using-css-clip-as-an-accessible-method-of-hiding-content](http://adaptivethemes.com/using-css-clip-as-an-accessible-method-of-hiding-content)
