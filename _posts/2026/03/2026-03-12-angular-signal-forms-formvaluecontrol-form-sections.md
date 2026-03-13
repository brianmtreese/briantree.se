---
layout: post
title: "Angular Signal Forms: Is FormValueControl Better for Large Forms?"
date: "2026-03-12"
video_id: "FN0PcwGa7ts"
tags:
  - "Angular"
  - "Angular Forms"
  - "Signal Forms"
  - "Form Validation"
  - "TypeScript"
---

<p class="intro"><span class="dropcap">I</span>n a <a href="{% post_url /2026/01/2026-01-08-angular-signal-forms-structuring-large-forms %}">recent guide</a> I showed a pattern for building large <a href="https://angular.dev/essentials/signal-forms" target="_blank">Angular Signal Forms</a> using reusable form sections. But a common follow-up question kept coming up: <em>Why not just use <a href="https://angular.dev/api/forms/signals/FormValueControl" target="_blank">FormValueControl</a> instead?</em> It sounded like a great idea, so I tried it. In this post you'll see how it works and why I'm not completely convinced it's actually the better approach for this scenario.</p>

{% include youtube-embed.html %}

## The Original Approach
[Structuring Large Forms]({% post_url /2026/01/2026-01-08-angular-signal-forms-structuring-large-forms %}) - The field tree approach this post compares against

## Angular Signal Forms Demo: Reusable Form Sections

Here's the form we're working with:

<div><img src="{{ '/assets/img/content/uploads/2026/03-12/profile-form-original.jpg' | relative_url }}" alt="The profile form with the account information, shipping address, and preferences sections" width="1524" height="1406" style="width: 100%; height: auto;"></div>

At the top we have an **Account Information** section, below that is a **Shipping Address** section, and finally there's a **Preferences** section at the bottom.

The important thing to note is that each of these form sections is its own Angular component. 

This makes large forms easier to maintain because each section owns its own UI and logic. 

If you've ever worked on a giant form component with 300 lines of inputs, you know why this matters. 

It also makes these form sections reusable elsewhere in the app as needed.

We also have a debug panel showing the real-time value and status of the form:

<div><img src="{{ '/assets/img/content/uploads/2026/03-12/debug-panel-original.jpg' | relative_url }}" alt="The debug panel showing the real-time value and status of the form" width="1050" height="1056" style="width: 100%; height: auto;"></div>

Typing in the first name updates the form value immediately:

<div><img src="{{ '/assets/img/content/uploads/2026/03-12/first-name-input-original.jpg' | relative_url }}" alt="The first name input field with the value updating in real time" width="1044" height="544" style="width: 100%; height: auto;"></div>

Now, let's look at how the original implementation worked.

## Building Reusable Angular Signal Forms with Field Tree

