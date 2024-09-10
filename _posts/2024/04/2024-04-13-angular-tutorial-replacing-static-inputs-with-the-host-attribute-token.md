---
layout: post
title: "Replacing Static Inputs with the Host Attribute Token"
date: "2024-04-13"
video_id: "vwFP4Gkbw-g"
categories: 
  - "angular"
---

<p class="intro"><span class="dropcap">I</span>f you build things with Angular, you probably already know that you need to keep up with the framework as it evolves over time. Well, in this post, I’m going to help you do just that. We’re going to take a look at the new <a href="https://angular.io/api/core/HostAttributeToken"><code>HostAttributeToken</code></a> injection token and why you may want to use it. In this post we’ll use an example of an existing button component with <a href="https://angular.io/guide/signal-inputs">inputs</a> and we’ll replace them with the <a href="https://angular.io/api/core/inject"><code>inject()</code></a> function and the <a href="https://angular.io/api/core/HostAttributeToken"><code>HostAttributeToken</code></a> class. Alright, let’s get to it!</p>

<iframe width="1280" height="720" src="https://www.youtube.com/embed/vwFP4Gkbw-g" title="" frameborder="0" allow="accelerometer; autoplay; clipboard-write; encrypted-media; gyroscope; picture-in-picture; web-share" allowfullscreen></iframe>

## Starting with the Demo Component and Inputs

