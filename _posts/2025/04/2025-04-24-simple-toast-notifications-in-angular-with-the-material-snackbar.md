---
layout: post
title: "Toast Notifications in Angular? Easier Than You Think!"
date: "2025-04-24"
video_id: "qpKUf_9Ut9k"
tags:
  - "Angular"
  - "Angular Material"
  - "Angular CDK"
  - "Angular Components"
  - "Snackbar"
---

<p class="intro"><span class="dropcap">I</span>n this tutorial, I’ll show you how to add beautiful, toast-style snackbar notifications using <a href="https://material.angular.io">Angular Material</a>. We’ll even take it a step further and trigger a full-screen help overlay from the snackbar action itself. And the best part? It’s lightweight, fully customizable, and you don’t need any third-party libraries to make it happen.</p>

<iframe width="1280" height="720" src="https://www.youtube.com/embed/qpKUf_9Ut9k" title="" frameborder="0" allow="accelerometer; autoplay; clipboard-write; encrypted-media; gyroscope; picture-in-picture; web-share" allowfullscreen></iframe>

## Install Angular Material and Set Up the Project

Now, I already have [Angular Material](https://material.angular.io) installed in this demo project, but if you're starting from scratch, you’ll want to run this command first to install it in your project:

```bash
npm install --save @angular/material
```

This gives you access to all of [Angular Material’s components](https://material.angular.io/components) — including the [snackbar service](https://material.angular.io/components/snack-bar/overview) and overlay tools we’ll be using in this video.

Okay, now that we have that installed, let’s look at [the app](https://stackblitz.com/edit/stackblitz-starters-o9xseuyp?file=src%2Fcontact-form%2Fcontact-form.component.ts) we’ll be using in this tutorial.

## Review the Basic Contact Form (Before Snackbars)

It’s just a basic contact form with name, email, and message fields, and when we click the “Send” button, nothing happens:

<div>
<img src="{{ '/assets/img/content/uploads/2025/04-25/demo-1.gif' | relative_url }}" alt="A basic Angular app with a simple contact form" width="782" height="878" style="width: 100%; height: auto;">
</div>

No success message. 

No error.

Let’s fix that.

Let’s look at the component behind that form. 

You can follow along with the code [here](https://stackblitz.com/edit/stackblitz-starters-o9xseuyp?file=src%2Fcontact-form%2Fcontact-form.component.ts).

All we’ve got is a form group defined with some simple controls and basic validators:

```typescript
export class ContactFormComponent {
  protected contactForm = new FormGroup({
    name: new FormControl<string>('', Validators.required),
    email: new FormControl<string>('', [Validators.required, Validators.email]),
    message: new FormControl<string>('', Validators.required),
  });
}
```

But if you look down near the bottom, the function responsible for handling form submission is completely empty:

```typescript
export class ContactFormComponent {
  ...

  protected submitForm() {
  }
}
```

Now let’s look at [the template](https://stackblitz.com/edit/stackblitz-starters-o9xseuyp?file=src%2Fcontact-form%2Fcontact-form.component.html).

In the HTML, we’ve got three [Angular Material form fields](https://material.angular.io/components/input/overview) and a [button](https://developer.mozilla.org/en-US/docs/Web/HTML/Reference/Elements/button) to submit the form:

```html
<h2>Contact Us</h2>
<form [formGroup]="contactForm" (ngSubmit)="submitForm()">
  <mat-form-field>
    <mat-label>Name</mat-label>
    <input matInput formControlName="name" required />
  </mat-form-field>
  <mat-form-field>
    <mat-label>Email</mat-label>
    <input
      matInput
      formControlName="email"
      required
      type="email"
      autocomplete="none"
    />
  </mat-form-field>
  <mat-form-field>
    <mat-label>Message</mat-label>
    <textarea matInput formControlName="message" rows="4"></textarea>
  </mat-form-field>
  <button mat-raised-button type="submit">Send</button>
</form>
```

This is all connected to that same empty submit function we just saw:

```typescript
<form ... (ngSubmit)="submitForm()">
  ...
</form>
```

Okay, so that’s what we’re starting with.

Let’s enhance this form with some simple toast-style notifications.

## Show Success Messages with Angular Material Snackbars

To add these types of notifications, all we need is Angular Material’s [MatSnackBar service](https://material.angular.io/components/snack-bar/overview).

So, let’s create a new field named "snackBar", and we’ll use the [inject()](https://angular.dev/api/core/inject) function to inject the [snackbar service](https://material.angular.io/components/snack-bar/overview):

```typescript
import { MatSnackBar } from '@angular/material/snack-bar';

export class ContactFormComponent {
  ...

  protected snackBar = inject(MatSnackBar);
}
```

This gives us access to a method that will trigger snackbars anywhere in the component.

Now, in our `submitForm()` method, let’s add a condition to check if the form group is valid.

If it is, we’ll open a snackbar using the service’s `open()` method.

The first thing we pass in is the message we want to display.

The next parameter is a label for the optional action button in the snackbar.

By default, this action will close the snackbar. So we’ll add a label of “Dismiss”.

```typescript
import { MatSnackBar } from '@angular/material/snack-bar';

export class ContactFormComponent {
  ...

  protected submitForm() {
    if (this.contactForm.valid) {
      this.snackBar.open('Message sent successfully!', 'Dismiss');
    }
  }
```

Now, for the third parameter, we can specify custom configuration options.

By default, snackbars stay visible until they’re dismissed, but we want this success message to disappear after a short period of time.

We can do that by adding a "duration" option. 

I’ll set it to nine seconds:

```typescript
this.snackBar.open('Message sent successfully!', 'Dismiss', {
  duration: 9000,
});
```

So, it should automatically close after nine seconds now.

Alright, the last thing we need to do is reset the form after submission, just to clear everything out:

```typescript
this.contactForm.reset();
```

Okay, that should be all we need to show a message when a valid form is submitted, so let’s save and try it out:

<div>
<img src="{{ '/assets/img/content/uploads/2025/04-25/demo-2.gif' | relative_url }}" alt="An example using the Angular Material Snackbar service to show a success message when a form is submitted" width="848" height="1078" style="width: 100%; height: auto;">
</div>

Okay, nothing looks different to start, but now, when I fill out the form and click send, the success message slides in at the bottom.

After nine seconds, it’ll close on its own.

Or we can fill out the form again, submit, and click the “Dismiss” button to close it manually.

It’s a clean and efficient solution, and remarkably simple to implement.

### Add Error Notifications for Invalid Form Submissions

Now, let’s add a message when the form is invalid as well.

I’ll add an "else" condition with a different snackbar message.

This time, I’ll use an action label of “OK”:

```typescript
export class ContactFormComponent {
  ...

  protected submitForm() {
    if (this.contactForm.valid) {
      ...
    } else {
      this.snackBar.open('Please fill in all required fields.', 'OK');
    }
  }
```

And for this message, we’ll leave it visible until it’s manually dismissed, so I’ll skip the duration config.

Alright, let’s save and see how this one works:

<div>
<img src="{{ '/assets/img/content/uploads/2025/04-25/demo-3.gif' | relative_url }}" alt="An example using the Angular Material Snackbar service to show a error message when a form is submitted" width="848" height="1078" style="width: 100%; height: auto;">
</div>

Now when we submit an incomplete form, we get an error message with an “OK” button.

And when we click that button, the message disappears.

Pretty straightforward, right?

## Style Snackbars with Custom Classes and Global Styles for Success and Error States

But I think this would be even better if these messages were visually different, maybe green for success and red for error.

To do that, we can add custom classes to each snackbar.

We’ll use the "panelClass" option, which takes an array of class names.

Let’s add "snackbar-success" for the success message, and "snackbar-error" for the error message:

```typescript
export class ContactFormComponent {
  ...

  protected submitForm() {
    if (this.contactForm.valid) {
      this.snackBar.open('Message sent successfully!', 'Dismiss', {
        ...,
        panelClass: ['snackbar-success'],
      });
      ...
    } else {
      this.snackBar.open('Please fill in all required fields.', 'OK', {
        panelClass: ['snackbar-error'],
      });
    }
  }
```

These classes will let us target the snackbar container with custom styles.

Next, we'll create a stylesheet for these styles.

We’ll add them as global styles, since the snackbar markup is injected outside of our contact form component.

Let’s call the file [_mat-snackbar.scss](https://stackblitz.com/edit/stackblitz-starters-r6fvxgjw?file=src%2Fscss%2F_mat-snackbar.scss).

Now I’ll add some custom style overrides using Angular Material’s specific classes and [CSS variables](https://material.angular.io/guide/theming#using-theme-styles) where possible:

```scss
.snackbar-success,
.snackbar-error {
  --mat-snack-bar-button-color: white;

  .mat-mdc-snack-bar-action {
    background-color: rgba(white, 0.2);
  }
}

.snackbar-success {
  --mdc-snackbar-container-color: #4caf50;
}

.snackbar-error {
  --mdc-snackbar-container-color: #f44336;
}
```

In these styles I’ll set the success background to green, and the error background to red.

Okay, now I just need to include that [SCSS partial](https://sass-lang.com/documentation/at-rules/use/#partials) along with the rest of the global styles.

I’ll open the [global stylesheet](https://stackblitz.com/edit/stackblitz-starters-o9xseuyp?file=src%2Fglobal_styles.scss) and add the import line:

```scss
@use 'scss/mat-snackbar';
```

Alright, that should be all we need to style the snackbars, so let’s save and try it out:

<div>
<img src="{{ '/assets/img/content/uploads/2025/04-25/demo-4.gif' | relative_url }}" alt="An example of customizing the color of the Angular Material Snackbar components" width="664" height="1080" style="width: 100%; height: auto;">
</div>

Now if I submit the form with errors, it’s red, nice.

And if I submit valid data, it’s green.

Much clearer for the user, right?

## Trigger a Custom Help Panel from the Snackbar Action

Now, what if we want to do something more interesting when the action button is clicked?

Like… instead of just dismissing the error, what if we showed a help panel?

Well, we can customize that behavior too.

I’ve already created a [help panel component](https://stackblitz.com/edit/stackblitz-starters-o9xseuyp?file=src%2Fcontact-form%2Fhelp-panel%2Fhelp-panel.component.ts) for this.

What we want to do is conditionally display this panel when the user clicks the action button in the error snackbar.

To do this, first, I’ll add a "showHelpPanel" [signal](https://angular.dev/guide/signals) to control visibility, and I'll initialize it to false:

```typescript
export class ContactFormComponent {
  ...

  protected showHelpPanel = signal(false);
}
```

Next, I’ll change the snackbar action label from “OK” to “Help”:

```typescript
this.snackBar.open('Please fill in all required fields.', 'Help', {
  ...
});
```

The `open()` method returns a reference to the snackbar [(MatSnackBarRef)](https://material.angular.io/components/snack-bar/api#MatSnackBarRef), so let’s store that in a variable:

```typescript
const snackBarRef = this.snackBar.open(...);
```

Now, we’ll use that reference to call the `onAction()` method, which gives us an observable that emits when the action is clicked.

We’ll subscribe to it, and inside the callback, we’ll set the `showHelpPanel` [signal](https://angular.dev/guide/signals) to true:

```typescript
snackBarRef.onAction().subscribe(() => {
  this.showHelpPanel.set(true);
});
```

Okay, that takes care of opening the help panel. 

Now let’s add a function to close it.

We’ll call it `closeHelpPanel()`, and just set the [signal](https://angular.dev/guide/signals) back to false:

```typescript
protected closeHelpPanel() {
  this.showHelpPanel.set(false);
}
```

Now we need to add the help panel to the template, but first, we need to import it in the component’s imports array:

```typescript
import { HelpPanelComponent } from "./help-panel/help-panel.component";

@Component({
  selector: 'app-contact-form',
  ...,
  imports: [
    ...
    HelpPanelComponent,
  ],
})
export class ContactFormComponent {
  ...
}
```

Okay, switching over to the [HTML](https://stackblitz.com/edit/stackblitz-starters-o9xseuyp?file=src%2Fcontact-form%2Fhelp-panel%2Fhelp-panel.component.html)…

First, I’ll add an [@if](https://angular.dev/tutorials/learn-angular/4-control-flow-if) block that checks the `showHelpPanel` signal.

Inside that block, I’ll render the <app-help-panel> component.

This allows it to appear or disappear based on our internal [signal](https://angular.dev/guide/signals).

Finally, we’ll wire up a `(close)` event on the component that calls our `closeHelpPanel()` method:

```html
@if (showHelpPanel()) {
  <app-help-panel (close)="closeHelpPanel()"></app-help-panel>
}
```

Alright, let’s save everything and try it out:

<div>
<img src="{{ '/assets/img/content/uploads/2025/04-25/demo-5.gif' | relative_url }}" alt="An example of customizing the action behavior of the Angular Material Snackbar service" width="664" height="1080" style="width: 100%; height: auto;">
</div>

Now, when we submit the form without filling it out, we get the error snackbar, but now the action says “Help.”

Clicking it opens the help panel, and clicking “Close” inside the panel hides it again.

Pretty clean, right?

## Final Recap: Toast Notifications and Help Panels Done Right

So that’s it! We added [Angular Material snackbars](https://material.angular.io/components/snack-bar/overview) for both success and error feedback, styled them using global styles, and made the app more interactive by linking the snackbar action to a custom help panel.

This is a really simple way to make your app feel more responsive and helpful for users.

If you found this helpful, don't forget to [subscribe](https://www.youtube.com/c/briantreese?sub_confirmation=1) and check out [my other Angular tutorials](https://www.youtube.com/@briantreese) for more tips and tricks!

{% include banner-ad.html %}

## Additional Resources

- [Angular Material Snackbar Official Docs](https://material.angular.io/components/snack-bar/overview)
- [Angular Material Installation Guide](https://material.angular.io/guide/getting-started)
- [Angular Signals (Official Guide)](https://angular.dev/guide/signals)
- [Angular Reactive Forms (Official Guide)](https://angular.dev/guide/forms/reactive-forms)
- [Angular CDK Overview](https://material.angular.io/cdk/categories)
- [My course: “Styling Angular Applications”](https://app.pluralsight.com/library/courses/angular-styling-applications/table-of-contents)

## Want to See It in Action?

Check out the demo code showcasing these techniques in the StackBlitz project below. If you have any questions or thoughts, don’t hesitate to leave a comment.

<iframe src="https://stackblitz.com/edit/stackblitz-starters-r6fvxgjw?ctl=1&embed=1&file=src%2Fcontact-form%2Fhelp-panel%2Fhelp-panel.component.ts" style="height: 500px; width: 100%; margin-bottom: 1.5em; display: block;"></iframe>