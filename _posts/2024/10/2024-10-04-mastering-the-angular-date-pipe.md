---
layout: post
title: "Mastering the Angular Date Pipe… It's About Time!"
date: "2024-10-04"
video_id: "w7AJWHFazG4"
tags: 
  - "Angular"
  - "Angular Pipe"
  - "Date Pipe"
  - "Date Time Format"
  - "Localization"
---

<p class="intro"><span class="dropcap">M</span>any developers struggle with formatting dates correctly for different locales and use cases, leading to inconsistent user experiences. When working with dates, it's easy to get caught up in the complexity of formatting options, which can result in a mess of code that's hard to maintain. Inconsistent date formats can also lead to confusion among users, and even worse, errors in calculations or data analysis.</p>

<iframe width="1280" height="720" src="https://www.youtube.com/embed/w7AJWHFazG4" title="" frameborder="0" allow="accelerometer; autoplay; clipboard-write; encrypted-media; gyroscope; picture-in-picture; web-share" allowfullscreen></iframe>

Well, good news for us, Angular's built-in [Date Pipe](https://angular.dev/api/common/DatePipe) provides a solution to these problems by offering a simple, yet powerful way to format and localize dates in our applications. 

And, by the end of this tutorial, you’ll know  exactly how to use it, and you’ll see several examples demonstrating its power and flexibility. So, let’s jump right in!

## Adding a Semantic, Formatted, and Localized Date with the HTML Time Element and the Angular Date Pipe

