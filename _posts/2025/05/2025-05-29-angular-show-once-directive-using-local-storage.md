---
layout: post
title: "Show It Once, Then Never Again… One-Time UI in Angular"
date: "2025-05-29"
video_id: "-LwfJZAlIpA"
tags:
  - "Angular"
  - "Angular Components"
  - "Angular Directives"
  - "Angular Signals"
  - "Angular Styles"
  - "Local Storage"
---

<p class="intro"><span class="dropcap">H</span>ave you ever wanted to show a banner, tooltip, or onboarding message just once, and then hide it forever? Like… "We get it. Thanks for the message. Please don’t show it again." In this tutorial, I’ll show you a clean, modern Angular 19+ approach for one-time UI using <a href="https://developer.mozilla.org/en-US/docs/Web/API/Window/localStorage" target="_blank">local storage</a>, <a href="https://angular.dev/guide/signals" target="_blank">signals</a>, and finally a reusable <a href="https://angular.dev/guide/directives/structural-directives" target="_blank">structural directive</a> you can drop anywhere in your app.</p>

{% include youtube-embed.html %}

## Let’s See the Problem in Action

So, here’s our basic dashboard app:

<div>
<img src="{{ '/assets/img/content/uploads/2025/05-29/demo-1.png' | relative_url }}" alt="Screenshot of a basic dashboard app built with Angular" width="1202" height="702" style="width: 100%; height: auto;">
</div>

Towards the top we have this yellow welcome banner:

<div>
<img src="{{ '/assets/img/content/uploads/2025/05-29/demo-2.png' | relative_url }}" alt="Screenshot of the welcome banner" width="1226" height="492" style="width: 100%; height: auto;">
</div>

What we want is for this to only show once per user.

After they dismiss it, they should no longer see it.

