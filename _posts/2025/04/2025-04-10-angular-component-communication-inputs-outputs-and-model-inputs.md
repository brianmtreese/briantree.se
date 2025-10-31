---
layout: post
title: "How Angular Components Should Communicate in 2025"
date: "2025-04-10"
video_id: "fTejxZ6W-90"
tags:
  - "Angular"
  - "Angular Components"
  - "Angular Input"
  - "Angular Output"
  - "Angular Model"
---

<p class="intro"><span class="dropcap">E</span>ver wondered how Angular components actually talk to each other? Maybe you’ve been juggling <a href="https://angular.dev/guide/components/inputs">inputs</a> and <a href="https://angular.dev/guide/components/outputs">outputs</a>... or maybe you’ve heard whispers about this mysterious new <a href="https://angular.dev/guide/components/inputs#model-inputs">model input</a>. Well, in this tutorial, we're going to break it all down. We’ll start with a barebones component and add real-time communication between a parent and child — first with <a href="https://angular.dev/guide/components/inputs">inputs</a> and <a href="https://angular.dev/guide/components/outputs">outputs</a>, then with the newer <a href="https://angular.dev/guide/components/inputs#model-inputs">model input</a> approach.</p>

{% include youtube-embed.html %}

## Setting the Stage: The Starter Code