Alright, for this tutorial we have a basic demo application for the [Vans clothing brand](https://www.vans.com). On a post about the History of the brand, we want to add the date and time this article was posted at the top of the page.

<div>
<img src="{{ '/assets/img/content/uploads/2024/10-04/demo-1.png' | relative_url }}" alt="Example of an Angular app before adding formatted dates with the Date Pipe" width="764" height="646" style="width: 100%; height: auto;">
</div>

Let’s look at how we can do this. To start, let’s look at the [page-content.component.ts](https://stackblitz.com/edit/stackblitz-starters-mbt2qw?file=src%2Fpage-content%2Fpage-content.component.html). Here we can see that we have a [JavaScript Date object](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/Date) set to September 20th, 2024 at 11:43 AM:

#### page-content.component.ts
```typescript
protected datePosted = new Date('2024-09-20 11:43:24');
```

Now, this date would realistically come from some API endpoint in real life, but for demonstration purposes, we’ve just included it here within our component.

So, we have this date object, but we can’t simply add this date as is, to our template. We want to use the built-in Angular [Date Pipe](https://angular.dev/api/common/DatePipe) instead.

But before we can use it, we need to first import it from the [Common Module](https://angular.dev/api/common/CommonModule), within our component imports array.

#### page-content.component.ts
```typescript
import { DatePipe } from '@angular/common';

@Component({
  selector: 'app-page-content',
  ...,
  imports: [ DatePipe ]
})
```

Ok, now we’ll be able to use the pipe within our template.

The first thing we want to do is add the [HTML Time element](https://developer.mozilla.org/en-US/docs/Web/HTML/Element/time).

Since we’re adding a date, the [Time element](https://developer.mozilla.org/en-US/docs/Web/HTML/Element/time) is the right tag for the job. Its purpose is to represent a specific period in time which is exactly what we’re doing here.

Now, with this element, we also want to add the [datetime](https://developer.mozilla.org/en-US/docs/Web/HTML/Element/time#datetime) attribute.

We can use basic [attribute binding](https://angular.dev/guide/templates/binding#attributes) to bind this attribute to our date value:

#### page-content.component.html
```html
<section>
    Posted on:
    <time [attr.datetime]="datePosted">
    </time>
</section>
```

This attribute is used to provide a machine-readable date which helps things like search engines or calendars recognize them as dates accordingly.

Ok, now let’s get to what we’re here for, the formatted date!

We’re going to use [string interpolation](https://angular.dev/guide/templates/binding#render-dynamic-text-with-text-interpolation), so we’ll add double curly braces for this. Then, we’ll output our date value within these curly braces.

#### page-content.component.html
```html
<time [attr.datetime]="datePosted">
    {% raw %}{{ datePosted }}{% endraw %}
</time>
```

Now, to use the pipe, we add a [pipe character](https://www.thesaurus.com/e/grammar/pipe-symbol/). If you’re not familiar, this is how you add pipes in Angular.

Then we follow this pipe with the name of the Angular pipe. In this case it’s simply, the word “date”:

```html
{% raw %}{{ datePosted | date }}{% endraw %}
```

Ok, that’s it. Let’s save and see how it looks:

<div>
<img src="{{ '/assets/img/content/uploads/2024/10-04/demo-2.png' | relative_url }}" alt="Example of an Angular app after adding a formatted date with the Date Pipe" width="1034" height="382" style="width: 100%; height: auto;">
</div>

And there we go. Now we see that this article was posted on September 20th, 2024.

Even though we gave it the date in that original ugly, hard to read format, we now get a nicely formatted date.

And what’s even more cool about this is that a lot of work has been done to this pipe so that the dates produced will be properly localized based on the settings of the device a person is using to access this application.

So, in basically one line of code, we were able to create a date that should make sense to anyone accessing it, even machines!

## Customizing Date and Time Formats with the Angular Date Pipe

Now, if that didn’t knock your socks off, there’s a lot more that we can do with this pipe.

We have the ability to really customize the format as needed.

### Using the "short" Date Format

For example, if we want to shorten the format of the date, and show the time too, we can add a colon, followed but the desired format as a string. In this case let’s use a value of “short”:

```html
{% raw %}{{ datePosted | date:'short' }}{% endraw %}
```

Ok, now when we save, it looks like this:

<div>
<img src="{{ '/assets/img/content/uploads/2024/10-04/demo-3.png' | relative_url }}" alt="Example of a date formatted with the Angular Date Pipe and a format value of short" width="1054" height="380" style="width: 100%; height: auto;">
</div>

Nice, now we have a shorter date format, and the time too.

So, this is one of the [predefined date formats](https://angular.dev/api/common/DatePipe?tab=usage-notes) that we can add when using this pipe, but there are several more available too.

### Using the "medium" Date Format

Let’s switch to “medium” instead:

```html
{% raw %}{{ datePosted | date:'medium' }}{% endraw %}
```

There, now we get a date formatted similar to the first example but including the time:

<div>
<img src="{{ '/assets/img/content/uploads/2024/10-04/demo-4.png' | relative_url }}" alt="Example of a date formatted with the Angular Date Pipe and a format value of medium" width="1034" height="382" style="width: 100%; height: auto;">
</div>

### Using the "long" Date Format

How about switching to “long”?

```html
{% raw %}{{ datePosted | date:'long' }}{% endraw %}
```

There, now we get the full date and time:

<div>
<img src="{{ '/assets/img/content/uploads/2024/10-04/demo-5.png' | relative_url }}" alt="Example of a date formatted with the Angular Date Pipe and a format value of long" width="1032" height="400" style="width: 100%; height: auto;">
</div>

### Using the "longDate" Date Format

And what if we wanted this format without the time?

Well, we could switch to a value of “longDate” instead:

```html
{% raw %}{{ datePosted | date:'longDate' }}{% endraw %}
```

There, now we have the long date without the time:

<div>
<img src="{{ '/assets/img/content/uploads/2024/10-04/demo-6.png' | relative_url }}" alt="Example of a date formatted with the Angular Date Pipe and a format value of longDate" width="1038" height="346" style="width: 100%; height: auto;">
</div>

### Using the "shortTime" Date Format

We also have the ability to format the date to show the time only if we want.

Let’s use a value of “shortTime” instead:

```html
{% raw %}{{ datePosted | date:'shortTime' }}{% endraw %}
```

There, now we only show the time from our date value:

<div>
<img src="{{ '/assets/img/content/uploads/2024/10-04/demo-7.png' | relative_url }}" alt="Example of a date formatted with the Angular Date Pipe and a format value of shortTime" width="1052" height="358" style="width: 100%; height: auto;">
</div>

### Displaying the Year Only With a Custom Date Format

Now, what if we only wanted to show the year?

Well, to do this, we can pass a custom format option.

Let’s go with a value of “yyyy”:

```html
{% raw %}{{ datePosted | date:'yyyy' }}{% endraw %}
```

There, now we’re only showing the year from our date:

<div>
<img src="{{ '/assets/img/content/uploads/2024/10-04/demo-8.png' | relative_url }}" alt="Example of a date formatted with the Angular Date Pipe and a custom format value of yyyy" width="1042" height="338" style="width: 100%; height: auto;">
</div>

### Displaying the Month and Year With a Custom Date Format

What if we want to show just the month and year?

Well, we’d add capital “MM”, slash lowercase “yy”:

```html
{% raw %}{{ datePosted | date:'MM/yy' }}{% endraw %}
```

There, now we see the month, slash, the year:

<div>
<img src="{{ '/assets/img/content/uploads/2024/10-04/demo-9.png' | relative_url }}" alt="Example of a date formatted with the Angular Date Pipe and a custom format value of MM/yy" width="1042" height="338" style="width: 100%; height: auto;">
</div>

### Displaying the Hours and Minutes With a Custom Date Format

How about if we only want to show the time in terms of the hour and the minute?

Well, we can switch to a value of capital “HH” colon, lowercase “mm”:

```html
{% raw %}{{ datePosted | date:'HH/mm' }}{% endraw %}
```

There, now we just have 11:43:

<div>
<img src="{{ '/assets/img/content/uploads/2024/10-04/demo-10.png' | relative_url }}" alt="Example of a date formatted with the Angular Date Pipe and a custom format value of HH:mm" width="1036" height="350" style="width: 100%; height: auto;">
</div>

So, there’s a lot we can do here, hopefully you get the idea from these examples.

For this demo, however, I think “medium” is what we want to go with.

It includes the date and time that this article was posted which is perfect for this scenario.

{% include banner-ad.html %}

## In Conclusion

As you can see, it’s incredibly versatile and easy to use. Whether you need a full date, just the time, or something custom, the [Date Pipe](https://angular.dev/api/common/DatePipe) has you covered.

To wrap up, using the [Date Pipe](https://angular.dev/api/common/DatePipe) can save you time and effort in date management. By using the [Date Pipe](https://angular.dev/api/common/DatePipe), you can simplify your date formatting, reduce errors, and improve the overall user experience for everyone.

Don't forget to check out [my other Angular tutorials](https://www.youtube.com/@briantreese) for more tips and tricks.

## Additional Resources
* [The demo BEFORE making any changes](https://stackblitz.com/edit/stackblitz-starters-mbt2qw?file=src%2Fpage-content%2Fpage-content.component.html)
* [The demo AFTER making changes](https://stackblitz.com/edit/stackblitz-starters-8j9u15?file=src%2Fpage-content%2Fpage-content.component.html)
* [The HTML Time element](https://developer.mozilla.org/en-US/docs/Web/HTML/Element/time)
* [Angular Date Pipe official documentation](https://angular.dev/api/common/DatePipe)

## Want to See It in Action?
Check out the demo code and examples of these techniques in the in the Stackblitz example below. If you have any questions or thoughts, don’t hesitate to leave a comment.

<iframe src="https://stackblitz.com/edit/stackblitz-starters-8j9u15?ctl=1&embed=1&file=src%2Fpage-content%2Fpage-content.component.html" style="height: 500px; width: 100%; margin-bottom: 1.5em; display: block;"></iframe>
