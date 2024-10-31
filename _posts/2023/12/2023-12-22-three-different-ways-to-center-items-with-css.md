---
layout: post
title: "3 Modern CSS Techniques for Centering Items"
date: "2023-12-22"
video_id: "XMH4c1xIZtE"
tags: 
  - "CSS"
---

<p class="intro"><span class="dropcap">C</span>entering items with HTML and CSS used to be pretty tough to do. Well, it’s not anymore. There are many different ways to do it now. And that’s a good thing because we may need different options in different scenarios. In this video we’ll look at three of my favorite ways to center items, We’ll use positioning, then we’ll use flexbox, and lastly, we’ll use my go-to CSS grid. Alright, let’s get to it.</p>

<iframe width="560" height="315" src="https://www.youtube.com/embed/XMH4c1xIZtE?si=6S1q6iduZ6iYxWd6" title="YouTube video player" frameborder="0" allow="accelerometer; autoplay; clipboard-write; encrypted-media; gyroscope; picture-in-picture; web-share" allowfullscreen></iframe>

It’s really such an odd thing that it was so difficult for so long to simply place items in the center of a container on the Web. Well, horizontal centering was easy, but vertical centering was nearly impossible up until more recent years.

## Using CSS Positioning to Center Items

This first method, using CSS positioning, has probably been around the longest, but it has evolved a little as newer properties have emerged. Let’s look at an example.

Here we have this box that we want to center in this other container with the red border.
It’s a strong element and it’s placed directly within a `div` element which is this red box that we’re seeing here.

<div>
<img src="{{ '/assets/img/content/uploads/2023/12-22/before-demo.png' | relative_url }}" alt="Demo before using CSS positioning to center items" width="856" height="682" style="width: 100%; height: auto;">
</div>

We’re going to use absolute positioning for this method so let’s add it to our `strong` element.

```css
strong {
    position: absolute;
}
```

Now, in order for this to function correctly, our `div` will need to create a positioning context for our item to be positioned on. There are many different ways to do this but the best option for this example is to use relative positioning.

```css
div {
    position: relative;
}
```

Now we can position our element down fifty percent of the height of our `div` and over fifty percent of the width. To position down from the top we can use the new logical property, `inset-block-start` with a value of fifty percent. And, to position over from the left we can use `inset-inline-start` with the same value of fifty percent.

```css
strong {
    ...
    inset-block-start: 50%;
    inset-inline-start: 50%;
}
```

<div>
<img src="{{ '/assets/img/content/uploads/2023/12-22/positioning-before-translation.png' | relative_url }}" alt="Demo after CSS positioning but before translating to center items" width="856" height="680" style="width: 100%; height: auto;">
</div>

Ok, so it’s not exactly centered, is it?

Well, this is because we’ve positioned the item in the center of our `div`, but its position is based on its top left corner. What we need to do now is shift the item back up fifty percent of its own height and back over fifty percent of its own width. This will get it properly placed in the center.

But, how can we do this?

It’s actually really easy. We can use the new CSS `translate` property. The first value will translate along the x-axis. We need to go back fifty percent, so we’ll add a value of negative fifty percent. And, the second value translates along the y-axis, we’ll give it the same value of negative fifty percent.

```css
strong {
    ...
    translate: -50% -50%;
}
```

<div>
<img src="{{ '/assets/img/content/uploads/2023/12-22/items-centered.png' | relative_url }}" alt="Demo after CSS positioning and translating to center items" width="856" height="680" style="width: 100%; height: auto;">
</div>

And there we go. Perfectly centered.

Here's the final working example using positioning and translation:

<p class="codepen" data-height="700" data-slug-hash="PoLYmKW" data-user="brianmtreese" style="height: 700px; box-sizing: border-box; display: flex; align-items: center; justify-content: center; border: 2px solid; margin: 1em 0; padding: 1em;">
  <span>See the Pen <a href="https://codepen.io/brianmtreese/pen/PoLYmKW">
  CSS Positioning for centering</a> by Brian (<a href="https://codepen.io/brianmtreese">@brianmtreese</a>)
  on <a href="https://codepen.io">CodePen</a>.</span>
</p>
<script async src="https://cpwebassets.codepen.io/assets/embed/ei.js"></script>

So, this is one way we can do it, but it’s not my favorite.

