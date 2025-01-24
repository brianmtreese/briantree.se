---
layout: post
title: "Turn Basic Angular Components into Interactive SVGs!"
date: "2025-01-09"
video_id: "MWJN8Y7OAq4"
tags: 
  - "Angular"
  - "SVG"
  - "Angular Template"
  - "Angular Signals"
---

<p class="intro"><span class="dropcap">D</span>id you know that in Angular, your component template doesn't have to be limited to HTML? It can also be an SVG! In this tutorial, we'll explore how to render SVGs as component templates and use Angular features to make them dynamic and interactive.</p>

We'll start with a simple app displaying two lists and transform them into dynamic SVG charts. By the end, you'll have a clear understanding of how to render SVGs as component templates, bind attributes, and add interactivity using Angular signals.

Ready? Let’s dive in!

<iframe width="1280" height="720" src="https://www.youtube.com/embed/MWJN8Y7OAq4" title="" frameborder="0" allow="accelerometer; autoplay; clipboard-write; encrypted-media; gyroscope; picture-in-picture; web-share" allowfullscreen></iframe>

## The Starting Point: Our Existing Component

The application that we'll be working with is pretty straightforward. 

It has two different lists of data—one for "fruits collected" and another for "cars sold":

<div>
<img src="{{ '/assets/img/content/uploads/2025/01-09/demo-1.png' | relative_url }}" alt="Example of a simple application with two lists of data" width="1018" height="966" style="width: 100%; height: auto;">
</div> 

We want to make this display more compelling by converting these lists into horizontal bar charts.

### Understanding the App Component

Let's look at the [app component](https://stackblitz.com/edit/stackblitz-starters-5an3ppfu?file=src%2Fmain.ts) to better understand the current set-up.

In the template for this comonent, we have the code for the "fruits collected" section:

```html
<h2>A graph that shows the number of fruit collected</h2>
<em>({{ fruit.length }} Total Categories)</em>
<app-chart [chartItems]="fruit"></app-chart>
```

