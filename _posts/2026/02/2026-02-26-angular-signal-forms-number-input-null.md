---
layout: post
title: "Angular Signal Forms: Why Number Inputs Were Broken (And Now Aren’t)"
date: "2026-02-26"
video_id: "3DlNnIsUsMM"
tags:
  - "Angular"
  - "Angular Forms"
  - "Signal Forms"
  - "Angular 21"
  - "TypeScript"
---

<p class="intro"><span class="dropcap">N</span>umber inputs in <a href="https://angular.dev/essentials/signal-forms" target="_blank">Angular Signal Forms</a> had a subtle but frustrating problem, there was no clean way to represent an empty numeric field. But, as of <a href="https://github.com/angular/angular/releases/tag/v21.2.0" target="_blank">v21.2.0</a>, this issue has been quietly fixed. Let me show you exactly what this looked like before, and then follow it up with how it works now.</p>

{% include youtube-embed.html %}

## The Starting Point: A Simple Signup Form

To demonstrate the problem, let's start with a basic signup form that has a username and email field:

<div><img src="{{ '/assets/img/content/uploads/2026/02-26/signup-form-before.jpg' | relative_url }}" alt="The signup form with username and email fields" width="1174" height="1108" style="width: 100%; height: auto;"></div>

At the bottom of the form, we're outputting the form model value so we can see exactly what's happening in real time as we interact with the form:

<div><img src="{{ '/assets/img/content/uploads/2026/02-26/signup-form-model-output.jpg' | relative_url }}" alt="The form model output showing the username and email fields" width="1306" height="388" style="width: 100%; height: auto;"></div>

Now let's say we need to add an age field. 

Seems simple enough, just add a number input, right? 

But this is where things get interesting.

## The Obvious Solution (zero)

