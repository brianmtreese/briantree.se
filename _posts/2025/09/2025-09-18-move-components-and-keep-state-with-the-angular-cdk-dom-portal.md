---
layout: post
title: "Teleport a Component in Angular (and Keep Its State)"
date: "2025-09-18"
video_id: "cxdNPXCCsaM"
tags:
  - "Angular"
  - "Angular CDK"
  - "Angular Components"
  - "Angular Material"
  - "Angular Template"
  - "Conditional Content"
---

<p class="intro"><span class="dropcap">M</span>oving components to different DOM locations in Angular typically destroys component state because Angular recreates views when templates change. The Angular CDK DomPortal provides a solution by moving live DOM elements without destroying component instances, preserving state, event listeners, and component lifecycle. This tutorial compares three approaches: ng-template with ngTemplateOutlet, CDK Template Portal, and CDK DomPortal, showing when each preserves state and when components get recreated.</p>

{% include youtube-embed.html %}

## Demo Setup: Moving a Component Across Layouts

Here’s the app that we’re working with in this tutorial:

<div>
<img src="{{ '/assets/img/content/uploads/2025/09-18/demo-1.png' | relative_url }}" alt="An Angular demo application with a promo banner displayed in the sidebar" width="2560" height="1440" style="width: 100%; height: auto;">
</div>

We’ve got a small admin dashboard with a "promo banner" displayed in the sidebar:

<div>
<img src="{{ '/assets/img/content/uploads/2025/09-18/demo-2.png' | relative_url }}" alt="Toggling the promo banner between the sidebar and the main content region" width="1920" height="1080" style="width: 100%; height: auto;">
</div>

When we click a button, the banner jumps to the main content region:

<div>
<img src="{{ '/assets/img/content/uploads/2025/09-18/demo-3.gif' | relative_url }}" alt="The promo banner displayed in the sidebar" width="1426" height="962" style="width: 100%; height: auto;">
</div>

This banner includes a heart button and a timer:

<div>
<img src="{{ '/assets/img/content/uploads/2025/09-18/demo-4.png' | relative_url }}" alt="Pointing out the heart button and the timer in the promo banner" width="1922" height="790" style="width: 100%; height: auto;">
</div>

But when we switch locations, the state resets, the timer restarts, and the heart unlikes because the component is being reinitialized every time it moves.

Let’s take a look at some code to get an understanding of the current logic.

Let’s start with the template for the root component where this banner is displayed.

First, we have the button that is used to toggle the region that the promo banner displays in:

```html
<button class="btn" (click)="togglePlacement()">
    Move Promo {% raw %}{{ dockRight() ? 'to Content' : 'to Sidebar' }}{% endraw %}
</button>
```

