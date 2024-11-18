---
layout: post
title: "Stop Using @ViewChild/Children Decorators! Use Signals Instead"
date: "2024-11-08"
video_id: "ZZKaxgUFcxc"
tags: 
  - "Angular"
  - "Angular Signals"
  - "Angular ViewChild"
  - "Angular ViewChildren"
---

<p class="intro"><span class="dropcap">I</span>f you’ve been working with Angular for very long, you’re probably pretty familiar with the <a href="https://angular.dev/api/core/ViewChild#descendants">@ViewChild</a> and <a href="https://angular.dev/api/core/ViewChildren#descendants">@ViewChildren</a> decorators. Well, if you haven’t heard yet, the framework is moving away from these decorators in favor of the new <a href="https://angular.dev/guide/signals/queries#viewchild">viewChild</a> and <a href="https://angular.dev/guide/signals/queries#viewchildren">viewChildren</a> signal query functions. This means that it’s time for us to make the switch! In this tutorial we’ll take an existing example of both decorators and convert them each to the new respective functions.</p>

<iframe width="1280" height="720" src="https://www.youtube.com/embed/ZZKaxgUFcxc" title="" frameborder="0" allow="accelerometer; autoplay; clipboard-write; encrypted-media; gyroscope; picture-in-picture; web-share" allowfullscreen></iframe>

## The Starting Point: Our Current Example

