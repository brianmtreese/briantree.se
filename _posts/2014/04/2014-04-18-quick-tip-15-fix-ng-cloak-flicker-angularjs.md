---
layout: post
title: "Quick Tip - 15: How to Fix ng-cloak Flicker in AngularJS"
date: "2014-04-18"
tags:
  - "Angular"
  - "Angular Directives"
  - "Angular Styles"
  - "CSS"
  - "HTML"
  - "JavaScript"
---

<p class="intro"><span class="dropcap">T</span>he <a href="https://docs.angularjs.org/api/ng/directive/ngCloak" target="_blank">ng-cloak</a> directive was added to <a href="https://angularjs.org/" target="_blank">Angular</a> in order to prevent the flickering of elements before your application has fully loaded. It then removes ng-cloak once it has had a chance to compile your views. However, there is still a flicker issue that occurs between when the view is first loaded and before Angular has had a chance to run.</p>

## How ng-cloak Works

The way that ng-cloak works is to add _display: none !important_ to items using it. The following code comes directly from the angular.js source file:

```css
[ng:cloak], 
[ng-cloak], 
[data-ng-cloak], 
[x-ng-cloak], 
.ng-cloak, 
.x-ng-cloak {
  display: none !important;
}
```

## So, What's the Problem?

The problem is that the style used to hide these items is included in the JavaScript file which takes a second to initialize. In this time period the CSS will not be parsed by the browser.

## The Fix

It is only a brief flicker but it is still undesired. Fortunately the fix is a very simple one. All you need to do is add the above CSS somewhere in your application stylesheet. That's all there is to it.