Let’s get started by taking a look at the example that we’re going to use in this post. We have a [demo application](https://stackblitz.com/edit/stackblitz-starters-cve27c?file=src%2Fbutton%2Fbutton.component.ts) for the Vans clothing brand. For the concepts we will cover in this post, we’re going to be focusing on these two buttons here.

<div>
<img src="{{ '/assets/img/content/uploads/2024/04-13/demo-application.gif' | relative_url }}" alt="Example of a demo application before converting inputs to the inject() function and HostAttributeToken class" width="1280" height="720" style="width: 100%; height: auto;">
</div>

They have been added using a button component.

#### page-content.component.html
```html
...
<button
    app-button
    primaryLabel="Sign Up"
    secondaryLabel="And Save Today!">
</button>
...
<button
    app-button
    primaryLabel="Shop Now">
</button>
...
```

When we look at the code for this component, we see that we are using the [`input`](https://angular.io/guide/signal-inputs) function for our “primary” and “secondary” labels. Also, the primary label is required, meaning if we use this component but fail to provide a primary label, we will receive an error.

### The Downside to Using Inputs for Static Values

Now, this works totally fine, but in this app we know that we only ever need to provide static string literal values for the labels when using this button component. We are going to set them once and that’s it. They won’t need to change dynamically so maybe an `input()` is not the best idea.

When we use an `input()`, Angular will create a binding that it will then need to check on every change detection cycle. This isn’t great since we will really only ever care about the value on initialization. After that it won’t be changed.

Well, this is where the [`@Attribute`](https://angular.io/api/core/Attribute) decorator comes into play.

<div class="shirt-ad">
<a href="https://www.teepublic.com/user/dev-drip" title="Click to get yourself some fresh Angular merch!">
<img src="{{ '/assets/img/dev-drip-banner.png' | relative_url }}" alt="Swoop up some hip new Angular drip! - Dev Drip Merch Shop" width="960" height="275" style="width: 100%; height: auto;"></a>
</div>

## Using the @Attribute Decorator to Improve Performance with Static Values

Since we know these values are going to be a static string literal we can instead convert them over to attributes. To do this, we need to start by adding a `constructor()`. Then we can add the `@Attribute` decorator. Within this decorator, we need to provide the attribute name as a string, so in this case it’ll be, “primaryLabel”. Next, let’s include the public modifier, the name will be “primaryLabel” as well, and it will be a string.

#### button.component.ts
```typescript
import { ..., Attribute } from "@angular/core";

@Component({
    selector: '[app-button]',
    ...
})
export class AppButtonComponent {
    ...
    constructor(@Attribute('primaryLabel') public primaryLabel: string) {
    }
}
```

Now, let’s do the same for the “secondaryLabel” property. We’ll add the decorator, the “secondaryLabel” name, and type it to a string as well.

```typescript
import { ..., Attribute } from "@angular/core";

@Component({
    selector: '[app-button]',
    ...
})
export class AppButtonComponent {
    ...
    constructor(@Attribute('primaryLabel') public primaryLabel: string,
                @Attribute('secondaryLabel') public secondaryLabel: string) {
    }
}
```

Ok, now we can remove the inputs and the input import too. Now, since we switched away from [signal inputs](https://angular.io/guide/signal-inputs), we need to go update the template removing the parenthesis from these properties.

### Before:
```html
<strong>{% raw %}{{ primaryLabel() }}{% endraw %}</strong>
@if (secondaryLabel()) {
  <em>{% raw %}{{ secondaryLabel() }}{% endraw %}</em>
}
```

### After:
```html
<strong>{% raw %}{{ primaryLabel }}{% endraw %}</strong>
@if (secondaryLabel) {
  <em>{% raw %}{{ secondaryLabel }}{% endraw %}</em>
}
```

And there we go. We don’t need to do anything else. So, that’s pretty cool. It’s a small optimization but it makes a lot more sense for what we’re doing here. But now, in newer versions of Angular, we can even do this differently.

## Using the `Inject()` Function and the `HostAttributeToken` for Attributes

We can use the [`inject()`](https://angular.io/api/core/inject) function and the new [`HostAttributeToken`](https://angular.io/api/core/HostAttributeToken) class. In this example let’s switch it over.

Let’s start with our “primaryLabel”. Let’s create a field like we had with the input function named “primaryLabel”. Then we’ll use the [`inject()`](https://angular.io/api/core/inject) function. In this function we’ll new up an instance of the new [`HostAttributeToken`](https://angular.io/api/core/HostAttributeToken) class. Then, we need to add the attribute name as a string like we do with the decorator.

```typescript
import { ..., HostAttributeToken, inject } from "@angular/core";

@Component({
    selector: '[app-button]',
    ...
})
export class AppButtonComponent {
    primaryLabel = inject(new HostAttributeToken('primaryLabel'));
}
```

Ok, now let’s do the same for the “secondaryLabel”. Let’s add the field, the inject function, the HostAttributeToken class, and the name of the attribute.

```typescript
import { ..., HostAttributeToken, inject } from "@angular/core";

@Component({
    selector: '[app-button]',
    ...
})
export class AppButtonComponent {
    primaryLabel = inject(new HostAttributeToken('primaryLabel'));
    secondaryLabel = inject(new HostAttributeToken('secondaryLabel'));
}
```

Now let’s remove the old `@Attribute` decorators and the constructor since it’s not needed anymore. Ok, now let’s save and see how this looks.

<div>
<img src="{{ '/assets/img/content/uploads/2024/04-13/compile-error-1.png' | relative_url }}" alt="Error after converting signal-inputs to Attributes using the HostAttributeToken without optional flag" width="1280" height="720" style="width: 100%; height: auto;">
</div>

Uh oh, it looks like we broke it. Well, this is actually one of the benefits of using this method over the old decorator.

## Errors and Optional Attributes Using the `Inject()` Function and the `HostAttributeToken` Class

If we look at the console here, we can see that we have an error for our “secondaryLabel” letting us know that one is not found on our second button where we don’t need the additional label.

<div>
<img src="{{ '/assets/img/content/uploads/2024/04-13/compile-error-2.png' | relative_url }}" alt="Consle error details after converting signal-inputs to Attributes using the HostAttributeToken without optional flag" width="1280" height="720" style="width: 100%; height: auto;">
</div>

So, this is an advantage to using the inject function and this class, we will get a dependency injection error when something is wrong. In this case the fix is pretty simple. We can make this attribute optional.

```typescript
secondaryLabel = inject(new HostAttributeToken('secondaryLabel'), { optional: true });
```

## Conclusion

So, it's just a different way to do this sort of thing. If you can use static string literals for your components and directives, attributes are the way to go. And, if you want runtime dependency injection errors or don’t otherwise have the need for a `constructor()`, you’ll probably want to use the [`inject()`](https://angular.io/api/core/inject) function and the [`HostAttributeToken`](https://angular.io/api/core/HostAttributeToken) .

## Want to See It in Action?
Check out the demo code and examples of these techniques in the in the Stackblitz example below. If you have any questions or thoughts, don’t hesitate to leave a comment.

<iframe src="https://stackblitz.com/edit/stackblitz-starters-latuao?ctl=1&embed=1&file=src%2Fbutton%2Fbutton.component.ts" style="height: 500px; width: 100%; margin-bottom: 1.5em; display: block;">
