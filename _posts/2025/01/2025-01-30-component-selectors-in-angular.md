---
layout: post
title: "Component Selectors in Angular: Everything You Need to Know"
date: "2025-01-30"
video_id: "aFQuBmHYTUQ"
tags: 
  - "Angular"
  - "Angular Components"
  - "Custom Elements"
---

<p class="intro"><span class="dropcap">N</span>ot all Angular component selectors are created equal! Choosing the right one can impact your app’s flexibility and maintainability. In this tutorial, I’ll walk you through all the component selector options in Angular, helping you decide which one best fits your component. By the end, you’ll know exactly which selector to use and why!</p>

<iframe width="1280" height="720" src="https://www.youtube.com/embed/aFQuBmHYTUQ" title="" frameborder="0" allow="accelerometer; autoplay; clipboard-write; encrypted-media; gyroscope; picture-in-picture; web-share" allowfullscreen></iframe>

## Custom Elements as Component Selectors: The Default

By default, when you [generate](https://angular.dev/cli/generate/component) a new Angular component, the selector will be a custom element.

In our app here, we can see this exact thing in our [icon-button.component.ts](https://stackblitz.com/edit/stackblitz-starters-8nwvgxvn?file=src%2Ficon-button%2Ficon-button.component.ts):

```typescript
@Component({
    selector: 'app-icon-button',
    ...
})
```

When it was generated, it was generated with this [custom element](https://developer.mozilla.org/en-US/docs/Web/API/Web_components/Using_custom_elements) selector.

Then, whenever we want to use this component, we need to add this [custom element](https://developer.mozilla.org/en-US/docs/Web/API/Web_components/Using_custom_elements):

```html
<app-icon-button
    (clicked)="signUp()"
    label="Sign Up" 
    message="And Save Today!">
</app-icon-button>
```

So, this works well in many cases, but in this particular case it’s not great.

With a standard [HTML button](https://developer.mozilla.org/en-US/docs/Web/HTML/Element/button) we’d have direct access to the [click event](https://developer.mozilla.org/en-US/docs/Web/API/Element/click_event), but since this component uses a [custom element](https://developer.mozilla.org/en-US/docs/Web/API/Web_components/Using_custom_elements) for the selector, the button is added within the [template](https://stackblitz.com/edit/stackblitz-starters-8nwvgxvn?file=src%2Ficon-button%2Ficon-button.component.html):

```html
<button (click)="clicked.emit()">
    ...
<button>
```

This requires us to add an [output](https://angular.dev/api/core/output?tab=api) to emit the [click event](https://developer.mozilla.org/en-US/docs/Web/API/Element/click_event) from the button so that we can properly react to it in the parent component.

So, we can use a [custom element](https://developer.mozilla.org/en-US/docs/Web/API/Web_components/Using_custom_elements), and in many cases this will work great, but sometimes we may want/need to use something else as the selector.

Luckily, Angular provides several different options for component selectors.

## Using Native HTML Elements as Component Selectors

In this case, the ideal scenario would be for us to target the [HTML button element](https://developer.mozilla.org/en-US/docs/Web/HTML/Element/button) generically as our component host right?

Well, this is actually supported.

We can simply use an existing [HTML element](https://developer.mozilla.org/en-US/docs/Web/CSS/Type_selectors) as a selector:

```typescript
@Component({
    selector: 'button',
    ...
})
```

Ok, now that we’re using the [button element](https://developer.mozilla.org/en-US/docs/Web/HTML/Element/button) as the selector, we are able to remove the old click [output](https://angular.dev/api/core/output?tab=api) since we'll now have direct access to the button's [click event](https://developer.mozilla.org/en-US/docs/Web/API/Element/click_event) in the parent component.

We can also remove the button from the template.

Then, we just need to change our old `app-icon-button` [custom element](https://developer.mozilla.org/en-US/docs/Web/API/Web_components/Using_custom_elements) to a standard [HTML button](https://developer.mozilla.org/en-US/docs/Web/HTML/Element/button), and we can switch the old [output](https://angular.dev/api/core/output?tab=api) to a standard [click event](https://developer.mozilla.org/en-US/docs/Web/API/Element/click_event):

```html
<button
    (click)="signUp()"
    label="Sign Up" 
    message="And Save Today!">
</button>
```

Ok, let’s save and make sure this all works correctly still:

<div>
<img src="{{ '/assets/img/content/uploads/2025/01-30/demo-1.jpg' | relative_url }}" alt="Example of an Angular icon-button component using an HTML button element as the selector" width="996" height="498" style="width: 100%; height: auto;">
</div> 

Yep, everything looks good right?

So, we can use an existing [HTML element](https://developer.mozilla.org/en-US/docs/Web/CSS/Type_selectors) as the selector, but this may not be a great idea in this case either because it means that every button in this app will now become an icon-button component.

Most likely, we don't want this.

As a matter of fact, we have two buttons right in the [page.component.html](https://stackblitz.com/edit/stackblitz-starters-8nwvgxvn?file=src%2Fpage-content%2Fpage-content.component.html) that have been negatively impacted by this change:

```html
<button class="signUp">
    ...
</button>
<button class="menu">
    ...
</button>
```

Normally these buttons are displayed in the upper right corner of the page, but since they are now icon-button components, they’re no longer displayed correctly:

<div>
<img src="{{ '/assets/img/content/uploads/2025/01-30/demo-2.jpg' | relative_url }}" alt="Example of buttons being displayed incorrectly in the page because the icon-button component is using a button element as the selector" width="840" height="920" style="width: 100%; height: auto;">
</div> 

## Filtering Elements with :not() – A Smart Exclusion Trick

Well in this case, we have another option.

The CSS [:not()](https://developer.mozilla.org/en-US/docs/Web/CSS/:not) pseudo class is supported in the component selector too.

So here, we could omit the button with the “signUp” class as well as the button with the “menu” class:

```typescript
@Component({
    selector: 'button:not(.signUp):not(.menu)',
    ...
})
```

This will now ignore these two buttons leaving them as they were.

Let’s save and see if we get these buttons back now:

<div>
<img src="{{ '/assets/img/content/uploads/2025/01-30/demo-3.jpg' | relative_url }}" alt="Example of buttons being displayed correctly in the page because the icon-button component is using the :not() pseudo class to filter button elements with specific classes as the selector" width="1123" height="976" style="width: 100%; height: auto;">
</div> 

Nice, those buttons are back, and our icon-button component is still working correctly too.

So, the [:not()](https://developer.mozilla.org/en-US/docs/Web/CSS/:not) pseudo class provides us with another option, but again in this case it's probably not exactly what we’d want because as the app grows, this list of buttons to ignore will continue to grow too.

## Attribute-Based Selectors: A Flexible Approach

Well, we have yet another option.

Angular also supports [attributes](https://developer.mozilla.org/en-US/docs/Web/CSS/Attribute_selectors) as a selector.

These attributes could be known [HTML attributes](https://developer.mozilla.org/en-US/docs/Web/HTML/Attributes) like `href`, `src`, `title`, or they could be custom attributes that we define ourselves.

Let's change the selector to a custom attribute instead, it will need to be wrapped in square brackets just as if we were using it as a CSS selector in a stylesheet:

```typescript

@Component({
    selector: '[appIconButton]',
    ...
})
```

Now we just need to add this attribute to our button:

```html
<button
    appIconButton
    (click)="signUp()"
    label="Sign Up" 
    message="And Save Today!">
</button>
```

Ok, now let’s save and see if this still works correctly:

<div>
<img src="{{ '/assets/img/content/uploads/2025/01-30/demo-1.jpg' | relative_url }}" alt="Example of an Angular icon-button component using an attribute selector" width="1123" height="976" style="width: 100%; height: auto;">
</div> 

Yep, looks good right?

So, this is a great option for this scenario.

Most likely, this is what I would choose for this sort of thing.

But we do still have a few more options.

## CSS Class-Based Component Selectors

Angular supports using a [CSS class](https://developer.mozilla.org/en-US/docs/Web/CSS/Class_selectors) as a selector.

So, we can switch this to a standard [CSS class selector](https://developer.mozilla.org/en-US/docs/Web/CSS/Class_selectors) instead.

```typescript
@Component({
    selector: '.appIconButton',
    ...
})
```

Then, we need to add this class to our button element and we can remove the custom attribute that we were just using:

```html
<button
    class="appIconButton"
    (click)="signUp()"
    label="Sign Up" 
    message="And Save Today!">
</button>
```

Ok, let’s save and make sure this works:

<div>
<img src="{{ '/assets/img/content/uploads/2025/01-30/demo-1.jpg' | relative_url }}" alt="Example of an Angular icon-button component using a CSS class selector" width="1123" height="976" style="width: 100%; height: auto;">
</div> 

Nice, so we can use a [CSS class](https://developer.mozilla.org/en-US/docs/Web/CSS/Class_selectors) as a selector too.

So we’ve seen several different options for component selectors, and there’s still one more!

## Combining Selectors for Precision Targeting

Angular supports combinations of selectors too.

Let’s say we want to target an [HTML button element](https://developer.mozilla.org/en-US/docs/Web/CSS/Type_selectors) but only when it has the `.appIconButton` [CSS class](https://developer.mozilla.org/en-US/docs/Web/CSS/Class_selectors) on it.

Well, we can add this combination as a selector too:

```typescript
@Component({
    selector: 'button.appIconButton',
    ...
})
```

We don’t need to change anything else since it was already a button with this class in our template, so let’s save and make sure this still works correctly:

<div>
<img src="{{ '/assets/img/content/uploads/2025/01-30/demo-1.jpg' | relative_url }}" alt="Example of an Angular icon-button component using a combination of selectors" width="1123" height="976" style="width: 100%; height: auto;">
</div> 

Yep, there it is.

So, we can even use more complex combinations of selectors if needed.

## Defining Multiple Selectors for Maximum Flexibility

Ok, if all of this wasn’t enough, we have more options when it comes to component selectors.

We can provide multiple selectors if needed.

In this case we already match on buttons with the `.appIconClass` selector, but what if we needed to use other selectors too?

Well, we can simply provide a comma-separated list and add more selectors as needed.

Like if we want to support the custom attribute and the [custom element](https://developer.mozilla.org/en-US/docs/Web/API/Web_components/Using_custom_elements), we can simply add them to the list:

```typescript
@Component({
    selector: 'button.appIconButton, [appIconButton], app-icon-button',
    ...
})
```

So now, to add this component, we can add a button with the `.appIconButton` class, we can add the custom `appIconButton` attribute to any element, or we can add the `app-icon-button` [custom element](https://developer.mozilla.org/en-US/docs/Web/API/Web_components/Using_custom_elements).

Any of these options will work now.

So, we have a lot of different options when it comes to component selectors, but looking at this example, I would say that the right fit here is the [attribute](https://developer.mozilla.org/en-US/docs/Web/CSS/Attribute_selectors) selector.

## Custom Selector Prefixes in Angular

It’s also important to note that the Angular team recommends using a [standard short prefix](https://angular.dev/style-guide#component-custom-prefix) for [custom element](https://developer.mozilla.org/en-US/docs/Web/API/Web_components/Using_custom_elements) and attribute selectors for components.

By default, the [Angular CLI](https://angular.dev/tools/cli) uses a prefix of “app”, so that’s what we’re using here.

You can customize this prefix in [the config](https://angular.dev/reference/configs/workspace-config#project-configuration-options) for your own app or [Angular library](https://angular.dev/tools/libraries).

It’s a good idea to follow this format to keep your code more organized and to be able to tell what’s going on at a glance.

{% include banner-ad.html %}

## Which Angular Selector Will You Use?

So there you have it! Angular gives us a ton of flexibility when it comes to component selectors, from [custom elements](https://developer.mozilla.org/en-US/docs/Web/API/Web_components/Using_custom_elements) to [HTML tags](https://developer.mozilla.org/en-US/docs/Web/CSS/Type_selectors), [attributes](https://developer.mozilla.org/en-US/docs/Web/CSS/Attribute_selectors), and even [class-based selectors](https://developer.mozilla.org/en-US/docs/Web/CSS/Class_selectors).

Plus, we can fine-tune things with [:not()](https://developer.mozilla.org/en-US/docs/Web/CSS/:not) and even combine selectors for more precision.

Choosing the right selector can make a big difference in how your components behave and interact in your app. 

In this case, the [attribute](https://developer.mozilla.org/en-US/docs/Web/CSS/Attribute_selectors) selector was the best fit, but depending on your use case, another option might be better!

If you found this helpful, don't forget to check out [my other Angular tutorials](https://www.youtube.com/@briantreese) for more tips and tricks!

## Additional Resources
* [The demo BEFORE making changes](https://stackblitz.com/edit/stackblitz-starters-8nwvgxvn?file=src%2Ficon-button%2Ficon-button.component.ts)
* [The demo AFTER making changes](https://stackblitz.com/edit/stackblitz-starters-gqutyymb?file=src%2Ficon-button%2Ficon-button.component.ts)
* [Angular component selectors documentation](https://angular.dev/guide/components/selectors)
* [My course: “Styling Angular Applications”](https://app.pluralsight.com/library/courses/angular-styling-applications/table-of-contents)

## Want to See It in Action?
Check out the demo code and examples of these techniques in the Stackblitz example below. If you have any questions or thoughts, don’t hesitate to leave a comment.

<iframe src="https://stackblitz.com/edit/stackblitz-starters-gqutyymb?ctl=1&embed=1&file=src%2Ficon-button%2Ficon-button.component.ts" style="height: 500px; width: 100%; margin-bottom: 1.5em; display: block;"></iframe>
