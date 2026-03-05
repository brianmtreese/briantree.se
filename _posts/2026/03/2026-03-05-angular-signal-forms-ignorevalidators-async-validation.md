---
layout: post
title: "Angular 21 Signal Forms: ignoreValidators Explained"
date: "2026-03-05"
video_id: "Fd_8YGeFMTk"
tags:
  - "Angular"
  - "Angular Forms"
  - "Signal Forms"
  - "Async Validation"
  - "Form Validation"
  - "Angular 21"
  - "TypeScript"
---

<p class="intro"><span class="dropcap">W</span>hat happens if a user clicks submit while your async validator is still checking the server? Do you submit bad data? Block the user? Silently fail? <a href="https://angular.dev/essentials/signal-forms" target="_blank">Angular Signal Forms</a> now gives you explicit control over that behavior with the <code>ignoreValidators</code> option. In this guide, we'll walk through all three modes so you can choose the right strategy for your real-world Angular applications.</p>

{% include youtube-embed.html %}

## Angular Signal Forms: Default Submission Behavior with Async Validators

Here we have a simple sign-up form with a username field:

<div><img src="{{ '/assets/img/content/uploads/2026/03-05/signup-form-before.jpg' | relative_url }}" alt="The signup form with username field" width="1244" height="696" style="width: 100%; height: auto;"></div>

If you type something short, you get a minlength validation error:

<div><img src="{{ '/assets/img/content/uploads/2026/03-05/signup-form-minlength-error.jpg' | relative_url }}" alt="The signup form with username field and a minlength validation error" width="1402" height="752" style="width: 100%; height: auto;"></div>

When you type something longer, a "checking availability" message appears:

<div><img src="{{ '/assets/img/content/uploads/2026/03-05/signup-form-checking-availability.jpg' | relative_url }}" alt="The signup form with username field and a checking availability message" width="1401" height="750" style="width: 100%; height: auto;"></div>

This message comes from an async validator that checks whether the username is already taken.

**Here's the key behavior to understand:** If you click the submit button while the async validator is still running, the submit action runs immediately:

You can see this because we log the form value on submission:

<div><img src="{{ '/assets/img/content/uploads/2026/03-05/signup-form-submission-log.jpg' | relative_url }}" alt="The signup form with username field and a submission log" width="2276" height="760" style="width: 100%; height: auto;"></div>

It does not wait for the async validator to complete. 

Once the async check finishes, we get a validation error letting us know the name is already taken but by then, submission has already happened:

<div><img src="{{ '/assets/img/content/uploads/2026/03-05/signup-form-submission-error.jpg' | relative_url }}" alt="The signup form with username field and a submission error" width="1282" height="756" style="width: 100%; height: auto;"></div>

This is the default behavior we'll modify in this tutorial.

But first, let's see how the form is configured.

## How the Signal Form Is Configured (Template + Submission Logic)

