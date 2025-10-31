---
layout: post
title: "Understanding View vs. Content in Angular"
date: "2025-02-20"
video_id: "8-U_x0Ui0p8"
tags:
  - "Angular"
  - "Angular Components"
  - "Angular ContentChild"
  - "Angular ViewChild"
---

<p class="intro"><span class="dropcap">I</span>n Angular, understanding the difference between "view" and "content" is key to working effectively with components. If you've ever tried querying an element and it didn’t work as expected, it’s likely because you were mixing these two concepts up. In this example, we’ll break down the difference between the two, and I’ll show you how Angular’s <a href="https://angular.dev/guide/components/queries">signal queries</a> make accessing both simple and reactive.</p>

{% include youtube-embed.html %}

## Understanding the View: A Component’s Own Template

To start, the "view" refers to a component’s own template, the HTML that is directly inside its associated template markup.

This includes all elements and child components that the component itself defines.

So, everything we see here in the template for this card component belongs to its "view":

```typescript
@Component({
  selector: "app-card",
  template: ` <h2>This is a Title</h2>
    <p>
      This is a Description
      <ng-content></ng-content>
    </p>`,
})
export class CardComponent {}
```

Okay, so that’s the "view." It's that simple.

If it's inside the component's own template, then it's part of the "view."

## Understanding Content: Projecting Elements from the Parent

"Content", on the other hand, is different.

