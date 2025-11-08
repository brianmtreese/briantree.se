---
layout: post
title: "exportAs in Angular: What It Does and When to Use It"
date: "2025-05-22"
video_id: "-6H6y3s6-no"
tags:
  - "Angular"
  - "Angular Components"
  - "Angular Directives"
  - "Angular Forms"
  - "Angular Material"
  - "Angular Signals"
  - "Angular Styles"
  - "CSS"
  - "HTML"
  - "export-as"
---

<p class="intro"><span class="dropcap">E</span>ver built a directive exposing public methods or <a href="https://angular.dev/guide/signals" target="_blank">signals</a>… only to realize you can’t cleanly access them when using it in another component template? In this tutorial, we’ll fix that using <a href="https://angular.dev/api/core/Directive#exportAs" target="_blank">exportAs</a>, <a href="https://angular.dev/guide/signals" target="_blank">signals</a>, and a modern declarative API, just like <a href="https://material.angular.io/" target="_blank">Angular Material</a> sometimes does.</p>

{% include youtube-embed.html %}

## Let’s See What’s Broken

This is our app. It looks good at first glance, but the wizard is purely decorative:

<div>
<img src="{{ '/assets/img/content/uploads/2025/05-22/demo-1.png' | relative_url }}" alt="The wizard is purely decorative, it doesn't function correctly at all" width="803" height="991" style="width: 100%; height: auto;">
</div>

All three steps are visible: "Personal Info", "Work Details", and "Review & Submit". 

The navigation buttons don’t work. 

It’s not actually doing anything at all.

