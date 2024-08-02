---
layout: post
title: "Can You Create a Signal From Another Signal? You Bet You Can!"
date: "2024-08-01"
video_id: "GSkDLJG3104"
categories: 
  - "angular"
---

<p class="intro"><span class="dropcap">S</span>ignals are now a core concept in the Angular framework. When you build components, directives, and services, you’re going to want use them going forward. And as you do, at some point you’ll likely ask yourself the question: how can I create a <a href="https://angular.dev/guide/signals">signal</a> based on the values from another signal? Well, in this post, I’m going to show you how, and it won’t take very long either!</p>

<iframe width="1280" height="720" src="https://www.youtube.com/embed/GSkDLJG3104" title="" frameborder="0" allow="accelerometer; autoplay; clipboard-write; encrypted-media; gyroscope; picture-in-picture; web-share" allowfullscreen></iframe>

## The Demo Application

For the examples in this video we will be using [this simple photo sharing application](https://stackblitz.com/edit/stackblitz-starters-q2jusu?file=src%2Fpurchase-form%2Fpurchase-form.component.ts) for a fake company called “Petpix”. The idea is that folks can use this application to share interesting images of their pets with other animal lovers.

<div>
<img src="{{ '/assets/img/content/uploads/2024/08-01/demo-1.png' | relative_url }}" alt="The demo pet photo sharing application Petpix" width="1102" height="1014" style="width: 100%; height: auto;">
</div>

The area that we’ll be focused on will be down at the bottom where people can purchase a print of the photo. We need to wire up the shipping and handling value as well as the order total because, as you can see, when we switch images, the price is the only data that changes.

<div>
<img src="{{ '/assets/img/content/uploads/2024/08-01/demo-2.gif' | relative_url }}" alt="Cycling through images showing that the photo price value changes but the shipping and total remain $0.00" width="1102" height="1014" style="width: 100%; height: auto;">
</div>

So, let’s take a look at the code to see what we’ll need in order to pull this off. 

For the display of this purchase region, we have a [purchase form component](https://stackblitz.com/edit/stackblitz-starters-q2jusu?file=src%2Fpurchase-form%2Fpurchase-form.component.ts) and right now, it’s a really simple component.

#### purchase-form.component.ts
```typescript
import { Component, input } from "@angular/core";

@Component({
    selector: 'app-purchase-form',
    standalone: true,
    templateUrl: './purchase-form.component.html',
    styleUrl: './purchase-form.component.scss'
})
export class PurchaseFormComponent {
    price = input.required<number>();
}
```

There’s not much to it. All it has is an [input()](https://angular.dev/guide/signals/inputs) for the price of the photo.

Let’s look at the [template](https://stackblitz.com/edit/stackblitz-starters-q2jusu?file=src%2Fpurchase-form%2Fpurchase-form.component.html) real quick to understand what we’re currently displaying.

#### purchase-form.component.html
```html
<h3>Purchase this Photo:</h3>
<table>
    <tr>
        <td>Price:</td>
        <td>${% raw %}{{ price() }}{% endraw %}</td>
    </tr>
    <tr>
        <td>Shipping &amp; handling:</td>
        <td>$0.00</td>
    </tr>
    <tr>
        <td>Order total:</td>
        <td>$0.00</td>
    </tr>
</table>
<footer>
    <button>Place your order</button>
</footer>
```

We have a table of data with a row for the price using the string interpolated value of our price input. And then for the shipping and total data, we just have the $0.00 values hard coded right within the template.

To fix this we are going to create a couple of new signals for these values. To create these signals, we will be using the [computed()](https://angular.dev/api/core/computed) function. This function allows us to create a signal based on the values of other signals. Its value will be automatically updated every time any of the signals used within are updated.

## Creating the “Shipping” Signal from the Price Input with the Computed Function

Let’s start by creating a property for the "shipping & handling" value. First, we’ll add a new protected field, let’s call it “shipping”. Then we’ll set its value by adding the new computed() function. This function requires a “computation” function as a parameter.

This “computation” function will need to return the value for our signal. To create this value, we are going to multiply our “price” input value by 0.085 or 8.5%. Then we’ll use the [toFixed()](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/Number/toFixed) function to round this value to the nearest two decimal places.

#### purchase-form.component.ts
```typescript
import { ..., computed } from "@angular/core";

protected shipping = computed(() => {
    return (this.price() * 0.085).toFixed(2);
});
```

Now we can switch over to the template and replace the existing content with the string interpolated value of our new signal.

#### purchase-form.component.html
```html
<tr>
    <td>Shipping &amp; handling:</td>
    <td>${% raw %}{{ shipping() }}{% endraw %}</td>
</tr>
```

Now if we save, we should see the propper "shipping & handling" value. And as we switch between the images, we should see that the value is properly updated based on the price of the photo too.

<div>
<img src="{{ '/assets/img/content/uploads/2024/08-01/demo-3.gif' | relative_url }}" alt="Cycling through images showing that the shipping and handling value now changes after calculating it using the computed function" width="752" height="1078" style="width: 100%; height: auto;">
</div>

## Creating the “Total” Signal by Combining the Price and Shipping Signals with the Computed Function

Ok, now let’s create a signal for the "total" using our “price” input and our new “shipping” signal. To do this, let’s add a new protected field called “total” and we’ll set its value, just as we did with the shipping value, using the computed() function.

We’ll take the value of the “price” and we’ll add the value of the "shipping" signal. But for this we’ll need to convert it to a number which we can do with the [Number()](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/Number) function. Then, just like the shipping signal, we’ll round it to two decimal places with the toFixed() function.

#### purchase-form.component.ts
```typescript
protected total = computed(() => {
    return (this.price() + Number(this.shipping())).toFixed(2);
});
```

Ok, that should be all we need. So let’s update it in the template now.

#### purchase-form.component.html
```html
<tr>
    <td>Order total:</td>
    <td>${% raw %}{{ total() }}{% endraw %}</td>
</tr>
```

Ok, now when we save, we should have the proper total value two.

<div>
<img src="{{ '/assets/img/content/uploads/2024/08-01/demo-4.gif' | relative_url }}" alt="Cycling through images showing that the overall total value now changes after calculating it using the computed function" width="752" height="1076" style="width: 100%; height: auto;">
</div>

Pretty cool right?

## In Conclusion
Not only is this a pretty slick way to do this sort of thing but there are some key performance benefits too. For one, computed signals are only calculated when the value is needed, so the first time the value is read.

Computed signals are also memoized too. So once the value is read for the first time, it’s then cached and then the next time it’s read, it will return the cached value. So, they’re pretty cool all around.

I hope you found this tutorial helpful, and if you did, check out [my YouTube channel](https://www.youtube.com/@briantreese) for more tutorials about various topics and features within Angular.

## Additional Resources
* [The official computed signals documentation](https://angular.dev/guide/signals#computed-signals)
* [The computed function documentation](https://angular.dev/api/core/computed)
* [JavaScript toFixed documentation](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/Number/toFixed)
* [JavaScript Number() function documentation](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/Number)

## Want to See It in Action?
Check out the demo code and examples of these techniques in the in the Stackblitz example below. If you have any questions or thoughts, don’t hesitate to leave a comment.

<iframe src="https://stackblitz.com/edit/stackblitz-starters-9kev39?ctl=1&embed=1&file=src%2Fpurchase-form%2Fpurchase-form.component.ts" style="height: 500px; width: 100%; margin-bottom: 1.5em; display: block;"></iframe>