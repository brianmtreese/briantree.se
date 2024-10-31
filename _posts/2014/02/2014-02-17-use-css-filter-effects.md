---
layout: post
title: "How to Use CSS Filter Effects"
date: "2014-02-17"
tags: 
  - "Animation"
  - "CSS"
---

<style>
.filterExamples { display: flex;column-gap: 1em; }
.filterExample { flex: 1; }
.filterExample h4 { text-align: center; }
.filterExample figure, .filterExample img { width: 100%; }
.filterExample figure { margin: 0; padding: 0; }
.filterExample img { margin: 0; }
</style>

<p class="intro"><span class="dropcap">B</span>efore I get started you should know that at the time of writing CSS Filter Effects are not supported in the latest versions of ie(11) and Firefox(27) so if you are using them you should try Chrome, Safari, or Opera instead.</p>

CSS filter effects are quickly becoming one of the hottest topics among web designers. They allow us to do some cool stuff that we generally only do within image editing software like PhotoShop. This article explains how to use CSS filter effects in your designs today.

## The Functions

CSS filter effects consist of a set of functions that can be used to alter images and other HTML elements.

- [blur()](#blur)

- [brightness()](#brightness)

- [contrast()](#contrast)

- [drop-shadow()](#drop-shadow)

- [grayscale()](#grayscale)

- [hue-rotate()](#hue-rotate)

- [invert()](#invert)

- [opacity()](#opacity)

- [saturate()](#saturate)

- [sepia()](#sepia)

<style>
.filterExample{-moz-box-sizing:border-box;box-sizing:border-box;width:50%;margin-bottom: 1em;}
.filterExample h4{text-align:center;}
.filterExample img{width:100%; height: auto;}
.filterExample-left{float:left;padding-right:8px;}
.filterExample-right{float:right;padding-left:8px;}

@media screen and (max-width: 600px) { 
    .filterExample { width: auto; } 
    .filterExample-left { float: none; padding: 0 0 16px; } 
    .filterExample-left p { margin: 0; } 
    .filterExample-right { float: none; padding: 0; }
}
</style>

### blur()

If you've ever used a [Gaussian blur](http://en.wikipedia.org/wiki/Gaussian_blur) in PhotoShop then this is something you're already familiar with. The blur function accepts a radius that is passed as a regular CSS length value, however, percentage values are not supported. Larger values create more of a blur. 0 is the default value.

```css
img {
    -webkit-filter: blur(8px);
    filter: blur(8px);
}
```

<div class="filterExamples">
<div class="filterExample filterExample-left">
<h4 style="text-align: center">Original</h4>
<figure><img src="../../assets/img/content/uploads/2014/62H.webp" alt="CSS Filter Effect blur" width="162" height="108"></figure>
</div>
<div class="filterExample filterExample-right filterExample-blur" style="flex: 1;"><style>.filterExample-blur img { -webkit-filter: blur(8px); filter: blur(8px); }</style>
<h4 style="text-align: center">blur</h4>
<figure><img src="../../assets/img/content/uploads/2014/62H.webp" alt="CSS Filter Effect blur" width="162" height="108"></figure>
</div>
</div>

### brightness()

The brightness function will adjust the brightness of the image. The smaller the value the darker it will be. A value of 0 will make the image completely black. Values over 1.0 will make the image brighter than the original. 1.0 is the default value.

```css
img {
    -webkit-filter: brightness(0.65);
    filter: brightness(0.65);
}
```

<div class="filterExamples">
<div class="filterExample filterExample-left">
<h4>Original</h4>
<figure><img src="../../assets/img/content/uploads/2014/62H.webp" alt="CSS Filter Effect brightness" width="162" height="108"></figure>
</div>
<div class="filterExample filterExample-right filterExample-brightness"><style>.filterExample-brightness img { -webkit-filter: brightness(0.65); filter: brightness(0.65); }</style>
<h4>brightness</h4>
<figure><img src="../../assets/img/content/uploads/2014/62H.webp" alt="CSS Filter Effect brightness" width="162" height="108"></figure>
</div>
</div>

### contrast()

The contrast function will adjust the contrast of the image. The smaller the value the darker it will be. A value of 0 will make the image completely black. Values over 1.0 will increase the contrast of the original. 1.0 is the default value.

```css
img {
    -webkit-filter: contrast(1.65);
    filter: contrast(1.65);
}
```

<div class="filterExamples">
<div class="filterExample filterExample-left">
<h4>Original</h4>
<figure><img src="../../assets/img/content/uploads/2014/62H.webp" alt="CSS Filter Effect brightness" width="162" height="108"></figure>
</div>
<div class="filterExample filterExample-right filterExample-contrast"><style>.filterExample-contrast img { -webkit-filter: contrast(1.65); filter: contrast(1.65); }</style>
<h4>contrast</h4>
<figure><img src="../../assets/img/content/uploads/2014/62H.webp" alt="CSS Filter Effect brightness" width="162" height="108"></figure>
</div>
</div>

### drop-shadow()

In an [earlier post](/difference-css-box-shadow-filter-drop-shadow/) I explain the difference between filter: drop-shadow() and box-shadow so if you want to know the difference between the two you should read that. For the purposes of this article you should just know the drop shadow function exists. Like other image editing software you can specify an x and y offset, a blur radius, a spread radius, and a color value for the shadow.

- `offset-x` — A required value that specifies the horizontal distance the shadow will be offset and a negative value will place the shadow to the left of the element

- `offset-y` — A required value that specifies the vertical distance the shadow will be offset and a negative value will place the shadow above the element

- `blur-radius` — An optional value that specifies the size of the shadow. Larger values will increase the size and blurriness where as smaller values will reduce the size and make it sharper

- `spread-radius` — An optional value that specifies the size of the shadow without blurring it. Larger values will increase the size where as smaller values will reduce the size

- `color` — An optional value that specifies the color of the shadow. Different browsers have different default colors so you'll probably want to set this

```css
img {
    -webkit-filter: drop-shadow(5px 5px 8px currentColor);
    filter: drop-shadow(5px 5px 8px currentColor);
}
```

<div class="filterExamples">
<div class="filterExample filterExample-left">
<h4>Original</h4>
<figure><img src="../../assets/img/content/uploads/2014/62H.webp" alt="CSS Filter Effect brightness" width="162" height="108"></figure>
</div>
<div class="filterExample filterExample-right filterExample-drop-shadow"><style>.filterExample-drop-shadow img { -webkit-filter: drop-shadow(5px 5px 8px currentColor); filter: drop-shadow(5px 5px 8px currentColor); }</style>
<h4>drop-shadow</h4>
<figure><img src="../../assets/img/content/uploads/2014/62H.webp" alt="CSS Filter Effect brightness" width="162" height="108"></figure>
</div>
</div>

### grayscale()

The grayscale function removes the color from the image. It is controlled on a scale of 0% to 100% with 100% being completely grayscale. 100% is the default value.

```css
img {
    -webkit-filter: grayscale(100%);
    filter: grayscale(100%);
}
```

<div class="filterExamples">
<div class="filterExample filterExample-left">
<h4>Original</h4>
<figure><img src="../../assets/img/content/uploads/2014/62H.webp" alt="CSS Filter Effect brightness" width="162" height="108"></figure>
</div>
<div class="filterExample filterExample-right filterExample-grayscale"><style>.filterExample-grayscale img { -webkit-filter: grayscale(100%); filter: grayscale(100%); }</style>
<h4>grayscale</h4>
<figure><img src="../../assets/img/content/uploads/2014/62H.webp" alt="CSS Filter Effect brightness" width="162" height="108"></figure>
</div>
</div>

### hue-rotate()

The hue-rotate function will adjust the hues of the image based on angles of the color wheel. It has a maximum rotation of 360deg. 0deg is the default value.

```css
img {
    -webkit-filter: hue-rotate(50deg);
    filter: hue-rotate(50deg);
}
```

<div class="filterExamples">
<div class="filterExample filterExample-left">
<h4>Original</h4>
<figure><img src="../../assets/img/content/uploads/2014/62H.webp" alt="CSS Filter Effect brightness" width="162" height="108"></figure>
</div>
<div class="filterExample filterExample-right filterExample-hue-rotate"><style>.filterExample-hue-rotate img { -webkit-filter: hue-rotate(50deg); filter: hue-rotate(50deg); }</style>
<h4>hue-rotate</h4>
<figure><img src="../../assets/img/content/uploads/2014/62H.webp" alt="CSS Filter Effect brightness" width="162" height="108"></figure>
</div>
</div>

### invert()

The invert function inverts the colors of the image. It is controlled on a scale of 0% to 100% with 100% being completely inverted. 100% is the default value.

```css
img {
    -webkit-filter: invert(100%);
    filter: invert(100%);
}
```

<div class="filterExamples">
<div class="filterExample filterExample-left">
<h4>Original</h4>
<figure><img src="../../assets/img/content/uploads/2014/62H.webp" alt="CSS Filter Effect brightness" width="162" height="108"></figure>
</div>
<div class="filterExample filterExample-right filterExample-invert"><style>.filterExample-invert img { -webkit-filter: invert(100%); filter: invert(100%); }</style>
<h4>invert</h4>
<figure><img src="../../assets/img/content/uploads/2014/62H.webp" alt="CSS Filter Effect brightness" width="162" height="108"></figure>
</div>
</div>

### opacity()

The opacity function sets the opacity of an element. It is pretty much the same as the CSS "opacity" property that we've already been using accept that certain browsers provide hardware acceleration to help with performance. It is controlled on a scale of 0% to 100% with 0% being completely transparent. 100% is the default value.

```css
img {
    -webkit-filter: opacity(65%);
    filter: opacity(65%);
}
```

<div class="filterExamples">
<div class="filterExample filterExample-left">
<h4>Original</h4>
<figure><img src="../../assets/img/content/uploads/2014/62H.webp" alt="CSS Filter Effect brightness" width="162" height="108"></figure>
</div>
<div class="filterExample filterExample-right filterExample-opacity"><style>.filterExample-opacity img { -webkit-filter: opacity(65%); filter: opacity(65%); }</style>
<h4>opacity</h4>
<figure><img src="../../assets/img/content/uploads/2014/62H.webp" alt="CSS Filter Effect brightness" width="162" height="108"></figure>
</div>
</div>

### saturate()

The saturate function controls the saturation of colors within an image. A value of 0 will make the image completely un-saturated. Values over 1.0 will increase the saturation of the original. 1.0 is the default value.

```css
img {
    -webkit-filter: saturate(1.65);
    filter: saturate(1.65);
}
```

<div class="filterExamples">
<div class="filterExample filterExample-left">
<h4>Original</h4>
<figure><img src="../../assets/img/content/uploads/2014/62H.webp" alt="CSS Filter Effect brightness" width="162" height="108"></figure>
</div>
<div class="filterExample filterExample-right filterExample-saturate"><style>.filterExample-saturate img { -webkit-filter: saturate(1.65); filter: saturate(1.65); }</style>
<h4>saturate</h4>
<figure><img src="../../assets/img/content/uploads/2014/62H.webp" alt="CSS Filter Effect brightness" width="162" height="108"></figure>
</div>
</div>

### sepia()

The sepia function converts the image to a sepia tone. It is controlled on a scale of 0% to 100% with 100% being completely sepia tone. 100% is the default value.

```css
img {
    -webkit-filter: sepia(100%);
    filter: sepia(100%);
}
```

<div class="filterExamples">
<div class="filterExample filterExample-left">
<h4>Original</h4>
<figure><img src="../../assets/img/content/uploads/2014/62H.webp" alt="CSS Filter Effect brightness" width="162" height="108"></figure>
</div>
<div class="filterExample filterExample-right filterExample-sepia"><style>.filterExample-sepia img { -webkit-filter: sepia(100%); filter: sepia(100%); }</style>
<h4>sepia</h4>
<figure><img src="../../assets/img/content/uploads/2014/62H.webp" alt="CSS Filter Effect brightness" width="162" height="108"></figure>
</div>
</div>

## Can I Use More Than One Filter at a Time?

Yep, you sure can. Here's how you would do that:

```css
img {
    -webkit-filter: invert(100%) drop-shadow(5px 5px 8px #000);
    filter: invert(100%) drop-shadow(5px 5px 8px #000);
}
```

<div class="filterExamples">
<div class="filterExample filterExample-left">
<h4>Original</h4>
<figure><img src="../../assets/img/content/uploads/2014/62H.webp" alt="CSS Filter Effect brightness" width="162" height="108"></figure>
</div>
<div class="filterExample filterExample-right filterExample-multiple"><style>.filterExample-multiple img { -webkit-filter: invert(100%) drop-shadow(5px 5px 8px #000); filter: invert(100%) drop-shadow(5px 5px 8px #000); }</style>
<h4>Multiple</h4>
<figure><img src="../../assets/img/content/uploads/2014/62H.webp" alt="CSS Filter Effect brightness" width="162" height="108"></figure>
</div>
</div>

## Can I Use Filters With Animations?

Yep, you sure can, take a look at this example:

```css
@-keyframes filterAnimation {
    0% {
        invert(0%) opacity(100%);
    }
    100% {
        invert(100%) opacity(50%);
    }
}

img {
    animation-name: filterAnimation;
    animation-duration: 3s;
    animation-iteration-count: infinite;
}
```

<div class="filterExamples">
<div class="filterExample filterExample-left">
<h4>Original</h4>
<figure><img src="../../assets/img/content/uploads/2014/62H.webp" alt="Multiple CSS Filter Effects" width="162" height="108"></figure>
</div>
<div class="filterExample filterExample-right filterExample-animated"><style> @-webkit-keyframes filterAnimation { 0% { -webkit-filter: invert(0%) opacity(100%); } 100% { -webkit-filter: invert(100%) opacity(50%); } } @-keyframes filterAnimation { 0% { filter: invert(0%) opacity(100%); } 100% { filter: invert(100%) opacity(50%); } }.filterExample-animated img { -webkit-animation-name: filterAnimation; -webkit-animation-duration: 3s; -webkit-animation-iteration-count: infinite; animation-name: filterAnimation; animation-duration: 3s; animation-iteration-count: infinite;}</style>
<h4>Animated</h4>
<figure><img src="../../assets/img/content/uploads/2014/62H.webp" alt="Multiple CSS Filter Effects" width="162" height="108"></figure>
</div>
</div>

## CSS Filter Performance

There are some performance considerations with some of the CSS Filter functions. The drop-shadow and opacity functions utilize hardware acceleration in various browsers possibly resulting in a performance gain over box-shadow and the CSS "opacity" property.

In general the filters that apply blurring effects will tend to be less performant than those that do not. But, in browsers that take advantage of hardware acceleration this shouldn't be an issue.

* * *

## Browser Support

<div class="browserSupport__list">
<img src="../../assets/img/chrome.svg" alt="Chrome 18 and above using -webkit-" title="Chrome 18 and above using -webkit-">
<img src="../../assets/img/safari.svg" alt="Safari 6 and above" title="Safari 6 and above using -webkit-">
</div>

Browser support is not great. CSS filters are still considered experimental because the spec is still in the working draft phase. There is currently no support in Firefox and ie, nope not even ie11.

* * *

## Sources

- [http://caniuse.com/css-filters](http://caniuse.com/css-filters)

- [http://davidwalsh.name/css-filters](http://davidwalsh.name/css-filters)

- [http://www.html5rocks.com/en/tutorials/filters/understanding-css](http://www.html5rocks.com/en/tutorials/filters/understanding-css/)

- [https://developer.mozilla.org/en-US/docs/Web/CSS/filter](https://developer.mozilla.org/en-US/docs/Web/CSS/filter)
