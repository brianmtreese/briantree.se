---
layout: post
title: "Still Using ControlValueAccessor? It Might Be Overkill 🤷"
date: "2025-05-01"
video_id: "0DAFZGy259Y"
tags:
  - "Angular"
  - "Angular Components"
  - "Angular Form Control"
  - "Angular Forms"
  - "Angular Input"
  - "Angular Signals"
  - "Angular Styles"
  - "CSS"
  - "ControlValueAccessor"
  - "HTML"
  - "Reactive Forms"
  - "TypeScript"
---

<p class="intro"><span class="dropcap">I</span>f you've ever built a custom form control in Angular, you've probably run into the <a href="https://angular.dev/api/forms/ControlValueAccessor" target="_blank">ControlValueAccessor</a>, and if we're being honest, it's a lot. In this tutorial, I'll show you how you might not need it at all. Instead, we'll simplify things using modern Angular features like <a href="https://angular.dev/guide/components/inputs" target="_blank">signal inputs</a> and direct <a href="https://angular.dev/api/forms/FormControl" target="_blank">form control</a> bindings. No interfaces, no providers, no boilerplate — just clean, reactive code.</p>

{% include youtube-embed.html %}

## Demo: How the Angular Rating Form Works Before Refactoring

Let's start by looking at [the current](https://stackblitz.com/edit/stackblitz-starters-1dju3hq9?file=src%2Frating-stars%2Frating-stars.component.ts){:target="_blank"} app setup.

We've got a basic profile form with two fields: a "name" input and a custom star rating component.

<div>
<img src="{{ '/assets/img/content/uploads/2025/05-01/demo-1.png' | relative_url }}" alt="Example of a simple reactive form with a custom rating component using ControlValueAccessor" width="676" height="600" style="width: 100%; height: auto;">
</div>

As you interact with the form, typing in a name or selecting a rating, the form state updates in real-time within the view, including the touched status and form value.

<div>
<img src="{{ '/assets/img/content/uploads/2025/05-01/demo-2.png' | relative_url }}" alt="Example of the Angular form validity status, touched status, and value output in the UI" width="836" height="552" style="width: 100%; height: auto;">
</div>

Everything works fine… but we’re about to make it a lot simpler.

### Exploring the Reactive Form Setup in Angular

