---
layout: post
title: "SVGs are Cool & You Should Start Using Them, If You're Not Already"
date: "2013-12-14"
tags: 
  - "CSS"
  - "SVG"
---

<p class="intro"><span class="dropcap">U</span>p until a couple of months ago I had no idea that there was even such a thing as an inline SVG. Once I found out I realized that I need to learn more about them. First off SVG stands for "Scalable Vector Graphics" which literally means just what it says. It's simply an image format containing XML code that describes vector graphics which can be resized large or small without affecting quality.</p>

Not all images are suitable as SVG however, just like raster and vector formats in image editing software, photos are still better suited as jpg, png, or gif format. Line art, a logo for example, would be better suited as SVG.

Once I started looking into them a little more I found that there are actually many different ways to use SVGs in a web page.

- [Using an SVG as a CSS background-image](#test-1)

- [Using an SVG as an inline image](#section-2)

- [Embedding an SVG using an iframe tag](#section-3)

- [Embedding an SVG using an object tag](#section-4)

- [Embedding an SVG using an embed tag](#section-5)

- [Using inline SVGs](#section-6)

* * *

## Using an SVG as a CSS background-image {#section-1}

This is very straight forward, you'll just need to save your image as SVG (I'll talk about this in detail in a later post) and then simply add it to your site as you would any other image. Once it's added just add the CSS background property with the path to your .svg file as you would any other .jpg, .png, or .gif image.

#### The Code:

```css
div { 
    background: url(graphic.svg) center center no-repeat;
    height: 130px;
}
```

#### Demo:

<style>
.exampleSvg__background div { background: url(../../assets/img/content/uploads/2014/01/graphic.svg) center center no-repeat; height: 130px; }
</style>

<div class="demoBox exampleSvg__background">
	<div>&nbsp;</div>
</div>

### Using background-size With an SVG Background

Using the CSS3 `background-size` property you can easily scale the SVG when using it as a background image.

#### The Code:

```css
div {
    background: url(graphic.svg) center center no-repeat;
    background-size: 90px 73px;
    height: 90px;
}
```

#### Demo:

<style>
.exampleSvg__background--size div { background: url(../../assets/img/content/uploads/2014/01/graphic.svg) center center no-repeat; background-size: 90px 73px; height: 90px; }
</style>

<div class="demoBox exampleSvg__background--size">
	<div>&nbsp;</div>
</div>

## Using an SVG as an inline image {#section-2}

This too is pretty straight forward, you just save your image as an SVG and then simply add it to your site as you would any other image. Once it's added just add an `<img>` tag and in the src attribute include the path to your .svg file like any other .jpg, .png, or .gif image.

#### The Code:

```html
<img src="graphic.svg" alt="SVG as an inline image" />
```

#### Demo:

<div class="demoBox exampleSvg" style="text-align: center;">
    <img src="../../assets/img/content/uploads/2014/01/graphic.svg" alt="SVG as an inline image">
</div>

## Embedding an SVG using an iframe tag {#section-3}

SVGs can be embedded directly into web pages, one way to do this is to add it to the "src" attribute on an `<iframe>` tag.

#### The Code:

```html
<iframe src="graphic.svg">
    Content for browsers that don't support SVG
</iframe>
```

#### Demo:

<style>
.exampleSvg__iframe { text-align: center; } .exampleSvg__iframe iframe { border: none; height: 140px; margin: 0; width: 171px; overflow: hidden; }
</style>

<div class="demoBox exampleSvg__iframe"><iframe src="../../assets/img/content/uploads/2014/01/graphic.svg">Content for browsers that don&#8217;t support SVG</iframe></div>

## Embedding an SVG using an object tag {#section-4}

Another method for embedding an SVG directly into a web page is to use an `<object>` tag.

#### The Code:

```html
<object data="graphic.svg" type="image/svg+xml">
    Content for browsers that don't support SVG
</object>
```

#### Demo:

<style>
.exampleSvg__object { text-align: center; } .exampleSvg__object object { margin: 0; }
</style>

<div class="demoBox exampleSvg__object"><object data="../../assets/img/content/uploads/2014/01/graphic.svg" type="image/svg+xml" width="300" height="150">Content for browsers that don’t support SVG</object></div>

## Embedding an SVG using an embed tag {#section-5}

Yet another method for embedding an SVG directly into a web page is to use an `<embed>` tag.

#### The Code:

```html
<embed src="graphic.svg&quot type="image/svg+xml" />
```

## Using inline SVGs {#section-6}

All of the code for the SVG can actually just be added to your page markup without relying on any external sources.

#### The Code: 

```html
<svg version="1.1" xmlns="http://www.w3.org/2000/svg" xmlns:xlink="http://www.w3.org/1999/xlink" x="0px" y="0px" width="180px" height="180px" viewBox="0 0 180 180" enable-background="new 0 0 180 180" xml:space="preserve">
	<circle fill="#000000" cx="90.304" cy="90" r="80.749"/>
	<path fill="#FFFFFF" d="M93.439,102.826l6.172,13.444l-5.177,15.468l-0.037,0.111l-0.02,0.115l-2.148,12.578h-3.685l-2.158-12.59 l-0.02-0.115l-0.037-0.11l-5.178-15.456l6.172-13.444H93.439 M94.412,101.309h-8.062l-6.828,14.875l5.368,16.025l2.374,13.852 h6.245l2.364-13.84l5.367-16.037L94.412,101.309L94.412,101.309z"/>
	<path fill="#FFFFFF" d="M38.511,48.808l-2.254,2.999l-0.377,0.501l0.088,0.622l1.686,11.972l0.048,0.344l0.193,0.289 l9.434,14.088l0.316,0.473l0.55,0.148l14.953,4.028l1.751,0.472l0.155-1.808l1.026-11.969l4.341-4.873l-2.298,5.048l-0.149,0.328 l0.014,0.36l0.506,13.151l0.021,0.546l0.364,0.408l13.704,15.309l-3.451,7.473c-1.689-2.412-5.119-7.242-12.128-17.043 l-0.25-0.35l-0.397-0.167l-17.71-7.421l-0.31-0.13l-0.335,0.013l-12.395,0.476l-0.371,0.015l-0.322,0.183l-1.729,0.984 c0.84-0.851,1.491-1.505,1.811-1.817c1.065-0.323,4.853-1.425,7.267-2.125l2.003-0.58L43.1,79.027l-9.38-13.876l1.195-13.414 L38.511,48.808 M47.21,39.76l-13.75,11.206l-1.3,14.588l9.682,14.323c0,0-7.437,2.153-7.626,2.238 c-0.189,0.086-9.694,9.839-9.694,9.839l11.144-6.343l12.395-0.476l17.71,7.421c0,0,13.498,18.873,13.625,19.209l4.984-10.791 L70.011,84.923l-0.506-13.151l6.448-14.167l-11.342,12.73l-1.069,12.472l-14.953-4.028L39.156,64.69L37.47,52.718L47.21,39.76 L47.21,39.76z"/>
	<polyline fill="none" stroke="#FFFFFF" stroke-width="1.5175" stroke-miterlimit="10" points="69.379,85.091 64.11,83.89 66.218,92.004"/>
	<line fill="none" stroke="#FFFFFF" stroke-width="1.5175" stroke-miterlimit="10" x1="65.48" y1="70.738" x2="68.894" y2="71.813"/>	
	<line fill="none" stroke="#FFFFFF" stroke-width="1.5175" stroke-miterlimit="10" x1="43.034" y1="80.349" x2="48.25" y2="84.427"/>	
	<line fill="none" stroke="#FFFFFF" stroke-width="1.5175" stroke-miterlimit="10" x1="42.623" y1="80.349" x2="48.25" y2="79.495"/>
	<line fill="none" stroke="#FFFFFF" stroke-width="1.5175" stroke-miterlimit="10" x1="33.002" y1="65.483" x2="38.565" y2="65.02"/>
	<line fill="none" stroke="#FFFFFF" stroke-width="1.5175" stroke-miterlimit="10" x1="34.14" y1="51.438" x2="36.88" y2="52.66"/>
	<path fill="#FFFFFF" d="M142.097,48.808l3.595,2.93l1.195,13.414l-9.38,13.876l-1.167,1.728l2.003,0.58 c2.414,0.699,6.202,1.801,7.267,2.125c0.32,0.312,0.971,0.966,1.811,1.817l-1.729-0.984l-0.322-0.183L145,84.095l-12.395-0.476 l-0.335-0.013l-0.31,0.13l-17.71,7.421l-0.397,0.167l-0.25,0.35c-7.01,9.802-10.439,14.632-12.128,17.043l-3.451-7.473 l13.705-15.309l0.364-0.408l0.021-0.546l0.506-13.151l0.014-0.36l-0.149-0.328l-2.298-5.047l4.341,4.873l1.026,11.969 l0.155,1.808l1.751-0.472l14.954-4.028l0.55-0.148l0.316-0.473l9.433-14.088l0.193-0.289l0.048-0.344l1.687-11.973l0.088-0.622 l-0.377-0.501L142.097,48.808 M133.397,39.76l9.741,12.958l-1.687,11.972l-9.433,14.088l-14.954,4.028l-1.069-12.472 l-11.342-12.73l6.449,14.167l-0.506,13.151l-14.37,16.052l4.984,10.791c0.128-0.336,13.626-19.209,13.626-19.209l17.71-7.421 l12.395,0.476l11.144,6.343c0,0-9.505-9.753-9.695-9.839c-0.189-0.085-7.626-2.238-7.626-2.238l9.682-14.323l-1.3-14.588 L133.397,39.76L133.397,39.76z"/>
	<polyline fill="none" stroke="#FFFFFF" stroke-width="1.5175" stroke-miterlimit="10" points="111.229,85.091 116.498,83.89 114.389,92.004"/>
	<line fill="none" stroke="#FFFFFF" stroke-width="1.5175" stroke-miterlimit="10" x1="115.127" y1="70.738" x2="111.713" y2="71.813"/>
	<line fill="none" stroke="#FFFFFF" stroke-width="1.5175" stroke-miterlimit="10" x1="137.573" y1="80.349" x2="132.357" y2="84.427"/>	
	<line fill="none" stroke="#FFFFFF" stroke-width="1.5175" stroke-miterlimit="10" x1="137.984" y1="80.349" x2="132.357" y2="79.495"/>		
	<line fill="none" stroke="#FFFFFF" stroke-width="1.5175" stroke-miterlimit="10" x1="147.605" y1="65.483" x2="142.042" y2="65.02"/>		
	<line fill="none" stroke="#FFFFFF" stroke-width="1.5175" stroke-miterlimit="10" x1="146.467" y1="51.438" x2="143.727" y2="52.66"/>		
	<line fill="none" stroke="#FFFFFF" stroke-width="1.5175" stroke-miterlimit="10" x1="80.212" y1="116.516" x2="95.26" y2="132.196"/>		
	<line fill="none" stroke="#FFFFFF" stroke-width="1.5175" stroke-miterlimit="10" x1="100.476" y1="116.516" x2="85.427" y2="132.196"/>
</svg>
```

#### Demo:

<style>
.exampleSvg__inline { text-align: center; }
</style>

<div class="demoBox exampleSvg__inline">
<svg version="1.1" xmlns="http://www.w3.org/2000/svg" xmlns:xlink="http://www.w3.org/1999/xlink" x="0px" y="0px" width="180px" height="180px" viewBox="0 0 180 180" enable-background="new 0 0 180 180" xml:space="preserve"><g><circle fill="#000000" cx="90.304" cy="90" r="80.749"></circle></g><g><g><g><path fill="#FFFFFF" d="M93.439,102.826l6.172,13.444l-5.177,15.468l-0.037,0.111l-0.02,0.115l-2.148,12.578h-3.685l-2.158-12.59 l-0.02-0.115l-0.037-0.11l-5.178-15.456l6.172-13.444H93.439 M94.412,101.309h-8.062l-6.828,14.875l5.368,16.025l2.374,13.852 h6.245l2.364-13.84l5.367-16.037L94.412,101.309L94.412,101.309z"></path></g><g><path fill="#FFFFFF" d="M38.511,48.808l-2.254,2.999l-0.377,0.501l0.088,0.622l1.686,11.972l0.048,0.344l0.193,0.289 l9.434,14.088l0.316,0.473l0.55,0.148l14.953,4.028l1.751,0.472l0.155-1.808l1.026-11.969l4.341-4.873l-2.298,5.048l-0.149,0.328 l0.014,0.36l0.506,13.151l0.021,0.546l0.364,0.408l13.704,15.309l-3.451,7.473c-1.689-2.412-5.119-7.242-12.128-17.043 l-0.25-0.35l-0.397-0.167l-17.71-7.421l-0.31-0.13l-0.335,0.013l-12.395,0.476l-0.371,0.015l-0.322,0.183l-1.729,0.984 c0.84-0.851,1.491-1.505,1.811-1.817c1.065-0.323,4.853-1.425,7.267-2.125l2.003-0.58L43.1,79.027l-9.38-13.876l1.195-13.414 L38.511,48.808 M47.21,39.76l-13.75,11.206l-1.3,14.588l9.682,14.323c0,0-7.437,2.153-7.626,2.238 c-0.189,0.086-9.694,9.839-9.694,9.839l11.144-6.343l12.395-0.476l17.71,7.421c0,0,13.498,18.873,13.625,19.209l4.984-10.791 L70.011,84.923l-0.506-13.151l6.448-14.167l-11.342,12.73l-1.069,12.472l-14.953-4.028L39.156,64.69L37.47,52.718L47.21,39.76 L47.21,39.76z"></path></g><polyline fill="none" stroke="#FFFFFF" stroke-width="1.5175" stroke-miterlimit="10" points="69.379,85.091 64.11,83.89 66.218,92.004"></polyline><line fill="none" stroke="#FFFFFF" stroke-width="1.5175" stroke-miterlimit="10" x1="65.48" y1="70.738" x2="68.894" y2="71.813"></line><line fill="none" stroke="#FFFFFF" stroke-width="1.5175" stroke-miterlimit="10" x1="43.034" y1="80.349" x2="48.25" y2="84.427"></line><line fill="none" stroke="#FFFFFF" stroke-width="1.5175" stroke-miterlimit="10" x1="42.623" y1="80.349" x2="48.25" y2="79.495"></line><line fill="none" stroke="#FFFFFF" stroke-width="1.5175" stroke-miterlimit="10" x1="33.002" y1="65.483" x2="38.565" y2="65.02"></line><line fill="none" stroke="#FFFFFF" stroke-width="1.5175" stroke-miterlimit="10" x1="34.14" y1="51.438" x2="36.88" y2="52.66"></line><g><path fill="#FFFFFF" d="M142.097,48.808l3.595,2.93l1.195,13.414l-9.38,13.876l-1.167,1.728l2.003,0.58 c2.414,0.699,6.202,1.801,7.267,2.125c0.32,0.312,0.971,0.966,1.811,1.817l-1.729-0.984l-0.322-0.183L145,84.095l-12.395-0.476 l-0.335-0.013l-0.31,0.13l-17.71,7.421l-0.397,0.167l-0.25,0.35c-7.01,9.802-10.439,14.632-12.128,17.043l-3.451-7.473 l13.705-15.309l0.364-0.408l0.021-0.546l0.506-13.151l0.014-0.36l-0.149-0.328l-2.298-5.047l4.341,4.873l1.026,11.969 l0.155,1.808l1.751-0.472l14.954-4.028l0.55-0.148l0.316-0.473l9.433-14.088l0.193-0.289l0.048-0.344l1.687-11.973l0.088-0.622 l-0.377-0.501L142.097,48.808 M133.397,39.76l9.741,12.958l-1.687,11.972l-9.433,14.088l-14.954,4.028l-1.069-12.472 l-11.342-12.73l6.449,14.167l-0.506,13.151l-14.37,16.052l4.984,10.791c0.128-0.336,13.626-19.209,13.626-19.209l17.71-7.421 l12.395,0.476l11.144,6.343c0,0-9.505-9.753-9.695-9.839c-0.189-0.085-7.626-2.238-7.626-2.238l9.682-14.323l-1.3-14.588 L133.397,39.76L133.397,39.76z"></path></g><polyline fill="none" stroke="#FFFFFF" stroke-width="1.5175" stroke-miterlimit="10" points="111.229,85.091 116.498,83.89 114.389,92.004"></polyline><line fill="none" stroke="#FFFFFF" stroke-width="1.5175" stroke-miterlimit="10" x1="115.127" y1="70.738" x2="111.713" y2="71.813"></line><line fill="none" stroke="#FFFFFF" stroke-width="1.5175" stroke-miterlimit="10" x1="137.573" y1="80.349" x2="132.357" y2="84.427"></line><line fill="none" stroke="#FFFFFF" stroke-width="1.5175" stroke-miterlimit="10" x1="137.984" y1="80.349" x2="132.357" y2="79.495"></line><line fill="none" stroke="#FFFFFF" stroke-width="1.5175" stroke-miterlimit="10" x1="147.605" y1="65.483" x2="142.042" y2="65.02"></line><line fill="none" stroke="#FFFFFF" stroke-width="1.5175" stroke-miterlimit="10" x1="146.467" y1="51.438" x2="143.727" y2="52.66"></line><line fill="none" stroke="#FFFFFF" stroke-width="1.5175" stroke-miterlimit="10" x1="80.212" y1="116.516" x2="95.26" y2="132.196"></line><line fill="none" stroke="#FFFFFF" stroke-width="1.5175" stroke-miterlimit="10" x1="100.476" y1="116.516" x2="85.427" y2="132.196"></line></g></g></svg>
</div>

## SVG Pros

- No need for separate versions for high density displays

- No need for different responsive versions

- Small file size, since they are XML, gzipping works really well to compress files on the server

- Embedded versions can be manipulated/animated with CSS and JavaScript

* * *

## SVG Cons

- Not suitable for photos and images with lots of pixel information

- Inline SVGs are difficult to cache

- Inline SVGs may make code a little messy

* * *

## Recommended Methods

#### The <object> Embedding Method

Overall, I would recommend using SVGs by embedding them with the `<object>` tag. This allows you to keep your SVG code, clean, separated, and organized. It also allows you to manipulate your SVG code with CSS and JavaScript.

#### The CSS Background Image Method

Sometimes the `<object>` embedding method will not be appropriate like when you need to apply your SVG as a background-image on a container. It is also perfectly acceptable to use them as CSS backgrounds, but just like using other image formats you will still want to pay attention to your http requests and consider using SVG sprites where appropriate. Also, the thing to remember when using SVG backgrounds is that you will not be able to manipulate and animate their paths and elements like you can using embedded methods.

* * *

## Browser Support

<div class="browserSupport__list">
	<img src="../../assets/img/ie.svg" alt="ie9 and above" title="ie9 and above">
	<img src="../../assets/img/chrome.svg" alt="Chrome 29 and above" title="Chrome 29 and above">
	<img src="../../assets/img/firefox.svg" alt="Fire Fox 24 and above" title="Fire Fox 24 and above">
	<img src="../../assets/img/safari.svg" alt="Safari 5.1 and above" title="Safari 5.1 and above">
</div>

SVGs have good browser support working in all modern browsers. Not supported in Internet Explorer 8 and below.

* * *

## Sources

- [http://caniuse.com/](http://caniuse.com/)

- [http://www.sitepoint.com/add-svg-to-web-page/](http://www.sitepoint.com/add-svg-to-web-page/)

- [http://css-tricks.com/using-svg/](http://css-tricks.com/using-svg/)

- [http://www.w3schools.com/html/html5\_svg.asp](http://www.w3schools.com/html/html5_svg.asp)

- [https://developer.mozilla.org/en-US/docs/SVG\_In\_HTML\_Introduction](https://developer.mozilla.org/en-US/docs/SVG_In_HTML_Introduction)
