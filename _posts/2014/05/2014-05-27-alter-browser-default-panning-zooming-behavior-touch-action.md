---
layout: post
title: "Alter Browser Default Panning and Zooming Behavior With CSS touch-action"
date: "2014-05-27"
tags: 
  - "CSS"
  - "Touch Action"
---

<p class="intro"><span class="dropcap">N</span>ow that there are so many people accessing the sites we build through touch devices many of us will see that we need to alter the default panning and zooming behavior of the browser when touching them.</p>

## Drawing Example

The easiest example to help you understand this property is through a simple canvas drawing demo. Below you can see that if you drag your cursor over the box it will draw properly wherever your mouse pointer goes. However, if you drag your finger over the box on a touch device you will create a bunch on single dots or you will drag the entire page left, right, up, or down and no drawing will occur.

#### Drag your mouse over the box below:

If you are using a touch screen you can try it and see how it works differently.  

<iframe src="../../demos/canvas-drawing/demo1.html" width="100%" height="350px" scrolling="no"></iframe>

## CSS touch-action to the Rescue

In order to resolve this issue you can use the CSS touch-action property. It can control how touch actions, panning and zooming, are triggered on elements within the page. Simply adding the following code will prevent the default behavior in supporting browsers:

```css
touch-action: none;
```

#### Drag your mouse or finger over the box below:

Regardless if you're using your mouse or your finger on touch devices it should now work the same. \*\*NOTE - if you are using anything other than ie10 or ie11 on your touch device the demo will not work.  

<iframe src="../../demos/canvas-drawing/demo2.html" width="100%" height="350px" scrolling="no"></iframe>

## CSS touch-action Values

The CSS touch-action property has a handful of different values that can be set.

- `auto` — this is the default value and will leave the touch behaviors up to the browser

- `none` — will not trigger any touch behaviors on the specified elements

- `pan-x` — will allow content to horizontally scroll on the specified elements

- `pan-y` — will allow content to vertically scroll on the specified elements

- `manipulation` — will allow scrolling and zooming on the specified elements

## Special Considerations

Just a couple of special considerations to keep in mind when using touch-action. The touch-action property is part of the [pointer-events](http://www.w3.org/TR/pointerevents/) specification which is still in the candidate recommendation phase. This means that it is both subject to change and likely to gain support in all major browsers at some point.

It only applies to elements that support both the CSS width and height properties. This is in place to help with performance issues for low-latency touch actions. So if you are using it on inline items you will want to them to display: block in order to achieve anticipated behavior.

* * *

## Browser Support

<div class="browserSupport__list"><img src="../../assets/img/ie.svg" alt="ie9 and above" title="ie10 and above"></div>

The touch-action property doesn't have very good browser support only working in internet explorer 10+ and you need to use the "-ms-" prefixed version in ie10. For Chrome, support is supposedly just around the corner so keep an eye out.

* * *

## Sources

- [https://dvcs.w3.org/hg/pointerevents/raw-file/tip/pointerEvents.html#the-touch-action-css-property](https://dvcs.w3.org/hg/pointerevents/raw-file/tip/pointerEvents.html#the-touch-action-css-property)
