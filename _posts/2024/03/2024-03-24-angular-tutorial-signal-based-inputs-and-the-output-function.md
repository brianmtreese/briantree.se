---
layout: post
title: "Signal-Based Inputs and the Output Function"
date: "2024-03-24"
video_id: "kM2mZ81968g"
tags: 
  - "Angular"
  - "Angular Signals"
  - "Signal Inputs"
---
<p class="intro"><span class="dropcap">I</span>n newer versions of Angular, a pretty significant change is coming with Signals. If you work with Angular and haven’t heard about them yet, you’re in the right place. In this post you’ll learn what they are, at a high level, and you’ll learn how to use the new signal-based inputs along with the new output function in components. We’re going to take a look at an example using the existing <code>@Input</code> and <code>@Output</code> decorators and we’ll convert it over to signals and the output function. I’ve been using signals a lot lately and I can assure you, It’s a change. Definitely a different way of thinking. Alright, let’s get to it!
</p>

<iframe width="1280" height="720" src="https://www.youtube.com/embed/kM2mZ81968g" title="" frameborder="0" allow="accelerometer; autoplay; clipboard-write; encrypted-media; gyroscope; picture-in-picture; web-share" allowfullscreen></iframe>

## What Exactly are Signals?

If you’ve been working in Angular for very long, you’re surely aware of what change detection is and probably have, at least, some experience working with it. It can be a challenging thing to deal with and understand. It can be challenging to optimize too because many different things can trigger it, or it may not be triggered as expected making it so changes are not properly reflected in the view.

<div>
<img src="{{ '/assets/img/content/uploads/2024/03-24/signals-are-here-to-help.png' | relative_url }}" alt="Signals are here to help" width="2560" height="1440" style="width: 100%; height: auto;">
</div>

