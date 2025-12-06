---
layout: post
title: "Angular Signal Queries: Replace @ViewChild and @ContentChild the Modern Way (v19+)"
date: "2024-04-20"
video_id: "b35ts9OinBc"
tags:
  - "Angular"
  - "Angular Components"
  - "Angular Directives"
  - "Angular Signals"
  - "Angular Styles"
---

<p class="intro"><span class="dropcap">A</span>ngular's traditional @ViewChild and @ContentChild decorators worked well for years, but in the signals era, they now have modern signal-based replacements. In this tutorial, you'll learn how to use signal queries to replace decorator-based queries with reactive, automatically updating references. We'll walk through both viewChild() and contentChild() in Angular v19+, explain how they behave differently from the old APIs, and show real-world examples for accessing template refs and projected content the modern way.</p>

{% include youtube-embed.html %}

{% include update-banner.html title="Updated for Angular 19+" message="This article demonstrates modern signal queries (viewChild() and contentChild()) which replace the traditional @ViewChild and @ContentChild decorators." %}

#### Angular Signals Tutorial Series:
- [Signal Inputs & output()]({% post_url /2024/03/2024-03-24-angular-tutorial-signal-based-inputs-and-the-output-function %}) - Replace @Input/@Output with signals
- [ViewChild Signal Queries]({% post_url /2024/11/2024-11-08-viewchild-and-viewchildren-signal-queries %}) - Detailed guide to viewChild()
- [ContentChild Signal Queries]({% post_url /2024/11/2024-11-22-contentchild-and-contentchildren-signal-queries %}) - Detailed guide to contentChild()

## The Demo Application

So, here’s the demo application that I was talking about. It lists out a searchable list of NBA players.

<div>
<img src="{{ '/assets/img/content/uploads/2024/04-20/demo-application.png' | relative_url }}" alt="Example of a demo application before swithing to viewChild() and contentCHild() signal queries" width="703" height="875" style="width: 100%; height: auto;">
</div>

### We have created three examples: 