[The template](https://github.com/brianmtreese/angular-signal-forms-submit-options/blob/master/src/form/form.component.html){:target="_blank"} uses the new [FormRoot](https://angular.dev/api/forms/signals/FormRoot){:target="_blank"} directive on the `<form>` element to connect the native form to the Signal Form model:

```html
<form [formRoot]="form">
    ...
</form>
```

The text input uses the [FormField](https://angular.dev/api/forms/signals/FormField){:target="_blank"} directive to bind to the username field:

```html
<input
    id="username"
    type="text"
    [formField]="form.username" />
```

Below the input, we show a "checking availability" message when <code>form.username().pending()</code> is true:

```html
@if (form.username().pending()) {
    <p class="info">Checking availability...</p>
}
```

This happens while the async validator is running. 

We then loop through errors when the field has been touched to show validation errors:

```html
 @if (form.username().touched() && form.username().invalid()) {
    <ul class="error-list">
        @for (err of form.username().errors(); track $index) {
            <li>{% raw %}{{ err.message }}{% endraw %}</li>
        }
    </ul>
}
```

The submit button is disabled during submission and its label changes to "Creating...":

```html
<button type="submit" [disabled]="form().submitting()"> 
    {% raw %}{{ form().submitting() ? 'Creating…' : 'Create account' }}{% endraw %}
</button>
```

### The TypeScript: Model and Validation

In [the component](https://github.com/brianmtreese/angular-signal-forms-submit-options/blob/master/src/form/form.component.ts){:target="_blank"}, we first define the form model for the form:

```typescript
interface SignupModel {
	username: string;
}

protected readonly model = signal<SignupModel>({
    username: ''
});
```
Then we create the form using the [form()](https://angular.dev/api/forms/signals/form){:target="_blank"} function and pass in the model.

We also add a required, minlength, and async validators to the username field:

```typescript
protected readonly form = form(
    this.model, 
    s => {
        required(s.username, { message: 'Please enter a username' });
        minLength(s.username, 3, 
            { message: 'Your username must be at least 3 characters' });
        validateAsync(s.username, {
            params: ({ value }) => {
                const val = value();
                if (!val || val.length < 3) {
                    return undefined;
                }
                return val;
            },
            factory: params =>
                resource({
                    params,
                    loader: async ({ params }) => {
                        const username = params;
                        const available = await this.checkUsernameAvailability(username);
                        return available;
                    }
                }),
            onSuccess: (result: boolean) => {
                if (result === false) {
                    return {
                        kind: 'username_taken',
                        message: 'This username is already taken'
                    }
                }
                return null;
            },
            onError: (error: unknown) => {
                console.error('Validation error:', error);
                return null;
            }
        });
        debounce(s.username, 300);
    },
    ...
);
```

And then, the third parameter to this form is an options object where we handle submission:

```typescript
{
    submission: {
        action: async form => {
            console.log('Form Value:', form().value());
            await new Promise(resolve => setTimeout(resolve, 1500));
        }
    }
}
```

This <code>submission</code> object defines an <code>action</code> that runs when submission is allowed.

This action only runs if the form permits it, and by default, it runs even when async validators are still pending. 

Validation errors can appear after submission has already happened.

**Is that what you want in a real application?** Sometimes yes, if you want a responsive feel and you're okay validating after submission. 

Often you need stricter behavior, and until now there was no control over this. 

But now, the <code>ignoreValidators</code> option changes that.

## ignoreValidators: 'pending' - Default Async Submission Behavior Explained

The new <code>ignoreValidators</code> option determines how validator state affects whether submission is allowed.

Inside the <code>submission</code> configuration is where you control how validator state affects whether submission is allowed.

The three possible values are <code>pending</code>, <code>none</code>, and <code>all</code>.

With <code>ignoreValidators: 'pending'</code>, you can still submit while async validators are running. 

```typescript
{
    submission({
        ignoreValidators: 'pending',
        ...
    });
}
```

After saving, you'll notice that the form still submits while the async validator is still running:

<div><img src="{{ '/assets/img/content/uploads/2026/03-05/signup-form-submission-while-async-validator-is-running.jpg' | relative_url }}" alt="The signup form with username field and a submission while the async validator is still running" width="2266" height="754" style="width: 100%; height: auto;"></div>

This is because <code>pending</code> is the default behavior. 

Adding it explicitly doesn't change behavior, but it can make the intent clear in your codebase.

**Use this when:** You want a fast, responsive experience and don't want to block on async checks.

## ignoreValidators: 'none' - Block Submission Until Validation Completes

When we switch to <code>ignoreValidators: 'none'</code> we get more strict, production-safe behavior:

```typescript
{
    submission({
        ignoreValidators: 'none',
        ...
    });
}
```

After saving, you'll notice that the form does not submit while the async validator is still running anymore:

<div><img src="{{ '/assets/img/content/uploads/2026/03-05/signup-form-not-submitting-while-async-validator-is-running.jpg' | relative_url }}" alt="The signup form with username field not submitting while the async validator is still running" width="2254" height="762" style="width: 100%; height: auto;"></div>

And it won't submit once validation finishes if the form is still invalid:

<div><img src="{{ '/assets/img/content/uploads/2026/03-05/signup-form-not-submitting-with-invalid-fields.jpg' | relative_url }}" alt="The signup form with username field not submitting with invalid fields" width="2250" height="756" style="width: 100%; height: auto;"></div>

With <code>none</code>, the form respects all validator states. 

If a validator is pending, submission waits. 

If the form is invalid, submission is blocked. 

The user cannot submit until all validation (including async) has completed and the form is valid.

### Using onInvalid to Auto-Focus the First Invalid Field

When submission is blocked because the form is invalid, you can improve UX by focusing the first invalid field. 

You can add an <code>onInvalid</code> callback to do this:

```typescript
{
    submission({
        ignoreValidators: 'none',
        onInvalid: (field, detail) => {
            const first = detail.root().errorSummary()?.[0];
            first?.fieldTree()?.focusBoundControl?.();
        }
        ...
    });
}
```

Now, when the user clicks submit and the form is invalid, <code>onInvalid</code> runs. 

We use <code>errorSummary()</code> to get a flat list of fields with errors, grab the first one, and use <code>focusBoundControl()</code> to move focus to it:

<div><img src="{{ '/assets/img/content/uploads/2026/03-05/signup-form-submission-focusing-first-invalid-field.gif' | relative_url }}" alt="The signup form with username field and submission focusing the first invalid field" width="1272" height="778" style="width: 100%; height: auto;"></div>

This gives users clear feedback about what needs to be fixed.

**Use this when:** You need strict, production-safe validation and want to prevent invalid or partially validated data from being submitted.

## ignoreValidators: 'all' - Submit Even When Invalid or Pending

With <code>ignoreValidators: 'all'</code>, the form submits regardless of validation state:

```typescript
{
    submission({
        ignoreValidators: 'all',
        ...
    });
}
```

In this mode, you can submit with an empty required field, or while an async validator is still running, it essentially ignores the validator state:

<div><img src="{{ '/assets/img/content/uploads/2026/03-05/signup-form-submission-with-empty-required-field.gif' | relative_url }}" alt="The signup form with username field and a submission with empty required field" width="1908" height="600" style="width: 100%; height: auto;"></div>

Validation still runs and errors still appear, but submission has already occurred.

**Use this when:** You're building features like saving drafts, auto-saving, or partial data persistence, not for forms that require full validation before submission.

## Choosing the Right ignoreValidators Mode for Real-World Angular Apps 

| Mode | Behavior | Best For |
|------|----------|----------|
| `pending` | Submit while async validators run; block only on invalid sync state | Fast UX when you're okay validating after submit |
| `none` | Block until all validation (sync + async) completes | Production forms that must not submit invalid data |
| `all` | Submit regardless of validation state | Drafts, auto-save, partial persistence |

<code>ignoreValidators</code> gives you precise control over what happens when users submit while validation is still running. 

If you're building real-world Angular applications with Signal Forms, this is an option you should understand deeply.

If this helped you, be sure to [subscribe](https://www.youtube.com/c/briantreese?sub_confirmation=1) for more deep dives into modern Angular features.

## Additional Resources
- [The source code for this example](https://github.com/brianmtreese/angular-signal-forms-submit-options){:target="_blank"}
- [Angular Signal Forms Guide](https://angular.dev/essentials/signal-forms){:target="_blank"}
- [Angular Form Validation](https://angular.dev/guide/forms/validation){:target="_blank"}
- [My course "Angular: Styling Applications"](https://www.pluralsight.com/courses/angular-styling-applications){:target="_blank"}
- [My course "Angular in Practice: Zoneless Change Detection"](https://app.pluralsight.com/library/courses/angular-practice-zoneless-change-detection){:target="_blank"}
- [Get a Pluralsight FREE TRIAL HERE!](https://www.jdoqocy.com/click-101557355-17135603){:target="_blank"}
