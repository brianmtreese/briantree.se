---
layout: post
title: "Pseudo-Classes vs. Pseudo-Elements"
date: "2014-03-03"
tags: 
  - "CSS"
  - "Pseudo Elements"
---

<p class="intro"><span class="dropcap">F</span>or the longest time the only pseudo selectors that we could use were <code>:link</code>, <code>:hover</code>, <code>:visited</code> and <code>:active</code> and they could only be applied to a tags. As long as we were intending to support ie6 that was all we could do. As we've adopted philosophies like <a href="http://en.wikipedia.org/wiki/Progressive_enhancement" target="_blank">progressive enhancement</a>, <a href="http://zurb.com/word/graceful-degradation" target="_blank">graceful degradation</a>, or dropped support for ie6, 7, and 8 we have seen the landscape of CSS selectors change dramatically.</p>

As I have began using more pseudo selectors I've found myself using the terms pseudo-classes and pseudo-elements interchangeably, which I've known to be wrong. In order to correct this I've decided to explore the differences between the two.

## Pseudo-Classes

A pseudo-class is a keyword that can be added to a selector based on a special state of the selected item. They are unique in that they can be actual elements in the DOM or they can be based on states that are triggered when certain actions occur such as `:hover`, `:visited`, `:checked`, etc.

### How They Are Used

```css
li {
    border-top: solid 1px gray;
}

li:first-child {
    border: none;
}
```

#### :active

