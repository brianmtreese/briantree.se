---
layout: post
title: "CSS Shapes: The Reference Box"
date: "2024-08-20"
video_id: "9J8h7obUjuM"
tags: 
  - "CSS"
  - "CSS Shapes"
---

<p class="intro"><span class="dropcap">T</span>here are a few things that CSS shapes need in order to function and display as desired. First, they need to be floated. Next, they need a coordinate system to control how they are drawn and where they are placed. And this coordinate system needs an origin.</p>

<iframe width="1280" height="720" src="https://www.youtube.com/embed/9J8h7obUjuM" title="" frameborder="0" allow="accelerometer; autoplay; clipboard-write; encrypted-media; gyroscope; picture-in-picture; web-share" allowfullscreen></iframe>

## What is the reference box?

The reference box is simply virtual box that will contain the shape. The reference box also establishes the coordinate system. And it controls how the shape will be drawn and positioned.

<div>
<img src="{{ '/assets/img/content/uploads/2024/08-20-02/demo-1.gif' | relative_url }}" alt="Graphic demonstrating how the reference box works for CSS Shapes" width="1280" height="720" style="width: 100%; height: auto;">
</div>

## The CSS box-model Values

The reference box is created using [CSS box model](https://developer.mozilla.org/en-US/docs/Learn/CSS/Building_blocks/The_box_model) values. These values are: 

* margin-box, which is the default
* border-box
* padding-box
* content-box

We will go through exactly how each of these effect how shapes are drawn and positioned a little later in this guide. But, before we do we need to discuss both the [shape-outside](https://developer.mozilla.org/en-US/docs/Web/CSS/shape-outside) property and the [clip-path](https://developer.mozilla.org/en-US/docs/Web/CSS/clip-path) property which we will move onto next. But before we get into those, we have a little bit more to cover on the reference box.

## The Anatomy of the Reference Box

First, it’s important to note that the default coordinate origin centers on the top left corner of this reference box. And, the shape’s origin is in the center of this coordinate system where the two diagonals meet. This origin can be moved using x and y coordinate values which we will see in a little bit.

<div>
<img src="{{ '/assets/img/content/uploads/2024/08-20-02/demo-2.gif' | relative_url }}" alt="Graphic demonstrating how coordinate system works for CSS Shapes" width="1280" height="720" style="width: 100%; height: auto;">
</div>

### Margin and CSS Shapes

Lastly, it’s important to note that margin applied to the reference box has the ability to affect the placement and size of the shape if used with margin-box. And we will dig into this further later on in this module.

<div>
<img src="{{ '/assets/img/content/uploads/2024/08-20-02/demo-3.gif' | relative_url }}" alt="Graphic demonstrating how magin affects CSS Shapes" width="1280" height="720" style="width: 100%; height: auto;">
</div>

So now that we know a little about the reference box and how it works, let’s move on and take a look at how the shape-outside property and clip-path properties work and then we’ll come back to the reference box and examine the different values and how they affect how shapes drawn within them.

## Want to Watch the Full Course?

Don't want to read? You can watch the full course instead here: [CSS Shapes: The Ultimate Guide](https://www.youtube.com/playlist?list=PLp-SHngyo0_jOW0nu1L4H-j-Y2BDocYZP).