Well, [signals](https://angular.io/guide/signals) have been added in Angular to address all of this. They are intended to be easier to use and understand. They are also intended to optimize change detection by determining the exact parts of the UI that have changed and need to be updated without affecting others that don’t.

A signal is essentially a reactive programming concept, not really unique in any way to Angular. Their most basic principle is that they will notify the items using them when their value changes.Under the hood they use a getter function, and they can be both writable and read-only.

<div>
<img src="{{ '/assets/img/content/uploads/2024/03-24/what-are-signals-in-angular.png' | relative_url }}" alt="What are Signals in Angular" width="2560" height="1440" style="width: 100%; height: auto;">
</div>

So that’s the basic concept of what they are, and there’s lots to consider when using them. The example that we’ll look at in this post is just the tip of the iceberg. Signals are going to become a core concept in the apps we build if they haven’t already.

We are moving towards what’s considered "signal-based" components. What this means is that we will be switching away from the old `@Input` and `@Output` decorators as well as the old lifecycle hooks too. Let’s convert an existing component using the old `@Input` decorator over to a signal input to help you better understand the concept. 

## Replacing the Old `@Input` Decorator with the New Signal-Based Input

Here we’re looking at our demo application. It allows us to choose from different players in a list to display a handful of their stats. What we’re looking at here is our player component.

<div>
<img src="{{ '/assets/img/content/uploads/2024/03-24/player-component.png' | relative_url }}" alt="Example of the player component in the demo application" width="897" height="568" style="width: 100%; height: auto;">
</div>

In the code, we have an input using the `@Input` decorator for our player data. It takes in a Player object, and it’s required.

#### player.component.ts
```typescript
@Input({required: true}) player!: Player;
```

Now, there are certainly different ways to do this sort of thing, but for this demo, we have several other properties that are used to display different player data in the UI. And, in order for these properties to properly update when the player input data changes, we need to set them in the `ngOnChanges` lifecycle.

```typescript
    imagePath = '';
    name = '';
    games = 0;
    points = 0;
    fieldGoalPercentage = 0;
    threePointPercentage = 0;

    ngOnChanges() {
        this.imagePath = `/assets/${this.player.imageName}.avif`;
        this.name = this.player.name;
        this.games = this.player.games;
        this.points = this.player.points;
        this.fieldGoalPercentage = this.player.fieldGoalPercentage;
        this.threePointPercentage = this.player.threePointPercentage;
    }
```

If we did in in the `OnInit` method, it would only set them the first time the component loads and would not update them when the input changes. And, what’s happening is that this component is used in the `app.component.html` template one time and the player data is updated based on the player that’s chosen. So, if we didn’t update them on changes, this wouldn’t work as expected. 

#### app.component.html
```html
<label>
    <span>Choose a Player</span>
    <select [formControl]="options">
        ...
    </select>
</label>

<app-player
    [player]="options.value" 
    (playerRemoved)="removePlayer($event)">
</app-player>
```

Ok, so now that we hopefully understand how this example is working, let’s convert this input over to a signal input instead. Also, when we do this, we’ll covert all of the other properties over to signals and remove the `ngOnChanges` method.

### Adding Required Signal-Based Inputs

Ok first, we can remove the old decorator. And we can remove it from the imports too since we’re not going to use it anymore.

To use the new input, we’ll make our player property equal to [input](https://angular.io/guide/signal-inputs) and we need to make sure that it gets imported properly too. Just like the old Input decorator, inputs can be both optional and required so if our player wasn’t required, we would leave this as is. But, in this case, it’s required, so we need to add dot, required. And it will be typed to our Player object so we add angle brackets around our Player interface.

#### player.component.ts
```typescript
import { input, ... } from '@angular/core';

@Component({
  selector: 'app-player',
  ...
})
export class PlayerComponent {
    player = input.required<Player>();
}
```

And that’s it, this input is now a signal. So, that was pretty easy, but everywhere we're using this input will have errors now. If we wanted to leave everything here as is, we could just update everywhere we use the player object to call the player signal by adding parentheses, which will always give us the current value of that signal.

```typescript
ngOnChanges() {
    this.imagePath = `/assets/${this.player().imageName}.avif`;
    this.name = this.player().name;
    this.games = this.player().games;
    this.points = this.player().points;
    this.fieldGoalPercentage = this.player().fieldGoalPercentage;
    this.threePointPercentage = this.player().threePointPercentage;
}
```

But we don’t want to do this here. Instead, we want to covert all of these properties over to signals themselves.

### Using Computed Signals to Remove the Need to Handle Change Detection

Let’s start with the "imagePath" property. To make this a signal, we can use our player input. Since we switched it over to a signal, we can use the new [`computed()`](https://angular.io/guide/signals#computed-signals) function. We'll need to make sure that gets imported correctly too.

This function will essentially create a signal from another signal. And when the original signal value changes, the `computed()` function will compute its new value, based on the new value of the original signal.

Within this function, we add a callback. This callback will return our computed value.

```typescript
import { computed, ... } from '@angular/core';

@Component({
  selector: 'app-player',
  ...
})
export class PlayerComponent {
    imagePath = computed(() => `/assets/${this.player().imageName}.avif`);
}
```

So, that’s pretty easy right? Now, every time the player value changes, this property will automatically update its value too.

Ok, one down, a few more to go. Now these others are even easier.

For the name, we can add the computed function again, and then, this time within the call back we can just return the player’s name from our input signal.

```typescript
name = computed(() => this.player().name);
```

And the rest of these will be exactly the same as this.

```typescript
games = computed(() => this.player().games);
points = computed(() => this.player().points);
fieldGoalPercentage = computed(() => this.player().fieldGoalPercentage);
threePointPercentage = computed(() => this.player().threePointPercentage);
```

Ok, now that all of these properties have been converted to computed signals, we can remove the `ngOnChanges` method and everything within it. We can also remove the interface, and the import as well.

### Accessing Signal Values in the Template

Now, the last part here is to properly call all of these new signals in the template. So, if we switch over to the template, we need to update every instance of these properties so that they properly call each signal.

#### player.component.html
```html
<h2>
    {% raw %}{{ name() }}{% endraw %}
</h2>
```

And that’s it. Now, when the player input changes, all of the other computed signals will change automatically too and we don’t need to worry about using `ngOnChanges`, the `changeDetectorRef`, or any of that stuff.

So, it’s pretty cool that all of this happens without us really needing to think about change detection, but we definitely need to think about things a little differently right? It’s just a different concept for sure.

So that’s inputs, but outputs are changing too. They are simplified with the new `output()` function.

## Replacing the Old @Output Decorator and EventEmitter with the New Output Function

For this component, we have an output that uses an `EventEmitter` to emit an event with a value of the current player object when the delete button is clicked.

#### player.component.ts
```typescript
@Output() playerRemoved = new EventEmitter<Player>();
```

We then react to that event in the app component to remove that player from the list. But, we no longer want to use the old `@Output decorator`, we want to use the new `output()` function, right?

Well, to do this, let’s start by removing the decorator. Let’s remove the import too. Now what’s cool about the new output function is that we don’t need the `EventEmitter` anymore either. The event emitting is all handled from this function now instead. So, let’s remove it and its import too.

Now, we just need to set the `playerRemoved` field equal to the new `output()` function and we need to make sure it gets imported too. Then, the last part here is to type the output to the Player object like we had before.

```typescript
import { output, ... } from '@angular/core';

@Component({
  selector: 'app-player',
  ...
})
export class PlayerComponent {
    playerRemoved = output<Player>();
}
```

Ok now to emit the event, we call it just as we did the EventEmitter, with the `emit()` function. So, our button can stay as is with the click event calling the `emit()` function on the output. In fact, we actually don’t need to change anything else for the output, it all works the same from here.

#### player.component.html
```html
<button (click)="playerRemoved.emit(this.player())">
    ...
</button>
```

And now, everything should be working correctly now with signals, the signal-based input, and the `output()` function.

{% include banner-ad.html %}

## Conclusion

So, here in this post, we’ve gotten a little taste of signals and how they work in Angular. We got a little glimpse into where things are headed with signal-based components. Hopefully what you saw here will help you as you build in Angular going forward.

Now, there’s still a lot more to signals like creating writable signals, and using effects, and more, so who knows, maybe I’ll create some more posts on them in the future.

## Want to See It in Action?
Check out the demo code and examples of these techniques in the Stackblitz example below. If you have any questions or thoughts, don’t hesitate to leave a comment.

<iframe src="https://stackblitz.com/edit/ttnwwm-pcav9k?ctl=1&embed=1&file=src%2Fapp%2Fplayer%2Fplayer.component.ts" style="height: 500px; width: 100%; margin-bottom: 1.5em; display: block;">