In the [profile form component](https://stackblitz.com/edit/stackblitz-starters-1dju3hq9?file=src%2Fprofile-form%2Fprofile-form.component.ts){:target="_blank"}, we have a standard reactive form setup.

The [FormGroup](https://angular.dev/api/forms/FormGroup){:target="_blank"} has two controls: a required "name" control and a "rating" control that starts at negative one with a minimum validator of zero to ensure a value is selected:

```typescript
protected form = new FormGroup({
    name: new FormControl('', { 
        validators: Validators.required, 
        nonNullable: true 
    }),
    rating: new FormControl(-1, { 
        validators: Validators.min(0), 
        nonNullable: true 
    }),
});
```

We also have a "resetRating()" method that resets the control and updates its validation status:

```typescript
protected resetRating() {
    const control = this.form.controls.rating;
    control.reset();
    control.updateValueAndValidity();
}
```

Now let’s look at [the template](https://stackblitz.com/edit/stackblitz-starters-1dju3hq9?file=src%2Fprofile-form%2Fprofile-form.component.html).

The custom [rating stars component](https://stackblitz.com/edit/stackblitz-starters-1dju3hq9?file=src%2Frating-stars%2Frating-stars.component.ts) uses [formControlName](https://angular.dev/api/forms/FormControlDirective){:target="_blank"}, which means it had to implement [ControlValueAccessor](https://angular.dev/api/forms/ControlValueAccessor){:target="_blank"} behind the scenes to make this function as an Angular [form control](https://angular.dev/api/forms/FormControl){:target="_blank"}:

```html
<app-rating-stars 
    formControlName="rating" 
    (reset)="resetRating()">
</app-rating-stars>
```

That's where the complexity begins.

## Inside the Custom Rating Component: No Native Input Required

Looking at the [rating stars component template](https://stackblitz.com/edit/stackblitz-starters-1dju3hq9?file=src%2Frating-stars%2Frating-stars.component.html){:target="_blank"}, you'll notice it doesn't use any native `<input>` or other form elements, it's all custom markup:

```html
<div class="stars">
    @for (star of stars; let i = $index; track i) {
        <span
            (click)="rate(star)"
            [class.filled]="star <= value">
            {% raw %}{{ star <= value ? '★' : '☆' }}{% endraw %}
        </span>
    }
    <button (click)="resetRating()">Reset</button>
</div>
```

Clicking a star triggers the "rate()" function and the current rating is tracked using a "value" property.

So even though this is a custom UI, we’re essentially pretending it behaves like a native `<input>`.

That’s why we had to implement [ControlValueAccessor](https://angular.dev/api/forms/ControlValueAccessor){:target="_blank"}.

## Why ControlValueAccessor Can Be Overkill for Simple Angular Components

Let’s switch to [the TypeScript](https://stackblitz.com/edit/stackblitz-starters-1dju3hq9?file=src%2Frating-stars%2Frating-stars.component.ts){:target="_blank"} for this component to see how.

First, we can see the providers array where we’re registering [NG_VALUE_ACCESSOR](https://angular.dev/api/forms/NG_VALUE_ACCESSOR){:target="_blank"}:

```typescript
import { ..., NG_VALUE_ACCESSOR } from '@angular/forms';

@Component({
    selector: 'app-rating-stars',
    ...,
    providers: [{
        provide: NG_VALUE_ACCESSOR,
        useExisting: forwardRef(() => RatingStarsComponent),
        multi: true,
    }]
})
```

We’re also implementing the [ControlValueAccessor](https://angular.dev/api/forms/ControlValueAccessor){:target="_blank"} interface:

```typescript
import { ..., ControlValueAccessor } from '@angular/forms';

export class RatingStarsComponent implements ControlValueAccessor {
    ...
}
```

Implementing [ControlValueAccessor](https://angular.dev/api/forms/ControlValueAccessor){:target="_blank"} means we need to define multiple required methods, maintain internal state with a "value" property, and register "onChange()" and "onTouched()" callbacks:

```typescript
protected value = -1;

writeValue(value: any): void {
    this.value = value || -1;
}

registerOnChange(fn: any): void {
    this.onChange = fn;
}

registerOnTouched(fn: any): void {
    this.onTouched = fn;
}

private onChange: (value: number) => void = () => {};
private onTouched: () => void = () => {};
```

For a control that just returns a number, that's a lot of boilerplate.

## Step-by-Step Guide: Replace ControlValueAccessor with Angular Signal Inputs

Let's refactor it.

First, we remove the providers and the [ControlValueAccessor](https://angular.dev/api/forms/ControlValueAccessor){:target="_blank"} interface, along with all the associated methods.

We can also remove the old "value" property and "reset" [output](https://angular.dev/api/core/Output){:target="_blank"}.

Instead, we'll add a new [signal input](https://angular.dev/guide/components/inputs){:target="_blank"} called "control", which gives us direct access to the parent [FormControl](https://angular.dev/api/forms/FormControl){:target="_blank"}:

```typescript
control = input.required<FormControl<number>>();
```

Now we need to change the way the "rate()" function works.

We'll use this new "control" [input](https://angular.dev/guide/components/inputs){:target="_blank"} to set the value with the "[setValue()](https://angular.dev/api/forms/FormControl#setValue){:target="_blank"}" method, we’ll also mark it as "dirty" and "touched":

```typescript
protected rate(star: number) {
    this.control.setValue(star);
    this.control.markAsDirty();
    this.control.markAsTouched();
}
```

We also need to update the "resetRating()" function.

We need to reset the control and update its value and validity.

This ensures that, not only the control value is reset, but the form state is also updated:

```typescript
protected resetRating() {
    this.control().reset();
    this.control().updateValueAndValidity();
}
```

The result? A much leaner component that no longer tracks internal state, it reacts entirely based on the passed-in control now.

Back in the parent [profile form component](https://stackblitz.com/edit/stackblitz-starters-1dju3hq9?file=src%2Fprofile-form%2Fprofile-form.component.html){:target="_blank"}, we remove [formControlName](https://angular.dev/api/forms/FormControlDirective){:target="_blank"} and the "(resetRating)" output. 

Instead, we pass the control directly to the component using the new "control" [input](https://angular.dev/guide/components/inputs){:target="_blank"}:

```html
<app-rating-stars [control]="form.controls.rating"></app-rating-stars>
```

We can simplify the form logic further by removing the old "resetRating()" method as well.

Okay, let’s save and test it:

<div>
<img src="{{ '/assets/img/content/uploads/2025/05-01/demo-3.gif' | relative_url }}" alt="Example of a simple reactive form with a custom rating component using using signal inputs instead of ControlValueAccessor" width="914" height="1076" style="width: 100%; height: auto;">
</div>

Nice, the form works just like before, but now it’s cleaner, and much easier to work with!

## Setting an Initial Value

Now, let’s make sure that it works properly with an initial value too.

Let’s start with a value of two:

```typescript
protected form = new FormGroup({
    ...,
    rating: new FormControl(2, { 
        validators: Validators.min(0), 
        nonNullable: true 
    })
});
```

This simulates a scenario where a user has previously saved data:

<div>
<img src="{{ '/assets/img/content/uploads/2025/05-01/demo-4.png' | relative_url }}" alt="Example of the control's initial value properly reflected in the custom star rating control" width="914" height="1076" style="width: 100%; height: auto;">
</div>

Nice. When the form loads, the rating component reflects the correct value automatically, no extra work required.

## Handling Disabled State

Now, we should also add support for disabling this control.

Let’s set it up so that it’s disabled out of the gate:

```typescript
protected form = new FormGroup({
    ...,
    rating: new FormControl(
        { 
            value: 0, 
            disabled: true 
        }, 
        { 
            validators: Validators.min(0), 
            nonNullable: true 
        })
});
```

Now, back over in [the rating stars component](https://stackblitz.com/edit/stackblitz-starters-1dju3hq9?file=src%2Frating-stars%2Frating-stars.component.html), we can check the disabled state and apply a class accordingly:

```html
<span 
      (click)="rate(star)"
      [class.disabled]="control().disabled">
      ...
</span>
```

Okay, now we just need to add some CSS for this state in our [component styles](https://stackblitz.com/edit/stackblitz-starters-1dju3hq9?file=src%2Frating-stars%2Frating-stars.component.scss):

```scss
.disabled {
    pointer-events: none;
    opacity: 0.4;
}
```

Now let’s save and see how it works:

<div>
<img src="{{ '/assets/img/content/uploads/2025/05-01/demo-5.gif' | relative_url }}" alt="Example of the control's disabled state properly reflected in the custom star rating control" width="672" height="1036" style="width: 100%; height: auto;">
</div>

Nice, with a bit of styling, the stars dim and become non-interactive. 

Again, no special logic needed for change tracking.

## Wrap-Up: When You Don't Need ControlValueAccessor

Here's the big takeaway: You don't always need [ControlValueAccessor](https://angular.dev/api/forms/ControlValueAccessor){:target="_blank"} to build custom form controls in Angular.

If you’re building something like a star rating, slider, or toggle that just talks to a form control, [signal inputs](https://angular.dev/guide/components/inputs){:target="_blank"} and direct bindings can be a much simpler and more effective approach.

No providers. No interfaces. No boilerplate.

The result? Smaller components, cleaner code, and better maintainability.

If you found this helpful, don't forget to [subscribe](https://www.youtube.com/c/briantreese?sub_confirmation=1) and check out [my other Angular tutorials](https://www.youtube.com/@briantreese) for more tips and tricks!

{% include banner-ad.html %}

## Additional Resources

- [The demo app BEFORE any changes](https://stackblitz.com/edit/stackblitz-starters-1dju3hq9?file=src%2Frating-stars%2Frating-stars.component.ts)
- [The demo app AFTER making changes](https://stackblitz.com/edit/stackblitz-starters-dxgow6sv?file=src%2Frating-stars%2Frating-stars.component.ts)
- [ControlValueAccessor (API Docs)](https://angular.dev/api/forms/ControlValueAccessor){:target="_blank"}
- [FormControl (API Docs)](https://angular.dev/api/forms/FormControl){:target="_blank"}
- [Signals in Angular](https://angular.dev/guide/signals){:target="_blank"}
- [Reactive Forms (Guide)](https://angular.dev/guide/forms/reactive-forms){:target="_blank"}
- [FormControlDirective (for `formControlName`)](https://angular.dev/api/forms/FormControlDirective){:target="_blank"}
- [My course: "Styling Angular Applications"](https://app.pluralsight.com/library/courses/angular-styling-applications/table-of-contents){:target="_blank"}

## Want to See It in Action?

Check out the demo code showcasing these techniques in the StackBlitz project below. If you have any questions or thoughts, don’t hesitate to leave a comment.

<iframe src="https://stackblitz.com/edit/stackblitz-starters-dxgow6sv?ctl=1&embed=1&file=src%2Frating-stars%2Frating-stars.component.ts" style="height: 500px; width: 100%; margin-bottom: 1.5em; display: block;"></iframe>
