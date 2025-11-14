---
layout: post
title: "Modern Angular Animations: Ditch the DSL, Keep the Power"
date: "2025-09-04"
video_id: "3ySKZyUW50A"
tags:
  - "Angular"
  - "Angular Animations"
  - "Angular Components"
  - "Angular Signals"
  - "Angular Styles"
  - "Animation"
---

<p class="intro"><span class="dropcap">A</span>ngular just deprecated the old animations module. So how do we still do advanced motion? In this tutorial, I’ll show you how to use the modern toolkit: the new enter and leave primitives plus real CSS. By the end, you’ll be able to build smooth enter/leave animations, chain effects in sequence, animate list items, and even add staggered effects, all without the legacy DSL.</p>

{% include youtube-embed.html %}

## Stackblitz Project Links

Check out the sample project for this tutorial here:
- [The demo before](https://stackblitz.com/edit/stackblitz-starters-zhiysail?file=src%2Fproduct-display%2Fproduct-display.html){:target="_blank"}
- [The demo after](https://stackblitz.com/edit/stackblitz-starters-qv1dwemb?file=src%2Fproduct-display%2Fproduct-display.html){:target="_blank"}

## Project Setup: A Basic Show/Hide Without Animation

For this tutorial, we’ll be working with a very simple Angular app.

It has a “Show Product” button, which when clicked, shows a product card and when clicked again, disappears instantly:

<div>
<img src="{{ '/assets/img/content/uploads/2025/09-04/demo-1.gif' | relative_url }}" alt="The demo app before any changes" width="782" height="680" style="width: 100%; height: auto;">
</div>

No animations yet, which makes it a great starting point.

Let’s take a look at [the HTML](https://stackblitz.com/edit/stackblitz-starters-zhiysail?file=src%2Fproduct-display%2Fproduct-display.html){:target="_blank"} for this product display component to better understand how it works.

The first thing we see is a button that toggles a “show()” [signal](https://angular.dev/guide/signals){:target="_blank"} when clicked:

```html
<button (click)="show.set(!show())">
    ...
</button>
```

Below this button, we conditionally show a [product card component](https://stackblitz.com/edit/stackblitz-starters-zhiysail?file=src%2Fproduct%2Fproduct.ts){:target="_blank"} based on the value of this signal:

```html
@if (show()) {
    <app-product [product]="product" />
}
```

This is what’s controlling the display of the product card in the browser.

Now, let’s use the new animation primitives to add some animations to this component in a modern Angular way.

## Add Enter/Leave: Fade + Slide

Since this component is being added and removed from the DOM, we’ll be dealing with the "enter" and "leave" states for this animation.  

Angular’s new `animate` primitives (added in v20.2) are what make this possible without using the old animations module.  

Using these primitives, we’ll define two CSS classes:  

- `fade-slide-in` → for enter  
- `fade-slide-out` → for leave

```html
@if (show()) {
    <app-product 
        [product]="product"
        animate.enter="fade-slide-in" 
        animate.leave="fade-slide-out" />
}
```

Angular automatically adds these classes at the right time: "fade-slide-in" on insert and "fade-slide-out" on removal.

Angular then waits for the CSS animation to finish before removing the element, which is super important for clean exit animations since there's currently no way to do this with CSS alone.

Now, when using these new primitives, the animations are handled with standard CSS.

So first, we need to add a [keyframe animation](https://developer.mozilla.org/en-US/docs/Web/CSS/@keyframes){:target="_blank"}, let's call it "fadeSlideIn":

```css
@keyframes fadeSlideIn {
    from { 
        opacity: 0; 
        translate: 0 16px;
    }
}
```

Now, when we use this animation, it will start with an opacity of 0 and a translation of 16px down.

Then it will finish with an opacity of 1.0 and a translation of 0.

Next, we need to add the "fade-slide-in" class and wire up the new animation:

```css
.fade-slide-in {
    animation: fadeSlideIn 1000ms ease-out;
}
```

With this, when the component enters it will fade in and slide up over 1000ms with an easing function of `ease-out`.

Okay, now let’s do the same for the leave animation, but we don’t need to add keyframes for this, instead we can just run the existing animation in reverse:

```css
.fade-slide-out { 
    animation: fadeSlideIn 1000ms ease-in reverse; 
}
```

At this point we should have a fully functioning enter and leave animation:

<div>
<img src="{{ '/assets/img/content/uploads/2025/09-04/demo-2.gif' | relative_url }}" alt="Angular enter and leave animations using the new v20.2+ animation primitives" width="782" height="678" style="width: 100%; height: auto;">
</div>

Now when we toggle the button, the card fades and slides in, and then exits gracefully when removed.  

All this without the old animations module. Pretty cool.

## Chaining with Multiple Animations (CSS Only)

So this is neat right, but we used to be able to easily chain animations when using the old library because everything ran in sequence.

So how can we do this now?

Well, since it’s all basically CSS, this is still easy.

Back in the template, let's rename the animation classes. 

Let's go with "enter-chain" and "leave-chain":

```html
@if (show()) {
    <app-product 
        [product]="product"
        animate.enter="enter-chain" 
        animate.leave="leave-chain" />
}
```

Now, back in the CSS, let's compose two animations:  

- A "fadeIn" animation
- A "popIn" animation  

The "fadeIn" animation will look like this:

```css
@keyframes fadeIn { 
    from { 
        opacity: 0;
        translate: 50% 0;
    } 
}
```

This will start with an opacity of 0 and a translation of 50% to the right.

Then, it will finish with an opacity of 1 and a translation of 0.

The "popIn" animation will look like this:

```css
@keyframes popIn { 
    0% { 
        scale: 0.98;
    } 
    50% { 
        scale: 1.02; 
    }
}
```

This will start scaled down a little bit, in the middle of the animation it will scale up a little bit, and then it will scale back down to 1.0.

Now, we can add these animations.

Let's start with the enter animation:

```css
.enter-chain {
    animation:
        fadeIn 1000ms ease-out,
        popIn 750ms ease-out 1000ms backwards;
}
```

This will run the "fadeIn" animation for 1000ms, and then the "popIn" animation for 750ms, starting 1000ms after the "fadeIn" animation, which allows them to run in sequence.

Then we have an [animation-fill-mode](https://developer.mozilla.org/en-US/docs/Web/CSS/animation-fill-mode){:target="_blank"} of "backwards", which essentially just tells the browser to apply the styles applied during the first keyframe before it starts.

Without this it would be rendered at its default scale of (1.0) during the delay while the first animation runs, then it would snap to the scaled down (0.98) version when its animation starts.

So, stacking animations like this is how we can chain animations in modern Angular.

Now let’s add the reverse for the leave animation:

```css
.leave-chain {
    animation:
        popIn 750ms ease-out forwards reverse,
        fadeIn 1000ms ease-out 750ms reverse;
}
```

This will first run the "popIn" animation keeping the final scale after it finishes, then the "fadeIn" animation for 1000ms, starting 750ms after the "popIn" animation.

It will run both in reverse, so the opposite of what we had for the enter animation.

So now how does this look?

<div>
<img src="{{ '/assets/img/content/uploads/2025/09-04/demo-3.gif' | relative_url }}" alt="Chaining multiple animations with delays without the old Angular animations module" width="782" height="674" style="width: 100%; height: auto;">
</div>

The result is a product card that smoothly fades in, then pops into place.  

When it leaves, the sequence reverses, with Angular waiting for the longest animation before removing the element.

And if you need more steps, just add another animation with an appropriate delay. 

Think of it like Lego bricks.

You can pretty much do whatever you want here. 

## Animate a List (then Stagger It)

What about lists?

Is there anything cool we can do?

We’ll actually there is.

First, let's switch to display the [product list component](https://stackblitz.com/edit/stackblitz-starters-zhiysail?file=src%2Fproduct-list%2Fproduct-list.ts){:target="_blank"} instead of the [product display](https://stackblitz.com/edit/stackblitz-starters-zhiysail?file=src%2Fproduct-display%2Fproduct-display.ts){:target="_blank"} in the [root component](https://stackblitz.com/edit/stackblitz-starters-zhiysail?file=src%2Fmain.ts){:target="_blank"}:

#### Before:
```typescript
@Component({
    selector: 'app-root',
    template: `
        <app-product-display />
        <!-- <app-product-list /> -->
    `,
    imports: [
        ProductDisplayComponent,
        // ProductListComponent
    ]
})
export class App {
}
```

#### After:
```typescript
@Component({
    selector: 'app-root',
    template: `
        <!-- <app-product-display /> -->
        <app-product-list />
    `,
    imports: [
        // ProductDisplayComponent,
        ProductListComponent
    ]
})
export class App {
}
```

Now, let’s save and see what this component looks like:

<div>
<img src="{{ '/assets/img/content/uploads/2025/09-04/demo-4.gif' | relative_url }}" alt="A simple product list component with no animations" width="640" height="1074" style="width: 100%; height: auto;">
</div>

Okay, when we toggle the button, the items appear and disappear instantly.

Again, there are no animations here.

Let's look at the [HTML](https://stackblitz.com/edit/stackblitz-starters-zhiysail?file=src%2Fproduct-list%2Fproduct-list.html){:target="_blank"} for this component to better understand how it works.

First, we've got the toggle button, which toggles the "show()" signal just like the previous example:

```html
<button (click)="show.set(!show())">
    ...
</button>
```

Then below that, we have a list of products that are conditionally rendered based on the value of that “show()” signal:

```html
<div class="products">
    @for (product of products; track product.id; let i = $index) {
        @if (show()) {
            <app-product [product]="product" />
        }
    }
</div>
```

Again, these product components are entering and leaving the DOM so we can animate them the same way:

```html
<div class="products">
    @for (product of products; track product.id; let i = $index) {
        @if (show()) {
            <app-product 
                [product]="product" 
                animate.enter="stagger-in" 
                animate.leave="stagger-out" />
        }
    }
</div>
```

Now we need to add the CSS for these animations.

First let's add a keyframe animation named "fadeUp":

```css
@keyframes fadeUp {
    from { 
        opacity: 0; 
        translate: 0 30px;
    }
}
```

This will start with an opacity of 0 and a translation of 30px down.

Then it will finish with an opacity of 1 and a translation of 0.

Next, we can use the "stagger-in" and "stagger-out" classes to wire this new animation:

```css
.stagger-in {
  animation: fadeUp 2000ms ease-out both;
}

.stagger-out {
  animation: fadeUp 2000ms ease-in both reverse;
}
```

This will run the "fadeUp" animation for 2000ms when it enters, and then run it in reverse for 2000ms when it leaves.

This time we're using the "both" animation-fill-mode to apply the appropriate styles before and after the animation runs.

Okay, the items should now animate as they're added and removed, so how does this look?

<div>
<img src="{{ '/assets/img/content/uploads/2025/09-04/demo-5.gif' | relative_url }}" alt="The product list with basic enter and leave animations using the new v20.2+ animation primitives" width="640" height="1068" style="width: 100%; height: auto;">
</div>

Nice, now each item smoothly enters and leaves the DOM, instead of snapping in and out.  

Already a huge improvement, but it would be better if they were staggered as they enter and leave, right?

### Add a Stagger with a Single Line

Let’s do it!

First, let’s switch back to the component template and use [style binding](https://angular.dev/guide/templates/binding#css-style-properties){:target="_blank"} to pass the list index as a [CSS custom property](https://developer.mozilla.org/en-US/docs/Web/CSS/Using_CSS_custom_properties){:target="_blank"}:

```html
<div class="products">
    @for (product of products; track product.id; let i = $index) {
        @if (show()) {
            <app-product 
                [product]="product" 
                [style.--i]="i"
                ... />
        }
    }
</div>
```

Now we can switch back to the CSS and use the [calc()](https://developer.mozilla.org/en-US/docs/Web/CSS/calc()){:target="_blank"} function to offset each item’s animation delay:

```css
.stagger-in {
  ...
  animation-delay: calc(var(--i) * 150ms);
}

.stagger-out {
  ...
  animation-delay: calc(var(--i) * 150ms);
}
```

So now item 0 starts immediately, item 1 starts after 150ms, item 2 after 300ms, and so on.

Okay, how does this look now?

<div>
<img src="{{ '/assets/img/content/uploads/2025/09-04/demo-6.gif' | relative_url }}" alt="The product list with staggered enter and leave animations using the new v20.2+ animation primitives, style binding, a custom property, and the calc() function" width="640" height="1078" style="width: 100%; height: auto;">
</div>

Nice, with the items staggered as they enter and leave, the list feels dynamic and polished.  

All with just a single line of CSS.

## Recap & Key Takeaways

So, animations should communicate change, not just decorate it.  

With the new enter and leave primitives, Angular handles when, while CSS defines how.

Today we learned how to add a simple enter/leave animation, chained multiple steps with delays, and staggered a list using one dynamic CSS variable. 

If this was helpful, don't forget to [subscribe](https://www.youtube.com/c/briantreese?sub_confirmation=1) for more hidden Angular gems.  

{% include banner-ad.html %}

## Additional Resources
- [The demo app BEFORE any changes](https://stackblitz.com/edit/stackblitz-starters-zhiysail?file=src%2Fproduct-display%2Fproduct-display.html){:target="_blank"}
- [The demo app AFTER making changes](https://stackblitz.com/edit/stackblitz-starters-qv1dwemb?file=src%2Fproduct-display%2Fproduct-display.html){:target="_blank"}
- [Migrating away from Angular's Animations package](https://angular.dev/guide/animations/migration){:target="_blank"}
- [Simplifying Animations with Angular’s New Native API](https://medium.com/@netbasal/simplifying-animations-with-angulars-new-native-api-9584b4db316b){:target="_blank"}
- [Enter/Leave Animations in 2025: They've changed!](https://youtu.be/pLSqA6u7J3U){:target="_blank"}
- [My course "Angular: Styling Applications"](https://www.pluralsight.com/courses/angular-styling-applications){:target="_blank"}
- [My course "Angular in Practice: Zoneless Change Detection"](https://app.pluralsight.com/library/courses/angular-practice-zoneless-change-detection){:target="_blank"}

## Want to See It in Action?

Want to experiment with the final version? Check out the full demo below.  

<iframe src="https://stackblitz.com/edit/stackblitz-starters-qv1dwemb?ctl=1&embed=1&file=src%2Fproduct-display%2Fproduct-display.html" style="height: 500px; width: 100%; margin-bottom: 1.5em; display: block;"></iframe>
