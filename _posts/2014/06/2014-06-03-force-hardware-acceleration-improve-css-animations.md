---
layout: post
title: "How to Force Hardware Acceleration to Improve CSS Animations"
date: "2014-06-03"
tags:
  - "Animation"
  - "CSS"
  - "CSS Transforms"
  - "HTML"
  - "Performance"
  - "SVG"
---

<p class="intro"><span class="dropcap">Y</span>ou've likely seen CSS animations and transitions in various web applications out there where they just didn't work well. They are choppy and freeze along with a bunch of other issues. This occurs because they are not taking advantage of the device GPU and hardware acceleration, but are instead using the browsers' built in rendering engine.</p>

Well, with a few lines of CSS we can fix this. Modern mobile and desktop browsers will now trigger hardware acceleration to aid with performance of certain complex CSS calculations. 3D transformations are the best way to set this up.

## All you have to do is add something like this

```css
.accelarate {
   -webkit-transform: translateZ(0);
   -moz-transform: translateZ(0);
   -ms-transform: translateZ(0);
   -o-transform: translateZ(0);
   transform: translateZ(0);
}
```

As you can see from this code there are not actually any 3D transformations taking place since tranzlatez is set to 0 but the existence of this property will hand the rendering off to the GPU.

## Considerations

As you can see this is somewhat of a hack so you should use it sparingly. It should only be used on items that are being animated due to the fact that over utilizing the GPU can cause performance issues itself as well as battery drain. Also, in order to get the biggest performance gains you should try to enable GPU acceleration on as few HTML elements as possible.

* * *
## Browser Support 

<div class="browserSupport__list">
  <img src="../../assets/img/ie.svg" alt="ie9 and above" title="ie9 and above">
  <img src="../../assets/img/chrome.svg" alt="Chrome" title="Chrome">
  <img src="../../assets/img/firefox.svg" alt="Fire Fox" title="Fire Fox">
  <img src="../../assets/img/safari.svg" alt="Safari" title="Safari">
</div>

Hardware acceleration has good support working in all modern browsers

* * *

## Sources

- [http://blog.teamtreehouse.com/increase-your-sites-performance-with-hardware-accelerated-css](http://blog.teamtreehouse.com/increase-your-sites-performance-with-hardware-accelerated-css)

- [http://www.urbaninsight.com/2013/01/04/improving-html5-app-performance-gpu-accelerated-css-transitions](http://www.urbaninsight.com/2013/01/04/improving-html5-app-performance-gpu-accelerated-css-transitions)

- [http://scotch.io/tutorials/off-canvas-menus-with-css3-transitions-and-transforms](http://scotch.io/tutorials/off-canvas-menus-with-css3-transitions-and-transforms)
