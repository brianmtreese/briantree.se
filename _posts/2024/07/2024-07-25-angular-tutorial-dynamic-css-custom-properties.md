---
layout: post
title: "3 Ways to add Dynamic CSS Custom Properties in Angular"
date: "2024-07-25"
video_id: "FQZh5qFrdDI"
categories: 
  - "angular"
---

<p class="intro"><span class="dropcap">S</span>ometimes you may need to programmatically set the value for a <a href="https://developer.mozilla.org/en-US/docs/Web/CSS/Using_CSS_custom_properties">CSS custom property</a> while building components in Angular. I occasionally run into situations where I need to use a custom property based on a dynamic value. Like a bar chart for example, where the items in the chart are based on data from an api. Well in this example, we’re going to look at three different ways to set custom properties programmatically. We’ll use basic <a href="https://angular.dev/guide/templates/class-binding#binding-to-a-single-style">style binding</a>, then we’ll use the <a href="https://angular.dev/api/core/Renderer2#setStyle">Renederer2 setStyle() method</a>, and after that, we’ll use <a href="https://angular.dev/guide/components/host-elements">host element binding</a>.</p>

<iframe width="1280" height="720" src="https://www.youtube.com/embed/FQZh5qFrdDI" title="" frameborder="0" allow="accelerometer; autoplay; clipboard-write; encrypted-media; gyroscope; picture-in-picture; web-share" allowfullscreen></iframe>

## The Demo Application

