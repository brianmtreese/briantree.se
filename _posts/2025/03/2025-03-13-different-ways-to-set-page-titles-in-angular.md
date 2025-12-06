---
layout: post
title: "Angular Page Titles: 3 Ways to Set Dynamic Titles"
date: "2025-03-13"
video_id: "dRzzV9QJ3Lk"
tags:
  - "Accessibility"
  - "Angular"
  - "Angular Components"
  - "Angular Forms"
  - "Angular Routing"
  - "Angular Styles"
  - "SEO"
---

<p class="intro"><span class="dropcap">S</span>tatic page titles hurt SEO rankings, confuse users with multiple tabs open, and violate accessibility guidelines. Angular provides multiple ways to set dynamic page titles, from simple route-based titles to complex dynamic titles that change based on component data. This tutorial demonstrates three approaches: using the Title service in components, setting titles in route configuration, and handling dynamic titles with route resolvers. You'll learn how to ensure every page has a unique, descriptive title.</p>

{% include youtube-embed.html %}

## The Demo App: Identifying the Issue

For this tutorial we’ll be using [this simple Angular application](https://stackblitz.com/edit/stackblitz-starters-r6fd63ta):

<div>
<img src="{{ '/assets/img/content/uploads/2025/03-13/demo-1.gif' | relative_url }}" alt="Example of a simple Angular application" width="2560" height="1391" style="width: 100%; height: auto;">
</div>

It’s built using [Angular Routing](https://angular.dev/guide/routing) so as we navigate to different pages the view is updated properly with the content for the given route.

But, the problem is that the page title is not being properly updated as we navigate.

It just says “My app” no matter what page we navigate to:

<div>
<img src="{{ '/assets/img/content/uploads/2025/03-13/demo-2.png' | relative_url }}" alt="Example of a simple Angular application with a page title that is not updated" width="782" height="316" style="width: 100%; height: auto;">
</div>

In this tutorial, I'll show you three ways to dynamically update page titles in Angular.

## Method 1: Using the Title Service in a Component

First, let’s start with the basics.

Angular provides a [built-in title service](https://angular.dev/api/platform-browser/Title) that we can use to set the page title dynamically.

Let’s use it to add the title to the “About” page.

To determine what component we are using for our “About” page, we can look in our [route config file](https://stackblitz.com/edit/stackblitz-starters-r6fd63ta?file=src%2Froutes.ts).

Here it is, this route maps to the [About Component](https://stackblitz.com/edit/stackblitz-starters-r6fd63ta?file=src%2Fpages%2Fabout%2Fabout.component.ts):

```typescript
const routeConfig: Routes = [
  ...,
  {
    path: "about",
    component: AboutComponent,
  }
];
```

So, let’s open the [code for this component](https://stackblitz.com/edit/stackblitz-starters-r6fd63ta?file=src%2Fpages%2Fabout%2Fabout.component.ts).

Now, we need to inject the [Title service](https://angular.dev/api/platform-browser/Title) using the `inject()` function.

Then, we can use the service to set the page title.

For this, we'll use the `setTitle()` function from the service.

This function requires us to pass the title for this page as a string, so let's add "About Us":

```typescript
import { inject } from '@angular/core';
import { Title } from '@angular/platform-browser';

export class AboutComponent {
  private titleService = inject(Title);
  
  constructor() {
    this.titleService.setTitle("About Us");
  }
}
```

Now, whenever this component loads, the page title should change to “About Us”.

Let’s save and see:

<div>
<img src="{{ '/assets/img/content/uploads/2025/03-13/demo-3.gif' | relative_url }}" alt="Example of the page title properly being set to 'About Us'" width="866" height="566" style="width: 100%; height: auto;">
</div>

Okay, it's still showing “My App” on the home page, but when we navigate to the “About” page now, it has the correct title.

So this is cool, right?

But we can make this better by setting the title dynamically when navigating between routes.

## Method 2: Setting Titles Directly in the Route Config

Let’s start by removing everything that we just added in the [About Component](https://stackblitz.com/edit/stackblitz-starters-r6fd63ta?file=src%2Fpages%2Fabout%2Fabout.component.ts).

In a real-world app, you don’t want to hardcode your titles everywhere like this.

Instead, we’ll define them in our routes.

Let’s open back up the [route config](https://stackblitz.com/edit/stackblitz-starters-r6fd63ta?file=src%2Froutes.ts).

Now, it turns out that adding dynamic titles to routes is really easy.

We just need to add the "title" property to each route object where we pass the desired title as a string.

We’ll skip the title for the dynamic blog posts because we need to handle them differently:

```typescript
const routeConfig: Routes = [
  {
    path: "",
    component: HomeComponent,
    title: "Welcome",
  },
  {
    path: "blog",
    component: BlogComponent,
    title: "Our Blog",
  },
  {
    path: "blog/post/:id",
    component: PostComponent,
  },
  {
    path: "about",
    component: AboutComponent,
    title: "About Us",
  },
  {
    path: "contact",
    component: ContactComponent,
    title: "Contact Us",
  },
  {
    path: "support",
    component: SupportComponent,
    title: "Get Support",
  },
];
```

Okay, that should be it, let’s save and see how it works now:

<div>
<img src="{{ '/assets/img/content/uploads/2025/03-13/demo-4.gif' | relative_url }}" alt="Example of the page title being set dynamically in the route config using the title property" width="1000" height="814" style="width: 100%; height: auto;">
</div>

Nice, now we have titles for all of the pages.

Well, all pages except for the dynamic blog posts, right?

## Method 3: Dynamic Titles with a Resolver

So what if your page title depends on dynamic [route parameters](https://angular.dev/guide/routing/common-router-tasks#accessing-query-parameters-and-fragments), like these blog post titles?

Well, we can create a custom [resolver](https://angular.dev/api/router/ResolveFn).

Let’s start by adding a title resolver file:

<div>
<img src="{{ '/assets/img/content/uploads/2025/03-13/demo-5.png' | relative_url }}" alt="Adding a title resolver file to the project" width="738" height="408" style="width: 100%; height: auto;">
</div>

Okay, now let’s export a const named "titleResolver".

This const will be typed as a [ResolveFn](https://angular.dev/api/router/ResolveFn) which needs to be imported from the router module and it will return a string.

This function will have a “route” parameter.

Then, within this function we can simply return the value from the title route queryParam:

```typescript
import { ResolveFn } from "@angular/router";

export const titleResolver: ResolveFn<string> = (route) => {
  return route.queryParams["title"];
};
```

Okay, that should be it.

Now, let’s switch back to the [route config](https://stackblitz.com/edit/stackblitz-starters-r6fd63ta?file=src%2Froutes.ts).

Then, let’s add the title property to the blog post route, and we can simply pass it the [resolver function](https://stackblitz.com/edit/stackblitz-starters-guy3qqk8?file=src%2Ftitle.resolver.ts) that we just created:

```typescript
import { titleResolver } from './title.resolver';

const routeConfig: Routes = [
  ...,
  {
    path: 'blog/post/:id',
    component: PostComponent,
    title: titleResolver
  }
];
```

Okay, that should be everything we need so let’s save and see how it works:

<div>
<img src="{{ '/assets/img/content/uploads/2025/03-13/demo-6.gif' | relative_url }}" alt="Example of the page title being set dynamically in the route config using a resolver" width="1440" height="1078" style="width: 100%; height: auto;">
</div>

Nice, now as we switch between the blog posts, the title is updated correctly.

## Conclusion – Bringing It All Together

And that’s it! Now your Angular app’s page titles update automatically as users navigate.

You can use the [Title service](https://angular.dev/api/platform-browser/Title), the [title property in your route config](https://angular.dev/api/router/Route#title), or a [resolver](https://angular.dev/api/router/ResolveFn) for dynamic titles.

No matter which way you do it, it improves SEO, user experience, and overall app polish!

If you found this helpful, don't forget to [subscribe](https://www.youtube.com/c/briantreese?sub_confirmation=1) and check out [my other Angular tutorials](https://www.youtube.com/@briantreese) for more tips and tricks!

{% include banner-ad.html %}

## Additional Resources

- [The demo app BEFORE any changes](https://stackblitz.com/edit/stackblitz-starters-r6fd63ta?file=src%2Froutes.ts)
- [The demo app AFTER making changes](https://stackblitz.com/edit/stackblitz-starters-guy3qqk8?file=src%2Froutes.ts)
- [Angular Title Service Docs](https://angular.dev/api/platform-browser/Title)
- [Angular Routing & Navigation Guide](https://angular.dev/guide/routing/common-router-tasks)
- [Angular Route Resolver Docs](https://angular.dev/api/router/ResolveFn)

## Want to See It in Action?

Check out the demo code showcasing these techniques in the StackBlitz project below. If you have any questions or thoughts, don’t hesitate to leave a comment.

<iframe src="https://stackblitz.com/edit/stackblitz-starters-guy3qqk8?ctl=1&embed=1&file=src%2Froutes.ts" style="height: 500px; width: 100%; margin-bottom: 1.5em; display: block;"></iframe>
