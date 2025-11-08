---
layout: post
title: "Stop Using ::ng-deep… What to do Instead"
date: "2024-12-20"
video_id: "Snr8JQ6HO1k"
tags:
  - "Angular"
  - "Angular Components"
  - "Angular Styles"
  - "CSS"
  - "CSS Custom Properties"
  - "HTML"
  - "View Encapsulation"
  - "ng-deep"
---

<p class="intro"><span class="dropcap">H</span>ey everyone, welcome back! In this tutorial, we’re diving into something that’s been a challenge in the past for Angular developers, the need to break <a href="https://angular.dev/guide/components/styling#style-scoping">style encapsulation</a> in certain cases with <a href="https://angular.dev/guide/components/styling#ng-deep">::ng-deep</a>. It’s been deprecated for quite some time but there are still times where we need to use it. Or at least there used to be. Now, we have modern solutions that not only replace <a href="https://angular.dev/guide/components/styling#ng-deep">::ng-deep</a> but can also make code cleaner and more maintainable.</p>

#### In this tutorial, I’ll show you two approaches:

1. Using [CSS Custom Properties](https://developer.mozilla.org/en-US/docs/Web/CSS/--*)
2. And disabling [View Encapsulation](https://angular.dev/api/core/ViewEncapsulation) for those special cases where custom properties won’t cut it.

{% include youtube-embed.html %}

## Goodbye ::ng-deep, Hello CSS Custom Properties!

Ok, here’s the basic application we’ll be using for this example:

<div>
<img src="{{ '/assets/img/content/uploads/2024/12-20/demo-1.png' | relative_url }}" alt="Example of a demo Angular application using ::ng-deep to break style encapsulation" width="774" height="468" style="width: 100%; height: auto;">
</div>

Now, in this demo, I only have a couple of components, but let’s imagine that this is an app that will eventually be quite large with hundreds of different components.

This particular [toolbar component](https://stackblitz.com/edit/stackblitz-starters-tdsjs3sb?file=src%2Fapp%2Ftoolbar%2Ftoolbar.component.ts) will be used over and over in many different situations.

Operating with that in mind, what this could mean is that we’d need default colors for these buttons.

These default colors would be used in most common scenarios, but we’d likely need to override them in certain situations.

In the example for this tutorial, this is one of those situations.

We are overriding the default colors.

If we open up the [stylesheet](https://stackblitz.com/edit/stackblitz-starters-tdsjs3sb?file=src%2Fapp%2Ftoolbar%2Ftoolbar.component.scss) for this toolbar component, we can see the default colors for the cancel and submit buttons:

```scss
button {
  &.cancel {
    background-color: #777;
  }

  &.submit {
    background-color: #000;
  }
}
```

The submit button is black and the cancel button is gray.

But in our example they are different colors because they are overridden in the [app.component.scss](https://stackblitz.com/edit/stackblitz-starters-tdsjs3sb?file=src%2Fapp%2Fapp.component.scss) where this toolbar component is used:

```scss
app-toolbar ::ng-deep button {
  &.cancel {
    background-color: #ff495d;
  }

  &.submit {
    background-color: #00deb7;
  }
}
```

We can see that we’re using [::ng-deep](https://angular.dev/guide/components/styling#ng-deep) to break the style encapsulation for this component so that we can style these buttons from the parent app component.

If we remove these styles, and then save, we can see the default colors for the buttons:

<div>
<img src="{{ '/assets/img/content/uploads/2024/12-20/demo-2.png' | relative_url }}" alt="Example of the default colors applied to the buttons without ::ng-deep" width="764" height="598" style="width: 100%; height: auto;">
</div>

This is a perfect situation for [CSS Custom Properties](https://developer.mozilla.org/en-US/docs/Web/CSS/--*), so let’s switch it over.

First, we need to set up the buttons to use [custom properties](https://developer.mozilla.org/en-US/docs/Web/CSS/--*).

To do this we need to start by adding the [var()](https://developer.mozilla.org/en-US/docs/Web/CSS/var) function.

Then we can add the name for the for the [custom property](https://developer.mozilla.org/en-US/docs/Web/CSS/--*), prefixed with two dashes.

Let’s go with “--cancelBackground”:

```scss
button {
  &.cancel {
    background-color: var(--cancelBackground, #777);
  }
}
```

So now, if we define this [custom property](https://developer.mozilla.org/en-US/docs/Web/CSS/--*) on a parent, that value will be used.

If not, it will fall back to the gray value.

Ok, now let’s add a custom property for our submit button:

```scss
button {
  &.submit {
    background-color: var(--submitBackground, #000);
  }
}
```

Now, what happens if we remove the overrides in the [app.component.scss](https://stackblitz.com/edit/stackblitz-starters-tdsjs3sb?file=src%2Fapp%2Fapp.component.scss) and save?

<div>
<img src="{{ '/assets/img/content/uploads/2024/12-20/demo-3.png' | relative_url }}" alt="Example of the fallback colors applied to the buttons when using CSS Custom Properties" width="782" height="376" style="width: 100%; height: auto;">
</div>

Perfect, the default colors are applied.

Now we just need to provide our custom property overrides for these colors in the [app.component.scss](https://stackblitz.com/edit/stackblitz-starters-tdsjs3sb?file=src%2Fapp%2Fapp.component.scss) file.

We can add them in our ruleset for the styles on the [:host](https://angular.dev/guide/components/host-elements) element:

```scss
:host {
    ...

    --cancelBackground: #ff495d;
    --submitBackground: #00deb7;
}
```

That’s it, now after we save, we should see the colors updated:

<div>
<img src="{{ '/assets/img/content/uploads/2024/12-20/demo-1.png' | relative_url }}" alt="Example of the override colors applied to the buttons when using CSS Custom Properties" width="774" height="468" style="width: 100%; height: auto;">
</div>

So, not only does this eliminate the need for [::ng-deep](https://angular.dev/guide/components/styling#ng-deep), but it actually results in fewer styles, at least in this case.

[Custom properties](https://developer.mozilla.org/en-US/docs/Web/CSS/--*) are usually the first thing I go for in scenarios like this because they are simple and easy to implement.

But sometimes you may find that they don’t work so well, and you need another solution.

Let’s look at an example.

## Scoped or Not? Disabling View Encapsulation for Flexibility

The other component we have here is a [checkbox component](https://stackblitz.com/edit/stackblitz-starters-tdsjs3sb?file=src%2Fapp%2Fcheckbox%2Fcheckbox.component.ts).

Now, I’ve only added this component for stylistic purposes.

In this app, most of the time when we use a checkbox, we want it to look like it does here:

<div>
<img src="{{ '/assets/img/content/uploads/2024/12-20/demo-4.png' | relative_url }}" alt="Example of the custom checkbox style used in the demo application" width="886" height="299" style="width: 100%; height: auto;">
</div>

To pull this off, we need [several styles](https://stackblitz.com/edit/stackblitz-starters-tdsjs3sb?file=src%2Fapp%2Fcheckbox%2Fcheckbox.component.scss).

There’s not really a great way to do this with [custom properties](https://developer.mozilla.org/en-US/docs/Web/CSS/--*).

And we may not want to add these as global styles because we may want a more standard checkbox style in certain scenarios.

So, what I’ve done is create this [checkbox component](https://stackblitz.com/edit/stackblitz-starters-tdsjs3sb?file=src%2Fapp%2Fcheckbox%2Fcheckbox.component.ts), basically as a "wrapper" that we can add whenever we want to opt-in to this style.

Here, in the [app.component.html](https://stackblitz.com/edit/stackblitz-starters-tdsjs3sb?file=src%2Fapp%2Fapp.component.html), we can see this component wrapping both of the checkboxes and their associated labels:

```html
<app-checkbox>
  <label>
    <input type="checkbox" />
    I am at least 13 years of age
  </label>
</app-checkbox>
<app-checkbox>
  <label>
    <input type="checkbox" />
    I agree to the terms of service
  </label>
</app-checkbox>
```

Now, we could’ve totally added the checkbox and label into our [checkbox component](https://stackblitz.com/edit/stackblitz-starters-tdsjs3sb?file=src%2Fapp%2Fcheckbox%2Fcheckbox.component.ts), but what I’ve found is that you often need direct access to the [input](https://developer.mozilla.org/en-US/docs/Web/HTML/Element/input) element for programmatic reasons.

So that’s why I prefer a "wrapper" style component for this type of thing.

But this means we need to use [::ng-deep](https://angular.dev/guide/components/styling#ng-deep) right?

Actually, no.

We have another option.

Styles by default in Angular are scoped or encapsulated for each component, right?

But we can disable this for certain components when needed.

We can add the “encapsulation” property in our component metadata.

Then we can add the [ViewEncapsulation](https://angular.dev/api/core/ViewEncapsulation) enum from the @angular/core module.

#### This encapsulation mode can be one of three things:

1. It can be set to “Emulated”, which is the default, where special scoping attributes are applied to emulate the effects of the native [Shadow DOM](https://developer.mozilla.org/en-US/docs/Web/API/Web_components/Using_shadow_DOM).
2. It can be set to “ShadowDom”, where it actually uses the native [Shadow DOM](https://developer.mozilla.org/en-US/docs/Web/API/Web_components/Using_shadow_DOM) to encapsulate styles.
3. Or, it can be set to “None”, where there will be no style encapsulation.

And this is what we’re going to use here:

```typescript
import { ..., ViewEncapsulation } from "@angular/core";

@Component({
    selector: 'app-checkbox',
    ...
    encapsulation: ViewEncapsulation.None
})
```

This means that the styles in this component will now be added un-scoped.

Essentially, they are applied just like the global styles.

So, we have to take extra care when doing this.

Also, it means we need to make a few changes to our styles.

First, we won’t need [::ng-deep](https://angular.dev/guide/components/styling#ng-deep) anymore because all of the styles in this stylesheet are now inserted without scoping.

Also, now that we have turned off our encapsulation, the [:host](https://angular.dev/guide/components/host-elements) selector will no longer apply because it’s not being emulated and because we have no native [Shadow DOM](https://developer.mozilla.org/en-US/docs/Web/API/Web_components/Using_shadow_DOM) for this component.

So, what I like to do here is wrap these styles in the component selector instead:

```scss
app-checkbox {
    ...
}
```

So, even thought they are now applied gloablly, they will only apply to the elements placed within the component host.

Ok, that should be it.

Now we should be able to save and see the styles applied:

<div>
<img src="{{ '/assets/img/content/uploads/2024/12-20/demo-1.png' | relative_url }}" alt="Example of the styles being applied with View Encapsultaion set to none" width="774" height="468" style="width: 100%; height: auto;">
</div>

Nice, these styles look exactly the same, but now they no longer need [::ng-deep](https://angular.dev/guide/components/styling#ng-deep).

{% include banner-ad.html %}

## In Conclusion

So those are a couple of ways to effectively replace [::ng-deep](https://angular.dev/guide/components/styling#ng-deep) in your projects.

[CSS Custom Properties](https://developer.mozilla.org/en-US/docs/Web/CSS/--*) are a flexible and efficient way to manage styles for reusable components.

And for more complex cases, disabling [View Encapsulation](https://angular.dev/api/core/ViewEncapsulation) can be a great alternative.

Alright, hope that was helpful.

Don't forget to check out [my other Angular tutorials](https://www.youtube.com/@briantreese) for more tips and tricks.

## Additional Resources

- [The demo BEFORE making changes](https://stackblitz.com/edit/stackblitz-starters-tdsjs3sb)
- [The demo AFTER making changes](https://stackblitz.com/edit/stackblitz-starters-frie8t6b)
- [Style Scoping in Angular](https://angular.dev/guide/components/styling#style-scoping)
- [CSS Custom Properties](https://developer.mozilla.org/en-US/docs/Web/CSS/--*)
- [CSS Var Function](https://developer.mozilla.org/en-US/docs/Web/CSS/var)
- [Shadow DOM](https://developer.mozilla.org/en-US/docs/Web/API/Web_components/Using_shadow_DOM)

## Want to See It in Action?

Check out the demo code and examples of these techniques in the Stackblitz example below. If you have any questions or thoughts, don’t hesitate to leave a comment.

<iframe src="https://stackblitz.com/edit/stackblitz-starters-frie8t6b?ctl=1&embed=1&file=src%2Fapp%2Fapp.component.ts" style="height: 500px; width: 100%; margin-bottom: 1.5em; display: block;"></iframe>
