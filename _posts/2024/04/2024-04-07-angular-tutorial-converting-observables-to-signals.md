---
layout: post
title: "Angular toSignal(): Convert Observables to Signals (v19+)"
date: "2024-04-07"
video_id: "dIyLqvqljKM"
tags:
  - "Angular"
  - "Angular Animations"
  - "Angular CDK"
  - "Angular Forms"
  - "Angular Material"
  - "Angular Signals"
  - "Angular Styles"
  - "Performance"
  - "RxJS"
---

<p class="intro"><span class="dropcap">C</span>onverting Observables to signals in Angular eliminates the need for async pipes, simplifies change detection, and reduces template complexity. While Observables excel at event streams and async operations, signals provide better performance for UI state that needs to update reactively. Angular's <code>toSignal()</code> function bridges these worlds, letting you transform Observable streams into reactive signals. This tutorial shows you how to convert common Observable patterns to signals, when to use each approach, and how to optimize performance.</p>

{% include youtube-embed.html %}

#### Angular Signals Tutorial Series:
- [Signal Inputs & output()]({% post_url /2024/03/2024-03-24-angular-tutorial-signal-based-inputs-and-the-output-function %}) - Learn signal-based inputs and outputs
- [Create Signals with computed()]({% post_url /2024/08/2024-08-01-create-signals-from-other-signals-with-the-computed-function %}) - Learn about computed signals
- [Angular Signals & effect()]({% post_url /2024/08/2024-08-09-angular-signals-and-the-effect-function %}) - Learn about the effect() function

Now, before we get too far along, it's important to note that I have created [another video](https://youtu.be/kM2mZ81968g) where I cover the basics of Signals, as well as the [signal-based input](https://angular.io/guide/signal-inputs) function, and the [output](https://blog.angular.io/meet-angulars-new-output-api-253a41ffa13c) function too.

