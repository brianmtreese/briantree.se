---
layout: post
title: "Angular 22: Mix Signal Forms and Reactive Forms Seamlessly"
date: "2026-03-26"
video_id: "RQUFjZdFqGE"
tags:
  - "Angular"
  - "Angular v22"
  - "Angular Forms"
  - "Signal Forms"
  - "Reactive Forms"
---

<p class="intro"><span class="dropcap">W</span>hat if you could start using Signal Forms today without touching your existing <a href="https://angular.dev/guide/forms/reactive-forms" target="_blank" rel="noopener noreferrer">Reactive</a> or <a href="https://angular.dev/guide/forms/template-driven-forms" target="_blank" rel="noopener noreferrer">Template-driven</a> forms at all? In Angular 22, you'll be able to build Signal-based custom form controls that drop right into your existing forms with no massive rewrites required. This post walks through how to migrate a custom control from <a href="https://angular.dev/api/forms/ControlValueAccessor" target="_blank" rel="noopener noreferrer">ControlValueAccessor</a> to <a href="https://angular.dev/api/forms/signals/FormValueControl" target="_blank" rel="noopener noreferrer">FormValueControl</a> while keeping the parent form completely intact.</p>

{% include youtube-embed.html %}

## Reactive Forms Setup with a Custom Control

Here, we have a simple cart form with a quantity control, a coupon code, an email field, and a gift wrap checkbox.

<div><img src="{{ '/assets/img/content/uploads/2026/03-26/cart-form-demo.jpg' | relative_url }}" alt="A cart form with a quantity stepper, coupon code, email, and gift wrap checkbox" width="998" height="1058" style="width: 100%; height: auto;"></div>

This form is currently built using standard Reactive Forms. 

