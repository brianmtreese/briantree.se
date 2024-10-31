---
layout: post
title: "Oh Wow, That's Neat - 01: Snap.svg"
date: "2014-01-10"
tags: 
  - "Animation"
  - "CSS"
  - "JavaScript"
  - "SVG"
---

<p class="intro"><span class="dropcap">F</span>or those of you that have read my post <a href="/svgs-are-cool-you-should-start-using-them-if-youre-not-already/">"SVGs are Cool & You Should Start Using Them, If You’re Not Already"</a> you know that I am a fan of SVGs. In fact, now that I know a little more about them I feel that they are very under used in modern web development. They are light weight, resolution independent, and they really open up the door to so many possibilities for enhancing user experiences.</p>

It seems as though part of the reason that their use tends to be limited despite decent browser support is the lack of understanding about just what can be achieved when using them. For me, when I used to think of SVGs I immediately thought of an SVG as an asset and never about using JavaScript to modify and generate dynamic embedded SVGs. This is where the new JavaScript library [Snap.svg](http://snapsvg.io/) really shines.

Snap.svg for SVG manipulation is compared to jQuery for DOM manipulation. It provides a method for generating SVG content solely with JavaScript. If you don't have a need for that, it's ok, Snap.svg still works with SVGs created in other programs such as Adobe Illustrator. It also provides a powerful animation library complete with event handling geared specifically at manipulating SVGs for modern browsers. This library helps to bring SVGs to life by animating with masking, clipping, and patterns among other new SVG features.

Perhaps the most intriguing feature of Snap.svg the ability it provides to pull out pieces of your SVG code for use in SVG sprites. This allows you to save on http requests and allows JavaScript to interact with the components of the SVG sprite to manipulate it as needed.

## This video demonstrates exactly how it works

<div class="demoBox">
<iframe width="560" height="315" style="width: 100%; aspect-ratio: 560 / 315; height: auto;" src="//www.youtube.com/embed/hyaiFapVOek" frameborder="0" allowfullscreen></iframe>
</div>

## Demos

You can check out some demos [here](http://snapsvg.io/demos/).

## Download

You can download Snap.svg [here](http://snapsvg.io/), it's free and opensource.
