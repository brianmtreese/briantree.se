---
layout: post
title: "Angular's New linkedSignal() Explained"
date: "2024-11-15"
video_id: "FxEN329zmRQ"
tags:
  - "Angular"
  - "Angular Effects"
  - "Angular Forms"
  - "Angular Signals"
  - "Angular Styles"
  - "Computed Signals"
  - "Linked Signal"
---

<p class="intro"><span class="dropcap">A</span>ngular 19 is here and that means that it’s time to learn some new stuff. In this tutorial, we’re getting hands-on with Angular’s latest <a href="https://angular.dev/guide/signals">signal</a> feature, the <a href="https://next.angular.dev/api/core/linkedSignal">linkedSignal()</a> function. It’s a powerful way to create <a href="https://angular.dev/guide/signals">signals</a> that are both writable, and that automatically update based on changes in other <a href="https://angular.dev/guide/signals">signals</a> without improperly using the <a href="https://angular.dev/guide/signals#effects">effect()</a> function. Let’s dive right in and see how this new function can streamline reactive updates in your Angular Apps!</p>

{% include youtube-embed.html %}

## Angular Version Disclaimer

Just a quick heads up before we get too far along, the features we’ll see in this tutorial are only available in Angular 19 and above which should be released at some point later this month (November 2024).

## Getting to Know the Existing Demo Application

For this example, we have a demo application called Petpix, where people share images of their pets.

In this app, when viewing different photos, users have the ability to purchase prints of the photos they like:

<div>
<img src="{{ '/assets/img/content/uploads/2024/11-15/demo-1.png' | relative_url }}" alt="Example of the Petpix application showing the purchase form" width="1062" height="529" style="width: 100%; height: auto;">
</div>

As we switch between the images, we get different pricing as the images have different values set by their owners:

<div>
<img src="{{ '/assets/img/content/uploads/2024/11-15/demo-2.gif' | relative_url }}" alt="Example of the Petpix application showing the different pricing as images are changed" width="754" height="672" style="width: 100%; height: auto;">
</div>

