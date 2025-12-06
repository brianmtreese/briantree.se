---
layout: post
title: "Goodbye FormArray. Hello Signal Forms."
date: "2025-10-30"
video_id: "tHBS_l_36h4"
tags:
  - "Angular"
  - "Angular Forms"
  - "Angular Signals"
  - "Reactive Forms"
  - "Signal Forms"
---

<p class="intro"><span class="dropcap">D</span>ynamic forms with Reactive Forms require FormArrays, complex state management, and imperative code that's hard to maintain. Angular's Signal Forms API provides a more reactive, declarative approach to building dynamic forms, eliminating FormArrays and simplifying field addition/removal. This tutorial demonstrates how to migrate a dynamic form from Reactive Forms to Signal Forms, showing how the new API makes dynamic form management cleaner and more intuitive.</p>

{% include youtube-embed.html %}

#### Angular Signal Forms Tutorial Series:
- [Migrate to Signal Forms]({% post_url /2025/10/2025-10-16-how-to-migrate-from-reactive-forms-to-signal-forms-in-angular %}) - Start here for migration basics
- [Signal Forms vs Reactive Forms]({% post_url /2025/11/2025-11-06-signal-forms-are-better-than-reactive-forms-in-angular %}) - See why Signal Forms are better
- [Custom Validators]({% post_url /2025/11/2025-11-13-how-to-migrate-a-form-with-a-custom-validator-to-signal-forms-in-angular %}) - Add custom validation
- [Custom Controls]({% post_url /2025/10/2025-10-23-how-to-migrate-a-custom-control-to-signal-based-forms %}) - Migrate custom controls

## The Dynamic Form in Action

Here’s the demo app we’ll be working with:

<div>
<img src="{{ '/assets/img/content/uploads/2025/10-30/demo-1.jpg' | relative_url }}" alt="A dynamic form with one email text field in Angular" width="802" height="710" style="width: 100%; height: auto;">
</div>

It's a dynamic form that starts with one email text field:

<div>
<img src="{{ '/assets/img/content/uploads/2025/10-30/demo-2.jpg' | relative_url }}" alt="A single email text field in the original state of the dynamic form" width="1050" height="262" style="width: 100%; height: auto;">
</div>

It has a button to add another email field dynamically:

<div>
<img src="{{ '/assets/img/content/uploads/2025/10-30/demo-3.jpg' | relative_url }}" alt="The dynamic form with the add button" width="684" height="242" style="width: 100%; height: auto;">
</div>

It also has a submit button that’s disabled until the form is valid:

<div>
<img src="{{ '/assets/img/content/uploads/2025/10-30/demo-4.jpg' | relative_url }}" alt="The dynamic form with the submit button disabled because the form is invalid" width="644" height="222" style="width: 100%; height: auto;">
</div>

And below all of this, it has a live JSON preview of the form’s current value:

<div>
<img src="{{ '/assets/img/content/uploads/2025/10-30/demo-5.jpg' | relative_url }}" alt="The dynamic form with the live JSON preview of the form's current value" width="1066" height="296" style="width: 100%; height: auto;">
</div>

When we click the “Add user” button, it creates a new email field. 

<div>
<img src="{{ '/assets/img/content/uploads/2025/10-30/demo-6.jpg' | relative_url }}" alt="The dynamic form with the new email field added" width="800" height="876" style="width: 100%; height: auto;">
</div>

If the field is invalid, we show a validation message: 

<div>
<img src="{{ '/assets/img/content/uploads/2025/10-30/demo-7.jpg' | relative_url }}" alt="The dynamic form with the validation message showing when the email field is invalid" width="1080" height="334" style="width: 100%; height: auto;">
</div>

And once the email becomes valid, the message disappears. 

<div>
<img src="{{ '/assets/img/content/uploads/2025/10-30/demo-8.jpg' | relative_url }}" alt="The dynamic form with the validation message disappearing when the email field is valid" width="846" height="256" style="width: 100%; height: auto;">
</div>

Removing the empty field, updates the form's validity, enabling the submit button:

<div>
<img src="{{ '/assets/img/content/uploads/2025/10-30/demo-9.jpg' | relative_url }}" alt="The dynamic form with the submit button enabled when the form is valid" width="796" height="688" style="width: 100%; height: auto;">
</div>

Everything behaves exactly as we’d expect.

So this is our working baseline.

Now let’s look at the code that powers all of this before we flip it over to Signal Forms.

## How This Works with Reactive Forms (Before the Upgrade)

