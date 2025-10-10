---
layout: post
title: "Make Any Angular List Draggable in Minutes"
date: "2025-10-09"
video_id: "Jc_ykhsJwnM"
tags:
  - "Angular"
  - "Angular CDK"
  - "Drag and Drop"
  - "Angular Components"
  - "Angular Directives"
---

<p class="intro"><span class="dropcap">E</span>ver built a list in Angular and thought, "It’d be awesome if I could just drag these items around to reorder them?" Well, what if I told you that you can? And it’s ridiculously easy! In this tutorial, we’ll add drag-to-reorder functionality to a todo list using <a href="https://material.angular.dev/cdk/drag-drop/overview" target="_blank">Angular’s CDK</a>. No extra libraries, no complex setup, just clean, modern Angular.</p>

By the end, you’ll have a todo list you can reorder effortlessly using simple directives and one helper function.  

Let’s jump in!

<iframe width="1280" height="720" src="https://www.youtube.com/embed/Jc_ykhsJwnM" frameborder="0" allowfullscreen></iframe>

## Tour the Todo App (Before Drag and Drop)

Here’s [our little app](https://stackblitz.com/edit/stackblitz-starters-u12ltdtd?file=src%2Fapp%2Fapp.html){:target="_blank"}, a simple todo list:

<div>
<img src="{{ '/assets/img/content/uploads/2025/10-09/demo-1.gif' | relative_url }}" alt="The todo list before drag and drop functionality" width="796" height="944" style="width: 100%; height: auto;">
</div>

We can check and uncheck items, and as we do, the remaining count updates right in the header.

That’s powered by a [signal](https://angular.dev/guide/signals){:target="_blank"}, so Angular automatically updates the DOM whenever the value changes.

Now, it looks like you could drag these items around: 

<div>
<img src="{{ '/assets/img/content/uploads/2025/10-09/demo-2.gif' | relative_url }}" alt="The todo list with the grip icon and grab cursor but no drag and drop functionality" width="796" height="754" style="width: 100%; height: auto;">
</div>

I mean, it even has the little "grip" icon and we get the grab cursor when hovering, but if we try to move one… nothing happens.  

Not yet, anyway.

This is what we’ll fix in this tutorial, but first, let’s review the existing code to understand what we’re working with.

## How the Angular Todo List Works 

In [the component’s template](https://stackblitz.com/edit/stackblitz-starters-u12ltdtd?file=src%2Fapp%2Fapp.html){:target="_blank"}, we’ve got a header showing the total task count and remaining count:

```html
<header class="header">
    ...
    <p class="subtle">
        Tasks: {% raw %}{{ todos().length }}{% endraw %} • Remaining: {% raw %}{{ remainingCount() }}{% endraw %}
    </p>
</header>
```

That’s what you see above the list:

<div>
<img src="{{ '/assets/img/content/uploads/2025/10-09/demo-3.jpg' | relative_url }}" alt="The header of the todo list displaying the total tasks and remaining tasks" width="794" height="428" style="width: 100%; height: auto;">
</div>

Then we’ve got the actual list of todos, rendered using a [@for](https://angular.dev/api/core/@for){:target="_blank"} block that creates a list item for each todo in the array:

```html
<ul class="todo-list">
    @for (todo of todos(); track todo.id; let i = $index) {
        <li class="todo-item">
            ...
        </li>
    }
</ul>
```

This is the section we’ll make draggable so we can reorder it.

In [the TypeScript](https://stackblitz.com/edit/stackblitz-starters-u12ltdtd?file=src%2Fapp%2Fapp.ts){:target="_blank"}, we have a signal called `todos`, which is just an array of `Todo` objects:

```typescript
type Todo = { id: string; title: string; done?: boolean };

protected todos = signal<Todo[]>([
    { id: '1', title: 'Pay invoices' },
    { id: '2', title: 'Email onboarding checklist' },
    { id: '3', title: 'Review pull request' },
    { id: '4', title: 'Prep sprint demo' },
]);
```

We also have a `remainingCount` [computed signal](https://angular.dev/guide/signals#computed-signals){:target="_blank"} that filters out completed tasks whenever the todos change:

```typescript
protected remainingCount = computed(() =>
    this.todos().filter(t => !t.done).length);
```

Finally, there’s a simple toggle function that flips the done state when you click a checkbox:

```typescript
protected toggle(t: Todo) {
    this.todos.update(list =>
        list.map(item => (item.id === t.id ? 
            { ...item, done: !item.done } : item))
    );
}
```

So overall, it’s clean, reactive, and modern, but the list order is static. 

Let’s fix that.

## Step 1: Install the Angular CDK for Drag and Drop 

The [Angular CDK](https://material.angular.dev/cdk/categories){:target="_blank"} provides low-level utilities like [accessibility helpers](https://material.angular.dev/cdk/a11y/overview){:target="_blank"}, [overlays](https://material.angular.dev/cdk/overlay/overview){:target="_blank"}, and in our case, [drag-and-drop](https://material.angular.dev/cdk/drag-drop/overview){:target="_blank"}.  

Before we can use it, we just need to install it from within the root of our Angular app using the following command:

```bash
npm install @angular/cdk
```

Once installed, we’re ready to start using CDK directives directly in our component.

## Step 2: Import the CDK Directives

Next, we’ll open the component TypeScript and import the CDK directives we need.  

For drag-and-drop, we’ll import two directives: the [CDKDropList](https://material.angular.dev/cdk/drag-drop/api#CdkDropList){:target="_blank"} and [CDKDrag](https://material.angular.dev/cdk/drag-drop/api#CdkDrag){:target="_blank"}:

```typescript
import { CdkDropList, CdkDrag } from '@angular/cdk/drag-drop';

@Component({
    selector: 'app-root',
    ...,
    imports: [CdkDropList, CdkDrag],
})
```

These imports make the directives available in our template so we can turn any element into a droppable list or a draggable item.

## Step 3: Turn the List into a Drop Zone

Now, let’s make our list droppable.  

We’ll add the `cdkDropList` directive to the list container:

```html
<ul
    cdkDropList
    class="todo-list">
    ...
</ul>
```

This turns the element into a "drop zone". 

Basically, a container that manages draggable items inside it.  

Then, we can listen to the `cdkDropListDropped` event, which fires every time an item is dragged and dropped.  

We’ll call a `drop()` function and pass along the event to handle reordering:

```html
<ul
    cdkDropList
    (cdkDropListDropped)="drop($event)"
    class="todo-list">
    ...
</ul>
```

## Step 4: Make Each Todo Item Draggable

Next up, let’s make each todo draggable.  

Each `<li>` represents one todo, so we’ll add the `cdkDrag` directive there:

```html
<li
    cdkDrag
    class="todo-item">
    ...
</li>
```

That’s all it takes. 

This single attribute allows Angular to track and drag that element.

You don’t even need a drag handle, the entire item can be dragged by default.  

But since we’ve already got that fancy little grip icon, you could turn that into a handle later if you want.

## Step 5: Handle the Drop Event and Reorder the List

Now let’s head back to the TypeScript and add our `drop()` function:

```typescript
import { ..., CdkDragDrop } from '@angular/cdk/drag-drop';

protected drop(event: CdkDragDrop<Todo[]>) {
}
```

This function receives a special [CDKDragDrop](https://material.angular.dev/cdk/drag-drop/api#CdkDragDrop){:target="_blank"} event when the drag operation finishes.  

Inside, we’ll create a new copy of the todos array (to avoid mutating the existing reference):

```typescript
protected drop(event: CdkDragDrop<Todo[]>) {
    const next = [...this.todos()];
}
```

Angular signals detect changes best when a new reference is returned.  

Then, we’ll call the CDK helper function `moveItemInArray()`:

```typescript
import { ..., moveItemInArray } from '@angular/cdk/drag-drop';

protected drop(event: CdkDragDrop<Todo[]>) {
    const next = [...this.todos()];
    moveItemInArray(next, event.previousIndex, event.currentIndex);
}
```

It takes care of moving the dragged item from its previous index to its new position, no manual index juggling or splice logic required.

Then, we just return the new array:

```typescript
protected drop(event: CdkDragDrop<Todo[]>) {
    const next = [...this.todos()];
    moveItemInArray(next, event.previousIndex, event.currentIndex);
    return next;
}
```

And that’s it. 

Our drop function is now complete.

## Step 6: Test Drag and Drop Reordering

Let’s save everything and test it out:

<div>
<img src="{{ '/assets/img/content/uploads/2025/10-09/demo-4.gif' | relative_url }}" alt="The todo list with drag and drop functionality using the Angular CDK" width="796" height="776" style="width: 100%; height: auto;">
</div>

Now when we click and drag one of the tasks, look at that!

It moves smoothly, and when we drop it, Angular re-renders the list in the new order.

We just added drag-to-reorder functionality with **one helper method** and **two directives**.

That’s an amazing tradeoff.

## Step 7: Add Visual Feedback

Right now it works great, but it’s not super clear what’s happening during a drag.

Let’s fix that with a couple of small style tweaks.

In [the component’s stylesheet](https://stackblitz.com/edit/stackblitz-starters-u12ltdtd?file=src%2Fapp%2Fapp.scss){:target="_blank"}, we can style two special classes that the CDK automatically adds during drag operations:

First, we'll add styles using the **cdk-drag-preview** class:

```css
.cdk-drag-preview {
    background: #111827;
    color: #fff;
    border-radius: 10px;
    padding: 8px 12px;
    box-shadow: 0 8px 20px rgba(0, 0, 0, 0.25);
}
```

This is applied to the item being dragged (the floating element that follows your cursor).

This preview will have a darker background and a subtle drop shadow for depth.  

Next, we'll add styles using the **cdk-drag-placeholder** class:

```css
.cdk-drag-placeholder {
    background-color: yellow;
    border: 2px dashed #c7d2fe;
    border-radius: 10px;
    height: 44px;
}
```

This is applied to the space where the dragged item will drop.

This placeholder will be bright yellow so it’s easy to see exactly where the item will land.

We’re going for maximum clarity here, not subtlety.

Okay, now let’s save and try it again!

## Final Test: The Polished Drag-and-Drop Experience

<div>
<img src="{{ '/assets/img/content/uploads/2025/10-09/demo-5.gif' | relative_url }}" alt="The todo list with drag and drop functionality using the Angular CDK and visual feedback" width="794" height="782" style="width: 100%; height: auto;">
</div>

When we drag now, the preview follows our mouse with a dark background, and the yellow placeholder clearly shows the drop location. 
 
It’s so much easier to see what’s happening.

## Wrap-Up: Drag to Reorder Made Easy

And that’s it! We added drag-to-reorder functionality to a todo list using Angular’s CDK.

We...
- Installed the CDK  
- Added the `CdkDropList` and `CdkDrag` directives  
- Handled the dropped event  
- Used `moveItemInArray()` to reorder our data  
- Finished with visual feedback for a smooth experience  

You can take this same approach to reorder anything, from cards in a kanban board to rows in a table, or even playlists in a music app.

If you found this helpful, be sure to [subscribe](https://www.youtube.com/c/briantreese?sub_confirmation=1) for more quick Angular tips! 

And maybe even reorder your todo list so "Keep an eye out for Brian’s next tutorial" is at the top!

{% include banner-ad.html %}

## Additional Resources
- [Angular CDK Drag and Drop Documentation](https://material.angular.dev/cdk/drag-drop/overview){:target="_blank"}
- [moveItemInArray API Reference](https://material.angular.dev/cdk/drag-drop/api#cdk-drag-drop-functions){:target="_blank"}
- [My course "Angular: Styling Applications"](https://www.pluralsight.com/courses/angular-styling-applications){:target="_blank"}
- [My course "Angular in Practice: Zoneless Change Detection"](https://app.pluralsight.com/library/courses/angular-practice-zoneless-change-detection){:target="_blank"}
- [Get a Pluralsight FREE TRIAL HERE!](https://www.jdoqocy.com/click-101557355-17135603){:target="_blank"}

## Try It Yourself

Want to experiment with the final version? Explore the full StackBlitz demo below.  
If you have any questions or thoughts, don’t hesitate to leave a comment.

<iframe src="https://stackblitz.com/edit/stackblitz-starters-g6229xrs?ctl=1&embed=1&file=src%2Fapp%2Fapp.html" style="height: 500px; width: 100%; margin-bottom: 1.5em; display: block;"></iframe>