In our purchase form, we have a [textarea](https://developer.mozilla.org/en-US/docs/Web/HTML/Element/textarea) where we can add special notes.

So far, all of this works great, but if we add notes and then switch to another image, the text remains in the [textarea](https://developer.mozilla.org/en-US/docs/Web/HTML/Element/textarea):

<div>
<img src="{{ '/assets/img/content/uploads/2024/11-15/demo-3.gif' | relative_url }}" alt="Example of the Petpix application adding special notes and switching images" width="752" height="670" style="width: 100%; height: auto;">
</div>

We want to clear this text when switching images because the notes may not make sense for the new image.

So, let’s make this happen.

## Understanding the Existing Code

The [purchase form](https://stackblitz.com/edit/stackblitz-starters-6a5q2n?file=src%2Fpurchase-form%2Fpurchase-form.component.ts) is a component that is included only once in the template for our [slider component](https://stackblitz.com/edit/stackblitz-starters-6a5q2n?file=src%2Fslider%2Fslider.component.html).

```html
<app-purchase-form 
    [price]="selectedImage().price" 
    [imageId]="selectedImage().id">
</app-purchase-form>
```

This component has two [inputs](https://angular.dev/guide/signals/inputs) to pass both the price and the imageId for the selected image. These inputs are [signals](https://angular.dev/guide/signals) since they use the new [signal input](https://angular.dev/api/core/Input) function:

```typescript
import { ..., input } from "@angular/core";

price = input.required<number>();
imageId = input.required<number>();
```

Then, we have a protected “specialNotes” field that is a writable [signal](https://angular.dev/guide/signals), used to store the value entered in our [textarea](https://developer.mozilla.org/en-US/docs/Web/HTML/Element/textarea):

```typescript
import { ..., signal } from "@angular/core";

protected specialNotes = signal('');
```

In the template, we have the “special notes” [textarea](https://developer.mozilla.org/en-US/docs/Web/HTML/Element/textarea), where we’re using the [ngModel](https://angular.dev/api/forms/NgModel) directive to leverage [two-way binding](https://angular.dev/guide/templates/two-way-binding) with the “specialNotes” [signal](https://angular.dev/guide/signals).

```html
<label>
    <span>Special Notes (Optional)</span>
    <textarea [(ngModel)]="specialNotes"></textarea>
</label>
```

So, if this “specialNotes” [signal](https://angular.dev/guide/signals) were to be updated programmatically elsewhere, the [textarea](https://developer.mozilla.org/en-US/docs/Web/HTML/Element/textarea) value would also update here.

And if its value were used somewhere else, it would update properly as the value entered in this [textarea](https://developer.mozilla.org/en-US/docs/Web/HTML/Element/textarea) changes.

Alright, so that’s how it works currently, now how do we reset the value when switching between images?

Well, this is where the new [linkedSignal](https://next.angular.dev/api/core/linkedSignal) comes into play.

## Signal Effects and Computed Signals Fall Short

Currently, the “specialNotes” field is a writable [signal](https://angular.dev/guide/signals), which is what we need.

But we need to update this [signal](https://angular.dev/guide/signals) when another [signal](https://angular.dev/guide/signals), our “imageId” input, changes.

Up to this point, the main tools we had for this situation were:

* The [effect()](https://angular.dev/guide/signals#effects) function
* [Computed signals](https://angular.dev/guide/signals#computed-signals).

But both of these have limitations in this case.

With the [effect()](https://angular.dev/guide/signals#effects) function, we can easily respond to changes in another [signal](https://angular.dev/guide/signals), but there are [issues with setting other signal values within an effect](https://www.youtube.com/watch?v=aKxcIQMWSNU).

So we shouldn’t really do it unless we have a really good reason.

Using a [computed signal](https://angular.dev/guide/signals#computed-signals) allows us to base a [signal](https://angular.dev/guide/signals)'s value on another [signal](https://angular.dev/guide/signals), but computed signals are not writable.

So that won’t work here either.

But now we have a new tool, a [linkedSignal](https://next.angular.dev/api/core/linkedSignal).

## Creating an Auto-Updating Writable Signal with Angular’s New Linked Signal Primitive

A [linkedSignal](https://next.angular.dev/api/core/linkedSignal) allows us to create a writable [signal](https://angular.dev/guide/signals) that can be updated when an associated [signal](https://angular.dev/guide/signals) value changes.

This way, we can write directly to this [signal](https://angular.dev/guide/signals) when we type in our [textarea](https://developer.mozilla.org/en-US/docs/Web/HTML/Element/textarea), and we can reset this [signal](https://angular.dev/guide/signals) when our “imageId” changes.

To do this, we can replace the [signal()](https://angular.dev/guide/signals) function with the new [linkedSignal()](https://next.angular.dev/api/core/linkedSignal) function instead.

We need to be sure that it gets imported from the @angular/core module.

Within this [linkedSignal()](https://next.angular.dev/api/core/linkedSignal) function, we need to provide two options:

1. The first is the "source" [signal](https://angular.dev/guide/signals), which we use to monitor for changes. This will be our “imageId” [signal](https://angular.dev/guide/signals) input.

2. The second option is a "computation" function that updates the [signal](https://angular.dev/guide/signals)'s value. For us, we simply want to set this to an empty string when we switch the “imageId”.

```typescript
protected specialNotes = linkedSignal({
    source: this.imageId,
    computation: () => ''
});
```

And that’s all we need to do here.

Let’s save, add some notes, switch images, and see if it works now:

<div>
<img src="{{ '/assets/img/content/uploads/2024/11-15/demo-4.gif' | relative_url }}" alt="Example of the special notes field properly clearing when switching images after changing to linkedSignal" width="754" height="658" style="width: 100%; height: auto;">
</div>

Great! Now it properly clears out when we switch the image.

So a [linkedSignal](https://next.angular.dev/api/core/linkedSignal) was a pretty good choice for this situation.

## Auto-Resetting the Quantity Signal When Switching Images with Linked Signal

In this demo there is another issue we need to address in this form.

Currently, we can update our quantity, and the price and shipping values update as expected when the quantity changes:

<div>
<img src="{{ '/assets/img/content/uploads/2024/11-15/demo-5.gif' | relative_url }}" alt="Example of the quantity field not resetting when switching images" width="754" height="690" style="width: 100%; height: auto;">
</div>

But, like the notes field, we need to reset the quantity to "1" whenever we switch images.

This is virtually the same issue.

The quantity field is set to a writable [signal](https://angular.dev/guide/signals) using the [signal()](https://angular.dev/guide/signals) function:

```typescript
protected quantity = signal(1);
```

When we hit the “add” and “remove” buttons, we call the respective functions to update the quantity:

```typescript
protected add() {
    this.quantity.update(q => q + 1);
}

protected remove() {
    this.quantity.update(q => q > 1 ? q - 1 : 1);
}
```

If we look at [the template](https://stackblitz.com/edit/stackblitz-starters-6a5q2n?file=src%2Fpurchase-form%2Fpurchase-form.component.html), we can see that the quantity field uses [two-way binding](https://angular.dev/guide/templates/two-way-binding) and the [ngModel](https://angular.dev/api/forms/NgModel) directive just like the "special notes" example:

```html
<input type="number" [(ngModel)]="quantity">
<button (click)="remove()">-</button>
<button (click)="add()">+</button>
```

This allows the value to be updated when the quantity [signal](https://angular.dev/guide/signals) is set programmatically.

Then, when the “add” and “remove” buttons are clicked, or when a number is typed directly into the [textbox](https://developer.mozilla.org/en-US/docs/Web/HTML/Element/input/text), the quantity [signal](https://angular.dev/guide/signals)'s value is updated too.

So, we just need to change this like we did for the "special notes" field, so that it resets when the “imageId” [signal](https://angular.dev/guide/signals) input changes.

Let’s switch it over to a [linkedSignal](https://next.angular.dev/api/core/linkedSignal) as well.

Just like the "special notes" example, we’ll use the “imageId” [signal](https://angular.dev/guide/signals) as the source.

For our computation, we’ll simply set it to 1:

```typescript
protected quantity = linkedSignal({
    source: this.imageId,
    computation: () => 1
});
```

And that’s it.

Now let’s save, change the quantity, then switch the image:

<div>
<img src="{{ '/assets/img/content/uploads/2024/11-15/demo-6.gif' | relative_url }}" alt="Example of the quantity field properly resetting when switching images after changing to linkedSignal" width="754" height="672" style="width: 100%; height: auto;">
</div>

Great! Now it resets to 1, just like we wanted.

So now, everything here is working as desired and is doing so using [signals](https://angular.dev/guide/signals) in the most efficient way.

{% include banner-ad.html %}

## In Conclusion

So, in Angular 19, the introduction of the [linkedSignal()](https://next.angular.dev/api/core/linkedSignal) function provides a powerful tool to create writable, auto-updating [signals](https://angular.dev/guide/signals) that respond dynamically to changes in other [signals](https://angular.dev/guide/signals).

This should help clear up some of the confusion on when to use the [effect()](https://angular.dev/guide/signals#effects) function.

With the [linkedSignal()](https://next.angular.dev/api/core/linkedSignal) function, you'll probably need an [effect()](https://angular.dev/guide/signals#effects) even less than you did before.

Hope this was helpful.

Don't forget to check out [my other Angular tutorials](https://www.youtube.com/@briantreese) for more tips and tricks.

## Additional Resources
* [Linked Signal documentation](https://next.angular.dev/api/core/linkedSignal)
* [Signal inputs documentation](https://angular.dev/guide/signals/inputs)
* [Computed signals documentation](https://angular.dev/guide/signals#computed-signals)
* [Effect function documentation](https://angular.dev/guide/signals#effects)
* [NgModel directive documentation](https://angular.dev/api/forms/NgModel)

## Want to See It in Action?
Check out the demo code and examples of these techniques in the Stackblitz example below. If you have any questions or thoughts, don’t hesitate to leave a comment.

<iframe src="https://stackblitz.com/edit/stackblitz-starters-z5epre?ctl=1&embed=1&file=src%2Fpurchase-form%2Fpurchase-form.component.ts" style="height: 500px; width: 100%; margin-bottom: 1.5em; display: block;"></iframe>
