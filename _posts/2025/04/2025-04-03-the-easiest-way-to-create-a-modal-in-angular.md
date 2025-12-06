---
layout: post
title: "The Easiest Way to Add a Modal in Angular"
date: "2025-04-03"
video_id: "Tsy28T38KtY"
tags:
  - "Angular"
  - "Angular CDK"
  - "Angular Components"
  - "Angular Forms"
  - "Angular Material"
  - "Angular Styles"
  - "CDK Overlay"
---

<p class="intro"><span class="dropcap">B</span>uilding modals in Angular often requires third-party libraries or complex overlay code, but the Angular CDK Dialog provides a native, lightweight solution that handles positioning, focus management, and backdrop behavior automatically. This tutorial demonstrates how to create modals using the CDK Dialog service, open any component as a modal, customize styling, and add custom behavior without external dependencies. You'll learn the simplest way to add professional modals to your Angular applications.</p>

{% include youtube-embed.html %}

## Install the Angular CDK: The First Step to Easy Modals

Since we’ll be using the [Angular CDK](https://material.angular.io/cdk/categories) for this example, you’ll want to make sure it’s installed before doing anything else.

I’ve already installed it in [the demo project](https://stackblitz.com/edit/stackblitz-starters-qthj32pz?file=src%2Fhome%2Fhome.component.ts) for this tutorial, but if you’re starting from scratch, just run this command:

```bash
npm install @angular/cdk
```

Once that’s done, we’re ready to use the [Dialog service](https://material.angular.io/cdk/dialog/overview) to create a modal.

## Build Your First Angular Modal with the CDK Dialog

In [this example](https://stackblitz.com/edit/stackblitz-starters-qthj32pz?file=src%2Fhome%2Fhome.component.ts), we’ve got a simple button on the page:

<div>
<img src="{{ '/assets/img/content/uploads/2025/04-03/demo-1.png' | relative_url }}" alt="A screenshot of a simple button in an Angular app" width="1058" height="426" style="width: 100%; height: auto;">
</div>

When a user clicks this button, we want to open the [sign-up form component](https://stackblitz.com/edit/stackblitz-starters-qthj32pz?file=src%2Fsign-up-form%2Fsign-up-form.component.ts) inside a modal that sits on top of everything else on the page.

Now, because this is an Angular app, and everything’s broken up into components, this might seem tricky at first.

But thanks to the Angular team, it’s actually really straightforward.

To start, the first step is to inject the [Dialog service](https://material.angular.io/cdk/dialog/overview) in the [home component](https://stackblitz.com/edit/stackblitz-starters-qthj32pz?file=src%2Fhome%2Fhome.component.ts) where the button lives, so let’s add a new property called “dialog”.

Then we’ll use the [inject()](https://angular.dev/api/core/Inject) function to inject the [CDK Dialog service](https://material.angular.io/cdk/dialog/overview):

```typescript
import { ..., inject } from "@angular/core";
import { Dialog } from "@angular/cdk/dialog";

export class HomeComponent {
  private dialog = inject(Dialog);
}
```

Okay, now that it’s injected, let’s create a function to open our modal, we’ll call it “openModal()”.

Within this function, we simply need to call the `open()` method from the [Dialog service](https://material.angular.io/cdk/dialog/overview), then we need to pass the component that we want to "modalize", so let’s add our [sign-up form component](https://stackblitz.com/edit/stackblitz-starters-qthj32pz?file=src%2Fsign-up-form%2Fsign-up-form.component.ts):

```typescript
import { SignUpFormComponent } from '../sign-up-form/sign-up-form.component';

export class HomeComponent {
  ...
  openModal() {
    this.dialog.open(SignUpFormComponent);
  }
}
```

And that’s it! That’s all it takes to open a component in a modal.

Now we just need to wire it up to the button click.

So, let’s switch over to the [component template](https://stackblitz.com/edit/stackblitz-starters-qthj32pz?file=src%2Fhome%2Fhome.component.html) and add a [click event](https://angular.dev/guide/templates/event-listeners) on the button where we’ll call our new “openModal()” function:

```html
<button (click)="openModal()">...</button>
```

Pretty simple, right?

Let’s save and try it out:

<div>
<img src="{{ '/assets/img/content/uploads/2025/04-03/demo-2.gif' | relative_url }}" alt="An example of a basic modal in an Angular app using the CDK Dialog service" width="788" height="796" style="width: 100%; height: auto;">
</div>

Okay, so the modal opens!

But… it doesn’t look much like a modal.

There are some very basic overlay styles included with the [CDK Dialog](https://material.angular.io/cdk/dialog/overview), but our sign up form is just floating here and it’s pretty difficult to see.

We’ll need to add more CSS to make it look more like a traditional modal.

## Style Your Modal: From Bare Bones to Beautiful

If we inspect the DOM, you can see that the CDK has injected some overlay containers near the end of the body, and within all this markup, our [sign-up form component](https://stackblitz.com/edit/stackblitz-starters-qthj32pz?file=src%2Fsign-up-form%2Fsign-up-form.component.ts) is injected right in the middle of it:

<div>
<img src="{{ '/assets/img/content/uploads/2025/04-03/demo-3.png' | relative_url }}" alt="An example of the markup injected by the CDK Dialog service" width="1288" height="772" style="width: 100%; height: auto;">
</div>

This is pretty cool because the button that opened this is up above in the [root component](https://stackblitz.com/edit/stackblitz-starters-qthj32pz?file=src%2Fmain.ts) and then within the markup for the [home component](https://stackblitz.com/edit/stackblitz-starters-qthj32pz?file=src%2Fhome%2Fhome.component.html):

<div>
<img src="{{ '/assets/img/content/uploads/2025/04-03/demo-4.png' | relative_url }}" alt="Pointing out the location of the button that opens the modal in the DOM" width="1050" height="792" style="width: 100%; height: auto;">
</div>

So now that the code works, we just need to add some styles.

We’ll apply some container styles directly to the host element of the [sign-up form component](https://stackblitz.com/edit/stackblitz-starters-qthj32pz?file=src%2Fsign-up-form%2Fsign-up-form.component.ts).

But here’s the trick, we’ll only apply these styles when the component is inside a `cdk-dialog-container` since this form could be used outside of the dialog where we wouldn’t want these styles to apply, so we’ll use [host-context](https://youtu.be/qHge5-9zm2M) instead of [host](https://youtu.be/qHge5-9zm2M) for this:

```css
:host-context(cdk-dialog-container) {
  display: block;
  border-radius: 0.375em;
  background-color: white;
  filter: drop-shadow(0 0 2em rgba(black, 0.5));
  padding: 0 2em 2em;
}
```

Okay, let’s try this again:

<div>
<img src="{{ '/assets/img/content/uploads/2025/04-03/demo-5.gif' | relative_url }}" alt="An example of modal container styles applied to a modal in an Angular app using the CDK Dialog service" width="790" height="958" style="width: 100%; height: auto;">
</div>

Perfect — that gives us a proper modal look and feel.

## Close the Modal the Right Way (No Accidental Clicks)

Alright, we’ve got a working modal… but how do we close it?

Well, by default, if you click anywhere on this backdrop here, the modal will close:

<div>
<img src="{{ '/assets/img/content/uploads/2025/04-03/demo-6.gif' | relative_url }}" alt="An example of the default closing behavior of a modal in an Angular app using the CDK Dialog service" width="784" height="1052" style="width: 100%; height: auto;">
</div>

That’s handy — but it can also be frustrating, especially if the user accidentally clicks outside the modal unintentionally.

Well, we can disable this functionality pretty easily.

When you open a modal with the [Dialog service](https://material.angular.io/cdk/dialog/overview), you can pass in a configuration object to customize its behavior.

So, inside the `open()` method, we’ll pass a second argument and set `disableClose` to `true`:

```typescript
this.dialog.open(SignUpFormComponent, { disableClose: true });
```

Okay, now let’s test it out:

<div>
<img src="{{ '/assets/img/content/uploads/2025/04-03/demo-7.gif' | relative_url }}" alt="A demonstration of the modal not closing  when disableClose is set to true in an Angular app using the CDK Dialog service" width="752" height="1076" style="width: 100%; height: auto;">
</div>

There, now, the backdrop is still visible, but clicking it doesn’t close the modal.

That’s great — except now, we don’t have any way to close it.

Let’s fix that by adding a custom close button to our [sign-up form component](https://stackblitz.com/edit/stackblitz-starters-qthj32pz?file=src%2Fsign-up-form%2Fsign-up-form.component.ts).

First, we’ll inject the [DialogRef](https://material.angular.io/cdk/dialog/api#DialogRef) so we can get a reference to the currently opened dialog.

We’ll call the property “dialogRef”, and again use the [inject() function](https://angular.dev/api/core/inject).

Since this component might also be used outside of a modal, we’ll mark this injection as optional:

```typescript
import { ..., inject } from "@angular/core";
import { DialogRef } from '@angular/cdk/dialog';

export class SignUpFormComponent {
  ...
  protected dialogRef = inject(DialogRef, { optional: true });
}
```

Okay, now let’s create a “closeModal()” method.

Inside this method, we’ll call the [DialogRef](https://material.angular.io/cdk/dialog/api#DialogRef) `close()` method to safely close the modal if the reference exists:

```typescript
export class SignUpFormComponent {
  ...
  protected closeModal() {
    this.dialogRef?.close();
  }
}
```

Okay, that should be everything we need here.

Now let’s wire this up in [the template](https://stackblitz.com/edit/stackblitz-starters-qthj32pz?file=src%2Fsign-up-form%2Fsign-up-form.component.html).

First, we need to add a [button](https://developer.mozilla.org/en-US/docs/Web/HTML/Element/button), and we’ll add a “close” label.

Then, we need to add a [click event](https://angular.dev/guide/templates/event-listeners) where we can call our new “closeModal()” function:

```html
<button (click)="closeModal()">Close</button>
```

Okay, let’s save and open the modal again:

<div>
<img src="{{ '/assets/img/content/uploads/2025/04-03/demo-8.gif' | relative_url }}" alt="A demonstration using the CDK DialogRef to close a modal in an Angular app using a custom button instead of the backdrop" width="776" height="944" style="width: 100%; height: auto;">
</div>

Now, we can close it properly with a custom button!

## Wrap-Up: Angular CDK Dialog Modal Complete

So that’s it!

You just built a fully functional, customizable modal using the Angular CDK Dialog — no other external libraries, no extra dependencies.

It’s clean, it’s flexible, and it feels like it truly belongs in your Angular app.

If you found this helpful, don't forget to [subscribe](https://www.youtube.com/c/briantreese?sub_confirmation=1) and check out [my other Angular tutorials](https://www.youtube.com/@briantreese) for more tips and tricks!

{% include banner-ad.html %}

## Additional Resources

- [The demo app BEFORE any changes](https://stackblitz.com/edit/stackblitz-starters-qthj32pz?file=src%2Fhome%2Fhome.component.ts)
- [The demo app AFTER making changes](https://stackblitz.com/edit/stackblitz-starters-gq2xpyvr?file=src%2Fhome%2Fhome.component.ts)
- [Angular CDK Dialog – Official Docs](https://material.angular.io/cdk/dialog/overview)
- [Angular Inject Function - Official Docs](https://angular.dev/api/core/inject)
- [Accessibility in Modals (WAI-ARIA patterns)](https://www.w3.org/WAI/ARIA/apg/patterns/dialog-modal/)
- [My course: “Styling Angular Applications”](https://app.pluralsight.com/library/courses/angular-styling-applications/table-of-contents)

## Want to See It in Action?

Check out the demo code showcasing these techniques in the StackBlitz project below. If you have any questions or thoughts, don’t hesitate to leave a comment.

<iframe src="https://stackblitz.com/edit/stackblitz-starters-gq2xpyvr?ctl=1&embed=1&file=src%2Fhome%2Fhome.component.ts" style="height: 500px; width: 100%; margin-bottom: 1.5em; display: block;"></iframe>