In the current version, we’re using the classic Reactive Forms module.

We define a [FormArray](https://angular.dev/api/forms/FormArray){:target="_blank"} of controls, each representing an email address:

```typescript
protected emails = new FormArray<FormControl<string>>([
    new FormControl<string>('', { 
        nonNullable: true, 
        validators: [
            Validators.required, 
            Validators.email
        ] 
    })
]);
```

The form starts with one entry, validated to be both required and a valid email format.

The component also provides an `add()` method that pushes a new control into the array:

```typescript
protected add() {
    this.emails.push(new FormControl<string>('', 
        { 
            nonNullable: true, 
            validators: [
                Validators.required,
                Validators.email
            ]
        })
    );
}
```

Then, there's a `remove()` method that removes the given control, by index, but only when there's more than one field:

```typescript
protected remove(index: number) {
    if (this.emails.length > 1) this.emails.removeAt(index);
}
```

In the template we loop through the `FormArray` to render each email field, remove button, and validation message.

```html
@for (ctrl of emails.controls; let i = $index; track ctrl) {
    <div class="row">
        ...
    </div>
}
```

The `input` is bound using the `formControl` directive:

```html
<input [formControl]="ctrl" />
```

The remove button only shows when more than one field exists:

```html
@if (emails.length > 1) {
    <button type="button" (click)="remove(i)">
        Remove
    </button>
}
```

The validation message appears when the control is both touched and invalid:

```html
@if (ctrl.touched && ctrl.invalid) {
    <p class="error">Enter a valid email.</p>
}
```

The submit button is disabled until the form is valid:

```html
<button 
    type="button" 
    [disabled]="emails.invalid" 
    (click)="submit()">
    Submit
</button>
```

And finally, the form’s raw value is displayed via JSON for debugging:

```html
<pre class="preview">
    {% raw %}{{ emails.getRawValue() | json }}{% endraw %}
</pre>
```

So far, very standard Reactive Forms.

Now let’s switch everything to Signal Forms.

## Meet Signal Forms: Angular’s Next-Gen Form API

Angular’s new Signal Forms API lets us describe forms using [signals](https://angular.dev/guide/signals){:target="_blank"} instead of Reactive Forms classes.

This feature is experimental, not for production yet, but it’s a huge step toward a cleaner, more intuitive way to model form state.

Our goal: convert the entire dynamic email form to Signal Forms without changing how it behaves.

## Step-by-Step: Converting Reactive Forms to Signal Forms

The first big change is removing the old `FormArray` entirely along with all of the Reactive Forms imports.

Instead, we’ll create a [signal()](https://angular.dev/guide/signals#writable-signals){:target="_blank"} named "model", which will represent our entire form state.

```typescript
import { form } from '@angular/forms/signals';

model = signal<{ id: string, value: string }[]>([{
    id: crypto.randomUUID(),
    value: ''
}]);
```

Each item in the `model()` signal holds:

- A **stable ID** (to ensure template updates stay consistent when fields are removed)
- A **string value** representing the email

Next, we use the new `form()` function to wrap this model in a **Field Tree**, which keeps UI, validation, and state in sync automatically:

```typescript
protected emails = form(this.model, root => {});
```

Inside the form builder callback, we apply our validators using:

- `applyEach()` to loop through each item in the list
- `required()` to require a value
- `email()` to require a valid email format

```typescript
import { ..., applyEach, required, email } from '@angular/forms/signals';

protected emails = form(this.model, root => {
    applyEach(root, item => {
        required(item.value);
        email(item.value);
    });
});
```

Now we refactor our `add()` method with the `model` signal directly instead of adding [FormControls](https://angular.dev/api/forms/FormControl){:target="_blank"} to the `FormArray`:

```typescript
protected add() {
    this.model.update(list => [...list, {
        id: crypto.randomUUID(),
        value: ''
    }]);
}
```

Each time the `add()` method is called, we add a new item to the list with a unique ID and an empty value.

Then we need to update the `remove()` method to remove the item at the given index from the `model` signal:

```typescript
protected remove(index: number) {
    this.model.update(list => 
        list.filter((_, i) => i !== index));
}
```

Finally, we need to import the new `Field` directive which we'll use to replace the old `formControl` directive in the template:

```typescript
import { ..., Field } from '@angular/forms/signals';

@Component({
    selector: 'app-email-list',
    ...,
    imports: [CommonModule, Field]
})
```

Alright, let's switch to the HTML.

## Updating the Template for Signal Forms

In the template, we need to update the loop to remove the `controls` property and to also track items using their new stable `id`:

#### Before:
```html
@for (ctrl of emails.controls; let i = $index; track ctrl) {
    ...
}
```

#### After:
```html
@for (ctrl of emails; let i = $index; track model()[i].id) {
    ...
}
```

Next, we need to replace the `formControl` binding with the new `field` directive, binding it to the email field’s `value` property:

```html
<input [field]="ctrl.value" >
```

Then, we need to update the remove button condition to reference the signal’s current state:

```html
@if (emails().value().length > 1) {
    <button type="button" (click)="remove(i)">
        Remove
    </button>
}
```

Next, we need to update the validation message to check `touched` and `invalid` signals instead of control properties:

```html
@if (ctrl().touched() && ctrl().invalid()) {
    <p class="error">Enter a valid email.</p>
}
```

After this, we need to update the submit button’s `disabled` state to use signal-based state:

```html
<button 
    type="button" 
    [disabled]="emails().invalid()"
    (click)="submit()">
    Submit
</button>
```

And finally, we need to replace the raw form value dump with the new `model` signal instead:

```html
<pre class="preview">
    {% raw %}{{ model() | json }}{% endraw %}
</pre>
```

That’s it, no behavior changes, no new UI, just a modern reactive form under the hood.

## Testing the Upgraded Signal Form

Once we save and refresh...

<div>
<img src="{{ '/assets/img/content/uploads/2025/10-30/demo-10.gif' | relative_url }}" alt="The dynamic form with the submit button enabled when the form is valid" width="1088" height="1076" style="width: 100%; height: auto;">
</div>

- Adding fields still works
- Validation still works
- Removing fields still works
- Form validity still controls the submit button
- The JSON output still updates instantly

The UI is unchanged, but the reactive system behind it is entirely new.

Sometimes switching to Signal Forms reduces the amount of code, but in this case the benefit is really about conceptual alignment:

✅ The form is now fully signal-driven  
✅ Works seamlessly with [computed signals](https://angular.dev/guide/signals#computed-signals){:target="_blank"}, [linked signals](https://angular.dev/api/core/linkedSignal){:target="_blank"} and [effects](https://angular.dev/api/core/effect){:target="_blank"}  
✅ No `FormArray` or `FormControl` plumbing  
✅ More consistent with the rest of Angular’s modern reactive patterns  

## Final Thoughts

That’s how you build a dynamic form using nothing but signals and the new Signal Forms API.

This feature is still experimental, but when it hits stable Angular, it’s going to simplify forms like never before.

If this helped you, be sure to [subscribe](https://www.youtube.com/c/briantreese?sub_confirmation=1) and leave a comment, it really helps other Angular developers find this content.

And hey — if you want to rep the Angular builder community, check out the Shieldworks “United by Craft” tees and hoodies [here](https://shop.briantree.se/){:target="_blank"}. They’re built for the ones who code like it’s a trade!

{% include banner-ad.html %}

## Additional Resources
- [The demo app BEFORE any changes](https://stackblitz.com/edit/stackblitz-starters-xisxcmo9?file=src%2Fform%2Fform.component.ts){:target="_blank"}
- [The demo app AFTER making changes](https://stackblitz.com/edit/stackblitz-starters-twqpr3gc?file=src%2Fform%2Fform.component.ts){:target="_blank"}
- [Angular Signal Forms GitHub (Experimental)](https://github.com/angular/angular/tree/main/packages/forms/signals){:target="_blank"}
- [Angular FormArray Docs](https://angular.dev/api/forms/FormArray){:target="_blank"}
- [My course "Angular: Styling Applications"](https://www.pluralsight.com/courses/angular-styling-applications){:target="_blank"}
- [My course "Angular in Practice: Zoneless Change Detection"](https://app.pluralsight.com/library/courses/angular-practice-zoneless-change-detection){:target="_blank"}
- [Get a Pluralsight FREE TRIAL HERE!](https://www.jdoqocy.com/click-101557355-17135603){:target="_blank"}

## Try It Yourself

Want to experiment with the final version? Explore the full StackBlitz demo below. 
 
If you have any questions or thoughts, don’t hesitate to leave a comment.

<iframe src="https://stackblitz.com/edit/stackblitz-starters-twqpr3gc?ctl=1&embed=1&file=src%2Fform%2Fform.component.ts" style="height: 500px; width: 100%; margin-bottom: 1.5em; display: block;"></iframe>
