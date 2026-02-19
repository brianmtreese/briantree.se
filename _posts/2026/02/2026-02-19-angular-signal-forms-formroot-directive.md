---
layout: post
title: "Angular Signal Forms: The New formRoot Directive Explained"
date: "2026-02-19"
video_id: "ARl78Z0XE7M"
tags:
  - "Angular"
  - "Angular Forms"
  - "Signal Forms"
  - "Angular Form Submission"
  - "formRoot"
  - "Angular 21"
---

<p class="intro"><span class="dropcap">F</span>orm submission in <a href="https://angular.dev/essentials/signal-forms" target="_blank">Angular Signal Forms</a> has always required a bit of manual wiring: a submit handler, <code>preventDefault</code>, and an explicit call to <code>submit()</code>. It works, but it doesn't feel fully Angular. Starting in <a href="https://github.com/angular/angular/releases/tag/v21.2.0-next.3" target="_blank">Angular 21.2-next.3</a>, the new <code>formRoot</code> directive changes that. It makes form submission completely declarative, moves submission logic into the form itself, and eliminates the remaining boilerplate. This post walks through exactly how it works and how to migrate an existing Signal Form in about 60 seconds.</p>

{% include youtube-embed.html %}

## Signal Forms Submission Before formRoot

Here's the starting point, a simple signup form with a username and email field:

<div><img src="{{ '/assets/img/content/uploads/2026/02-19/signal-form-before-formroot.jpg' | relative_url }}" alt="Signal Forms signup form with username and email fields" width="1096" height="882" style="width: 100%; height: auto;"></div>

The submit button is disabled until the form is valid:

<div><img src="{{ '/assets/img/content/uploads/2026/02-19/signal-form-submit-button-disabled.jpg' | relative_url }}" alt="Signal Forms signup form with submit button disabled due to invalid form state" width="1246" height="354" style="width: 100%; height: auto;"></div>

Once both fields are filled in with valid values, the button enables:

<div><img src="{{ '/assets/img/content/uploads/2026/02-19/signal-form-submit-button-enabled.jpg' | relative_url }}" alt="Signal Forms signup form with username and email filled in and submit button enabled" width="1284" height="890" style="width: 100%; height: auto;"></div>

After we submit the form, in the console, we can see the dirty status, form value, and the model signal value:

<div><img src="{{ '/assets/img/content/uploads/2026/02-19/signal-form-console-output.jpg' | relative_url }}" alt="Console showing dirty status, form value, and model signal value after Signal Form submission" width="1304" height="308" style="width: 100%; height: auto;"></div>

Everything works, but the amount of manual wiring required just to submit the form isn’t ideal.

## Manual Form Submission in Signal Forms (The Old Way)

