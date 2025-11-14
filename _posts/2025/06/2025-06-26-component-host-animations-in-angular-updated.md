---
layout: post
title: "I Updated My Component Host Animation… Here’s the Angular 20 Way"
date: "2025-06-26"
video_id: "GyH-QDjxFyE"
tags:
  - "Angular"
  - "Angular Animations"
  - "Angular Components"
  - "Angular Signals"
  - "Angular Styles"
---

<p class="intro"><span class="dropcap">I</span>f you’ve been building Angular apps for a while, like I have, you know the framework evolves fast. In this tutorial I’m going to show you how to modernize an older app step-by-step using the latest Angular features… modern <a href="https://angular.dev/guide/components/host-elements#binding-to-the-host-element" target="_blank">host bindings</a> and events, <a href="https://youtu.be/nUEERAOZKwg" target="_blank">control flow</a>, and <a href="https://angular.dev/guide/components/inputs" target="_blank">signal inputs</a>. By the end, your code will be smaller, a little faster, and overall more modern. You’ll see exactly how to quickly modernize several aspects of an existing application.</p>

{% include youtube-embed.html %}

## Animating List Items in Angular

A couple years back, I built this little Angular demo showing how to use the [@HostBinding](https://angular.dev/api/core/HostBinding){:target="_blank"} decorator to bind an animation to a component [host](https://angular.dev/guide/components/host-elements){:target="_blank"}:

<div>
<img src="{{ '/assets/img/content/uploads/2025/06-26/demo-1.gif' | relative_url }}" alt="An example of an older Angular application using the @HostBinding decorator to bind a animation to a component host" width="728" height="1074" style="width: 100%; height: auto;">
</div>

Back then, it worked great. 

But Angular has come a long way and now we have some much cleaner, more powerful ways to write the logic behind this functionality.

Let’s look at the code that’s making this happen.

The [app component](https://stackblitz.com/edit/stackblitz-starters-wpjq4m2s?file=src%2Fapp.component.html){:target="_blank"} is where this list of players lives currently:

```html
<app-player 
    [player]="player" 
    *ngFor="let player of players; trackBy: trackByFn">
</app-player>
```

## Modernizing Control Flow: `@for` and `@if` Blocks

First off, this list is using the old [*ngFor](https://angular.dev/api/common/NgFor){:target="_blank"} structural directive.

This isn’t the way we want to do this anymore. 

Instead, we want to use a [@for](https://angular.dev/api/core/@for){:target="_blank"} block:

```html
@for (player of players; track player.name) {
    <app-player [player]="player"></app-player>
}
```

This is part of Angular’s modern built-in [control flow syntax](https://youtu.be/nUEERAOZKwg){:target="_blank"}.

It’s a little cleaner, no more asterisk, no structural directive needed. 

And instead of the old [TrackByFunction](https://angular.dev/api/core/TrackByFunction){:target="_blank"}, we now use "track" with a unique identifier, in this case, the player name.

Same idea, just nicer to read.

And because of that change, we no longer need the `trackBy` method in the component TypeScript:

```typescript
trackByFn(index: number, player: Player): string {
    return player.name;
}
```

We can just delete it. 

The [@for](https://angular.dev/api/core/@for){:target="_blank"} block takes care of tracking for us.

Now, let’s switch back to [the template](https://stackblitz.com/edit/stackblitz-starters-wpjq4m2s?file=src%2Fapp.component.html){:target="_blank"}, there were a couple more things that we can improve.

We’ve got two buttons that use [*ngIf](https://angular.dev/api/common/NgIf){:target="_blank"}, one for removing a player and one for adding:

```html
<button
    *ngIf="players.length > 0"
    (click)="removePlayer()"
    title="Remove Player"
    class="remove">
    <span class="cdk-visually-hidden">
        Remove Player
    </span>
</button>
<button
    *ngIf="players.length < totalCount"
    (click)="addPlayer()"
    title="Add Player"
    class="add">
    <span class="cdk-visually-hidden">
        Add Player
    </span>
</button>
```

We can modernize these too, using [@if](https://angular.dev/api/core/@if){:target="_blank"} instead of the structural directive:

```html
@if (players.length > 0) {
    <button
        (click)="removePlayer()"
        title="Remove Player"
        class="remove">
        <span class="cdk-visually-hidden">
            Remove Player
        </span>
    </button>
}
@if (players.length < totalCount) {
    <button
        (click)="addPlayer()"
        title="Add Player"
        class="add">
        <span class="cdk-visually-hidden">
            Add Player
        </span>
    </button>
}
```

Again, no more asterisk, no structural directive.

This is the new syntax Angular recommends moving forward, and once you start using it, you won’t want to go back.

Ok, this is cool but what does it have to do with host-binding animations?

Nothing, right?

## Cleaner Animations with Host Metadata

There aren’t even any animations in [this template](https://stackblitz.com/edit/stackblitz-starters-wpjq4m2s?file=src%2Fapp.component.html){:target="_blank"}.

Well, this is because we’re using the [@HostBinding](https://angular.dev/api/core/HostBinding){:target="_blank"} decorator in the [player component](https://stackblitz.com/edit/stackblitz-starters-wpjq4m2s?file=src%2Fplayer%2Fplayer.component.ts){:target="_blank"} for this animation. 

So, let's take a look at this component because this is where the animations live.

Here, we’ve got a [@HostBinding](https://angular.dev/api/core/HostBinding){:target="_blank"} decorator to bind the animation on the component host:

```typescript
@HostBinding('@enterLeaveAnimation') animate = true;
```

And then two [@HostListener](https://angular.dev/api/core/HostListener){:target="_blank"} decorators. 

One for when the animation starts, and one for when it’s done:

```typescript
@HostListener('@enterLeaveAnimation.start') start() {
    document.body.style.backgroundColor = 'yellow';
}

@HostListener('@enterLeaveAnimation.done') done() {
    document.body.style.backgroundColor = 'white';
}
```

But here’s the thing, while these decorators are still supported, they’re not the recommended way to bind things on the component [host](https://angular.dev/guide/components/host-elements){:target="_blank"} anymore.

We want to do this with the `host` property instead now.

We’ll switch this over in a minute, but first let’s look at the animation itself.

Here we can see that we’re using an external animation:

```typescript
import { enterLeaveAnimation } from '../animation';

@Component({
    selector: 'app-player',
    ...,
    animations: [
        enterLeaveAnimation
    ]
})
```

Let’s look at this file real quick to better understand how it works:

```typescript
import { style, trigger, transition, animate } from '@angular/animations';

export const enterLeaveAnimation = trigger('enterLeaveAnimation', [
    transition(':enter', [
        style({opacity: 0, transform: 'scale(0.8)'}),
        animate('500ms ease-in', 
            style({opacity: 1, transform: 'scale(1)'}))
    ]),
    transition(':leave', [
        style({opacity: 1, transform: 'scale(1)'}),
        animate('500ms ease-in', 
            style({opacity: 0, transform: 'scale(0.8)'}))
    ]),
]);
```

It’s just a simple "enter" and "leave" animation.

The [:enter](https://angular.dev/guide/animations/transition-and-triggers#aliases-enter-and-leave){:target="_blank"} alias allows us to animate an element when it's added to the DOM, and the [:leave](https://angular.dev/guide/animations/transition-and-triggers#aliases-enter-and-leave){:target="_blank"} alias does the opposite, it animates items as they leave the DOM.

Okay, now that we know how this works, let’s go back to the [player component](https://stackblitz.com/edit/stackblitz-starters-wpjq4m2s?file=src%2Fplayer%2Fplayer.component.ts){:target="_blank"} and switch over to the `host` property.

First, we add a new `host` property inside the component decorator and then add a binding for the animation like this:

```typescript
@Component({
    selector: 'app-player',
    ...,
    host: {
        '[@enterLeaveAnimation]': ''
    }
})
```

That’s it, now the animation is bound to the component host without using the [@HostBinding](https://angular.dev/api/core/HostBinding){:target="_blank"} decorator.

And, since we’re doing it this way now, we don’t need the old [@HostBinding](https://angular.dev/api/core/HostBinding){:target="_blank"} decorator anymore, so it can be removed.

Next, we can move the “start” and "done" events to the host property too.

We use parentheses for this just as we would for events in the template.

Then we just need to call our "start" and "done" methods for these:

```typescript
@Component({
    selector: 'app-player',
    ...,
    host: {
        '[@enterLeaveAnimation]': '',
        '(@enterLeaveAnimation.start)': 'start()',
        '(@enterLeaveAnimation.done)': 'done()'
    }
})
```

Now we don’t need the `@HostListener` decorators anymore, so they can be removed as well.

Now before we finish, there’s one more modern pattern we'll definitely want to use here: [signal inputs](https://angular.dev/guide/signals#signal-inputs).

## Upgrading to Signal Inputs

Right now, this uses the classic [@Input](https://angular.dev/api/core/Input){:target="_blank"} decorator:

```typescript
@Input({required: true}) player!: Player;
```

But modern Angular gives us a newer way, using [signal inputs](https://angular.dev/guide/components/inputs){:target="_blank"}, which makes the component more reactive.

So, we just need to switch this over to the new input function:

```typescript
import { ..., input } from '@angular/core';

readonly player = input.required<Player>();
```

Then, we can remove the old decorator import too.

Now, we’re not done yet… over in the template we need to update it to use this new [signal](https://angular.dev/guide/signals){:target="_blank"}.

What I’m going to do is create a [template variable](https://youtu.be/DYDzf2JOOho){:target="_blank"} here with the [@let](https://youtu.be/DYDzf2JOOho){:target="_blank"} syntax called "playerVar".

Then I’ll set this to the signal input.

```html
@let playerVar = player();
```

Then I just need to update all instances of the old “player” property:

#### Before:
```html
<img [ngSrc]="'/assets/' + player.imageName + '.avif'" width="1040" height="760" />
<h2>{{ player.name }}</h2>
<dl>
    <div>
        <dt>
            GP
        </dt>
        <dd>
            {% raw %}{{ player.games | number }}{% endraw %}
        </dd>
    </div>
    <div>
        <dt>
            PTS
        </dt>
        <dd>
            {% raw %}{{ player.points | number }}{% endraw %}
        </dd>
    </div>
    <div>
        <dt>
            FG%
        </dt>
        <dd>
            {% raw %}{{ player.fieldGoalPercentage | percent:'.1' }}{% endraw %}
        </dd>
    </div>
    <div>
        <dt>
            3P%
        </dt>
        <dd>
            {% raw %}{{ player.threePointPercentage | percent:'.1' }}{% endraw %}
        </dd>
    </div>
</dl>
```

#### After:
```html
@let playerVar = player();
<img [ngSrc]="'/assets/' + playerVar.imageName + '.avif'" width="1040" height="760" />
<h2>{{ playerVar.name }}</h2>
<dl>
    <div>
        <dt>
            GP
        </dt>
        <dd>
            {% raw %}{{ playerVar.games | number }}{% endraw %}
        </dd>
    </div>
    <div>
        <dt>
            PTS
        </dt>
        <dd>
            {% raw %}{{ playerVar.points | number }}{% endraw %}
        </dd>
    </div>
    <div>
        <dt>
            FG%
        </dt>
        <dd>
            {% raw %}{{ playerVar.fieldGoalPercentage | percent:'.1' }}{% endraw %}
        </dd>
    </div>
    <div>
        <dt>
            3P%
        </dt>
        <dd>
            {% raw %}{{ playerVar.threePointPercentage | percent:'.1' }}{% endraw %}
        </dd>
    </div>
</dl>
```

Using a template variable like this means we can reference "playerVar" directly, without having to write `player()` with parentheses every time.

But, since it’s now a local variable, I do have to change the name. So, pick your poison!

Alright, I think we’ve got everything, let’s save it and take a look in the browser:

<div>
<img src="{{ '/assets/img/content/uploads/2025/06-26/demo-1.gif' | relative_url }}" alt="An example of an older Angular application using the @HostBinding decorator to bind a animation to a component host" width="728" height="1074" style="width: 100%; height: auto;">
</div>

There we go, add a player, nice entrance animation, remove a player, smooth exit animation. 

And everything works exactly as it should.

But now the code is more modern, and ready for anything Angular throws at us in future updates.

## Final Result & Key Takeaways

So that’s it… a quick refactor of an older app using Angular modern syntax: new [control flow](https://angular.dev/api/core/@for){:target="_blank"}, [signal inputs](https://angular.dev/guide/signals#signal-inputs){:target="_blank"}, and cleaner [host bindings](https://angular.dev/guide/components/host-elements#binding-to-the-host-element){:target="_blank"}.

If you’re building apps in Angular today, these patterns will help you write clearer, more reactive code, and they’ll keep your apps easy to maintain long-term.

If you found this helpful, don't forget to [subscribe](https://www.youtube.com/c/briantreese?sub_confirmation=1) and check out [my other Angular tutorials](https://www.youtube.com/@briantreese) for more tips and tricks!

{% include banner-ad.html %}

## Additional Resources
- [The demo app BEFORE any changes](https://stackblitz.com/edit/stackblitz-starters-wpjq4m2s?file=src%2Fplayer%2Fplayer.component.ts)
- [The demo app AFTER making changes](https://stackblitz.com/edit/stackblitz-starters-fn4kkkzz?file=src%2Fplayer%2Fplayer.component.ts)
- [The original tutorial from 2023](https://youtu.be/fS5KLM2johA)
- [Announcing Angular v20](https://blog.angular.dev/announcing-angular-v20-b5c9c06cf301)
- [Angular flow control basics](https://youtu.be/nUEERAOZKwg)
- [Binding to the host element](https://angular.dev/guide/components/host-elements#binding-to-the-host-element)
- [More on Angular Animations](https://www.youtube.com/playlist?list=PLp-SHngyo0_ikgEN5d9VpwzwXA-eWewSM)
- [My course: "Angular: Styling Applications"](https://www.pluralsight.com/courses/angular-styling-applications)

## Want to See It in Action?

Want to experiment with the final version? Explore the full StackBlitz demo below. If you have any questions or thoughts, don’t hesitate to leave a comment.

<iframe src="https://stackblitz.com/edit/stackblitz-starters-fn4kkkzz?ctl=1&embed=1&file=src%2Fplayer%2Fplayer.component.ts" style="height: 500px; width: 100%; margin-bottom: 1.5em; display: block;"></iframe>