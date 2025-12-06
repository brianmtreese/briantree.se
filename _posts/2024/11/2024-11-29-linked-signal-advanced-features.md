---
layout: post
title: "Angular linkedSignal(): Advanced Features and Multiple Sources (v19+)"
date: "2024-11-29"
video_id: "ikAHugi2uAw"
tags:
  - "Angular"
  - "Angular Effects"
  - "Angular Signals"
  - "Angular Styles"
  - "Computed Signals"
  - "Linked Signal"
  - "TypeScript"
---

<p class="intro"><span class="dropcap">A</span>ngular's <code>linkedSignal()</code> goes beyond simple two-way binding with advanced features that enable intelligent update logic. By comparing old and new values, you can create conditional updates, prevent unnecessary changes, and implement complex state synchronization patterns. This tutorial explores advanced <code>linkedSignal()</code> features including value comparison callbacks, multiple source signals, and smart update strategies that optimize performance and reduce unnecessary re-renders.</p>

{% include youtube-embed.html %}

#### Angular Signals Tutorial Series:
- [linkedSignal() Basics]({% post_url /2024/11/2024-11-15-how-to-use-linked-signal-in-angular %}) - Learn the fundamentals of linkedSignal()
- [Signal set() vs update()]({% post_url /2024/12/2024-12-06-signal-set-vs-update %}) - When to use each method
- [Signal Inputs & output()]({% post_url /2024/03/2024-03-24-angular-tutorial-signal-based-inputs-and-the-output-function %}) - Replace @Input/@Output with signals

## Setting the Stage: Inside the Current Demo Application

Here we have the same application that we used in our [previous example]({% post_url /2024/11/2024-11-15-how-to-use-linked-signal-in-angular %}), but now we’ve added a “shipping type” control:

<div>
<img src="{{ '/assets/img/content/uploads/2024/11-29/demo-1.png' | relative_url }}" alt="Example of the Petpix application showing the new shipping type control" width="724" height="1078" style="width: 100%; height: auto;">
</div>

In this application, it’s possible to have different shipping options for different images.

So, if we open the menu, we can see that we have five different options:

<div>
<img src="{{ '/assets/img/content/uploads/2024/11-29/demo-2.png' | relative_url }}" alt="Example of the Petpix application showing the shipping type options for a single image" width="724" height="456" style="width: 100%; height: auto;">
</div>

Then, when we switch to the next image, now we only have three options:

<div>
<img src="{{ '/assets/img/content/uploads/2024/11-29/demo-3.png' | relative_url }}" alt="Example of the Petpix application showing the shipping type options for a different image" width="724" height="453" style="width: 100%; height: auto;">
</div>

For this image, we can’t use USPS or XPO.

Now currently, this “shipping type” control state is not being tracked.

