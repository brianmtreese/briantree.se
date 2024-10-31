---
layout: post
title: "Getting Modular With Web Components"
date: "2014-03-10"
tags: 
  - "CSS"
  - "HTML5"
  - "JavaScript"
  - "Web Components"
---

<p class="intro"><span class="dropcap">M</span>odular is the new black when speaking in terms of the web. From the back-end perspective, developers have been building modular, object-oriented code for a long time now. Well, as web technologies and our development processes continue to improve, more and more of these back-end, programmatic philosophies are finding their way into front-end development.</p>

The first real evidence of this was when CSS preprocessors like [Less](http://lesscss.org/) and [Sass](http://sass-lang.com/) started popping up and gaining popularity. They do a lot of really cool stuff, but at their core they allow us to apply more of a programmatic approach to our CSS.

Then we had stuff like [SMACSS](http://smacss.com/) and [Object-Oriented CSS](http://oocss.org/) entering into the discussion. These methodologies are an attempt to organize and modularize our front-end code much like we do our back-end code. Now frameworks like [Bootstrap](http://getbootstrap.com/) and [Foundation](http://foundation.zurb.com/) have become a solid starting point for front-end development combining both preprocessing and SMACSS/OOCSS principles. We also have things like [pattern libraries](http://boagworld.com/design/pattern-library/) becoming all the rage. They are showcases of these modules in action built to encourage consistency, re-use of common element styles, and make front-end code easier for us to maintain.

## What are Web Components?

The newest tool on our modular front-end toolbox are Web Components. Gaining some real steam, many developers see them as our future. They are a new HTML5 standard to build reusable components for the web. They contain a set of custom elements, JavaScript, and styles unique to a specific component. A component can consist of anything as simple as a single button, input, or select to something as complex as a complete application. Web Components consist of the following:

### Templates

The template element contains all of the mark up that will be used within a component. All code within the template will be parsed by the browser but not rendered until it is called elsewhere by JavaScript. This means that all external assets will not be loaded and all script tags won't be processed by the browser until we want them to be.

```html
<template>
    <div id="contentElement"></div>
</template>
<script>
    var t = document.querySelector('#contentElement');
    var contentElement = t.content.cloneNode(true);
    contentElement.innerHTML = 'This content will be inserted #contentElement';
    document.body.appendChild(contentElement);
</script>
```

[Click here](http://codepen.io/zinas/pen/aBcGy) to see a nice example by front-end developer [Nikos Zinas](http://www.prevent-default.com/)

### Decorators

Decorators are not actually in the specification yet but they are intended to describe the presentation of Web Components.

```html
<decorator id="items">
    <template>
        <style>
            .itemContent {
                padding: 10px;
            }
        </style>
        <div class="itemContent">
            <content></content>
        </div>
    </template>
</decorator>
```

The content element is required and is where the element's children will get inserted.

There is a special decorator property that is used to apply styles via CSS.

```css
.itemContainer {
    decorator: url(#items);
    background-color: red;
}
```

You would then add some html to the page that would call this template

```html
<div class="itemContainer">
    This content will use the decorator 
</div>
```

Then, when the decorator is applied, the rendered mark up will look like this

```html
<div class="itemContainer" style="background-color: red;">
    <div style="padding: 10px;">    
        This content will use the decorator
    </div> 
</div>
```

Decorators can do some other neat stuff, you can find out more [here](https://dvcs.w3.org/hg/webcomponents/raw-file/57f8cfc4a7dc/explainer/index.html).

### Custom Elements

Custom elements are exactly what you would think they are. They are new DOM or HTML elements that we create to make more sense for our code. Currently, most applications use a ton of div tags to do build out structure.

#### With the use of Custom Elements, this:

```html
<div class="commentStream">
    <div class="commentStream__item">
        <div class="commentStream__avatar">
            <img src="/avatar.jpg" alt="My Avatar" />
        </div>
        <div class="commentStream__message">
            Yo, this is my message, what do you think?
        </div>
    </div>
</div>
```

#### Becomes this:

```html
<commentstream-module>
    <commentstream-item>
        <commentstream-avatar>
            <img src="/avatar.jpg" alt="My Avatar" />
        </commentstream-avatar>
        <commentstream-message>
            Yo, this is my message, what do you think?
        </commentstream-message>
    </commentstream-item>
</commentstream-module>
```

Similarly to how the HTML5 shim creates DOM/HTML elements for the new HTML5 tags in older browsers that don't support them, Custom Elements have to be instantiated with JavaScript as well.

They can also be created to extend other elements that already exist like buttons for example. You can then define new public properties and methods for button elements and then use your new tag where you need it.

You can get a more in-depth overview of what's possible with Custom Elements [here](http://www.html5rocks.com/en/tutorials/webcomponents/customelements/).

### Shadow DOM

The Shadow DOM is very similar to the contents loaded within and iframe. They are sub tree nodes that form their own scope so that they are not affected by outside code. The Shadow DOM is separate from the HTML document so ids and styles will not interfere with those from the document. The Shadow DOM can be applied to any element using createShadowRoot().

With Shadow DOM this div:

```html
<div id="content"></div>
```

Will get its own encapsulated Shadow DOM tree because of this code here:

```javascript
var shadowHost = document.querySelector("#content");
var shadowRoot = shadowHost.createShadowRoot();
shadowRoot.textContent = "This is my content";
```

Many HTML5 elements like video and audio tags already have their own Shadow DOM and you can see it by enabling Shadow DOM in the Chrome developer tools. You can do this by bringing up the dev tools(F12), clicking on the gear icon, and then enabling "Show Shadow DOM". Then you can inspect any ol' HTML5 audio or video tag and see its Shadow DOM.

### Imports

Imports allow you to load external files for decorators and elements as you would an external style sheet or JavaScript file

```html
<link rel="import" href="module.html">
```

## Polyfills

As I mentioned earlier, Web Components are still in the working draft phase so browser support is pretty spotty. Chrome and Fire Fox seem to support most of the spec. Google and Mozilla seem to really believe that Web Components are the future and both have created polyfills allowing us to start using this technology right now.

For more information, take a look at Google's [Polymer](http://www.polymer-project.org/) and Mozilla's [x-tag](http://www.x-tags.org/) projects.

* * *

## Browser Support - Templates

<div class="browserSupport__list">
<img src="../../assets/img/chrome.svg" alt="Chrome 31 and above" title="Chrome 31 and above">
<img src="../../assets/img/firefox.svg" alt="Fire Fox 29 and above" title="Fire Fox 29 and above">
</div>

Web Components Templates don't have the best browser support working only in Chrome and Fire Fox.

* * *

## Browser Support - Shadow DOM

<div class="browserSupport__list">
<img src="../../assets/img/chrome.svg" alt="Chrome 31 and above" title="Chrome 31 and above">
<img src="../../assets/img/firefox.svg" alt="Fire Fox 29 and above" title="Fire Fox 29 and above">
</div>

Web Components Shadow DOM doesn't have the best browser support working only in Chrome and Fire Fox.

* * *

## Sources

- [http://caniuse.com/#search=web%20components](http://caniuse.com/#search=web%20components)

- [http://www.w3.org/TR/components-intro](http://www.w3.org/TR/components-intro/)

- [http://www.infoq.com/news/2013/05/webcomponents](http://www.infoq.com/news/2013/05/webcomponents)

- [http://www.html5rocks.com/en/tutorials/webcomponents/customelements](http://www.html5rocks.com/en/tutorials/webcomponents/customelements/)

- [http://css-tricks.com/modular-future-web-components](http://css-tricks.com/modular-future-web-components/)

- [http://www.prevent-default.com/templates-nextgen-markup-pt-1](http://www.prevent-default.com/templates-nextgen-markup-pt-1/)

- [http://code.tutsplus.com/tutorials/intro-to-shadow-dom--net-34966](http://code.tutsplus.com/tutorials/intro-to-shadow-dom--net-34966)
