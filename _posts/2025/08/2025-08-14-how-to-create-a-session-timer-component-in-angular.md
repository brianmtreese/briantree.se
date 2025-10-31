---
layout: post
title: "I Built the Smoothest Countdown Timer in Angular"
date: "2025-08-14"
video_id: "W_pHLdeD3YY"
tags:
  - "Angular"
  - "Angular Signals"
  - "Angular Components"
  - "Class Binding"
  - "Animation"
---

<p class="intro"><span class="dropcap">Y</span>ou know those session timeout warnings that pop up in apps right before you get kicked out? Ever wanted to add one to your own Angular app? Well, today we’re doing exactly that. We’re building a real-time countdown timer with smooth animations, color-coded warnings, and a “time’s up” message your users can’t miss.</p>

{% include youtube-embed.html %}

## The Starting Point

Here’s what we’re starting with: a timer UI with a label, a number, and a progress bar:

<div>
<img src="{{ '/assets/img/content/uploads/2025/08-14/demo-1.png' | relative_url }}" alt="An example of a timer component that doesn't do anything in a basic Angular app" width="940" height="418" style="width: 100%; height: auto;">
</div>

Looks fine… but it’s just sitting there. No ticking, no urgency, no real purpose.

Let’s fix that.

## Step 1: Core Countdown Logic in Angular

Right now… it’s completely empty. Just a shell. 

Time to give it some brains.

We’ll start by adding three time-related properties:

1. One for total number of seconds for the countdown. 
2. One for when the timer is in a “warning” phase.
3. One for a “danger” phase.

```typescript
export class SessionTimerComponent {
    readonly total = 15;
    readonly warnAt = 10;
    readonly dangerAt = 5;
}
```

Using `readonly` here means these values can’t be changed after the component is created. 

It's good for keeping our timer rules consistent.

### Using Angular Signals to Track Time Remaining

Now we’ll make a property to track the seconds remaining. 

We'll set it as a [signal](https://angular.dev/guide/signals){:target="_blank"} with the total time as its initial value:

```typescript
import { ..., signal } from '@angular/core';

export class SessionTimerComponent {
    ...
    readonly secondsRemaining = signal(this.total);
}
```

Why a signal? Because anything that depends on a signal automatically re-renders when it changes. 

This will be perfect for keeping the UI in sync as the timer ticks.

### Making the Timer Tick