What we’re going to do in this example is create this state using a [linkedSignal](https://next.angular.dev/api/core/linkedSignal).

But first, let’s understand what’s going on.

If we look at the [purchase form component template](https://stackblitz.com/edit/stackblitz-starters-2kcqpn?file=src%2Fpurchase-form%2Fpurchase-form.component.html), here we have a basic HTML [select](https://developer.mozilla.org/en-US/docs/Web/HTML/Element/select) with options listed out from a “shippingOptions” signal.

```html
<select>
    @for (option of shippingOptions(); track option) {
        <option [value]="option">{{ option }}</option>
    }
</select>
```

Let’s look at the [component TypeScript](https://stackblitz.com/edit/stackblitz-starters-2kcqpn?file=src%2Fpurchase-form%2Fpurchase-form.component.ts) to understand where this signal gets its options from.

Here we can see that it comes from an input using the new [signal input function](https://angular.dev/guide/signals/inputs):

```typescript
shippingOptions = input.required<string[]>();
```

So, the shipping options are expected to be provided as an input in the form of an array of strings.

Ok, that’s what we’re starting with, now let’s create a [signal](https://angular.dev/guide/signals) to track the state of this control.

But, before we do, it’s important to note that we want to reset the selected shipping value when switching between images since we can’t guarantee that the selected shipping option will be available for the new image that we’re switching to.

And this is why we want to use a [linkedSignal](https://next.angular.dev/api/core/linkedSignal).

It will allow us to create a [writable signal](https://angular.dev/guide/signals#writable-signals), that can be updated when switching shipping options, but that can be reset when the “shippingOptions” [input signal](https://angular.dev/guide/signals/inputs) is updated.

## Tracking the Selected Shipping Option With Linked Signal

Let’s start by adding a protected, “shippingOption” field, for which we’ll use the [linkedSignal](https://next.angular.dev/api/core/linkedSignal) function:

```typescript
protected shippingOption = linkedSignal();
```

Now, in my previous tutorial, I provided both the source signal, and the computation function, but in this case, we can actually provide a simplified version.

What we want to do here is set the value of this signal to the first shipping option in the list whenever the “shippingOptions” input changes. 

So we can just use that [signal](https://angular.dev/guide/signals), and grab the option with an index of zero:

```typescript
protected shippingOption = linkedSignal(() => this.shippingOptions()[0]);
```

This will use the “shippingOptions” [signal](https://angular.dev/guide/signals) as it’s source and then compute its value from that same [signal](https://angular.dev/guide/signals).

Ok, that’s what we need for our [signal](https://angular.dev/guide/signals), now we need to configure how we update this signal when the select changes.

Let’s use the [ngModel](https://angular.dev/api/forms/NgModel) directive to do this:

```html
<select [(ngModel)]="shippingOption">
    ...
</select>
```

Now to be sure that we understand what’s going on here, let’s use [string interpolation](https://angular.dev/guide/templates/binding#render-dynamic-text-with-text-interpolation) to render the value of this “shippingOption” [signal](https://angular.dev/guide/signals) in the template so that we will know what it's set to as it changes.

```html
{% raw %}{{ shippingOption() }}{% endraw %}
```

Ok, now let’s save and see how this works:

<div>
<img src="{{ '/assets/img/content/uploads/2024/11-29/demo-4.gif' | relative_url }}" alt="Example switching the shipping type to FedEx and then switching images so that the value is reset" width="724" height="936" style="width: 100%; height: auto;">
</div>

Ok, it starts off with “UPS” selected because that is the first value in the list for this particular image.

Then, when we switch this to “FedEx” our signal value is now updated to “FedEx”.

Then, when we switch the image it is reset to “UPS” since it’s the first option in the new list.

So that’s pretty cool right?

But what’s a bummer here is that, in this case, “FedEx” is actually part of this new list of shipping options. 

<div>
<img src="{{ '/assets/img/content/uploads/2024/11-29/demo-5.png' | relative_url }}" alt="Example showing that FedEx is part of the new list of shipping options" width="724" height="936" style="width: 100%; height: auto;">
</div>

So, it would be cool if we could keep the selected value if it still exists in the new list of options.

Well, we can actually do this with [linkedSignal](https://next.angular.dev/api/core/linkedSignal).

## Smarter Linked Signal Resets: Updating Only When Values Change

When using [linkedSignal](https://next.angular.dev/api/core/linkedSignal) we can compare the new value of the source [signal](https://angular.dev/guide/signals) against the previous value.

Let’s switch to the more expanded concept for a [linkedSignal](https://next.angular.dev/api/core/linkedSignal).

Our source [signal](https://angular.dev/guide/signals) will be the “shippingOptions” input and now, we will add a computation function.

Within this function, we can access the current value and the previous value for comparison.

Then we can see if we can find an option with the previous value within the new list of options.

If not, we’ll set it to the first option from the input.

All of this would look something like the following:

```typescript
protected shippingOption = linkedSignal({
    source: this.shippingOptions,
    computation: (current, previous) => 
        current.find(o => o === previous?.value) ?? current[0]
});
```

So, if the currently selected option is found, it will remain the selected value.

If not, it will set it to the first option in the new list.

Alright, let’s save and see how this works now:

<div>
<img src="{{ '/assets/img/content/uploads/2024/11-29/demo-6.gif' | relative_url }}" alt="Example showing that FedEx remains selected when switching images because it is still part of the new list and then the value is reset to UPS when switching images after switching to XPO since its not part of the new list" width="724" height="936" style="width: 100%; height: auto;">
</div>

Ok, “UPS” is selected initially again since it’s the first in the list. 

Then, when we switch to “FedEx” again and switch the image, now we see that “FedEx” remains selected.

Then, when we switch to “XPO”, and then switch images again, we see that the value gets set to “UPS” because “XPO” doesn’t exist in the new list of options.

So, now we have a way to compare current and previous values and update the [signal](https://angular.dev/guide/signals) only when needed.

{% include banner-ad.html %}

## In Conclusion

Ok, so that’s a handy feature available with the new [linkedSignal](https://next.angular.dev/api/core/linkedSignal) function.

Hope that was helpful.

Don't forget to check out [my other Angular tutorials](https://www.youtube.com/@briantreese) for more tips and tricks.

## Additional Resources
* [The demo BEFORE making any changes](https://stackblitz.com/edit/stackblitz-starters-2kcqpn?file=src%2Fpurchase-form%2Fpurchase-form.component.ts)
* [The demo AFTER making changes](https://stackblitz.com/edit/stackblitz-starters-dhcnje?file=src%2Fpurchase-form%2Fpurchase-form.component.ts)
* [linkedSignal documentation](https://angular.dev/guide/signals/queries)
* [Signal inputs documentation](https://angular.dev/guide/signals/inputs)
* [Computed signals documentation](https://angular.dev/guide/signals#computed-signals)
* [The effect function documentation](https://angular.dev/guide/signals#effects)
* [The ngModel directive documentation](https://angular.dev/api/forms/NgModel)

## Want to See It in Action?
Check out the demo code and examples of these techniques in the Stackblitz example below. If you have any questions or thoughts, don’t hesitate to leave a comment.

<iframe src="https://stackblitz.com/edit/stackblitz-starters-dhcnje?ctl=1&embed=1&file=src%2Fpurchase-form%2Fpurchase-form.component.ts" style="height: 500px; width: 100%; margin-bottom: 1.5em; display: block;"></iframe>
