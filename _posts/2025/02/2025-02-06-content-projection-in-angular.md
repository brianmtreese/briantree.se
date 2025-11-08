---
layout: post
title: "The Beginner's Guide to Content Projection in Angular"
date: "2025-02-06"
video_id: "1uyOR8oWKeM"
tags:
  - "Angular"
  - "Angular Components"
  - "Angular Styles"
  - "CSS"
  - "Custom Elements"
  - "HTML"
  - "Web Components"
---

<p class="intro"><span class="dropcap">I</span>n this beginner-friendly tutorial, I’ll guide you through everything you need to know about Content Projection in Angular. You’ll learn how to inject dynamic content in components, create multiple content slots, use advanced techniques, and even implement fallback content for maximum flexibility. By the end, you’ll be able to build flexible, reusable components with ease.</p> 

{% include youtube-embed.html %}

## From Web Components to Angular: The Power of Content Projection

The idea of content projection actually comes from [Web Components](https://developer.mozilla.org/en-US/docs/Web/Web_Components).

At its core, it’s about punching "holes" in a component where you can insert unique content, whether that’s plain text, custom markup, or even other components.

These "holes" are called slots.

<div>
<img src="{{ '/assets/img/content/uploads/2025/02-06/content-projection-slide.gif' | relative_url }}" alt="Angular content projection visualization" width="1920" height="1080" style="width: 100%; height: auto;">
</div> 

Think of them as placeholders for content that comes from outside the component.

This is super useful because it lets you inject custom content into specific regions of a component without mixing up the DOM trees. 

It keeps everything clean and organized.

And the best part? 

Angular fully supports this concept.

<div>
<img src="{{ '/assets/img/content/uploads/2025/02-06/web-component-slots-vs-angular.jpg' | relative_url }}" alt="Web Component slots vs Angular content projection" width="1812" height="801" style="width: 100%; height: auto;">
</div> 

In Web Components, we use the HTML [`<slot>`](https://developer.mozilla.org/en-US/docs/Web/HTML/Element/slot) element for content projection. 

But in Angular, we use a special element called [`<ng-content>`](https://angular.dev/api/core/ng-content).

Let’s dive into an example to see how it works!

## Basic Content Projection with `<ng-content>`

Alright, let’s imagine we’ve got a growing Angular application, and we’re starting to sprinkle a bunch of message sections throughout the app:

<div>
<img src="{{ '/assets/img/content/uploads/2025/02-06/demo-1.jpg' | relative_url }}" alt="Example of repetitive sections of HTML and CSS in an Angular application" width="1060" height="834" style="width: 100%; height: auto;">
</div> 

Now, since we’re repeating the same markup with just different content each time, it makes sense to turn this into a presentational component.

Great idea, right? 

So, we’ve already started creating a [message component](https://stackblitz.com/edit/stackblitz-starters-nj2lwayp?file=src%2Fmessage%2Fmessage.component.html) to handle this.

But here’s the challenge, we’re dealing with dynamic content.

We can’t rely on these regions just having simple strings of text. 

The content could be anything, headings, paragraphs, lists, or even more complex markup.

So, how do we handle this?

We need to use Content Projection of course!

We want to project any unknown content into the `<article>` element within the [message component template](https://stackblitz.com/edit/stackblitz-starters-nj2lwayp?file=src%2Fmessage%2Fmessage.component.html):

```html
<svg>...</svg>
<article>
    <!-- Any content will be inserted here -->
</article>
```

To do this, we just add an [`<ng-content>`](https://angular.dev/api/core/ng-content) element inside the `<article>`:

```html
<svg>...</svg>
<article>
    <ng-content></ng-content>
</article>
```

Now, when the component is rendered, any content we place between the opening and closing tags of this component will get injected right here inside the article.

Now, let’s switch to the [main app component](https://stackblitz.com/edit/stackblitz-starters-nj2lwayp?file=src%2Fmain.ts) and import our new message component:

```typescript
import { MessageComponent } from './message/message.component';

@Component({
  selector: 'app-root',
  ...,
  imports: [ MessageComponent ]
})
```

Once that’s done, we can simply replace all of the `<div>` elements with our new message component:

#### Before:
```html
<div class="error">
    <h3>We have a little problem</h3>
    <p>Your premium payment failed. Please make sure we've got your details right.</p>
</div>
<div class="success">
    <h3>Success!</h3>
    <p>Congrats, you've successfully created an account.</p>
</div>
<div class="error">
    <h3>Sorry, this form has some issues</h3>
    <p>It looks like we need a little more information from you</p>
    <ul>
        <li>Please enter your name</li>
        <li>It looks like your email address is invalid</li>
        <li>You must be thirteen or older to create an account</li>
    </ul>
</div>
```

#### After:
```html
<app-message class="error">
    <h3>We have a little problem</h3>
    <p>Your premium payment failed. Please make sure we've got your details right.</p>
</app-message>
<app-message class="success">
    <h3>Success!</h3>
    <p>Congrats, you've successfully created an account.</p>
</app-message>
<app-message class="error">
    <h3>Sorry, this form has some issues</h3>
    <p>It looks like we need a little more information from you</p>
    <ul>
        <li>Please enter your name</li>
        <li>It looks like your email address is invalid</li>
        <li>You must be thirteen or older to create an account</li>
    </ul>
</app-message>
```

Okay, after we save it looks a little different now with the icons and whatnot:

<div>
<img src="{{ '/assets/img/content/uploads/2025/02-06/demo-2.jpg' | relative_url }}" alt="Example of a reusable message component with a single generic slot for content projection in an Angular application" width="788" height="894" style="width: 100%; height: auto;">
</div> 

This is because we have these icons and some basic styles already included in our [message component](https://stackblitz.com/edit/stackblitz-starters-nj2lwayp?file=src%2Fmain.ts,src%2Fmessage%2Fmessage.component.scss).

But this is awesome, we’ve just created a reusable message component that encapsulates all the markup and styling, and we can drop any content we need into it.

Super clean, super flexible.

### Why You Won’t See `<ng-content>` in the DOM

Now, here’s something important to keep in mind: the `<ng-content>` element isn’t a real DOM element. 

It’s not an Angular [component](https://angular.dev/api/core/Component), and it’s not a [directive](https://angular.dev/api/core/Directive) either.

It’s just a placeholder that Angular uses to inject content during rendering.

So, you might expect to see this `<ng-content>` tag if we inspect the final output, right?

Let’s check:

<div>
<img src="{{ '/assets/img/content/uploads/2025/02-06/demo-3.gif' | relative_url }}" alt="Inspecting the DOM of a reusable message component with a single generic slot for content projection in an Angular application" width="1722" height="592" style="width: 100%; height: auto;">
</div> 

Well, we see our message component. 

Inside it we can see the SVG icon from the component template, and the `<article>` element.

But notice inside the `<article>`, there’s no `<ng-content>` tag.

That’s because Angular replaces it entirely with the projected content.

And this is crucial to remember because it means you can’t add directives, apply styles, or bind properties directly to it. 

It’s purely a placeholder at compile time.

Alright, so that’s how we add a basic, generic content slot.

But what if we want more structure in our component?

What if we need multiple content regions?

Well, good news, we can set this up easily and I’ll show you how!

## Target Specific Content with Named Slots

Let’s start by adding a `<header>` element for our title and we’ll drop in another `<ng-content>` element:

```html
<svg>...</svg>
<header>
    <ng-content></ng-content>
</header>
<article>
    <ng-content></ng-content>
</article>
```

Now, here’s something interesting, at this point we have two generic content regions. 

But the way Angular processes this is that the last one wins. 

That means the first slot in the header gets completely ignored during content projection.

But don’t worry, we can fix that by creating multiple named slots using a special "select" attribute.

This "select" attribute takes a CSS selector to target specific content.

In this case, let’s use `<h3>`:

```html
<header>
    <ng-content select="h3"></ng-content>
</header>
```

Now, Angular will look for any `<h3>` tags between our component’s opening and closing tags and project them right into this header.

And just to be clear, it doesn’t have to be an [element selector](https://developer.mozilla.org/en-US/docs/Learn_web_development/Core/Styling_basics/Basic_selectors#type_selectors). 

You can use a [class](https://developer.mozilla.org/en-US/docs/Learn_web_development/Core/Styling_basics/Basic_selectors#class_selectors) or even an [attribute](https://developer.mozilla.org/en-US/docs/Learn_web_development/Core/Styling_basics/Attribute_selectors) selector if you prefer.

Next, let’s add another select attribute on the original region, but this time targeting the `<p>` tag.

```html
<article>
    <ng-content select="p"></ng-content>
</article>
```

Alright, let’s wrap the article in a `<section>` and we’ll add a `<div>` with a class of "content".

Inside this `<div>`, we’ll place a generic `<ng-content>` region. 

This will catch any content that isn’t an `<h3>` or `<p>`, so everything else will get projected here.

Here's the complete template with multiple slots:

```html
<svg>...</svg>
<header>
    <ng-content select="h3"></ng-content>
</header>
<section>
    <article>
        <ng-content select="p"></ng-content>
    </article>
    <div class="content">
        <ng-content></ng-content>
    </div>
</section>
```

Since we’re already using `<h3>` and `<p>` tags in our main component, there’s no need to change anything else:

<div>
<img src="{{ '/assets/img/content/uploads/2025/02-06/demo-4.jpg' | relative_url }}" alt="Example of a reusable message component with multiple slots for content projection in an Angular application" width="788" height="976" style="width: 100%; height: auto;">
</div> 

Now, after we save, we’ve got some additional borders separating each of these regions.

This is because we have some styles for these regions in our existing stylesheet for this [message component](https://stackblitz.com/edit/stackblitz-starters-nj2lwayp?file=src%2Fmessage%2Fmessage.component.scss) and now that content is projected into them, these styles are applied correctly.

And if we inspect the DOM, you’ll see the <h3> ends up inside the header, the <p> tag inside the article, and all the remaining content lands in the "content" div:

<div>
<img src="{{ '/assets/img/content/uploads/2025/02-06/demo-5.gif' | relative_url }}" alt="Inspecting the DOM of a reusable message component with multiple slots for content projection in an Angular application" width="1366" height="594" style="width: 100%; height: auto;">
</div> 

By using multiple slots like this, we can create specialized regions with custom styling while keeping the component flexible and reusable.

And, we can still accept random content with the generic slot whenever we need it.

## Alias Your Slots for Maximum Flexibility

Now, if all of this still doesn’t give you enough flexibility, don’t worry Angular has another trick up its sleeve.

It supports aliasing for projected content placeholders, giving you even more control.

Let’s say I want to move the <h3> and <p> tags directly into the template:

```html
<header>
    <h3>
        <ng-content select="h3"></ng-content>
    </h3>
</header>
<section>
    <article>
        <p>
            <ng-content select="p"></ng-content>
        </p>
    </article>
    ...
</section>
```

But here’s the thing, it wouldn’t make sense to select these regions using <h3> and <p> tags because we'd end up with the same tags nested inside themselves. 

That’d get messy, right?

So instead, I’m going to swap these out for custom element selectors.

```html
<header>
    <h3>
        <ng-content select="message-title"></ng-content>
    </h3>
</header>
<section>
    <article>
        <p>
            <ng-content select="message-subtitle"></ng-content>
        </p>
    </article>
    ...
</section>
```

Now, if we had [components](https://angular.dev/api/core/Component) or [directives](https://angular.dev/api/core/Directive) matching these custom elements, they’d get projected into the right spots.

But wait, that means we’d have to actually create those [components](https://angular.dev/api/core/Component) or [directives](https://angular.dev/api/core/Directive), or register them in our [custom elements schema](https://angular.dev/guide/components/advanced-configuration#custom-element-schemas), and that feels like overkill for this.

Alternatively, you could use attribute selectors (like [message-title]) if you prefer to keep your HTML more semantic without custom tags.

But for this example, I’m going to stick with the custom element selectors to help illustrate the point.

And, there is another way.

We can switch these elements to something else entirely. 

I’m going to use an [`<ng-container>`](https://angular.dev/api/core/ng-container) because it doesn’t add any extra markup to the DOM.

Now here’s the cool part: we can use a special attribute called "ngProjectAs".

With this, we can tell Angular to treat these containers as if they were custom selectors. 

So for the title, I’ll add "message-title", and for the subtitle, "message-subtitle":

```html
<app-message class="error">
    <ng-container ngProjectAs="message-title">
        We have a little problem
    </ng-container>
    <ng-container ngProjectAs="message-subtitle">
        Your premium payment failed. Please make sure we've got your details right.
    </ng-container>
</app-message>
<app-message class="success">
    <ng-container ngProjectAs="message-title">
        Success!
    </ng-container> 
    <ng-container ngProjectAs="message-subtitle">
        Congrats, you've successfully created an account.
    </ng-container>
</app-message>
<app-message class="error">
    <ng-container ngProjectAs="message-title">
        Sorry, this form has some issues
    </ng-container>
    <ng-container ngProjectAs="message-subtitle">
        It looks like we need a little more information from you
    </ng-container>
    <ul>
        <li>Please enter your name</li>
        <li>It looks like your email address is invalid</li>
        <li>You must be thirteen or older to create an account</li>
    </ul>
</app-message>
```

And that’s it!

<div>
<img src="{{ '/assets/img/content/uploads/2025/02-06/demo-4.jpg' | relative_url }}" alt="Example of a reusable message component with aliased slots using ngProjectAs for content projection in an Angular application" width="788" height="976" style="width: 100%; height: auto;">
</div> 

When we save it looks the same, right? 

That’s how you know it’s working. 

Now, I probably wouldn’t do this exact setup in this scenario for a real-world project, but you might find this handy in more complex scenarios where flexibility is key.

So, "ngProjectAs" lets us alias content to match specific selectors in our component template, giving us more flexibility without creating extra components or directives.

## No Content? No Problem! How to Use Fallback Content in Angular

Alright, with everything we've covered so far, you might run into situations where you need to display some default content when nothing gets projected into a specific region.

This is considered "fallback content".

Implementing fallback content is super simple, just add the default content between your opening and closing `<ng-content>` tags.

```html
<header>
    <ng-content select="h3">
        We've had an error
    </ng-content>
</header>
<section>
    <article>
        <ng-content select="p">
            It looks like something went wrong, you'll need to try again.
        </ng-content>
    </article>
    ...
</section>
```

That way, if no content is passed into these slots, the fallback text will automatically show up instead.

Now, let’s go ahead and add an empty message component in our [main app component](https://stackblitz.com/edit/stackblitz-starters-dpmxauxu?file=src%2Fmain.ts) with the rest of the messages:

```html
<app-message class="error"></app-message>
```

And after we save, our fallback content is showing up just like we want:

<div>
<img src="{{ '/assets/img/content/uploads/2025/02-06/demo-6.jpg' | relative_url }}" alt="Example of a reusable message component with fallback content for content projection in an Angular application" width="790" height="290" style="width: 100%; height: auto;">
</div> 

## Wrapping Up: Build Flexible, Reusable Angular Components

Okay, I think that’s probably everything you need to know about content projection in Angular!

Now you can build flexible, reusable components with dynamic content, multiple slots, and fallback options. 

If you found this helpful, don't forget to [subscribe](https://www.youtube.com/@briantreese), and check out [my other Angular tutorials](https://www.youtube.com/@briantreese) for more tips and tricks!

{% include banner-ad.html %}

## Additional Resources
* [The demo app BEFORE any changes](https://stackblitz.com/edit/stackblitz-starters-nj2lwayp?file=src%2Fmain.ts)
* [The demo app AFTER making changes](https://stackblitz.com/edit/stackblitz-starters-dpmxauxu?file=src%2Fmain.ts)
* [The official Angular Content Projection documentation](https://angular.dev/guide/components/content-projection)
* [The Web Component Slot element](https://developer.mozilla.org/en-US/docs/Web/HTML/Element/slot)

## Want to See It in Action?
Check out the demo code and examples of these techniques in the Stackblitz example below. If you have any questions or thoughts, don’t hesitate to leave a comment.

<iframe src="https://stackblitz.com/edit/stackblitz-starters-dpmxauxu?ctl=1&embed=1&file=src%2Fmessage%2Fmessage.component.html" style="height: 500px; width: 100%; margin-bottom: 1.5em; display: block;"></iframe>
