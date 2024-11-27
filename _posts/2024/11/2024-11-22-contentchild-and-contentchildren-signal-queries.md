---
layout: post
title: "Don’t Use @ViewChild/Children Decorators! Use Signals Instead"
date: "2024-11-22"
video_id: "Mi-G-wwaFXY"
tags: 
  - "Angular"
  - "Angular Signals"
  - "Angular ContentChild"
  - "Angular ContentChildren"
---


<p class="intro"><span class="dropcap">H</span>ey there Angular folks, and welcome back! In this tutorial, we’re tackling an exciting update in Angular: how to modernize your components by migrating from the traditional <a href="https://angular.dev/api/core/ContentChild">@ContentChild</a> and <a href="https://angular.dev/api/core/ContentChildren">@ContentChildren</a> decorators, and <a href="https://angular.dev/api/core/QueryList">QueryList</a>, to the new signal-based <a href="https://angular.dev/guide/components/queries#content-queries">contentChild</a> and <a href="https://angular.dev/guide/components/queries#content-queries">contentChildren</a> functions.</p>

<iframe width="1280" height="720" src="https://www.youtube.com/embed/Mi-G-wwaFXY" title="" frameborder="0" allow="accelerometer; autoplay; clipboard-write; encrypted-media; gyroscope; picture-in-picture; web-share" allowfullscreen></iframe>

We’ll explore how these new features work, why they’re helpful, and walk you through a couple of examples to help it all make sense.