In the [component TypeScript](https://github.com/brianmtreese/angular-signal-forms-null-number-example/blob/master/src/form/form.component.ts){:target="_blank"}, we have a `SignupModel` interface that defines the shape of our form data:

```typescript
interface SignupModel {
	username: string;
	email: string;
}
```

Now, we want to add a new property for age. 

Since this is a number field, I’ll type it as a number:

```typescript
interface SignupModel {
	username: string;
	email: string;
	age: number;
}
```

Now, we need to initialize the form model signal with a default value for the age field.

Since `age` is a number, the most obvious default value is zero:

```typescript
protected readonly model = signal<SignupModel>({
    username: '',
    email: '',
    age: 0,
});
```

We also need validation. 

Inside the form configuration function, we need to add a `required` validator for this new `age` field:

```typescript
protected readonly form = form(
    this.model, 
    s => {
        ...
        required(s.age, { message: 'Please enter an age' });
    }
);
```

This ensures that the user must provide a value for this field.

### Adding a Number Input Using Angular Signal Forms

In the template, the `age` field follows the same pattern as the other inputs:

```html
<div class="field">
    @let age = form.age();
    @let showAgeError = age.touched() && age.invalid();
    <label for="age">Age</label>
    <input
        id="age"
        type="number"
        [formField]="form.age" />
    @if (showAgeError) {
        <ul class="error-list">
            @for (error of age.errors(); track error.kind) {
                <li>{{ error.message }}</li>
            }
        </ul>
    }
</div>
```

We create an `age` template variable to reference the age field signal, and then a `showAgeError` variable to check if the field has been touched and is invalid.

Then, we add a label and number input for the `age` field.

The `formField` directive connects the input to the Signal Form control, just like the other fields.

Finally, we add a conditional error message loop that displays validation errors once the field has been touched and is invalid.

### The Problem with Zero

This works, but there's an immediate issue: The age field renders with `0` pre-filled:

<div><img src="{{ '/assets/img/content/uploads/2026/02-26/signup-form-age-field-zero.jpg' | relative_url }}" alt="The signup form with age field pre-filled with 0" width="1274" height="650" style="width: 100%; height: auto;"></div>

The form model output also shows `age: 0`:

<div><img src="{{ '/assets/img/content/uploads/2026/02-26/signup-form-model-output-age-zero.jpg' | relative_url }}" alt="The form model output showing the age field with a value of 0" width="1026" height="420" style="width: 100%; height: auto;"></div>

But zero is probably not the user's actual age.

It's a placeholder value that creates ambiguity.

We can't distinguish between the user intentionally entering zero and the user not entering anything at all.

Clearing the field does trigger the required validation error:

<div><img src="{{ '/assets/img/content/uploads/2026/02-26/signup-form-age-field-required-error.jpg' | relative_url }}" alt="The signup form with age field blurred showing the required error message" width="858" height="378" style="width: 100%; height: auto;"></div>

And the model value becomes `null`:

<div><img src="{{ '/assets/img/content/uploads/2026/02-26/signup-form-model-output-age-null.jpg' | relative_url }}" alt="The form model output showing the age field with a value of null" width="1002" height="406" style="width: 100%; height: auto;"></div>

But starting with zero isn't ideal for most real-world forms.

## The Type-Safety Compromise: Using a Union Type (string | number)

One workaround is to loosen the type so that `age` can be either a number or a string:

```typescript
export interface SignupModel {
    username: string;
    email: string;
    age: number | string;
}
```

Then initialize it with an empty string instead of zero:

```typescript
protected readonly model = signal<SignupModel>({
    username: '',
    email: '',
    age: '',
});
```

Now the field starts empty:

<div><img src="{{ '/assets/img/content/uploads/2026/02-26/signup-form-age-field-empty.jpg' | relative_url }}" alt="The signup form with age field empty" width="1198" height="392" style="width: 100%; height: auto;"></div>

And the model shows an empty string:

<div><img src="{{ '/assets/img/content/uploads/2026/02-26/signup-form-model-output-age-empty-string.jpg' | relative_url }}" alt="The form model output showing the age field with a value of empty string" width="1010" height="408" style="width: 100%; height: auto;"></div>

Typing a value works correctly:

<div><img src="{{ '/assets/img/content/uploads/2026/02-26/signup-form-age-field-value.jpg' | relative_url }}" alt="The signup form with age field entered with a value" width="1098" height="686" style="width: 100%; height: auto;"></div>

But we've introduced a different problem: from TypeScript's perspective, `age` might be a string. 

We've lost type safety, and in a real application, this can lead to bugs and extra conversion logic.

## The Hack Developers Used (NaN)

Another approach developers used was `NaN`.

So we revert the interface back to `number`:

```typescript
export interface SignupModel {
    username: string;
    email: string;
    age: number;
}
```

Then we initialize it with `NaN` instead of an empty string or zero:

```typescript
protected readonly model = signal<SignupModel>({
    username: '',
    email: '',
    age: NaN,
});
```

The field starts empty again: 

<div><img src="{{ '/assets/img/content/uploads/2026/02-26/signup-form-age-field-empty.jpg' | relative_url }}" alt="The signup form with age field empty" width="1198" height="392" style="width: 100%; height: auto;"></div>

And the model shows `null` this time, which looks correct:

<div><img src="{{ '/assets/img/content/uploads/2026/02-26/signup-form-model-output-age-null.jpg' | relative_url }}" alt="The form model output showing the age field with a value of null" width="1002" height="406" style="width: 100%; height: auto;"></div>

But `NaN` is semantically misleading. 

It literally means "not a number" while being typed as a `number`. 

It worked because Angular maps empty number inputs to `null`, but Signal Forms didn’t originally support `null` as a valid model value for number fields.

`NaN` was a workaround, not a real solution.

## The Correct Approach: Using null for Number Inputs in Angular Signal Forms

As of Angular 21.2.0, Signal Forms officially support `null` for number inputs. 

This aligns Signal Forms with how Reactive Forms and most backend systems represent optional numeric values.

We just need to update the interface to allow `null`:

```typescript
export interface SignupModel {
    username: string;
    email: string;
    age: number | null;
}
```

Then initialize with `null`:

```typescript
protected readonly model = signal<SignupModel>({
    username: '',
    email: '',
    age: null,
});
```

That's it!

Now the field still starts empty:

<div><img src="{{ '/assets/img/content/uploads/2026/02-26/signup-form-age-field-empty.jpg' | relative_url }}" alt="The signup form with age field empty" width="1198" height="392" style="width: 100%; height: auto;"></div>

And the model value is still `null` to start:

<div><img src="{{ '/assets/img/content/uploads/2026/02-26/signup-form-model-output-age-null.jpg' | relative_url }}" alt="The form model output showing the age field with a value of null" width="1002" height="406" style="width: 100%; height: auto;"></div>

There are no more hacks, no ambiguity, and no loss of type safety.

`null` clearly represents the absence of a value, which is exactly how most databases and APIs model optional numeric fields. 

Your form state now aligns directly with your data layer.

## In Summary

Angular 21.2.0 quietly shipped a small but meaningful improvement for Signal Forms: proper `null` support for number inputs. 

It eliminates the need for workarounds and gives you a clean, type-safe way to represent the absence of a numeric value.

If this helped you, be sure to [subscribe](https://www.youtube.com/c/briantreese?sub_confirmation=1) for more deep dives into modern Angular features.

## Additional Resources
- [The source code for this example](https://github.com/brianmtreese/angular-signal-forms-null-number-example){:target="_blank"}
- [v21.2.0-rc.0 Release Notes](https://github.com/angular/angular/releases/tag/v21.2.0-rc.0){:target="_blank"}
- [Angular Signal Forms Guide](https://angular.dev/essentials/signal-forms){:target="_blank"}
- [Angular Releases](https://github.com/angular/angular/releases){:target="_blank"}
- [My course "Angular: Styling Applications"](https://www.pluralsight.com/courses/angular-styling-applications){:target="_blank"}
- [My course "Angular in Practice: Zoneless Change Detection"](https://app.pluralsight.com/library/courses/angular-practice-zoneless-change-detection){:target="_blank"}
- [Get a Pluralsight FREE TRIAL HERE!](https://www.jdoqocy.com/click-101557355-17135603){:target="_blank"}