Matches when an element is being activated by the user — [_Learn More_](https://developer.mozilla.org/en-US/docs/Web/CSS/:active)

<div class="browserSupport__list">
<img src="../../assets/img/ie.svg" alt="ie4 and above" title="ie4 and above">
<img src="../../assets/img/chrome.svg" alt="Chrome 1 and above" title="Chrome 1 and above">
<img src="../../assets/img/firefox.svg" alt="Fire Fox 1 and above" title="Fire Fox 1 and above">
<img src="../../assets/img/safari.svg" alt="Safari 1 and above" title="Safari 1 and above">
</div>

#### :checked

Represents any radio, checkbox, or option in a select element that is checked or toggled to an on state — [_Learn More_](https://developer.mozilla.org/en-US/docs/Web/CSS/:checked)

<div class="browserSupport__list">
<img src="../../assets/img/ie.svg" alt="ie9 and above" title="ie9 and above">
<img src="../../assets/img/chrome.svg" alt="Chrome 1 and above" title="Chrome 1 and above">
<img src="../../assets/img/firefox.svg" alt="Fire Fox 1 and above" title="Fire Fox 1 and above">
<img src="../../assets/img/safari.svg" alt="Safari 3.1 and above" title="Safari 3.1 and above">
</div>

#### :default

Represents any user interface element that is the default among a group of similar elements — [_Learn More_](https://developer.mozilla.org/en-US/docs/Web/CSS/:default)

<div class="browserSupport__list">
<img src="../../assets/img/chrome.svg" alt="Chrome 10 and above" title="Chrome 10 and above">
<img src="../../assets/img/firefox.svg" alt="Fire Fox 4 and above" title="Fire Fox 4 and above">
<img src="../../assets/img/safari.svg" alt="Safari 5 and above" title="Safari 5 and above">
</div>

#### :dir()

Matches elements based on the directionality of the text contained in it — [_Learn More_](https://developer.mozilla.org/en-US/docs/Web/CSS/:dir)

<div class="browserSupport__list">
<img src="../../assets/img/firefox.svg" alt="Fire Fox 4 and above" title="Fire Fox 4 and above">
</div>

#### :disabled

Represents any disabled element. An element is disabled if it can't be activated (e.g. selected, clicked on or accept text input) or accept focus — [_Learn More_](https://developer.mozilla.org/en-US/docs/Web/CSS/:disabled)

<div class="browserSupport__list">
<img src="../../assets/img/ie.svg" alt="ie9 and above" title="ie9 and above">
<img src="../../assets/img/chrome.svg" alt="Chrome 1 and above" title="Chrome 1 and above">
<img src="../../assets/img/firefox.svg" alt="Fire Fox 1 and above" title="Fire Fox 1 and above">
<img src="../../assets/img/safari.svg" alt="Safari 3.1 and above" title="Safari 3.1 and above">
</div>

#### :empty

Represents any element that has no children at all. Only element nodes and text (including whitespace) are considered — [_Learn More_](https://developer.mozilla.org/en-US/docs/Web/CSS/:empty)

<div class="browserSupport__list">
<img src="../../assets/img/ie.svg" alt="ie9 and above" title="ie9 and above">
<img src="../../assets/img/chrome.svg" alt="Chrome 1 and above" title="Chrome 1 and above">
<img src="../../assets/img/firefox.svg" alt="Fire Fox 1 and above" title="Fire Fox 1 and above">
<img src="../../assets/img/safari.svg" alt="Safari 3.1 and above" title="Safari 3.1 and above">
</div>

#### :enabled

Represents any enabled element. An element is enabled if it can be activated (e.g. selected, clicked on or accept text input) or accept focus — [_Learn More_](https://developer.mozilla.org/en-US/docs/Web/CSS/:enabled)

<div class="browserSupport__list">
<img src="../../assets/img/ie.svg" alt="ie9 and above" title="ie9 and above">
<img src="../../assets/img/chrome.svg" alt="Chrome 1 and above" title="Chrome 1 and above">
<img src="../../assets/img/firefox.svg" alt="Fire Fox 1 and above" title="Fire Fox 1 and above">
<img src="../../assets/img/safari.svg" alt="Safari 3.1 and above" title="Safari 3.1 and above">
</div>

#### :first

Describes the styling of the first page when printing a document — [_Learn More_](https://developer.mozilla.org/en-US/docs/Web/CSS/:first)

<div class="browserSupport__list">
<img src="../../assets/img/ie.svg" alt="ie8 and above" title="ie8 and above">
</div>

#### :first-child

Represents any element that is the first child element of its parent — [_Learn More_](https://developer.mozilla.org/en-US/docs/Web/CSS/:first-child)

<div class="browserSupport__list">
<img src="../../assets/img/ie.svg" alt="ie7 and above" title="ie7 and above">
<img src="../../assets/img/chrome.svg" alt="Chrome 4 and above" title="Chrome 4 and above">
<img src="../../assets/img/firefox.svg" alt="Fire Fox 3 and above" title="Fire Fox 3 and above">
<img src="../../assets/img/safari.svg" alt="Safari 4 and above" title="Safari 4 and above">
</div>

#### :first-of-type

Represents the first sibling of its type in the list of children of its parent element — [_Learn More_](https://developer.mozilla.org/en-US/docs/Web/CSS/:first-of-type)

<div class="browserSupport__list">
<img src="../../assets/img/ie.svg" alt="ie9 and above" title="ie9 and above">
<img src="../../assets/img/chrome.svg" alt="Chrome 1 and above" title="Chrome 1 and above">
<img src="../../assets/img/firefox.svg" alt="Fire Fox 3.5 and above" title="Fire Fox 3.5 and above">
<img src="../../assets/img/safari.svg" alt="Safari 3.2 and above" title="Safari 3.2 and above">
</div>

#### :fullscreen

Applies to any element that's currently being displayed in full-screen mode — [_Learn More_](https://developer.mozilla.org/en-US/docs/Web/CSS/:fullscreen)

<div class="browserSupport__list">
<img src="../../assets/img/ie.svg" alt="ie11 and above" title="ie11 and above">
<img src="../../assets/img/chrome.svg" alt="Chrome 15 and above" title="Chrome 15 and above">
<img src="../../assets/img/firefox.svg" alt="Fire Fox 9 and above" title="Fire Fox 9 and above">
<img src="../../assets/img/safari.svg" alt="Safari 6 and above" title="Safari 6 and above">
</div>

#### :focus

Applied when a element has received focus, either from the user selecting it with the use of a keyboard or by activating with the mouse (e.g. a form input) — [_Learn More_](https://developer.mozilla.org/en-US/docs/Web/CSS/:focus)

<div class="browserSupport__list">
<img src="../../assets/img/ie.svg" alt="ie8 and above" title="ie8 and above">
<img src="../../assets/img/chrome.svg" alt="Chrome 1 and above" title="Chrome 1 and above">
<img src="../../assets/img/firefox.svg" alt="Fire Fox 1 and above" title="Fire Fox 1 and above">
<img src="../../assets/img/safari.svg" alt="Safari 1 and above" title="Safari 1 and above">
</div>

#### :hover

Matches when the user designates an element with a pointing device, but does not necessarily activate it — [_Learn More_](https://developer.mozilla.org/en-US/docs/Web/CSS/:hover)

<div class="browserSupport__list">
<img src="../../assets/img/ie.svg" alt="ie7 and above" title="ie7 and above">
<img src="../../assets/img/chrome.svg" alt="Chrome 0.2 and above" title="Chrome 0.2 and above">
<img src="../../assets/img/firefox.svg" alt="Fire Fox 1 and above" title="Fire Fox 1 and above">
<img src="../../assets/img/safari.svg" alt="Safari 2.0.4 and above" title="Safari 2.0.4 and above">
</div>

#### :indeterminate

Represents any input type=“checkbox” element whose indeterminate DOM property is set to true by JavaScript — [_Learn More_](https://developer.mozilla.org/en-US/docs/Web/CSS/:indeterminate)

<div class="browserSupport__list">
<img src="../../assets/img/ie.svg" alt="ie9 and above" title="ie9 and above">
<img src="../../assets/img/chrome.svg" alt="Chrome 6 and above" title="Chrome 6 and above">
<img src="../../assets/img/firefox.svg" alt="Fire Fox 3.6 and above" title="Fire Fox 3.6 and above">
<img src="../../assets/img/safari.svg" alt="Safari 3 and above" title="Safari 3 and above">
</div>

#### :invalid

Represents any input or form element whose content fails to validate according to the input's type setting — [_Learn More_](https://developer.mozilla.org/en-US/docs/Web/CSS/:invalid)

<div class="browserSupport__list">
<img src="../../assets/img/ie.svg" alt="ie10 and above" title="ie10 and above">
<img src="../../assets/img/chrome.svg" alt="Chrome 10 and above" title="Chrome 10 and above">
<img src="../../assets/img/firefox.svg" alt="Fire Fox 4 and above" title="Fire Fox 4 and above">
<img src="../../assets/img/safari.svg" alt="Safari 5 and above" title="Safari 5 and above">
</div>

#### :lang()

Matches elements based on the language the element is determined to be in — [_Learn More_](https://developer.mozilla.org/en-US/docs/Web/CSS/:lang)

<div class="browserSupport__list">
<img src="../../assets/img/ie.svg" alt="ie8 and above" title="ie8 and above">
<img src="../../assets/img/chrome.svg" alt="Chrome 1 and above" title="Chrome 1 and above">
<img src="../../assets/img/firefox.svg" alt="Fire Fox 1 and above" title="Fire Fox 1 and above">
<img src="../../assets/img/safari.svg" alt="Safari 3.1 and above" title="Safari 3.1 and above">
</div>

#### :last-child

Represents any element that is the last child element of its parent — [_Learn More_](https://developer.mozilla.org/en-US/docs/Web/CSS/:last-child)

<div class="browserSupport__list">
<img src="../../assets/img/ie.svg" alt="ie9 and above" title="ie9 and above">
<img src="../../assets/img/chrome.svg" alt="Chrome 1 and above" title="Chrome 1 and above">
<img src="../../assets/img/firefox.svg" alt="Fire Fox 1 and above" title="Fire Fox 1 and above">
<img src="../../assets/img/safari.svg" alt="Safari 3.2 and above" title="Safari 3.2 and above">
</div>

#### :last-of-type

Represents the last sibling of its type in the list of children of its parent element — [_Learn More_](https://developer.mozilla.org/en-US/docs/Web/CSS/:last-of-type)

<div class="browserSupport__list">
<img src="../../assets/img/ie.svg" alt="ie9 and above" title="ie9 and above">
<img src="../../assets/img/chrome.svg" alt="Chrome 1 and above" title="Chrome 1 and above">
<img src="../../assets/img/firefox.svg" alt="Fire Fox 3.5 and above" title="Fire Fox 3.5 and above">
<img src="../../assets/img/safari.svg" alt="Safari 3.2 and above" title="Safari 3.2 and above">
</div>

#### :left

Matches any left page when printing a page. It allows to describe the styling of left-side pages — [_Learn More_](https://developer.mozilla.org/en-US/docs/Web/CSS/:left)

<div class="browserSupport__list">
<img src="../../assets/img/ie.svg" alt="ie8 and above" title="ie8 and above">
</div>

#### :link

Lets you select links inside elements — [_Learn More_](https://developer.mozilla.org/en-US/docs/Web/CSS/:link)

<div class="browserSupport__list">
<img src="../../assets/img/safari.svg" alt="Safari 1 and above" title="Safari 1 and above">
</div>

#### :not()

A functional notation taking a simple selector as an argument. It matches an element that is not represented by the argument. Must not contain another negation selector, or any pseudo-elements — [_Learn More_](https://developer.mozilla.org/en-US/docs/Web/CSS/:not)

<div class="browserSupport__list">
<img src="../../assets/img/ie.svg" alt="ie9 and above" title="ie9 and above">
<img src="../../assets/img/chrome.svg" alt="Chrome 1 and above" title="Chrome 1 and above">
<img src="../../assets/img/firefox.svg" alt="Fire Fox 1 and above" title="Fire Fox 1 and above">
<img src="../../assets/img/safari.svg" alt="Safari 3.2 and above" title="Safari 3.2 and above">
</div>

#### :nth-child

Matches an element that has siblings before it in the document tree, for a given positive or zero value, and has a parent element — [_Learn More_](https://developer.mozilla.org/en-US/docs/Web/CSS/:nth-child)

<div class="browserSupport__list">
<img src="../../assets/img/ie.svg" alt="ie9 and above" title="ie9 and above">
<img src="../../assets/img/chrome.svg" alt="Chrome 1 and above" title="Chrome 1 and above">
<img src="../../assets/img/firefox.svg" alt="Fire Fox 1 and above" title="Fire Fox 1 and above">
<img src="../../assets/img/safari.svg" alt="Safari 3.1 and above" title="Safari 3.1 and above">
</div>

#### :nth-last-child

Matches elements that have siblings after them in the document tree, for a given positive or zero value, and have a parent element — [_Learn More_](https://developer.mozilla.org/en-US/docs/Web/CSS/:nth-last-child)

<div class="browserSupport__list">
<img src="../../assets/img/ie.svg" alt="ie9 and above" title="ie9 and above">
<img src="../../assets/img/chrome.svg" alt="Chrome 1 and above" title="Chrome 1 and above">
<img src="../../assets/img/firefox.svg" alt="Fire Fox 1 and above" title="Fire Fox 1 and above">
<img src="../../assets/img/safari.svg" alt="Safari 3.1 and above" title="Safari 3.1 and above">
</div>

#### :nth-last-of-type

Matches the last element that has siblings with the same element name after it in the document tree, for a given positive or zero value, and has a parent element — [_Learn More_](https://developer.mozilla.org/en-US/docs/Web/CSS/:nth-last-of-type)

<div class="browserSupport__list">
<img src="../../assets/img/ie.svg" alt="ie9 and above" title="ie9 and above">
<img src="../../assets/img/chrome.svg" alt="Chrome 4 and above" title="Chrome 4 and above">
<img src="../../assets/img/firefox.svg" alt="Fire Fox 3.5 and above" title="Fire Fox 3.5 and above">
<img src="../../assets/img/safari.svg" alt="Safari 3.2 and above" title="Safari 3.2 and above">
</div>

#### :nth-of-type

Matches an element that has siblings with the same element name before it in the document tree, for a given positive or zero value, and has a parent element — [_Learn More_](https://developer.mozilla.org/en-US/docs/Web/CSS/:nth-of-type)

<div class="browserSupport__list">
<img src="../../assets/img/ie.svg" alt="ie9 and above" title="ie9 and above">
<img src="../../assets/img/chrome.svg" alt="Chrome 1 and above" title="Chrome 1 and above">
<img src="../../assets/img/firefox.svg" alt="Fire Fox 3.5 and above" title="Fire Fox 3.5 and above">
<img src="../../assets/img/safari.svg" alt="Safari 3.1 and above" title="Safari 3.1 and above">
</div>

#### :only-child

Represents any element which is the only child of its parent — [_Learn More_](https://developer.mozilla.org/en-US/docs/Web/CSS/:only-child)

<div class="browserSupport__list">
<img src="../../assets/img/ie.svg" alt="ie9 and above" title="ie9 and above">
<img src="../../assets/img/chrome.svg" alt="Chrome 2 and above" title="Chrome 2 and above">
<img src="../../assets/img/firefox.svg" alt="Fire Fox 1.5 and above" title="Fire Fox 1.5 and above">
<img src="../../assets/img/safari.svg" alt="Safari 3.1 and above" title="Safari 3.1 and above">
</div>

#### :only-of-type

Represents any element that has no siblings of the given type — [_Learn More_](https://developer.mozilla.org/en-US/docs/Web/CSS/:only-of-type)

<div class="browserSupport__list">
<img src="../../assets/img/ie.svg" alt="ie9 and above" title="ie9 and above">
<img src="../../assets/img/chrome.svg" alt="Chrome 1 and above" title="Chrome 1 and above">
<img src="../../assets/img/firefox.svg" alt="Fire Fox 3.5 and above" title="Fire Fox 3.5 and above">
<img src="../../assets/img/safari.svg" alt="Safari 3.2 and above" title="Safari 3.2 and above">
</div>

#### :optional

Represents any input element that does not have the required attribute set on it — [_Learn More_](https://developer.mozilla.org/en-US/docs/Web/CSS/:optional)

<div class="browserSupport__list">
<img src="../../assets/img/ie.svg" alt="ie10 and above" title="ie10 and above">
<img src="../../assets/img/chrome.svg" alt="Chrome 10 and above" title="Chrome 10 and above">
<img src="../../assets/img/firefox.svg" alt="Fire Fox 4 and above" title="Fire Fox 4 and above">
<img src="../../assets/img/safari.svg" alt="Safari 5 and above" title="Safari 5 and above">
</div>

#### :read-write

Matches when an element is editable by user like text input element — [_Learn More_](https://developer.mozilla.org/en-US/docs/Web/CSS/:read-write)

<div class="browserSupport__list">
<img src="../../assets/img/ie.svg" alt="ie9 and above" title="ie9 and above">
<img src="../../assets/img/chrome.svg" alt="Supported in Chrome" title="Supported in Chrome">
<img src="../../assets/img/firefox.svg" alt="Supported in Fire Fox" title="Supported in Fire Fox">
<img src="../../assets/img/safari.svg" alt="Supported in Safari" title="Supported in Safari">
</div>

#### :required

Represents any input element that has the required attribute set on it — [_Learn More_](https://developer.mozilla.org/en-US/docs/Web/CSS/:required)

<div class="browserSupport__list">
<img src="../../assets/img/ie.svg" alt="ie10 and above" title="ie10 and above">
<img src="../../assets/img/chrome.svg" alt="Chrome 10 and above" title="Chrome 10 and above">
<img src="../../assets/img/firefox.svg" alt="Fire Fox 4 and above" title="Fire Fox 4 and above">
<img src="../../assets/img/safari.svg" alt="Safari 5 and above" title="Safari 5 and above">
</div>

#### :right

Matches any right page when printing a page. It allows to describe the styling of right-side page — [_Learn More_](https://developer.mozilla.org/en-US/docs/Web/CSS/:right)

<div class="browserSupport__list">
<img src="../../assets/img/ie.svg" alt="ie8 and above" title="ie8 and above">
</div>

#### :root

Matches the root element of a tree representing the document — [_Learn More_](https://developer.mozilla.org/en-US/docs/Web/CSS/:root)

<div class="browserSupport__list">
<img src="../../assets/img/ie.svg" alt="ie9 and above" title="ie9 and above">
<img src="../../assets/img/chrome.svg" alt="Chrome 1 and above" title="Chrome 1 and above">
<img src="../../assets/img/firefox.svg" alt="Fire Fox 1 and above" title="Fire Fox 1 and above">
<img src="../../assets/img/safari.svg" alt="Safari 1 and above" title="Safari 1 and above">
</div>

#### :scope

Matches the elements that are a reference point for selectors to match against — [_Learn More_](https://developer.mozilla.org/en-US/docs/Web/CSS/:scope)

<div class="browserSupport__list">
<img src="../../assets/img/chrome.svg" alt="Chrome 20 and above" title="Chrome 20 and above">
<img src="../../assets/img/firefox.svg" alt="Fire Fox 21 and above" title="Fire Fox 21 and above">
<img src="../../assets/img/safari.svg" alt="Safari 7 and above" title="Safari 7 and above">
</div>

#### :target

Represents the unique element, if any, with an id matching the fragment identifier of the URI of the document — [_Learn More_](https://developer.mozilla.org/en-US/docs/Web/CSS/:target)

<div class="browserSupport__list">
<img src="../../assets/img/ie.svg" alt="ie9 and above" title="ie9 and above">
<img src="../../assets/img/chrome.svg" alt="Chrome 1 and above" title="Chrome 1 and above">
<img src="../../assets/img/firefox.svg" alt="Fire Fox 1.3 and above" title="Fire Fox 1.3 and above">
<img src="../../assets/img/safari.svg" alt="Safari 1.3 and above" title="Safari 1.3 and above">
</div>

#### :valid

Represents any input element whose content validates correctly according to the input's type setting — [_Learn More_](https://developer.mozilla.org/en-US/docs/Web/CSS/:valid)

<div class="browserSupport__list">
<img src="../../assets/img/ie.svg" alt="ie10 and above" title="ie10 and above">
<img src="../../assets/img/chrome.svg" alt="Chrome 10 and above" title="Chrome 10 and above">
<img src="../../assets/img/firefox.svg" alt="Fire Fox 4 and above" title="Fire Fox 4 and above">
<img src="../../assets/img/safari.svg" alt="Safari 5 and above" title="Safari 5 and above">
</div>

#### :visited

Lets you select only links that have been visited — [_Learn More_](https://developer.mozilla.org/en-US/docs/Web/CSS/:visited)

<div class="browserSupport__list">
<img src="../../assets/img/ie.svg" alt="ie 3.5 and above" title="ie 3.5 and above">
<img src="../../assets/img/chrome.svg" alt="Chrome 1 and above" title="Chrome 1 and above">
<img src="../../assets/img/firefox.svg" alt="Fire Fox 1 and above" title="Fire Fox 1 and above">
<img src="../../assets/img/safari.svg" alt="Safari 1 and above" title="Safari 1 and above">
</div>

* * *

## Pseudo-Elements

Like a pseudo-class, a pseudo-element is a keyword that can be added to a selector. Where they differ is that a pseudo-class does not apply to a special state but rather a portion of html that doesn't exist in the DOM like `:before` or is not contained within a tag like `:first-letter`.

Another difference is that as part of the CSS3 spec, in an attempt to differentiate pseudo-classes from pseudo selectors, use of double colons(::) was allowed. Most browsers support both single and double colons for pseudo-elements.

### How They Are Used

```css
li::after {
    clear: both;
}
```

#### ::after

Matches a virtual last child of the selected element. Typically used to add cosmetic content to an element, by using the content CSS property — [_Learn More_](https://developer.mozilla.org/en-US/docs/Web/CSS/::after)


<div class="browserSupport__list">
<img src="../../assets/img/ie.svg" alt="ie8 and above" title="ie8 and above">
<img src="../../assets/img/chrome.svg" alt="Supported in Chrome" title="Supported in Chrome">
<img src="../../assets/img/firefox.svg" alt="Fire Fox 1 and above" title="Fire Fox 1 and above">
<img src="../../assets/img/safari.svg" alt="Safari 4 and above" title="Safari 4 and above">
</div>

#### ::before

Creates a pseudo-element that is the first child of the element matched. Typically used to add cosmetic content to an element, by using the content CSS property — [_Learn More_](https://developer.mozilla.org/en-US/docs/Web/CSS/::before)

<div class="browserSupport__list">
<img src="../../assets/img/ie.svg" alt="ie8 and above" title="ie8 and above">
<img src="../../assets/img/chrome.svg" alt="Supported in Chrome" title="Supported in Chrome">
<img src="../../assets/img/firefox.svg" alt="Fire Fox 1 and above" title="Fire Fox 1 and above">
<img src="../../assets/img/safari.svg" alt="Safari 4 and above" title="Safari 4 and above">
</div>

#### ::first-letter

Selects the first letter of the first line of a block, if it is not preceded by any other content (such as images or inline tables) on its line — [_Learn More_](https://developer.mozilla.org/en-US/docs/Web/CSS/::first-letter)

<div class="browserSupport__list">
<img src="../../assets/img/ie.svg" alt="ie9 and above" title="ie9 and above">
<img src="../../assets/img/chrome.svg" alt="Chrome 1 and above" title="Chrome 1 and above">
<img src="../../assets/img/firefox.svg" alt="Fire Fox 1 and above" title="Fire Fox 1 and above">
<img src="../../assets/img/safari.svg" alt="Safari 1 and above" title="Safari 1 and above">
</div>

#### ::first-line

Applies styles only to the first line of an element — [_Learn More_](https://developer.mozilla.org/en-US/docs/Web/CSS/::first-line)

<div class="browserSupport__list">
<img src="../../assets/img/ie.svg" alt="ie9 and above" title="ie9 and above">
<img src="../../assets/img/chrome.svg" alt="Chrome 1 and above" title="Chrome 1 and above">
<img src="../../assets/img/firefox.svg" alt="Fire Fox 1 and above" title="Fire Fox 1 and above">
<img src="../../assets/img/safari.svg" alt="Safari 1 and above" title="Safari 1 and above">
</div>

#### ::selection

Applies rules to the portion of a document that has been highlighted (e.g., selected with the mouse or another pointing device) by the user — [_Learn More_](https://developer.mozilla.org/en-US/docs/Web/CSS/::selection)

<div class="browserSupport__list">
<img src="../../assets/img/ie.svg" alt="ie9 and above" title="ie9 and above">
<img src="../../assets/img/chrome.svg" alt="Chrome 1 and above" title="Chrome 1 and above">
<img src="../../assets/img/firefox.svg" alt="Fire Fox 1 and above" title="Fire Fox 1 and above">
<img src="../../assets/img/safari.svg" alt="Safari 1.1 and above" title="Safari 1.1 and above">
</div>

* * *

## Sources

- [https://developer.mozilla.org/en-US/docs/Web/CSS/pseudo-classes](https://developer.mozilla.org/en-US/docs/Web/CSS/pseudo-classes)

- [https://developer.mozilla.org/en-US/docs/Web/CSS/Pseudo-elements](https://developer.mozilla.org/en-US/docs/Web/CSS/Pseudo-elements)

- [http://www.d.umn.edu/~lcarlson/csswork/selectors/pseudo\_dif.html](http://www.d.umn.edu/~lcarlson/csswork/selectors/pseudo_dif.html)
