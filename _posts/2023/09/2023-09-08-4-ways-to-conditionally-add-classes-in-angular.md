---
layout: post
title: "4 Angular Class Binding Patterns You Should Actually Be Using"
date: "2023-09-01"
video_id: "sAa8QyFkVkI"
tags:
  - "Angular"
  - "Angular Directives"
  - "Angular Forms"
  - "Angular Styles"
  - "RxJS"
---

<p class="intro"><span class="dropcap">C</span>onditionally adding CSS classes is one of the most common tasks in Angular, and also one of the most misunderstood. Between [class], [class.someClass], ngClass, and now modern signal-driven patterns, it's easy to end up with unreadable templates or brittle styling logic. In this article, you'll learn the four class binding patterns you should actually be using in Angular in 2025, when to use each one, and how to avoid the most common performance and readability pitfalls. All examples work with Angular v19+ and modern component patterns.</p>

{% include youtube-embed.html %}

## Using Angular Class Binding

So class binding is something that you'd want to use in more simplistic cases where we basically just either want a class on an element or not. For example, we may want to add a disabled class to a button in a form when the form is invalid. To do this we simply add the word class in square brackets, followed by a dot and then our disabled class name. Then, we will bind this when our control is invalid.

```html
<form>
  ...
  <input [formControl]="emailControl" type="email" />
  ...
  <button [class.disabled]="emailControl.invalid">Subscribe</button>
</form>
```

## Using the Angular ngClass Directive

When we encounter more complex scenarios, we may find ourselves needing to use the `ngClass` directive instead of Angular class binding. The directive gives us more flexibility and allows us to use more advanced logic for adding and removing class names. In this example, we want to switch between two different classes on our wrapping `fieldset` depending on whether the form is valid or not.

To use the `ngClass` directive, we still use the square brackets, but this time we're going to use a ternary operator and when our control is invalid we'll add a class of 'invalid' and when it's not we'll add a class of 'valid'.

```html
<form>
  <fieldset [ngClass]="emailControl.invalid ? 'invalid' : 'valid'">
    ...
    <input [formControl]="emailControl" type="email" />
    ...
  </fieldset>
</form>
```

## Using Angular @HostBinding

⚠️ **Note:** The `@HostBinding` decorator shown below is no longer recommended in modern Angular. It exists exclusively for backwards compatibility. For the modern approach, see [Host Element Binding]({% post_url 2024/07/2024-07-05-angular-tutorial-host-element-binding %}) or the [Angular Docs: Binding to Host Elements](https://angular.dev/guide/components/host-elements#binding-to-the-host-element).

What if we have the need to conditionally bind a class on the host of our Angular Component or Directive? Well this is where the Angular `@HostBinding` decorator comes into play. To do this we add the `@HostBinding` decorator within our component class and within this is will look much like our class binding example. We'll add the class name followed by a dot and then the class. Then we use a field, we'll call this one 'isValid' and we'll initialize it to false.

To update this field, we'll need to subscribe to our email control status changes event and then simply update the value based on the status.

```typescript
...
import { inject, DestroyRef } from '@angular/core';

export class FormComponent implements OnInit {
  @HostBinding('class.valid') isValid = false;
  ...
  private destroyRef = inject(DestroyRef);

  ngOnInit() {
    this.emailControl.statusChanges
      .pipe(takeUntilDestroyed(this.destroyRef))
      .subscribe((status) => this.isValid = status === 'VALID');
  }
}
```

## Using Angular Renderer2 addClass and removeClass Methods

When we need to get real crazy and do something like add a class to the body element from within our component, this may seem near impossible in Angular. But, fortunately it's not. We can reach for the Angular Renderer2 class which allows us to do several different things. For our purposes for conditionally adding classes to elements, we are only concerned with the add and remove class methods.

First, we need to make sure that we inject the Renderer2 into our component via the constructor. Then, we we will add a ternary operator within our status changes observable subscription for our control. If its status valid, we will want to add the class to our `document.body` element, and if it's invalid, we will want to be sure to remove the valid class.

```typescript
...
import { inject, DestroyRef, Renderer2 } from '@angular/core';

export class FormComponent implements OnInit {
  ...
  private destroyRef = inject(DestroyRef);
  private renderer = inject(Renderer2);

  ngOnInit() {
    this.emailControl.statusChanges
      .pipe(takeUntilDestroyed(this.destroyRef))
      .subscribe((status) => {
        ...
        status === 'VALID'
          ? this.renderer.addClass(document.body, 'valid')
          : this.renderer.removeClass(document.body, 'valid');
      });
  }
}
```

{% include banner-ad.html %}

## In Conclusion

Okay so we now have four different ways to conditionally add and remove classes in Angular. First, we used class binding for more simple, straight forward cases. Then we used the `ngClass` directive where more advanced logic was needed. After that we used the @HostBinding decorator to conditionally bind classes to our component host element. And finally, when all else failed and we needed something else, we used the Renderer2 add and remove class methods to bridge the gap.

So hopefully that helps you out along your way and gives you some options when you need to programmatically add or remove classes.

### Want to See It in Action?

Check out the demo code and examples of these techniques in the stackblitz example below. If you have any questions or thoughts, don’t hesitate to leave a comment.

<iframe src="https://stackblitz.com/edit/stackblitz-starters-gn5o3d?ctl=1&embed=1&file=src%2Fform%2Fform.component.ts" style="height: 500px; width: 100%; margin-bottom: 1.5em; display: block;">
