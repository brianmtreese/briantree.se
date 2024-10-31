---
layout: post
title: "Things You May Not Know About CSS Backgrounds"
date: "2014-03-31"
tags: 
  - "CSS"
---

<p class="intro"><span class="dropcap">I</span> have been using CSS background properties for quite a few years and have only used what I have needed. There are some pretty cool things that can be done with backgrounds that I was not so familiar with. In this article I'll highlight some of these not so common options.</p>

<style>
.imageBox { background-image: url(../../assets/img/content/uploads/2014/77H-1024x682.jpg); background-repeat: no-repeat; border: dotted 20px #ff495d; color: #fff; margin-bottom: 40px; padding: 20px; }
</style>

## background-origin

The background-origin property specifies where the viewing area for backgrounds applied to a given container will start. The background origin is based off of the top left corner. This property will not be applied if background-attachment is fixed.

### border-box

The viewing area for backgrounds will begin at the outside edges of the container and will be displayed on a layer beneath the container's border if one is applied.

```css
div {
    background-origin: border-box;
}
```

<div class="imageBox" style="background-origin: border-box;">Lorem ipsum dolor sit amet, consectetuer adipiscing elit. Aenean commodo ligula eget dolor. Aenean massa. Cum sociis natoque penatibus et magnis dis parturient montes, nascetur ridiculus mus. Donec quam felis, ultricies nec, pellentesque eu, pretium quis, sem. Nulla consequat massa quis enim.</div>

### padding-box

The viewing area for backgrounds will begin at the outside edges of the padding if any is applied and will not be displayed below the border if one is applied.

```css
div {
    background-origin: padding-box;
}
```

<div class="imageBox" style="background-origin: padding-box;">Lorem ipsum dolor sit amet, consectetuer adipiscing elit. Aenean commodo ligula eget dolor. Aenean massa. Cum sociis natoque penatibus et magnis dis parturient montes, nascetur ridiculus mus. Donec quam felis, ultricies nec, pellentesque eu, pretium quis, sem. Nulla consequat massa quis enim.</div>

### content-box

The viewing area for backgrounds will begin at the edges of the content within the container.

```css
div {
    background-origin: content-box;
}
```

<div class="imageBox" style="background-origin: content-box;">Lorem ipsum dolor sit amet, consectetuer adipiscing elit. Aenean commodo ligula eget dolor. Aenean massa. Cum sociis natoque penatibus et magnis dis parturient montes, nascetur ridiculus mus. Donec quam felis, ultricies nec, pellentesque eu, pretium quis, sem. Nulla consequat massa quis enim.</div>

### inherit

The viewing area will be set based on that of its nearest parent with background-origin set. If one is not set on a parent element the default is padding-box.

* * *

## background-size

The background-size property specifies the size for background images applied to a given container.

### length/percentage

The background-size can be given a height and width in any length value px, em, %, etc. Percentages will be based on the dimensions of the parent container. Negative length values will not be applied.

```css
div {
    background-size: 80% 50%;
}
```

<div class="imageBox" style="background-size: 80% 50%;">Lorem ipsum dolor sit amet, consectetuer adipiscing elit. Aenean commodo ligula eget dolor. Aenean massa. Cum sociis natoque penatibus et magnis dis parturient montes, nascetur ridiculus mus. Donec quam felis, ultricies nec, pellentesque eu, pretium quis, sem. Nulla consequat massa quis enim.</div>

### auto

If explicitly setting a height and width on the background-size alters the aspect ratio/proportions of the image you can avoid this by picking either height or width to set explicitly and then set the other to auto.

```css
div {
    background-size: 80% auto;
}
```

<div class="imageBox" style="background-size: 80% auto;">Lorem ipsum dolor sit amet, consectetuer adipiscing elit. Aenean commodo ligula eget dolor. Aenean massa. Cum sociis natoque penatibus et magnis dis parturient montes, nascetur ridiculus mus. Donec quam felis, ultricies nec, pellentesque eu, pretium quis, sem. Nulla consequat massa quis enim.</div>

### cover

The cover property will set the size of the image, maintaining its proportions, to be as small as it can be while both of its dimensions are greater than or equal to the dimensions of its container. When using cover there will be no area of the container that does not have the background image applied.

```css
div {
    background-size: cover;
}
```

<div class="imageBox" style="background-size: cover;">Lorem ipsum dolor sit amet, consectetuer adipiscing elit. Aenean commodo ligula eget dolor. Aenean massa. Cum sociis natoque penatibus et magnis dis parturient montes, nascetur ridiculus mus. Donec quam felis, ultricies nec, pellentesque eu, pretium quis, sem. Nulla consequat massa quis enim.</div>

### contain

The contain property is the opposite of the cover property. It will set the size of the image, maintaining its proportions, to be as large as it can be while both of its dimensions are less than or equal to the dimensions of its container.

```css
div {
    background-size: contain;
}
```

<div class="imageBox" style="background-size: contain;">Lorem ipsum dolor sit amet, consectetuer adipiscing elit. Aenean commodo ligula eget dolor. Aenean massa. Cum sociis natoque penatibus et magnis dis parturient montes, nascetur ridiculus mus. Donec quam felis, ultricies nec, pellentesque eu, pretium quis, sem. Nulla consequat massa quis enim.</div>

## background-clip

The background-clip property specifies the viewing area for backgrounds applied to a given container.

### border-box

The viewing area for backgrounds will go to the outside edges of the container and will be displayed on a layer beneath the container's border if one is applied.

```css
div {
    background-clip: border-box;
}
```

<div class="imageBox" style="background-clip: border-box;">Lorem ipsum dolor sit amet, consectetuer adipiscing elit. Aenean commodo ligula eget dolor. Aenean massa. Cum sociis natoque penatibus et magnis dis parturient montes, nascetur ridiculus mus. Donec quam felis, ultricies nec, pellentesque eu, pretium quis, sem. Nulla consequat massa quis enim.</div>

### padding-box

The viewing area for backgrounds will go to the outside edges of the padding if any is applied and will not be displayed below the border if one is applied.

```css
div {
    background-clip: padding-box;
}
```

<div class="imageBox">Lorem ipsum dolor sit amet, consectetuer adipiscing elit. Aenean commodo ligula eget dolor. Aenean massa. Cum sociis natoque penatibus et magnis dis parturient montes, nascetur ridiculus mus. Donec quam felis, ultricies nec, pellentesque eu, pretium quis, sem. Nulla consequat massa quis enim.</div>

### content-box

The viewing area for backgrounds will go to the edges of the content within the container.

```css
div {
    background-clip: content-box;
}
```

<div class="imageBox" style="background-clip: content-box;">Lorem ipsum dolor sit amet, consectetuer adipiscing elit. Aenean commodo ligula eget dolor. Aenean massa. Cum sociis natoque penatibus et magnis dis parturient montes, nascetur ridiculus mus. Donec quam felis, ultricies nec, pellentesque eu, pretium quis, sem. Nulla consequat massa quis enim.</div>

### inherit

The viewing area will be set based on that of its nearest parent with background-clip set. If one is not set on a parent element the default is border-box.

* * *

## Browser Support

<div class="browserSupport__list">
<img src="../../assets/img/ie.svg" alt="ie9 and above" title="ie9 and above">
<img src="../../assets/img/chrome.svg" alt="Chrome 31 and above" title="Chrome 31 and above">
<img src="../../assets/img/firefox.svg" alt="Fire Fox 26 and above" title="Fire Fox 26 and above">
<img src="../../assets/img/safari.svg" alt="Safari 7 and above" title="Safari 7 and above">
</div>

These CSS background-image options have pretty good browser support working in the latest versions of all modern browsers. Not supported in ie8 and below.

* * *

## Sources

- [https://developer.mozilla.org/en-US/docs/Web/CSS/background](https://developer.mozilla.org/en-US/docs/Web/CSS/background)

- [https://developer.mozilla.org/en-US/docs/Web/CSS/background-origin](https://developer.mozilla.org/en-US/docs/Web/CSS/background-origin)

- [https://developer.mozilla.org/en-US/docs/Web/CSS/background-size](https://developer.mozilla.org/en-US/docs/Web/CSS/background-size)

- [https://developer.mozilla.org/en-US/docs/Web/CSS/background-clip](https://developer.mozilla.org/en-US/docs/Web/CSS/background-clip)

- [https://developer.mozilla.org/en-US/docs/Web/CSS/background-attachment](https://developer.mozilla.org/en-US/docs/Web/CSS/background-attachment)

- [http://www.css3.info/preview/background-origin-and-background-clip](http://www.css3.info/preview/background-origin-and-background-clip/)

- [http://www.css3.info/preview/background-size](http://www.css3.info/preview/background-size/)