In our demo application we have a [chart component](https://stackblitz.com/edit/stackblitz-starters-pktahc?file=src%2Fsales-chart%2Fsales-chart.component.html) for displaying sales numbers by year. In this compnenet, we have a [@for loop](https://angular.dev/api/core/@for) iterating over a list of sales per year data.

#### sales-chart.component.html
```html
@for (item of items; track item) {
    <tr>
        <th scope="row">
            {% raw %}{{ item.year }}{% endraw %}
        </th>
        <td>
            <span>
                {% raw %}{{ item.total }}{% endraw %}
            </span>
        </td>
    </tr>
}
```

For each year, we have a row of data but, there’s a problem with the way this data is displayed currently. The bar for each year is the same height even though the data is different.

<div>
<img src="{{ '/assets/img/content/uploads/2024/07-25/demo-1.png' | relative_url }}" alt="Example of a bar chart without proper percentage styles for each of the bars of data" width="600" height="352" style="width: 100%; height: auto;">
</div>

Well, this is what we’re going to fix.

To make things easier, we’re using the open-source data visualization library, [Charts.css](https://chartscss.org/). So, we don’t need to worry about adding our own styles for the chart. This library uses [HTML tables](https://developer.mozilla.org/en-US/docs/Web/HTML/Element/table) and provides several classes to style the chart as needed.

#### sales-chart.component.html
```html
<table 
    class="
        charts-css 
        column 
        show-heading 
        show-labels 
        show-primary-axis 
        show-data-axes 
        show-10-secondary-axes 
        data-spacing-10">
    ...
</table>
```

But it’s our job to provide our own custom data, and when we provide our data, we also need to supply the height for each bar in the chart using a “--size” custom property. This custom property needs to be set as a decimal value so we’ll need to use a JavaScript math equation to programatically set it based on the data provided.

## Using Style Binding in the Component Template

One way to do this is to use basic style binding on the table cell for the bar to bind the custom property directly on this element. To this we start by adding square brackets to bind to the style attribute. Then we add a dot, followed by the “--size" custom property.

Then we just need to provide our math equation to create our decimal value. This equation will take the item total and divide it by the "maxSalesCount". This is the top value for our chart and in this case it’s set to one thousand.

#### sales-chart.component.html
```html
<td [style.--size]="item.total / maxSalesCount">
    <span>
        {% raw %}{{ item.total }}{% endraw %}
    </span>
</td>
```

Ok, that should be all we need, so let’s save and see how it looks.

<div>
<img src="{{ '/assets/img/content/uploads/2024/07-25/demo-2.png' | relative_url }}" alt="Example of a bar chart with the proper dynamic percentage styles for each of the bars of data" width="600" height="350" style="width: 100%; height: auto;">
</div>

There, that’s better. Now we have the proper heights for each of the bars in the chart.

## Using the Renderer2 setStyle() Method with RendererStyleFlags.DashCase

Another way we can programmatically bind custom properties in Angular is to use the [Renderer2](https://angular.dev/api/core/Renderer2) class [setStyle()](https://angular.dev/api/core/Renderer2#setStyle) method along with the [DashCase](https://angular.dev/api/core/RendererStyleFlags2) flag.

For this example, we’ll instead switch over to use an existing chart row component for each of the rows in the list. First we'll need to import it in our sales chart component.

#### sales-chart.component.ts
```typescript
import { SalesChartRowComponent } from "./sales-chart-row/sales-chart-row.component";

@Component({
    selector: 'app-sales-chart',
    ...
    imports: [
        SalesChartRowComponent
    ]
})
```

Ok, now we can switch back to the template and remove the `th` and `td` within the @for loop since these are now going to be included in the template for the row component. This component uses an attribute "appSalesChartRow" for its selector, so we'll need to add that on the `tr`.

#### sales-chart.component.html
```html
@for (item of items; track item) {
    <tr appSalesChartRow></tr>
}
```

Now this component has two required [inputs](https://angular.dev/guide/signals/inputs), one for the max sales count which we can bind to our “maxSalesCount” property, and another for our item which we can bind to our item from the @for loop.

#### sales-chart.component.html
```html
@for (item of items; track item) {
    <tr
        appSalesChartRow
        [maxSalesCount]="maxSalesCount"
        [item]="item">
    </tr>
}
```

Now at this point, if we save, we’ll see our chart bars are not getting the correct height style applied anymore.

<div>
<img src="{{ '/assets/img/content/uploads/2024/07-25/demo-1.png' | relative_url }}" alt="Example of a bar chart without proper percentage styles for each of the bars of data" width="600" height="352" style="width: 100%; height: auto;">
</div>

This is because we now need to set the custom property within our new row component. So, let’s switch over to the [code for this component](https://stackblitz.com/edit/stackblitz-starters-pktahc?file=src%2Fsales-chart%2Fsales-chart-row%2Fsales-chart-row.component.ts) and set this custom property with the Renderer2.

The first thing we need to is get a handle to the HTML element that we want to add the style to. So let’s create a protected field called “bar”. This element will be within what is considered the “view” for our component so we'll use a [viewChild()](https://angular.dev/guide/signals/queries#viewchild) signal query typed as an [ElementRef](https://angular.dev/api/core/ElementRef). And then we’ll look for a reference variable with the name “bar”.

#### sales-chart-row.component.ts
```typescript
import { ..., viewChild } from "@angular/core";

@Component({
  selector: '[appSalesChartRow]',
  ...
})
export class SalesChartRowComponent {
    protected bar = viewChild<ElementRef>('bar');
}
```

Ok, now let’s switch to the template and add this reference variable.

#### sales-chart-row.component.html
```html
<td #bar>
    ...
</td>
```

Ok, now let’s switch back to the TypeScript for this component. 

Next we need to add a constructor. In the constructor we need to inject in the Renderer2 class, so we'll add a field named “renderer” and then we'll add the Render2 class.

#### sales-chart-row.component.ts
```typescript
import { ..., Renderer2 } from "@angular/core";

@Component({
  selector: '[appSalesChartRow]',
  ...
})
export class SalesChartRowComponent {
    
    constructor(renderer: Renderer2) {
    }

}
```

Ok, now we can use the renderer to add this custom property style. We will need to wait until we have access to the bar viewChild(), so we’ll use an [effect()](https://angular.dev/api/core/effect) for this. Then within this effect(), we'll use the renderer property that we added to call the setStyle() method.

The first parameter this function needs it the element to add the style to, so we'll add our bar viewChild() and then access its nativeElement. Then, for the second parameter, we need to provide the style we’re going to set as a string. So, in this case, it’ll be our “--size” custom property. For the third parameter, we need to provide the value for this style which will be our math equation again, the item total divided by the "maxSalesCount" input.

Since we’re adding a custom property, we need to provide a special flag to the setStyle() method as the fourth parameter. We need to use the RendererStyleFlags2 enum to access the DashCase flag value. Now this flag is only needed because we are setting a custom property which starts with dashes. If we were binding to a known style property like color, height, width, or something along those lines, we wouldn’t need this flag.

#### sales-chart-row.component.ts
```typescript
import { ..., RendererStyleFlags2 } from "@angular/core";

@Component({
  selector: '[appSalesChartRow]',
  ...
})
export class SalesChartRowComponent {
    
    constructor(renderer: Renderer2) {
        effect(() => {
            renderer.setStyle(
                this.bar()?.nativeElement,
                '--size',
                this.item().total / this.maxSalesCount(),
                RendererStyleFlags2.DashCase);
            );
        });
    }

}
```

Now let’s save again and see how we did.

<div>
<img src="{{ '/assets/img/content/uploads/2024/07-25/demo-2.png' | relative_url }}" alt="Example of a bar chart with the proper dynamic percentage styles for each of the bars of data" width="600" height="350" style="width: 100%; height: auto;">
</div>

Nice, now we have the correct styles again.

So, that's another possibility for programmatically setting custom properties. If style binding doesn’t work for you, maybe this renderer concept will.

## Using Style Binding on the Component with Host Element Binding

Now, for this chart example, we have another possibility too. Since CSS custom properties cascade, we can bind it on our [component host element](https://angular.dev/guide/components/host-elements) and this should provide the proper value to the [Charts.css]() library.

To do this, we'll want to remove all of the stuff we just added for the renderer concept including the constructor, renderer, effect, viewChild(), all the unused imports, and the "bar" template reference variable too.

Then, to bind to the host element, we'll add the host object in the component metadata.

#### sales-chart-row.component.ts
```typescript
@Component({
  selector: '[appSalesChartRow]',
  ...,
  host: {}
})
```

From here it’ll look a lot like the first style binding example. We'll use square brackets to bind to the style attribute, then we we'll add a dot, and then our “--size” custom property. Then we can provide the value using our same math equation again, the item total by the "maxSalesCount".

#### sales-chart-row.component.ts
```typescript
@Component({
  selector: '[appSalesChartRow]',
  ...,
  host: {
    '[style.--size]': 'item().total / maxSalesCount()'
  }
})
```

Ok, that’s it, so let’s save and see how it looks.

<div>
<img src="{{ '/assets/img/content/uploads/2024/07-25/demo-2.png' | relative_url }}" alt="Example of a bar chart with the proper dynamic percentage styles for each of the bars of data" width="600" height="350" style="width: 100%; height: auto;">
</div>

Nice it looks like it’s supposed to so that means that our style is getting added properly on the host element and then cascading down just like we need it to.

## In Conclusion

Ok, so this isn’t necessarily something that you’ll need very often, but now at least you have a few different ways to programmatically set dynamic custom properties if and when you need to.

I hope you found this tutorial helpful, and if you did, check out [my YouTube channel](https://www.youtube.com/@briantreese) for more tutorials about various topics and features within Angular.

## Additional Resources
* [CSS Custom Properties](https://developer.mozilla.org/en-US/docs/Web/CSS/Using_CSS_custom_properties)
* [Angular Renderer2 setStyle() Documentation](https://angular.dev/api/core/Renderer2#setStyle)
* [Angular Style Binding Documentation](https://angular.dev/guide/templates/class-binding#binding-to-a-single-style)
* [Angular Host Elements Documentation](https://angular.dev/guide/components/host-elements)
* [Charts.css Data Visualization Framework](https://chartscss.org/)

## Want to See It in Action?
Check out the demo code and examples of these techniques in the in the Stackblitz example below. If you have any questions or thoughts, don’t hesitate to leave a comment.

<iframe src="https://stackblitz.com/edit/stackblitz-starters-bessah?ctl=1&embed=1&file=src%2Fsales-chart%2Fsales-chart.component.html" style="height: 500px; width: 100%; margin-bottom: 1.5em; display: block;"></iframe>