Looking into [the code](https://stackblitz.com/edit/stackblitz-starters-wkgclzq1?file=src%2Fstep-tracker.directive.ts){:target="_blank"}, we can easily see why. 

All we’ve got is a `stepTracker` directive:

```html
<div stepTracker [stepLabels]="steps()" class="stepper">
    ...
</div>
```

And the static three steps inside of it:

```html
<section>
  <h3>Personal Info</h3>
  <p>Fill out your name, email, and contact information.</p>
</section>
<section>
  <h3>Work Details</h3>
  <p>Enter your job title, company, and experience.</p>
</section>
<section>
  <h3>Review & Submit</h3>
  <p>Please review your information before submitting.</p>
</section>
```

[The directive](https://stackblitz.com/edit/stackblitz-starters-wkgclzq1?file=src%2Fstep-tracker.directive.ts){:target="_blank"} is set up to track state with a "current" [signal](https://angular.dev/guide/signals) and exposes some public methods, but there’s no way to call them from [this template](https://stackblitz.com/edit/stackblitz-starters-wkgclzq1?file=src%2Fmain.html){:target="_blank"}:

```typescript
export class StepTrackerDirective {
  readonly stepLabels = input<string[]>();
  private readonly current = signal(0);

  next() {
    this.current.update(i => i + 1);
  }
  
  prev() {
    this.current.update(i => i - 1);
  }

  reset() {
    this.current.set(0);
  }
}
```

## Trying the Obvious Fix (and Why It Fails)

We can try adding a [template reference](https://angular.dev/guide/templates/variables#template-reference-variables){:target="_blank"} variable (`#wizard`) and calling `wizard.next()` from a button click:

```html
<div stepTracker ... #wizard>
    ...
</div>
...
<button (click)="wizard.next()">Next</button>
```

But Angular throws an error, because (`#wizard`) is referencing the native DOM element, not our [directive](https://stackblitz.com/edit/stackblitz-starters-wkgclzq1?file=src%2Fstep-tracker.directive.ts){:target="_blank"}:

<div>
<img src="{{ '/assets/img/content/uploads/2025/05-22/demo-2.png' | relative_url }}" alt="Screenshot of the error: Property 'next' does not exist on type 'HTMLDivElement'" width="766" height="562" style="width: 100%; height: auto;">
</div>

## The Imperative Approach: viewChild

To get around this, we can use the [viewChild()](https://angular.dev/api/core/viewChild){:target="_blank"} function in [the root component class](https://stackblitz.com/edit/stackblitz-starters-wkgclzq1?file=src%2Fmain.ts){:target="_blank"}:

```typescript
import { ..., viewChild } from '@angular/core';

export class App {
    protected wizard = viewChild.required(StepTrackerDirective);
}
```

Then, in [the template](https://stackblitz.com/edit/stackblitz-starters-wkgclzq1?file=src%2Fmain.html){:target="_blank"}, we can bind to this "wizard" [signal](https://angular.dev/guide/signals){:target="_blank"} and call its methods:

```html
<button (click)="wizard().next()">Next</button>
```

This works… but it’s imperative.

We’re not accessing [the directive](https://stackblitz.com/edit/stackblitz-starters-wkgclzq1?file=src%2Fstep-tracker.directive.ts){:target="_blank"} in code, we’re only trying to use its behavior in the template.

Feels a little clunky, right?

## Fixing It the Angular Way: exportAs

Now, if this were a component, the first example with the [template reference variable](https://angular.dev/guide/templates/variables#template-reference-variables){:target="_blank"} would have worked just fine.

This directive is a different story though.

[Template reference variables](https://angular.dev/guide/templates/variables#template-reference-variables){:target="_blank"}  default to the component instance, but not for directives. 

That’s where [exportAs](https://angular.dev/api/core/Directive#exportAs){:target="_blank"} comes in:

```typescript
@Directive({
  selector: '[stepTracker]',
  exportAs: 'stepper'
})
```

This will create an alias that can then be accessed with a [template reference variable](https://angular.dev/guide/templates/variables#template-reference-variables){:target="_blank"}.

In [the root component template](https://stackblitz.com/edit/stackblitz-starters-wkgclzq1?file=src%2Fmain.html){:target="_blank"}, we can add this reference:

```html
<div stepTracker ... #wizard="stepper">
    ...
</div>
```

And then call [the directive's](https://stackblitz.com/edit/stackblitz-starters-wkgclzq1?file=src%2Fstep-tracker.directive.ts){:target="_blank"} methods directly from [the template](https://stackblitz.com/edit/stackblitz-starters-wkgclzq1?file=src%2Fmain.html){:target="_blank"}, without using [viewChild](https://angular.dev/api/core/viewChild){:target="_blank"}:

```html
<button (click)="wizard.next()">Next</button>
```

This is clean, declarative, and works great with [signals](https://angular.dev/guide/signals).

## Only Show the Step That Matters

Next, we need make sure only the current step is shown.

We need to expose the current step index from [the directive](https://stackblitz.com/edit/stackblitz-starters-wkgclzq1?file=src%2Fstep-tracker.directive.ts){:target="_blank"}:

```typescript
export class StepTrackerDirective {
  ...
  readonly stepIndex = this.current;
}
```

Then we can add logic to [the template](https://stackblitz.com/edit/stackblitz-starters-wkgclzq1?file=src%2Fmain.html){:target="_blank"} to conditionally show each step based on the "stepIndex" [signal](https://angular.dev/guide/signals){:target="_blank"} from [the directive](https://stackblitz.com/edit/stackblitz-starters-wkgclzq1?file=src%2Fstep-tracker.directive.ts){:target="_blank"}:

```html
<section *ngIf="wizard.stepIndex() === 0">
  ...
</section>
<section *ngIf="wizard.stepIndex() === 1">
  ...
</section>
<section *ngIf="wizard.stepIndex() === 2">
  ...
</section>
```

Now, navigation works and the UI reflects the current state:

<div>
<img src="{{ '/assets/img/content/uploads/2025/05-22/demo-3.gif' | relative_url }}" alt="The wizard is now functional, with the correct step being shown" width="806" height="608" style="width: 100%; height: auto;">
</div>

When we click "Next" and "Back", we’re actually stepping through this now!

So, our wizard is stepping, but it’s still walking into walls 😂.

If I’m on the last step and I click “next” again, there’s no step for me to navigate to which results in an error:

<div>
<img src="{{ '/assets/img/content/uploads/2025/05-22/demo-4.png' | relative_url }}" alt="Screenshot of the wizard with error when navigating past the last step" width="778" height="424" style="width: 100%; height: auto;">
</div>

Let’s fix this.

## Don’t Let It Break: Add Navigation Guards

In [the directive](https://stackblitz.com/edit/stackblitz-starters-wkgclzq1?file=src%2Fstep-tracker.directive.ts){:target="_blank"}, we need to add a few [signals](https://angular.dev/guide/signals){:target="_blank"} to detect when we’re on the first or last step:

```typescript
export class StepTrackerDirective {
  ...
  readonly totalSteps = computed(() => this.stepLabels()?.length ?? 0);
  readonly isFirstStep = computed(() => this.stepIndex() === 0);
  readonly isLastStep = computed(() => this.stepIndex() === this.totalSteps() - 1);
}
```

Then we prevent navigation if we're already at the boundary:

```typescript
export class StepTrackerDirective {
  ...
  next() {
    if (!this.isLastStep()) {
      this.current.update(i => i + 1);
    }
  }
  
  prev() {
    if (!this.isFirstStep()) {
      this.current.update(i => i - 1);
    }
  }
}
```

In [the template](), we then want to disable the "Back" button when we're on the first step:

```html
<button 
  (click)="wizard.prev()" 
  [disabled]="wizard.isFirstStep()">
  Back
</button>
```

Then, we want to add logic to show the the "Next" button and hide the "Submit" button unless we're on the last step:

```html
@if (!wizard.isLastStep()) {
  <button (click)="wizard.next()">Next</button>
} @else {
  <button (click)="submit()">Submit</button>
}
```

Now the wizard can’t go out of bounds, and it’s much more polished:

<div>
<img src="{{ '/assets/img/content/uploads/2025/05-22/demo-5.gif' | relative_url }}" alt="Now the wizard can't go out of bounds, and it's much more polished" width="800" height="868" style="width: 100%; height: auto;">
</div>

The “back” is properly disabled on the first step and the last step the “next” button is hidden and the “submit” button is shown.

## Make the Wizard Feel Smarter

Now we want to enhance the stepper header to include “Step X of Y” and the current step’s label.

This is done with one more [computed signal](https://angular.dev/guide/signals#computed-signals){:target="_blank"} in [the directive](https://stackblitz.com/edit/stackblitz-starters-wkgclzq1?file=src%2Fstep-tracker.directive.ts){:target="_blank"} that returns the current step label based on the index:

```typescript
export class StepTrackerDirective {
  ...
  readonly currentLabel = computed(() =>
    this.stepLabels()?.[this.stepIndex()] ?? ''
  );
}
```

Then, we can update [the template](https://stackblitz.com/edit/stackblitz-starters-wkgclzq1?file=src%2Fmain.html){:target="_blank"} to display the step count and current step label:

```html
<p class="step-count">
  Step {% raw %}{{ wizard.stepIndex() + 1 }}{% endraw %} of {% raw %}{{ wizard.totalSteps() }}{% endraw %}
</p>
<h2 class="step-label">
  {% raw %}{{ wizard.currentLabel() }}{% endraw %}
</h2>
```

Now, the UI is both reactive and user-friendly all made possible with [exportAs](https://angular.dev/api/core/Directive#exportAs){:target="_blank"} and a [template reference variable](https://angular.dev/guide/templates/variables#template-reference-variables){:target="_blank"}:

<div>
<img src="{{ '/assets/img/content/uploads/2025/05-22/demo-6.gif' | relative_url }}" alt="The wizard is now fully functional, with the correct step being shown and the step count and label being displayed" width="968" height="744" style="width: 100%; height: auto;">
</div>

## How Angular Material Does This

If you’ve ever used [Angular Material](https://material.angular.io/){:target="_blank"}, this concept might feel familiar.

They use [exportAs](https://angular.dev/api/core/Directive#exportAs){:target="_blank"} in components like the [Stepper](https://material.angular.io/components/stepper/overview){:target="_blank"}, which lets you reference the stepper component directly in your templates exactly like we just did:

```html
<mat-horizontal-stepper #wizard="matStepper">
  ...
</mat-horizontal-stepper>
<footer>
  <p>You're currently on step {% raw %}{{ wizard.selectedIndex + 1 }}{% endraw %}</p>
  <button mat-button (click)="wizard.reset()">Reset</button>
</footer>
```

Same pattern, same benefits.

## Final Thoughts + When You Don’t Need exportAs

So that’s [exportAs](https://angular.dev/api/core/Directive#exportAs){:target="_blank"}, the little-known key to building clean, declarative APIs for your directives and components in Angular.

But, you don’t need it if:
- You’re only accessing the directive/component from TypeScript
- You’re not exposing behavior to the template
- The directive/component is static or visual only

But if you're building reusable, template-driven logic, it’s probably a must.

If you found this helpful, don't forget to [subscribe](https://www.youtube.com/c/briantreese?sub_confirmation=1){:target="_blank"}, check out [my other Angular tutorials](https://www.youtube.com/@briantreese){:target="_blank"} for more tips and tricks, and maybe buy some Angular swag from [my shop](https://shop.briantree.se/){:target="_blank"}!

{% include banner-ad.html %}

## Additional Resources
- [The demo app BEFORE any changes](https://stackblitz.com/edit/stackblitz-starters-wkgclzq1?file=src%2Fstep-tracker.directive.ts){:target="_blank"}
- [The demo app AFTER making changes](https://stackblitz.com/edit/stackblitz-starters-rg2rllvg?file=src%2Fstep-tracker.directive.ts){:target="_blank"}
- [An Angular Material Stepper demo](https://stackblitz.com/edit/stackblitz-starters-hvtdcd3o?file=src%2Fmain.html){:target="_blank"}
- [Angular exportAs API docs](https://angular.dev/api/core/Directive#exportAs){:target="_blank"}
- [Signals in Angular](https://angular.dev/guide/signals){:target="_blank"}
- [Angular Material Stepper docs](https://material.angular.io/components/stepper/overview){:target="_blank"}
- [My course: "Styling Angular Applications"](https://app.pluralsight.com/library/courses/angular-styling-applications/table-of-contents){:target="_blank"}

## Want to See It in Action?

Check out the demo code showcasing these techniques in the StackBlitz project below. If you have any questions or thoughts, don’t hesitate to leave a comment.

<iframe src="https://stackblitz.com/edit/stackblitz-starters-rg2rllvg?ctl=1&embed=1&file=src%2Fmain.html" style="height: 500px; width: 100%; margin-bottom: 1.5em; display: block;"></iframe>