- One where we used the [`@ViewChild`](https://angular.io/api/core/ViewChild) decorator and a template reference variable to select the HTML input element for our search field in order to focus it on initialization.
- Then, we have another example also using the [`@ViewChild`](https://angular.io/api/core/ViewChild) decorator along with a component to focus the search form, on initialization, but when it’s nested within another component.
- And, for the final example we used the [`@ContentChild`](https://angular.io/api/core/ContentChild) decorator to focus the search field when it’s been included within projected content.

In this post, we’ll convert each of these over to [signals](https://angular.io/guide/signals) using the [`viewChild()`](https://angular.io/guide/signal-queries#viewchild) and [`contentChild()`](https://angular.io/api/core/ContentChild) functions. Ok, let’s start with the [`@ViewChild`](https://angular.io/api/core/ViewChild) and template reference variable DOM element example.

## Using the viewChild() Function to Query for an HTML Element Within a Component View

Ok, here [in this example](https://stackblitz.com/edit/stackblitz-starters-gbpu6y?file=package.json,src%2Fsearch%2Fsearch.component.ts) we can see, in our search component, we have the [`@ViewChild`](https://angular.io/api/core/ViewChild) decorator that queries for a template reference variable named “searchField”.

#### search.component.ts
```typescript
@ViewChild('searchField', { static: true }) searchField!: ElementRef<HTMLInputElement>;
```

And if we switch over to the template, we can see the variable on our search input here.

#### search.component.html
```html
<input type="search" id="search" #searchField>
```

Ok, let’s switch back to the code. A couple more things to note, we’ve also made this decorator `static` because we know it will always exist. When we do this, it becomes available earlier in Angular’s [component lifecycle events](https://angular.io/guide/lifecycle-hooks), so we’re able to set focus in the [`ngOnInit()`](https://angular.io/api/core/OnInit) hook here.

#### search.component.ts
```typescript
ngOnInit() {
    this.searchField.nativeElement.focus();
}
```

If it wasn’t static, we’d need to add it in the [`ngAfterViewInit()`](https://angular.io/api/core/AfterViewInit) lifecycle event instead because it wouldn’t be available until the view is ready. Ok, now that we understand what’s going on here, let’s switch to the [`viewChild()`](https://angular.io/guide/signal-queries#viewchild) function.

### What are Signal Queries?

This function is part of a set of what are known as [“signal queries”](https://angular.io/guide/signal-queries) in Angular. These queries are used to find child components, directives, or DOM elements.

<div>
<img src="{{ '/assets/img/content/uploads/2024/04-20/signal-queries.gif' | relative_url }}" alt="Slide explaining signal queries in Angular" width="1920" height="1080" style="width: 100%; height: auto;">
</div> 

#### The View:
If we’re searching for something directly within the component template, then we’re using the view.

#### The Content: 
To contrast, if we’re searching for something that will be inserted within a content slot, we’re using content.

In this case, since we’re dealing with the component view, this function is considered a “view query”. Anything dealing with projected content would be considered a “content query”. We’ll see an example of this later on in the post.

### Using the viewChild() Function
Ok, to use the [`viewChild()`](https://angular.io/guide/signal-queries#viewchild) function, we’ll create a private variable that we’ll name “searchField”. Since we’re going to replace our existing “searchField” property it’ll be named the same for now. We’ll remove the old one once we’re done. Then, we add the [`viewChild()`](https://angular.io/guide/signal-queries#viewchild) function and we’ll need to type it to an [`ElementRef`](https://angular.io/api/core/ElementRef), [`HTMLInputElement`](https://developer.mozilla.org/en-US/docs/Web/API/HTMLInputElement).

```typescript
import { ..., viewChild } from '@angular/core';

@Component({
  selector: 'app-search',
  ...
})
export class SearchComponent implements OnInit {
    private searchField = viewChild<ElementRef<HTMLInputElement>>('searchField');
}
```

Ok, now we can remove the old variable set with the decorator and we can remove the decorator import too. Then, all we need to do is, since this property is now a [signal](https://angular.io/guide/signals), we need to add parenthesis where we’re using it.

```typescript
ngOnInit() {
    this.searchField()?.nativeElement.focus();
}
```

And that’s it. If we were to save, we should see that our search field is properly focused on initialization just like it was before the change.

### Using an effect() Instead of ngOnInit()/ngAfterViewInit() With viewChild()

Now, since this property is now a [signal](https://angular.io/guide/signals), we can switch this over to use the [`effect()`](https://angular.io/guide/signals#effects) function instead of the [`ngOnInit()`](https://angular.io/api/core/OnInit) lifecycle event. This will make it available as soon as the [`viewChild()`](https://angular.io/guide/signal-queries#viewchild) signal is set.

To do this, let’s add a `constructor()`. Within the constructor, let’s add the [`effect()`](https://angular.io/guide/signals#effects) function. Within the [`effect()`](https://angular.io/guide/signals#effects) callback, we can move our focus call.

```typescript
import { ..., effect } from '@angular/core';

@Component({
  selector: 'app-search',
  ...
})
export class SearchComponent implements OnInit {

    constructor() {
        effect(() => {
            this.searchField()?.nativeElement.focus();
        });
    }
}
```

Now we can remove our [`ngOnInit()`](https://angular.io/api/core/OnInit) function, interface, and import too. Then, we should be able to save and see this still working correctly. Pretty cool right?

### Making a viewChild() Query Required

One more thing we can do here is, since we know that this field will always exist, we can make it required just like we can with the [`input()`](https://angular.io/guide/signal-inputs) function. We just add, `required` to our function.

#### Before:
```typescript
private searchField = viewChild<ElementRef<HTMLInputElement>>('searchField');
```

#### After:
```typescript
private searchField = viewChild.required<ElementRef<HTMLInputElement>>('searchField');
```

Now, [Typescript](https://www.typescriptlang.org/) will infer that this variable will always exist, meaning we no longer need the question mark when we access it either.

#### Before:
```typescript
this.searchField()?.nativeElement.focus();
```

#### After:
```typescript
this.searchField().nativeElement.focus();
```

Ok, that’s it. If we were to save again, everything should work as expected.

Now, this would mean that we’d get an error if this were to become conditional or something in the future. So you'll just need to keep that in mind.

So that’s the [`viewChild()`](https://angular.io/guide/signal-queries#viewchild) function querying for an HTML element, now let’s query for a component within the template instead.

#### See the final result below:
<iframe src="https://stackblitz.com/edit/stackblitz-starters-yyq3by?ctl=1&embed=1&file=src%2Fsearch%2Fsearch.component.ts" style="height: 500px; width: 100%; margin-bottom: 1.5em; display: block;"></iframe>

## Using the viewChild() Function to Query for a Component/Directive Within a Component View

Here, [in this example](https://stackblitz.com/edit/stackblitz-starters-afq6gf?file=src%2Fsearch%2Fsearch-form%2Fsearch-form.component.ts,src%2Fsearch%2Fsearch.component.ts), we have moved the search form to its own component. Then, this search form component gets included within the parent search component.

#### search.component.html
```html
<app-search-form></app-search-form>
```

When we switch back over to the code for the search form component, we can see that we have our “searchField” variable available as a public property so that it can be accessed externally by other components or directives.

#### search-form.component.ts
```typescript
@Component({
  selector: 'app-search-form',
  ...
})
export class SearchFormComponent {
    searchField = viewChild.required<ElementRef<HTMLInputElement>>('searchField');
}
```

Now, let’s take a look at the code for the search component. We have an old [`@ViewChild`](https://angular.io/api/core/ViewChild) decorator used to access the `SearchFormComponent` within the view. It’s also `static` like the previous example and it’s accessed in the [`ngOnInit()`](https://angular.io/api/core/OnInit) lifecycle hook to set focus of the text field within that component.

#### search.component.ts
```typescript
@Component({
  selector: 'app-search',
  ...
})
export class SearchComponent implements OnInit {
  @ViewChild(SearchFormComponent, { static: true }) searchForm!: SearchFormComponent;

  ngOnInit() {
    this.searchForm.searchField()?.nativeElement.focus();
  }
}
```

This example will be very similar to the last one accept we’ll be using a component for our query instead of an HTML element. So, let’s add a new private variable named “searchForm”. Then we’ll use the [`viewChild()`](https://angular.io/guide/signal-queries#viewchild) function again. We’ll make it required, then we’ll pass it the `SearchFormComponent` class. And that’s it.

```typescript
private searchForm = viewChild.required(SearchFormComponent);
```

Now we can remove the old property, set with the decorator and we can remove the import for the [`@ViewChild`](https://angular.io/api/core/ViewChild) decorator.

Next, let's add a `constructor()`, [`effect()`](https://angular.io/guide/signals#effects) function, and move the focus call into the [`effect()`](https://angular.io/guide/signals#effects) callback.

```typescript
constructor() {
    effect(() => {
        this.searchForm().searchField()?.nativeElement.focus();
    });
}
```

After that, we can now remove the [`ngOnInit()`](https://angular.io/api/core/OnInit) function, the interface, and the import too. And that should be it. If we were to save, we should see everything still working properly.

So now we know how to query for both DOM elements and components or directives within the view. Up next, let’s look at how we’d use the [`contentChild()`](https://angular.io/api/core/ContentChild) function to query for a component within projected content.

#### See the final result below:
<iframe src="https://stackblitz.com/edit/stackblitz-starters-jzaggp?ctl=1&embed=1&file=src%2Fsearch%2Fsearch.component.ts" style="height: 500px; width: 100%; margin-bottom: 1.5em; display: block;"></iframe>

## Using the contentChild() Function to Query for a Component/Directive Within Projected Content

[In this example](https://stackblitz.com/edit/stackblitz-starters-pcw1us?file=src%2Fsearch%2Fsearch.component.ts,src%2Fsearch%2Fsearch-form%2Fsearch-form.component.ts,src%2Fapp.component.html), we have our same search form component, but the parent search component has changed a little. If we look at the template, we can see that it has a content slot.

#### search.component.html
```html
<app-search-form></app-search-form>
```

Let’s take a look at the app component template where this search component is used. Here, we can see that the search form component is included in the slot for the search component now.

#### app.component.html
```html
<app-search>
  <app-search-form></app-search-form>
</app-search>
...
```

So it’s projected content within the search component. Now to access this search form component from the parent search component we’ll be dealing with a content query.

Now let’s look at the code for the search component. Here we can see that we’re using the old [`@ContentChild`](https://angular.io/api/core/ContentChild) decorator to create a static “searchForm” property querying for the SearchFormComponent.

So, this is exactly the same as the last example accept we’ll use the [`contentChild()`](https://angular.io/api/core/ContentChild) function in this case.

Let’s create a private field named “searchForm”. Then we’ll use the [`contentChild()`](https://angular.io/api/core/ContentChild) function. We can make it required here too since we’ll always want to include it, and then we just pass the `SearchFormComponent` class.

#### search.component.ts
```typescript
private searchForm = contentChild.required(SearchFormComponent);
```

Now we can remove the old property set with the [`@ContentChild`](https://angular.io/api/core/ContentChild) decorator and we can remove the decorator import too.

Next, we can add a constructor. Then we can add the [`effect()`](https://angular.io/guide/signals#effects) function. Then we can move the focus call into the [`effect()`](https://angular.io/guide/signals#effects).

```typescript
constructor() {
    effect(() => {
        this.searchForm().searchField().nativeElement.focus();
    });
}
```

Ok, all that’s left now is to remove the [`ngOnInit()`](https://angular.io/api/core/OnInit) function, interface, and import. Now if we were save again, everything should be working correctly.

{% include banner-ad.html %}

#### See the final result below:
<iframe src="https://stackblitz.com/edit/stackblitz-starters-qnysas?ctl=1&embed=1&file=src%2Fsearch%2Fsearch.component.ts" style="height: 500px; width: 100%; margin-bottom: 1.5em; display: block;"></iframe>

## Conclusion

So, there you have it. Now you know how use the new [`viewChild()`](https://angular.io/guide/signal-queries#viewchild) and [`contentChild()`](https://angular.io/api/core/ContentChild) signal query functions. They’re not too much different than the old decorators but you’ll probably want to start using them moving forward to modernize your Angular applications and now you’ll know how.
