---
layout: post
title: "Using @HostBinding with Signals"
date: "2024-05-25"
video_id: "pkLY8ET9_5A"
tags: 
  - "Angular"
---

<p class="intro"><span class="dropcap">I</span>f you’re building apps with Angular, you’re probably using <a href="https://angular.dev/guide/signals">signals</a> more and more every day. This can definitely be a challenge at times because it’s such a different way of working. And, there are things that just don’t quite work with <a href="https://angular.dev/guide/signals">signals</a> yet, like <a href="https://angular.dev/api/core/HostBinding">@HostBinding</a> for example. Well in this post, I’m going to demonstrate how we can actually use the <a href="https://angular.dev/api/core/HostBinding">@HostBinding</a> decorator with <a href="https://angular.dev/guide/signals">signals</a>, pretty easily right now even though the decorator was not originally built to support them directly. Alright, let’s get to it.</p>

<iframe width="1280" height="720" src="https://www.youtube.com/embed/pkLY8ET9_5A" title="" frameborder="0" allow="accelerometer; autoplay; clipboard-write; encrypted-media; gyroscope; picture-in-picture; web-share" allowfullscreen></iframe>

## The Demo Application

Ok, before we do anything, let’s take a look at the [example application](https://stackblitz.com/edit/stackblitz-starters-vc7zpx?file=src%2Flist-item%2Flist-item.component.ts) that we’ll be working with in this post. Here we have a simple application with a list of items to complete. We can mark the items complete by clicking the button next to each step. And when all items have been marked complete, we display a message notifying the user that everything is done.

<div>
<img src="{{ '/assets/img/content/uploads/2024/05-25/demo-1.gif' | relative_url }}" alt="Example of a demo application with @HostBinding decorator before converting to signals" width="592" height="432" style="width: 100%; height: auto;">
</div>

Now, we’ll see this in more detail soon, but this app is in the process of migrating to [signals](https://angular.dev/guide/signals). In this post we’re going to convert it over the rest of the way and in the process, we’ll need to update a [@HostBinding](https://angular.dev/api/core/HostBinding) on our list items based on a [signal input](https://angular.dev/guide/signals/inputs). Ok, first let’s familiarize ourselves with the existing code for this app.

## Using @Hostbinding with a Signal Input

Let’s start with the app component itself. Looking at the template we can see that we have three instances of our list item component. One for each of the items to be completed.

#### main.ts
```html
<app-list-item ...>
    First, do something...
</app-list-item>
<app-list-item ...>
    Next, do something else...
</app-list-item>
<app-list-item ...>
    After that, you're finished...
</app-list-item>
```

For each of the list items, we have a corresponding boolean property for whether that step is complete or not. And, these properties have already been converted to [signals](https://angular.dev/guide/signals).

```typescript
import { ..., signal } from '@angular/core';

@Component({
  selector: 'app-root'
  ...
})
export class App {
    step1Complete = signal(false);
    step2Complete = signal(false);
    step3Complete = signal(false);
}
```

Now, when the button in each of these items is clicked, it toggles the complete property for that list item.

```html
<button (click)="step1Complete.set(!step1Complete())">
    ...
</button>
```

And this value is passed as an input to the list item component.

```html
<app-list-item [step]="1" [isComplete]="step1Complete()">
    ...
</app-list-item>
```

Then, at the bottom of the template, once all of the steps are complete, a message will display.

```html
<div [class.visible]="step1Complete() && step2Complete() && step3Complete()" class="success">
      <h2>Thank You!</h2>
      All steps have been completed
</div>
```

So that’s the app component, and since everything here has been converted to [signals](https://angular.dev/guide/signals) already, we don’t need to do anything more here. So now, let’s look at the list item component.

In this component, we still have two inputs using the old [@Input](https://angular.dev/api/core/Input) decorator. First, we’ve got the input for the “step” number, then we have the input for the for the “isComplete” property which is also a [@HostBinding](https://angular.dev/api/core/HostBinding) for a “complete” class. So, when that input is true, the “complete” class will be added to the host, which is how it turns everything within it green.

#### list-item.component.ts
```typescript
@Component({
    selector: 'app-list-item'
    ...
})
export class ListItemComponent {
    @Input({ required: true }) step!: number;
    @Input() @HostBinding('class.complete') isComplete = false;
}
```

### Converting Decorator Inputs to Signal Inputs

So, the “step” property will be pretty easy to switch over to a [signal input](https://angular.dev/guide/signals/inputs) but the “isComplete” property will be a little more challenging. So let’s start with the “step” property.

We can begin by removing the decorator, then we just need to set it using the input function, and we’ll need to make sure that function gets imported correctly. Then, we’ll want to make it required, and we’ll type it to a number.

```typescript
import { ..., input } from "@angular/core";

@Component({
    selector: 'app-list-item'
    ...
})
export class ListItemComponent {
    step = input.required<number>();
    ...
}
```

That’s pretty much it, we just need to update the value in the template now that it’s a [signal](https://angular.dev/guide/signals).

#### Before:
```html
<strong>{% raw %}{{ step }}{% endraw %}.)</strong>
```

#### After:
```html
<strong>{% raw %}{{ step() }}{% endraw %}.)</strong>
```

Now, after we save, everything should look the same, but it'll now be done in a more modern way with [signal inputs](https://angular.dev/guide/signals/inputs).

Now, at some point the Angular team will probably have a native solution for [signals](https://angular.dev/guide/signals) with [@HostBinding](https://angular.dev/api/core/HostBinding), but for the time being we need to be a little clever.

One way we could do it is, we could use a [getter function](https://www.typescripttutorial.net/typescript-tutorial/typescript-getters-setters/) and simply return the value of the [signal input](https://angular.dev/guide/signals/inputs) in that function. That would work but it would run more than it needs to.

Instead, we can use an [effect()](https://angular.dev/api/core/effect). This way it will be optimized to only update when the value of the [signal input](https://angular.dev/guide/signals/inputs) has changed. And that’s what we’re going to do here.

### Using an effect() to Update the @HostBinding when the Signal Changes

Ok first, let’s set our “isComplete” property to a Boolean input. Then, we need to add a new property for our class [@HostBinding](https://angular.dev/api/core/HostBinding), let’s call it “hasCompleteClass”, and let’s initialize it to false.

```typescript
@Component({
    selector: 'app-list-item'
    ...
})
export class ListItemComponent {
    ...
    isComplete = input(false);
    @HostBinding('class.complete') hasCompleteClass = false;
}
```

Now we can add the [effect()](https://angular.dev/api/core/effect) to update this property when the “isComplete” input value changes. To do this, we need to add a constructor first. Then, we can add the [effect()](https://angular.dev/api/core/effect) function, and we need to make sure it gets imported properly from Angular core. Within the [effect()](https://angular.dev/api/core/effect) callback, all we need to do is set our “hasCompleteClass” property to the value of the “isComplete” [signal input](https://angular.dev/guide/signals/inputs).

```typescript
import { ..., effect } from "@angular/core";

@Component({
    selector: 'app-list-item'
    ...
})
export class ListItemComponent {
    ...
    
    constructor() {
        effect(() => this.hasCompleteClass = this.isComplete());
    }
}
```

And that’s all we need. Since we’re using the [effect()](https://angular.dev/api/core/effect) function, it will run only when the “isComplete” value changes.

Ok, last thing we need to do is remove the old [@Input](https://angular.dev/api/core/Input) decorator and import since we’re no longer using it.

Now when we save, we should everything working correctly like it was before these changes, but it’s all using [signals](https://angular.dev/guide/signals) now.

## Conclusion

So, that’s one way you can use [signals](https://angular.dev/guide/signals) and [@HostBinding](https://angular.dev/api/core/HostBinding) for the time being. Like I said earlier though, at some point there will probably be an even better way to do this but at least you have a pretty slick way to do it until that time comes.

Hope that helps you as you build using signals.

## Want to See It in Action?
Check out the demo code and examples of these techniques in the in the Stackblitz example below. If you have any questions or thoughts, don’t hesitate to leave a comment.

<iframe src="https://stackblitz.com/edit/stackblitz-starters-4tstsd?ctl=1&embed=1&file=src%2Flist-item%2Flist-item.component.ts" style="height: 500px; width: 100%; margin-bottom: 1.5em; display: block;">
