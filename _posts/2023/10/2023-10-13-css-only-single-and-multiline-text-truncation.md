---
layout: post
title: "Single and Multi-line Truncation With Ease"
date: "2023-10-13"
video_id: "SrKwDEihwB4"
categories: 
  - "css"
---

<p class="intro"><span class="dropcap">A</span>re you running into scenarios where you have a single line of text that can get too long and you want to truncate it? How about multiple lines that you want to constrain to a known number of lines and then truncate? Well, in this post I’ll show you how to do both with nothing but CSS. Let’s check it out!</p>

<iframe width="560" height="315" src="https://www.youtube.com/embed/SrKwDEihwB4?si=vCVHjTrBtsJInFcq" title="YouTube video player" frameborder="0" allow="accelerometer; autoplay; clipboard-write; encrypted-media; gyroscope; picture-in-picture; web-share" allowfullscreen></iframe>

## Truncating a Single Line of Text With the text-overflow Property

With CSS we have the `text-overflow` property that we can use any time we want to truncate a single line of text. Seems simple enough right? But there are a couple of things to be on the lookout for so let’s look at an example.

Here, we have some issues with our username display in the header bar for our site. This person has a long name and it’s breaking our layout. Let’s truncate it when this happens.

<div class="demoBox" style="padding: 0;">
<img src="{{ '/assets/img/content/uploads/2023/10-13/single-line-overflowing-container.png' | relative_url }}" alt="A single line of text overflowing out of its containing block" width="1776" height="214" style="width: 100%; height: auto; display: block; margin: 0;">
</div>

Here on our username, we already have `white-space` set to `nowrap` because we want to keep the name on a single line. 

```css
.username {
  white-space: nowrap;
}
```

So, to truncate it, we use the `text-overflow` with a value of `ellipsis`.

```css
.username {
  white-space: nowrap;
  text-overflow: ellipsis;
}
```

But, nothing happens. This is because we need to do a few more things here. First, text overflow won’t work without adding overflow hidden.

```css
.username {
  white-space: nowrap;
  text-overflow: ellipsis;
  overflow: hidden;
}
```

### Properly Handling text-overflow Within a Flex Container

Another issue we have with this particular example is that it’s contained within our header which is a flex container. Both the nav and our user sections will be flex items that have a min width value of auto by default. We need to make our user item flexible, which we can do by adding a flex of one.

```css
.user {
  flex: 1;
}
```

And now, we need to allow it to shrink by setting a min-width to zero.

```css
.user {
  flex: 1;
  min-width: 0;
}
```

Ok now we’re getting somewhere but our avatar is getting a little squeezed.

<div class="demoBox" style="padding: 0;">
<img src="{{ '/assets/img/content/uploads/2023/10-13/avatar-squeezed-by-username.png' | relative_url }}" alt="The username squeezing the avatar" width="1758" height="198" style="width: 100%; height: auto; display: block; margin: 0;">
</div>

This is probably because we need to make our username flexible too, so, let’s add flex one.

```css
.username {
  white-space: nowrap;
  text-overflow: ellipsis;
  overflow: hidden;
  flex: 1;
}
```

Yep, that was it.

<div class="demoBox" style="padding: 0;">
<img src="{{ '/assets/img/content/uploads/2023/10-13/single-line-text-truncation-final-example.png' | relative_url }}" alt="Single line text truncation final example" width="1754" height="212" style="width: 100%; height: auto; display: block; margin: 0;">
</div>

Nice, so we have this single line of text truncated properly now. You can check out the final example below:

<p class="codepen" data-height="300" data-default-tab="html,result" data-slug-hash="vYvPzzY" data-user="brianmtreese" style="height: 300px; box-sizing: border-box; display: flex; align-items: center; justify-content: center; border: 2px solid; margin: 1em 0; padding: 1em;">
  <span>See the Pen <a href="https://codepen.io/brianmtreese/pen/vYvPzzY">
  Text Overflow - Single Line</a> by Brian (<a href="https://codepen.io/brianmtreese">@brianmtreese</a>)
  on <a href="https://codepen.io">CodePen</a>.</span>
</p>
<script async src="https://cpwebassets.codepen.io/assets/embed/ei.js"></script>

## Truncating Multiple Lines of Text With the line-clamp Property

What if we had multiple lines that we want to truncate? Well, we can do this again with a handful of `CSS` properties, and the webkit prefixed `line-clamp` property. Let’s take a look at another example.

Here, we have this list of blog posts that show an excerpt. But, we only want to see three lines of the excerpt in each post.

<div class="demoBox" style="padding: 0;">
<img src="{{ '/assets/img/content/uploads/2023/10-13/multi-line-untruncated-text.png' | relative_url }}" alt="An example of blog list layout with post excerpts of varying length" width="2070" height="1598" style="width: 100%; height: auto; display: block; margin: 0;">
</div>

Well, let’s add our webkit `line-clamp` property with a value of three.

```css
p {
  -webkit-line-clamp: 3;
}
```

Ok, just like the last example, nothing happens. This is because we need a few more properties too. First, we need to set the display property to webkit-box.

```css
p {
  -webkit-line-clamp: 3;
  display: -webkit-box;
}
```

Then we need to add -webkit-box-orient: with a value of vertical. Almost there I promise.

```css
p {
  -webkit-line-clamp: 3;
  display: -webkit-box;
  -webkit-box-orient: vertical;
}
```

The last thing we need to add is overflow hidden.

```css
p {
  -webkit-line-clamp: 3;
  display: -webkit-box;
  -webkit-box-orient: vertical;
  overflow: hidden; 
}
```

Tada. There it is, now these are properly truncated to three lines of text.

<div class="demoBox" style="padding: 0;">
<img src="{{ '/assets/img/content/uploads/2023/10-13/multi-line-truncated-text.png' | relative_url }}" alt="Multi-line text truncation final example" width="2080" height="1606" style="width: 100%; height: auto; display: block; margin: 0;">
</div>

And, even as they shrink and grow, they will continue to show three lines. Pretty cool.

It’s probably important here to mention that, in most cases similar to this, you’d want to be sure that you’re not hiding a lot of text for performance reasons. Like if these excerpts were actually a full blog post here, that wouldn’t be great. It’s better to do something more like what we have where we have a fairly short excerpt for each post and then we truncate with CSS.

Check out the final example below:

<p class="codepen" data-height="300" data-default-tab="html,result" data-slug-hash="Jjwzmdg" data-user="brianmtreese" style="height: 300px; box-sizing: border-box; display: flex; align-items: center; justify-content: center; border: 2px solid; margin: 1em 0; padding: 1em;">
  <span>See the Pen <a href="https://codepen.io/brianmtreese/pen/Jjwzmdg">
  Text Overflow - Multiline</a> by Brian (<a href="https://codepen.io/brianmtreese">@brianmtreese</a>)
  on <a href="https://codepen.io">CodePen</a>.</span>
</p>
<script async src="https://cpwebassets.codepen.io/assets/embed/ei.js"></script>

Ok, so I think that’s all I have for this now. Until you next time, thanks for reading!