Now we need to create a timer with a [setInterval()](https://developer.mozilla.org/en-US/docs/Web/API/WindowOrWorkerGlobalScope/setInterval){:target="_blank"} to update this signal every second, subtracting one each tick but never going below zero:

```typescript
export class SessionTimerComponent {
    ...
    constructor() {
        const timerId = setInterval(() => {
            this.secondsRemaining
                .update(v => Math.max(v - 1, 0));
        }, 1000);
    }
}
```

Then, we need to be sure to clean up the timer once the component is destroyed.

For this we'll use the [DestroyRef](https://angular.dev/api/core/DestroyRef){:target="_blank"} to clear the interval when the component gets destroyed:

```typescript
import { ..., DestroyRef, inject } from '@angular/core';

export class SessionTimerComponent {
    ...
    constructor() {
        const timerId = setInterval(() => {
            this.secondsRemaining
                .update(v => Math.max(v - 1, 0));
        }, 1000);

        const destroyRef = inject(DestroyRef);
        this.destroyRef.onDestroy(() => 
            clearInterval(timerId));
    }
}
```

Of course, you could even take this further and clear the interval once the timer reaches zero which would probably be a little better, but this will work fine for this example.

### Formatting Seconds into mm:ss in Angular

Next, we need a way to format our seconds into a readable format to display in the template.

So let's create a "formattedTime" method that:

1. Takes total seconds.
2. Converts to milliseconds.
3. Creates a Date object.
4. Uses `toISOString()` and `slice()` to grab just the mm:ss portion:

```typescript
export class SessionTimerComponent {
    ...
    private formattedTime(totalSeconds: number): string {
        return new Date(totalSeconds * 1000)
            .toISOString().slice(14, 19);
    }
}
```

Okay, now here’s where signals start to shine.

We’ll store this in a [computed signal](https://angular.dev/guide/signals#computed-signals){:target="_blank"} so that it automatically recalculates whenever `secondsRemaining()` changes:

```typescript
import { ..., computed } from '@angular/core';

export class SessionTimerComponent {
    ...
    readonly formattedRemaining = computed(() => 
        this.formattedTime(this.secondsRemaining()));
}
```

Using a computed signal here lets us create derived state.

Anytime `secondsRemaining()` changes, `formattedRemaining()` automatically recalculates using our `formattedTime()` method.

## Displaying Countdown and Progress Bar in the Template

Now we need to wire this up in the HTML.

To do this we’ll first display the formatted time in the UI (remember, signals need `()` to read them):

```html
<div class="value">
    {% raw %}{{ formattedRemaining() }}{% endraw %}
</div>
```

Now we can use [style binding](https://angular.dev/guide/templates/binding#css-style-properties){:target="_blank"} to bind the width of the progress bar to the percentage of time remaining.

To calculate this percentage, we just need to divide the time remaining by the total time, then multiply by 100:

```html
<div 
    class="bar" 
    [style.width.%]="(secondsRemaining() / total) * 100">
</div>
```

## Adding a Smooth Progress Bar Animation with CSS

At this point the bar jumps each second as the timer ticks down. 

Let’s add a width transition so it smoothly shrinks over time.

We'll need to be sure to use the `linear` easing function to make the progress bar shrink smoothly and evenly over time:

```scss
.bar {
    /* other styles */
    transition: width 1s linear;
}
```

This should make the UI feel more polished. 

Less “tick-tick” and more “flow”.

## Show ‘Session Expired’ When Time Runs Out

Now, currently when the timer reaches zero, it just shows "00:00".

Let’s swap this out with a “session expired” message once the time has run out.

To do this we can use an if/else statement in the template based on the `secondsRemaining()` signal.

And we can add a special message when there are no seconds remaining:

```html
<div class="timer">
    @if (secondsRemaining()) {
        <span class="label">Your session expires in:</span>
        <span class="value">
            {% raw %}{{ formattedRemaining() }}{% endraw %}
        </span>
    } @else {
        <span class="label">Your session has expired!</span>
    }
</div>
```

## Color-Coding Warning and Danger States in Angular

Now, what would make this all even better is if we changed the color at the different states. 

So we could make it orange when we’re in the "warning" phase and maybe red when we’re in the "danger" phase.

We’ll use [class binding](https://angular.dev/guide/templates/binding#css-classes){:target="_blank"} to add a "warning" class when the `secondsRemaining()` are less than or equal to our `warnAt` time.

And we'll do the same for the "danger" state too:

```html
<section
    [class.warn]="secondsRemaining() <= warnAt" 
    [class.danger]="secondsRemaining() <= dangerAt">
    ...
</section>
```

Then we'll just need to add styles for these states in our SCSS:

```scss
.warn {
    span {
        color: orange;
    }

    .bar {
        background: orange;
    }
}

.danger {
    span {
        color: red;
    }

    .bar {
        background: red;
    }
}
```

This gives users a clear visual cue as the timer runs out.

Okay, that should be everything, let’s save and see how it looks now:

<div>
<img src="{{ '/assets/img/content/uploads/2025/08-14/demo-2.gif' | relative_url }}" alt="The final session timer component with the countdown and progress bar" width="668" height="272" style="width: 100%; height: auto;">
</div>

Nice! Now we see the time count down and the progress bar smoothly animate as time ticks.

Then when the timer hits 10 seconds, the color changes to orange.

And when it hits 5 seconds, it turns red.

This gives the user a clear visual “uh-oh” moment before the time runs out.

And then, when it hits zero, it shows the "session expired" message.

## Wrapping It Up

And that’s our complete session timer built entirely with:

- Angular Signals
- Computed values
- Modern template syntax
- Simple CSS

No Observables, no manual change detection, just a clean, reactive, and maintainable component.

Easily adaptable for quiz timers, auto-save warnings, or similar countdown UIs.

If you found this helpful, don't forget to [subscribe](https://www.youtube.com/c/briantreese?sub_confirmation=1) and check out [my other Angular tutorials](https://www.youtube.com/@briantreese) for more tips and tricks!

{% include banner-ad.html %}

## Additional Resources
- [Angular Signals Documentation](https://angular.dev/guide/signals){:target="_blank"}
- [CSS Transitions Guide (MDN)](https://developer.mozilla.org/en-US/docs/Web/CSS/CSS_transitions/Using_CSS_transitions){:target="_blank"}
- [Angular Class Binding Docs](https://angular.io/guide/class-binding){:target="_blank"}
- [My Angular Signals Playlist](https://www.youtube.com/playlist?list=PLp-SHngyo0_iboYPhI2YV2dGQFT1mctOQ){:target="_blank"}
- [My course "Angular: Styling Applications"](https://www.pluralsight.com/courses/angular-styling-applications){:target="_blank"}

## Want to See It in Action?

Want to experiment with the final version? Explore the full StackBlitz demo below. If you have any questions or thoughts, don't hesitate to leave a comment.

<iframe src="https://stackblitz.com/edit/stackblitz-starters-jxgs9tgh?ctl=1&embed=1&file=src%2Fsession-timer%2Fsession-timer.ts" style="height: 500px; width: 100%; margin-bottom: 1.5em; display: block;"></iframe>