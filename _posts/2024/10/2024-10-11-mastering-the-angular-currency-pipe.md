---
layout: post
title: "Mastering the Angular Currency Pipe... Easy Money!"
date: "2024-10-11"
video_id: "9pEmHsmYdKI"
tags:
  - "Accessibility"
  - "Angular"
  - "Angular Components"
  - "Angular Pipe"
  - "Angular Styles"
  - "Currency Formatting"
  - "Currency Pipe"
  - "Localization"
---

<p class="intro"><span class="dropcap">M</span>any developers struggle with displaying currency correctly, especially when dealing with different locales and formats. This is because currency formatting can be complex, with many variables to consider such as decimal separators, currency symbols, and number formatting. It's not just about displaying the currency, but also about making sure it's easily readable and understandable by all users.</p>

{% include youtube-embed.html %}

In this tutorial, we'll explore how to use the [Angular Currency Pipe](https://angular.dev/api/common/CurrencyPipe), including its syntax, parameters, and real-world examples to demonstrate its effectiveness.

Ok, let’s look at an example.

## Adding Properly Formatted and Localized Currency Values with the Angular Currency Pipe

Alright, so here we have a [basic demo application](https://stackblitz.com/edit/stackblitz-starters-zunvaa?file=src%2Fpurchase-form%2Fpurchase-form.component.html) “Petpix” where people share and sell photo prints of their pets.

<div>
<img src="{{ '/assets/img/content/uploads/2024/10-11/demo-1.png' | relative_url }}" alt="Example of a demo application" width="788" height="860" style="width: 100%; height: auto;">
</div>

In this modal where you can order the image, we have the item price, shipping and handling costs, and the total amount.

<div>
<img src="{{ '/assets/img/content/uploads/2024/10-11/demo-2.png' | relative_url }}" alt="Example of a demo application with unformatted currency values" width="1424" height="686" style="width: 100%; height: auto;">
</div>

These prices look strange right? 

We never really see three, four, and five decimal places for currency values. And we can’t just round them and call it good because that wouldn’t work correctly in all locales.

For example, there are no “cents” with the Japanese yen, so if we were to just round these decimals, they wouldn’t exactly work for yen currency values.

So, we need a better way to do this, and that’s where the [Angular Currency Pipe](https://angular.dev/api/common/CurrencyPipe) comes into play. Let’s look at how we do this.

To start, let’s open the [purchase form component TypeScript](https://stackblitz.com/edit/stackblitz-starters-zunvaa?file=src%2Fpurchase-form%2Fpurchase-form.component.ts) file.

We can see there’s a little bit going on in this component already.

We have a number [input](https://angular.dev/api/core/input) for the price of the print:

```typescript
price = input.required<number>();
```

Then we have a shipping [signal](https://angular.dev/api/core/signal) property computed to 8.5% of the price:

```typescript
shipping = computed(() => this.price() * 0.085);
```

And then to get the total, we add the shipping and the price together:

```typescript
total = computed(() => this.price() + this.shipping());
```

So that’s where the values come from, now let’s format them with the currency pipe.

But before we can use the pipe, we first need to import it from the [Common Module](https://angular.dev/api/common/CommonModule), within our component imports array:

```typescript
import { CurrencyPipe } from '@angular/common';

@Component({
  selector: 'app-purchase-form',
  imports: [CurrencyPipe]
})
```

Ok, now we’ll be able to use it in our template.

To display our price value we are simply converting the number value to a string with [string interpolation](https://angular.dev/guide/templates/binding#render-dynamic-text-with-text-interpolation):

```html
<td>{% raw %}{{ price() }}{% endraw %}</td>
```

So, in order to add the [Currency Pipe](https://angular.dev/api/common/CurrencyPipe) here, we start by adding a [pipe character](https://www.thesaurus.com/e/grammar/pipe-symbol/).

If you’re not familiar, this is how you add [pipes](https://angular.dev/guide/pipes) in Angular. Then we follow this pipe with the name of the Angular pipe, in this case it’s simply, the word “currency”:

```html
<td>{% raw %}{{ price() | currency }}{% endraw %}</td>
```

Ok, that’s it. After we save, we can see that the price is now properly formatted with the currency symbol.

<div>
<img src="{{ '/assets/img/content/uploads/2024/10-11/demo-3.png' | relative_url }}" alt="Example of a demo application with properly formatted currency values using the Currency Pipe" width="944" height="374" style="width: 100%; height: auto;">
</div>

Now it may not look like much, it’s just the addition of a dollar sign, right?

Well not exactly.

### Specifying the Specific Currency Code to for the Value

Remember how I said earlier that the Japanese yen doesn’t have a concept for cents?

Well, one of the things we can do with the [Currency Pipe](https://angular.dev/api/common/CurrencyPipe) is, we can specify the specific [currency code](https://en.wikipedia.org/wiki/ISO_4217) to use.

Let’s look at what it looks like for the yen.

To do this, we add a colon, then we’ll add a parameter for the currency code as a string. For the yen it’s JPY:

```html
<td>{% raw %}{{ price() | currency: 'JPY' }}{% endraw %}</td>
```

Ok, now let’s save again and see how it looks:

<div>
<img src="{{ '/assets/img/content/uploads/2024/10-11/demo-4.png' | relative_url }}" alt="Example of a currency value formatted specifically for the Japanese yen using the Currency Pipe" width="944" height="374" style="width: 100%; height: auto;">
</div>

So now we can see some of the power of the [Currency Pipe](https://angular.dev/api/common/CurrencyPipe) right?

It’s properly formatting our currency value, without decimals and displaying the proper currency symbol for the Japanese yen.

And that’s what’s so cool about this pipe. A lot has already been figured out for us.

We don’t have to handle any locale-specific logic when using it and that’s a pretty big deal.

### Displaying the Currency Code or Symbol with the Date Pipe

So, what we’ve seen so far is really great, but there’s even more to this pipe.

We have some more options available to really control the display of these currency values.

For one, we may have the need to show the [currency code](https://en.wikipedia.org/wiki/ISO_4217) instead of the symbol, before the value.

Well, we can do this by specifying the display parameter with the pipe.

For this, we’ll provide a value of “code”:

```html
<td>{% raw %}{{ price() | currency: 'JPY' : 'code' }}{% endraw %}</td>
```

That’s it.

Now let’s save and see this in action:

<div>
<img src="{{ '/assets/img/content/uploads/2024/10-11/demo-5.png' | relative_url }}" alt="Example of a currency value formatted to display the currency code instead of the symbol using the Currency Pipe" width="944" height="358" style="width: 100%; height: auto;">
</div>

There, so now instead of the yen symbol, we see the code "JPY" instead.

And if we change this to “symbol”, of course we’ll see the symbol again instead:

```html
<td>{% raw %}{{ price() | currency: 'JPY' : 'symbol' }}{% endraw %}</td>
```

<div>
<img src="{{ '/assets/img/content/uploads/2024/10-11/demo-4.png' | relative_url }}" alt="Example of a currency value formatted to display the currency symbol using the Currency Pipe" width="944" height="374" style="width: 100%; height: auto;">
</div>

Then, if we don’t want to show either of these, we can just switch it to an empty string instead:

```html
<td>{% raw %}{{ price() | currency: 'JPY' : '' }}{% endraw %}</td>
```

<div>
<img src="{{ '/assets/img/content/uploads/2024/10-11/demo-6.png' | relative_url }}" alt="Example of a currency value formatted to not display the currency symbol or code using the Currency Pipe" width="952" height="348" style="width: 100%; height: auto;">
</div>

There, now there’s no symbol or code.

### Controlling Minimum and Maximum Integer and Fraction Digits to Display

We can also control how many integer units before the decimal to show, and how many fractional units after the decimal to show.

Let’s use our shipping value for this.

Now we don’t want to set the currency code for this. The default value for the currency code parameter is “undefined”, so let’s set it to “undefined”:

```html
<td>{% raw %}{{ shipping() | currency: undefined }}{% endraw %}</td>
```

Now, in order to get the decimal formatting to work correctly, we need to also fill out the display parameter, so let’s set it to “symbol”:

```html
<td>{% raw %}{{ shipping() | currency: undefined: 'symbol' }}{% endraw %}</td>
```

Ok, now we can add our third parameter. This too will be a string.

The first value is the minimum number of integer digits to show, so the minimum number of digits to show before the decimal point.

The default is one, so let’s go with a value of two. Then we add a dot:

```html
<td>{% raw %}{{ shipping() | currency: undefined: 'symbol': '2.' }}{% endraw %}</td>
```

The next value is the minimum number of fractional units to show, so the minimum number of digits to show after the decimal point.

The default is two, so let’s change it to one:

```html
<td>{% raw %}{{ shipping() | currency: undefined: 'symbol': '2.1' }}{% endraw %}</td>
```

Then we add a dash followed by the max number of fractional digits to show.

The default for this is two as well, so let’s go with three instead:

```html
<td>{% raw %}{{ shipping() | currency: undefined: 'symbol': '2.1-3' }}{% endraw %}</td>
```

Ok, that’s it.

Let’s save and check this out:

<div>
<img src="{{ '/assets/img/content/uploads/2024/10-11/demo-7.png' | relative_url }}" alt="Example of a currency value formatted to display the minimum and maximum number of integer and fractional digits using the Currency Pipe" width="942" height="366" style="width: 100%; height: auto;">
</div>

Ok, so that’s a little different huh?

Now we see the zero before the eight, and the nine after the forty-nine cents.

So, there’s quite a bit we can do with this pipe.

It’s just really easy to use and helps us avoid common pitfalls and errors that can occur when working with currency values in Angular.

{% include banner-ad.html %}
 
## In Conclusion

So, by using the [Currency Pipe](https://angular.dev/api/common/CurrencyPipe), you can ensure that your application is adaptable to different locales and languages, and that your currency values are displayed correctly and consistently.

This will ultimately lead to a better user experience and more reliable data overall.

Well, I guess that’s all for now.

Don't forget to check out [my other Angular tutorials](https://www.youtube.com/@briantreese) for more tips and tricks.

## Additional Resources
* [The demo BEFORE making any changes](https://stackblitz.com/edit/stackblitz-starters-zunvaa?file=src%2Fpurchase-form%2Fpurchase-form.component.html)
* [The demo AFTER making changes](https://stackblitz.com/edit/stackblitz-starters-tz8l2c?file=src%2Fpurchase-form%2Fpurchase-form.component.html)
* [Angular Currency Pipe official documentation](https://angular.dev/api/common/CurrencyPipe)

## Want to See It in Action?
Check out the demo code and examples of these techniques in the Stackblitz example below. If you have any questions or thoughts, don’t hesitate to leave a comment.

<iframe src="https://stackblitz.com/edit/stackblitz-starters-tz8l2c?ctl=1&embed=1&file=src%2Fpurchase-form%2Fpurchase-form.component.html" style="height: 500px; width: 100%; margin-bottom: 1.5em; display: block;"></iframe>
