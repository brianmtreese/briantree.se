---
layout: post
title: "Understanding CSS Regions"
date: "2014-01-20"
categories: 
  - "css"
tags: 
  - "CSS"
  - "CSS Layout"
  - "JavaScript"
---

<p class="intro"><span class="dropcap">S</span>ome of my favorite parts of CSS3 are those concerning layout. So far I've explored <a href="/flexbox-modern-web-layouts-simplified/">Flexbox</a> and <a href="/all-you-need-to-know-about-css3-multiple-columns/">Columns</a>, but today I'm going to dig into CSS Regions.</p>

## What the Heck are They?

Understanding CSS regions is pretty simple really. Basically, they allow us to flow content through multiple containers on a page.

Usually we are stuck with one containing element around our content like a <p> or a <div> or something similar. This wouldn't work if we are trying to achieve a layout similar to this:

<div>
    <img style="display: block;" src="../../assets/img/content/uploads/2014/Nylon-Layout-1024x611.jpg" alt="Understanding CSS Regions">
</div>

To create a layout like the design above without css regions we would have to use JavaScript or something to let the content regions know how to handle the content. With CSS Regions we simply let the containers know what's up and they handle the rest of the heavy lifting.

## Ok Cool, So How Do We Use it?

CSS Regions consist of only 2 properties and are easy to use. It doesn't have to be text only, many other HTML elements can be part of the flowed content.

### flow-into

This property identifies the container as a "CSS Region" element. It accepts an arbitrary value that you create. It then uses that value to determine the link between this container and its additional flow containers.

- `flow-into` — accepts an arbitrary value that you create

- `none` — disables the container as a "region"

### flow-from

This property identifies the container as a "CSS Region" element. It accepts an arbitrary value that you create but it must match that of another container with `flow-into` set. It then uses that value to retrieve the content.

- `flow-from` — accepts an arbitrary value that you create

- `none` — disables the container as a "region"

## Got an Example?

Well of course I do. The only problem is that, at the time of writing, the CSS Region spec is still a working draft. This means browser support is all over the place. It doesn't work in Firefox or Opera, ie10 must use an iframe tag, Chrome needs "enable-experimental-webkit-features" enabled, and Safari needs the "-webkit" prefix. So, unfortunately all of the browsers that I have available do not yet support this feature and it's likely that yours don't either. Sorry, it's just the times we're living in. I do, however, have an example of the code so that you can get an idea of how you would use it.

### The HTML

```html
<div class="example__region--content">
    Lorem ipsum dolor sit amet, consectetuer adipiscing elit. Aenean commodo ligula eget dolor. Aenean massa. Cum sociis natoque penatibus et magnis dis parturient montes, nascetur ridiculus mus. Donec quam felis, ultricies nec, pellentesque eu, pretium quis, sem. Nulla consequat massa quis enim. Donec pede justo, fringilla vel, aliquet nec, vulputate eget, arcu. In enim justo, rhoncus ut, imperdiet a, venenatis vitae, justo. Nullam dictum felis eu pede mollis pretium. Integer tincidunt. Cras dapibus. Vivamus elementum semper nisi. Aenean vulputate eleifend tellus. Aenean leo ligula, porttitor eu, consequat vitae, eleifend ac, enim. Aliquam lorem ante, dapibus in, viverra quis, feugiat a, tellus. Phasellus viverra nulla ut metus varius laoreet. Quisque rutrum. Aenean imperdiet. Etiam ultricies nisi vel augue. Curabitur ullamcorper ultricies nisi. Nam eget dui. Etiam rhoncus. Maecenas tempus, tellus eget condimentum rhoncus, sem quam semper libero, sit amet adipiscing sem neque sed ipsum. Nam quam nunc, blandit vel, luctus pulvinar, hendrerit id, lorem. Maecenas nec odio et ante tincidunt tempus. Donec vitae sapien ut libero venenatis faucibus. Nullam quis ante. Etiam sit amet orci eget eros faucibus tincidunt. Duis leo. Sed fringilla mauris sit amet nibh. Donec sodales sagittis magna. Sed consequat, leo eget bibendum sodales, augue velit cursus nunc
</div>
<div class="example__region--1">
    <h4>Hey, I'm the 1st Region!</h4>
    <p></p>
</div>
<div class="example__region--2">
    <h4>Hey, I'm the 2nd Region!</h4>
    <p></p>
</div>
```

### The CSS

```css
.example__region--content {
    -webkit-flow-into: flowed-content; /* For Safari */
    flow-into: flowed-content;
}

.example__region--1 p {
    -webkit-flow-from: flowed-content; /* For Safari */
    flow-from: flowed-content;
    height: 100px;
}

.example__region--2 p {
    -webkit-flow-from: flowed-content; /* For Safari */
    flow-from: flowed-content;
}
```

## Browsers That Don't Support CSS Regions

If you would like to start using CSS Regions today you can do so using a [polyfill](http://adobe-webplatform.github.io/css-regions-polyfill/) provided by Adobe. You simply include the JavaScript file in your site and the use an "-adobe-" prefix. If your browser supports CSS Regions the polyfill won't run so you'll need to make sure to include the un-prefixed version as well.

* * *

## Browser Support

<div class="browserSupport__list">
<img src="../../assets/img/ie.svg" alt="ie10 and above" title="ie10 and above">
<img src="../../assets/img/safari.svg" alt="Safari 7 and above using -webkit- prefix" title="Safari 7 and above using -webkit- prefix">
</div>

Browser support is nearly non-existent so far so it will probably be a little while before we can take advantage of CSS Regions.

* * *

## Sources

- [http://caniuse.com/](http://caniuse.com/)

- [http://coding.smashingmagazine.com/2013/11/05/killer-responsive-layouts-with-css-regions](http://coding.smashingmagazine.com/2013/11/05/killer-responsive-layouts-with-css-regions/)

- [http://www.webdesignerdepot.com/2013/09/introducing-css-regions](http://www.webdesignerdepot.com/2013/09/introducing-css-regions/)
