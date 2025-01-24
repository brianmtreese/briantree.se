---
layout: post
title: "Angular Styling Secrets: How to Use :host and :host-context Like a Pro"
date: "2025-01-23"
video_id: "qHge5-9zm2M"
tags: 
  - "Angular"
  - "Angular Styles"
  - "host"
  - "host-context"
  - "CSS"
---

<p class="intro"><span class="dropcap">S</span>tyling Angular components can be tricky, especially with encapsulated styles. But <a href="https://developer.mozilla.org/en-US/docs/Web/CSS/:host">:host</a> and <a href="https://developer.mozilla.org/en-US/docs/Web/CSS/:host-context">:host-context</a> let you target a component’s root element and adapt styles based on its context—without global CSS hacks. In this guide, you'll learn how to apply, modify, and control styles using these selectors, making your components smarter and more flexible. Let’s dive in!</p>

<iframe width="1280" height="720" src="https://www.youtube.com/embed/qHge5-9zm2M" title="" frameborder="0" allow="accelerometer; autoplay; clipboard-write; encrypted-media; gyroscope; picture-in-picture; web-share" allowfullscreen></iframe>

## Understanding :host and :host-context

These selectors originate from [Web Components](https://developer.mozilla.org/en-US/docs/Web/API/Web_components), where encapsulated styling is essential.

Angular's [ViewEncapsulation](https://angular.dev/guide/components/styling#view-encapsulation) mechanism uses the [Shadow DOM](https://developer.mozilla.org/en-US/docs/Web/API/Web_components/Using_shadow_DOM), or at least emulates it, to scope component styles.

[:host](https://developer.mozilla.org/en-US/docs/Web/CSS/:host) lets us style the component’s root element.

And [:host-context](https://developer.mozilla.org/en-US/docs/Web/CSS/:host-context) lets us apply styles based on the context of something higher up in the DOM tree.

Let’s look at how and why we may want to use them.

## Using :host: Styling the Component’s Root Element

Here we have a simple application showing a basic sign-up form:

<div>
<img src="{{ '/assets/img/content/uploads/2025/01-23/demo-1.jpg' | relative_url }}" alt="Example of a basic Angular application before adding component specific styles with :host and :host-context pseudo class selectors" width="900" height="776" style="width: 100%; height: auto;">
</div> 

We need to add a visual container around the contents of this form.

We'll add these styles in the the [stylesheet](https://stackblitz.com/edit/stackblitz-starters-dzh2vp5r?file=src%2Fsign-up-form%2Fsign-up-form.component.scss) for this sign-up form component.

Now, in order to apply styles to the root element of this component, we’ll use the [:host](https://developer.mozilla.org/en-US/docs/Web/CSS/:host) pseudo class:

```scss
:host {
}
```

This is how we access the root element for our styles.

Now let’s add a border to this element:

```scss
:host {
    border: solid 2px;
}
```

Ok, let’s save and see how it looks:

<div>
<img src="{{ '/assets/img/content/uploads/2025/01-23/demo-2.jpg' | relative_url }}" alt="Example of a border added using the :host pseudo class selector without adding display" width="898" height="834" style="width: 100%; height: auto;">
</div> 

Well, that doesn’t look like a border now does it?

This is because, since this Angular component uses a [custom element](https://developer.mozilla.org/en-US/docs/Web/API/Web_components/Using_custom_elements) for its selector, the browser knows nothing about it:

```typescript
@Component({
    selector: 'app-sign-up-form',
    ...
})
```

This means there’s no vendor specific style information, so it's essentially rendered inline.

So, let’s add display to the styles for this element:

```scss
:host {
    display: block;
}
```

Let’s save and check it out now:

<div>
<img src="{{ '/assets/img/content/uploads/2025/01-23/demo-3.jpg' | relative_url }}" alt="Example of a border and display styles added using the :host pseudo class selector" width="898" height="906" style="width: 100%; height: auto;">
</div> 

Nice, now that’s looking more like we’d expect right?

Ok, now let’s round the corners a little and give it a background color too:

```scss
:host {
    display: block;
    border-radius: 0.375em;
    background-color: #eee;
}
```

Ok, let’s see how it looks now:

<div>
<img src="{{ '/assets/img/content/uploads/2025/01-23/demo-4.jpg' | relative_url }}" alt="Example of a container style added using the :host pseudo class selector" width="898" height="896" style="width: 100%; height: auto;">
</div> 

Well, that’s definitely looking better now right?

So we can use this [:host](https://developer.mozilla.org/en-US/docs/Web/CSS/:host) pseudo class to style the root element of our component, but this also means that these styles will always apply when this component is used.

This may not be exactly what we want.

Like here in our blog where the form opens within a modal:

<div>
<img src="{{ '/assets/img/content/uploads/2025/01-23/demo-5.jpg' | relative_url }}" alt="Example of a container style added using the :host pseudo class selector, applied in a modal where it's not needed" width="898" height="1080" style="width: 100%; height: auto;">
</div> 

We don’t want the border or the background color here.

So how can we handle this?

### Enhancing Flexibility: Conditional Styling with :host

Well, we can actually use a class in conjunction with the [:host](https://developer.mozilla.org/en-US/docs/Web/CSS/:host) pseudo class.

To do this, let’s first add a class to the sign-up form element in the [home.component.html](https://stackblitz.com/edit/stackblitz-starters-dzh2vp5r?file=src%2Fhome%2Fhome.component.html) file, let’s call it “contained”:

```html
<app-sign-up-form class="contained"></app-sign-up-form>
```

Ok, now back in our [stylesheet](https://stackblitz.com/edit/stackblitz-starters-dzh2vp5r?file=src%2Fsign-up-form%2Fsign-up-form.component.scss), we just need to add this class selector within parens:

```scss
:host(.contained) {
    border: solid 2px;
    display: block;
    border-radius: 0.375em; 
    background-color: #eee;
}
```

So now these styles will only apply when this class has been added to the host element.

Let’s save and check it out:

<div>
<img src="{{ '/assets/img/content/uploads/2025/01-23/demo-6.gif' | relative_url }}" alt="Example of a container style added using the :host pseudo class selector and a class to target specific instances with these styles" width="898" height="1050" style="width: 100%; height: auto;">
</div> 

Nice, there’s no longer a container in the modal since this instance doesn’t have our new “contained” class, and for the usage in the “Sign-up” page, we still have the container styles since we added the class.

So, this concept definitely comes in handy in certain situations, but what if we decide that we want every single instance of this form to get the container styles except when placed within a modal?

Do we always have to add this “contained” class?

Nope, we have a better way.

We can use the [:host-context](https://developer.mozilla.org/en-US/docs/Web/CSS/:host-context) pseudo class instead.

## Context-Aware: Dynamically Adjusting Styles with :host-context

To start we can remove the “contained” class concept that we just added.

```scss
:host {
    border: solid 2px;
    display: block;
    border-radius: 0.375em; 
    background-color: #eee;
}
```

Now these styles will apply to all instances of this component again.

Now let’s remove the styles that we don’t want in modals.

We'll use the [:host-context](https://developer.mozilla.org/en-US/docs/Web/CSS/:host-context) pseudo class for this.

We'll need to provide a selector to use for context. 

In this case, we’ll use the `app-modal` element selector:

```scss
:host-context(app-modal) {
}
```

So, any time the `app-sign-up-form` element finds itself nested within the `app-modal` element, this selector will match.

Now, let’s remove the background color, and let’s also remove the border in this scenario:

```scss
:host-context(app-modal) {
    background-color: unset;
    border: none;
}
```

Ok, that should do it, let’s save and take a look:

<div>
<img src="{{ '/assets/img/content/uploads/2025/01-23/demo-7.gif' | relative_url }}" alt="Example of a container style added using the :host-context pseudo class selector to target specific instances with these styles" width="896" height="1058" style="width: 100%; height: auto;">
</div> 

Ok, the sign-up page form looks good with the container, and when we switch over to the modal, we see that the container is no longer there.

So now, any time the component is added outside of a modal, it will get the container styles.

But, any time it is added within the modal, these container styles will be removed automatically without any extra effort.

{% include banner-ad.html %}

## Conclusion: Smart, Adaptive Component Styling

So now we’ve seen how [:host](https://developer.mozilla.org/en-US/docs/Web/CSS/:host) helps us style a component’s root element and how [:host-context](https://developer.mozilla.org/en-US/docs/Web/CSS/:host-context) allows us to apply styles based on where a component is used.

Understanding and using these techniques will make your Angular components more flexible, maintainable, and visually consistent across your app.

If you found this helpful you may also want to check out [my course all about styles in Angular](https://app.pluralsight.com/library/courses/angular-styling-applications/table-of-contents).

Also, don't forget to check out [my other Angular tutorials](https://www.youtube.com/@briantreese) for more tips and tricks!

## Additional Resources
* [My course: “Styling Angular Applications”](https://app.pluralsight.com/library/courses/angular-styling-applications/table-of-contents)
* [Angular styling components documentation](https://angular.dev/guide/components/styling)
* [The :host pseudo class](https://developer.mozilla.org/en-US/docs/Web/CSS/:host)
* [The :host-context pseudo class](https://developer.mozilla.org/en-US/docs/Web/CSS/:host-context)

## Want to See It in Action?
Check out the demo code and examples of these techniques in the in the Stackblitz example below. If you have any questions or thoughts, don’t hesitate to leave a comment.

<iframe src="https://stackblitz.com/edit/stackblitz-starters-rjqxksgc?ctl=1&embed=1&file=src%2Fsign-up-form%2Fsign-up-form.component.scss" style="height: 500px; width: 100%; margin-bottom: 1.5em; display: block;"></iframe>
