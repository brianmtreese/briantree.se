---
layout: post
title: "Every Way to Add Styles in Angular... Which One Should You Use?"
date: "2025-03-06"
video_id: "sZSDguDFH34"
tags:
  - "Angular"
  - "Angular Styles"
  - "Angular Components"
  - "CSS"
  - "host"
---

<p class="intro"><span class="dropcap">E</span>ver felt like styling an Angular component is a bit like ordering coffee? You think it's simple, but then you realize there are a million ways to do it! Well, in this tutorial, we're going to break down the many different ways to add styles in Angular components, so you can choose the best approach for your app.</p>

<iframe width="1280" height="720" src="https://www.youtube.com/embed/sZSDguDFH34" title="" frameborder="0" allow="accelerometer; autoplay; clipboard-write; encrypted-media; gyroscope; picture-in-picture; web-share" allowfullscreen></iframe>

## Using the styles Metadata Property for Quick Inline Styles

For this tutorial, we’ll be using [a simple Angular component](https://stackblitz.com/edit/stackblitz-starters-hvsprjc9?file=src%2Fexample%2Fexample.component.ts) with a title, a couple of lines of text, and a button:

<div>
<img src="{{ '/assets/img/content/uploads/2025/03-06/demo-1.png' | relative_url }}" alt="Example of a simple Angular component before adding styles" width="914" height="416" style="width: 100%; height: auto;">
</div>

The easiest way to quickly add styles to a component is to add them directly in the [component decorator](https://angular.dev/api/core/Component), so let’s open the [TypeScript for this example component](https://stackblitz.com/edit/stackblitz-starters-hvsprjc9?file=src%2Fexample%2Fexample.component.ts).

Now, to add styles here, we can add a “styles” property.

This property accepts a [template literal](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Template_literals) also known as a template string.

Within this string, we can simply add CSS, so let’s add some styles to our [component host element](https://angular.dev/guide/components/host-elements):

```typescript
@Component({
  selector: 'app-example',
  ...
  styles: `
    :host {
      display: block;
      padding: 1rem;
      border: solid 2px;
    }
  `
})
```

Now let’s save and see how it looks:

<div>
<img src="{{ '/assets/img/content/uploads/2025/03-06/demo-2.png' | relative_url }}" alt="Example of a simple Angular component after adding styles with the styles metadata property" width="790" height="346" style="width: 100%; height: auto;">
</div>

There, we’ve added some basic styles to the [host element](https://angular.dev/guide/components/host-elements).

That was pretty easy, right?

Now, I rarely do this.

It works well for quick component-specific styles, but it isn't ideal for large applications.

Instead, I prefer to move these styles to an external file.

## Moving Styles to External Stylesheets with styleUrl or styleUrls

To add styles in an external stylesheet, we can link to any existing stylesheet so let’s go ahead and create one for this component.

We'll call it `example.component.css` and we'll create it right within the directory for this component:

<div>
<img src="{{ '/assets/img/content/uploads/2025/03-06/demo-3.png' | relative_url }}" alt="Example of a basic CSS stylesheet for the Angular component" width="990" height="364" style="width: 100%; height: auto;">
</div>

Now, I’ve created a standard CSS stylesheet with the CSS extension, but if you prefer to use a preprocessor like [SCSS](https://sass-lang.com/) or [Less](https://lesscss.org/), you can simply add a file with the proper extension and it should just work.

Okay, now I’m going to copy the styles that we just added into this stylesheet instead:

```css
:host {
  display: block;
  padding: 1rem;
  border: solid 2px;
}
```

Now we can replace the styles property with the styleUrl property instead:

```typescript
@Component({
  selector: 'app-example',
  ...
  styleUrl: './example.component.css'
})
```

This property accepts a single string with the path, relative to our component, to the stylesheet.

Now, if you happen to have more than one stylesheet that you want to include, you can change this styleUrl property to styleUrls instead:

```typescript
@Component({
  selector: 'app-example',
  ...
  styleUrls: [
    './example.component.css',
    'new-stylesheet.css'
  ]
})
```

This property accepts an array of path strings.

So that’s an option, but I rarely need to do that, so I’ll stick with the styleUrl property and the single stylesheet.

Now, let’s save and make sure it works:

<div>
<img src="{{ '/assets/img/content/uploads/2025/03-06/demo-2.png' | relative_url }}" alt="Example of some basic CSS added in an external stylesheet in an Angular component" width="790" height="346" style="width: 100%; height: auto;">
</div>

Nice, it looks the same, so we know that it’s working correctly.

So this is how I add styles for components most often, and I normally prefer to use [SCSS](https://sass-lang.com/) just because it makes things easier to build and maintain although this is becoming less and less the case as CSS continues to advance over time.

Adding the styles in external stylesheets keeps styles modular and makes them easier to maintain.

Personally, I prefer not to edit CSS directly in the TypeScript file.

Now these options work great for more static styles, but sometimes we may need to add styles programmatically.

## Dynamically Applying Styles with Style Binding

If we find ourselves needing to do this, we can use [style binding](https://angular.dev/guide/templates/binding#css-class-and-style-property-bindings) in the [component template](https://stackblitz.com/edit/stackblitz-starters-hvsprjc9?file=src%2Fexample%2Fexample.component.html).

Let’s look at how we do this.

Before we switch to the [template](https://stackblitz.com/edit/stackblitz-starters-hvsprjc9?file=src%2Fexample%2Fexample.component.html), I want to point out that I’ve already added a "warningColor" [signal](https://angular.dev/api/core/signal) here set to the value "blue":

```typescript
export class ExampleComponent {
  warningColor = signal('blue');
  ...
}
```

Normally, if you need to programmatically add styles you’ll be doing it based off some sort of data or something, but I’ve just hard coded it for the purposes of this demo.

Okay, let’s switch to the [template](https://stackblitz.com/edit/stackblitz-starters-hvsprjc9?file=src%2Fexample%2Fexample.component.html).

To bind a style we add square brackets, then we add the style attribute, followed by a dot and the property that we want to add, in our case this will be the [background](https://developer.mozilla.org/en-US/docs/Web/CSS/background) property.

Then we’ll simply bind this style to our "warningColor" [signal](https://angular.dev/api/core/signal):

```html
<button [style.background]="warningColor()">Change Color</button>
```

Ok, that’s it so let’s save:

<div>
<img src="{{ '/assets/img/content/uploads/2025/03-06/demo-4.png' | relative_url }}" alt="Example of a button with a blue background color style added with basic style binding in Angular" width="1042" height="384" style="width: 100%; height: auto;">
</div>

Cool, now the button is blue.

So, this works for binding a single style property, but what if we need to bind multiple styles?

Well, we can do this too.

### Binding Multiple Styles with Style Object Syntax

We can start by removing the `.background` from the [style binding](https://angular.dev/guide/templates/binding#css-class-and-style-property-bindings).

Then we’ll replace the [signal](https://angular.dev/api/core/signal) with an object.

Now within this object, we can add multiple styles.

So, let’s add the background, and let’s add a color too:

```html
<button
  [style]="{ 
    'background': warningColor(),
    'color': 'white'
  }"
>
  Change Color
</button>
```

Okay, now let’s save and see how this works:

<div>
<img src="{{ '/assets/img/content/uploads/2025/03-06/demo-5.png' | relative_url }}" alt="Example of a button with a multiple styles added with the style binding in Angular" width="1046" height="386" style="width: 100%; height: auto;">
</div>

Nice, now we have changed both the background color and the text color.

So, that’s how we can [bind styles](https://angular.dev/guide/templates/binding#css-class-and-style-property-bindings) in the template, but what about the component’s [host element](https://angular.dev/guide/components/host-elements)?

Well, we can do this too.

### Binding Styles Directly to the Component Host Element

Let’s switch back to the [component TypeScript](https://stackblitz.com/edit/stackblitz-starters-hvsprjc9?file=src%2Fexample%2Fexample.component.ts).

Here, we already have a function created to generate a random color:

```typescript
export class ExampleComponent {
  ...
  protected setRandomColor() {
    const color = `#${Math.floor(Math.random() * 16777215).toString(16)}`;
  }
}
```

So, I’m going to add a new property called “color”.

It’ll be a [signal](https://angular.dev/api/core/signal), and we’ll give it an initial hex value for yellow.

```typescript
export class ExampleComponent {
  ...
  private color = signal('#ffff00');
}
```

Okay, now in the random color function, let’s set this [signal](https://angular.dev/api/core/signal) to the random color:

```typescript
export class ExampleComponent {
  ...
  protected setRandomColor() {
    const color = `#${Math.floor(Math.random() * 16777215).toString(16)}`;
    this.color.set(color);
  }
}
```

Okay, now for the last part, we need to call this function when our button is clicked.

So we’ll add a [click event](https://angular.dev/guide/templates/event-listeners) on the button, and then when clicked, we’ll call the `setRandomColor()` function:

```html
<button (click)="setRandomColor()">Change Color</button>
```

Ok now we’re toggling the color value when this button is clicked so we need to bind this color style to our [component host](https://angular.dev/guide/components/host-elements).

Let’s switch back to [the TypeScript](https://stackblitz.com/edit/stackblitz-starters-hvsprjc9?file=src%2Fexample%2Fexample.component.ts).

To bind to the [host element](https://angular.dev/guide/components/host-elements), we need to add the `host` property.

In this object, we can bind attributes on the host just like we do on elements within the template.

We use square brackets, the style attribute, followed by a dot and the property that we want to add.

Then we can bind this to our color signal:

```typescript
@Component({
  selector: 'app-example',
  ...
  host: {
    '[style.background]': 'color()'
  }
})
```

So now it should start out with a yellow background and then when we click the button, it should change to a random color.

Let’s save and try it out:

<div>
<img src="{{ '/assets/img/content/uploads/2025/03-06/demo-6.gif' | relative_url }}" alt="Example of a component with a yellow background that changes to a random color when the button is clicked using host element style binding in Angular" width="792" height="348" style="width: 100%; height: auto;">
</div>

Nice, now it’s yellow to start, then when we click the button it changes to a random color.

Pretty cool, right?

This isn’t something you’ll need to do a lot but it’s good to know about for when you do need it.

## Programmatic Styling with Renderer2 setStyle()

Next up, now that we know how we can programmatically add styles to elements that we have access to, sometimes we may find ourselves with the need to do the same with dynamic markup.

This is the type of code that may be injected from a third party library, from an API call, or something along those lines.

Here in our [component](https://stackblitz.com/edit/stackblitz-starters-hvsprjc9?file=src%2Fexample%2Fexample.component.ts) template I’m simulating this concept with this “content” [signal](https://angular.dev/api/core/signal) by binding it with [innerHTML](https://developer.mozilla.org/en-US/docs/Web/API/Element/innerHTML).

It contains some hardcoded markup:

```typescript
export class ExampleComponent {
  ...
  protected content = signal(`
    <h2>This is Title</h2>
    <p>Here is the first line of this message.</p>
    <p>This is the second line of this message.</p>`);
}
```

Then, in the [template](https://stackblitz.com/edit/stackblitz-starters-hvsprjc9?file=src%2Fexample%2Fexample.component.html) here, we are injecting this content by binding it with [innerHTML](https://developer.mozilla.org/en-US/docs/Web/API/Element/innerHTML):

```html
<div [innerHTML]="content()"></div>
```

This means that we have no way to bind to the markup elements in this [innerHTML](https://developer.mozilla.org/en-US/docs/Web/API/Element/innerHTML).

But we can actually do it with the [Renderer2](https://angular.dev/api/core/Renderer2) class.

So, let’s switch back to [the TypeScript](https://stackblitz.com/edit/stackblitz-starters-hvsprjc9?file=src%2Fexample%2Fexample.component.ts).

The first thing we need to do is add a property for the [Renderer2](https://angular.dev/api/core/Renderer2) and inject it with the [inject()](https://angular.dev/api/core/inject) function:

```typescript
import { ..., inject, Renderer2 } from '@angular/core';

export class ExampleComponent {
  ...
  private renderer = inject(Renderer2);
}
```

We also need to add an elementRef property and inject the [ElementRef](https://angular.dev/api/core/ElementRef) class:

```typescript
import { ..., ElementRef } from '@angular/core';

export class ExampleComponent {
  ...
  private elementRef = inject(ElementRef);
}
```

Next, we need to add a constructor and within it, we’ll add the [afterNextRender()](https://angular.dev/api/core/afterNextRender) method:

```typescript
import { ..., afterNextRender } from '@angular/core';

export class ExampleComponent {
  ...
  constructor() {
    afterNextRender(() => {
    });
  }
}
```

This method will allow us to access the markup after the component has been rendered.

Within the callback for this method, I’m going to add a variable for the [host element](https://angular.dev/guide/components/host-elements), and we’ll access it with the `nativeElement` on the [ElementRef](https://angular.dev/api/core/ElementRef):

Then I’m going to create another variable called "title" where I'll use the [host element](https://angular.dev/guide/components/host-elements) to query for an `H2` element within:

```typescript
export class ExampleComponent {
  ...
  constructor() {
    afterNextRender(() => {
      const host = this.elementRef.nativeElement;
      const title = host.querySelector('h2');
    });
  }
}
```

Then we'll have programmatic access to this `H2` element which means that we can add styles with the [Renderer2](https://angular.dev/api/core/Renderer2) class and its `setStyle()` method.

This method needs three arguments:

1. The first is the element that we want to set style on, this will be our "title" element
2. Then we need to give it the property that we want to add as a string, we'll add the [color](https://developer.mozilla.org/en-US/docs/Web/CSS/color) property
3. Then we need to provide the value that we want to add for this property, we'll give it “red”

```typescript
export class ExampleComponent {
  ...
  private renderer = inject(Renderer2);
  private elementRef = inject(ElementRef);

  constructor() {
    afterNextRender(() => {
      const host = this.elementRef.nativeElement;
      const title = host.querySelector('h2');
      this.renderer.setStyle(title, 'color', 'red');
    });
  }
}
```

Okay, that should be it, let’s save and see:

<div>
<img src="{{ '/assets/img/content/uploads/2025/03-06/demo-7.png' | relative_url }}" alt="Example of a component with a title that changes to red using the Renderer2 setStyle method in Angular" width="1038" height="366" style="width: 100%; height: auto;">
</div>

Nice, now the title is red.

Again, this is something that you shouldn’t need often but it’s useful when styling dynamic content that Angular doesn’t directly control.

## Using Global Styles for App-Wide Style Control

Okay, if all this wasn’t enough, we also have the ability to add styles outside of components that are applied globally across the application.

By default, when you create a new Angular application, it will be configured to include a stylesheet at the app level that will simply be included in the [head](https://developer.mozilla.org/en-US/docs/Web/HTML/Element/head) of the application.

This is similar to what you may already be used to with standard stylesheets on the web.

You can find this stylesheet by looking in your [angular.json](https://stackblitz.com/edit/stackblitz-starters-hvsprjc9?file=angular.json) configuration file

Here, you can see we have a `global_styles.css` stylesheet in the `src` directory:

<div>
<img src="{{ '/assets/img/content/uploads/2025/03-06/demo-8.png' | relative_url }}" alt="Example of the path to a global stylesheet in an Angular application in the angular.json configuration file" width="1314" height="428" style="width: 100%; height: auto;">
</div>

So, let’s open this stylesheet and add some styles for paragraph tags:

```css
p {
  font-family: Arial, Helvetica, sans-serif;
  font-size: 120%;
  color: gray;
}
```

These styles will be applied to all `p` tags in the entire application.

Let’s save and see how it looks:

<div>
<img src="{{ '/assets/img/content/uploads/2025/03-06/demo-9.png' | relative_url }}" alt="Example of global styles applied to a paragraph tag in an Angular application" width="1036" height="364" style="width: 100%; height: auto;">
</div>

Nice, now the paragraphs have some basic styles applied.

I mean this component is pretty ugly but hopefully you get the idea.

When using this concept for styles, you need to be careful because they are applied globally, meaning you can easily break things unexpectedly and make things difficult to maintain.

Personally, I prefer to use these sparingly for things like general [CSS resets](https://meyerweb.com/eric/tools/css/reset/), basic overall font styles, and similar global styles.

## Best Practices: Choosing the Right Styling Approach in Angular

Alright, we’ve seen a lot here, so let’s recap.

#### Using the Styles Metadata Property

We want to use the styles metadata property for quick, small styles.

#### Using the styleUrl(s) Metadata Properties

We should use the styleUrl or styleUrls to create more structured, organized styles with external stylesheets.

#### Using Style Binding

We can use [style binding](https://angular.dev/guide/templates/binding#css-class-and-style-property-bindings) both within the template and on the component host when programmatic styles are needed.

#### Using the Renderer2 setStyle() Method

We can use the [Renderer2 setStyle method](https://angular.dev/api/core/Renderer2#setStyle) when we need to add programmatic styles to markup that Angular doesn’t control or as another method for programmatic styles when [style binding](https://angular.dev/guide/templates/binding#css-class-and-style-property-bindings) doesn’t work.

#### Using Global Styles

And finally, we can add global, app-wide styles for things like theming and other defaults.

Each approach has its place, so choose based on your use case!

## Wrapping Up

And that’s it! You now have a complete toolkit for adding styles in Angular components.

Which method do you use most often?

If you found this helpful, don't forget to [subscribe](https://www.youtube.com/c/briantreese?sub_confirmation=1) and check out [my other Angular tutorials](https://www.youtube.com/@briantreese) for more tips and tricks!

{% include banner-ad.html %}

## Additional Resources

- [Angular Component Styling Guide](https://angular.dev/guide/components/styling)
- [Angular Renderer2 API Docs](https://angular.dev/api/core/Renderer2)
- [Angular Host Metadata Docs](https://angular.dev/guide/components/host-elements)
- [My course: “Styling Angular Applications”](https://app.pluralsight.com/library/courses/angular-styling-applications/table-of-contents)

Check out the demo code showcasing these techniques in the StackBlitz project below. If you have any questions or thoughts, don’t hesitate to leave a comment.

<iframe src="https://stackblitz.com/edit/stackblitz-starters-qxkaj3gi?ctl=1&embed=1&file=src%2Fexample%2Fexample.component.ts" style="height: 500px; width: 100%; margin-bottom: 1.5em; display: block;"></iframe>
