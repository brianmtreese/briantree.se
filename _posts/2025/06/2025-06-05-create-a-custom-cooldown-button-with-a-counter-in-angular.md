---
layout: post
title: "I Built a “Cooldown” Button in Angular… Here’s How"
date: "2025-06-05"
video_id: "qKl_BjFoh7I"
tags:
  - "Angular"
  - "Angular Components"
  - "Angular Signals"
  - "Angular Styles"
  - "Performance"
---

<p class="intro"><span class="dropcap">D</span>ouble-submit buttons create poor user experiences and can cause duplicate API calls, form submissions, or unintended actions. Cooldown buttons prevent this by disabling themselves after clicks, showing countdown timers, and preventing rapid-fire interactions. This tutorial demonstrates how to build a reusable cooldown button component in Angular using signals for state management and setInterval for countdown functionality, creating a pattern you can use throughout your application.</p>

{% include youtube-embed.html %}

## Why a "Cooldown" Button?

Think about feedback forms, one-time password (OTP) requests, or "Resend Email" buttons. You don’t want the user clicking repeatedly and hammering your backend. A "cooldown" button provides:
- Click-throttling
- Visual feedback for the user
- Improved UX and backend safety

And it’s surprisingly easy to build in Angular.

## Kick Things Off with a Basic Angular Form 

Here’s our starting point, a basic feedback form with a submit button and a success message:

<div>
<img src="{{ '/assets/img/content/uploads/2025/06-05/demo-1.gif' | relative_url }}" alt="Example of a basic feedback form with a submit button and a success message in Angular" width="776" height="864" style="width: 100%; height: auto;">
</div>