"Content" refers to elements that are passed into a component from a parent, using [content projection](https://angular.dev/guide/components/content-projection) with [ng-content](https://angular.dev/api/core/ng-content).

This is considered a “slot” in an Angular component.

In this example, the [button](https://developer.mozilla.org/en-US/docs/Web/HTML/Element/button) tag inside the `app-card` element does not belong to the card component:

```typescript
@Component({
  selector: "app-root",
  template: ` <app-card>
    <button>Click me!</button>
  </app-card>`,
})
export class App {}
```

The card component provides a slot for the button, but the button itself within this slot is owned by the parent `<app-root>` component instead.

The key takeaway here is that the "view" is part of the component, while "content" is part of the parent and projected inside [ng-content](https://angular.dev/guide/components/content-projection#ng-content) regions.

So now that we understand the difference between the two, let’s look at how we can access items in each scenario.

## How to Query Elements Inside a Component’s View

Let’s look at the concept of the component “view” first.

If we want to reference an element inside our component’s own template, we use the [viewChild](https://angular.dev/api/core/viewChild) or [viewChildren](https://angular.dev/api/core/viewChildren) signal query functions.

These query functions allow us to access elements inside the component’s view.

They update reactively, so there’s no need for the old [ngAfterViewInit](https://angular.dev/api/core/AfterViewInit) lifecycle hook when using them.

Here, we have a simple [app card component](https://stackblitz.com/edit/stackblitz-starters-h6zyxzve?file=src%2Fcard%2Fcard.component.html).

It has a heading, a description, and a button:

```html
<h2>Shiba Inu</h2>
<p>
  The Shiba Inu is the smallest of the six original and distinct spitz breeds of
  dog from Japan. A small, agile dog that copes very well with mountainous
  terrain, the Shiba Inu was originally bred for hunting.
</p>
<button>View Button</button>
```

To access this button, we can add a [reference variable](https://angular.dev/guide/templates/variables#template-reference-variables).

This is how we’ll target it with our [view query function](https://angular.dev/guide/components/queries#view-queries).

Now, let’s switch to the [TypeScript for this component](https://stackblitz.com/edit/stackblitz-starters-h6zyxzve?file=src%2Fcard%2Fcard.component.ts).

Here we can add a new “button” property and we’ll use the [viewChild](https://angular.dev/api/core/viewChild) signal query function.

We'll need to be sure that this gets properly imported from the Angular core module too.

Also, in this case, we need to type this signal to an [ElementRef&lt;HTMLButtonElement&gt;](https://angular.dev/api/core/ElementRef), since we are querying for the [HTML button element](https://developer.mozilla.org/en-US/docs/Web/HTML/Element/button) directly.

Then, we just need to pass the [template reference](https://angular.dev/guide/templates/variables#template-reference-variables) from the button as the locator:

```typescript
import { ..., viewChild, ElementRef } from '@angular/core';

@Component({
  selector: 'app-card',
  ...
})
export class CardComponent {
  protected button = viewChild<ElementRef<HTMLButtonElement>>('btn');
}
```

Next, let’s add a “buttonText” [signal](https://angular.dev/api/core/signal) and initialize it to an empty string:

```typescript
@Component({
  selector: 'app-card',
  ...
})
export class CardComponent {
  ...
  protected buttonText = signal('');
}
```

Now we'll add a new “buttonClicked” method and set the “buttonText” [signal](https://angular.dev/api/core/signal) with the button’s text when clicked:

```typescript
@Component({
  selector: 'app-card',
  ...
})
export class CardComponent {
  ...
  protected buttonClicked() {
    this.buttonText.set(this.button()?.nativeElement.innerText ?? '');
  }
}
```

Then, let’s switch back to the [template](https://stackblitz.com/edit/stackblitz-starters-4tad4q3a?file=src%2Fcard%2Fcard.component.html) and wire up this function on click of our button element:

```html
<button #btn (click)="buttonClicked()">View Button</button>
```

Then, let’s add a `<div>` and then add the [string-interpolated](https://angular.dev/guide/templates/binding#render-dynamic-text-with-text-interpolation) value of the [signal](https://angular.dev/api/core/signal) within it:

```html
<div>{% raw %}{{ buttonText() }}{% endraw %}</div>
```

Ok, now let’s test it!

When we click the button, we should see the text "View Button" appear:

<div>
<img src="{{ '/assets/img/content/uploads/2025/02-20/demo-1.gif' | relative_url }}" alt="Example accessing projected content with the viewChild signal query" width="724" height="664" style="width: 100%; height: auto;">
</div>

So, that’s how you query elements inside of a component’s "view", no lifecycle hooks needed, and the [viewChild](https://angular.dev/api/core/viewChild) signal updates reactively.

And just to clarify, if we needed to query for more than one item, we would use the [viewChildren](https://angular.dev/api/core/viewChildren) signal query instead.

## How to Query Projected Content from the Parent Component

Now, to contrast this, if we need to reference content that is projected into our component, not part of the "view", we use the [contentChild](https://angular.dev/api/core/contentChild) or [contentChildren](https://angular.dev/api/core/contentChildren) signal queries instead.

These functions allow us to access elements projected into our component using [ng-content](https://angular.dev/guide/components/content-projection#ng-content).

And, just like the [view queries](https://angular.dev/guide/components/queries#view-queries), they update reactively when content projection changes so there’s no need for the old [ngAfterContentInit](https://angular.dev/api/core/AfterContentInit) lifecycle hook when using them.

So, let’s switch the component around a little to demonstrate this concept.

Instead of defining the button text in the card component template, let’s replace it with an [ng-content](https://angular.dev/guide/components/content-projection#ng-content) element instead.

Let’s also remove the reference variable:

```html
<button #btn (click)="buttonClicked()">
  <ng-content></ng-content>
</button>
```

This now allows us to project content here from the parent when including this [card component](https://stackblitz.com/edit/stackblitz-starters-4tad4q3a?file=src%2Fcard%2Fcard.component.ts).

So, now let’s switch to the [main app component](https://stackblitz.com/edit/stackblitz-starters-4tad4q3a?file=src%2Fmain.ts) and let’s add a `<span>` within the `<app-card>` selector.

Inside this `<span>`, let’s add the text “Content Button”.

Also, we’ll need to add a [template reference variable](https://angular.dev/guide/templates/variables#template-reference-variables) on it because, like the [viewChild](https://angular.dev/api/core/viewChild) query, we’ll use it to reference this element:

```html
<app-card>
  <span #btn>Content Button</span>
</app-card>
```

Next, we can switch back to our [card component](https://stackblitz.com/edit/stackblitz-starters-4tad4q3a?file=src%2Fcard%2Fcard.component.ts).

Here we can change the [viewChild](https://angular.dev/api/core/viewChild) to the [contentChild](https://angular.dev/api/core/contentChild) function now since we’re referring to the "content" of the component instead of the "view".

And we’ll need to make sure that it also gets imported from Angular core:

```typescript
import { ..., contentChild } from '@angular/core';

@Component({
  selector: 'app-card',
  ...
})
export class CardComponent {
  protected button = contentChild<ElementRef<HTMLElement>>('btn');
}
```

Now, when we save and click the button... we should see the “Content Button” text now that we’ve switched the button to the "content" of the component:

<div>
<img src="{{ '/assets/img/content/uploads/2025/02-20/demo-2.gif' | relative_url }}" alt="Example accessing projected content with the contentChild signal query" width="722" height="654" style="width: 100%; height: auto;">
</div>

And just like the "view", if we needed to query for more than one item, we would use the [contentChildren](https://angular.dev/api/core/contentChildren) signal query instead.

## Why Understanding This Matters

So, understanding the "view" vs. "content" helps us build more reusable, flexible components more effectively.

It’s an important concept in the Angular framework.

[Signal queries](https://angular.dev/guide/components/queries#signal-queries) further simplify things by making it easy to access both "view" elements and projected "content".

If you ever run into issues with queries, ask yourself:

1. Is the element inside my component’s own template? If so, use [viewChild](https://angular.dev/api/core/viewChild).
2. Or, is the element projected into my component? If so, use [contentChild](https://angular.dev/api/core/contentChild).

This simple distinction can save you a lot of debugging time when you understand it properly.

{% include youtube-embed.html %}

## Conclusion: Choosing the Right Query Every Time

Alright, we’ve covered a lot!

Now you should have a clear understanding of the difference between "view" and "content" in Angular, and how [signal queries](https://angular.dev/guide/components/queries#signal-queries) make working with both simple and reactive.

If you found this helpful, don't forget to [subscribe](https://www.youtube.com/c/briantreese?sub_confirmation=1), and check out [my other Angular tutorials](https://www.youtube.com/@briantreese) for more tips and tricks!

{% include banner-ad.html %}

## Additional Resources

- [The demo app BEFORE any changes](https://stackblitz.com/edit/stackblitz-starters-h6zyxzve?file=src%2Fcard%2Fcard.component.html)
- [The demo app AFTER making changes](https://stackblitz.com/edit/stackblitz-starters-4tad4q3a?file=src%2Fcard%2Fcard.component.html)
- [Content projection in angular](https://angular.dev/guide/components/content-projection)
- [View and content queries](https://angular.dev/guide/components/queries)
- [Angular signals overview](https://angular.dev/guide/signals)
- [My course: “Styling Angular Applications”](https://app.pluralsight.com/library/courses/angular-styling-applications/table-of-contents)

## Want to See It in Action?

Check out the demo code showcasing these techniques in the StackBlitz project below. If you have any questions or thoughts, don’t hesitate to leave a comment.

<iframe src="https://stackblitz.com/edit/stackblitz-starters-4tad4q3a?ctl=1&embed=1&file=src%2Fcard%2Fcard.component.ts" style="height: 500px; width: 100%; margin-bottom: 1.5em; display: block;"></iframe>
