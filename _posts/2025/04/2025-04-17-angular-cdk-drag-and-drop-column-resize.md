---
layout: post
title: "How to Build a Resizable Sidebar in Angular (Step-by-Step)"
date: "2025-04-17"
video_id: "N8j1JQnJTjw"
tags:
  - "Angular"
  - "Angular CDK"
  - "Drag and Drop"
  - "Angular Components"
---

<p class="intro"><span class="dropcap">H</span>ey everyone, in this tutorial, we’re going to add a resizable sidebar to an existing Angular app, and we’re going to do it using just the <a href="https://material.angular.io/cdk/categories">Angular CDK</a>. No random libraries or weird hacks. If you’ve ever wanted to create a sidebar like the ones you see in <a href="https://code.visualstudio.com/">VS Code</a> or design tools, where you can click and drag to resize the panel, that’s exactly what we’ll be building.</p>

<iframe width="1280" height="720" src="https://www.youtube.com/embed/fTejxZ6W-90" title="" frameborder="0" allow="accelerometer; autoplay; clipboard-write; encrypted-media; gyroscope; picture-in-picture; web-share" allowfullscreen></iframe>

## Step 1: Install the Angular CDK (Drag and Drop Module)

Now before we get into the code, I do want to mention that the features you’ll see in this example depend on the [Angular CDK](https://material.angular.io/cdk/categories), specifically the [Drag and Drop module](https://material.angular.io/cdk/drag-drop/overview).

So, if you’re following along in your own project, you’ll want to run the command below to install the [Angular CDK](https://material.angular.io/cdk/categories):

```bash
npm install @angular/cdk
```

For this example, I’ve already installed it in [the demo project](https://stackblitz.com/edit/stackblitz-starters-oj28mspa?file=src%2Fsidebar-resize%2Fsidebar-resize.component.ts), but make sure it’s installed in your own app before continuing.

## Step 2: Previewing the Current Layout

Alright, here’s what [the existing app](https://stackblitz.com/edit/stackblitz-starters-oj28mspa?file=src%2Fsidebar-resize%2Fsidebar-resize.component.ts) looks like, it's got a very basic layout with a main column on the right and a sidebar on the left:

<div>
<img src="{{ '/assets/img/content/uploads/2025/04-17/demo-1.png' | relative_url }}" alt="A screenshot of the existing app layout with two columns" width="1304" height="980" style="width: 100%; height: auto;">
</div>

Now, it might be a little difficult to tell which column is which, right now, but we’ll fix that soon.

Also, there’s a visual resizer bar between the two columns, but it doesn’t actually do anything yet:

<div>
<img src="{{ '/assets/img/content/uploads/2025/04-17/demo-2.png' | relative_url }}" alt="A screenshot of the resizer bar between the two columns" width="820" height="330" style="width: 100%; height: auto;">
</div>

Let’s change that.

For this example, I’ve already created a [sidebar-resize component](https://stackblitz.com/edit/stackblitz-starters-oj28mspa?file=src%2Fsidebar-resize%2Fsidebar-resize.component.ts) that holds the basic layout we’re seeing here.

This is where we’ll add the logic to make the sidebar resizable.

So, let’s take a look at the code we’re starting with:

```typescript
import { Component } from "@angular/core";

@Component({
  selector: "app-sidebar-resize",
  templateUrl: "./sidebar-resize.component.html",
  styleUrl: "./sidebar-resize.component.scss",
})
export class SidebarResizeComponent {}
```

You can see there’s no drag logic yet, there’s actually no logic at all, it’s just a plain shell of a component.

So, we’ll build this up step-by-step.

### Understanding the Sidebar Resize Component Template

Next, let’s take a quick look at the template:

```html
<main>
  <ng-content select="[slot-main]"></ng-content>
</main>
<aside>
  <ng-content select="[slot-sidebar]"></ng-content>
  <div class="resizer">
    <span class="drag-icon">⠿</span>
  </div>
</aside>
```

We’ve got a [main element](https://developer.mozilla.org/en-US/docs/Web/HTML/Element/main) that holds the main column content:

```html
<main>
  <ng-content select="[slot-main]"></ng-content>
</main>
```

It uses [content projection]({% post_url /2025/02/2025-02-06-content-projection-in-angular %}) to find an element with the "slot-main" attribute and project that content into this region.

We also have an [aside element](https://developer.mozilla.org/en-US/docs/Web/HTML/Element/aside) for the sidebar content, which also uses [content projection]({% post_url /2025/02/2025-02-06-content-projection-in-angular %}) with the "slot-sidebar" attribute:

```html
<aside>
  <ng-content select="[slot-sidebar]"></ng-content>
</aside>
```

Inside the sidebar, we’ve got a div with a “resizer” class:

```html
<div class="resizer">
  <span class="drag-icon">⠿</span>
</div>
```

This is the visual edge between the two columns, and it’s what we’ll make draggable.

### How the Layout Is Composed Using Slot-Based Content

Now let’s look at the [main app root component](https://stackblitz.com/edit/stackblitz-starters-oj28mspa?file=src%2Fmain.ts) so we can see how the component gets used:

```typescript
@Component({
  selector: 'app-root',
  template: `
    <app-sidebar-resize>
      <div slot-main>
        ...
      </div>
      <div slot-sidebar>
        ...
      </div>
    </app-sidebar-resize>
  `
})
```

In the template for this component, we’re using the [sidebar-resize component](https://stackblitz.com/edit/stackblitz-starters-oj28mspa?file=src%2Fsidebar-resize%2Fsidebar-resize.component.ts).

The main column content is wrapped in a div with the "slot-main" attribute:

```html
<div slot-main>...</div>
```

Then, there’s the sidebar content in the div with the “slot-sidebar” attribute:

```html
<div slot-sidebar>...</div>
```

So that’s the basic set-up, now let’s make it resizable!

## Step 3: Adding the Resizable Sidebar with Angular CDK

Let’s jump back to the [sidebar-resize component](https://stackblitz.com/edit/stackblitz-starters-oj28mspa?file=src%2Fsidebar-resize%2Fsidebar-resize.component.ts) TypeScript and start building this out.

First up, we’ll add a "defaultWidth" property:

```typescript
export class SidebarResizeComponent {
  protected defaultWidth = 250;
}
```

This will be the initial width of our sidebar, and also the value we reset to later.

Next, let’s create a [signal](https://angular.dev/guide/signals) to hold the current width, and we’ll initialize it to the default value:

```typescript
import { ..., signal } from '@angular/core';

export class SidebarResizeComponent {
  ...
  protected currentWidth = signal(this.defaultWidth);
}
```

This will let us reactively bind the sidebar’s width in the template and update it when the user drags the resizer.

Now let’s add the logic that will be triggered by the [Angular CDK drag directive](https://material.angular.io/cdk/drag-drop/api#CdkDrag) to actually resize the columns.

We’ll add a function named "onDragMoved", and it’ll take a parameter named “event” which will be typed to a [CdkDragMove](https://material.angular.io/cdk/drag-drop/api#CdkDragMove) event.

When this function is called, we’ll respond to the drag event from the CDK and use the pointer’s x-position to update the sidebar width:

```typescript
import { CdkDragMove } from '@angular/cdk/drag-drop';

export class SidebarResizeComponent {
  ...
  protected onDragMoved(event: CdkDragMove) {
    this.currentWidth.set(event.pointerPosition.x);
  }
}
```

Here, `pointerPosition.x` gives us the horizontal cursor position on the page, which we can simply treat as the new width of the sidebar.

But we also need to fix a small quirk when using the [CDK Drag directive](https://material.angular.io/cdk/drag-drop/api#CdkDrag) for resizing like this.

The directive applies a [translate3d()](https://developer.mozilla.org/en-US/docs/Web/CSS/transform-function/translate3d) style to the dragged element, and if we don’t remove it, the resizer can visually drift away from the edge of the sidebar.

So right after setting the width, we’ll get the dragged element from the event and then we’ll reset the [transform](https://developer.mozilla.org/en-US/docs/Web/CSS/transform) style:

```typescript
export class SidebarResizeComponent {
  ...
  protected onDragMoved(event: CdkDragMove) {
    ...
    const element = event.source.element.nativeElement;
    element.style.transform = 'none';
  }
}
```

This will keep the handle visually pinned to the edge of the sidebar.

### Importing the DragDropModule for Drag Support

At this point, we’re finally ready to use the Angular CDK’s [drag directive](https://material.angular.io/cdk/drag-drop/api#CdkDrag) in our template, but before we do that, we need to import the [DragDropModule](https://material.angular.io/cdk/drag-drop/api#DragDropModule).

So let’s add it to the component’s imports array:

```typescript
import { ..., DragDropModule } from '@angular/cdk/drag-drop';

@Component({
  selector: 'app-sidebar-resize',
  ...
  imports: [ DragDropModule ],
})
```

Cool, now we can hook up the HTML.

### Wiring Up the Drag Behavior in the Template

First, let’s find the “resizer” div and add the [CdkDrag directive](https://material.angular.io/cdk/drag-drop/api#CdkDrag):

```html
<div class="resizer" cdkDrag>...</div>
```

This directive gives us a low-overhead way to track pointer movement across mouse and touch devices.

On [this directive](https://material.angular.io/cdk/drag-drop/api#CdkDrag) there are a few different events available, but the one we need here is `cdkDragMoved`.

This event fires every time the user drags, which can be a lot, so be careful using it in high-cost operations, but for this use case, it’s exactly what we want.

Now, when this event fires, it will fire with a [CdkDragMove](https://material.angular.io/cdk/drag-drop/api#CdkDragMove) event, so we can simply call our "onDragMoved" method and pass it the event:

```html
<div class="resizer" cdkDrag (cdkDragMoved)="onDragMoved($event)">...</div>
```

Now, for the last step, on the [aside element](https://developer.mozilla.org/en-US/docs/Web/HTML/Element/aside), I’ll use [style binding](https://angular.dev/guide/templates/binding#css-style-properties) to bind the width to the `currentWidth()` [signal](https://angular.dev/guide/signals):

```html
<aside [style.width.px]="currentWidth()">...</aside>
```

So now, whenever the [signal](https://angular.dev/guide/signals) changes, the width style will update automatically.

Okay, this thing should be resizable at this point, let’s save everything and check it out in the browser:

<div>
<img src="{{ '/assets/img/content/uploads/2025/04-17/demo-3.gif' | relative_url }}" alt="An example of simple resizable columns in Angular using the CDK" width="912" height="1078" style="width: 100%; height: auto;">
</div>

Nice! At first glance, it still looks similar, but now, when I click and drag the handle, the sidebar resizes in real time.

Pretty cool right?

It’s smooth, it’s responsive, and we didn’t need any third-party libraries or anything complicated.

## Step 4: Adding a Reset Button to Restore Default Width

What I’d like to do now is let users reset the layout to the original column widths.

Let’s take this one step further and add a “Reset” button.

Let’s switch back over to the TypeScript for the [sidebar-resize component](https://stackblitz.com/edit/stackblitz-starters-oj28mspa?file=src%2Fsidebar-resize%2Fsidebar-resize.component.ts).

Here, let’s add a new “reset” method.

When this method is called, all we need to do is set the `currentWidth()` [signal](https://angular.dev/guide/signals) back to the `defaultWidth` property:

```typescript
export class SidebarResizeComponent {
  ...
  protected reset() {
    this.currentWidth.set(this.defaultWidth);
  }
}
```

Now let’s jump back to the template and add a button labeled “Reset.”

Then we’ll use a [click event binding](https://angular.dev/guide/templates/event-listeners) to call our "reset" method when the button is clicked:

```html
<button (click)="reset()">Reset</button>
```

Okay, that should be everything we need, let’s save again and give it a shot:

<div>
<img src="{{ '/assets/img/content/uploads/2025/04-17/demo-4.gif' | relative_url }}" alt="An example of a resizable sidebar with a reset button in Angular using the CDK" width="1168" height="1076" style="width: 100%; height: auto;">
</div>

Cool, now we have the “reset” button at the top of the sidebar and when we resize and then click Reset, boom — the sidebar snaps right back to its original width.

## Wrap-Up: What You Learned and Where to Go Next

And that’s it! We just built a clean, fully functional resizable sidebar using Angular CDK’s [DragDropModule](https://material.angular.io/cdk/drag-drop/overview), a couple of [signals](https://angular.dev/guide/signals), and some simple width logic.

And if you want to take it further, you could easily extend this to support vertical resizing, or even persist the sidebar width using [localStorage](https://developer.mozilla.org/en-US/docs/Web/API/Window/localStorage).

Who knows, I might make a follow-up tutorial showing exactly that.

If you found this helpful, don't forget to [subscribe](https://www.youtube.com/c/briantreese?sub_confirmation=1) and check out [my other Angular tutorials](https://www.youtube.com/@briantreese) for more tips and tricks!

{% include banner-ad.html %}

## Additional Resources

- [The demo app BEFORE any changes](https://stackblitz.com/edit/stackblitz-starters-oj28mspa?file=src%2Fsidebar-resize%2Fsidebar-resize.component.ts)
- [The demo app AFTER making changes](https://stackblitz.com/edit/stackblitz-starters-sbcrprky?file=src%2Fsidebar-resize%2Fsidebar-resize.component.ts)
- [Angular CDK Drag and Drop Documentation](https://material.angular.io/cdk/drag-drop/overview)
- [The Angular CdkDrag Directive](https://material.angular.io/cdk/drag-drop/api#CdkDrag)
- [Angular Signals Overview](https://angular.dev/guide/signals)
- [Content Projection in Angular](https://angular.dev/guide/components/content-projection)
- [My course: “Styling Angular Applications”](https://app.pluralsight.com/library/courses/angular-styling-applications/table-of-contents)

## Want to See It in Action?

Check out the demo code showcasing these techniques in the StackBlitz project below. If you have any questions or thoughts, don’t hesitate to leave a comment.

<iframe src="https://stackblitz.com/edit/stackblitz-starters-sbcrprky?ctl=1&embed=1&file=src%2Fsidebar-resize%2Fsidebar-resize.component.ts" style="height: 500px; width: 100%; margin-bottom: 1.5em; display: block;"></iframe>