## Using Flexbox to Center Items

If I can, I prefer to use flexbox over positioning because it’s even easier, requires fewer lines of code, no positioning context, and honestly, it just feels like a better, more modern solution. Let’s look at an example.

Ok, so we’re starting from the same point, we have our outer div with the red border and then our inner strong element.

<div>
<img src="{{ '/assets/img/content/uploads/2023/12-22/before-demo.png' | relative_url }}" alt="Demo before using CSS Flexbox to center items" width="856" height="682" style="width: 100%; height: auto;">
</div>

We start by making our div a flex container with display, flex. Then we can align our item to the center along the x-axis with the `justify-content` property and a value of center. And last but not least, we can align along the y-axis with the `align-items` property and the same value of center.

```css
div {
    display: flex;
    justify-content: center;
    align-items: center;
}
```

<div>
<img src="{{ '/assets/img/content/uploads/2023/12-22/items-centered-nowrap.png' | relative_url }}" alt="Demo after CSS Flexbox to center items" width="836" height="684" style="width: 100%; height: auto;">
</div>

And there you have it, the item is properly centered and it only took three lines of code to get there this time.

Here's the final working example using Flexbox:

<p class="codepen" data-height="700" data-slug-hash="bGZbWgW" data-user="brianmtreese" style="height: 700px; box-sizing: border-box; display: flex; align-items: center; justify-content: center; border: 2px solid; margin: 1em 0; padding: 1em;">
  <span>See the Pen <a href="https://codepen.io/brianmtreese/pen/bGZbWgW">
  CSS Flexbox for centering</a> by Brian (<a href="https://codepen.io/brianmtreese">@brianmtreese</a>)
  on <a href="https://codepen.io">CodePen</a>.</span>
</p>
<script async src="https://cpwebassets.codepen.io/assets/embed/ei.js"></script>

So that’s cool and I sometimes have the need to do this, but my favorite way to position items in the center is to use CSS grid. And again, my reasons for this are because it’s even easier than `flex` and requires even less code.

## Using Grid to Center Items

Ok, same starting point with the red box and inner item.

<div>
<img src="{{ '/assets/img/content/uploads/2023/12-22/before-demo.png' | relative_url }}" alt="Demo before using CSS Flexbox to center items" width="856" height="682" style="width: 100%; height: auto;">
</div>

This time we’ll make our div a grid container with a `display` value of `grid`. Now what’s cool here is that we can use the same two properties that we used for our flexbox example if we want. We can add `justify-content: center` and `align-items: center`. It works the same exact way.

```css
div {
    display: grid;
    justify-content: center;
    align-items: center;
}
```

Kind of funny but it’s just the way grid works, it can use the same box-alignment properties that flexbox does. But, if we left it this way there’d really be no advantage to use grid right?

Well, what we can do instead is, remove these alignment properties, and replace them with the place-items property. And, we can give this property a value of center.

```css
div {
    display: grid;
    place-items: center;
}
```

<div>
<img src="{{ '/assets/img/content/uploads/2023/12-22/items-centered-nowrap.png' | relative_url }}" alt="Demo after CSS Grid to center items" width="836" height="684" style="width: 100%; height: auto;">
</div>

There we go, now we’ve whittled it all the way down to just two lines of CSS.

Here's the final working example using CSS Grid:

<p class="codepen" data-height="700" data-slug-hash="zYbOwoM" data-user="brianmtreese" style="height: 700px; box-sizing: border-box; display: flex; align-items: center; justify-content: center; border: 2px solid; margin: 1em 0; padding: 1em;">
  <span>See the Pen <a href="https://codepen.io/brianmtreese/pen/zYbOwoM">
  CSS Grid for centering</a> by Brian (<a href="https://codepen.io/brianmtreese">@brianmtreese</a>)
  on <a href="https://codepen.io">CodePen</a>.</span>
</p>
<script async src="https://cpwebassets.codepen.io/assets/embed/ei.js"></script>

So like I said earlier, it’s a lot easier than it used to be that’s for sure. But all of these techniques are still very relevant and may be needed due to any number of circumstances so it’s good to know all of them just in case. I would definitely prefer the least amount of code CSS grid, and if that doesn’t work the next best thing flexbox, and if neither of those work, try positioning.
