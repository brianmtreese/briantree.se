---
layout: post
title: "Can You Even Use Jump Links in Angular? (Yes… Here’s How)"
date: "2025-09-11"
video_id: "Dz8ERBSXoHs"
tags:
  - "Accessibility"
  - "Angular"
  - "Angular Components"
  - "Angular Routing"
---

<p class="intro"><span class="dropcap">J</span>ump links improve navigation in long-form content, but Angular's routing system breaks standard HTML anchor links. Implementing jump links in Angular requires handling router navigation, smooth scrolling, and ensuring links work across different route configurations. This tutorial demonstrates how to create router-friendly jump links that work seamlessly with Angular's routing system, providing smooth scrolling and proper navigation handling.</p>

{% include youtube-embed.html %}

## Stackblitz Project Links

Check out the sample project for this tutorial here:
- [The demo before](https://stackblitz.com/edit/stackblitz-starters-epxpgz8x?file=src%2Fpage%2Fpage.html)
- [The demo after](https://stackblitz.com/edit/stackblitz-starters-v7rlt5bx?file=src%2Fpage%2Fpage.html)

## Why Regular Anchor Links Fail in Angular

Here’s the app that we’ll be working with in this tutorial:

<div>
<img src="https://briantree.se/assets/img/content/uploads/2025/09-11/demo-1.png" alt="The demo app before any changes" width="2560" height="1440" style="width: 100%; height: auto;">
</div>

Right now, we’ve got a table of contents at the top of the page:

<div>
<img src="https://briantree.se/assets/img/content/uploads/2025/09-11/demo-2.png" alt="The table of contents region that should have working jump links but doesn't" width="1066" height="626" style="width: 100%; height: auto;">
</div>

Each item looks like a link, but if I click them… nothing happens. 

That’s because these links don’t actually point anywhere yet.

We have all of these corresponding sections in the page and the links should take us to each of these.

<div>
<img src="https://briantree.se/assets/img/content/uploads/2025/09-11/demo-3.png" alt="The corresponding sections in the page" width="1318" height="998" style="width: 100%; height: auto;">
</div>

In a standard website this is really easy with anchors and IDs, but this is an Angular app so things are a little different.  

In Angular, you can’t just slap an [href](https://developer.mozilla.org/en-US/docs/Web/HTML/Reference/Elements/a#href) in there. 

So, let’s do it the Angular way!

## How to Add RouterLink and Fragment IDs

Let’s look at the [code for this component](https://stackblitz.com/edit/stackblitz-starters-epxpgz8x?file=src%2Fpage%2Fpage.html) to better understand what we’re starting with.

At the top we have this list of links that form the table of contents region:

```html
<ul>
    <li>
        <a>Adding a Link</a>
    </li>
    <li>
        <a>Linking to a Section</a>
    </li>
    <li>
        <a>How it Relates to History</a>
    </li>
    <li>
        <a>How to Handle Scrolling</a>
    </li>
</ul>
```

Right now, each link is just an empty anchor tag which is why they don’t navigate anywhere.  

Then, further down, the headers for these sections already have IDs and these are what we need to link to:

```html
<h2 id="links">
    Adding a Link
</h2>
<p>...</p>
<h2 id="linking">
    Linking to a Section
</h2>
<p>...</p>
<h2 id="history">
    How it Relates to History
</h2>
<p>...</p>
<h2 id="scrolling">
    How to Handle Scrolling
</h2>
<p>...</p>
```

In a normal website, we’d just add an `href` with the ID and we’d be done, but we can’t do that here. 

Instead, we need to use the [routerLink](https://angular.dev/api/router/RouterLink) directive and the [fragment](https://angular.dev/api/router/RouterLink#fragment) input.  

This lets Angular handle the URL and the fragment properly.

In order to use this directive, we need to import it in our component imports array:

```typescript
import { RouterLink } from '@angular/router';

@Component({
    selector: 'app-page',
    ...,
    imports: [ RouterLink ]
})
export class PageComponent {
}
```

Then, back in the template, we can use the `routerLink` directive.

```html
<a routerLink="">Adding a Link</a>
```

Since we’re just adding a jump link, I don’t want to switch the route.

If I were navigating to a different route, I’d just add the route here:

```html
<a routerLink="adding-links">Adding a Link</a>
```

But in this case we don’t want to change routes so let’s just leave this empty for now.

Now in order to navigate to the header by ID we use the “fragment” input and we just pass it the associated ID, in this case “links”:

```html
<a routerLink="" fragment="links">
    Adding a Link
</a>
```

Okay, this should work now, right?

Actually, no.

This is because, with the way we have it set up, we’re actually switching the route.

Here we can see that “home” is the current route:

<div>
<img src="https://briantree.se/assets/img/content/uploads/2025/09-11/demo-4.png" alt="The current route is home" width="854" height="460" style="width: 100%; height: auto;">
</div>

Then when we click the link, we remove the “home” portion of the path, but we successfully set the anchor ID:

<div>
<img src="https://briantree.se/assets/img/content/uploads/2025/09-11/demo-5.png" alt="Home is removed from the path but the anchor id is set properly" width="776" height="458" style="width: 100%; height: auto;">
</div>

So, that’s good and bad, right?

How can we fix this?

## Stay on the Current Route with RouterLink and an Empty Array

Well, it turns out, there’s a simple trick... bind the `routerLink` to an empty array:

```html
<a [routerLink]="[]" fragment="links">
    Adding a Link
</a>
```

It looks odd, but this is Angular’s way of saying... 

>"Don’t go anywhere, just stick to the current route"  

Now we can apply this to the rest of the links too:

```html
<ul>
    <li>
        <a [routerLink]="[]" fragment="links">
            Adding a Link
        </a>
    </li>
</ul>
<ul>
    <li>
        <a [routerLink]="[]" fragment="linking">
            Linking to a Section
        </a>
    </li>
</ul>
<ul>
    <li>
        <a [routerLink]="[]" fragment="history">
            How it Relates to History
        </a>
    </li>
</ul>
<ul>
    <li>
        <a [routerLink]="[]" fragment="scrolling">
            How to Handle Scrolling
        </a>
    </li>
</ul>
```

Okay, this should work now right?

Unfortunately no, but we’re getting closer.

Now when we click the links, we no longer switch routes, but we don't scroll to the correct section either:

<div>
<img src="https://briantree.se/assets/img/content/uploads/2025/09-11/demo-6.gif" alt="The links now work but we're not scrolling to the correct section" width="1700" height="794" style="width: 100%; height: auto;">
</div>

We are properly adding the appropriate fragments in the URL though:

<div>
<img src="https://briantree.se/assets/img/content/uploads/2025/09-11/demo-7.png" alt="The fragments are properly added to the URL" width="802" height="430" style="width: 100%; height: auto;">
</div>

So what the heck is happening now?

## Enable Angular Router Anchor Scrolling

It turns out that in an Angular app, we actually need to enable what’s known as "anchor scrolling".  

To do this, we open the file that contains the router configuration, in our case this is the [main.ts](https://stackblitz.com/edit/stackblitz-starters-epxpgz8x?file=src%2Fmain.ts) file.

Then, inside the `provideRouter()` function, we add the `withInMemoryScrolling()` function and enable `anchorScrolling`:

```typescript
import { ..., withInMemoryScrolling } from '@angular/router';

bootstrapApplication(App, {
    providers: [
        provideRouter([
            ...
        ], 
        withInMemoryScrolling({ anchorScrolling: 'enabled' }))
    ]
});
```

This tells Angular... 

>"If there’s a fragment in the URL, scroll to it"

With this enabled, the links finally take us to the correct section, and even the back button works properly with fragments in history:

<div>
<img src="https://briantree.se/assets/img/content/uploads/2025/09-11/demo-8.gif" alt="The links now work and we're scrolling to the correct section" width="1920" height="1080" style="width: 100%; height: auto;">
</div>

And, believe it or not, we can improve this even more!

## Add Smooth Scrolling with CSS

Let’s make one last improvement.

Right now the jump between sections is instant. 

It works, but it’s jarring. Let’s smooth it out.

We can do this with a single line of CSS.

In this app, the vertical scrolling occurs on the HTML element, so we'll open the [global_styles.css](https://stackblitz.com/edit/stackblitz-starters-epxpgz8x?file=src%2Fglobal_styles.css) file.

On the HTML selector, we just need to add the [scroll-behavior](https://developer.mozilla.org/en-US/docs/Web/CSS/scroll-behavior) property, and then we’ll set it to a value of “smooth”:

```css
html {
    ...
    scroll-behavior: smooth;
}
```

That’s it! Now navigation between sections feels polished and natural:

<div>
<img src="https://briantree.se/assets/img/content/uploads/2025/09-11/demo-9.gif" alt="The links now scroll smoothly with a smooth scrolling effect" width="1920" height="1080" style="width: 100%; height: auto;">
</div>

It’s one line, but it really improves the feel of the app.

## Final Thoughts and Next Steps

So that’s it! We turned lifeless links into full-fledged Angular router links that jump, scroll, and play nice with the back button.  

In this example we:  

- Used the `routerLink` directive with fragments to add jump links  
- Enabled in-memory scrolling in the router config  
- And added smooth scrolling with CSS  

These are the little details that make your Angular app feel pro-level. 

If you enjoyed this and want more Angular tips that make your apps feel polished, don’t forget to [subscribe](https://www.youtube.com/c/briantreese?sub_confirmation=1)!  

## Additional Resources
- [The demo app BEFORE any changes](https://stackblitz.com/edit/stackblitz-starters-epxpgz8x?file=src%2Fpage%2Fpage.html){:target="_blank"}
- [The demo app AFTER making changes](https://stackblitz.com/edit/stackblitz-starters-v7rlt5bx?file=src%2Fpage%2Fpage.html){:target="_blank"}
- [Angular Router Documentation](https://angular.dev/guide/routing){:target="_blank"}
- [Angular RouterLink API](https://angular.dev/api/router/RouterLink){:target="_blank"}
- [Angular withInMemoryScrolling](https://angular.dev/api/router/withInMemoryScrolling){:target="_blank"}
- [My course "Angular: Styling Applications"](https://www.pluralsight.com/courses/angular-styling-applications){:target="_blank"}
- [My course "Angular in Practice: Zoneless Change Detection"](https://app.pluralsight.com/library/courses/angular-practice-zoneless-change-detection){:target="_blank"}

## Want to See It in Action?

Want to try this yourself? Check out the full demo app below.  

<iframe src="https://stackblitz.com/edit/stackblitz-starters-v7rlt5bx?ctl=1&embed=1&file=src%2Fpage%2Fpage.html" style="height: 500px; width: 100%; margin-bottom: 1.5em; display: block;"></iframe>
