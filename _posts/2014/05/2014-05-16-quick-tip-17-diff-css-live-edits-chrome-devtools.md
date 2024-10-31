---
layout: post
title: "Quick Tip – 17: How to Diff CSS Live Edits in Chrome DevTools"
date: "2014-05-16"
tags: 
  - "CSS"
---

<p class="intro"><span class="dropcap">I</span>f you're reading my blog I'll assume that you are familiar with how to live edit code within all browser developer tools. I use them all the time and can hardly remember what it was like without them. Chrome DevTools tend to be my favorite but FireFox and Internet Explorer continue to improve.</p>

Chrome DevTools have the best and most complete offering as well as some really great features. One nice feature that I recently learned about is the ability to diff your live edit CSS changes directly from within DevTools.

<style>
.demoBox {text-align: center}
</style>

## Here's How You Do it

When inspecting styles, click the link to the external stylesheet to open it in the "Sources" tab

<div class="demoBox">
  <img src="../../assets/img/content/uploads/2014/devtools-stylesheet-link.png" alt="When inspecting styles, click the link to the external stylesheet to open it in the Sources tab"> 
</div>

## Edit & Save Styles

Edit some styles and then save them (ctrl + s)

<div class="demoBox">
  <img src="../../assets/img/content/uploads/2014/devtools-sources-tab.png" alt="Edit some styles and then save them"> 
</div>

## Navigate to "Sources", "Local"

Right click within the "Sources" tab content area and select "Local Modifications"

<div class="demoBox">
  <img src="../../assets/img/content/uploads/2014/devtools-local-modifications.png" alt="Right click within the Sources tab content area and select Local Modifications"> 
</div>

## History Panel

This will open the history panel where you can diff your edits

<div class="demoBox">
  <img src="../../assets/img/content/uploads/2014/devtools-history.png" alt="This will open the history panel where you can diff your edits"> 
</div>
