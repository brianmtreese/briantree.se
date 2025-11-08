---
layout: post
title: "Oh Wow That’s Neat – 12: SVG Optimiser"
date: "2014-03-25"
tags:
  - "CSS"
  - "HTML"
  - "JavaScript"
  - "SVG"
---

<p class="intro"><span class="dropcap">I</span>f you've ever created an SVG image in Adobe Illustrator you've seen some pretty crazy code. Just like all other code we write, it should be simple, clean, and lean. Also, like any other image type we want to make sure that it is optimized and has the highest quality with the smallest file size.</p>

With SVG files some of the code is easy to tell if it's needed or not but some is not so clear. It can take a decent amount of time to manually parse this code to optimize it by hand. Wouldn't it be great if there was a tool available that allowed us to pass our image to it and have it optimized automatically? Oh wait there is. Thanks to [Peter Collingridge](http://www.petercollingridge.co.uk/) a freelance content creator for [Khan Academy](https://www.khanacademy.org/). He has created an [svg optimiser](http://petercollingridge.appspot.com/svg-optimiser) tool that will simplify decimals, apply transformations, remove unnecessary attributes, remove unnecessary namespaces, remove unnecessary whitespace, and convert element styles to CSS which all will substantially reduce the size of your SVG assets.

I ran my own logo through the [svg optimiser](http://petercollingridge.appspot.com/svg-optimiser) and reduced it's file size by 11.6%. It's easy too, all you do is choose your SVG image, hit the upload button, choose a couple of options and your done. You can even compare your old image to the new image to see if there are any differences.

[Peter](http://www.petercollingridge.co.uk/) also provides a [JavaScript version](http://petercollingridge.appspot.com/svg-editor/) that lets you upload an image and then toggle the different settings real time to see how they affect the image.

## More Information

Give the SVG optimizer tool a try [here](http://www.petercollingridge.co.uk/) or try the JavaScript version [here](http://petercollingridge.appspot.com/svg-editor/).
