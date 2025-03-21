---
layout: post
title: "Build a Dynamic Checkbox Form in Angular with Reactive Forms!"
date: "2025-03-20"
video_id: "NpsuDJcbf6k"
tags:
  - "Angular"
  - "Angular Forms"
  - "Angular Form Control"
  - "Forms"
---

<p class="intro"><span class="dropcap">T</span>oday, we're building a dynamic checkbox form in Angular using Reactive Forms. We’ll allow users to select multiple values from a list and display the selected values in real time. Then, we’ll take it a step further by adding a "Select All" checkbox so users can toggle everything at once. Let's get started!</p>

<iframe width="1280" height="720" src="https://www.youtube.com/embed/NpsuDJcbf6k" title="" frameborder="0" allow="accelerometer; autoplay; clipboard-write; encrypted-media; gyroscope; picture-in-picture; web-share" allowfullscreen></iframe>

## Dynamically Generating Checkbox Controls with Reactive Forms

To start off, I’ve already created [a basic Angular application](https://stackblitz.com/~/github.com/brianmtreese/dynamic-checkboxes-before).

It has [a basic form component](https://stackblitz.com/~/github.com/brianmtreese/dynamic-checkboxes-before?file=src/app/dynamic-checkbox-form/dynamic-checkbox-form.component.ts) and it's been included in the [root app component](https://stackblitz.com/~/github.com/brianmtreese/dynamic-checkboxes-before?file=src/app/app.component.ts):

```typescript
@Component({
    selector: 'app-root',
    template: `<app-dynamic-checkbox-form></app-dynamic-checkbox-form>`,
    imports: [DynamicCheckboxComponent],
})
```

This component is super basic as you can see:

```typescript
import { Component } from "@angular/core";
import { State, states } from "./states";

@Component({
  selector: "app-dynamic-checkbox-form",
  templateUrl: "./dynamic-checkbox-form.component.html",
  styleUrls: ["./dynamic-checkbox-form.component.scss"],
})
export class DynamicCheckboxComponent {
  protected states: State[] = states;
}
```

All we have is this “states” array.

[The data](https://stackblitz.com/~/github.com/brianmtreese/dynamic-checkboxes-before?file=src/app/dynamic-checkbox-form/states.ts) for this consists of an object for each state:

```typescript
export interface State {
    label: string;
    value: string;
}

export const states: State[] = [
    { label: 'Alabama', value: 'AL' },
    { label: 'Alaska', value: 'AK' },
    { label: 'Arizona', value: 'AZ' },
    { label: 'Arkansas', value: 'AR' },
    { label: 'California', value: 'CA' },
    ... // 45 more states
];
```

In a real-world scenario, this data would likely come from an API, meaning that this data would be dynamic.

What we’re going to do is use the [Reactive Forms Module](https://angular.dev/api/forms/ReactiveFormsModule) in Angular to create a dynamic list of checkboxes out of this data.

Now with a basic [form control](https://angular.dev/api/forms/FormControl) in Angular, you’d normally just create a [form control](https://angular.dev/api/forms/FormControl) statically, but in this case, we need to dynamically create a backing control for each state.

Creating these options as Angular [form controls](https://angular.dev/api/forms/FormControl) makes it so Angular will track each checkbox’s state automatically.

So first, we need to create what is known as a [form group](https://angular.dev/api/forms/FormGroup) in Angular.

This is essentially a programmatic container for an angular form which allows us to track and monitor state of a set of Angular [form controls](https://angular.dev/api/forms/FormControl).

So, let’s begin by creating a “form” property for this form group:

```typescript
import { FormGroup } from "@angular/forms";

protected form = new FormGroup({});
```

Since this will be a container for all of our dynamic checkbox fields, we need to now add an Angular [form control](https://angular.dev/api/forms/FormControl) for each of the states within this form group.

So, we’ll iterate over the states from the list.

And when we do, we add an Angular [form control](https://angular.dev/api/forms/FormControl) for each object.

The name for each of the controls will be the value from the state object.

The initial value for each of the controls will be false:

```typescript
import { ..., FormControl } from "@angular/forms";

protected form = new FormGroup(
    Object.fromEntries(
        this.states.map(
            option => [option.value, new FormControl(false, { nonNullable: true })]
        )
    )
);
```

Ok, at this point we’ve created an Angular [form group](https://angular.dev/api/forms/FormGroup) with a control for each item in our dynamic data.

Now, we just need to wire these controls up in [our template](https://stackblitz.com/~/github.com/brianmtreese/dynamic-checkboxes-before?file=src/app/dynamic-checkbox-form/dynamic-checkbox-form.component.html) to create the UI.

But before we can do this, we’re going to use some directives from the [Reactive Forms module](https://angular.dev/api/forms/ReactiveFormsModule) so we need to import this module first:

```typescript
import { ReactiveFormsModule } from "@angular/forms";

@Component({
    selector: "app-dynamic-checkbox-form",
    ...,
    imports: [ReactiveFormsModule]
})
```

## Connecting the Form Controls to the UI

Okay, now let’s start by adding a [form element](https://developer.mozilla.org/en-US/docs/Web/HTML/Element/form).

On this [form](https://developer.mozilla.org/en-US/docs/Web/HTML/Element/form), let’s add the [formGroup](https://angular.dev/api/forms/FormGroup#formgroup) directive to connect up the form group that we created:

```html
<form [formGroup]="form"></form>
```

This is the container for all of our checkbox form controls, so now, we can use a [@for](https://angular.dev/api/core/@for) block to iterate over the states in the list.

Within this loop let’s add some basic markup for each of the state options in the list, and let’s add a checkbox input.

These inputs will be the Angular [form controls](https://angular.dev/api/forms/FormControl) for our form group.

We can mark them as such with the [formControlName](https://angular.dev/api/forms/FormControlName) directive from the Angular [Reactive Forms module](https://angular.dev/api/forms/ReactiveFormsModule).

And, when we created the controls in the group, we used the state object value as the name so that’s what we need to use here too in order to bind the Angular form control to the input:

```html
<form [formGroup]="form">
  @for (option of states; track option.value) {
  <div>
    <label>
      <input type="checkbox" [formControlName]="option.value" />
      {{ option.label }}
    </label>
  </div>
  }
</form>
```

## Displaying Selected Checkboxes in Real-Time

Ok, at this point we should have a functioning [form group](https://angular.dev/api/forms/FormGroup), but in order to better understand what’s going on, we’re going to add a little bit more to this example.

What we need now is, we need a way to display the states that the user selects so that we know that things are functioning correctly.

### Extracting Selected States from the Form

So, let’s create a [getter function](https://www.typescripttutorial.net/typescript-tutorial/typescript-getters-setters/) that extracts the selected states from our form:

```typescript
get selectedValues() {
    return Object.keys(this.form.value).filter(key => this.form.value[key]);
}
```

This function checks which states have a value of “true” in our form and returns a list of selected states.

Now, let’s move on to the template and add this data to the UI.

We’ll add a div, and then we’ll add the [string interpolated value](https://angular.dev/guide/templates/binding#render-dynamic-text-with-text-interpolation) from this getter function that we just added.

Ok, that should be everything we need.

Let’s save, and let the project refresh.

<div>
<img src="{{ '/assets/img/content/uploads/2025/03-20/demo-1.gif' | relative_url }}" alt="Example of a dynamic checkbox form in Angular" width="656" height="1080" style="width: 100%; height: auto;">
</div>

Now, if we check a few checkboxes, we should see the states appear in the selected values list.

And if we uncheck them, they should disappear.

So, this is all pretty neat, isn’t it?

We have a dynamic list of data, and we’ve used this data to create a dynamic list of Angular [Reactive Form controls](https://angular.dev/api/forms/FormControl).

But selecting multiple checkboxes one by one is tedious.

Let’s improve this by adding a "Select All" checkbox that will toggle everything at once!

## Implementing a “Select All” Checkbox for Easy Selection

In order to do this, we’re going to add another Angular [form control](https://angular.dev/api/forms/FormControl).

Let’s start by adding a new property called “selectAll”.

It will be a [form control](https://angular.dev/api/forms/FormControl) and we’ll add it outside of the other form group because we won’t be concerned with the state of this control as far as our form data is concerned.

Also, we’ll set the initial value to false:

```typescript
protected selectAll = new FormControl(false, { nonNullable: true });
```

Now we need to add some logic to toggle all of the checkboxes when the value of this control changes.

To do this, let’s add a new function called “toggleAll”.

This function will need a parameter for whether the field is checked or not.

Okay, now within this function, we can again, iterate over the list of states using the [forEach()](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/Array/forEach) method.

Now, for each state, we can access its individual form control using the [get()](https://angular.dev/api/forms/FormGroup#get) method on the form group by passing the state's value as the control name.

This gives us programmatic access to the controls so now we can use the [setValue()](https://angular.dev/api/forms/FormControl#setValue) function to programmatically set the value.

For this value, we’ll pass our “checked” parameter, and, we’ll set “emitEvent” in the control options to false to prevent triggering unnecessary form change events:

```typescript
private toggleAll(checked: boolean) {
    const controlsArray = Object.keys(this.form.controls);
    controlsArray.forEach(key => {
        this.form.get(key)?.setValue(checked, { emitEvent: false });
    });
}
```

Now, we just need to call this function when the "Select All" control value changes.

Let’s add a constructor.

Next, let’s access the "Select All" [form control](https://angular.dev/api/forms/FormControl) so we can use the [valueChanges](https://angular.dev/api/forms/FormControl#valueChanges) method.

This method returns an observable that fires every time the control value changes.

Next, since this function returns an observable, we want to add the [takeUntilDestroyed()](https://angular.dev/api/core/rxjs-interop/takeUntilDestroyed) method to properly clean up the subscription when the component is destroyed.

Finally, we can subscribe to this observable and call our toggleAll() function, passing the checked value of the control:

```typescript
import { takeUntilDestroyed } from '@angular/core/rxjs-interop';

constructor() {
    this.selectAll.valueChanges
        .pipe(takeUntilDestroyed())
        .subscribe(checked => this.toggleAll(checked));
}
```

Now, whenever the "Select All" checkbox is checked or unchecked, our function will automatically update all checkboxes.

Now that our logic is ready, let’s update the template to display the "Select All" checkbox at the top of the form.

We’ll add similar markup to the state checkbox items so that it will look right.

And, this time, we’ll use the [formControl](https://angular.dev/api/forms/FormControlDirective) directive to bind to our selectAll control:

```html
<div>
  <label>
    <input type="checkbox" [formControl]="selectAll" />
    Select All
  </label>
</div>
```

Okay, that should be everything we need.

Now, let’s save and refresh the project:

<div>
<img src="{{ '/assets/img/content/uploads/2025/03-20/demo-2.gif' | relative_url }}" alt="Example of a dynamic checkbox form in Angular with a 'Select All' checkbox" width="656" height="1080" style="width: 100%; height: auto;">
</div>

Now, clicking 'Select All' should check every checkbox in the list.

Also, unchecking it should uncheck everything!

And checking individual boxes should still work independently from “Select All.”

And just like that, we’ve built a fully functional, dynamic checkbox form in Angular!

## What We Built Today: A Quick Recap

And that’s it!

Today, we: created a dynamic checkbox form using Reactive Forms, allowed users to select multiple checkboxes, displayed selected values in real time, and added a "Select All" checkbox for bulk selection.

And best of all, this method is scalable and flexible.

If you found this helpful, don't forget to [subscribe](https://www.youtube.com/c/briantreese?sub_confirmation=1) and check out [my other Angular tutorials](https://www.youtube.com/@briantreese) for more tips and tricks!

{% include banner-ad.html %}

## Additional Resources

- [The demo app BEFORE any changes](https://stackblitz.com/~/github.com/brianmtreese/dynamic-checkboxes-before?file=src/app/dynamic-checkbox-form/dynamic-checkbox-form.component.ts)
- [The demo app AFTER making changes](https://stackblitz.com/~/github.com/brianmtreese/dynamic-checkboxes-after?file=src/app/dynamic-checkbox-form/dynamic-checkbox-form.component.ts)
- [Reactive Forms Guide](https://angular.dev/guide/forms/reactive-forms)
- [FormGroup API Reference](https://angular.dev/api/forms/FormGroup)
- [FormControl API Reference](https://angular.dev/api/forms/FormControl)

## Want to See It in Action?

Check out the demo code showcasing these techniques in the StackBlitz project below. If you have any questions or thoughts, don’t hesitate to leave a comment.

**Check out the demo here:** [https://stackblitz.com/~/github.com/brianmtreese/dynamic-checkboxes-after](https://stackblitz.com/~/github.com/brianmtreese/dynamic-checkboxes-after)