Then, we have two conditional regions based on this `dockRight()` [signal](https://angular.dev/guide/signals){:target="_blank"} that will show the banner either in the sidebar or the main content region:

#### In the main content region:
```html
@if (!dockRight()) {
    <promo-banner></promo-banner>
}
```

#### In the sidebar:
```html
@if (dockRight()) {
    <promo-banner></promo-banner>
}
```

Now, let’s look at the TypeScript for this component.

Right now this thing is pretty simple.

First, we have the `dockRight()` signal defined:

```typescript
const dockRight = signal(false);
```

Then, we have the `togglePlacement()` method that is used to toggle the `dockRight()` signal:
```typescript
togglePlacement() {
    dockRight.set(!dockRight());
}
```

In this tutorial we’ll try to render this banner in three different ways:
- First using **ng-template with ngTemplateOutlet**
- Then using the **CDK TemplatePortal**
- Finally using the **CDK DomPortal**

And we’ll observe when state resets and when it persists.

## Part 1: Using ng-template and ngTemplateOutlet

First, we’re going to try to use an `ng-template` and the `ngTemplateOutlet` directive.

In order to do this, we first need to add it to the component imports array:

```typescript
import { NgTemplateOutlet } from '@angular/common';

@Component({
  selector: 'app-root',
  ...,
  imports: [ NgTemplateOutlet ],
}
```

Now, in the template, we need to define an `ng-template` with our `promo-banner` component that we can reuse:

```html
<ng-template #promo>
    <promo-banner></promo-banner>
</ng-template>
```

On this template, we have also added a reference variable `#promo` so that we can access it later.

So, what this will do is allow us to essentially stamp out this component in multiple different locations as needed.


And how do we do that?

Well, we’ll use the `ngTemplateOutlet` directive.

To do this, we'll replace the existing conditional `promo-banner` components with an `ngTemplateOutlet` directive that references our `#promo` template:

#### In the main content region:
```html
@if (!dockRight()) {
    <ng-template [ngTemplateOutlet]="promo"></ng-template>
}
```
#### In the sidebar:
```html
@if (dockRight()) {
    <ng-template [ngTemplateOutlet]="promo"></ng-template>
}
```

Now, after we save, how does it work?

<div>
<img src="{{ '/assets/img/content/uploads/2025/09-18/demo-5.gif' | relative_url }}" alt="The promo banner moving but no persisting state using ng-template and ngTemplateOutlet" width="1920" height="1080" style="width: 100%; height: auto;">
</div>

Well, this banner still successfully appears in both locations, but the state is reset every time.

This is because when we switch the banner between the two locations, Angular creates a brand new embedded view each time.

New view, new component instance, new state.

So let’s try something different, a CDK `TemplatePortal`.

## Part 2: Trying the CDK TemplatePortal

Next, we’ll use the **Angular CDK Portal Module**.

The CDK gives us three kinds of portals:
- [TemplatePortal](https://material.angular.dev/cdk/portal/api#TemplatePortal){:target="_blank"}  
- [ComponentPortal](https://material.angular.dev/cdk/portal/api#ComponentPortal){:target="_blank"}  
- [DomPortal](https://material.angular.dev/cdk/portal/api#DomPortal){:target="_blank"}  

Since `TemplatePortal` is closest to what we already had, we’ll try it first.

With a `TemplatePortal`, we can pass around our template and attach it wherever we need it.

First, a quick note, you'll need the [Angular CDK](https://material.angular.dev/guide/getting-started){:target="_blank"} installed. 

You'll just need to run this command in your project root to install it:

```bash
npm install @angular/cdk
```

Okay, once we have the CDK installed, we can import the `PortalModule` in our component so that we can use it:

```typescript
import { PortalModule } from '@angular/cdk/portal';

@Component({
  selector: 'app-root',
  ...,
  imports: [ PortalModule ],
}
```

Now we need to add a few new properties to this component.

First, let’s add a “promoContent” property to hold the value for the portal:

```typescript
import { ..., TemplatePortal } from '@angular/cdk/portal';

protected promoContent!: TemplatePortal<unknown>;
```

Next, we need a property to access the template. 

Let’s call it “promo” and set it to the template we made using the [viewChild()](https://angular.dev/api/core/viewChild){:target="_blank"} signal query:

```typescript
import { ..., viewChild } from '@angular/core';

private readonly promo = viewChild.required<TemplateRef<unknown>>('promo');
```

We’ll also need to inject the [ViewContainerRef](https://angular.dev/api/core/ViewContainerRef){:target="_blank"} for the origin of the view:

```typescript
import { ..., inject, ViewContainerRef } from '@angular/core';

private viewContainerRef = inject(ViewContainerRef);
```

Now, we need to set the portal whenever the `viewChild` is resolved, so let’s add a constructor with an [effect()](https://angular.dev/api/core/effect){:target="_blank"}:

```typescript
import { ..., effect } from '@angular/core';

constructor() {
    effect(() => {
    })
}
```

Then we’ll check for the existence of our `promo()` template, and if it exists, we’ll set the portal using the `TemplatePortal`:

```typescript
constructor() {
    effect(() => {
        if (this.promo()) {
            this.promoContent = new TemplatePortal(this.promo(), this.viewContainerRef);
        }
    })
}
```

As you can see we need to pass this function both the template and the `ViewContainerRef`.

Alright, that's all we need here, so now we go back to the component template and switch to the `TemplatePortal`.

All we need to do is replace `ngTemplateOutlet` with `cdkPortalOutlet` and pass it our new `promoContent` property:

#### In the main content region:
```html
@if (!dockRight()) {
    <ng-template [cdkPortalOutlet]="promoContent"></ng-template>
}
```
#### In the sidebar:
```html
@if (dockRight()) {
    <ng-template [cdkPortalOutlet]="promoContent"></ng-template>
}
```

Okay, after we save, how does it work now?

<div>
<img src="{{ '/assets/img/content/uploads/2025/09-18/demo-5.gif' | relative_url }}" alt="The promo banner moving but not persisting state using the CDK TemplatePortal" width="1920" height="1080" style="width: 100%; height: auto;">
</div>

Well, when we switch the banner location, the attach process kicks in and… just like before, we get a new embedded view.  

That means the state still resets. 

Now we could try a `ComponentPortal` here but I’ll go ahead and spoil it for you… we’d end up with the same result.

So `TemplatePortals` don’t solve our problem either.  

Let’s move on to the real winner.

## Part 3: DomPortal (The Win)

With a `DomPortal`, we can actually move the same live instance of the component.  

It literally re-parents existing DOM into another outlet.

Same instance, same signals, same timers.

To use it, back in the TypeScript, we need to change a few things.

First, we need to switch the `promoContent` property from a `TemplatePortal` to a `DomPortal` typed as an `HTMLElement` this time:

```typescript
import { ..., DomPortal } from '@angular/cdk/portal';

protected promoContent!: DomPortal<HTMLElement>;
```

We also need to switch the `promo` viewChild from a `TemplateRef` to an `ElementRef`:

```typescript
import { ..., ElementRef } from '@angular/core';

private readonly promo = viewChild.required<ElementRef>('promo');
```

For the `DomPortal` we no longer need the `ViewContainerRef` so it can be removed.

Finally, in the `effect()` we can switch from the `TemplatePortal` to the `DomPortal`:

```typescript
constructor() {
    effect(() => {
        if (this.promo()) {
            this.promoContent = new DomPortal(this.promo());
        }
    })
}
```

Okay, that’s everything we need to change in the TypeScript, now we just need to make a few changes in the component template.

Basically, we just need to switch to use real elements instead of templates:

#### The shared instance:
```html
<div #promo>
    <promo-banner></promo-banner>
</div>
```

#### In the main content region:
```html
@if (!dockRight()) {
    <div [cdkPortalOutlet]="promoContent"></div>
}
```

#### In the sidebar:
```html
@if (dockRight()) {
    <div [cdkPortalOutlet]="promoContent"></div>
}
```

Alright, that’s it. Let’s save and check it out now!

<div>
<img src="{{ '/assets/img/content/uploads/2025/09-18/demo-6.gif' | relative_url }}" alt="The promo banner moving and persisting state using the CDK DomPortal" width="1920" height="1080" style="width: 100%; height: auto;">
</div>


Nice! Now when we move the banner:
- The timer keeps ticking  
- The like stays liked  
- No reset happens! 

A `DomPortal` even preserves the origin injector, so feature-scoped providers and DI context remain intact.  

This is the approach that lets us teleport a component without losing state.

## Key Takeaways: Templates Recreate vs. DomPortal Moves

Here’s the simple rule to remember:

- Rendering the banner directly, with `ng-template` and `ngTemplateOutlet`, or with a `TemplatePortal` all **recreate the view**, so state resets.  
- A `DomPortal` actually **moves the same instance**, so state persists.  

That’s the whole trick.  

The Portal Module is just one of many hidden gems in the Angular CDK. 

If you want to see more lesser-known Angular features that can level up your applications, don’t forget to [subscribe](https://www.youtube.com/c/briantreese?sub_confirmation=1)!

{% include banner-ad.html %}

## Additional Resources
- [The demo app BEFORE any changes](https://stackblitz.com/edit/stackblitz-starters-bj7pn1f2?file=src%2Fmain.html){:target="_blank"}
- [The demo app AFTER making changes](https://stackblitz.com/edit/stackblitz-starters-1xnmwh7p?file=src%2Fmain.html){:target="_blank"}
- [Angular CDK Portal Documentation](https://material.angular.dev/cdk/portal/overview){:target="_blank"}
- [NgTemplateOutlet Directive](https://angular.dev/api/common/NgTemplateOutlet){:target="_blank"}
- [Angular Signals Overview](https://angular.dev/guide/signals){:target="_blank"}
- [My course "Angular: Styling Applications"](https://www.pluralsight.com/courses/angular-styling-applications){:target="_blank"}
- [My course "Angular in Practice: Zoneless Change Detection"](https://app.pluralsight.com/library/courses/angular-practice-zoneless-change-detection){:target="_blank"}

## Want to See It in Action?

Want to experiment with the final version? Explore the full StackBlitz demo below. If you have any questions or thoughts, don’t hesitate to leave a comment.

<iframe src="https://stackblitz.com/edit/stackblitz-starters-1xnmwh7p?ctl=1&embed=1&file=src%2Fmain.html" style="height: 500px; width: 100%; margin-bottom: 1.5em; display: block;"></iframe>