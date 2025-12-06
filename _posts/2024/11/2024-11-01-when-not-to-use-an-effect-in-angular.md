---
layout: post
title: "Angular effect(): When NOT to Use It and Better Alternatives"
date: "2024-11-01"
video_id: "rExv-jyKqcE"
tags:
  - "Angular"
  - "Angular Components"
  - "Angular Effects"
  - "Angular Forms"
  - "Angular Signals"
  - "Angular Styles"
  - "Computed Signals"
  - "JavaScript"
  - "Reactive Forms"
  - "Signal Inputs"
  - "TypeScript"
---

<p class="intro"><span class="dropcap">A</span>ngular's <code>effect()</code> function is often misused, leading to performance issues, unnecessary side effects, and code that's harder to reason about. While effects seem like an easy solution for reacting to signal changes, most scenarios have better alternatives using computed signals, template bindings, or lifecycle hooks. This tutorial shows you when NOT to use effects, demonstrates common anti-patterns, and provides better solutions for each scenario. You'll learn to write more efficient, maintainable Angular code.</p>

{% include youtube-embed.html %}

#### Angular Signals Tutorial Series:
- [Angular Signals & effect()]({% post_url /2024/08/2024-08-09-angular-signals-and-the-effect-function %}) - Learn about the effect() function
- [Create Signals with computed()]({% post_url /2024/08/2024-08-01-create-signals-from-other-signals-with-the-computed-function %}) - Learn about computed signals
- [Signal Inputs & output()]({% post_url /2024/03/2024-03-24-angular-tutorial-signal-based-inputs-and-the-output-function %}) - Replace @Input/@Output with signals

## Where We Started: A Look at the Original Example

