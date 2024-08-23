---
layout: post
title: "CSS Shapes: The Ultimate Guide 03 - Fundamentals"
date: "2024-08-20"
video_id: "mhel88ijVGM"
categories: 
  - "css"
  - "css shapes"
---

<p class="intro"><span class="dropcap">W</span>hen you began building websites did you expect content to wrap around a floated image with transparency? Did you think that the first time you created a floated circle with a 50% border radius that the content would flow around it in an arc? And each time you did, did you yell to yourself, why is this not possible? Well, this used to be a real problem on the web, but now we have CSS Shapes.</p>

<iframe width="1280" height="720" src="https://www.youtube.com/embed/mhel88ijVGM" title="" frameborder="0" allow="accelerometer; autoplay; clipboard-write; encrypted-media; gyroscope; picture-in-picture; web-share" allowfullscreen></iframe>

## What are CSS Shapes?

CSS shapes is a specification for wrapping content around custom shapes and paths. The name CSS Shapes is somewhat misleading. You see, shapes are all about controlling how content flows around a shape or image but they do not actually render a shape to the page.

<div>
<img src="{{ '/assets/img/content/uploads/2024/08-20-01/demo-1.gif' | relative_url }}" alt="Graphic explaining how CSS shapes don't actually render a shape to the page" width="1280" height="720" style="width: 100%; height: auto;">
</div>

So to put it another way, CSS Shapes do not actually create visual shapes in the page, they simply determine what the float area looks like.

They provide us with the ability to create more dynamic layouts on the web by breaking free from rectangles and boxes.

## Basic Rules and Concepts

Now before we get too far a long however, there are some rules and core concepts that we need to understand.

**1. CSS Shapes Only Work With Floated Items**<br />
Currently, they can only be applied when used in combination with CSS floats. So, if an item is not floated left or right, then shapes will not be applied.

**2. CSS Shapes Only Work With Block-level Items**<br />
They can only be applied to block level elements or inline elements set to display block.

**3. Content Only Flows to One Side**<br />
Content will ONLY flow to the right of a left floated item and to the left of a right floated item. It will NEVER flow on more than one side or within open areas of a shape or image. So if we take a triangle for example, and float it to the left, even though we have some free space on the left the content will only flow around the right edge and not on both sides

<div>
<img src="{{ '/assets/img/content/uploads/2024/08-20-01/demo-2.gif' | relative_url }}" alt="Graphic explaining how the content wraps around floated items" width="1280" height="720" style="width: 100%; height: auto;">
</div>
 
## The shape-outside Property Values

CSS shapes use the [shape-outside](https://developer.mozilla.org/en-US/docs/Web/CSS/shape-outside) property which can accept different categories of values.

### Keyword Values

First, there are keyword values, which refer to the `<shape-box>` types from the [CSS box model](https://developer.mozilla.org/en-US/docs/Learn/CSS/Building_blocks/The_box_model). These values are: 

* none
* margin-box
* border-box
* padding-box
* content-box

### Basic Shape Values

Next we have basic shape values, which refer to [basic shape](https://developer.mozilla.org/en-US/docs/Web/CSS/basic-shape) functions in CSS. These values are: 

* circle
* ellipse
* inset
* polygon

### URL Values

Then there are URL values, which are based on the url for a given image url().

* url()

### Global Values

And finally we have global values: 

* initial
* inherit
* unset 

Ok, with some basic fundamentals under our belt, next we'll explore what is referred to as [the reference box](https://developer.mozilla.org/en-US/docs/Web/CSS/CSS_shapes/Basic_shapes#the_reference_box). We'll take a look at what it is, what it does, and how we can manipulate it to best suit our needs.

## Want to Watch the Full Course?

Don't want to read? You can watch the full course instead here: [CSS Shapes: The Ultimate Guide](https://www.youtube.com/playlist?list=PLp-SHngyo0_jOW0nu1L4H-j-Y2BDocYZP).