Also, the demo application that we will use in this post uses the [Angular CDK Breakpoint Observer](https://material.angular.io/cdk/layout/api#BreakpointObserver) and, you guessed it, I have [a video](https://youtu.be/aKxFbZG_3go) on this as well.

So, if you’re not too familiar with Signals or the Breakpoint Observer, you may want to watch those videos first and then come back to this one so that it’ll make more sense. Ok, enough of that, onto the example for this video.

## The Demo Application

Here we have a demo that I created for [the post]({% post_url /2023/10/2023-10-20-angular-host-binding-animations %}) demonstrating how the Angular CDK Breakpoint Observer works. As we resize, we can see that the label at the bottom of the viewport changes at certain points. It’s either large, medium, or small.

<div>
<img src="{{ '/assets/img/content/uploads/2024/04-07/demo-preview-1.gif' | relative_url }}" alt="Example of a demo application before converting Breakpoint Observer Observable subscriptions to Signals" width="1280" height="720" style="width: 100%; height: auto;">
</div>

Also, when the viewport gets pretty small, the main nav is hidden and togglable with the button in the upper right corner.

<div>
<img src="{{ '/assets/img/content/uploads/2024/04-07/demo-preview-2.gif' | relative_url }}" alt="Example of a demo application before converting Breakpoint Observer Observable subscriptions to Signals" width="1280" height="720" style="width: 100%; height: auto;">
</div>

If we toggle this menu open, then resize larger to where it’s no longer togglable, and then resize smaller to where it is togglable again, we can see that it doesn't remain open.

<div>
<img src="{{ '/assets/img/content/uploads/2024/04-07/demo-preview-3.gif' | relative_url }}" alt="Example of a demo application before converting Breakpoint Observer Observable subscriptions to Signals" width="1280" height="720" style="width: 100%; height: auto;">
</div>

Now this exact functionality, and the label change at the bottom is happening because of our use of the CDK Breakpoint observer. Let’s look at some code to see how.

## The Breakpoint Observer Logic

In our nav component we have a “currentRange” variable. Then we use the Breakpoint Observer to observe several breakpoints from the [CDK Layout module](https://material.angular.io/cdk/layout/api#Breakpoints).

This `observe()` method returns and observable that fires anytime these breakpoints are first matched or unmatched. When the event fires, we are then simply checking each of our breakpoints to see which is matched and then setting our current range appropriately. When doing this, since we are using the [`OnPush`](https://angular.io/guide/change-detection-skipping-subtrees#using-onpush) change detection strategy, we also need to use the ChangeDetectorRef to properly update the view and show the appropriate label.

#### nav.component.ts
```typescript
@Component({
  selector: 'app-nav',
  ...
})
export class NavComponent implements OnInit {
    ...
    protected currentRange?: Size;

    ngOnInit() {
        ...

        this.breakpointObserver.observe([Breakpoints.Small, Breakpoints.Medium, Breakpoints.Large])
            .pipe(takeUntilDestroyed(this.destroyRef))
            .subscribe(() => {
            if (this.breakpointObserver.isMatched(Breakpoints.Small)) {
                this.currentRange = 'Small';
            }
            if (this.breakpointObserver.isMatched(Breakpoints.Medium)) {
                this.currentRange = 'Medium';
            }
            if (this.breakpointObserver.isMatched(Breakpoints.Large)) {
                this.currentRange = 'Large';
            }
            this.changeDetectorRef.detectChanges();
        });
    }
}
```

So that’s to show the label at the bottom, next we have an “isVisible” variable used to toggle the visibility of the menu when it’s in smaller viewports. In order to force it to close when it’s been opened and then the viewport has been resized larger, we’re observing another breakpoint here to set it back to false when that occurs.

```typescript
@Component({
  selector: 'app-nav',
  ...
})
export class NavComponent implements OnInit {
    ...
    protected isVisible = false;

    ngOnInit() {
        ...

        const breakpoint = getComputedStyle(this.elementRef.nativeElement).getPropertyValue('--breakpointForMenu');
        this.breakpointObserver.observe(`(max-width: ${breakpoint})`)
            .pipe(takeUntilDestroyed(this.destroyRef))
            .subscribe(state => {
                if (!state.matches) {
                    this.isVisible = false;
                }
        });
    }
}
```

So, what we want to do is convert both of these over to signals. Let’s start with this “isVisble” concept first.

## Converting a Breakpoint Observer Subscription Monitoring a Single Breakpoint to a Signal

First, let’s take look at the template so we can fully understand what’s happening. Here, we can see the `nav` element gets a “visible” class when the `isVisible` property is true.

#### nav.component.html
```html
<nav [class.visible]="isVisible">
    ...
</nav>
```

Also, here on the button, we are simply toggling this property when it’s clicked.

```html
<button (click)="isVisible = !isVisible">
    ...
</button>
```

And then here at the bottom, we are just string interpolating the value of the `currentRange` property.

```html
<section>{% raw %}{{ currentRange ?? 'Small' }}{% endraw %}</section>
```

Ok, so that’s what’s going on in the template, now let’s change some code. Ok, first thing we can do is move this breakpoint out to the class level, and we’ll make it private.

#### nav.component.ts
```typescript
@Component({
  selector: 'app-nav',
  ...
})
export class NavComponent implements OnInit {
    ...
    private breakpoint = getComputedStyle(this.elementRef.nativeElement).getPropertyValue('--breakpointForMenu');
}
```

Now we’re going to create a signal from this observable. To do this, let’s create a new private variable, let’s call it “navTogglable”. The, we’ll use the [`toSignal()`](https://angular.io/api/core/rxjs-interop/toSignal) function, and we need to make sure it gets imported properly.

```typescript
import { toSignal } from '@angular/core/rxjs-interop';

@Component({
  selector: 'app-nav',
  ...
})
export class NavComponent implements OnInit {
    ...
    private navTogglable = toSignal();
}
```

The `toSignal()` function will return a Signal from an Observable. This Signal will always have the most recent value from the Observable.

Now, we can take the whole subscription, and move it into our toSignal() function. We can remove the `takeUntilDestroyed` here too, it won’t be needed now. And then, rather than subscribe, we’re going to map the emitted value in order to return the value rather than a subscription. So, let’s remove the whole subscription. Then, let’s add the `map` operator, and make sure it gets imported too.

This observable will fire with the [`BreakpointState`](https://material.angular.io/cdk/layout/api#BreakpointState) object, and we can simply return the state matches value.

```typescript
import { map } from 'rxjs';

@Component({
  selector: 'app-nav',
  ...
})
export class NavComponent implements OnInit {
    ...
    private navTogglable = toSignal(
        this.breakpointObserver.observe(`(max-width: ${this.breakpoint})`)
            .pipe(map(state => {
                return state.matches;
            }))
    );
}
```

Nex, we can add an options object as the second parameter for the `toSignal` function. Inside of this object, we could provide an initial value if we wanted, but in our case this observable will produce a value immediately on subscription, so we can instead add an option, `requireSync`, with a value of `true`.

```typescript
@Component({
  selector: 'app-nav',
  ...
})
export class NavComponent implements OnInit {
    ...
    private navTogglable = toSignal(
        ...
        ), { requireSync: true });
    );
}
```

Ok, so now we have a Signal that will fire with a Boolean value every time the `observe()` event fires. Now, for this to all work properly, I’m going to add another protected variable here, let’s call it “toggleVisible”. We’ll use this variable to toggle the menu visibility when the button is clicked now. Let’s set it to a Signal using the [`signal()`](https://angular.io/guide/signals#writable-signals) function, and let’s give it an initial value of false.

```typescript
import { ..., signal } from '@angular/core';

@Component({
  selector: 'app-nav',
  ...
})
export class NavComponent implements OnInit {
    ...
    protected toggleVisible = signal(false);
}
```

Now, let’s convert the “isVisible” property over to a Signal using the [`computed()`](https://angular.io/api/core/computed) function. We will set this signal up to fire with a combination of the `toggleVisible()`  and the `navTogglable()` Signals. We’ll only want to toggle the visibility if the nav is togglable, so let’s add a condition, if `navTogglable()`. Within this condition, we can just return the value of the `toggleVisible()` signal. And if the nav isn’t togglable, we just return false.

```typescript
@Component({
  selector: 'app-nav',
  ...
})
export class NavComponent implements OnInit {
    ...
    protected isVisible = computed(() => {
        if (this.navTogglable()) {
            return this.toggleVisible();
        }
        return false;
    });
}
```

So now, our `isVisible()` Signal will only be able to change when the `navTogglable()` Signal is true. And, in that case it will be equal to the current value of the `toggleVisible()` Signal which will be controlled by our button click event.

Ok, one more thing we need to do here. When our Breakpoint Observer observe method fires, we want to set the `toggleVisible()` signal to false. This will just reset it to its initial state.

```typescript
import { map } from 'rxjs';

@Component({
  selector: 'app-nav',
  ...
})
export class NavComponent implements OnInit {
    ...
    private navTogglable = toSignal(
        this.breakpointObserver.observe(`(max-width: ${this.breakpoint})`)
            .pipe(map(state => {
                this.toggleVisible.set(false);
                return state.matches;
            }))
    );
}
```

Now we need to change a few things in the template so let’s switch to the HTML. First, we need to add parentheses everywhere the `isVisible` property is used since it's now a Signal. Then, on the button click event, we want to set the `toggleVisible()` Signal to not equal to its current value.

#### nav.component.html
```html
<nav [class.visible]="isVisible()">
    <ul>
        <li *ngFor="let link of links">
            <a href="#">{{ link }}</a>
        </li>
    </ul>
</nav>
<button (click)="toggleVisible.set(!toggleVisible())">
    {% raw %}{{ isVisible() ? 'Hide Menu' : 'Show Menu' }}{% endraw %}
</button>
<section>{{ currentRange }}</section>
```

Ok, now it should be togglable. Before you can try this, you’ll need to be in a viewport narrow enough that the menu is will start out hidden. Then, just click to toggle the menu open. After that, resize larger so that it becomes always visible, when we resize smaller, it should be closed.

Ok so we’ve successfully converted that example over to Signals, now let’s convert the “currentRange” example over to a signal too.

## Converting a Breakpoint Observer Subscription Monitoring Multiple Breakpoints to a Signal

This example should be a little more straight forward. We’ll use the `toSignal()` function here again here. Let’s copy the `observe()` method with the breakpoints into the `toSignal` function. Then let's add the `pipe()` function and use the `map` operator again. We’ll add an empty callback and within this callback, let’s first check to see if we’re matching the `Breakpoints.Large` breakpoint. If we are, we’ll return a string value of “Large”. Then, if we’re matching our `Breakpoints.Medium` breakpoint, we’ll return a string of “Medium”. And if neither of those are matched, let’s return a value of “Small”.

#### nav.component.ts
```typescript
@Component({
  selector: 'app-nav',
  ...
})
export class NavComponent implements OnInit {
    ...
    protected currentRange = toSignal(
        this.breakpointObserver.observe([Breakpoints.Small, Breakpoints.Medium, Breakpoints.Large])
            .pipe(map(() => {
                if (this.breakpointObserver.isMatched(Breakpoints.Large)) {
                    return 'Large';
                } else if (this.breakpointObserver.isMatched(Breakpoints.Medium)) {
                    return 'Medium';
                } else {
                    return 'Small';
                }
            })
    ), { requireSync: true });
}
```

And that’s it.

Now we can remove the `ngOnInit` method and everything in it. We can also remove the `OnInit` interface, and the import too.

And we don’t need the `ChangeDetectorRef` anymore either. We can remove the import for it, and we can also remove the `takeUntilDestroyed` and `DestroyRef` imports as well since we’re no longer using them either.

So, we were able to get rid of several things here which is cool. Now, we just need to fix the template where we’re using this signal.

#### nav.component.html
```html
<nav [class.visible]="isVisible()">
    <ul>
        <li *ngFor="let link of links">
            <a href="#">{{ link }}</a>
        </li>
    </ul>
</nav>
<button (click)="toggleVisible.set(!toggleVisible())">
    {% raw %}{{ isVisible() ? 'Hide Menu' : 'Show Menu' }}{% endraw %}
</button>
<section>{% raw %}{{ currentRange() }}{% endraw %}</section>
```

Ok, that’s it. So, everything should be working correctly with Signals now.

{% include banner-ad.html %}

## Conclusion

So, we didn’t remove our observables, we just converted them to Signals to make them easier to work with and to optimize Change Detection. You won’t always need to convert your Observables over to Signals in order to use them, but at least now you’ll have a way to do it when needed.

## Want to See It in Action?
Check out the demo code and examples of these techniques in the Stackblitz example below. If you have any questions or thoughts, don’t hesitate to leave a comment.

<iframe src="https://stackblitz.com/edit/stackblitz-starters-cyxmva?ctl=1&embed=1&file=src%2Fnav%2Fnav.component.ts" style="height: 500px; width: 100%; margin-bottom: 1.5em; display: block;">