In [the template](https://github.com/brianmtreese/angular-signal-forms-form-root-example/blob/master/src/form/form.component.html){:target="_blank"}, form submission requires two manual pieces:

```html
<form (submit)="onSubmit($event)" novalidate>
    ...
</form>
```

The `(submit)` binding wires up a custom method and passes along the event. 

The `novalidate` attribute disables the browser's built-in validation so Signal Forms can handle it instead.

Without it, the browser could show its own popup messages that would conflict with our form validation logic.

This is what we’ll be changing in this tutorial.

But just to make sure we understand all aspects of this form before changing it, each input uses the `formField` directive to connect to the Signal Form:

```html
<input
    id="username"
    type="text"
    [formField]="form.username" />
...
<input
    id="email"
    type="email"
    [formField]="form.email" />
```

And the submit button triggers submission:

```html
<button type="submit" [disabled]="form().invalid() || form().submitting()"> 
    @if (form().submitting()) {
        Creating… 
    } @else { 
        Create account
    }
</button>
```

Pretty straightforward stuff.

Now let’s look at [the TypeScript](https://github.com/brianmtreese/angular-signal-forms-form-root-example/blob/master/src/form/form.component.ts){:target="_blank"} for this component.

### Component TypeScript

In the component class, the form is constructed with a model signal and validation rules:

```typescript
export interface SignupModel {
	username: string;
	email: string;
}

const INITIAL_VALUES: SignupModel = {
	username: '',
	email: '',
};

protected readonly model = signal<SignupModel>(INITIAL_VALUES);

protected readonly form = form(
    this.model, 
    s => {
        required(s.username, { message: 'Please enter a username' });
        minLength(s.username, 3, 
            { message: 'Your username must be at least 3 characters' });
        required(s.email, { message: 'Please enter an email address' });
    }
);
```

This is the key piece driving everything we just saw in the browser.

Then the submit handler wires everything together:

```typescript
protected onSubmit(event: Event) {
    event.preventDefault();

    submit(this.form, async f => {
        const value = f().value();
        const result = await this.signupService.signup(value);

        if (result.status === 'error') {
            const errors: ValidationError.WithOptionalFieldTree[] = [];

            if (result.fieldErrors.username) {
                errors.push({
                    fieldTree: f.username,
                    kind: 'server',
                    message: result.fieldErrors.username,
                });
            }

            if (result.fieldErrors.email) {
                errors.push({
                    fieldTree: f.email,
                    kind: 'server',
                    message: result.fieldErrors.email,
                });
            }

            return errors.length ? errors : undefined;
        }

        console.log('Form Dirty:', this.form().dirty());
        console.log('Form Value:', this.form().value());
        console.log('Form Model:', this.model());
        return undefined;
    });
}
```

`preventDefault` stops the browser from refreshing the page. 

If we didn’t include this, the browser would perform a full page refresh which would wipe out our app state.

The `submit()` call from the Signal Forms API marks fields as touched, runs validation, and executes the submission logic.

If everything succeeds, we log the dirty status, form value, and model signal value to the console.

It works, but there are several pieces that require manual wiring just to submit the form.

The new `formRoot` directive eliminates some of it.

## Angular formRoot Directive Explained (Signal Forms)

Starting in Angular 21.2-next.3, the `FormRoot` directive is now available from `@angular/forms/signals`.

### Step 1: Add FormRoot to the Component Imports

```typescript
import { ..., FormRoot } from '@angular/forms/signals';

@Component({
    selector: 'app-form',
    imports: [..., FormRoot],
    ...
})
```

### Step 2: Update the Template

Here we remove the `(submit)` binding and `novalidate` attribute and replace them with the `formRoot` directive:

```html
<form [formRoot]="form">
    ...
</form>
```

This directive handles both of these automatically.

That’s the only template change needed. 

Angular now handles submission automatically.

`formRoot` prevents default browser submission behavior internally and connects the DOM form to the Signal Form model.

### Step 3: Move Submission Logic Into the Form

The key shift is that submission logic now lives directly inside the form definition instead of in a separate event handler. 

This makes the form self-contained and removes the need for manual submission wiring in the template.

This is done with a third argument on the `form()` function containing a `submission` property.

We can essentially move everything from the `submit()` function in the `onSubmit()` method here:

```typescript
protected readonly form = form(
    this.model, 
    s => { ... },
    {
        submission: {
            action: async f => {
                const value = f().value();
                const result = await this.signupService.signup(value);

                if (result.status === 'error') {
                    const errors: ValidationError.WithOptionalFieldTree[] = [];

                    if (result.fieldErrors.username) {
                        errors.push({
                            fieldTree: f.username,
                            kind: 'server',
                            message: result.fieldErrors.username,
                        });
                    }

                    if (result.fieldErrors.email) {
                        errors.push({
                            fieldTree: f.email,
                            kind: 'server',
                            message: result.fieldErrors.email,
                        });
                    }

                    return errors.length ? errors : undefined;
                }

                console.log('Form Dirty:', this.form().dirty());
                console.log('Form Value:', this.form().value());
                console.log('Form Model:', this.model());
                return undefined;
            }
        }
    }
);
```

The old `onSubmit()` method can now be removed entirely. 

The `formRoot` directive connects the DOM `<form>` element to the Signal Form model declaratively. 

When the form is submitted, Angular automatically calls the configured `submission.action` callback. 

This mirrors how `formGroup` connects a DOM `<form>` to a `FormGroup` in Reactive Forms.

## formRoot in Action: Same Result, Less Code

After saving, the form looks exactly the same:

<div><img src="{{ '/assets/img/content/uploads/2026/02-19/signal-form-formroot-form-after-switching-to-formroot.jpg' | relative_url }}" alt="The form after migrating to formRoot" width="1096" height="882" style="width: 100%; height: auto;"></div>

And when we submit the form, we see the same console output:

<div><img src="{{ '/assets/img/content/uploads/2026/02-19/signal-form-formroot-console-output-after-submit.jpg' | relative_url }}" alt="Console showing the same dirty status, form value, and model signal value after migrating to formRoot and submitting the form" width="1304" height="308" style="width: 100%; height: auto;"></div>

Everything works exactly the same, but with a little less code now.

At this point, I think there’s one more improvement we can make.

## Resetting Signal Forms After Submission

After submission, the form keeps its values by default.

To clear the fields and reset form state, we'll call `reset()` inside the submission action:

```typescript
protected readonly form = form(
    this.model, 
    s => { ... },
    {
        submission: {
            action: async f => {
                ...

                console.log('Form Dirty:', this.form().dirty());
                console.log('Form Value:', this.form().value());
                console.log('Form Model:', this.model());

                f().reset();

                console.log('Form Dirty:', this.form().dirty());
                console.log('Form Value:', this.form().value());
                console.log('Form Model:', this.model());

                return undefined;
            }
        }
    }
);
```

This resets the form to its initial state.

We've also added more logs to see the final state of the form and model signals after it’s been reset.

Now, after we save the form and submit again, it almost looks like nothing changed.

But if we look closely at the console, we can see that the dirty status actually changed from `true` to `false`:

<div><img src="{{ '/assets/img/content/uploads/2026/02-19/signal-form-reset-console-output.jpg' | relative_url }}" alt="Console showing the dirty status changed from true to false after resetting the form" width="1356" height="614" style="width: 100%; height: auto;"></div>

What if we also want to reset the form and model value?

Well, this is pretty easy to do now.

### How to Reset Form State AND Model Signal 

According to the Signal Forms docs, `reset()` does several things.

First, it says that this resets the `touched` and `dirty` states of the field and its descendants.

<div><img src="{{ '/assets/img/content/uploads/2026/02-19/signal-form-reset-docs-1.jpg' | relative_url }}" alt="Signal Forms reset() docs part 1" width="1882" height="176" style="width: 100%; height: auto;"></div>

And then, optionally we can pass a value to reset the value of the form, which we didn’t and that’s why the value remained the same:

<div><img src="{{ '/assets/img/content/uploads/2026/02-19/signal-form-reset-docs-2.jpg' | relative_url }}" alt="Signal Forms reset() docs part 2" width="1902" height="172" style="width: 100%; height: auto;"></div>

It also mentions that it does not change the data model, it needs to be reset directly, meaning that we need to manually reset the model signal back to its initial value

<div><img src="{{ '/assets/img/content/uploads/2026/02-19/signal-form-reset-docs-3.jpg' | relative_url }}" alt="Signal Forms reset() docs part 3" width="1796" height="176" style="width: 100%; height: auto;"></div>

Kinda clunky... but ok.

So calling `reset()` alone will correctly reset `dirty` to `false`, but the form fields will still show their submitted values.

To reset the actual field values, we need to pass the initial data to `reset()`:

```typescript
protected readonly form = form(
    this.model, 
    s => { ... },
    {
        submission: {
            action: async f => {
                ...
                f().reset(INITIAL_VALUES);
                ...
            }
        }
    }
);
```

Passing a value to `reset()` resets both the form fields back to their initial values.

Now, what I found during testing is that this appears to handle the model signal automatically now too.

No need to reset the model signal separately.

This appears to be an intentional improvement in recent Angular releases.

And now after submitting, the fields clear out and both the form value and model signal return to their initial empty state:

<div><img src="{{ '/assets/img/content/uploads/2026/02-19/signal-form-reset-after-submit.jpg' | relative_url }}" alt="Signal Form fields cleared and console showing reset dirty status, empty form value, and empty model signal after submission" width="1136" height="428" style="width: 100%; height: auto;"></div>

## Why formRoot Is Probably the New Recommended Pattern

The `formRoot` directive removes the last piece of manual boilerplate from Signal Forms submission. 

Declaring submission logic inside the form rather than in a separate method keeps everything in one place, which is easier to read and easier to test.

You can still use the `submit()` function directly when you need fine-grained control, but for most forms, `formRoot` is the cleaner path forward.

It also aligns Signal Forms more closely with Angular’s existing Reactive Forms mental model, where directives like `formGroup` declaratively connect the DOM to the form model. 

`formRoot` follows the same idea.

If this helped you, be sure to [subscribe](https://www.youtube.com/c/briantreese?sub_confirmation=1) for more deep dives into modern Angular features.

## Additional Resources
- [The source code for this example](https://github.com/brianmtreese/angular-signal-forms-form-root-example){:target="_blank"}
- [v21.2.0-next.3 Release Notes](https://github.com/angular/angular/releases/tag/v21.2.0-next.3){:target="_blank"}
- [Angular Signal Forms Guide](https://angular.dev/essentials/signal-forms){:target="_blank"}
- [My course "Angular: Styling Applications"](https://www.pluralsight.com/courses/angular-styling-applications){:target="_blank"}
- [My course "Angular in Practice: Zoneless Change Detection"](https://app.pluralsight.com/library/courses/angular-practice-zoneless-change-detection){:target="_blank"}
- [Get a Pluralsight FREE TRIAL HERE!](https://www.jdoqocy.com/click-101557355-17135603){:target="_blank"}