In a [previous tutorial]({% post_url /2024/10/2024-10-25-disable-enable-form-control-on-signal-input-change %}), I covered an example where there were some components with [Reactive Forms](https://angular.dev/guide/forms/reactive-forms).

<div>
<img src="{{ '/assets/img/content/uploads/2024/11-01/demo-1.png' | relative_url }}" alt="Example Angular application with reactive forms" width="1234" height="788" style="width: 100%; height: auto;">
</div>

In this example, the [sign-in form component](https://stackblitz.com/edit/stackblitz-starters-e4ipwq?file=src%2Fsign-in-form%2Fsign-in-form.component.ts) has a [signal-based input](https://angular.dev/guide/signals/inputs) named “disabled”:

```typescript
disabled = input(false);
```

In that tutorial I converted this from the [old decorator-based input](https://angular.dev/api/core/Input) where the component was also using the [ngOnChanges lifecycle hook](https://angular.dev/api/core/OnChanges) to enable and disable the [form group](https://angular.dev/api/forms/FormGroup) programmatically based on the value of that input:

```typescript
@Input() disabled = false;

ngOnChanges(changes: SimpleChanges) {
    if (changes['hasEmployeeId'] || changes['disabled']) {
        this.showEmployeeId = this.hasEmployeeId && !this.disabled();
    }
}
```

I essentially replaced the [ngOnChanges implementation](https://angular.dev/api/core/OnChanges) with the [effect function](https://angular.dev/guide/signals/inputs#monitoring-changes) instead:

```typescript
disabled = input(false);

constructor() {
    effect(() => {
         this.disabled() ? this.form.disable() : this.form.enable();
    });
}
```

An [effect](https://angular.dev/guide/signals/inputs#monitoring-changes) seemed like the right choice because, the input became a [signal](https://angular.dev/guide/signals), so I needed to react when the [signal value changes](https://angular.dev/guide/signals/inputs#monitoring-changes), and that reaction was to enable or disable the form with a method call on a [Form Group](https://angular.dev/api/forms/FormGroup).

This really seems like the best way to do this sort of thing based on our current toolset in Angular. And based on the fact that we don’t yet have a signal-based forms module, which is hopefully in the works.

Now, there could definitely be a better way to do this. If so, I would love to see an example.

But for now, I’ll assume that this is an acceptable use case for the [effect function](https://angular.dev/guide/signals/inputs#monitoring-changes), and I’ll leave it as is.

## A Real-World Example: Adding a Conditional Employee ID Field

But, in order to demonstrate an example of when **NOT** to use the [effect function](https://angular.dev/guide/signals/inputs#monitoring-changes), I’m going to change this concept a little.

I’m going to switch this form that’s so that it includes an option to use an employee id:

<div>
<img src="{{ '/assets/img/content/uploads/2024/11-01/demo-2.png' | relative_url }}" alt="The update form with an employee id option" width="816" height="369" style="width: 100%; height: auto;">
</div>

Just like before, I’m still including the disabled status of the two form components in the UI:

<div>
<img src="{{ '/assets/img/content/uploads/2024/11-01/demo-3.png' | relative_url }}" alt="The display of the form group status in UI" width="818" height="424" style="width: 100%; height: auto;">
</div>


Currently the [sign-in form](https://stackblitz.com/edit/stackblitz-starters-fztw19?file=src%2Fsign-in-form%2Fsign-in-form.component.ts) is enabled, and the [sign-up form](https://stackblitz.com/edit/stackblitz-starters-fztw19?file=src%2Fsign-up-form%2Fsign-up-form.component.ts) is disabled.

This is all still happening from the “disabled” [signal input](https://angular.dev/guide/signals/inputs) and the [effect function](https://angular.dev/guide/signals/inputs#monitoring-changes) code that we just saw.

When we click to toggle the checkbox, we can see that an "Employee ID" field gets added to the form:

<div>
<img src="{{ '/assets/img/content/uploads/2024/11-01/demo-4.gif' | relative_url }}" alt="Toggling the employee id field" width="980" height="1000" style="width: 100%; height: auto;">
</div>

Then, when we switch to the [sign-up form component](https://stackblitz.com/edit/stackblitz-starters-fztw19?file=src%2Fsign-up-form%2Fsign-up-form.component.ts), the enabled forms swap and we also see an employee id field here too:

<div>
<img src="{{ '/assets/img/content/uploads/2024/11-01/demo-5.gif' | relative_url }}" alt="Switching to the sign-up form component" width="988" height="874" style="width: 100%; height: auto;">
</div>

If we toggle the checkbox, we can see the id field is removed:

<div>
<img src="{{ '/assets/img/content/uploads/2024/11-01/demo-6.gif' | relative_url }}" alt="Hiding the employee id field by toggling the checkbox" width="818" height="846" style="width: 100%; height: auto;">
</div>

So that’s what happens in the UI. Let’s look at the code to better understand what’s happening here.

In the [root app component](https://stackblitz.com/edit/stackblitz-starters-fztw19?file=src%2Fmain.ts), we have a checkbox input that, when toggled, sets a “hasEmployeeId” boolean [signal](https://angular.dev/guide/signals) to the opposite of its current value:

```html
<label>
    <input (change)="hasEmployeeId.set(!hasEmployeeId())" type="checkbox" />
    <span>I have an employee ID</span>
</label>
```

This [signal](https://angular.dev/guide/signals) is then passed as an [input](https://angular.dev/guide/signals/inputs) to each of the form components:

```html
<app-sign-in-form [hasEmployeeId]="hasEmployeeId()" ...></app-sign-in-form>
<app-sign-up-form [hasEmployeeId]="hasEmployeeId()" ...></app-sign-up-form>
```

Now let’s look at the code for the [sign-in component](https://stackblitz.com/edit/stackblitz-starters-fztw19?file=src%2Fsign-in-form%2Fsign-in-form.component.ts).

Here is the “hasEmployeeId” input:

```typescript
@Input() hasEmployeeId = false;
```

Now this input is still set up as a [decorator-based input](https://angular.dev/api/core/Input), but we’re going to change that in a minute.

Also, we have this “showEmployeeId” boolean property:

```typescript
protected showEmployeeId = false;
```

Then, we have the [ngOnChanges method](https://angular.dev/api/core/OnChanges) here again:

```typescript
ngOnChanges(changes: SimpleChanges) {
    if (changes['hasEmployeeId'] || changes['disabled']) {
        this.showEmployeeId = this.hasEmployeeId && !this.disabled();
    }
}
```

When the “hasEmployeeId” or “disabled” inputs change, we update the value of the “showEmployeeId” property.

Now, if we switch over to the [template](https://stackblitz.com/edit/stackblitz-starters-fztw19?file=src%2Fsign-in-form%2Fsign-in-form.component.html), here we can see that we conditionally display the employee id field based on the value of the “showEmployeeId” property:

```html
<div *ngIf="showEmployeeId">
    <label>Employee ID</label>
    <input type="text" />
</div>
```

So that’s how it works currently.

Now we’re going to switch this concept over to [signals](https://angular.dev/guide/signals) and we’re going to remove the [ngOnChanges lifecycle hook](https://angular.dev/api/core/OnChanges) when we do so.

## The Wrong Way: Using an Effect to Update This Property

The first thing we should do is switch the “hasEmployeeId” input to a [signal](https://angular.dev/guide/signals) using the [input function](https://angular.dev/guide/signals/inputs) instead:

#### Before:
```typescript
@Input() hasEmployeeId = false;
```

#### After:
```typescript
hasEmployeeId = input(false);
```

Now, we need to add parenthesis to its usage in the [ngOnChanges method](https://angular.dev/api/core/OnChanges) as well:

```typescript
ngOnChanges(changes: SimpleChanges) {
    if (changes['hasEmployeeId'] || changes['disabled']) {
        this.showEmployeeId = this.hasEmployeeId() && !this.disabled();
    }
}
```

And that’s it, this is now a [signal](https://angular.dev/guide/signals).

Next, we want to convert the “showEmployeeId” property to a [signal](https://angular.dev/guide/signals) as well.

To do this we can use the [signal function](https://angular.dev/guide/signals).

We’ll need to be sure to import it from @angular/core, and we’ll start with an initial value of false:

```typescript
import { ..., signal } from "@angular/core";

showEmployeeId = signal(false);
```

Then we need to use the set method in the [ngOnChanges method](https://angular.dev/api/core/OnChanges) instead:

```typescript
ngOnChanges(changes: SimpleChanges) {
    if (changes['hasEmployeeId'] || changes['disabled']) {
        this.showEmployeeId.set(this.hasEmployeeId() && !this.disabled());
    }
}
```

And for this property, we also need to update the template:

```html
@if (showEmployeeId()) {
    <label>
        <strong>
            Employee ID 
        </strong>
        <input type="text" formControlName="employeeId" />
    </label>
}
```

This property is now a [signal](https://angular.dev/guide/signals) too.

Now, we want to replace the [ngOnChanges lifecycle hook](https://angular.dev/api/core/OnChanges) concept for this and instead use a more modern, [signals-based approach](https://angular.dev/guide/signals) right?

This means we should use an [effect](https://angular.dev/guide/signals/inputs#monitoring-changes) right?

Well, let’s see.

Let’s add a new [effect](https://angular.dev/guide/signals/inputs#monitoring-changes) function in the constructor. Then, let’s move the logic for this into this new [effect](https://angular.dev/guide/signals/inputs#monitoring-changes):

```typescript
effect(() => {
    this.showEmployeeId.set(this.hasEmployeeId() && !this.disabled());
})
```

Then we can remove the [ngOnChanges method](https://angular.dev/api/core/OnChanges) and it’s imports too.

Ok, that should be it right?

Let’s save and see how it works:

<div>
<img src="{{ '/assets/img/content/uploads/2024/11-01/demo-7.gif' | relative_url }}" alt="Getting an error when toggling the checkbox" width="816" height="876" style="width: 100%; height: auto;">
</div>

Well, it looks like we have something wrong because, when we click on the checkbox, we’re not seeing the employee id field.

To better understand what’s going on here let's look at the console in the [Chrome Dev Tools](https://developer.chrome.com/docs/devtools/):

<div>
<img src="{{ '/assets/img/content/uploads/2024/11-01/demo-8.png' | relative_url }}" alt="Example of a runtime error when writing to signals within an effect" width="1210" height="638" style="width: 100%; height: auto;">
</div>

Ok, there it is, we’re getting a runtime error with the way that we’re setting our [signal](https://angular.dev/guide/signals) within the [effect](https://angular.dev/guide/signals/inputs#monitoring-changes).

But it’s also telling us that we a have a way around this by setting “allowSignalWrites” within the options for our [effect function](https://angular.dev/guide/signals/inputs#monitoring-changes).

So, we should do that right? 

Sure, why not.

### Using allowSignalWrites to Update Signals in an Effect

To do this, we just need to add the options parameter to our [effect function](https://angular.dev/guide/signals/inputs#monitoring-changes), and then set “allowSignalWrites” to true:

```typescript
effect(() => {
    this.showEmployeeId.set(this.hasEmployeeId() && !this.disabled());
}, { allowSignalWrites: true });
```

That’s all we should need to do.

Let’s save and see if it’s working correctly now:

<div>
<img src="{{ '/assets/img/content/uploads/2024/11-01/demo-9.gif' | relative_url }}" alt="Example of the employee field properly toggling" width="980" height="950" style="width: 100%; height: auto;">
</div>

Nice, now we’re properly toggling the field again.

So, this works, but it’s not actually what we want to do in this case.

Actually, this is probably almost never what we want to do.

### But, Don't Do This!

You really shouldn't use this approach unless you absolutely have to.

If you don’t deeply understand [signals](https://angular.dev/guide/signals) and [effects](https://angular.dev/guide/signals/inputs#monitoring-changes) and how they work under the hood, you shouldn’t update [signal](https://angular.dev/guide/signals) values in an [effect](https://angular.dev/guide/signals/inputs#monitoring-changes) like this.

You could potentially cause major performance degradation by triggering way more change detection cycles than actually needed due to their asynchronous nature.

So, probably, don’t use it.

In this case, we definitely have a better way.

We have something that is specifically designed to set a [signal](https://angular.dev/guide/signals) value, based on the values of other [signals](https://angular.dev/guide/signals), and it automatically updates when those other [signals](https://angular.dev/guide/signals) change.

This concept is a [computed signal](https://angular.dev/guide/signals#computed-signals).

## The Right Way: Using the Computed Function to Create a Signal Based on Another Signal

[Computed signals](https://angular.dev/guide/signals#computed-signals) should be used when the value needed can be derived from existing [signals](https://angular.dev/guide/signals), synchronously.

And this is what we have here.

To switch to a [computed signal](https://angular.dev/guide/signals#computed-signals), we’ll switch from the [signal function](https://angular.dev/guide/signals) to the [computed function](https://angular.dev/guide/signals#computed-signals) instead, and we need to be sure that it gets imported from the @angular/core module too:

```typescript
import { ..., computed } from "@angular/core";

showEmployeeId = computed();
```

This function will return a [signal](https://angular.dev/guide/signals) from the logic we put within it.

So, in this case, we can simply move our logic into this function instead of the [effect](https://angular.dev/guide/signals/inputs#monitoring-changes):

```typescript
showEmployeeId = computed(() => this.hasEmployeeId() && !this.disabled());
```

Now, whenever either of these [signal](https://angular.dev/guide/signals) values change, this [signal](https://angular.dev/guide/signals) will automatically update using the new values for each [signal](https://angular.dev/guide/signals).

That’s all we need to do for this.

So, let’s save and see how it works now:

<div>
<img src="{{ '/assets/img/content/uploads/2024/11-01/demo-9.gif' | relative_url }}" alt="Example of the employee field properly toggling" width="980" height="950" style="width: 100%; height: auto;">
</div>

Ok, looks like it’s working exactly like we want but now it’s done in the correct way for this example, using [computed signals](https://angular.dev/guide/signals#computed-signals).

{% include banner-ad.html %}

## In Conclusion

So, [effects](https://angular.dev/guide/signals/inputs#monitoring-changes) are really only for handling things related to [signals](https://angular.dev/guide/signals) that there’s no other way to do.

In this tutorial we saw one example, but others may include things like manipulating the DOM, or using a third-party charting library, etcetera.

And the reality is, you’ll rarely need them.

Also, you pretty much never want to set another [signal](https://angular.dev/guide/signals) within an [effect](https://angular.dev/guide/signals/inputs#monitoring-changes) unless you deeply understand how both [signals](https://angular.dev/guide/signals) and [effects](https://angular.dev/guide/signals/inputs#monitoring-changes) work.

Alright, I hope you found this tutorial helpful!

Don't forget to check out [my other Angular tutorials](https://www.youtube.com/@briantreese) for more tips and tricks.

## Additional Resources
* [The previous tutorial]({% post_url /2024/10/2024-10-25-disable-enable-form-control-on-signal-input-change %})
* [The demo BEFORE making any changes](https://stackblitz.com/edit/stackblitz-starters-fztw19?file=src%2Fsign-in-form%2Fsign-in-form.component.ts)
* [The demo AFTER making changes](https://stackblitz.com/edit/stackblitz-starters-ckrltt?file=src%2Fsign-in-form%2Fsign-in-form.component.ts)
* [Angular Effect function documentation](https://angular.dev/guide/signals/inputs#monitoring-changes)

## Want to See It in Action?
Check out the demo code and examples of these techniques in the Stackblitz example below. If you have any questions or thoughts, don’t hesitate to leave a comment.

<iframe src="https://stackblitz.com/edit/stackblitz-starters-ckrltt?ctl=1&embed=1&file=src%2Fsign-in-form%2Fsign-in-form.component.ts" style="height: 500px; width: 100%; margin-bottom: 1.5em; display: block;"></iframe>
