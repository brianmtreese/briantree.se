---
layout: post
title: "The @Input Decorator is Out… So Is ngOnChanges. Now What?"
date: "2024-10-25"
video_id: "jENEpDk45z8"
tags:
  - "Angular"
  - "Angular Components"
  - "Angular Effects"
  - "Angular Forms"
  - "Angular Input"
  - "Angular Signals"
  - "JavaScript"
  - "Reactive Forms"
  - "Signal Inputs"
  - "TypeScript"
---

<p class="intro"><span class="dropcap">H</span>ey there, Angular folks, and welcome back! If you're still using <a href="https://angular.dev/api/core/Input">@Input decorators</a> and <a href="https://angular.dev/api/core/OnChanges">ngOnChanges()</a> for managing states, this tutorial is for you! We’ll take two simple forms that are enabled and disabled programmatically based on an <a href="https://angular.dev/api/core/Input">@Input</a> and refactor them to use Angular’s latest <a href="https://angular.dev/guide/signals">signal-based</a> approach.</p>

Trust me, it’s easier than you think, and it’ll make your code cleaner, more performant, and more modern!

{% include youtube-embed.html %}

## Understanding the Existing Application: Setting the Stage

Here’s the scenario, I already have a couple of reactive forms set up. 

First we have a [sign-in-form component](https://stackblitz.com/edit/stackblitz-starters-enftyj?file=src%2Fsign-in-form%2Fsign-in-form.component.ts) where we have an [Angular Form Group](https://angular.dev/api/forms/FormGroup) for our two form fields: "username" and "password":

```typescript
protected form = new FormGroup({
    username: new FormControl<string>('', Validators.required),
    password: new FormControl<string>('', Validators.required)
});
```

We’re using an [@Input](https://angular.dev/api/core/Input) named “disabled” to accept a boolean value from a parent component:

```typescript
@Input() disabled = false;
```

Then, in the [ngOnChanges()](https://angular.dev/api/core/OnChanges) function, if the [@Input](https://angular.dev/api/core/Input) is true, we disable the form, if not we enable it:

```typescript   
ngOnChanges(changes: SimpleChanges) {
    if (changes['disabled']) {
        this.disabled ? this.form.disable() : this.form.enable();
    }
}
```

Also, for the purposes of this example, we are displaying the disabled status of the form in the UI:

<div>
<img src="{{ '/assets/img/content/uploads/2024/10-25/demo-1.png' | relative_url }}" alt="Example of the disabled status of the form displayed in the UI" width="794" height="776" style="width: 100%; height: auto;">
</div>

If we switch to the [template](https://stackblitz.com/edit/stackblitz-starters-enftyj?file=src%2Fsign-in-form%2Fsign-in-form.component.html), down at the bottom, we can see that we’re rendering the word “Disabled” when the [Angular Form Group](https://angular.dev/api/forms/FormGroup) is disabled and then “Enabled” when it’s not:

```html
<footer [class.disabled]="form.disabled">
    Sign In: {% raw %}{{ form.disabled ? 'Disabled' : 'Enabled' }}{% endraw %}
</footer>
```

So, this form is currently enabled, but we’re also seeing this other message where it says, “Sign Up: Disabled”:

<div>
<img src="{{ '/assets/img/content/uploads/2024/10-25/demo-2.png' | relative_url }}" alt="Example of the disabled status of the form displayed in the UI" width="794" height="798" style="width: 100%; height: auto;">
</div>

Well, this is because we also have a [sign-up-form component](https://stackblitz.com/edit/stackblitz-starters-enftyj?file=src%2Fsign-up-form%2Fsign-up-form.component.ts), and its form is currently disabled.

So, if we click the “Sign Up” button at the top of the page, the UI switches to show that [sign-up form component](https://stackblitz.com/edit/stackblitz-starters-enftyj?file=src%2Fsign-up-form%2Fsign-up-form.component.ts). And now we can see that the [sign-in form component](https://stackblitz.com/edit/stackblitz-starters-enftyj?file=src%2Fsign-in-form%2Fsign-in-form.component.ts) is disabled, and this form is now enabled:

<div>
<img src="{{ '/assets/img/content/uploads/2024/10-25/demo-3.gif' | relative_url }}" alt="Example of the disabled status of the form being toggled in the UI" width="794" height="812" style="width: 100%; height: auto;">
</div>

If we look at the [code for this component](https://stackblitz.com/edit/stackblitz-starters-enftyj?file=src%2Fsign-up-form%2Fsign-up-form.component.ts), we see a very similar set up, but we only have a single [form control](https://angular.dev/api/forms/FormControl) for the "name" field instead of a [form group](https://angular.dev/api/forms/FormGroup) like the [sign-in component](https://stackblitz.com/edit/stackblitz-starters-enftyj?file=src%2Fsign-in-form%2Fsign-in-form.component.ts). 

Other than that, it’s the same with the “disabled” [@Input](https://angular.dev/api/core/Input) and the control enabling and disabling within the [ngOnChanges()](https://angular.dev/api/core/OnChanges) method:

```typescript
@Input() disabled = false;
protected name = new FormControl<string>('', Validators.required);
protected submitted = false;

ngOnChanges(changes: SimpleChanges) {
    if (changes['disabled']) {
        this.disabled ? this.name.disable() : this.name.enable();
    }
}
```

Now, in our [root app component](https://stackblitz.com/edit/stackblitz-starters-enftyj?file=src%2Fmain.ts), we have both of these form components.

The disabled input on the [sign-in form](https://stackblitz.com/edit/stackblitz-starters-enftyj?file=src%2Fsign-in-form%2Fsign-in-form.component.ts) will be true when our “formMode” property equals “signUp”:

```html
<app-sign-in-form [disabled]="formMode === 'signUp'"></app-sign-in-form>
```

Then, on the [sign-up form](https://stackblitz.com/edit/stackblitz-starters-enftyj?file=src%2Fsign-up-form%2Fsign-up-form.component.ts) it will be disabled when the “formMode” equals “signIn”:

```html
<app-sign-up-form [disabled]="formMode === 'signIn'"></app-sign-up-form>
```

When we click on these buttons for the tabs at the top, the value of this “formMode” property is toggled to properly display and enable the appropriate form.

```html
<ul>
    <li>
        <button (click)="formMode = 'signIn'" >
            Sign In
        </button>
    </li>
    <li>
        <button (click)="formMode = 'signUp'" >
            Sign Up
        </button>
    </li>
</ul>
```

So that’s how it’s currently set up and it all appears to be working just fine as is right?

Well this is true, but it’s not using the latest Angular features like [signal inputs](https://angular.dev/guide/signals/inputs), so let’s update it to do so.

## Evolving the Angular App: Migrating from @Input Decorators to Signal Inputs

To switch from the [@Input](https://angular.dev/api/core/Input) decorator, it’s pretty easy, we can just remove the decorator.

Then we can add the [input](https://angular.dev/guide/signals/inputs) function. We'll need to be sure to import it from the @angular/core module, and we can set its initial value to false:

```typescript
import { ..., input } from "@angular/core";

disabled = input(false);
```

This function provides [signals](https://angular.dev/guide/signals) for reactive state management. It's part of Angular’s move towards a more reactive architecture.

Now at this point, it’s a signal. We just need to add parenthesis to the usage in the [ngOnChanges()](https://angular.dev/api/core/OnChanges) method:

```typescript
ngOnChanges(changes: SimpleChanges) {
    if (changes['disabled']) {
        this.disabled() ? this.form.disable() : this.form.enable();
    }
}
```

But now that it’s a [signal](https://angular.dev/guide/signals), we can change this. We can completely get rid of [ngOnChanges](https://angular.dev/api/core/OnChanges).

Instead, we’ll leverage Angular’s new [effect()](https://angular.dev/guide/signals/inputs#monitoring-changes) function to monitor for changes to the "disabled" [signal input](https://angular.dev/guide/signals/inputs) instead.

This simplifies our code and makes it more reactive.

### Important Disclaimer About Effects!!!

It’s important to note here that the [effect()](https://angular.dev/guide/signals/inputs#monitoring-changes) function is not always going to be the best choice.

You really shouldn’t use the [effect()](https://angular.dev/guide/signals/inputs#monitoring-changes) function if you need to update other [signals](https://angular.dev/guide/signals).

If that’s what you need to do you should look into creating [computed signals](https://angular.dev/api/core/computed) instead.

But for this example, the [effect()](https://angular.dev/guide/signals/inputs#monitoring-changes) function works just fine, so we're going to use it.

## Maximizing Performance: Transitioning from ngOnChanges() to Signal Effects in Angular

To switch to the [effect()](https://angular.dev/guide/signals/inputs#monitoring-changes) function, we need to first add a constructor.

Then, we can add the [effect()](https://angular.dev/guide/signals/inputs#monitoring-changes) function within the constructor.

We'll also need to be sure that it gets imported from the @angular/core module too:

```typescript
import { ..., effect } from "@angular/core";

constructor() {
    effect(() => {
    });
}
```

Now, once we include our "disabled" [signal input](https://angular.dev/guide/signals/inputs) within this [effect()](https://angular.dev/guide/signals/inputs#monitoring-changes) function, whenever the [signal](https://angular.dev/guide/signals) value changes, this [effect](https://angular.dev/guide/signals/inputs#monitoring-changes) automatically runs. No need to manually check for changes like we did with [ngOnChanges()](https://angular.dev/api/core/OnChanges).

So now, we can simply move this logic into the [effect()](https://angular.dev/guide/signals/inputs#monitoring-changes) function:

```typescript
effect(() => {
    this.disabled() ? this.form.disable() : this.form.enable();
});
```

Then we can remove the [ngOnChanges()](https://angular.dev/api/core/OnChanges) method and its imports too.

And that’s it.

Now this component has been properly updated to use more modern Angular Features. So we should switch over and update the [sign-in form component](https://stackblitz.com/edit/stackblitz-starters-e4ipwq?file=src%2Fsign-in-form%2Fsign-in-form.component.ts) too.

We need to:
* Switch the [@Input](https://angular.dev/api/core/Input) decorator to the [input](https://angular.dev/guide/signals/inputs) function
* Add the constructor
* Add the [effect()](https://angular.dev/guide/signals/inputs#monitoring-changes) function
* Move the logic and add parenthesis to the "disabled" [signal](https://angular.dev/guide/signals)
* Remove everything for the [ngOnChanges()](https://angular.dev/api/core/OnChanges) method and [@Input](https://angular.dev/api/core/Input) decorator

After all of that, the component should look like this:

```typescript
import { ChangeDetectionStrategy, Component, effect, input } from "@angular/core";
import { FormControl, FormGroup, ReactiveFormsModule, Validators } from "@angular/forms";

@Component({
    selector: 'app-sign-in-form',
    templateUrl: './sign-in-form.component.html',
    styleUrl: './sign-in-form.component.scss',
    standalone: true,
    imports: [
        ReactiveFormsModule
    ],
    changeDetection: ChangeDetectionStrategy.OnPush
})
export class SignInFormComponent {
    disabled = input(false);
    protected form = new FormGroup({
        username: new FormControl<string>('', Validators.required),
        password: new FormControl<string>('', Validators.required)
    });
  
    constructor() {
        effect(() => {
            this.disabled() ? this.form.disable() : this.form.enable();
        });
    }
}
```

Let’s save and see how this all works now:

<div>
<img src="{{ '/assets/img/content/uploads/2024/10-25/demo-4.gif' | relative_url }}" alt="Example of the disabled status of the form being toggled in the UI as we switch between the sign-in and sign-up forms" width="796" height="838" style="width: 100%; height: auto;">
</div>

Ok, everything looks good right?

The [sign-in form](https://stackblitz.com/edit/stackblitz-starters-e4ipwq?file=src%2Fsign-in-form%2Fsign-in-form.component.ts) is enabled, and the [sign-up form](https://stackblitz.com/edit/stackblitz-starters-e4ipwq?file=src%2Fsign-up-form%2Fsign-up-form.component.ts) is disabled.

Then when we switch to the [sign-up form](https://stackblitz.com/edit/stackblitz-starters-e4ipwq?file=src%2Fsign-up-form%2Fsign-up-form.component.ts), it’s enabled, and the [sign-in form](https://stackblitz.com/edit/stackblitz-starters-e4ipwq?file=src%2Fsign-in-form%2Fsign-in-form.component.ts) is disabled.

So, it works exactly like it did before but now it’s up to date with current best practices.

{% include banner-ad.html %}

## In Conclusion

To recap, we’ve modernized our [Angular form](https://angular.dev/guide/forms/reactive-forms) components by converting the [@Input](https://angular.dev/api/core/Input) decorator to the new [input](https://angular.dev/guide/signals/inputs) function, and we used the [effect()](https://angular.dev/guide/signals/inputs#monitoring-changes) function to replace [ngOnChanges()](https://angular.dev/api/core/OnChanges) in this case. 

Our forms will continue to react automatically to [input](https://angular.dev/guide/signals/inputs) value changes, but will now do so using [signals](https://angular.dev/guide/signals), making the code a little cleaner and more performant.

With just a few lines of code, we’ve refactored our Angular components to use the latest reactive patterns with [signal inputs](https://angular.dev/guide/signals/inputs) and [effects](https://angular.dev/guide/signals/inputs#monitoring-changes).

Alright, I hope you found this tutorial helpful!

Don't forget to check out [my other Angular tutorials](https://www.youtube.com/@briantreese) for more tips and tricks.

## Additional Resources
* [The demo BEFORE making any changes](https://stackblitz.com/edit/stackblitz-starters-enftyj?file=src%2Fsign-in-form%2Fsign-in-form.component.ts)
* [The demo AFTER making changes](https://stackblitz.com/edit/stackblitz-starters-e4ipwq?file=src%2Fsign-in-form%2Fsign-in-form.component.ts)
* [Angular Signal inputs documentation](https://angular.dev/guide/signals/inputs)
* [Angular Effect function documentation](https://angular.dev/guide/signals/inputs#monitoring-changes)

## Want to See It in Action?
Check out the demo code and examples of these techniques in the Stackblitz example below. If you have any questions or thoughts, don’t hesitate to leave a comment.

<iframe src="https://stackblitz.com/edit/stackblitz-starters-e4ipwq?ctl=1&embed=1&file=src%2Fsign-in-form%2Fsign-in-form.component.ts" style="height: 500px; width: 100%; margin-bottom: 1.5em; display: block;"></iframe>
