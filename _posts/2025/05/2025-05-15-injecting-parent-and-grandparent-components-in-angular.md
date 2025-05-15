---
layout: post
title: "You Might Not Need That Service After All 💉"
date: "2025-05-15"
video_id: "efmP6kCKgLs"
tags:
  - "Angular"
  - "Angular Inject"
  - "Component Communication"
  - "Angular Components"
  - "Angular Signals"
---

<p class="intro"><span class="dropcap">E</span>ver felt like your Angular components are playing telephone, passing messages up with <a href="https://angular.dev/api/core/output" target="_blank">outputs</a>, down with <a href="https://angular.dev/api/core/input" target="_blank">inputs</a>, or just screaming across the app through a <a href="https://angular.dev/guide/di/creating-injectable-service" target="_blank">service</a>? In this tutorial, I’ll show you a different way to pass context down, or back up, without relying on a shared service. We’ll inject a parent, or even a grandparent, component directly.</p>

<iframe width="1280" height="720" src="https://www.youtube.com/embed/efmP6kCKgLs" frameborder="0" allowfullscreen></iframe>

## Previewing the App and the Problem

Let’s start by first looking at what we’ve got.

We have a [user management UI](https://stackblitz.com/edit/stackblitz-starters-qfteae9t?file=src%2Fmain.ts){:target="_blank"} with a list of users that we can delete:

<div>
<img src="{{ '/assets/img/content/uploads/2025/05-15/demo-1.png' | relative_url }}" alt="Example of a simple Angular user management UI" width="784" height="892" style="width: 100%; height: auto;">
</div>

Click “Delete” on any user, and we get a confirmation dialog:

<div>
<img src="{{ '/assets/img/content/uploads/2025/05-15/demo-2.png' | relative_url }}" alt="Example of a dialog visible when attempting to delete a user" width="778" height="440" style="width: 100%; height: auto;">
</div>

This dialog is pretty plain. 

There’s no message confirming who we’re deleting or action buttons to confirm or cancel the action. 

That’s not very helpful.

So, let’s fix this.

First, let’s open our [dialog.component.ts](https://stackblitz.com/edit/stackblitz-starters-qfteae9t?file=src%2Fdialog%2Fdialog.component.ts){:target="_blank"} to see what we’re working with.

Here, you can see we’ve already got a "username" input, and it’s required so we can be sure that it’s properly getting passed to this component:

```typescript
export class DialogComponent {
  username = input.required<string>();
}
```

Now let’s look at [the template](https://stackblitz.com/edit/stackblitz-starters-qfteae9t?file=src%2Fdialog%2Fdialog.component.html){:target="_blank"}.

This component is pretty simple but, within the template, we have an `app-dialog-content` component:

```html
<div class="overlay">
  <div class="dialog">
    <h2>Confirm Deletion</h2>
    <app-dialog-content></app-dialog-content>
  </div>
</div>
```


This component is where we'll want to add the new message for the dialog.

Here's the existing [TypeScript](https://stackblitz.com/edit/stackblitz-starters-qfteae9t?file=src%2Fdialog-content%2Fdialog-content.component.ts){:target="_blank"} for this component:

```typescript
import { ChangeDetectionStrategy, Component } from '@angular/core';

@Component({
  selector: 'app-dialog-content',
  templateUrl: './dialog-content.component.html',
  styleUrl: './dialog-content.component.scss',
  changeDetection: ChangeDetectionStrategy.OnPush,
})
export class DialogContentComponent {
}
```

This particular component will always be rendered within the context of the [dialog component](https://stackblitz.com/edit/stackblitz-starters-qfteae9t?file=src%2Fdialog%2Fdialog.component.ts){:target="_blank"}.

We can rely on that relationship to exist, ALWAYS.

What we need to do here is get access to the "username" [input](https://angular.dev/api/core/input){:target="_blank"} property from the parent [dialog component](https://stackblitz.com/edit/stackblitz-starters-qfteae9t?file=src%2Fdialog%2Fdialog.component.ts){:target="_blank"}.

Now, normally I’d do this with a simple [input](https://angular.dev/api/core/input){:target="_blank"}, but for the purposes of this example, we’re going to communicate a little differently.

## Accessing Parent Component State with `inject()`

Instead of passing "username" down as an [input](https://angular.dev/api/core/input){:target="_blank"}, we’re going to inject the [dialog component](https://stackblitz.com/edit/stackblitz-starters-qfteae9t?file=src%2Fdialog%2Fdialog.component.ts){:target="_blank"} directly.

To do this, let’s create a new property called "dialog".

Then, we’ll use the [inject()](https://angular.dev/api/core/inject){:target="_blank"} function to inject our parent [dialog component](https://stackblitz.com/edit/stackblitz-starters-qfteae9t?file=src%2Fdialog%2Fdialog.component.ts){:target="_blank"}:

```typescript
import { ..., inject } from '@angular/core';
import { DialogComponent } from '../dialog/dialog.component';

export class DialogContentComponent {
  ...
  private dialog = inject(DialogComponent);
}
```

This function offers an alternative to constructor-based [dependency injection](https://angular.dev/guide/di/dependency-injection){:target="_blank"}.

So now, we’ll have access to the parent [dialog component](https://stackblitz.com/edit/stackblitz-starters-qfteae9t?file=src%2Fdialog%2Fdialog.component.ts){:target="_blank"} instance.

So, let’s create a new property called "username".

Then, we’ll make this a [computed signal](https://angular.dev/guide/signals#computed-signals){:target="_blank"} and we’ll set its value using the "username" [signal](https://angular.dev/guide/signals){:target="_blank"} from the dialog component:

```typescript
import { ..., computed } from '@angular/core';

export class DialogContentComponent {
  ...
  protected username = computed(() => this.dialog.username());
}
```

Now, we’ve got access to the dialog’s "username" property, and it’s fully reactive thanks to [signals](https://angular.dev/guide/signals){:target="_blank"}.

### Displaying Dialog Data from Context

Let’s switch to [the template](https://stackblitz.com/edit/stackblitz-starters-qfteae9t?file=src%2Fdialog-content%2Fdialog-content.component.html){:target="_blank"} and add a message using this "username" property.

We can add a simple paragraph with a message that includes the [string-interpolated](https://angular.dev/guide/templates/binding#render-dynamic-text-with-text-interpolation){:target="_blank"} value of our "username" property from the parent component:

```html
<p>Are you sure you want to delete <strong>{% raw %}{{ username() }}{% endraw %}</strong>?</p>
```

Okay, that’s it. Let’s save and see how this looks now:

<div>
<img src="{{ '/assets/img/content/uploads/2025/05-15/demo-3.gif' | relative_url }}" alt="Example of the dialog content component displaying the username from the parent dialog component when deleting a user" width="778" height="872" style="width: 100%; height: auto;">
</div>

And there it is! Now we have a personalized message.

We didn’t need inputs or a [service](https://angular.dev/guide/di/creating-injectable-service){:target="_blank"}, we just used component injection.

But like I said, since this is only a single level of nesting, I’d probably just use an [input](https://angular.dev/api/core/input){:target="_blank"} here in real life.

But this approach shines when you need to bridge more than one component level.

Where this really comes in handy is when the components will often be used together but they’ll be nested several levels away from each other.

## Injecting a Grandparent Component Without a Service

What we want to do now is add two buttons to the dialog content component: “cancel” and “agree”.

Clicking “cancel” should just close the dialog.

Clicking “agree” should also close the dialog, but it should additionally delete the user.

Let’s look at the [dialog component](https://stackblitz.com/edit/stackblitz-starters-qfteae9t?file=src%2Fdialog%2Fdialog.component.ts){:target="_blank"} one more time.

Here, we have a "close" method:

```typescript
export class DialogComponent {
  ...
  close(confirm = false) {
    this.onClose.emit();
    this.closed.set(true);

    if (confirm) {
      this.onConfirm.emit();
    }
  }
}
```

It handles both scenarios, it updates the internal "closed" state and emits events that it has closed and if it's a confirm action.

So, we want to add some buttons inside the [dialog content component](https://stackblitz.com/edit/stackblitz-starters-qfteae9t?file=src%2Fdialog-content%2Fdialog-content.component.html){:target="_blank"}, and they’ll need to call this method.

Let’s open [the template](https://stackblitz.com/edit/stackblitz-starters-qfteae9t?file=src%2Fdialog-content%2Fdialog-content.component.html){:target="_blank"} for this component.

First, we need to add some buttons.

But not just any buttons.

In this app we have a special [action button component](https://stackblitz.com/edit/stackblitz-starters-qfteae9t?file=src%2Faction-button%2Faction-button.component.ts){:target="_blank"}, so let’s add one of these for our “cancel” button.

This component has an input for the label, so let’s pass it a label of “Cancel”:

```html
<app-action-button label="Cancel"></app-action-button>
```

Now let’s add another button.

This one will get a label of “Agree”.

Also, there is an [input](https://angular.dev/api/core/input){:target="_blank"} on this component for whether it’s a “confirm” action or not, so let’s set it to true:

```html
<app-action-button label="cancel"></app-action-button>
<app-action-button label="Agree" [isConfirm]="true"></app-action-button>
```

Now we just need to switch to the [TypeScript](https://stackblitz.com/edit/stackblitz-starters-qfteae9t?file=src%2Fdialog-content%2Fdialog-content.component.ts){:target="_blank"} and import this component:

```typescript
import { ActionButtonComponent } from '../action-button/action-button.component';

@Component({
  selector: 'app-dialog-content',
  ...,
  imports: [ActionButtonComponent],
})
```

### Making Our Action Button Smarter

Next, we need to make a change to the [action button component](https://stackblitz.com/edit/stackblitz-starters-qfteae9t?file=src%2Faction-button%2Faction-button.component.ts){:target="_blank"}.

Here’s where the magic happens.

Let’s create a new property called "dialog" and again, we’ll use the [inject()](https://angular.dev/api/core/inject){:target="_blank"} function to inject the [dialog component](https://stackblitz.com/edit/stackblitz-starters-qfteae9t?file=src%2Fdialog%2Fdialog.component.ts){:target="_blank"}.

```typescript
import { ..., inject } from '@angular/core';
import { DialogComponent } from '../dialog/dialog.component';

export class ActionButtonComponent {
  ...
  private dialog = inject(DialogComponent);
}
```

This might seem surprising at first because this [action button component](https://stackblitz.com/edit/stackblitz-starters-qfteae9t?file=src%2Faction-button%2Faction-button.component.ts){:target="_blank"} is nested multiple levels of components under the [dialog component](https://stackblitz.com/edit/stackblitz-starters-qfteae9t?file=src%2Fdialog-content%2Fdialog-content.component.ts){:target="_blank"}, yet we can still access it.

This works because [Angular's DI system](https://angular.dev/guide/di/dependency-injection){:target="_blank"} walks up the injector tree, allowing us to access ancestors as long as they’re in the component hierarchy.

So now, we can modify our "handleClick()" method and simply use this property to call the "close()" method on the [dialog component](https://stackblitz.com/edit/stackblitz-starters-qfteae9t?file=src%2Fdialog-content%2Fdialog-content.component.ts){:target="_blank"}, passing it our "isConfirm" property:

```typescript
protected handleClick() {
  this.dialog.close(this.isConfirm());
}
```

Now, you may be asking yourself the question... 

> “why not a [service](https://angular.dev/guide/di/creating-injectable-service){:target="_blank"}?”

That’s a great question!

A [service](https://angular.dev/guide/di/creating-injectable-service){:target="_blank"} is more for decoupled communication, and in this case, this [action button component](https://stackblitz.com/edit/stackblitz-starters-qfteae9t?file=src%2Faction-button%2Faction-button.component.ts){:target="_blank"} is often used within a [dialog component](https://stackblitz.com/edit/stackblitz-starters-qfteae9t?file=src%2Fdialog-content%2Fdialog-content.component.ts){:target="_blank"}, so the more global [service](https://angular.dev/guide/di/creating-injectable-service){:target="_blank"} concept isn’t really necessary.

Could you use a [service](https://angular.dev/guide/di/creating-injectable-service){:target="_blank"}? Sure. 

But do you have to? Definitely not.

Okay, now let’s save and see how this all works:

<div>
<img src="{{ '/assets/img/content/uploads/2025/05-15/demo-4.gif' | relative_url }}" alt="Example of the dialog content component with action buttons that properly close the dialog when clicked by injecting the parent dialog component" width="780" height="936" style="width: 100%; height: auto;">
</div>

Nice, now when we click to delete a user, we have some action buttons. 

When we click “Cancel”, the dialog properly closes without deleting the user.

Then, when we try again, and click the "Agree" button, we can see the dialog closes and the user gets deleted.

Pretty cool, right? 

Just like that, our dialog is interactive!

And we didn’t need a [service](https://angular.dev/guide/di/creating-injectable-service){:target="_blank"} to communicate across multiple levels of components.

## Handling Optional Injection Gracefully

What if we need to use this [action button component](https://stackblitz.com/edit/stackblitz-starters-qfteae9t?file=src%2Faction-button%2Faction-button.component.ts){:target="_blank"} outside of the [dialog component](https://stackblitz.com/edit/stackblitz-starters-qfteae9t?file=src%2Fdialog-content%2Fdialog-content.component.ts){:target="_blank"}?

For example, what if we want to add a button to save the changes made to the user list?

<div>
<img src="{{ '/assets/img/content/uploads/2025/05-15/demo-5.png' | relative_url }}" alt="Mock up pointing out where we'd like to add a save button for the user manangment list" width="824" height="936" style="width: 100%; height: auto;">
</div>

Can we still do this?

Well, let’s try it.

Let’s open up the code for the [root app component](https://stackblitz.com/edit/stackblitz-starters-qfteae9t?file=src%2Fmain.ts){:target="_blank"} where this list lives and where we want to add this "save" button.

Now, let’s add the [action button component](https://stackblitz.com/edit/stackblitz-starters-qfteae9t?file=src%2Faction-button%2Faction-button.component.ts){:target="_blank"} to the imports array so that we can use it:

```typescript
import { ActionButtonComponent } from './action-button/action-button.component';

@Component({
  selector: 'app-root',
  ...,
  imports: [..., ActionButtonComponent],
})
```

Then, let’s add a "saved" [signal](https://angular.dev/guide/signals){:target="_blank"} to track the saved state after clicking the new button:

```typescript
import { ..., signal } from '@angular/core';

export class App {
  ...
  protected saved = signal(false);
}
```

Next, we need to add a method to handle the click event on our new save button, let’s call it "usersSaved()".

Within this method, let’s first set our "saved" [signal](https://angular.dev/guide/signals){:target="_blank"} to true.

Then, we’ll simulate a save delay using [setTimeout()](https://developer.mozilla.org/en-US/docs/Web/API/setTimeout){:target="_blank"}, and then set it back to false:

```typescript
export class App {
  ...
  protected usersSaved() {
    this.saved.set(true);
    setTimeout(() => this.saved.set(false), 3000);
  }
}
```

Now our “saved” state will change for three seconds when we click the new button.

Okay, now let’s switch and add a "save" button in [the template](https://stackblitz.com/edit/stackblitz-starters-qfteae9t?file=src%2Fmain.component.html){:target="_blank"}.

First, let’s add a new [action button](https://stackblitz.com/edit/stackblitz-starters-qfteae9t?file=src%2Faction-button%2Faction-button.component.ts){:target="_blank"}.

Let’s give it a label of “Save Users”.

Let’s also set "isConfirm" to true to make it a confirmation button.

Next, we can use the "onClick" [output](https://angular.dev/api/core/Output){:target="_blank"} to call our new "usersSaved()" method:

```html
<app-action-button 
  label="Save Users" 
  [isConfirm]="true" 
  (onClick)="usersSaved()">
</app-action-button>
```

Ok, that’s all we need for the button, but I want to provide some feedback related to the "saved" state.

So let’s add a little message too:

```html
@if (saved()) {
  <div class="saved">Your users have been saved!</div>
}
```

Ok, that should be everything, let’s save and see what happens:

<div>
<img src="{{ '/assets/img/content/uploads/2025/05-15/demo-6.png' | relative_url }}" alt="Example of the action button component used without the required parent dialog component causing an error" width="770" height="414" style="width: 100%; height: auto;">
</div>

Uh oh, looks like we have an error.

Let’s inspect to see what’s going on:

<div>
<img src="{{ '/assets/img/content/uploads/2025/05-15/demo-7.png' | relative_url }}" alt="Showing Chrome Developer Tools console with the error 'No provider for _DialogComponent!' when using the action button component outside of the dialog component" width="1194" height="444" style="width: 100%; height: auto;">
</div>

Okay, there it is: “No provider for _DialogComponent!”.

Why? Because the [action button component](https://stackblitz.com/edit/stackblitz-starters-qfteae9t?file=src%2Faction-button%2Faction-button.component.ts){:target="_blank"} is trying to inject the [dialog component](https://stackblitz.com/edit/stackblitz-starters-qfteae9t?file=src%2Fdialog-content%2Fdialog-content.component.ts){:target="_blank"}, and we’re not inside one.

Let’s fix this.

Back over in the [action button component](https://stackblitz.com/edit/stackblitz-starters-qfteae9t?file=src%2Faction-button%2Faction-button.component.ts){:target="_blank"}, we need to make the injected [dialog component](https://stackblitz.com/edit/stackblitz-starters-qfteae9t?file=src%2Fdialog-content%2Fdialog-content.component.ts){:target="_blank"} optional with the "optional" parameter:

```typescript
private dialog = inject(DialogComponent, { optional: true });
```

Then, we just need to use the [optional chaining operator](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Operators/Optional_chaining){:target="_blank"} in the "handleClick()" method to prevent errors when it doesn’t exist:

**Before:**
```typescript
this.dialog.close(this.isConfirm());
```

**After:**
```typescript
this.dialog?.close(this.isConfirm());
```

Now let’s save and try again:

<div>
<img src="{{ '/assets/img/content/uploads/2025/05-15/demo-8.gif' | relative_url }}" alt="Example of the action button component used without the parent dialog component after making the injection optional" width="776" height="1076" style="width: 100%; height: auto;">
</div>

Now it works beautifully, no error, no [dialog](https://stackblitz.com/edit/stackblitz-starters-qfteae9t?file=src%2Fdialog-content%2Fdialog-content.component.ts){:target="_blank"} needed, and we see the message for three seconds after saving.

So now it’s context-aware when inside a [dialog](https://stackblitz.com/edit/stackblitz-starters-qfteae9t?file=src%2Fdialog-content%2Fdialog-content.component.ts){:target="_blank"}, and still functional outside.

**Pro tip:** always use `{ optional: true }` when your component might be reused outside of its expected context.

## Wrap-Up: When to Inject Components (and When Not To)

So, here’s what we learned today…

You can [inject](https://angular.dev/api/core/inject){:target="_blank"} a parent or grandparent component instead of using a [service](https://angular.dev/guide/di/creating-injectable-service){:target="_blank"}, as long as the component hierarchy is stable.

This works great for tightly coupled components like a dialog component and action buttons.

By using optional injection, you make your component flexible, it works with or without a specific context.

Avoid injecting parent components when your components aren’t tightly coupled. 

In those cases, a shared [service](https://angular.dev/guide/di/creating-injectable-service){:target="_blank"} is still the better choice.

If you found this helpful, don't forget to [subscribe](https://www.youtube.com/c/briantreese?sub_confirmation=1) and check out [my other Angular tutorials](https://www.youtube.com/@briantreese) for more tips and tricks!

{% include banner-ad.html %}

## Additional Resources

- [Angular inject() API](https://angular.dev/api/core/inject)
- [Optional Dependencies](https://angular.dev/api/core/InjectOptions)
- [Signals in Angular](https://angular.dev/guide/signals)
- [My course: “Styling Angular Applications”](https://app.pluralsight.com/library/courses/angular-styling-applications/table-of-contents)

## Want to See It in Action?

Check out the demo on StackBlitz below to explore component injection in action.

<iframe src="https://stackblitz.com/edit/stackblitz-starters-g6cbsixx?ctl=1&embed=1&file=src%2Faction-button%2Faction-button.component.ts" style="height: 500px; width: 100%; margin-bottom: 1.5em; display: block;"></iframe>