When we look at the [template for this form component](https://stackblitz.com/edit/stackblitz-starters-9eagfbag?file=src%2Fform%2Fform.html){:target="_blank"}, we can see that the button is actually already set up as its own "cooldown" button component:

```html
<h2>Send us a message</h2>
<label for="message">Message</label>
<textarea></textarea>

<app-cooldown-button
    [disabled]="!message()"
    (click)="onSubmit($event)">
</app-cooldown-button>

@if (showSuccess()) {
    <p>✅ Message sent successfully!</p>
}
```

So, let's look at the [template for this component](https://stackblitz.com/edit/stackblitz-starters-9eagfbag?file=src%2Fcooldown-button%2Fcooldown-button.html){:target="_blank"}:

```html
<button 
    (click)="handleClick()" 
    [disabled]="disabled()">
    Send
</button>
```

It's really simple, it's just a button that has a click event and that's disabled if the "disabled" [input](https://angular.dev/guide/components/inputs){:target="_blank"} is true.

Now let’s look at [the TypeScript](https://stackblitz.com/edit/stackblitz-starters-9eagfbag?file=src%2Fcooldown-button%2Fcooldown-button.ts){:target="_blank"}:

```typescript
import { Component, input, ChangeDetectionStrategy } from '@angular/core';
import { CommonModule } from '@angular/common';

@Component({
    selector: 'app-cooldown-button',
    templateUrl: './cooldown-button.html',
    styleUrl: './cooldown-button.scss',
    imports: [CommonModule],
    changeDetection: ChangeDetectionStrategy.OnPush
})
export class CooldownButtonComponent {
    readonly disabled = input(false);

    protected handleClick() {
    }
}
```

This too is super simple. We just have the "disabled" [input](https://angular.dev/guide/components/inputs){:target="_blank"} and the empty `handleClick()` method.

So, this all is nothing fancy yet. 

The goal is to give that button a brain, to have it control itself and provide visual feedback to the user.

## Let’s Give This Button a Brain 

Let’s add some logic for this button to disable itself and show a countdown for a few seconds after it's clicked.

First, let's add a few properties to manage the state of this button:

```typescript
import { ..., signal } from '@angular/core';

export class CooldownButtonComponent {
    protected cooldownSeconds = signal(0);
    private intervalId!: number;
    private duration = signal(6);
}
```

The "cooldownSeconds" signal is used to display the remaining seconds before the button is clickable again.

The "intervalId" is used to store the ID of the interval that's used with the [setInterval()](https://developer.mozilla.org/en-US/docs/Web/API/Window/setInterval){:target="_blank"} function.

When using [setInterval()](https://developer.mozilla.org/en-US/docs/Web/API/Window/setInterval){:target="_blank"}, it returns a positive integer that uniquely identifies the interval, and can be used to clear the interval using the [clearInterval()](https://developer.mozilla.org/en-US/docs/Web/API/Window/clearInterval){:target="_blank"} function.

The "duration" [signal](https://angular.dev/guide/signals){:target="_blank"} is used to set the duration of the "cooldown" in seconds for calculations.

Now, let's update the "handleClick()" handle the "cooldown" logic.

First, let's add a variable to track the end of the timer in terms of seconds: 

```typescript
protected handleClick() {
    const end = Date.now() + this.duration() * 1000;
}
```

We're using the current time and the "duration" [signal](https://angular.dev/guide/signals){:target="_blank"}, multiplied by one thousand since we’re dealing with milliseconds and we want to display seconds in the end.

Now we want to make sure we clear any existing running intervals so we’ll use the [clearInterval()](https://developer.mozilla.org/en-US/docs/Web/API/Window/clearInterval){:target="_blank"} function and we’ll pass it our "intervalId".

```typescript
protected handleClick() {
    ...
    this.clearInterval();
}
```

This ensures that if an interval is already running, we clear it before starting a new one, preventing overlapping countdowns.

Now we’re ready to add our interval. 

Since [setInterval()](https://developer.mozilla.org/en-US/docs/Web/API/Window/setInterval){:target="_blank"} returns a positive integer, we can use it to store the interval id in our "intervalId" variable:

```typescript
protected handleClick() {
    ...
    this.intervalId = setInterval(() => {
    }, 1000);
}
```

Okay so this timer is going to run every second until we clear it.

So within it, let’s add a variable for the remaining time left in our counter:

```typescript
protected handleClick() {
    ...
    this.intervalId = setInterval(() => {
        const remaining = Math.ceil((end - Date.now()) / 1000);
    }, 1000);
}
```

We're using [Math.ceil()](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/Math/ceil){:target="_blank"} to make sure that we always round up to the nearest second.

We’re also using the "end" variable we calculated earlier, subtracting the current time, and dividing by one thousand to get the remaining time in seconds.

Now, let’s update the "cooldownSeconds" [signal](https://angular.dev/guide/signals){:target="_blank"} to display this remaining time:

```typescript
protected handleClick() {
    ...
    this.intervalId = setInterval(() => {
        ...
        this.cooldownSeconds.set(Math.max(0, remaining));
    }, 1000);
}
```

For this we’re using the [Math.max()](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/Math/max){:target="_blank"} function to make sure that we don’t end up with a negative number of seconds by using zero along with our remaining count.

This will always take the larger of the two numbers.

It just prevents issues in case the timer overshoots slightly.

Now, we can check to see if our remaining duration is less than or equal to zero, and if it is, we’ll clear the interval and reset the button:

```typescript
protected handleClick() {
    ...
    this.intervalId = setInterval(() => {
        ...
        if (remaining <= 0) {
            clearInterval(this.intervalId);
        }
    }, 1000);
}
```

This will kill the timer when we reach the end of our countdown.

Okay, now the last part here is to make sure the interval is cleared when the component is destroyed.

So, let’s implement the [OnDestroy](https://angular.dev/api/core/OnDestroy){:target="_blank"} interface:

```typescript
import { ..., OnDestroy } from '@angular/core';

export class CooldownButtonComponent implements OnDestroy { 
    ...
}
```

Then we can simply add the [ngOnDestroy()](https://angular.dev/guide/components/lifecycle#ngondestroy){:target="_blank"} method and clear the interval:

```typescript
ngOnDestroy() {
    clearInterval(this.intervalId);
}
```

This just ensures that we don’t leave any timers running after the component is gone.

So the final code for this component looks like this:

```typescript
import { Component, signal, OnDestroy, input, ChangeDetectionStrategy } from '@angular/core';
import { CommonModule } from '@angular/common';

@Component({
  selector: 'app-cooldown-button',
  templateUrl: './cooldown-button.html',
  styleUrl: './cooldown-button.scss',
  imports: [CommonModule],
  changeDetection: ChangeDetectionStrategy.OnPush
})
export class CooldownButtonComponent implements OnDestroy {
  readonly disabled = input(false);
  protected cooldownSeconds = signal(0);
  private intervalId!: number;
  private duration = signal(6);

  protected handleClick() {
    const end = Date.now() + this.duration() * 1000;
    clearInterval(this.intervalId);

    this.intervalId = setInterval(() => {
        const remaining = Math.ceil((end - Date.now()) / 1000);
        this.cooldownSeconds.set(Math.max(0, remaining));

        if (remaining <= 0) {
            clearInterval(this.intervalId);
        }
    }, 1000);
  }

  ngOnDestroy() {
    clearInterval(this.intervalId);
  }
}
```

### Show the Countdown in the UI 

Now, let’s update this button label in [the template](https://stackblitz.com/edit/stackblitz-starters-9eagfbag?file=src%2Fcooldown-button%2Fcooldown-button.html){:target="_blank"}.

We'll add a condition to check if the “cooldown seconds” value is greater than zero.

If it is, we'll add a message that displays our live countdown in seconds as it’s running.

And then we’ll move the current “Send” label to the else:

```html
<button 
    (click)="handleClick()" 
    [disabled]="disabled()">
    @if (cooldownSeconds() > 0) {
        {% raw %}{{ `Retry in ${cooldownSeconds()}s` }}{% endraw %}
    } @else {
        Send
    } 
</button>
```

Ok, I think that’s everything now, so let’s save and see how this all works:

<div>
<img src="{{ '/assets/img/content/uploads/2025/06-05/demo-2.gif' | relative_url }}" alt="Example of a cooldown button with a countdown in Angular" width="968" height="862" style="width: 100%; height: auto;">
</div>

Now, when we submit, we have a count down!

Pretty cool huh?

But there is a portion of this countdown where the button is still enabled even though the timer is counting down.

Let's fix this.

### Lock the Button Until the Countdown Ends

Let’s make sure the button is disabled when it’s in “cooldown” mode no matter what.

To do this, let’s add to our current disabled [attribute binding](https://angular.dev/guide/templates/binding#binding-dynamic-properties-and-attributes){:target="_blank"} to also disable when the "cooldown seconds" [signal](https://angular.dev/guide/signals){:target="_blank"} is greater than zero:

```typescript
<button 
    (click)="handleClick()" 
    [disabled]="disabled() || cooldownSeconds() > 0">
    ...
</button>
```

Okay that should do it, let's save and try this out again now:

<div>
<img src="{{ '/assets/img/content/uploads/2025/06-05/demo-3.gif' | relative_url }}" alt="Example of a cooldown button disabled for the entire duration of the countdown in Angular" width="956" height="848" style="width: 100%; height: auto;">
</div>

Nice! Now when we submit, the button is disabled until the countdown ends.

So, this is working pretty well now, but since it’s reusable, we may find that we want to change the label.

What if we wanted this button to say “send message” instead of “send”? 

Well, we can’t do this currently.

## Make the Button Text Customizable

So, what we should do is add an [input](https://angular.dev/guide/components/inputs){:target="_blank"} for the button label.

Back in [the TypeScript](https://stackblitz.com/edit/stackblitz-starters-9eagfbag?file=src%2Fcooldown-button%2Fcooldown-button.ts){:target="_blank"}, let’s add a new “label” [input](https://angular.dev/guide/components/inputs){:target="_blank"}:

```typescript
export class CooldownButtonComponent implements OnDestroy {
    ...
    readonly label = input('Send');
}
```

Here, we're providing a fallback value of “Send”, so if we don’t pass a custom label, it’ll still display “Send” like it does currently.

Now we just need to update [the template](https://stackblitz.com/edit/stackblitz-starters-9eagfbag?file=src%2Fcooldown-button%2Fcooldown-button.html){:target="_blank"} to use this new input:

```html
<button 
    (click)="handleClick()" 
    [disabled]="disabled()">
    @if (cooldownSeconds() > 0) {
        {% raw %}{{ `Retry in ${cooldownSeconds()}s` }}{% endraw %}
    } @else {
        {% raw %}{{ label() }}{% endraw %}
    } 
</button>
```

Then, we just need to update the usage of this component in [the form](https://stackblitz.com/edit/stackblitz-starters-9eagfbag?file=src%2Fform%2Fform.html){:target="_blank"} to pass in a custom "Send Message" label:

```html
<app-cooldown-button
    label="Send Message"
    [disabled]="!message()"
    (click)="onSubmit($event)">
</app-cooldown-button>
```

Okay, now let’s save and check it out:

<div>
<img src="{{ '/assets/img/content/uploads/2025/06-05/demo-4.png' | relative_url }}" alt="Example of a cooldown button with a custom label using a signal input in Angular" width="976" height="726" style="width: 100%; height: auto;">
</div>

There, now we have a custom label.

I think that’s a good addition to this component because it can be used for pretty much anything.

Now what about the duration?

## Make the "Cooldown" Duration Configurable 

What if we want the ability to configure the duration?

Like, what if we wanted this particular button to countdown from eight seconds instead of six?

Well, let’s switch our current "duration" [signal](https://angular.dev/guide/signals){:target="_blank"} to an [input](https://angular.dev/guide/components/inputs){:target="_blank"} instead:

```typescript
export class CooldownButtonComponent implements OnDestroy {
    ...
    readonly duration = input.required<number>();
}
```

In this case we're also making it required, which means we’ll have to add a duration every time we use this component.

So let's switch back to [the form component](https://stackblitz.com/edit/stackblitz-starters-9eagfbag?file=src%2Fform%2Fform.html){:target="_blank"} and update the usage of this component to pass in a custom duration:

```html
<app-cooldown-button
    label="Send Message"
    [duration]="8"
    [disabled]="!message()"
    (click)="onSubmit($event)">
</app-cooldown-button>
```

Okay, that’s all we need for this so let’s save and see how it works now:

<div>
<img src="{{ '/assets/img/content/uploads/2025/06-05/demo-5.gif' | relative_url }}" alt="Example of a cooldown button with a custom duration using a signal input in Angular" width="960" height="846" style="width: 100%; height: auto;">
</div>

Nice, now when we submit, we have a countdown from eight seconds instead of six.

## Final Thoughts: A Smart Button with Boundaries

What started as a basic button became a self-managing Angular component that:

- Disables itself after each click
- Shows a live countdown using signals
- Supports configurable labels and durations
- Plays nicely in any form with zero external services

It's a small enhancement that delivers a big UX payoff, and a reusable pattern that scales.

If this helped you, consider [subscribing](https://www.youtube.com/c/briantreese?sub_confirmation=1){:target="_blank"}, checking out [more Angular tutorials](https://www.youtube.com/@briantreese){:target="_blank"}, or grabbing some dev-friendly merch from [my shop](https://shop.briantree.se/){:target="_blank"}!

{% include banner-ad.html %}

## Additional Resources

- [The demo app BEFORE any changes](https://stackblitz.com/edit/stackblitz-starters-9eagfbag?file=src%2Fcooldown-button%2Fcooldown-button.ts){:target="_blank"}
- [The demo app AFTER making changes](https://stackblitz.com/edit/stackblitz-starters-np3n3xbe?file=src%2Fcooldown-button%2Fcooldown-button.ts){:target="_blank"}
- [Angular Signals (official docs)](https://angular.dev/guide/signals){:target="_blank"}
- [Signal inputs in Angular 16+](https://angular.dev/api/core/input){:target="_blank"}
- [setInterval MDN Docs](https://developer.mozilla.org/en-US/docs/Web/API/setInterval){:target="_blank"}
- [My course: "Styling Angular Applications"](https://app.pluralsight.com/library/courses/angular-styling-applications/table-of-contents){:target="_blank"}

## Want to See It in Action?

Want to experiment with the final version? Explore the full StackBlitz demo below. If you have any questions or thoughts, don’t hesitate to leave a comment.

<iframe src="https://stackblitz.com/edit/stackblitz-starters-np3n3xbe?ctl=1&embed=1&file=src%2Fcooldown-button%2Fcooldown-button.ts" style="height: 500px; width: 100%; margin-bottom: 1.5em; display: block;"></iframe>
