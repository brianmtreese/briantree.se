---
layout: post
title: "Using The New HTML Search Element: Enhancing Semantics for Search Functionality 🔎"
date: "2023-12-08"
video_id: "gi1sAH7DZQw"
tags:
  - "Accessibility"
  - "HTML"
  - "SEO"
---

<p class="intro"><span class="dropcap">T</span>he HTML <code>&lt;search&gt;</code> element provides proper semantic meaning for search functionality, improving accessibility, SEO, and browser understanding. Before its introduction, developers had no native way to mark search regions, forcing workarounds with generic containers or ARIA landmarks. This tutorial demonstrates how to use the <code>&lt;search&gt;</code> element in common scenarios like site-wide search bars and filtered content lists, ensuring your search functionality is properly identified by assistive technologies and search engines.</p>

{% include youtube-embed.html %}

## The need for the HTML search element

With HTML, it’s important to use the best tag for the job. We want the browser or assistive technology to be able to understand as much as it can about the context surrounding the portions of our applications. Search is no different.

There is a concept for what is known as landmark roles in the ARIA specification for HTML to help do this. They are:

- Banner
- Complementary
- Contentinfo
- Form
- Main
- Navigation
- Region
- Search

All of these landmarks could be added implicitly using the proper HTML element, except for search until the element was added in early 2023. And now, we have an element for this as well.

So now that we have it, we need to understand when and how to use it. Let’s take a look at an example.

## How to Use the HTML Search Element With a Common Submittable Search Form

Here we have some pretty standard search form markup.

```html
<form action="./search/" role="search">
    <label for="search">Search Players</label>
    <input type="search" id="search" autocomplete="off" [(ngModel)]="searchText" placeholder="Search by entering a player name" />
    <button type="submit">Go</button>
</form>
```

We have a form element with the proper ARIA landmark role attribute of search. Then we have the label for our search textbox, then the search textbox, and then the button that will submit our search query. This will post to some backend and then give us a filtered list to display below our search form.

Well, in this case where we have a button to submit the search, we simply need to wrap our form in the new search element. And after that, we can remove the role attribute since the search element will provide the same semantic meaning.

```html
<search>
    <form action="./search/">
        <label for="search">Search Players</label>
        <input type="search" id="search" autocomplete="off" [(ngModel)]="searchText" placeholder="Search by entering a player name" />
        <button type="submit">Search</button>
    </form>
</search>
```

And that’s it, it’s just that easy.

### The ARIA Landmark Search Role vs. the HTML Search Element

One important item to note here is that we are essentially replacing the ARIA role attribute with the new HTML search element. We could leave it as it was with the landmark role attribute and no search element instead, but the ARIA spec is clear on the fact that we should always use the element that provides the appropriate semantics when one exists. And in this case, the search element now exists, so we should use it instead of the role attribute.

## How to use the HTML search element with a more modern filterable search controlled with JavaScript

So, we’ve seen a more traditional search configuration but what about something more modern like a web app search where the search is implemented with JavaScript and no form is actually submitted for our query. Well, let’s take another look at our example.

For this demo, it’s actually built using angular so the search functionality can easily happen all right here within the client. I won’t get into the specifics of how we perform the search in angular since that would be a bit off topic, but just know that’s what’s happening here.

```html
<form action="./search/">
    <label for="search">Search Players</label>
    <input type="search" id="search" autocomplete="off" [(ngModel)]="searchText" placeholder="Search by entering a player name" />
    <button type="submit">Search</button>
</form>

@for (player of players | filter: searchText; track player.name) {
    <app-player [player]="player"></app-player>
} @empty {
    <p>Sorry, we couldn't find any players with the name you entered</p>
}
```

So, in this case we actually want to wrap the results in the search element as well since it should be used to contain all of the search capabilities. In this case we also no longer need a button because the search will be bound to the textbox value change. So as we type, the results will be filtered without needing to hit the button. And, since we aren’t submitting the form and no longer have a submit button, we no longer need the form element either.

```html
<search>
  <label for="search">Search Players</label>
  <input type="search" id="search" autocomplete="off" [(ngModel)]="searchText" placeholder="Search by entering a player name" />

  @for (player of players | filter: searchText; track player.name) {
    <app-player [player]="player"></app-player>
  } @empty {
    <p>Sorry, we couldn't find any players with the name you entered</p>
  }
</search>
```

And that’s it. As simple as that.

## When and Where the HTML Search Element Should be Used

So now you should be able to add the search element where appropriate for the things you’re building.

It’s also important to understand what types of search regions are appropriate to be placed within the search element. It should be used for any type of search or filtering functionality really. Whether you’re adding search or filtering for a website or app, or a specific portion of a website or app, or even when searching externally to other sites or even the web as whole.

Equally important to note here that it is perfectly acceptable to have more than one search element within a website or app.

Ok, so now you should be good to go to use the search element.

## Want to See It in Action?
Check out the demo code and examples of these techniques in the stackblitz example below. If you have any questions or thoughts, don’t hesitate to leave a comment.

<iframe src="https://stackblitz.com/edit/stackblitz-starters-yg18rq?ctl=1&embed=1&file=src%2Fapp.component.html" style="height: 500px; width: 100%; margin-bottom: 1.5em; display: block;">  