The [quantity control](https://github.com/brianmtreese/template-and-reactive-forms-form-value-control-support/tree/main/src/app/quantity-stepper){:target="_blank"} is actually a custom form control built using `ControlValueAccessor`. 

If we click the plus and minus buttons, the value of our form updates correctly:

<div><img src="{{ '/assets/img/content/uploads/2026/03-26/custom-control-updating-value.jpg' | relative_url }}" alt="Clicking the plus and minus buttons updates the quantity value" width="1080" height="544" style="width: 100%; height: auto;"></div>

And if we go under 1 item, it triggers our validation and we see the error message appear:

<div><img src="{{ '/assets/img/content/uploads/2026/03-26/cart-form-validation.jpg' | relative_url }}" alt="Changing the quantity below 1 triggers a validation error message" width="1050" height="400" style="width: 100%; height: auto;"></div>

Everything works, but the underlying `ControlValueAccessor` implementation is incredibly verbose.

Let's look at the code so you can see what I mean.

## The Old Way: How ControlValueAccessor Works in Angular

Let's start with the code for [the parent form](https://github.com/brianmtreese/template-and-reactive-forms-form-value-control-support/tree/main/src/app/cart){:target="_blank"} component. 

In [the template](https://github.com/brianmtreese/template-and-reactive-forms-form-value-control-support/blob/main/src/app/cart/cart.component.html){:target="_blank"}, we have a `formGroup` directive that wraps all of our form controls:

```html
<form class="cart-form" novalidate [formGroup]="form">
    ...
</form>
```

Within this form group, our custom `app-quantity-stepper` component is wired up using the standard `formControlName` directive as well:

```html
<app-quantity-stepper id="qty" formControlName="quantity" />
```

All the other fieds use the same `formControlName` directive too.

Now let's switch and look at [the component TypeScript](https://github.com/brianmtreese/template-and-reactive-forms-form-value-control-support/blob/main/src/app/cart/cart.component.ts){:target="_blank"}.

First, we have the interface for our form, strongly typing everything with [FormControls](https://angular.dev/api/forms/FormControl){:target="_blank"}:

```typescript
import { ..., FormControl } from '@angular/forms';

interface CartForm {
    quantity: FormControl<number>;
    couponCode: FormControl<string>;
    email: FormControl<string>;
    giftWrap: FormControl<boolean>;
}
```

Then we have the [FormGroup](https://angular.dev/api/forms/FormGroup){:target="_blank"} itself:

```typescript
import { FormControl, FormGroup, ReactiveFormsModule, Validators } from '@angular/forms';

protected form = new FormGroup<CartForm>({
    quantity: new FormControl(1, {
        nonNullable: true,
        validators: [Validators.min(1)],
    }),
    couponCode: new FormControl('', { nonNullable: true }),
    email: new FormControl('', {
        nonNullable: true,
        validators: [Validators.required, Validators.email],
    }),
    giftWrap: new FormControl(false, { nonNullable: true }),
});
```

The quantity form control is initialized to 1 and set as non-nullable with a minimum value validator of 1.

That’s why, once we went below a quantity of one, we saw our validation error.

This is a pretty standard Reactive Forms setup. 

The complexity is actually hiding inside that custom stepper component.

## Why ControlValueAccessor Is So Verbose

First, we have this `providers` array:

```typescript
import { ..., forwardRef } from '@angular/core';
import { ..., NG_VALUE_ACCESSOR } from '@angular/forms';

providers: [{
    provide: NG_VALUE_ACCESSOR,
    useExisting: forwardRef(() => QuantityStepperComponent),
    multi: true
}],
```

We have to provide `NG_VALUE_ACCESSOR` and use `forwardRef` just to tell Angular that this component can act as a form control.

Our class then implements the `ControlValueAccessor` interface:

```typescript
import { ..., ControlValueAccessor } from '@angular/forms';

export class QuantityStepperComponent implements ControlValueAccessor {
    // ...
}
```

Inside the class we have a private `value` signal to hold the state, a public `value` property to expose it for use in the form, and an `isDisabled` Boolean property too:

```typescript
private _value = signal(1);
value = this._value;
isDisabled = false;
```

After this, we implement empty `onChange` and `onTouched` callbacks, and wire up `writeValue`, `registerOnChange`, `registerOnTouched`, and `setDisabledState`:

```typescript
private onChange: (v:number)=>void = () => {};

private onTouched: ()=>void = () => {};

writeValue(v: number | null): void {
    this._value.set(v ?? 1);
}

registerOnChange(fn: (v:number)=>void) { 
    this.onChange = fn; 
}

registerOnTouched(fn: ()=>void): void { 
    this.onTouched = fn; 
}

setDisabledState(disabled: boolean): void { 
    this.isDisabled = disabled; 
}
```

Pretty much none of this is your actual business logic. 

It’s mostly all just needed due to the fact that this is a custom control built with `ControlValueAccessor`.

Finally, in our `increment` and `decrement` functions, we update our internal signal.

But we also have to manually call `onChange` so the parent form knows about it:

```typescript
protected increment() { 
    this._value.update(v => { 
        const n = v + 1; this.onChange(n); return n;
    });
}

protected decrement() { 
    this._value.update(v => { 
        const n = v - 1; this.onChange(n); return n; 
    });
}
```

That’s a lot of stuff, right?

And this is a fairly simple example, I’ve certainly seen much more complex custom controls in my experience working with Angular.

## Replace ControlValueAccessor with FormValueControl

Now, imagine we are tasked with updating this quantity stepper component to use Signal Forms. 

We don't want to rewrite the parent cart component yet, because maybe it's a massive, complicated form.

Well, with the upcoming release of Angular v22, we will be able to do exactly that!

With Signal Forms, migrating this component is incredibly easy. 

We can completely delete the `providers` array, the private `value` signal, and all of those `ControlValueAccessor` methods. 

Instead of `ControlValueAccessor`, we'll implement the new `FormValueControl` interface, and we'll type it to a number.

```typescript
import { ChangeDetectionStrategy, Component, input, model } from '@angular/core';
import { FormValueControl } from '@angular/forms/signals';

@Component({
    selector: 'app-quantity-stepper',
    templateUrl: './quantity-stepper.component.html',
    styleUrl: './quantity-stepper.component.scss',
    changeDetection: ChangeDetectionStrategy.OnPush,
})
export class QuantityStepperComponent implements FormValueControl<number> {
    value = model(1);
    isDisabled = input(false);

    protected increment() { 
        this.value.update(v => v + 1);
    }

    protected decrement() { 
        this.value.update(v => v - 1); 
    }
}
```

When you implement this interface, instead of requiring a bunch of methods, Angular now expects a single "value" [model()](https://angular.dev/api/core/model){:target="_blank"} signal for the value of the control. 

We also changed our `isDisabled` property to an [input](https://angular.dev/api/core/input){:target="_blank"} initialized to false. 

We don’t need to call `onChange` anymore, so all we need to do now is update the signal value in our increment and decrement functions. 

That's the entire component class now!

Next, we need to switch over to the parent cart component and make some massive, complicated changes to the parent form so it can talk to this new signal-based control... 

Just kidding!

Yeah, we’re not doing that. 

In Angular 22, we won't have to make any changes to intermix custom `FormValueControls` with classic Reactive Forms or Template-Driven Forms.

Let's save and test it out!

## The Final Result

To start, our form looks exactly the same, so that’s good:

<div><img src="{{ '/assets/img/content/uploads/2026/03-26/signal-form-control-working.jpg' | relative_url }}" alt="The updated form still works perfectly with the new Signal-based child control" width="1006" height="1068" style="width: 100%; height: auto;"></div>

And after adjusting the quantity, the value of our Reactive Form is updating correctly in real time, now driven by our Signal-based child control:

<div><img src="{{ '/assets/img/content/uploads/2026/03-26/signal-form-control-updating-value.jpg' | relative_url }}" alt="The value of our Reactive Form is updating correctly in real time, now driven by our Signal-based child control" width="1032" height="530" style="width: 100%; height: auto;"></div>

Then if I go under 1 item again, it triggers the Reactive Forms validation, and our error message still works perfectly:

<div><img src="{{ '/assets/img/content/uploads/2026/03-26/signal-form-control-validation-error.jpg' | relative_url }}" alt="The error message appearing when the quantity is below 1" width="1010" height="422" style="width: 100%; height: auto;"></div>

So, this is still a Reactive Form, but the control itself is now fully signal-based.

## Key Takeaway: Migrate to Signal Forms Without Rewriting Everything

Angular 22 allows Signal-based custom controls to work seamlessly with existing Reactive and Template-Driven Forms, no parent form changes required.

We simply continue to use our existing parent form with `FormGroup`, `FormControl`, and the `formControlName` directive, and it just works. 

Angular automatically bridges Signal Forms and Reactive Forms for you, meaning you can modernize your large applications one component at a time!

## Get Ahead of Angular's Next Shift

Most Angular apps today still rely on `ControlValueAccessor` for custom form controls, but that's starting to shift.

Signal Forms are new, and not widely adopted yet, which makes this a good time to get ahead of the curve.

I created a course that walks through everything in a real-world context if you want to get up to speed early: 👉 [Angular Signal Forms: Build Modern Forms with Signals](https://www.udemy.com/course/angular-signal-forms/?couponCode=021409EC66FC6440B867){:target="_blank"}

<div class="youtube-embed-wrapper">
	<iframe 
		width="1280" 
		height="720"
		src="https://www.youtube.com/embed/RQUFjZdFqGE?rel=1&modestbranding=1" 
		frameborder="0" 
		allow="accelerometer; autoplay; clipboard-write; encrypted-media; gyroscope; picture-in-picture; web-share" 
		allowfullscreen
		loading="lazy"
		title="Angular 22: Mix Signal Forms and Reactive Forms Seamlessly"
	></iframe>
</div>

## Additional Resources
- [The source code for this example](https://github.com/brianmtreese/template-and-reactive-forms-form-value-control-support){:target="_blank"}
- [The commit that makes this all possible](https://github.com/angular/angular/commit/c4ce3f345fdb14595f0991dff488c4043a0fc71c){:target="_blank"}
- [Angular Signal Forms Custom Controls Documentation](https://angular.dev/guide/forms/signals/custom-controls){:target="_blank"}
- [My course "Angular Signal Forms: Build Modern Forms with Signals"](https://www.udemy.com/course/angular-signal-forms/?couponCode=021409EC66FC6440B867){:target="_blank"}
- [My course "Angular: Styling Applications"](https://www.pluralsight.com/courses/angular-styling-applications){:target="_blank"}
- [My course "Angular in Practice: Zoneless Change Detection"](https://app.pluralsight.com/library/courses/angular-practice-zoneless-change-detection){:target="_blank"}
