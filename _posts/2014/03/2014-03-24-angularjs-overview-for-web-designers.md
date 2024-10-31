---
layout: post
title: "AngularJS Overview for Web Designers"
date: "2014-03-24"
tags: 
  - "Angular"
  - "Animation"
  - "CSS"
  - "CSS Transforms"
  - "HTML"
  - "JavaScript"
---

<p class="intro"><span class="dropcap">A</span>ngularJS is a newer JavaScript framework geared towards the creation and maintenance of single page web applications. It is considered to be a “toolset for building the framework most suited to your application development” meaning that, for the most part, you can choose the elements that you want to use and swap out those that you don’t want with other libraries/frameworks of your choice. It is built and maintained by Google and is open source with an MIT license.</p>

Angular is written in pure JavaScript and is based on the [model–view–controller (MVC)](http://en.wikipedia.org/wiki/Model%E2%80%93view%E2%80%93controller) pattern making applications using it easier to develop and test. Angular uses two-way data-binding to synchronize the data between models and views.

For designers, besides working with HTML and CSS like we are used to and adjusting to working in an MVC pattern, we will likely be most interested in Angular directives and animations.

## Directives

Angular contains components called **Directives** which are essentially “markers” on DOM elements like attributes, element names, or html classes. Angular will traverse the DOM and match these directives to attach specific behavior and/or transform the markup of itself and its children. They have no restrictions and can be added to any element in the DOM. **ng-app** is the most important directive because it bootstraps the application and runs Angular. It's usually applied to the HTML tag or a div tag that wraps the page content.

```html
<div ng-app>
    This is the Angular application content 
</div>
```

When using directives they can be written in two different ways using a dash (ng-model) or using a colon (data-ng:model). It is recommended to use a dash instead of colon because you can use "data-ng-model” to validate HTML in a validation tool.

You can use any from the set of built in directives or create your own custom directives if needed.

## Directives Designers Will Use

There are quite a few directives that Angular provides out of the box but not all will be used by designers on a regular basis. I've chosen to sift through and find the ones that I'd use the most but you can find the whole list [here](http://docs.angularjs.org/api/ng#directive).

### ng-disabled

If true then the “disabled” attribute will be set on the element - [Learn More]( http://docs.angularjs.org/api/ng/directive/ngDisabled)

### ng-checked

If true then the “checked” attribute will be set on the element - [Learn More](http://docs.angularjs.org/api/ng/directive/ngChecked)

### ng-readonly

If true then the “readonly” attribute will be set on the element - [Learn More](http://docs.angularjs.org/api/ng/directive/ngReadonly)

### ng-selected

If true then the “selected” attribute will be set on the element - [Learn More](http://docs.angularjs.org/api/ng/directive/ngSelected)

### ng-class

Allows you to dynamically set html classes on elements - [Learn More](http://docs.angularjs.org/api/ng/directive/ngClass)

### ng-class-odd

Allows you to dynamically set html classes on odd elements - [Learn More](http://docs.angularjs.org/api/ng/directive/ngClassOdd)

### ng-class-even

Allows you to dynamically set html classes on even elements - [Learn More](http://docs.angularjs.org/api/ng/directive/ngClassEven)

### ng-cloak

Prevents the raw markup from displaying while your application is loading before AngularJS has had a chance to run and compile the html - [Learn More](http://docs.angularjs.org/api/ng/directive/ngCloak)

### ng-click

An event that allows you to attach behavior when an element has been clicked - [Learn More](http://docs.angularjs.org/api/ng/directive/ngClick)

### ng-dblclick

An event that allows you to attach behavior when an element has been double clicked - [Learn More](http://docs.angularjs.org/api/ng/directive/ngDblclick)

### ng-mousedown

An event that allows you to attach behavior on mouse down - [Learn More](http://docs.angularjs.org/api/ng/directive/ngMousedown)

### ng-mouseup

An event that allows you to attach behavior on mouse up - [Learn More](http://docs.angularjs.org/api/ng/directive/ngMouseup)

### ng-mouseover

An event that allows you to attach behavior on mouse over - [Learn More](http://docs.angularjs.org/api/ng/directive/ngMouseover)

### ng-mouseenter

An event that allows you to attach behavior on mouse enter - [Learn More](http://docs.angularjs.org/api/ng/directive/ngMouseenter)

### ng-mouseleave

An event that allows you to attach behavior on mouse leave - [Learn More](http://docs.angularjs.org/api/ng/directive/ngMouseleave)

### ng-mousemove

An event that allows you to attach behavior on mouse move - [Learn More](http://docs.angularjs.org/api/ng/directive/ngMousemove)

### ng-keydown

An event that allows you to attach behavior on key down - [Learn More](http://docs.angularjs.org/api/ng/directive/ngKeydown)

### ng-keyup

An event that allows you to attach behavior on key up - [Learn More](http://docs.angularjs.org/api/ng/directive/ngKeyup)

### ng-keypress

An event that allows you to attach behavior on key press - [Learn More](http://docs.angularjs.org/api/ng/directive/ngKeypress)

### ng-focus

An event that allows you to attach behavior on an element when focused - [Learn More](http://docs.angularjs.org/api/ng/directive/ngFocus)

### ng-blur

An event that allows you to attach behavior on an element when it has lost focus - [Learn More](http://docs.angularjs.org/api/ng/directive/ngBlur)

### ng-copy

An event that allows you to attach behavior when copying - [Learn More](http://docs.angularjs.org/api/ng/directive/ngCopy)

### ng-cut

An event that allows you to attach behavior when cutting - [Learn More](http://docs.angularjs.org/api/ng/directive/ngCut)

### ng-paste

An event that allows you to attach behavior when pasting - [Learn More](http://docs.angularjs.org/api/ng/directive/ngPaste)

### ng-show

An event that allows you to show html based on the evaluation of an expression - [Learn More](http://docs.angularjs.org/api/ng/directive/ngShow)

### ng-hide

An event that allows you to hide html based on the evaluation of an expression - [Learn More](http://docs.angularjs.org/api/ng/directive/ngHide)

### ng-style

Allows you to conditionally set CSS on an element - [Learn More](http://docs.angularjs.org/api/ng/directive/ngStyle)

* * *

## Animations

Angular provides animation hooks for certain directives that trigger CSS Transition animations, CSS Keyframe animations, or JavaScript Callback animations. Angular also includes animation detection support for custom animations when performing operations on DOM elements.

Angular animations are triggered on certain events like enter, leave, move, and class change. These animations are based completely on HTML classes and can be applied to any element with a class on it. These animations are also based on convention ng-(event) and ng-(event)-active.

```css
.my-item.ng-enter {
    transition: height 0.5s;
}

.my-item.ng-enter.ng-enter-active {
    background-color: red;
}
```

JavaScript can be used to perform animations if you wish and these animations will use jQuery. However, It's probably best not to use JavaScript if it can be avoided since it will likely add more code than necessary and can hinder performance to some degree.

If you want your animations tied to something other than one of the events enter, leave, or move, you can add them on add or remove of HTML classes. Angular will only recognize class changes if an expression or the ng-class directive is used.

```html
<input type="button" value="set" ng-click="sizeVar='size-large'">
<input type="button" value="clear" ng-click="sizeVar='size-small'">
<div>
  <span ng-class="sizeVar">Animation Happens Here</span>
</div>
```

## Directives With Animation Support

Not all of the out of the box directives support animations so below I've included the ones that do and the events that they have to trigger animations.

### ng-repeat

Supported Events - enter, leave, and move

### ng-view

Supported Events - enter and leave

### ng-include

Supported Events - enter and leave

### ng-switch

Supported Events - enter and leave

### ng-if

Supported Events - enter and leave

### ng-class

Supported Events - add and remove

### ng-show

Supported Events - add and remove of the ng-hide class value

### ng-hide

Supported Events - add and remove of the ng-hide class value

* * *

## Animation Examples

To get more info and see real examples of animations in Angular [check this out](http://www.nganimate.org/).

* * *

## In Conclusion

From what I have read AngularJS is meant "to enable web-designers (non-programmers) to build simple app like websites" which looks to be possible but so far everything surrounding it like documentation, examples, tutorials, etc. seem to be very developer oriented. It can certainly do some cool stuff and I hope this article helps some of my fellow web designers begin to see how they can use it.

In theory it appears as though there is a lot of power in Angular but I've yet to use it on a project as of the time of writing. I guess you will just have to check back in a few months to see how it goes.

* * *

## Browser Support

<div class="browserSupport__list">
<img src="../../assets/img/ie.svg" alt="ie8 and above" title="ie8 and above">
<img src="../../assets/img/chrome.svg" alt="Chrome" title="Chrome"><img src="../../assets/img/firefox.svg" alt="Fire Fox" title="Fire Fox">
<img src="../../assets/img/safari.svg" alt="Safari" title="Safari">
</div>

Browser support for AngularJS is pretty good. If using version 1.2 it will work in ie7 and above. If using version 1.3 it will work in ie8 and above. I couldn't find any info as to whether or not Angular supports Opera but my guess is that it does.

* * *

## Sources

- [http://docs.angularjs.org/guide/directive](http://docs.angularjs.org/guide/directive)

- [http://docs.angularjs.org/api/ng#directive](http://docs.angularjs.org/api/ng#directive)

- [http://docs.angularjs.org/guide/animations](http://docs.angularjs.org/guide/animations)

- [http://docs.angularjs.org/api/ngAnimate/service/$animate](http://docs.angularjs.org/api/ngAnimate/service/$animate)

- [http://www.divshot.com/blog/tips-and-tricks/angular-1-2-and-animate-css](http://www.divshot.com/blog/tips-and-tricks/angular-1-2-and-animate-css)

- [http://docs.angularjs.org/api/ngAnimate/service/$animate](http://docs.angularjs.org/api/ngAnimate/service/$animate)

- [http://en.wikipedia.org/wiki/AngularJS](http://en.wikipedia.org/wiki/AngularJS)