In [the template](https://github.com/brianmtreese/signal-forms-composition-formvaluecontrol-example/blob/master/src/app/sign-up/profile-form/profile-form.component.html){:target="_blank"} for the profile form component, the parent that wires the separate form sections into a single form, we see the three section components:

```html
<form (submit)="onSubmit($event)">
    <app-account-form [form]="form.account" />
    <app-address-form [form]="form.shippingAddress" />
    <app-preferences-form [form]="form.preferences" />
</form>
```

Each component receives a slice of the form's field tree through an input called `form`. 

The parent form owns the entire form structure and passes individual sections down to each component.

In [the component TypeScript](https://github.com/brianmtreese/signal-forms-composition-formvaluecontrol-example/blob/master/src/app/sign-up/profile-form/profile-form.component.ts){:target="_blank"}, we first define the interface for our profile form:

```typescript
import { ..., Account } from '../../account/account-form/account-form.model';
import { ..., Address } from '../../shipping/address-form/address-form.model';
import { ..., Preferences } from '../../account/preferences-form/preferences-form.model';

interface Profile {
    account: Account;
    shippingAddress: Address;
    preferences: Preferences;
}
```

Each section is typed with an interface exported from the individual components themselves.

Below this, we have our form model signal that holds the state of the entire form:

```typescript
import { ..., AccountModel } from '../../account/account-form/account-form.model';
import { ..., AddressModel  } from '../../shipping/address-form/address-form.model';
import { ..., PreferencesModel } from '../../account/preferences-form/preferences-form.model';

@Component({
  selector: 'app-profile-form',
    ...,
})
export class ProfileFormComponent {
    readonly model = signal<Profile>({
        account: AccountModel,
        shippingAddress: AddressModel,
        preferences: PreferencesModel
    });

    //...
}
```

Each section uses a variable to set the initial value. 

Since each form is its own reusable component, we store the interface and the initial model value with that component so we can access and maintain it near the component rather than wire it up uniquely in every form it's used in.

This was one of the key concepts from the previous example.

Below the model signal we create the form itself:

```typescript
import { ..., buildAccountSection } from '../../account/account-form/account-form.model';
import { ..., buildAddressSection } from '../../shipping/address-form/address-form.model';
import { ..., buildPreferencesSection } from '../../account/preferences-form/preferences-form.model';

@Component({
    selector: 'app-profile-form',
    ...,
})
export class ProfileFormComponent {
    readonly form = form(this.model, s => {
        buildAccountSection(s.account);
        buildAddressSection(s.shippingAddress);
        buildPreferencesSection(s.preferences);
    });

    //...
}
```

And here's the other main concept, each section exports a function that defines its validation. 

These live with the components themselves, just like the interface and initial values. 

That way the parent form can compose them easily without redefining them everywhere the components are used.

## Inside a Reusable Angular Form Section Component

In the original implementation, [the account form component](https://github.com/brianmtreese/signal-forms-composition-formvaluecontrol-example/blob/master/src/app/account/account-form/account-form.component.ts){:target="_blank"} had an input to take in the account field tree from the parent:

```typescript
@Component({
    selector: 'app-account-form',
    ...
})
export class AccountFormComponent {
    readonly form = input.required<FieldTree<Account>>();
}
```

The component expects the parent to pass in the account portion of the form.

In [the template](https://github.com/brianmtreese/signal-forms-composition-formvaluecontrol-example/blob/master/src/app/account/account-form/account-form.component.html){:target="_blank"}, each input is bound using the [FormField](https://angular.dev/api/forms/signals/FormField){:target="_blank"} directive accessing the appropriate field from the input:

```html
<label>
    First Name
    <input type="text" [formField]="form().firstName" />
    <app-validation-errors [fieldState]="form().firstName()" />
</label>
<label>
    Last Name
    <input type="text" [formField]="form().lastName" />
    <app-validation-errors [fieldState]="form().lastName()" />
</label>
```

Validation errors are shown by passing the control state to a custom [validation errors component](https://github.com/brianmtreese/signal-forms-composition-formvaluecontrol-example/tree/master/src/app/shared/validation-errors){:target="_blank"}.

Within each form section component we have a **model file** that contains three things:

1. **The interface** - used to strictly type this section of the form
2. **The initial value object** - used when this section is added to the parent form model signal
3. **A validation builder function** - takes a schema path tree typed with the section interface and defines required fields, patterns, etc.

For example, the account form model file looks like this:

```typescript
import { required, SchemaPathTree } from '@angular/forms/signals';

export interface Account {
    firstName: string;
    lastName: string;
}

export const AccountModel: Account = {
    firstName: '',
    lastName: ''
};

export function buildAccountSection(a: SchemaPathTree<Account>) {
    required(a.firstName, { message: 'First name is required' });
    required(a.lastName, { message: 'Last name is required' });
}
``` 

The main idea is as much of the form logic as possible lives with the component itself.

Anything needed to wire up the form in the parent is exported from the component so it doesn't have to be manually recreated everywhere it's used.

The address and preferences form components are set up the same way.

That was the whole concept. 

But now we're going to try something different.

## Refactoring to Angular FormValueControl

Instead of passing field trees into the section components, we can turn each section into a custom form control. 

Angular provides an interface for this called `FormValueControl`.

Let's start with the account section.

First, we add the interface to the component and type it with our `Account` interface:

```typescript
import { FormValueControl } from '@angular/forms/signals';

@Component({...})
export class AccountFormComponent implements FormValueControl<Account> {
    // ...
}
```

When you implement this interface, Angular expects the component to expose a `value` [model input](https://angular.dev/api/core/model){:target="_blank"}. 

So we replace the old input with a new model input that represents the entire value of the account section:

```typescript
import { ..., model } from '@angular/core';

@Component({...})
export class AccountFormComponent implements FormValueControl<Account> {
    value = model<Account>(AccountModel);
}
```

Next, we'll create a local form using the [form()](https://angular.dev/api/forms/signals/form){:target="_blank"} function from the Signal Forms API and move the validation from the model file into this form:

```typescript
protected form = form(this.value, a => {
    required(a.firstName, { message: 'First name is required' });
    required(a.lastName, { message: 'Last name is required' });
});
```

At this point the component owns its own validation completely which sounds nice, because the parent form doesn't have to know anything about the internal fields.

The validation moves out of the model file and into the component. 

In the template, we just need to update the bindings to use the local `form` property instead of the input signal:

#### Before:
```html
<input type="text" [formField]="form().firstName" />
```

#### After:
```html
<input type="text" [formField]="form.firstName" />
```

The address and preferences form components follow the same pattern. 

The address form implements `FormValueControl`, switches to the `value` model input, and creates a local form with its validation:

```typescript
@Component({
    selector: 'app-address-form',
    ...,
})
export class AddressFormComponent implements FormValueControl<Address> {
    value = model<Address>(AddressModel);

    protected form = form(this.value, s => {
        required(s.street, { message: 'Street is required' });
        required(s.city, { message: 'City is required' });
        required(s.state, { message: 'State is required' });
        required(s.zip, { message: 'ZIP code is required' });
        pattern(s.zip, /^\d{5}$/, { message: 'ZIP code must be 5 digits' });
    });
}
```

The preferences form is simpler because it has no validation:

```typescript
import { Component, model } from '@angular/core';
import { form, FormField, FormValueControl } from '@angular/forms/signals';
import { Preferences, PreferencesModel } from './preferences-form.model';

@Component({
    selector: 'app-preferences-form',
    ...,
})
export class PreferencesFormComponent implements FormValueControl<Preferences> {
    value = model<Preferences>(PreferencesModel);

    protected form = form(this.value);
}
```

Once all section components are converted to custom controls, we update the parent form to use them as such.

## Connecting FormValueControl to the Parent Signal Form

Since the child components now own their validation, the parent no longer needs to call the build functions.

We can remove those from the form definition.

#### Before:
```typescript
protected readonly form = form(this.model, s => {
    buildAccountSection(s.account);
    buildAddressSection(s.shippingAddress);
    buildPreferencesSection(s.preferences);
});
```

#### After:
```typescript
protected readonly form = form(this.model);
```

Then we need to import the new `FormField` directive so that we can use it in the template:

```typescript
import { ..., FormField } from '@angular/forms/signals';

@Component({
    selector: 'app-profile-form',
    ...,
    imports: [
        ...,
        FormField
    ],
})
```

Then we can update the template to use the `FormField` directive instead of the old input:

#### Before:
```html
<form [formRoot]="form">
    <app-account-form [form]="form().account" />
    <app-address-form [form]="form().shippingAddress" />
    <app-preferences-form [form]="form().preferences" />
</form>
```

#### After:
```html
<form [formRoot]="form">
    <app-account-form [formField]="form.account" />
    <app-address-form [formField]="form.shippingAddress" />
    <app-preferences-form [formField]="form.preferences" />
</form>
```

Now, after we save, everything still looks the same:

<div><img src="{{ '/assets/img/content/uploads/2026/03-12/profile-form-formvaluecontrol.jpg' | relative_url }}" alt="The profile form with the account information, shipping address, and preferences sections" width="1524" height="1406" style="width: 100%; height: auto;"></div>

The debug panel form object is unchanged. 

Typing in the first name updates the value, so the custom control is working:

<div><img src="{{ '/assets/img/content/uploads/2026/03-12/first-name-input-formvaluecontrol.jpg' | relative_url }}" alt="The first name input field with the value updating in real time" width="1044" height="544" style="width: 100%; height: auto;"></div>

But here's the problem.

When I click in and blur the last name field, we see the validation error inside the component which is correct:

<div><img src="{{ '/assets/img/content/uploads/2026/03-12/last-name-validation-error-formvaluecontrol.jpg' | relative_url }}" alt="The last name input field with the validation error" width="988" height="606" style="width: 100%; height: auto;"></div>

But in the debug panel, the parent form still says valid:

<div><img src="{{ '/assets/img/content/uploads/2026/03-12/debug-panel-formvaluecontrol.jpg' | relative_url }}" alt="The debug panel showing the form object with the account information, shipping address, and preferences sections" width="1102" height="632" style="width: 100%; height: auto;"></div>

The parent form has no idea those fields are required. 

The validation only exists inside the child form, so the parent doesn't see it. 

In my opinion, this is the biggest drawback of this approach.

The only fix I've found isn't great. 

### Why Parent Form Validation Breaks with FormValueControl

I had to add validation back within the parent's builder functions:

```typescript
export function buildAccountSection(a: SchemaPathTree<Account>) {
    required(a.firstName);
    required(a.lastName);
}
```

We don't need the error messages there because they already exist in the form section where they're displayed. 

But now things get awkward, we're duplicating validation logic.

In the address form it's worse:

```typescript
export function buildAddressSection(a: SchemaPathTree<Address>) {
    required(a.street);
    required(a.city);
    required(a.state);
    required(a.zip);
    pattern(a.zip, /^\d{5}$/);
}
```

We have a regular expression duplicated in two places.

We also need to add the builder functions back into the parent form to wire up this validation:

```typescript
protected readonly form = form(this.model, s => {
    buildAccountSection(s.account);
    buildAddressSection(s.shippingAddress);
    buildPreferencesSection(s.preferences);
});
```

After doing that, the form starts out invalid correctly now:

<div><img src="{{ '/assets/img/content/uploads/2026/03-12/profile-form-formvaluecontrol-invalid.jpg' | relative_url }}" alt="The profile form with the account information, shipping address, and preferences sections" width="914" height="552" style="width: 100%; height: auto;"></div>

Validation errors show when we blur required fields:

<div><img src="{{ '/assets/img/content/uploads/2026/03-12/last-name-validation-error-formvaluecontrol.jpg' | relative_url }}" alt="The last name input field with the validation error" width="988" height="606" style="width: 100%; height: auto;"></div>

And the form status becomes valid once all data is filled in:

<div><img src="{{ '/assets/img/content/uploads/2026/03-12/profile-form-formvaluecontrol-valid.jpg' | relative_url }}" alt="The profile form with the account information, shipping address, and preferences sections" width="1258" height="1198" style="width: 100%; height: auto;"></div>

Everything works, but we've duplicated validation logic to get there.

## Should You Use FormValueControl for Angular Signal Form Sections? 

You can absolutely build reusable form sections using `FormValueControl`, and technically it works. 

But for this specific scenario it doesn't actually simplify things. 

We ended up duplicating validation logic so the parent form could still understand the overall validity.

The original approach, passing field tree slices into section components, might still be the cleaner architecture for large forms. 

If you've found a better way to solve this with `FormValueControl`, I'd genuinely love to hear it.

## Learn Angular Signal Forms in depth

If you'd like to go deeper, I created a full course that walks through building a real Signal Form from scratch.

It covers:
- validation patterns 
- async validation 
- dynamic forms 
- custom controls 
- submission and server errors

You can check it out here:
👉 [Angular Signal Forms Course](https://www.udemy.com/course/angular-signal-forms/?couponCode=D25F85A7AC786D432252){:target="_blank"}

Use coupon code D25F85A7AC786D432252 for $9.99 for the first 5 days.

<div class="youtube-embed-wrapper">
	<iframe 
		width="1280" 
		height="720"
		src="https://www.youtube.com/embed/fZZ1UVkyB4I?rel=1&modestbranding=1" 
		frameborder="0" 
		allow="accelerometer; autoplay; clipboard-write; encrypted-media; gyroscope; picture-in-picture; web-share" 
		allowfullscreen
		loading="lazy"
		title="Signal Forms Course Preview"
	></iframe>
</div>

## Additional Resources
- [The source code for this example](https://github.com/brianmtreese/signal-forms-composition-formvaluecontrol-example){:target="_blank"}
- [How to Structure Large Forms Without Losing Your Mind]({% post_url /2026/01/2026-01-08-angular-signal-forms-structuring-large-forms %})
- [My course "Angular Signal Forms: Build Modern Forms with Signals"](https://www.udemy.com/course/angular-signal-forms/?couponCode=D25F85A7AC786D432252){:target="_blank"}
- [My course "Angular: Styling Applications"](https://www.pluralsight.com/courses/angular-styling-applications){:target="_blank"}
- [My course "Angular in Practice: Zoneless Change Detection"](https://app.pluralsight.com/library/courses/angular-practice-zoneless-change-detection){:target="_blank"}