Let’s look at [the template](https://stackblitz.com/edit/stackblitz-starters-p8p99wos?file=src%2Fmain.html){:target="_blank"} for the main app component.

Okay here, we’ve got the [welcome-banner component](https://stackblitz.com/edit/stackblitz-starters-p8p99wos?file=src%2Fwelcome-banner%2Fwelcome-banner.component.ts){:target="_blank"} showing directly:

```html
<app-welcome-banner (dismiss)="dismissBanner()"></app-welcome-banner>
```

Notice the "dismiss" [output](https://angular.dev/api/core/output){:target="_blank"}, that’s a custom [output](https://angular.dev/api/core/output){:target="_blank"} event that fires when the “dismiss” button is clicked.

In this case, it lets us hide the banner when someone clicks the button.

But, it’s not doing anything yet, so let’s see why. Let's look at the [code](https://stackblitz.com/edit/stackblitz-starters-p8p99wos?file=src%2Fmain.ts){:target="_blank"} for this component.

Okay here it is, the "dismiss" method that's called when the button is clicked, doesn’t do anything yet:

```typescript
export class App {
  protected dismiss() {}
}
```

So, let’s look at how we might make this more dynamic with a [signal](https://angular.dev/guide/signals){:target="_blank"}.

## Quick Fix: Hiding the Banner with a Signal

Let’s start by adding a new property called "hideBanner".

It will be a [signal](https://angular.dev/guide/signals){:target="_blank"}, and it will be initialized to false:

```typescript
import { ..., signal } from '@angular/core';

export class App {
  protected hideBanner = signal(false);
  ...
}
```

Then let’s update the "dismiss" function to flip that [signal](https://angular.dev/guide/signals){:target="_blank"}:

```typescript
export class App {
  ...
  protected dismiss() {
    this.hideBanner.set(true);
  }
}
```

Now back in [the template](https://stackblitz.com/edit/stackblitz-starters-p8p99wos?file=src%2Fmain.html){:target="_blank"}, we’ll wrap the [welcome-banner](https://stackblitz.com/edit/stackblitz-starters-p8p99wos?file=src%2Fwelcome-banner%2Fwelcome-banner.component.ts){:target="_blank"} in an [@if](https://angular.dev/tutorials/learn-angular/4-control-flow-if){:target="_blank"} block using that [signal](https://angular.dev/guide/signals){:target="_blank"}:

```html
@if (!hideBanner()) {
  <app-welcome-banner (dismiss)="dismiss()"></app-welcome-banner>
}
```

Okay, let’s save and see how it works now:

<div>
<img src="{{ '/assets/img/content/uploads/2025/05-29/demo-3.gif' | relative_url }}" alt="Example of the banner showing and then being dismissed using a signal that doesn't persist" width="1228" height="972" style="width: 100%; height: auto;">
</div>

Okay, the banner still shows initially, and then when we click “dismiss,” it hides. 

So that’s cool, but we have a problem here don’t we?

If we refresh, the banner comes back.

This is because we haven’t done anything to store the “dismissed” state of this banner that will allow it to persist.

## Make It Stick: Saving Dismissal with localStorage

What we really want is for our app to remember: 

> "Hey, this user already dismissed the banner — don’t show it again."

So, let’s fix it with [localStorage](https://developer.mozilla.org/en-US/docs/Web/API/Window/localStorage){:target="_blank"}.

Let’s switch back to [the code](https://stackblitz.com/edit/stackblitz-starters-p8p99wos?file=src%2Fmain.ts){:target="_blank"}.

First, we’ll update the "dismiss" method to write a flag to [localStorage](https://developer.mozilla.org/en-US/docs/Web/API/Window/localStorage){:target="_blank"}, let’s call it "bannerDismissed", and we’ll give it a value of "true":

```typescript
export class App {
  ...
  protected dismiss() {
    this.hideBanner.set(true);
    localStorage.setItem('bannerDismissed', 'true');
  }
}
```

Now, when the "dismiss" button is clicked, a "bannerDismissed" property will be added to [localStorage](https://developer.mozilla.org/en-US/docs/Web/API/Window/localStorage){:target="_blank"} and will persist.

Now, we need to add the logic to determine whether or not it should display when initialized.

Let’s add a constructor.

Then let’s add a "dismissed" variable that we’ll set based on the value of our new "bannerDismissed" property from [localStorage](https://developer.mozilla.org/en-US/docs/Web/API/Window/localStorage){:target="_blank"}, and we’ll check if it’s set to "true".

Then we update our "hideBanner" [signal](https://angular.dev/guide/signals){:target="_blank"} based on this value:

```typescript
export class App {
  ...
  constructor() {
    const dismissed = localStorage.getItem('bannerDismissed') === 'true';
    this.hideBanner.set(dismissed);
  }
}
```

Okay, that should be all we need, so let’s save and try it out:

<div>
<img src="{{ '/assets/img/content/uploads/2025/05-29/demo-4.gif' | relative_url }}" alt="Example of the banner showing and then being dismissed using local storage so that the state persists across page reloads" width="1918" height="728" style="width: 100%; height: auto;">
</div>

Nice. To start the banner shows, and there’s nothing in [localStorage](https://developer.mozilla.org/en-US/docs/Web/API/Window/localStorage){:target="_blank"}.

Then, when we click "dismiss," the banner hides and in the dev tools, we can see the key: "bannerDismissed" set to "true".

Then, when we refresh, the banner remains hidden.

Pretty cool, right?

This works well, but… the logic is starting to feel too custom and too local.

Let’s make it reusable.

## Upgrade Time: Reusable UI with a Structural Directive

Let’s create a [structural directive](https://angular.dev/guide/directives/structural-directives){:target="_blank"} that takes in a [localStorage](https://developer.mozilla.org/en-US/docs/Web/API/Window/localStorage){:target="_blank"} key and controls whether to show an item or not based on whether that key is set.

I’ve already got [this directive](https://stackblitz.com/edit/stackblitz-starters-p8p99wos?file=src%2Fshow-once.directive.ts){:target="_blank"} stubbed out. It’s called "show-once":

```typescript
import { Directive } from '@angular/core';

@Directive({
  selector: '[showOnce]'
})
export class ShowOnceDirective {
}
```

Right now, this file is empty, so let’s build it step-by-step.

First, we need to add an [input](https://angular.dev/api/core/input){:target="_blank"} for the [localStorage](https://developer.mozilla.org/en-US/docs/Web/API/Window/localStorage){:target="_blank"} key:

```typescript
import { ..., input } from '@angular/core';

export class ShowOnceDirective {
  key = input('', { alias: 'showOnce' });
}
```

We’re using Angular’s [input()](https://angular.dev/api/core/input){:target="_blank"} function and giving it an alias that matches the directive name "showOnce".

Next, we need to create a couple more properties and [inject](https://angular.dev/api/core/inject){:target="_blank"} both [TemplateRef](https://angular.dev/api/core/TemplateRef){:target="_blank"} and [ViewContainerRef](https://angular.dev/api/core/ViewContainerRef){:target="_blank"}:

```typescript
import { ..., inject, TemplateRef, ViewContainerRef } from '@angular/core';

export class ShowOnceDirective {
  ...
  private templateRef = inject(TemplateRef<unknown>);
  private viewContainerRef = inject(ViewContainerRef);
}
```

These will be used to conditionally render the content placed within this directive.

Now, let’s add a constructor.

Inside the constructor, we’ll set up an [effect()](https://angular.dev/api/core/effect){:target="_blank"}.

This will run whenever the "key" [input](https://angular.dev/api/core/input){:target="_blank"} changes.

Within the [effect()](https://angular.dev/api/core/effect){:target="_blank"}, we call the clear() method from the [ViewContainerRef](https://angular.dev/api/core/ViewContainerRef){:target="_blank"} to reset the view.

Then, we read the [localStorage](https://developer.mozilla.org/en-US/docs/Web/API/Window/localStorage){:target="_blank"} key passed into the directive from the "key" [input](https://angular.dev/api/core/input){:target="_blank"}.

If the key isn’t set, we call the createEmbeddedView() method from the [ViewContainerRef](https://angular.dev/api/core/ViewContainerRef){:target="_blank"} to render the content, like our banner:

```typescript
import { ..., effect } from '@angular/core';

export class ShowOnceDirective {
  ...
  constructor() {
    effect(() => {
      this.viewContainerRef.clear();
      const value = localStorage.getItem(this.key());
      if (!value) {
        this.viewContainerRef.createEmbeddedView(this.templateRef);
      }
    });
  }
}
```

This [effect()](https://angular.dev/api/core/effect){:target="_blank"} handles conditional display on initialization.

Next, we need to add a custom "clear" method that can be used to dismiss the message.

This method updates [localStorage](https://developer.mozilla.org/en-US/docs/Web/API/Window/localStorage){:target="_blank"} with the "key" and sets its value to "true".

Then, it clears the [ViewContainerRef](https://angular.dev/api/core/ViewContainerRef){:target="_blank"} to hide the content:

```typescript
export class ShowOnceDirective {
  ...
  protected clear() {
    localStorage.setItem(this.key(), 'true');
    this.viewContainerRef.clear();
  }
}
```

This becomes part of the directive’s public API.

And, in order to access it from the template, we need to add an alias with [exportAs](https://angular.dev/api/core/Directive#exportAs){:target="_blank"}:

```typescript
@Directive({
  selector: '[showOnce]',
  exportAs: 'showOnce'
})
```

### Using the Directive in Our Component

Now we can remove the old logic from the app component. t

The "hideBanner" [signal](https://angular.dev/guide/signals){:target="_blank"}, the constructor, the "dismiss" function, and imports can all go.

Then, we need to import the new [show-once directive](https://stackblitz.com/edit/stackblitz-starters-cwfdc5ud?file=src%2Fshow-once.directive.ts){:target="_blank"} so we can use it in the template:

```typescript
import { ShowOnceDirective } from './show-once.directive';

@Component({
  selector: 'app-root',
  ...,
  imports: [ ..., ShowOnceDirective ]
})
```

Then, we replace the [@if](https://angular.dev/tutorials/learn-angular/4-control-flow-if){:target="_blank"} block with an `<ng-template>`.

The template is where we apply the directive passing it the [localStorage](https://developer.mozilla.org/en-US/docs/Web/API/Window/localStorage){:target="_blank"} key, "bannerDismissed".

Then, we add a [template reference variable](https://angular.dev/guide/templates/variables#template-reference-variables){:target="_blank"} using our "showOnce" alias to access the directive right within the template.

Finally, we use that reference to call the directive’s clear() method when the "dismiss" button is clicked:

```html
<ng-template showOnce="bannerDismissed" #showOnce="showOnce">
  <app-welcome-banner (dismiss)="showOnce.clear()"></app-welcome-banner>
</ng-template>
```

Okay, now let’s save and test it out:

<div>
<img src="{{ '/assets/img/content/uploads/2025/05-29/demo-4.gif' | relative_url }}" alt="Example of the banner showing and then being dismissed using local storage and a custom structual directive to make it reusable" width="1918" height="728" style="width: 100%; height: auto;">
</div>

After we clear [localStorage](https://developer.mozilla.org/en-US/docs/Web/API/Window/localStorage){:target="_blank"} and refresh, the banner is properly displayed again.

Then, when we dismiss it, it hides and the key is stored in [localStorage](https://developer.mozilla.org/en-US/docs/Web/API/Window/localStorage){:target="_blank"} again.

And, when we refresh again, the banner remains hidden.

Everything works great, and now we have a reusable concept.

## Wrap-Up & When to Use This Pattern

So, that’s it. You now have a clean, reusable directive that you can drop into any Angular app.

It’s perfect for banners, tooltips, modals, or anything you only want users to see once.

No global state. No services. Just declarative, Angular-idiomatic code.

But remember: it’s per-browser and not tied to user auth.

Also, it needs manual clearing if you want to reset it.

Just a couple things to keep in mind.

If you found this helpful, don't forget to [subscribe](https://www.youtube.com/c/briantreese?sub_confirmation=1){:target="_blank"}, check out [my other Angular tutorials](https://www.youtube.com/@briantreese){:target="_blank"} for more tips and tricks, and maybe buy some Angular swag from [my shop](https://shop.briantree.se/){:target="_blank"}!

{% include banner-ad.html %}

## Additional Resources
- [The demo app BEFORE any changes](https://stackblitz.com/edit/stackblitz-starters-p8p99wos?file=src%2Fshow-once.directive.ts){:target="_blank"}
- [The demo app AFTER making changes](https://stackblitz.com/edit/stackblitz-starters-cwfdc5ud?file=src%2Fshow-once.directive.ts){:target="_blank"}
- [Angular Signals Guide](https://angular.dev/guide/signals){:target="_blank"}
- [Angular Structural Directives Explained](https://angular.dev/guide/directives/structural-directives){:target="_blank"}
- [JavaScript Local Storage Documentation](https://developer.mozilla.org/en-US/docs/Web/API/Window/localStorage){:target="_blank"}
- [My course: "Styling Angular Applications"](https://app.pluralsight.com/library/courses/angular-styling-applications/table-of-contents){:target="_blank"}

## Want to See It in Action?

Want to experiment with the final version? Explore the full StackBlitz demo below. If you have any questions or thoughts, don’t hesitate to leave a comment.

<iframe src="https://stackblitz.com/edit/stackblitz-starters-cwfdc5ud?ctl=1&embed=1&file=src%2Fshow-once.directive.ts" style="height: 500px; width: 100%; margin-bottom: 1.5em; display: block;"></iframe>
