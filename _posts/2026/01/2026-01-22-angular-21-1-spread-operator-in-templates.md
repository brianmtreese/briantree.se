---
layout: post
title: "Angular 21.1 Template Spread Operator: Compose Arrays and Objects Directly in Templates"
date: "2026-01-22"
video_id: "Zw3JZTCTqUE"
tags:
  - "Angular"
  - "Angular Templates"
  - "Angular 21"
  - "TypeScript"
  - "Template Syntax"
  - "Spread Operator"
---

<p class="intro"><span class="dropcap">A</span>ngular 21.1 introduced a feature that sounds small but eliminates a whole class of helper methods we've all written for years. This update lets you compose arrays and objects directly in templates using the <a href="https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Operators/Spread_syntax" target="_blank">spread operator</a> (...). This means you can merge arrays and extend objects declaratively and keep UI logic where it belongs: in the template. Let's see how it works!</p>

{% include youtube-embed.html %}

## The Example Application

Here we have a [basic users list application](https://github.com/brianmtreese/angular-template-spread-operator-example){:target="_blank"}:

<div>
<img src="{{ '/assets/img/content/uploads/2026/01-22/users-list-application.jpg' | relative_url }}" alt="Example of a basic users list application in Angular 21.1" width="1290" height="1420" style="width: 100%; height: auto;">
</div>

The data is composed from several different sources, which we'll explore in detail in a moment.

At the top, we have checkboxes to mock whether we're an admin or to simulate when the app may be busy processing something:

<div>
<img src="{{ '/assets/img/content/uploads/2026/01-22/checkboxes.jpg' | relative_url }}" alt="Checkboxes to mock whether we're an admin or to simulate when the app may be busy processing something" width="1292" height="466" style="width: 100%; height: auto;">
</div>

We're starting out in admin mode.

Because of this, we have a button here where we can delete all users: 

<div>
<img src="{{ '/assets/img/content/uploads/2026/01-22/delete-all-users-button.jpg' | relative_url }}" alt="Button to delete all users" width="1316" height="272" style="width: 100%; height: auto;">
</div>

Then we have a button next to each user where we can delete them individually:

<div>
<img src="{{ '/assets/img/content/uploads/2026/01-22/delete-user-button.jpg' | relative_url }}" alt="Button to delete an individual user" width="1510" height="328" style="width: 100%; height: auto;">
</div>

When we click the button to delete all users, we get a console log showing the configuration that we're passing to this particular button:

<div>
<img src="{{ '/assets/img/content/uploads/2026/01-22/delete-all-users-button-config.jpg' | relative_url }}" alt="Configuration object for the delete all users button" width="1004" height="428" style="width: 100%; height: auto;">
</div>

We've got a confirm, disabled, icon, label, telemetry, and tone property on the object.

In telemetry, we can see that the event is related to deleting all users and that the source is "controls_menu".

The individual user delete buttons have a very similar looking object:

<div>
<img src="{{ '/assets/img/content/uploads/2026/01-22/delete-user-button-config.jpg' | relative_url }}" alt="Configuration object for the delete user button" width="1004" height="430" style="width: 100%; height: auto;">
</div>

In fact, everything is the same as the other button except for the telemetry.

Keep this in mind because we'll be making changes to these buttons using the spread operator.

Now if we check "is busy", every delete button becomes disabled:

<div>
<img src="{{ '/assets/img/content/uploads/2026/01-22/delete-buttons-disabled.jpg' | relative_url }}" alt="All delete buttons are disabled when the app is busy" width="1276" height="1410" style="width: 100%; height: auto;">
</div>

This simulates what would happen after submitting one of these actions while it's processing.

If we turn off "is admin," the top delete button disappears entirely and the user delete buttons are still there, but disabled:

<div>
<img src="{{ '/assets/img/content/uploads/2026/01-22/delete-buttons-disabled-non-admin.jpg' | relative_url }}" alt="All delete buttons are disabled when the app is busy and non-admin" width="1308" height="1364" style="width: 100%; height: auto;">
</div>

This is our baseline. Everything works as expected. Now let's look at how it's built.

## Baseline: What Works Today

Let's open up [the template](https://github.com/brianmtreese/angular-template-spread-operator-example/blob/master/src/app/users-page/users-page.component.html){:target="_blank"} for this component and scroll down to where the users are listed out:

```html
<ul class="users-list">
  @for (user of users(); track user.id) {
    ...
  }
</ul>
```

This is pretty straightforward. 

We have a simple `@for` block that renders users based on a `users` array [signal](https://angular.dev/api/core/signal){:target="_blank"}.

Let's see how this array is being created in [the component](https://github.com/brianmtreese/angular-template-spread-operator-example/blob/master/src/app/users-page/users-page.component.ts){:target="_blank"}.

First, we have several arrays as signals that come from external sources:

```typescript
import { ..., invitedUsers, pinnedUsers, searchResults, suggestedUsers, } from './users.data';

export class UsersPageComponent {
  ...
  protected readonly pinnedUsers = pinnedUsers;
	protected readonly searchResults = searchResults;
	protected readonly suggestedUsers = suggestedUsers;
	protected readonly invitedUsers = invitedUsers;
  ...
}
```

Then, we merge all of these together into a single array using a [computed signal](https://angular.dev/api/core/computed){:target="_blank"}:

```typescript
import { ..., computed } from '@angular/core';

export class UsersPageComponent {
  ...
  protected readonly users = computed(() => [
		...this.pinnedUsers(), 
		...this.searchResults(), 
		...this.suggestedUsers(), 
		...this.invitedUsers()
	]);
  ...
}
```

This is perfectly fine as is. 

It's an acceptable way to do this type of thing.

But now we've got a new option. 

We can compose this list directly in the template using the spread operator.

## Spread Operator in Templates for Arrays (Angular 21.1)

Let's go back to the HTML and add a new template variable called "users". 

It will be an array:

```html
@let users = [
	...pinnedUsers(),
	...searchResults(),
	...suggestedUsers(),
	...invitedUsers()
];
```

That's it. We can do this right in the template now.

We don't have to use the computed signal if we don't want to. Pretty cool, right?

This matters because this logic is purely about how the view is shaped. 

It doesn't need to live in the component class anymore.

Then we just need to go through the template and update anything using the old computed signal to use this new variable:

#### Before:
```html
@for (user of users(); track user.id) {
  ...
}
```

#### After:
```html
@for (user of users; track user.id) {
  ...
}
```

So we've completely removed the computed signal from the picture. 

The template is now responsible for composing the list.

Everything behaves exactly the same. 

But now our list composition lives with the markup that consumes it. 

No helper methods. No computed signals. Just simple, declarative UI.

It's just another, slightly more simplistic way to create the list in this case.

## From Arrays to Objects

Now let's look at another example using the spread operator with objects this time.

Here's the code for the delete all users button:

```html
<app-action-button
  [config]="{
    label: 'Delete',
    icon: 'trash',
    confirm: true,
    tone: 'danger',
    disabled: isBusy(),
    telemetry: { event: 'delete_all_users', source: 'controls_menu' }
  }"
/>
```

It uses a [custom component](https://github.com/brianmtreese/angular-template-spread-operator-example/blob/master/src/app/action-button/action-button.component.ts){:target="_blank"} that takes in a `config` [input](https://angular.dev/api/core/input){:target="_blank"}. 

There are quite a few properties in this object, and if we remember back to the original example, lots of these were the same in the individual delete user buttons.

Here's how those are wired up:

```html
@if (isAdmin()) {
  <app-action-button
    [config]="{
      label: 'Delete',
      icon: 'trash',
      confirm: true,
      tone: 'danger',
      disabled: isBusy(),
      telemetry: { event: 'delete_user', source: 'row_menu' }
    }"
  />
} @else {
  <app-action-button
    [config]="{
      label: 'Delete',
      icon: 'trash',
      confirm: true,
      tone: 'warning',
      disabled: true,
      telemetry: {}
    }"
  />
}
```

With these buttons, we're repeating ourselves. 

And repetition always grows.

First it's two buttons, then it's four, then someone fixes a bug in one place and forgets the others.

So, let's simplify this using the spread operator.

First, let's add a variable for the configuration that's shared across all three buttons:

```html
@let sharedButtonConfig = {
	label: 'Delete',
	icon: 'trash',
	confirm: true,
};
```

Now let's create a variable for the configuration shared across the two admin buttons:

```html
@let sharedAdminButtonConfig = {
	...sharedButtonConfig,
	tone: 'danger',
	disabled: isBusy(),
};
```

In this, we can use the spread operator to include our `sharedButtonConfig`, then we'll add the `tone`, and disable it when busy.

Now we can go and update the config for the delete all button:

```html
<app-action-button
  [config]="{
    ...sharedAdminButtonConfig,
    telemetry: { event: 'delete_all_users', source: 'controls_menu' }
  }"
/>
```

Here we use the spread operator with the `sharedAdminButtonConfig` and then add the telemetry.

Now we can do the same for the admin button on the user delete button:

```html
@if (isAdmin()) {
  <app-action-button [config]="{
    ...sharedAdminButtonConfig,
    telemetry: { event: 'delete_user', source: 'row_menu' }
  }" />
} @else {
  ...
}
```

Then on the non-admin button, we'll use the shared configuration to replace everything except for `tone`, `disabled`, and `telemetry`:

```html
@if (isAdmin()) {
  ...
} @else {
  <app-action-button [config]="{
    ...sharedButtonConfig,
    tone: 'warning',
    disabled: true,
    telemetry: {}
  }" />
}
```

And that's it. With this, we were able to simplify these shared concepts right here within the template.

When we click the delete all users button, we get the same configuration object:

<div>
<img src="{{ '/assets/img/content/uploads/2026/01-22/delete-all-users-button-config.jpg' | relative_url }}" alt="Configuration object for the delete all users button" width="1004" height="428" style="width: 100%; height: auto;">
</div>

Same for the individual user delete buttons:

<div>
<img src="{{ '/assets/img/content/uploads/2026/01-22/delete-user-button-config.jpg' | relative_url }}" alt="Configuration object for the delete user button" width="1004" height="430" style="width: 100%; height: auto;">
</div>

When we check "is busy", every delete button still becomes disabled:

<div>
<img src="{{ '/assets/img/content/uploads/2026/01-22/delete-buttons-disabled.jpg' | relative_url }}" alt="All delete buttons are disabled when the app is busy" width="1276" height="1410" style="width: 100%; height: auto;">
</div>

If we turn off "is admin," the top delete button still disappears and the user delete buttons are still there and disabled:

<div>
<img src="{{ '/assets/img/content/uploads/2026/01-22/delete-buttons-disabled-non-admin.jpg' | relative_url }}" alt="All delete buttons are disabled when the app is busy and non-admin" width="1308" height="1364" style="width: 100%; height: auto;">
</div>

Everything behaves exactly the same, but now our shared intent is visible, explicit, and impossible to drift out of sync.

## Why This Actually Matters

Hopefully these examples have got you thinking.

Angular templates just got a little closer to TypeScript and that's a big deal.

It's cool because now you can:
- **Compose arrays directly in the template**: Merge multiple arrays without anything extra.
- **Extend objects declaratively**: Use the spread operator to build objects incrementally.
- **Keep UI logic in the UI**: Move view-specific composition logic from the component class to the template.

This feature bridges the gap between Angular templates and TypeScript, making templates more powerful and expressive while keeping them declarative and easy to understand.

## Additional Resources
- [The demo project](https://github.com/brianmtreese/angular-template-spread-operator-example){:target="_blank"}
- [MDN Spread syntax (...) documentation](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Operators/Spread_syntax){:target="_blank"}
- [My course "Angular: Styling Applications"](https://www.pluralsight.com/courses/angular-styling-applications){:target="_blank"}
- [My course "Angular in Practice: Zoneless Change Detection"](https://app.pluralsight.com/library/courses/angular-practice-zoneless-change-detection){:target="_blank"}
- [Get a Pluralsight FREE TRIAL HERE!](https://www.jdoqocy.com/click-101557355-17135603){:target="_blank"}