To display the list of data, we use a [chart component](https://stackblitz.com/edit/stackblitz-starters-5an3ppfu?file=src%2Fchart%2Fchart.component.html).

This component receives an array of "ChartItem" objects as input:

```typescript
fruit: ChartItem[] = [
    {
        count: 4,
        label: 'apples'
    },
    {
        count: 8,
        label: 'bananas'
    },
    {
        count: 15,
        label: 'kiwis'
    },
    {
        count: 16,
        label: 'oranges'
    },
    {
        count: 23,
        label: 'lemons'
    }
];
```

A similar setup is used for the "cars sold" section:

```html
<app-chart [chartItems]="carsSold"></app-chart>
```

And the corresponding data:

```typescript
carsSold: ChartItem[] = [
    {
        count: 12,
        label: 'Toyota'
    },
    {
        count: 6,
        label: 'Ford'
    },
    {
        count: 21,
        label: 'Chevrolet'
    },
    {
        count: 3,
        label: 'BMW'
    },
    {
        count: 17,
        label: 'Lexus'
    },
    {
        count: 13,
        label: 'Tesla'
    },
    {
        count: 8,
        label: 'Kia'
    },
    {
        count: 19,
        label: 'Dodge'
    }
];
```

Now, let's look at the [chart component](https://stackblitz.com/edit/stackblitz-starters-5an3ppfu?file=src%2Fchart%2Fchart.component.ts).

### The Chart Component

This component is quite simple.

It has a required [input](https://angular.dev/guide/components/inputs#required-inputs) for the "chartItems" array:

```typescript
chartItems = input.required<ChartItem[]>();
```

The template renders the items as a basic unordered list using a [@for](https://angular.dev/api/core/@for) block:

```html
<ul>
    @for (item of chartItems(); track item; let index = $index) {
        <li>
             {% raw %}{{ item.count }} {{ item.label }}{% endraw %}
        </li>
    }
</ul>
```

So, very basic but that’s what we’re starting from.

## Converting Angular Components from HTML to SVG

In this case, we want to transform the [chart component](https://stackblitz.com/edit/stackblitz-starters-5an3ppfu?file=src%2Fchart%2Fchart.component.ts) into an interactive SVG-based bar chart.

So, we can do that by simply changing the file extension from .html to .svg.

#### Before:
```
chart.component.html
```

#### After:
```
chart.component.svg
```

Then, we need to update the "templateUrl" in the component's metadata to point to the SVG file:

```typescript
@Component({
    selector: 'app-chart',
    templateUrl: './chart.component.svg'
    ...
})
```

Now, we can replace the `<ul>` with an `<svg>` tag, and then add the SVG code for the dynamic bar chart:

```xml
<svg width="420" [attr.height]="20 * chartItems().length">
    @for (item of chartItems(); track item; let index = $index) {
        <g
            (click)="activeIndex.set(index)" 
            [class.active]="activeIndex() === index">
            <rect 
                [attr.width]="item.count * 10" 
                height="19" 
                [attr.y]="index * 20"></rect>
            <text
                [attr.x]="item.count * 10 + 5" 
                [attr.y]="index * 20 + 15">
                {% raw %}{{ item.label }}{% endraw %}
            </text>
        </g>
    }
</svg>
```

### Explanation:
1. **Width and Height Binding**: The width of the SVG is fixed at 420 units, and the height is dynamically calculated based on the number of items in the array.
2. **Bar Elements**: Each bar is represented by a `<rect>` element. The width is determined by multiplying the `item.count` value by 10.
3. **Labels**: The labels are added using `<text>` elements. Their position is calculated to be slightly to the right of each bar.

Save and refresh—we should now see dynamic bar charts!

<div>
<img src="{{ '/assets/img/content/uploads/2025/01-09/demo-2.png' | relative_url }}" alt="Example using an SVG as an Angular template and using attribute binding to display a bar chart of dynamic data" width="740" height="768" style="width: 100%; height: auto;">
</div> 

This is pretty cool right?

We’re able to use traditional Angular features right within an SVG.

## Enhancing the SVG with Angular Interactivity

Let’s take it even a little further now.

Let's make things a bit more interactive by highlighting a bar when it's clicked.

Let's start by adding a [signal](https://angular.dev/guide/signals) to track the active index:

```typescript
protected activeIndex = signal(-1);
```

Next, let's use click [event binding](https://angular.dev/guide/templates/event-listeners) to update the active index on the SVG group elements:

```html
@for (item of chartItems(); track item; let index = $index) {
    <g (click)="activeIndex.set(index)">
        ...
    </g>
}
```

Now, let's use [class binding](https://angular.dev/guide/templates/binding#css-classes) to add an `.active` class to the bar when it's clicked:

```html
@for (item of chartItems(); track item; let index = $index) {
    <g
        (click)="activeIndex.set(index)"
        [class.active]="activeIndex() === index">
        ...
    </g>
}
```

Now, when we click on a bar, it should turn green.

Likewise when we click on another bar, the previous one should turn back to its original color and the new one should turn green:

<div>
<img src="{{ '/assets/img/content/uploads/2025/01-09/demo-3.gif' | relative_url }}" alt="Example using an SVG as an Angular template and using Angular features to make it interactive" width="740" height="768" style="width: 100%; height: auto;">
</div> 

This simple feature adds a layer of interactivity, making the chart more engaging.

{% include banner-ad.html %}

## Conclusion

In this tutorial, we transformed basic lists into dynamic, interactive SVG bar charts. 

We learned how to:
* Use an SVG as an Angular component template.
* Dynamically [bind attributes](https://angular.dev/guide/templates/binding).
* Add interactivity using Angular [signals](https://angular.dev/guide/signals).

With these techniques, you can create engaging visualizations directly within your Angular apps.

If you found this tutorial useful, check out [my other Angular tutorials](https://www.youtube.com/@briantreese) for more tips and tricks!

## Additional Resources
* [The demo app BEFORE any changes](https://stackblitz.com/edit/stackblitz-starters-5an3ppfu?file=src%2Fchart%2Fchart.component.html)
* [The demo app AFTER making changes](https://stackblitz.com/edit/stackblitz-starters-8twjlbdn?file=src%2Fchart%2Fchart.component.svg)
* [Angular Templates documentation](https://angular.dev/guide/templates/binding)
* [A collection of Angular Signals tutorials](https://www.youtube.com/playlist?list=PLp-SHngyo0_iVhDOLRQTFDenpaAXy10CB)

## Want to See It in Action?
Check out the demo code and examples of these techniques in the in the Stackblitz example below. If you have any questions or thoughts, don’t hesitate to leave a comment.

<iframe src="https://stackblitz.com/edit/stackblitz-starters-8twjlbdn?ctl=1&embed=1&file=src%2Fchart%2Fchart.component.svg" style="height: 500px; width: 100%; margin-bottom: 1.5em; display: block;"></iframe>
