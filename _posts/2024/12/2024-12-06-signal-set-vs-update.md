---
layout: post
title: "Angular Signals: set() vs. update()"
date: "2024-12-06"
video_id: "PspwrAECtnM"
tags: 
  - "Angular"
  - "Angular Signals"
  - "Computed Signals"
  - "Linked Signal"
---

<p class="intro"><span class="dropcap">H</span>ey there, Angular fans! So, <a href="https://angular.dev/guide/signals">signals</a> are a fairly new concept in Angular but I’m sure many of you out there are using them often. And if you’re anything like me, when using <a href="https://angular.dev/guide/signals#writable-signals">writable signals</a>, you’ve probably found yourself wondering when to use the set() vs. the update() method. Well, in this tutorial, we’re diving into this question to help you understand why you may want to use one over the other.</p>

{% include youtube-embed.html %}

## A Case for the Signal update() Method

First, let's start with a case for the update() method.

Here, we’re using the [Petpix application](https://stackblitz.com/edit/stackblitz-starters-gq628z?file=src%2Fpurchase-form%2Fpurchase-form.component.html) that I use for many of my [Angular tutorials](https://www.youtube.com/@briantreese):

<div>
<img src="{{ '/assets/img/content/uploads/2024/12-06/demo-1.png' | relative_url }}" alt="Example of the Petpix application" width="786" height="1302" style="width: 100%; height: auto;">
</div>

In this application we have a form where users can purchase prints of the photos that others have shared:

<div>
<img src="{{ '/assets/img/content/uploads/2024/12-06/demo-2.png' | relative_url }}" alt="Example of the Petpix application showing the purchase form" width="784" height="518" style="width: 100%; height: auto;">
</div>

And in this form, the user can adjust the quantity of prints that they want to purchase:

<div>
<img src="{{ '/assets/img/content/uploads/2024/12-06/demo-3.png' | relative_url }}" alt="Example of the Petpix application showing the purchase form quantity field" width="788" height="406" style="width: 100%; height: auto;">
</div>

Now, at the moment, clicking on these buttons does nothing.

This is because they aren’t yet wired up, and this is what we’re going to do in this tutorial.

Ok, let’s look at the code for this [purchase form component](https://stackblitz.com/edit/stackblitz-starters-gq628z?file=src%2Fpurchase-form%2Fpurchase-form.component.html).

First, we have the "quantity" input and the buttons to add or remove items:

```html
<input type="number" [(ngModel)]="quantity">
<button (click)="remove()">-</button>
<button (click)="add()">+</button>
```

We have a “quantity” property that we use the [ngModel](https://angular.dev/api/forms/NgModel) directive to update when the value entered changes.

So, if I change the quantity to 2, we’ll see that our "total" and "shipping and handling" values change as well:

<div>
<img src="{{ '/assets/img/content/uploads/2024/12-06/demo-4.gif' | relative_url }}" alt="Example of directly adjusting the quantity field and seeing the total and shipping and handling values update" width="778" height="520" style="width: 100%; height: auto;">
</div>

This is all happening because this “quantity” property is already a [signal](https://angular.dev/guide/signals) which we’ll see in a minute. 

But for now, just understand that it’s a [signal](https://angular.dev/guide/signals) and the "total" and "shipping and handling" values are also [signals](https://angular.dev/guide/signals) that are computed using this “quantity” [signal](https://angular.dev/guide/signals).

The other thing that I want to point out is that the “remove” button is currently calling a remove() method when clicked, and the add button is calling an add() method:

```html
<button (click)="remove()">-</button>
<button (click)="add()">+</button>
```

These two methods are what we’ll be wiring up.

Ok, let’s switch to the [TypeScript for this component](https://stackblitz.com/edit/stackblitz-starters-gq628z?file=src%2Fpurchase-form%2Fpurchase-form.component.ts).

First, we have our “quantity” [signal](https://angular.dev/guide/signals):

```typescript
protected quantity = linkedSignal({
    source: this.imageId,
    computation: () => 1
});
```

This [signal](https://angular.dev/guide/signals) is created using the new [linkedSignal](https://angular.dev/api/core/linkedSignal) function which is both a [writable signal](https://angular.dev/guide/signals#writable-signals) and a [signal](https://angular.dev/guide/signals) that updates when another [signal](https://angular.dev/guide/signals) changes too.

If you’re unfamiliar with this concept, I’ve created a couple of tutorials that you should definitely check out as well:

* [Angular's New linkedSignal() Explained]({% post_url /2024/11/2024-11-15-how-to-use-linked-signal-in-angular %})
* [linkedSignal(): Beyond the Basics]({% post_url /2024/11/2024-11-29-linked-signal-advanced-features %})

So, this property is a [writable signal](https://angular.dev/guide/signals#writable-signals) that, no matter what its value is, it will reset to 1 whenever the “imageId” [signal](https://angular.dev/guide/signals) changes.

We can also see the "total" and "shipping" properties are created as [computed signals](https://angular.dev/guide/signals#computed-signals) that use this “quantity” [signal](https://angular.dev/guide/signals) to determine their values, which is why we saw them update as we adjusted the quantity directly:

```typescript
protected shipping = computed(() => {
    return (this.price() * this.quantity() * 0.085).toFixed(2);
});
protected total = computed(() => {
    return (this.price() * this.quantity() + Number(this.shipping())).toFixed(2);
});
```

So, everything we’ve seen so far is working just fine. 

We just need to wire up the add() and remove() functions for our buttons.

Since we’re working with a [writable signal](https://angular.dev/guide/signals#writable-signals), we can choose either the set() or the update() method when setting the value.

But this scenario is probably best suited for the update() method since we will always need to calculate the new value based on the previous value.

Let's look at why this is.

### Wiring up the add() Function

We'll start with the add() function.

When it’s called, we want to add 1 to the current quantity.

So, let’s use the update() method.

We need to add a callback function with the previous value as an argument, and this allows us to use the previous value and simply add 1 to it:

```typescript
protected add() {
    this.quantity.update(q => q + 1);
}
```

That’s it.

### Wiring up the remove() Function

Now, let’s add the logic to the remove() function.

We’ll still want to use the update() method here because we’re just going to use subtraction instead of addition of course.

But this time, we need to avoid calculating if the value is already equal to 1. 

We don’t want folks to be able to end up with a quantity of zero or a negative quantity.

So, we’ll check that our previous value is greater than 1, then we’ll use a [ternary operator](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Operators/Conditional_operator), and return the previous value minus 1, or if it’s equal to 1 already, we’ll simply return one:

```typescript
protected remove() {
    this.quantity.update(q => q > 1 ? q - 1 : 1);
}
```

Ok, now to be fair, as far as I understand, the use of the update() method versus set() is really just a matter of convenience.

In this case, we could actually use the set() method to do the same calculation. 

We’d just use our [signal](https://angular.dev/guide/signals) in the calculation.

So, this would work exactly the same:

```typescript
protected add() {
    this.quantity.set(this.quantity() + 1);
}
```

But, in a case where we’re relying on the previous value, it probably makes more sense to use update() instead.

And that’s what I use as a rule of thumb as to when to use one or the other.

So, if we save now, let’s see how these buttons work:

<div>
<img src="{{ '/assets/img/content/uploads/2024/12-06/demo-5.gif' | relative_url }}" alt="Example of adjusting the quantity with the add and remove buttons using the signal update() method" width="786" height="514" style="width: 100%; height: auto;">
</div>

Nice, it looks like they work properly when adding and removing items.

So that’s an example of something that I’d probably use the update() method for. 

Now let’s look at an example of something where we may want to use set() instead.

## A Case for the Signal set() Method

Up in the header of our app, we have a hamburger menu button:

<div>
<img src="{{ '/assets/img/content/uploads/2024/12-06/demo-6.png' | relative_url }}" alt="Pointing out the hamburger menu button in the header of the Petpix application" width="788" height="328" style="width: 100%; height: auto;">
</div>

When we click it right now, nothing happens.

Let’s look at the code to see why.

In the [header component](https://stackblitz.com/edit/stackblitz-starters-gq628z?file=src%2Fheader%2Fheader.component.html), we have an [@if](https://angular.dev/tutorials/learn-angular/4-control-flow-if) condition wrapping our [nav component](https://stackblitz.com/edit/stackblitz-starters-gq628z?file=src%2Fnav%2Fnav.component.ts):

```html
@if (showMenu()) {
    <app-nav></app-nav>
}
```

So, we only show this [nav component](https://stackblitz.com/edit/stackblitz-starters-gq628z?file=src%2Fnav%2Fnav.component.ts) when a “showMenu” [signal](https://angular.dev/guide/signals) is true.

Let’s look at the [component TypeScript](https://stackblitz.com/edit/stackblitz-starters-gq628z?file=src%2Fheader%2Fheader.component.ts) to see how this is being set right now:

```typescript
export class HeaderComponent {
    protected showMenu = signal(false);
}
```

Ok, this looks like the problem.

All we have is the [signal](https://angular.dev/guide/signals) declaration with an initial value of false.

So, we need to set it to true when we click the button.

Let’s switch back to the template.

Now, in this case, we don’t care what the previous value was.

When we click on the button, we ALWAYS want the “showMenu” [signal](https://angular.dev/guide/signals) to be set to true.

So, let’s add a click event to our menu button.

When this event fires, we can simply set the [signal](https://angular.dev/guide/signals) to true with the set() method:

```html
<button (click)="showMenu.set(true)">
    ...
</button>
```

Now, on the [navigation component](https://stackblitz.com/edit/stackblitz-starters-npy5er?file=src%2Fnav%2Fnav.component.ts), we have a “close” event that fires when we click anywhere outside of the menu while it’s open.

When this event fires, we want the opposite, we ALWAYS want to set the [signal](https://angular.dev/guide/signals) to false no matter what the previous value was:

```html
@if (showMenu()) {
    <app-nav (close)="showMenu.set(false)"></app-nav>
}
```

Ok, let’s save and try this out:

<div>
<img src="{{ '/assets/img/content/uploads/2024/12-06/demo-7.gif' | relative_url }}" alt="Example of the hamburger menu button opening and closing the navigation menu using a singal and the set() method" width="640" height="1068" style="width: 100%; height: auto;">
</div>

Nice, now the menu opens and closes just like we want.

{% include banner-ad.html %}

## In Conclusion

So, it’s pretty subtle, but if you’re factoring in the old value to update your [signal](https://angular.dev/guide/signals), you’ll probably want to use the update() method.

But, you certainly don’t have to, you can just use the set() method all the time if you want to. 

I don’t think anyone will get mad at you.

Well, I hope that was helpful, I’ve definitely been confused on this in the past.

Don't forget to check out [my other Angular tutorials](https://www.youtube.com/@briantreese) for more tips and tricks.

## Additional Resources
* [The demo BEFORE making any changes](https://stackblitz.com/edit/stackblitz-starters-gq628z?file=src%2Fpurchase-form%2Fpurchase-form.component.ts)
* [The demo AFTER making changes](https://stackblitz.com/edit/stackblitz-starters-npy5er?file=src%2Fpurchase-form%2Fpurchase-form.component.ts)
* [Angular Signals documentation](https://angular.dev/guide/signals)
* [linkedSignal documentation](https://angular.dev/guide/signals/queries)
* [Signal inputs documentation](https://angular.dev/guide/signals/inputs)
* [Computed signals documentation](https://angular.dev/guide/signals#computed-signals) 
* [The ngModel directive documentation](https://angular.dev/api/forms/NgModel)

## Want to See It in Action?
Check out the demo code and examples of these techniques in the Stackblitz example below. If you have any questions or thoughts, don’t hesitate to leave a comment.

<iframe src="https://stackblitz.com/edit/stackblitz-starters-npy5er?ctl=1&embed=1&file=src%2Fpurchase-form%2Fpurchase-form.component.ts" style="height: 500px; width: 100%; margin-bottom: 1.5em; display: block;"></iframe>