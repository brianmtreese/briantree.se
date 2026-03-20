---
layout: post
title: "Angular’s New debounced() Signal Explained"
date: "2026-03-19"
video_id: "jKffTaEL1JI"
tags:
  - "Angular"
  - "Angular v22"
  - "Angular Signals"
  - "debounced"
  - "resource"
  - "TypeScript"
---

<p class="intro"><span class="dropcap">E</span>very Angular developer has faced it, an input that spams the backend with every single keystroke. The classic solution involves pulling in RxJS and using <a href="https://rxjs.dev/api/operators/debounceTime" target="_blank">debounceTime</a>, but it requires converting signals to observables and thinking in streams. As of Angular v22, there’s a new, cleaner way. The new experimental <a href="https://github.com/angular/angular/commit/b918beda323eefef17bf1de03fde3d402a3d4af0" target="_blank">debounced()</a> signal primitive lets you solve this problem in a more declarative, signal-native way. This post walks through the old way and then refactors it to the new, showing you exactly how to simplify your async data-fetching logic.</p>

{% include youtube-embed.html %}

## The Problem: Too Many API Requests

Let's start with a simple product search app:

<div><img src="{{ '/assets/img/content/uploads/2026/03-19/simple-product-search-app.jpg' | relative_url }}" alt="A simple product search app" width="1382" height="682" style="width: 100%; height: auto;"></div>

It looks fine on the surface, but the real story is in the Network tab:

<div><img src="{{ '/assets/img/content/uploads/2026/03-19/network-spam.gif' | relative_url }}" alt="A GIF showing the browser's network tab firing a new API request on every keystroke in the search input" width="1908" height="944" style="width: 100%; height: auto;"></div>

As you type a search term you can see a new HTTP request firing for each character typed. 

In a real-world application, this is a ton of unnecessary load on your backend and can create a jumpy, unpleasant user experience. 

This is the classic problem we need to solve.

## The Old Way: Debouncing with RxJS `debounceTime`

Our initial component uses a mix of signals and RxJS. 

We have a `query` signal that holds the search term, which is converted to an observable using `toObservable`. 

The `products` are then loaded inside a `toSignal` block that pipes the query observable through several RxJS operators:

```typescript
private http = inject(HttpClient);
protected readonly query = signal('');
private readonly $query = toObservable(this.query);

protected readonly products = toSignal(
  this.$query.pipe(
    distinctUntilChanged(),
    switchMap(query =>
      query
        ? this.http.get(/* ... */).pipe(
            map(res => ({ status: 'data' as const, data: res.products })),
            startWith({ status: 'loading' as const, data: [] as Product[] }),
            catchError(() => of({ status: 'error' as const, data: [] as Product[] }))
          )
        : of({ status: 'idle' as const, data: [] as Product[] })
    )
  ),
  { initialValue: { status: 'idle' as const, data: [] as Product[] } }
);
```

The traditional fix is to add the `debounceTime` operator to the pipe. 

It's a one-line change that tells RxJS to wait for a pause in emissions (e.g., 1000ms) before letting the value proceed:

```typescript
this.$query.pipe(
  debounceTime(1000), // Wait for 1 second of silence
  distinctUntilChanged(),
  switchMap(query => /* ... */)
)
```

This works perfectly:

<div><img src="{{ '/assets/img/content/uploads/2026/03-19/network-spam-fixed-with-rxjs-debounce-time.gif' | relative_url }}" alt="A GIF showing the browser's network tab firing a new API request after the user stops typing for 1 second" width="1918" height="904" style="width: 100%; height: auto;"></div>

The network spam stops, and only one request is sent after the user stops typing. 

But it forces us into the RxJS world of observables and pipes, even if the rest of our app is signal-first. 

What if we could stay in the world of signals?

Well, as of Angular v22, we will be able to!

## The New Way: `debounced()` and `resource()` in Angular v22 

The Angular team has introduced a new experimental primitive, `debounced`, and it can work together with `resource` to solve this exact problem elegantly.

### Step 1: Create a Debounced Signal

First, we'll create a new signal that is a debounced version of our original `query` signal. 

The `debounced()` function from `@angular/core` makes this trivial.

```typescript
import { ..., debounced } from '@angular/core';

// ...
protected readonly query = signal('');
protected readonly debouncedQuery = debounced(this.query, 1000);
```

That's it. `debouncedQuery` is now a read-only signal that will only update its value when the `query` signal has been stable for 1000 milliseconds.

### Step 2: Refactor to Use `resource()`

Next, we'll completely replace our `toSignal` implementation with the new `resource()` primitive. 

