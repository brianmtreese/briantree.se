---
layout: post
title: "Angular CDK: The Accordion Module"
date: "2024-06-21"
video_id: "6qacO21e7Ug"
tags: 
  - "Angular"
  - "Angular CDK"
---

<p class="intro"><span class="dropcap">A</span>n <a href="https://www.w3.org/WAI/ARIA/apg/patterns/accordion/examples/accordion/">accordion component</a> is a component that has one or more expandable sections within it. It’s pretty common to have the need for this type of thing when building apps in Angular. And, it’s not the most difficult thing to do even if you’re creating your own from scratch but the <a href="https://material.angular.io/cdk/categories">CDK</a> makes it really simple. In this example I’ll show you just how easy it is. And after we create the accordion using the <a href="https://material.angular.io/cdk/categories">CDK</a>, we’ll even make it accessible with some <a href="https://developer.mozilla.org/en-US/docs/Web/Accessibility/ARIA">ARIA</a>. Alright, let’s get to it!</p>

<iframe width="1280" height="720" src="https://www.youtube.com/embed/6qacO21e7Ug" title="" frameborder="0" allow="accelerometer; autoplay; clipboard-write; encrypted-media; gyroscope; picture-in-picture; web-share" allowfullscreen></iframe>

## The Demo Application

For the example we’ll be working with in this post, we have [a simple application](https://stackblitz.com/edit/stackblitz-starters-cxpspk?file=src%2Fapp.component.html) that lists some information about several different NBA players.

<div>
<img src="{{ '/assets/img/content/uploads/2024/06-21/demo-1.png' | relative_url }}" alt="Example of a demo application built with Angular to list information about NBA players" width="772" height="1076" style="width: 100%; height: auto;">
</div>

There are two distinct regions that you can see here. What we want to do is convert this to an accordion where the first section, this darker gray region is always visible, and this lower region will be expandable.

<div>
<img src="{{ '/assets/img/content/uploads/2024/06-21/demo-2.png' | relative_url }}" alt="Highlighting the two resiong that will become an accordion" width="786" height="1074" style="width: 100%; height: auto;">
</div>

We’ll use the button with the ellipsis in the upper right corner to toggle the lower region.

<div>
<img src="{{ '/assets/img/content/uploads/2024/06-21/demo-3.png' | relative_url }}" alt="Highlighting the button that will be used to toggle the accordion items" width="792" height="1078" style="width: 100%; height: auto;">
</div>

The final result will be something that looks like this:

<div>
<img src="{{ '/assets/img/content/uploads/2024/06-21/demo-4.gif' | relative_url }}" alt="Example of simplae accordion build in Angular using the CDK Accordion module" width="748" height="1076" style="width: 100%; height: auto;">
</div>

As we can see, this functions like an accordion. When we toggle a region, it expands, then when we toggle another region, it too expands while the other collapses.

So, if we were to create all of this functionality from scratch, we’d have some work to do, but luckily the [Angular CDK](https://material.angular.io/cdk/categories) has us covered. We can use the [CDK Accordion Module](https://material.angular.io/cdk/accordion/overview) which will provide some basic accordion functionality for us.

Now, it’s important to note that these components only provide basic logic for an [accordion pattern](https://www.w3.org/WAI/ARIA/apg/patterns/accordion/examples/accordion/). They don’t provide any style or accessibility information so that’s stuff we’ll need to handle ourselves, which we’ll do in this example.

Ok, let’s look at the code for this app.

<div class="shirt-ad">
<a href="https://www.teepublic.com/user/dev-drip" title="Click to get yourself some fresh Angular merch!">
<img src="{{ '/assets/img/dev-drip-banner.png' | relative_url }}" alt="Swoop up some hip new Angular drip! - Dev Drip Merch Shop" width="960" height="275" style="width: 100%; height: auto;"></a>
</div>

## The Existing Code

Here, in the [app component template](https://stackblitz.com/edit/stackblitz-starters-rtnzi4?file=src%2Fapp.component.html), we can see that we have a [`@for`](https://angular.dev/essentials/conditionals-and-loops#for-block) block that iterates over a list of player objects. For each of these players, we have a player-summary and a player-details component.

#### app.component.template
```html
@for (player of players | filter: searchText; track player.name) {
    <app-player-summary [player]="player">
        ...
    </app-player-summary>
    <app-player-details [player]="player"></app-player-details>
}
```

The player-summary component contains the section that will always be visible: 

<div>
<img src="{{ '/assets/img/content/uploads/2024/06-21/player-summary.png' | relative_url }}" alt="Highlighting the player-summary component" width="786" height="291" style="width: 100%; height: auto;">
</div>

The player-details component contains the section that will be expandable:

<div>
<img src="{{ '/assets/img/content/uploads/2024/06-21/player-details.png' | relative_url }}" alt="Highlighting the player-details component" width="786" height="480" style="width: 100%; height: auto;">
</div>

Also, within the player-summary component we have a slot that contains the button we’ll use to toggle the details section.

```html
<app-player-summary [player]="player">
    <button title="{% raw %}{{ player.name }}{% endraw %}'s Details">
        ...
    </button>
</app-player-summary>
```

Ok, so that’s what we’re starting with, now let’s add the [Angular CDK Accordion](https://material.angular.io/cdk/accordion/overview) components.

## Installing the Angular CDK

Now, in order to use the [Angular CDK](https://material.angular.io/cdk/categories), you’ll first need to install it. To do so, you’ll need to run the following command from your terminal within the root directory of your Angular application.

```shell
npm i @angular/cdk
```

## Adding Basic Accordion Functionality with the Angular CDK Accordion

Ok, once the [CDK](https://material.angular.io/cdk/categories) is installed you’ll be able to add the accordion components. We’ll be using these components within our main app-component so we’ll need to first import the `CdkAccordionModule`.

#### main.ts
```typescript
import { CdkAccordionModule } from '@angular/cdk/accordion';

@Component({
    selector: 'app-root',
    ...,
    imports: [ ..., CdkAccordionModule ]
})
export class App {
    ...
}
```

Ok, after that’s imported, we can switch back to the component template. Now, we can add a [`cdk-accordion`](https://material.angular.io/cdk/accordion/api#CdkAccordion) component around our list items.

#### app.component.template
```html
<cdk-accordion>
    @for (player of players | filter: searchText; track player.name) {
        ...
    }
</cdk-accordion>
```

This is simply a basic wrapper component used to manage the state for the accordion overall.

Next, we can wrap each of our items in a [`cdk-accordion-item`](https://material.angular.io/cdk/accordion/api#CdkAccordionItem) component.

```html
<cdk-accordion-item>
    <app-player-summary [player]="player">
        ...
    </app-player-summary>
    <app-player-details [player]="player"></app-player-details>
</cdk-accordion-item>
```

This is a wrapper used to manage the state for the individual accordion item itself. 

Ok, at this point we have some accordion components, but we don’t have any accordion functionality going on yet. To add this, we will now use some of the features provided by the accordion, but first we’ll need to be able to access the accordion item component within the template. 

To do this, let’s add a template reference variable on the accordion-item component, let’s call it “#item”. Then, this component is exported as `cdkAccordionItem`, so we'll pass that to our reference variable.

```html
<cdk-accordion-item #item="cdkAccordionItem">
```

Ok, so now we’ll have access to the component like we need. The first thing we can do is add the style to toggle the details region to the player-details element itself. 

Let’s add a style binding for the [display](https://developer.mozilla.org/en-US/docs/Web/CSS/display) property. Then, we can use the “expanded” property on the accordion item to toggle the display. It will not need a display value when it’s visible, but we’ll set it to “none” when it’s not expanded.

```html
<app-player-details [style.display]="item.expanded ? '' : 'none'">
</app-player-details>
```

Ok, almost there, all we need to do now is toggle the expanded state of the item when we click the button. So we can add a “click” event to the button, and when this event fires, we’ll call the `toggle()` function on the accordion item.

```html
<button (click)="item.toggle()">
    ...
</button>
```

Ok, that’s all we need for the basic accordion functionality. 

Now if we save, we can see that the details start out hidden, then when we click on the button, the details region is properly expanded. Then when we click on it again, it collapses. 

Also, if we expand a player’s details region, and then click on another player, that player expands and the other collapses.

<div>
<img src="{{ '/assets/img/content/uploads/2024/06-21/demo-5.gif' | relative_url }}" alt="Example of basic accordion functionality using the Angular CDK Accordion Module" width="590" height="944" style="width: 100%; height: auto;">
</div>

So, this is pretty cool, but one thing I think we need to fix is this label on the button. It always says the players name, and “details”, even when it’s expanded.

<div>
<img src="{{ '/assets/img/content/uploads/2024/06-21/demo-6.png' | relative_url }}" alt="Example the incorrect label on the toggle button when an item is expanded" width="590" height="282" style="width: 100%; height: auto;">
</div>

This probably doesn't make a lot of sense when it's expanded.

Instead let’s add some logic when the item is expanded to toggle the label between “Show details” and “Hide details” instead. This label is actually in two spots, once as a visually hidden, accessible label, and then as a title attribute which is what shows when we hover over it. So, we’ll need to change both of these.

We can use the `item.expanded` value to switch between the word “Hide” when it’s expanded, and “Show” when it’s not.

```html
<button title="{% raw %}{{ item.expanded ? 'Hide' : 'Show' }} {{ player.name }}{% endraw %}'s Details">
    ...
    <span class="cdk-visually-hidden">
        {% raw %}{{ item.expanded ? 'Hide' : 'Show' }} {{ player.name }}{% endraw %}'s Details
    </span>
</button>
```

Now it it should say “Show”, then the player’s name, then “details” when collapsed, and it should say “Hide”, the player’s name, “details” when expanded.

So, this is pretty cool so far. We now have a working accordion, and it didn’t take much to get there did it? But there’s one big piece that’s still missing, accessibility.

If we were to leave this as is, it wouldn’t make much sense to those with disabilities who may encounter it. In order to fix this, we need to add some [ARIA](https://developer.mozilla.org/en-US/docs/Web/Accessibility/ARIA).

## Adding Accessibility Features with ARIA

Ok, the first thing we need to do is add an aria role of “[region](https://developer.mozilla.org/en-US/docs/Web/Accessibility/ARIA/Roles/region_role)” to the details region of our accordion item.

```html
<app-player-details role="region">
</app-player-details
```

If we weren’t using an actual button to toggle this region, we would need to add a role of “[button](https://developer.mozilla.org/en-US/docs/Web/Accessibility/ARIA/Roles/button_role)” to the element that toggles it. Of course, it’s always best to use the appropriate element if possible because then, no [ARIA](https://developer.mozilla.org/en-US/docs/Web/Accessibility/ARIA) is needed, which is what we’re doing in this case. So we don’t need a role attribute on the button here.

Ok, now we can add an [`aria-expanded`](https://developer.mozilla.org/en-US/docs/Web/Accessibility/ARIA/Attributes/aria-expanded) attribute to our button to notify the user of the expanded state of the accordion item.

```html
<button [attr.aria-expanded]="item.expanded">
    ...
</button>
```

Ok now we need to add several [ARIA](https://developer.mozilla.org/en-US/docs/Web/Accessibility/ARIA) attributes that will require an id unique to either our button element or the details region element. To add an id that’s unique, we can use the index of our list item so let’s add an index variable to our [@for](https://angular.dev/essentials/conditionals-and-loops#for-block) block.

```html
@for (player of players | filter: searchText; track player.name; let index = $index) {
    ...
}
```

Ok, now let’s use this index to bind an id on our button. We’ll use a prefix of “item-” and then we’ll concatenate our index.

```html
<button [attr.id]="'item-' + index">
    ...
</button>
```

Ok, now let’s bind an id on the details region, let’s use a prefix of “item-body-” and then our index.

```html
<app-player-details [attr.id]="'item-body-' + index">
</app-player-details
```

Ok now that we have these ids, on our button we can add an [`aria-controls`](https://developer.mozilla.org/en-US/docs/Web/Accessibility/ARIA/Attributes/aria-controls) attribute. This button will control the details region so we will add the “item-body” id.

```html
<button [attr.aria-controls]="'item-body-' + index">
    ...
</button>
```

And now, the last thing we need to do is add the [`aria-labelledby`](https://developer.mozilla.org/en-US/docs/Web/Accessibility/ARIA/Attributes/aria-labelledby) attribute to our details region. This region is labelled by the button, so let’s add the button id.

```html
<app-player-details [attr.aria-labelledby]="'item-' + index">
</app-player-details
```

Ok, so that should be all of the [ARIA](https://developer.mozilla.org/en-US/docs/Web/Accessibility/ARIA) that we need to make this component accessible.

Now we can make sure everything is getting applied correctly. If we inspect the code, before we’ve toggled the item, we can see that [`aria-expanded`](https://developer.mozilla.org/en-US/docs/Web/Accessibility/ARIA/Attributes/aria-expanded) is false.

<div>
<img src="{{ '/assets/img/content/uploads/2024/06-21/aria-expanded.png' | relative_url }}" alt="Example of aria-expanded='false' when the item is collapsed" width="1314" height="264" style="width: 100%; height: auto;">
</div>

We can see that [`aria-controls`](https://developer.mozilla.org/en-US/docs/Web/Accessibility/ARIA/Attributes/aria-controls) is set to the id of the details element.

<div>
<img src="{{ '/assets/img/content/uploads/2024/06-21/aria-controls.png' | relative_url }}" alt="Example of aria-controls set with the correct id" width="1312" height="366" style="width: 100%; height: auto;">
</div>

And, we can see that the [`aria-labelledby`](https://developer.mozilla.org/en-US/docs/Web/Accessibility/ARIA/Attributes/aria-labelledby) attribute on our details component is set to the id from button.

<div>
<img src="{{ '/assets/img/content/uploads/2024/06-21/aria-labelledby.png' | relative_url }}" alt="Example of aria-labelledby set with the correct id" width="1310" height="488" style="width: 100%; height: auto;">
</div>

And, of course, the role attribute of “[region](https://developer.mozilla.org/en-US/docs/Web/Accessibility/ARIA/Roles/region_role)” is on our details element too, because we hard-coded it.

<div>
<img src="{{ '/assets/img/content/uploads/2024/06-21/role-region.png' | relative_url }}" alt="Example of aria-labelledby set with the correct id" width="1312" height="298" style="width: 100%; height: auto;">
</div>

Now, if we click to expand, we can see that the [`aria-expanded`](https://developer.mozilla.org/en-US/docs/Web/Accessibility/ARIA/Attributes/aria-expanded) attribute was updated correctly.

<div>
<img src="{{ '/assets/img/content/uploads/2024/06-21/aria-expanded-true.png' | relative_url }}" alt="Example of aria-expanded='true' when the item is expanded" width="1310" height="308" style="width: 100%; height: auto;">
</div>

## Conclusion

So there you go. Now you have a pretty simple set-up for creating an accessible accordion component in Angular. And it doesn’t take much effort thanks to the [Angular CDK](https://material.angular.io/cdk/categories).

I hope you found this tutorial helpful, and if you did, check out [my YouTube channel](https://www.youtube.com/@briantreese) for more tutorials on the [Angular CDK](https://material.angular.io/cdk/categories) and Angular in general.

## Want to See It in Action?
Check out the demo code and examples of these techniques in the in the Stackblitz example below. If you have any questions or thoughts, don’t hesitate to leave a comment.

<iframe src="https://stackblitz.com/edit/stackblitz-starters-rtnzi4?ctl=1&embed=1&file=src%2Fapp.component.html" style="height: 500px; width: 100%; margin-bottom: 1.5em; display: block;">