Here we have [this demo application](https://stackblitz.com/edit/stackblitz-starters-wpimwn?file=src%2Fmain.ts) that lists out several notable NBA players:

<div>
<img src="{{ '/assets/img/content/uploads/2024/11-08/demo-1.png' | relative_url }}" alt="Example Angular application" width="826" height="766" style="width: 100%; height: auto;">
</div>

This list is searchable and, when initialized, the search field is automatically focused so that the user can just start typing to filter the list:

<div>
<img src="{{ '/assets/img/content/uploads/2024/11-08/demo-2.png' | relative_url }}" alt="Example of the search textbox focused on initialization using the @ViewChild decorator" width="1092" height="218" style="width: 100%; height: auto;">
</div>

We are currently using the old [@ViewChild](https://angular.dev/api/core/ViewChild#descendants) decorator to accesss the input element and programmatically set focus on initialization.

Also, each of the players visible in this list are displayed using a “[player component](https://stackblitz.com/edit/stackblitz-starters-wpimwn?file=src%2Fplayer%2Fplayer.component.ts)”.

Just below the search field, we are displaying the current number of player components showing in the list, one for each player:

<div>
<img src="{{ '/assets/img/content/uploads/2024/11-08/demo-3.png' | relative_url }}" alt="Example of the player components count displayed using the @ViewChildren decorator" width="854" height="196" style="width: 100%; height: auto;">
</div>

This is probably not something you would do in the real-world, but it’s just something basic that I came up with for the purposes of this tutorial.

Then, as we filter the list, we can see this number updated to properly reflect the changes in the view:

<div>
<img src="{{ '/assets/img/content/uploads/2024/11-08/demo-4.png' | relative_url }}" alt="Example of the player components count updating using the @ViewChildren decorator" width="848" height="474" style="width: 100%; height: auto;">
</div>

This component count is being handled with the old [@ViewChildren](https://angular.dev/api/core/ViewChildren#descendants) decorator and the [QueryList](https://angular.dev/api/core/QueryList) class.

In this tutorial, we are going to convert both of these concepts to use the new [signals-based](https://angular.dev/guide/signals) approach.

Let’s start with the focusing of the search textbox.

## Step 1: Converting the @ViewChild Decorator to the viewChild() Function

Let’s open the [app component template](https://stackblitz.com/edit/stackblitz-starters-wpimwn?file=src%2Fapp.component.html) to look at the code and see how this is currently implemented.

The search field input element has a “#searchField” template reference variable on it.

```html
<input #searchField type="search" id="search" ... />
```

This variable is then used with the [@ViewChild](https://angular.dev/api/core/ViewChild#descendants) decorator to get a handle to the input element.

Let’s look at the [TypeScript](https://stackblitz.com/edit/stackblitz-starters-wpimwn?file=src%2Fapp.component.ts) to see how.

Here's what this decorator currently looks like:

```typescript
@ViewChild('searchField') private searchField?: ElementRef<HTMLInputElement>;
```

This is how we are getting a handle to the input element so that we can programmatically set focus.

We then need to use the [ngAfterViewInit](https://angular.dev/api/core/AfterViewInit) lifecycle hook to wait until we have access to the view to set focus programmatically:

```typescript
ngAfterViewInit() {
    this.searchField?.nativeElement.focus();
}
```

Let’s switch this concept and update it to use [signals](https://angular.dev/guide/signals).

First, we can remove the decorator, then we’ll set this property to a [signal](https://angular.dev/guide/signals) using the new [viewChild](https://angular.dev/guide/signals/queries#viewchild) function. We'll need to be sure to import this function from the @angular/core module.

This [viewChild](https://angular.dev/guide/signals/queries#viewchild) signal will be typed to our existing [ElementRef](https://angular.dev/api/core/ElementRef), [HTMLInputElement](https://developer.mozilla.org/en-US/docs/Web/API/HTMLInputElement) too.

Then, we just need to add our reference variable “searchField” name as a string as the “locator”.

```typescript
import { viewChild } from "@angular/core";

private searchField = viewChild<ElementRef<HTMLInputElement>>('searchField');
```

Ok, at this point, our searchField property is now a [signal](https://angular.dev/guide/signals). So, we can change how focus is set. 

Instead of using the [ngAfterViewInit](https://angular.dev/api/core/AfterViewInit) lifecycle hook, we’ll use the new [effect](https://angular.dev/guide/signals#effects) function which allows us to react to [signal](https://angular.dev/guide/signals) value changes.

We need to add the [effect](https://angular.dev/guide/signals#effects) function within the constructor and we’ll need to be sure that it gets imported from the @angular/core module too.

Within this function we can move our programmatic focus and update it to use the new [signal](https://angular.dev/guide/signals) property by adding parenthesis.

```typescript
import { effect } from "@angular/core";

constructor(...) {
    effect(() => {
        this.searchField()?.nativeElement.focus();
    });
}
```

That’s it.

Now, once we save, we'd see that the search field gets focused when initialized just like we want.

So, it will work exactly like it used to, but instead of using the old decorator, it’s now done using a more modern [signals-based](https://angular.dev/guide/signals) approach.

## Step 2: Converting the @ViewChildren Decorator to the viewChildren() Function

Ok, now let’s update the player components count concept.

First, let’s switch back to the template to see how this is being rendered.

It looks like it’s just a “playerComponentsCount” property that’s being displayed with string interpolation:

```html
<em>Player Components Visible: {% raw %}{{ playerComponentsCount }}{% endraw %}</em>
```

Let’s switch back to the [TypeScript](https://stackblitz.com/edit/stackblitz-starters-wpimwn?file=src%2Fmain.ts) to see how this property is being set.

The “playerComponentsCount” is just a basic number property:

```typescript
protected playerComponentsCount: number = 0;
```

This property is updated in the “updatePlayerComponentsCount()” function.

```typescript
private updatePlayerComponentsCount() {
    this.playerComponentsCount = this.playerComponents?.length ?? 0;
    this.playerComponents?.changes.pipe(takeUntilDestroyed(this.destroyRef))
        .subscribe(components => { 
            this.playerComponentsCount = components.length;
            this.changeDetectorRef.detectChanges();
        });
}
```

This function uses an [observable subscription](https://angular.dev/guide/observables) to the “playerComponents” [QueryList](https://angular.dev/api/core/QueryList) “changes” observable to update the count.

So, every time the [QueryList](https://angular.dev/api/core/QueryList) is updated, the count will be updated to the length of the list.

Ok, now let’s convert this to [signals](https://angular.dev/guide/signals).

First, we should remove the decorator, then the [QueryList](https://angular.dev/api/core/QueryList).

Then, we’ll set this property equal to a [signal query](https://angular.dev/guide/signals/queries) with the new [viewChildren](https://angular.dev/guide/signals/queries#viewchildren) function.

We’ll need to be sure to import it from the @angular/core module as well.

Then, we need to pass it the [PlayerComponent](https://stackblitz.com/edit/stackblitz-starters-wpimwn?file=src%2Fplayer%2Fplayer.component.ts) as its locator:

```typescript
import { viewChildren } from "@angular/core";

private playerComponents = viewChildren(PlayerComponent);
```

Ok, this is now a [signal](https://angular.dev/guide/signals), so we can update how the count gets set.

This is where it gets pretty cool.

Rather than use the function with the whole [observable subscription](https://angular.dev/guide/observables), we can use a new concept where we create a [signal](https://angular.dev/guide/signals) from another [signal](https://angular.dev/guide/signals).

This concept is known as a [computed signal](https://angular.dev/guide/signals#computed-signals).

So, let’s change the “playerComponentsCount” property to use the new [computed](https://angular.dev/guide/signals#computed-signals) function.

We need to be sure that this also gets imported from the @angular/core module like the others.

Any [signals](https://angular.dev/guide/signals) used within this function will be used to update the value of this [signal](https://angular.dev/guide/signals).

So, since our player components list property is now a [signal](https://angular.dev/guide/signals), all we need to do is return its length in this [computed](https://angular.dev/guide/signals#computed-signals) function.

```typescript
import { computed } from "@angular/core";

protected playerComponentsCount = computed(() => this.playerComponents().length);
```

So now, whenever the [viewChildren](https://angular.dev/guide/signals/queries#viewchildren) signal is updated, its value will trigger this [signal](https://angular.dev/guide/signals) to update with its new length.

And this means that we can remove the old "updatePlayerComponentsCount" function, the [ngAfterViewInit](https://angular.dev/api/core/AfterViewInit) function and its imports, the [takeUntilDestroyed](https://angular.dev/api/common/takeUntilDestroyed) function, the [DestroyRef](https://angular.dev/api/core/DestroyRef), and the [ChangeDetectorRef](https://angular.dev/api/core/ChangeDetectorRef) too.

Lastly, we need to add parenthesis to its usage in the template:

#### Before:
```html
<em>Player Components Visible: {% raw %}{{ playerComponentsCount }}{% endraw %}</em>
```

#### After:
```html
<em>Player Components Visible: {% raw %}{{ playerComponentsCount() }}{% endraw %}</em>
```

Ok, that’s it.

When we save now it should all be working as expected.

The count should be correct right out of the gate. Then as we filter, we should still see the count update as the list changes.

So, it should all work just like it did before, but now instead of using the old decorator and [QueryList](https://angular.dev/api/core/QueryList), it's done using a more modern [signals-based](https://angular.dev/guide/signals) approach.

## In Conclusion

The new [viewChild](https://angular.dev/guide/signals/queries#viewchild) and [viewChildren](https://angular.dev/guide/signals/queries#viewchildren) functions are a change for Angular developers for sure.

When switching to [signals](https://angular.dev/guide/signals), it’s a different way of thinking, but these functions are easy to use, powerful, and flexible, and they make working with components and templates a breeze.

So, what are you waiting for? 

Ditch those old decorators for good and update to [signals](https://angular.dev/guide/signals) with these new [signal query functions](https://angular.dev/guide/signals/queries) instead!

Alright, I hope you found this tutorial helpful!

Don't forget to check out [my other Angular tutorials](https://www.youtube.com/@briantreese) for more tips and tricks.

## Additional Resources
* [The demo BEFORE making any changes](https://stackblitz.com/edit/stackblitz-starters-wpimwn?file=src%2Fmain.ts)
* [The demo AFTER making changes](https://stackblitz.com/edit/stackblitz-starters-1mx1ky?file=src%2Fmain.ts)
* [Angular Signal queries documentation](https://angular.dev/guide/signals/queries)

## Want to See It in Action?
Check out the demo code and examples of these techniques in the in the Stackblitz example below. If you have any questions or thoughts, don’t hesitate to leave a comment.

<iframe src="https://stackblitz.com/edit/stackblitz-starters-1mx1ky?ctl=1&embed=1&file=src%2Fmain.ts" style="height: 500px; width: 100%; margin-bottom: 1.5em; display: block;"></iframe>