`resource` is purpose-built for loading asynchronous data from a signal.

We can delete the entire `products` signal and its `toSignal` block and replace it with this:

```typescript
import { ..., resource } from '@angular/core';

// ...
protected readonly products = resource({
  params: () => this.debouncedQuery.value() || undefined,
  loader: ({ params }) => 
    firstValueFrom(
      this.http.get<{ products: Product[] }>(/* ... */)
    ).then(res => res.products),
});
```

Let's break this down:
- **`params`**: A function that returns the current search query from the debounced signal (`this.debouncedQuery.value()`), or `undefined` if the query is empty. When this value changes, the resource automatically re-fetches.
- **`loader`**: A function that receives the resolved `params` and fetches data using Angular's `HttpClient`. Because `HttpClient` returns an Observable, `firstValueFrom()` is used to convert it to a Promise. The result is then unwrapped to return just the `products` array.

The `resource` primitive automatically manages the loading, error, and data states for us based on the `params` signal and the `loader` function's execution.

## Updating the Template for the `resource` API

The new `resource` primitive has a different template API than our old status-based object. 

Instead of checking a `status` property, we use methods like `isLoading()` and `value()`.

Our old `@switch` block gets replaced with a set of `@if` conditions:

```html
@if (query()) {
  <!-- If there's a search query -->
  @if (products.isLoading()) {
    <!-- Show loading spinner -->
    <div class="state loading">
      <span class="spinner"></span>
      <span>Fetching products…</span>
    </div>
  } @else {
    <!-- Show results -->
    <ul class="results-list">
      @for (product of products.value(); track product) {
        <li class="result-item">
          <div><strong>{% raw %}{{ product.title }}{% endraw %}</strong></div>
          <div>{% raw %}{{ product.price | currency }}{% endraw %}</div>
        </li>
      }
    </ul>
  }
} @else {
  <!-- If there's no query, show idle state -->
  <div class="state idle">
    Start typing to search products
  </div>
}
```

- We first check if the base `query()` signal has a value. If not, we show the idle message.
- If it does, we then check `products.isLoading()`. If true, we show the spinner.
- Finally, if it's not loading, we can safely access the data via `products.value()` and render the results.

## The Final Result

With these changes, the application behaves identically to the optimized RxJS version:

<div><img src="{{ '/assets/img/content/uploads/2026/03-19/network-spam-fixed-with-debounced-signal.gif' | relative_url }}" alt="A GIF showing the browser's network tab firing a new API request after the user stops typing for 1 second" width="1918" height="920" style="width: 100%; height: auto;"></div>

Typing in the search box only fires a single API request after the user has stopped typing for a second. 

The difference is that our component logic is now almost 100% signal-based. 

No `toObservable`, no `.pipe()`, no manual subscriptions.

This is a huge step forward for reactivity in Angular, giving us a more declarative, signal-native way to handle one of the most common patterns in web development.

## Get Ahead of Angular's Next Shift

Most Angular apps today still rely on reactive forms, but that's starting to shift.

Signal Forms are new, and not widely adopted yet, which makes this a good time to get ahead of the curve.

I created a course that walks through everything in a real-world context if you want to get up to speed early: 👉 [Angular Signal Forms Course](https://www.udemy.com/course/angular-signal-forms/?couponCode=021409EC66FC6440B867){:target="_blank"}

<div class="youtube-embed-wrapper">
	<iframe 
		width="1280" 
		height="720"
		src="https://www.youtube.com/embed/fZZ1UVkyB4I?rel=1&modestbranding=1" 
		frameborder="0" 
		allow="accelerometer; autoplay; clipboard-write; encrypted-media; gyroscope; picture-in-picture; web-share" 
		allowfullscreen
		loading="lazy"
		title="Signal Forms Course Preview"
	></iframe>
</div>

## Additional Resources
- [The source code for this example](https://github.com/brianmtreese/angular-v22-debounced-signals-example){:target="_blank"}
- [Angular Resource API](https://angular.dev/guide/signals/resource){:target="_blank"}
- [RxJS debounceTime Docs](https://rxjs.dev/api/operators/debounceTime){:target="_blank"}
- [My course "Angular Signal Forms: Build Modern Forms with Signals"](https://www.udemy.com/course/angular-signal-forms/?couponCode=021409EC66FC6440B867){:target="_blank"}
- [My course "Angular: Styling Applications"](https://www.pluralsight.com/courses/angular-styling-applications){:target="_blank"}
- [My course "Angular in Practice: Zoneless Change Detection"](https://app.pluralsight.com/library/courses/angular-practice-zoneless-change-detection){:target="_blank"}