Here’s the [super simple Angular app](https://stackblitz.com/edit/stackblitz-starters-qrp3fjyn?file=src%2Fusername-field%2Fusername-field.component.ts) that we’ll be working with in this example:

<div>
<img src="{{ '/assets/img/content/uploads/2025/04-10/demo-1.png' | relative_url }}" alt="A simple Angular app with a username field component and a parent app component" width="960" height="456" style="width: 100%; height: auto;">
</div>

It’s just a component that will eventually let us type in a username and reflect that value in both the [parent](https://stackblitz.com/edit/stackblitz-starters-qrp3fjyn?file=src%2Fmain.ts) and [child](https://stackblitz.com/edit/stackblitz-starters-qrp3fjyn?file=src%2Fusername-field%2Fusername-field.component.ts) components.

Let’s start by looking at [the existing code](https://stackblitz.com/edit/stackblitz-starters-qrp3fjyn?file=src%2Fusername-field%2Fusername-field.component.ts) for this component:

```typescript
import { ChangeDetectionStrategy, Component } from "@angular/core";

@Component({
  selector: "app-username-field",
  templateUrl: "./username-field.component.html",
  styleUrl: "./username-field.component.scss",
  changeDetection: ChangeDetectionStrategy.OnPush,
})
export class UsernameFieldComponent {}
```

Right now, it’s just a plain shell component — no [inputs](https://angular.dev/guide/components/inputs), no [outputs](https://angular.dev/guide/components/outputs), no internal state — just an empty class ready to go.

Now, let’s switch and look at the [root app component](https://stackblitz.com/edit/stackblitz-starters-qrp3fjyn?file=src%2Fmain.ts) where this username-field component is included:

```typescript
import { ChangeDetectionStrategy, Component } from "@angular/core";
import { bootstrapApplication } from "@angular/platform-browser";
import { UsernameFieldComponent } from "./username-field/username-field.component";

@Component({
  selector: "app-root",
  template: ` <app-username-field></app-username-field> `,
  imports: [UsernameFieldComponent],
  changeDetection: ChangeDetectionStrategy.OnPush,
})
export class App {}
```

This component doesn’t have any [signals](https://angular.dev/guide/signals) or [bindings](https://angular.dev/guide/templates/binding#binding-dynamic-properties-and-attributes) yet.

We’ve got the `<app-username-field>` component in place, but there’s nothing being passed into it or coming out of it yet.

So, let’s wire up a basic communication flow — starting with component [inputs](https://angular.dev/guide/components/inputs) and [outputs](https://angular.dev/guide/components/outputs).

## Building Parent-Child Communication with input() and output()

[Inputs](https://angular.dev/guide/components/inputs) allow data to flow into a child component from a parent, and [outputs](https://angular.dev/guide/components/outputs) flow data from the child component back up to the parent.

For this example, we’ll be using the [input()](https://angular.dev/api/core/input) and [output()](https://angular.dev/api/core/output) functions from Angular — these are the new functional equivalents of the classic decorators.

### Wiring Up the Child Component

First, let’s define a "username" property.

This property will be a [signal input](https://angular.dev/api/core/input) with a default value of an empty string:

```typescript
import { ..., input } from "@angular/core";

...

export class UsernameFieldComponent {
  username = input("");
}
```

This will allow the parent to pass a value down into this component.

Next, let’s create another property named "usernameChange".

This property will be an [output](https://angular.dev/api/core/output), and it will emit a string value:

```typescript
import { ..., output } from "@angular/core";

...

export class UsernameFieldComponent {
  ...
  usernameChange = output<string>();
}
```

This component will use this [output](https://angular.dev/api/core/output) to send updates back to the parent.

Next, we need to add a function to handle [input events](https://developer.mozilla.org/en-US/docs/Web/API/Element/input_event) from our textbox.

This function will be called when the value entered into the textbox changes.

Let’s call it "onInput", and it will take in an [Event](https://developer.mozilla.org/en-US/docs/Web/API/Event) parameter.

We’ll use this event to get the current value of the textbox.

Once we have the value, we emit it to the parent with the [output](https://angular.dev/api/core/output) by simply passing it to the `emit()` method:

```typescript
export class UsernameFieldComponent {
  ...
  onInput(event: Event) {
    const value = (event.target as HTMLInputElement).value;
    this.usernameChange.emit(value);
  }
}
```

Okay, I think that’s everything we need here — let’s switch to [the template](https://stackblitz.com/edit/stackblitz-starters-qrp3fjyn?file=src%2Fusername-field%2Fusername-field.component.html) and bind that logic to our [input element](https://developer.mozilla.org/en-US/docs/Web/HTML/Element/input).

Let’s start by using [property binding](https://angular.dev/guide/templates/binding#binding-dynamic-properties-and-attributes) to bind the "username" [input](https://angular.dev/api/core/input) to the value property on our [input element](https://developer.mozilla.org/en-US/docs/Web/HTML/Element/input):

```html
<input type="text" [value]="username()" />
```

This sets the textbox input’s value to whatever the parent passes in via the "username" [input](https://angular.dev/api/core/input).

Next, we’ll use the [input event](https://angular.dev/guide/templates/event-listeners) to call our "onInput()" function:

```html
<input type="text" [value]="username()" (input)="onInput($event)" />
```

So now, whenever the user types in the textbox, we’ll emit the value back to the parent.

### Binding the Parent Component

Okay, that should be everything we need to add to this component, so let’s switch to the [root component](https://stackblitz.com/edit/stackblitz-starters-qrp3fjyn?file=src%2Fmain.ts).

Here, let’s define a [signal](https://angular.dev/guide/signals) to hold the username.

I’ll call it "username", and I’ll set the initial value to "Brian":

```typescript
import { ..., signal } from '@angular/core';
...
export class App {
    protected username = signal('Brian');
}
```

Now we’ll bind this [signal](https://angular.dev/guide/signals) to the child component’s "username" [input](https://angular.dev/api/core/input):

```html
<app-username-field [username]="username()" />
```

This means the initial value we’ll see in the input should now be “Brian”.

And now, we can use our new custom "usernameChange" event to update the value of this "username" [signal](https://angular.dev/guide/signals):

```html
<app-username-field
  [username]="username()"
  (usernameChange)="username.set($event)"
/>
```

Also, just to make all of this more clear in the example, let’s show the current value in the parent component template below the `<app-username-field>` component:

```html
<p>Hello, {% raw %}{{ username() }}{% endraw %}!</p>
```

Alright, let’s save and try this all out:

<div>
<img src="{{ '/assets/img/content/uploads/2025/04-10/demo-2.gif' | relative_url }}" alt="An example of the parent and child components syncing their values with inputs and outputs" width="786" height="410" style="width: 100%; height: auto;">
</div>

Nice, the initial value “Brian” shows up in both the parent and child components and when I type something else… look at that!

The child sends the new value back to the parent, and both stay in sync.

Pretty cool, right?

These two components are now communicating back and forth with each other and updating values as needed.

But what if I told you all of this could be further simplified and written more elegantly?

## Refactoring with model() for Cleaner Code Using Two-Way Binding

The [input()](https://angular.dev/api/core/input) and [output()](https://angular.dev/api/core/output) concept worked great, and if we were only using one or the other, I’d probably leave it as is.

But we can clean this particular example up using Angular’s new [model()](https://angular.dev/guide/components/inputs#model-inputs) input.

This allows us to leverage [two-way binding](https://angular.dev/guide/templates/two-way-binding) with less code overall.

### Cleaning it Up with model()

First, let’s switch back to the [username-field.component.ts](https://stackblitz.com/edit/stackblitz-starters-qrp3fjyn?file=src%2Fusername-field%2Fusername-field.component.ts).

I can remove the [output](https://angular.dev/api/core/output) because we won’t need it anymore.

Next, I’ll change the [input](https://angular.dev/api/core/input) over to a [model()](https://angular.dev/guide/components/inputs#model-inputs) input instead:

```typescript
import { ..., model } from "@angular/core";

...

export class UsernameFieldComponent {
  username = model("");
  ...
}
```

This special type of input gives us a [signal](https://angular.dev/guide/signals) that allows us to propagate values back to the parent component — eliminating the need for a separate [input](https://angular.dev/api/core/input) and [output](https://angular.dev/api/core/output).

Okay, now that we’re working with a [signal](https://angular.dev/guide/signals), we need to set the value in our "onInput()" function.

Instead of emitting, we just update the [signal](https://angular.dev/guide/signals) directly:

#### Before:

```typescript
export class UsernameFieldComponent {
  ...
  onInput(event: Event) {
    ...
    this.usernameChange.emit(value);
  }
}
```

#### After:

```typescript
export class UsernameFieldComponent {
  ...
  onInput(event: Event) {
    ...
    this.username.set(value);
  }
}
```

Okay, that’s all we need to do here, let’s switch back over to [the root component](https://stackblitz.com/edit/stackblitz-starters-qrp3fjyn?file=src%2Fmain.ts).

The first thing I’m going to do is remove the "usernameChange" event binding since the child doesn’t emit this event anymore.

Then we can use Angular’s built-in [two-way binding syntax](https://angular.dev/guide/templates/two-way-binding), often referred to as “banana-in-a-box”, because of the parentheses inside of the square brackets:

```html
<app-username-field [(username)]="username" /></app-username-field>
```

This connects the parent’s [signal](https://angular.dev/guide/signals) directly to the child’s [model](https://angular.dev/guide/components/inputs#model-inputs) input.

Updates will now flow both ways automatically, from the parent to the child, and from the child to the parent.

Let’s save and see it in action:

<div>
<img src="{{ '/assets/img/content/uploads/2025/04-10/demo-2.gif' | relative_url }}" alt="An example of the parent and child components syncing their values with a model input, a signal, and two-way binding" width="786" height="410" style="width: 100%; height: auto;">
</div>

Nice, just like the previous example, it starts with “Brian” in both the parent and the child.

And if I update the value, it's still in sync.

But now the code is simplified, and just as powerful.

## Wrapping Up: Cleaner Code, Better Communication

So there you have it, we started with the traditional [input()](https://angular.dev/api/core/input) and [output()](https://angular.dev/api/core/output) setup for component communication, then refactored it into something leaner and cleaner using the new [model()](https://angular.dev/guide/components/inputs#model-inputs) input.

With just a few small changes, we made our code easier to follow and let Angular do more of the heavy lifting for us.

If you found this helpful, don't forget to [subscribe](https://www.youtube.com/c/briantreese?sub_confirmation=1) and check out [my other Angular tutorials](https://www.youtube.com/@briantreese) for more tips and tricks!

{% include banner-ad.html %}

## Additional Resources

- [The demo app BEFORE any changes](https://stackblitz.com/edit/stackblitz-starters-qrp3fjyn?file=src%2Fusername-field%2Fusername-field.component.ts)
- [The demo app AFTER making changes](https://stackblitz.com/edit/stackblitz-starters-gdbsfbj5?file=src%2Fusername-field%2Fusername-field.component.ts)
- [Accepting Data with Input Properties](https://angular.dev/guide/components/inputs)
- [Custom Events with Outputs](https://angular.dev/guide/components/outputs)
- [Model Inputs Official Docs](https://angular.dev/guide/components/inputs#model-inputs)
- [My course: “Styling Angular Applications”](https://app.pluralsight.com/library/courses/angular-styling-applications/table-of-contents)

## Want to See It in Action?

Check out the demo code showcasing these techniques in the StackBlitz project below. If you have any questions or thoughts, don’t hesitate to leave a comment.

<iframe src="https://stackblitz.com/edit/stackblitz-starters-gdbsfbj5?ctl=1&embed=1&file=src%2Fusername-field%2Fusername-field.component.ts" style="height: 500px; width: 100%; margin-bottom: 1.5em; display: block;"></iframe>
