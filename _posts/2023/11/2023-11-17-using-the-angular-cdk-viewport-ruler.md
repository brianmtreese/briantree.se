---
layout: post
title: "How to Use the Angular CDK Viewport Ruler for Responsive Apps"
date: "2023-11-17"
video_id: "71z2SPF4LDA"
tags: 
  - "Angular"
  - "Angular CDK"
---

<p class="intro"><span class="dropcap">S</span>ometimes, in an Angular app we need to trigger something when the viewport gets resized. Like in the demo app for this post, when we open a menu, and then resize, we want to close the menu automatically. How would you do this? Well, maybe you have some ideas, but with the Angular CDK, this is pretty easy. We can use the Viewport Ruler. It’s a utility that deals with, you guessed it, the viewport. In this post I’m going to show you how to use it. Alright, let’s get to it!</p>

<iframe width="560" height="315" src="https://www.youtube.com/embed/71z2SPF4LDA?si=zsvVuxRGmFmwFz1n" title="YouTube video player" frameborder="0" allow="accelerometer; autoplay; clipboard-write; encrypted-media; gyroscope; picture-in-picture; web-share" allowfullscreen></iframe>

Ok, so we probably already know the Angular CDK provides many useful utilities. And the more we know about them, the easier our angular development goes. The Viewport Ruler is another example of this.

It may not be something you use every day, but it can definitely help out in certain situations. For example, in the demo site for this post, the history of the Vans shoe brand, we have a hamburger menu button and when we click it the main menu opens. And, then when we resize the browser, it remains open.

But let’s pretend our client wants us to hide this menu when the viewport is resized. Let’s take a closer look at how this menu is toggled.

Within our app component we have our page content component which contains everything we see in the page, including the menu button. When the menu button is clicked, we emit that event.

### page-content.component.html
```html
<button (click)="menuClick.emit()">
    ...
</button>
```

When that event is emitted, we toggle the value of our menu visible property.

### main.ts
```html
<app-page-content (menuClick)="menuVisible = !menuVisible"></app-page-content>
```

When that property is true, we bind a class on our menu component which contains style for the visible state.

```html
<app-page-menu [class.open]="menuVisible"></app-page-menu>
```

So, it’s pretty straight forward, but it only toggles on button clicks right now. This is where the viewport ruler comes in.

## Setting up the the CDK ViewportRuler

To use it, we first need to have the CDK installed.

```shell
npm i @angular/cdk
```

Then, we need to have the Viewport Ruler imported.

```typescript
import { ViewportRuler } from '@angular/cdk/scrolling';
```

And now we can use it. We start by injecting it in the constructor.

```typescript
constructor(private viewportRuler: ViewportRuler) {}
```

Ok, now we can listen for a change with the change event observable.

## Subscribing to the Angular CDK ViewportRuler Change Event 

We can wire this up right here in our constructor. We start by calling the `change` method on the Viewpor Ruler. And, we can throttle our response to this change event so that it doesn’t fire too often when resizing. We'll go with three hundred milliseconds. This function returns an observable so, we need to destroy it when needed to prevent memory leaks. To do this we need to add `pipe` and then `takeUntilDestroyed`.

```typescript
constructor(private viewportRuler: ViewportRuler) {
    this.viewportRuler
        .change(300)
        .pipe(takeUntilDestroyed())
}
```

Ok, now we can subscribe to the event and properly toggle our menu visible property. Now, under the hood, the Viewport Ruler uses a window resize event which fires outside of angular’s change detection. In this case, since we need our variable value change to be reflected in the template, we need to make sure to run within `ngZone`. So, we need to inject in `ngZone` in the constructor. And when this event fires, we just need to make sure that our property is set to false.

```typescript
constructor(
    private viewportRuler: ViewportRuler,
    private ngZone: NgZone)) {
    this.viewportRuler
        .change(300)
        .pipe(takeUntilDestroyed())
        .subscribe(() => {
            this.ngZone.run(() => {
                this.menuVisible = false;
            });
        });
}
```

Ok so now when we open the menu and then resize the viewport it properly closes.

Cool, so that was easy right? 

The Viewport Ruler actually provides more information too. In our case here we don’t need anything else, but there’s more available if needed.

## Using the CDK ViewportRuler to get the viewport rect object

To start, we can get the viewport rect which provides an object containing the bottom, height, left, right, top, and width values of the viewport.

Let’s go ahead and log this out. It’s accessed using the `getViewportRect()` method.

```typescript
constructor(
    private viewportRuler: ViewportRuler,
    private ngZone: NgZone)) {
    this.viewportRuler
        .change(300)
        .pipe(takeUntilDestroyed())
        .subscribe(() => {
            this.ngZone.run(() => {
                ...
                console.log('Viewport Rect:', this.viewportRuler.getViewportRect());
            });
        });
}
```

Now, when we resize, we can see what this rect object looks like.

## Using the Angular CDK ViewportRuler to Get the Current Viewport Scroll Position

We can also get the current viewport scroll position. Let’s log this out this time. We do this with the `getViewportScrollPosition()` method.

```typescript
constructor(
    private viewportRuler: ViewportRuler,
    private ngZone: NgZone)) {
    this.viewportRuler
        .change(300)
        .pipe(takeUntilDestroyed())
        .subscribe(() => {
            this.ngZone.run(() => {
                ...
                console.log('Viewport Scroll:', this.viewportRuler.getViewportScrollPosition());
            });
        });
}
```

Now, let’s scroll down a little bit and resize, we can see this object consists of both the value we’re scrolled vertically as well as the value we’re scrolled horizontally.

## Using the Angular CDK ViewportRuler to Get the Viewport Size

We can also just get the viewport size if that’s all that’s needed. We do this with the `getViewportSize()` method.

```typescript
constructor(
    private viewportRuler: ViewportRuler,
    private ngZone: NgZone)) {
    this.viewportRuler
        .change(300)
        .pipe(takeUntilDestroyed())
        .subscribe(() => {
            this.ngZone.run(() => {
                ...
                console.log('Viewport Size:', this.viewportRuler.getViewportSize());
            });
        });
}
```

There, when we resize now, we get an object with the width and height of the viewport.

{% include banner-ad.html %}

So, in this example, we were easily able to react to viewport size changes and get all sorts of information about the viewport itself with the CDK Viewport Ruler.

I hope you find this useful as you build things in Angular.

## Want to See It in Action?
Check out the demo code and examples of these techniques in the stackblitz example below. If you have any questions or thoughts, don’t hesitate to leave a comment.

<iframe src="https://stackblitz.com/edit/stackblitz-starters-kvsh1c?ctl=1&embed=1&file=src%2Fmain.ts" style="height: 500px; width: 100%; margin-bottom: 1.5em; display: block;"> 