Now, recently I created [another tutorial]({% post_url /2024/11/2024-11-08-viewchild-and-viewchildren-signal-queries %}) where we converted the [@ViewChild](https://angular.dev/api/core/ViewChild#descendants) and [@ViewChildren](https://angular.dev/api/core/ViewChildren#descendants) decorators over to [signals](https://angular.dev/guide/signals), so this tutorial will look a little bit familiar, but this time we’ll be dealing with a component’s “[projected content](https://angular.dev/guide/components/content-projection)” instead its “view” a.k.a. [the template](https://angular.dev/guide/components#showing-components-in-a-template).

Ok, let’s get started!

## The Starting Point: Our Current Example 

Like several of my other tutorials, we’ll be using [a demo app](https://stackblitz.com/edit/stackblitz-starters-qwnsgk?file=src%2Fsearch-layout%2Fsearch-layout.component.ts) that lists out several NBA players:

<div>
<img src="{{ '/assets/img/content/uploads/2024/11-22/demo-1.png' | relative_url }}" alt="Example Angular application" width="826" height="766" style="width: 100%; height: auto;">
</div>

It has a search field that can be used to filter the list of players and, when the app is initialized, the search field is automatically focused:

<div>
<img src="{{ '/assets/img/content/uploads/2024/11-22/demo-2.png' | relative_url }}" alt="Example of the search textbox focused on initialization using the @ContentChild decorator" width="1092" height="218" style="width: 100%; height: auto;">
</div>

Now, we’ll see how in a minute, but this programmatic focus is currently handled with the [@ContentChild](https://angular.dev/api/core/ContentChild) decorator.

The data for each of the players in this list is formatted with a "[player component](https://stackblitz.com/edit/stackblitz-starters-qwnsgk?file=src%2Fplayer%2Fplayer.component.ts)".

Currently we are using the [@ContentChildren](https://angular.dev/api/core/ContentChildren) decorator and the [QueryList](https://angular.dev/api/core/QueryList) class to provide the total count of player components visible in the list and we are displaying this count right under the search field:

<div>
<img src="{{ '/assets/img/content/uploads/2024/11-08/demo-3.png' | relative_url }}" alt="Example of the player components count displayed using the @ContentChildren decorator" width="854" height="196" style="width: 100%; height: auto;">
</div>

Probably not exactly something that you would want to do in the real-world but it should work just fine for the purposes of this demo.

So that’s what we’re starting with, now let’s convert these both over to the new [signals-based](https://angular.dev/guide/signals) method instead.

Let’s start with the programmatic focus of the search field.

## Step 1: Converting the @ContentChild Decorator to the contentChild() Function

To begin, let’s open the [app component template](https://stackblitz.com/edit/stackblitz-starters-qwnsgk?file=src%2Fapp.component.html).

Here’s the search field input element:

```html
<app-search-layout>
    <ng-container search-form>
        <label for="search">Search Players</label>
        <input 
            #searchField 
            type="search" 
            id="search" 
            autocomplete="off" 
            [(ngModel)]="searchText" 
            [formControl]="search" 
            placeholder="Search by entering a player name" />
    </ng-container>
    ...
</app-search-layout>
```

We can see that this input is placed within a parent [search-layout.component](https://stackblitz.com/edit/stackblitz-starters-qwnsgk?file=src%2Fsearch-layout%2Fsearch-layout.component.html).

Then, within this component we have two slots, one for the “search-form”, and another for the “search-list”.

```html
<app-search-layout>
    <ng-container search-form>
      ...
    </ng-container>
    <ng-container search-list>
      ...
    </ng-container>
</app-search-layout>
```

This means these items are within the “content” of the [search-layout.component](https://stackblitz.com/edit/stackblitz-starters-qwnsgk?file=src%2Fsearch-layout%2Fsearch-layout.component.html) as opposed to the “view”.

Also important to note here, we have a “searchField” template reference variable that we use to get a handle to this input element when using the [@ContentChild](https://angular.dev/api/core/ContentChild) decorator:

```html
<input #searchField ... />
```

Ok, so how and where is the focus getting applied?

Well, this is happening in our [search-layout.component](https://stackblitz.com/edit/stackblitz-starters-qwnsgk?file=src%2Fsearch-layout%2Fsearch-layout.component.ts).

Here, we’re using the [@ContentChild](https://angular.dev/api/core/ContentChild) decorator to query for the “searchField” template reference variable:

```typescript
@ContentChild('searchField') private searchField?: ElementRef<HTMLInputElement>;
```

Then, we use the [AfterContentInit](https://angular.dev/api/core/AfterContentInit) lifecycle hook to access the native element and set programmatic focus:

```typescript
ngAfterContentInit() {
    this.searchField?.nativeElement.focus();
}
```

Let’s switch this concept and update it to use [signals](https://angular.dev/guide/signals).

First, we can remove the decorator. Then we’ll set this property to a [signal](https://angular.dev/guide/signals) using the new [contentChild()](https://angular.dev/guide/components/queries#content-queries) function.

We need to be sure to import this function from the @angular/core module too.

This [contentChild()](https://angular.dev/guide/components/queries#content-queries) signal will be typed to our existing [ElementRef](https://angular.dev/api/core/ElementRef), [HTMLInputElement](https://developer.mozilla.org/en-US/docs/Web/API/HTMLInputElement).

Then, we just need to add our reference variable “searchField” as the “locator”:

```typescript
import { ..., contentChild } from '@angular/core';

private searchField = contentChild<ElementRef<HTMLInputElement>>('searchField');
```

And that’s it, this is now a [signal](https://angular.dev/guide/signals).

So now that it’s a signal, we can switch away from the [AfterContentInit](https://angular.dev/api/core/AfterContentInit) lifecycle function.

Instead, we can use the [effect()](https://angular.dev/guide/signals#effect) function which allows us to react to [signal](https://angular.dev/guide/signals) value changes.

And we’ll need to be sure that it gets imported from the @angular/core module as well.

Within this function we can move our programmatic focus and update it to use the new signal property by adding parenthesis:

```typescript
import { ..., effect } from '@angular/core';

constructor() {
    effect(() => {
        this.searchField()?.nativeElement.focus();
    })
}
```

That’s it.

Now, once we save, we'd see that the search field gets focused when initialized just like we want.

So, it will work exactly like it used to, but instead of using the old decorator, it’s now done using a more modern [signals-based](https://angular.dev/guide/signals) approach.

## Step 2: Converting the @ContentChildren Decorator to the contentChildren() Function

Ok, now let’s update the player components count concept. 

First let’s understand how it’s working currently.

Let’s switch back to the [app component template](https://stackblitz.com/edit/stackblitz-starters-qwnsgk?file=src%2Fapp.component.html).

Ok, here in the “search-list” slot region for the [search-layout.component](https://stackblitz.com/edit/stackblitz-starters-qwnsgk?file=src%2Fsearch-layout%2Fsearch-layout.component.html), we have a [for loop](https://angular.dev/api/core/@for) that loops out a list of player components:

```html
<ng-container search-list>
    @for (player of filteredPlayers(); track player.name) {
        <app-player [player]="player"></app-player>
    } @empty {
        <p>Sorry, we couldn't find any players with the name you entered</p>
    }
  </ng-container>
```

So, these are also within the “content” of the [search-layout.component](https://stackblitz.com/edit/stackblitz-starters-qwnsgk?file=src%2Fsearch-layout%2Fsearch-layout.component.html).

But in this case there are potentially multiple of these components depending on how the list is filtered, so we are using the [@ContentChildren](https://angular.dev/api/core/ContentChildren) decorator for this instead of the [@ContentChild](https://angular.dev/api/core/ContentChild) decorator.

Let’s switch back to the [search-layout.component](https://stackblitz.com/edit/stackblitz-starters-qwnsgk?file=src%2Fsearch-layout%2Fsearch-layout.component.ts) TypeScript to see how this is being set.

Ok, here we have the a “playerComponents” private field that’s set using the [@ContentChildren](https://angular.dev/api/core/ContentChildren) decorator and the [QueryList](https://angular.dev/api/core/QueryList) class to query for all “player components”:

```typescript
@ContentChildren(PlayerComponent) private playerComponents?: QueryList<PlayerComponent>;
```

We also have this “playerComponentsCount” property:

```typescript
protected playerComponentsCount: number = 0;
```

To set this property, we have this “updatePlayerComponentsCount()” function:

```typescript
private updatePlayerComponentsCount() {
    this.playerComponentsCount = this.playerComponents?.length ?? 0;
    this.playerComponents?.changes.pipe(takeUntilDestroyed(this.destroyRef))
      .subscribe(components => this.playerComponentsCount = components.length);
}
```

This function uses an [observable](https://angular.dev/guide/observables) subscription to the “playerComponents” [QueryList](https://angular.dev/api/core/QueryList) “changes” [observable](https://angular.dev/guide/observables) to update the count.

So, every time the [QueryList](https://angular.dev/api/core/QueryList) is updated, the count will be updated to the length of the list.

Then, if we switch over to the [template for this component](https://stackblitz.com/edit/stackblitz-starters-qwnsgk?file=src%2Fsearch-layout%2Fsearch-layout.component.html), we can see that we’re simply rendering the value of this property with string interpolation:

```html
<p>Player Count: {% raw %}{{ playerComponentsCount }}{% endraw %}</p>
```

Ok, now let’s convert this to [signals](https://angular.dev/guide/signals).

First, let’s remove the [@ContentChildren](https://angular.dev/api/core/ContentChildren) decorator and [QueryList](https://angular.dev/api/core/QueryList) class.

Then we’ll set this [signal](https://angular.dev/guide/signals) with the new [contentChildren()](https://angular.dev/guide/components/queries#content-queries) function.

And, we’ll need to be sure to import this from @angular/core as well.

Then, we need to pass it the "PlayerComponent" as its locator:

```typescript
import { ..., contentChildren } from '@angular/core';

private playerComponents = contentChildren(PlayerComponent);
```

Ok, this is now a [signal](https://angular.dev/guide/signals), so we can update how the count gets set.

And this is my favorite part of the demo because we can simplify things quite a bit.

Rather than use the function with the [observable](https://angular.dev/guide/observables) subscription, we can use a new concept where we create a [signal](https://angular.dev/guide/signals) from another [signal](https://angular.dev/guide/signals) with the [computed()](https://angular.dev/guide/signals#computed) function.

Just like the others, we need to import it from @angular/core too:

```typescript
import { ..., computed } from '@angular/core';

protected playerComponentsCount = computed(() => {});
```

Now, anytime the [signals](https://angular.dev/guide/signals) added within this function change, this signal value will be updated too, based on the values of the associated [signals](https://angular.dev/guide/signals).

Since our player components list is now a [signal](https://angular.dev/guide/signals), all we need to do is return its length in this computed function:

```typescript
protected playerComponentsCount = computed(() => this.playerComponents().length);
```

This means that we can remove the old function, the [AfterContentInit](https://angular.dev/api/core/AfterContentInit) function and its imports, the [takeUntilDestroyed](https://angular.dev/api/core/takeUntilDestroyed) function and its imports, and the [DestroyRef](https://angular.dev/api/core/DestroyRef) too.

Then, we just need to switch to the template and add parenthesis to the usage of this counts property:

```html
<em>Player Components Visible: {% raw %}{{ playerComponentsCount() }}{% endraw %}</em>
```

And that’s it.

When we save now it should all be working as expected.

It should have the correct count to start and then as we filter the list, the value should update just like we want it to.

So, it should work just like it did before, but now instead of using the old [@ContentChildren](https://angular.dev/api/core/ContentChildren) decorator and [QueryList](https://angular.dev/api/core/QueryList) class, it’s done using a more modern, [signals-based](https://angular.dev/guide/signals) approach.

## In Conclusion

So, switching from the old content decorators to these new [signal queries](https://angular.dev/guide/signals/queries) is pretty easy and makes things simpler in many cases.

Ok, hopefully that was helpful.

Don't forget to check out [my other Angular tutorials](https://www.youtube.com/@briantreese) for more tips and tricks.

## Additional Resources
* [The demo BEFORE making any changes](https://stackblitz.com/edit/stackblitz-starters-wpimwn?file=src%2Fmain.ts)
* [The demo AFTER making changes](https://stackblitz.com/edit/stackblitz-starters-1mx1ky?file=src%2Fmain.ts)
* [Angular Signal queries documentation](https://angular.dev/guide/signals/queries)

## Want to See It in Action?
Check out the demo code and examples of these techniques in the in the Stackblitz example below. If you have any questions or thoughts, don’t hesitate to leave a comment.

<iframe src="https://stackblitz.com/edit/stackblitz-starters-kn4vtc?ctl=1&embed=1&file=src%2Fsearch-layout%2Fsearch-layout.component.ts" style="height: 500px; width: 100%; margin-bottom: 1.5em; display: block;"></iframe>
