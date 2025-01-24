---
layout: post
title: "Angular Host Binding Animations"
date: "2023-10-20"
video_id: "fS5KLM2johA"
tags: 
  - "Angular"
  - "Animations"
---

<p class="intro"><span class="dropcap">A</span>ngular provides many ways to animate things. In this post we are going to look specifically at adding <code>:enter</code> and <code>:leave</code> animations to a component as it gets added and removed from the UI. We’re going to do this with the Angular <code>@HostBinding</code> decorator and the enter and leave aliases for animations. Alright, let’s check it out!</p>

<iframe width="560" height="315" src="https://www.youtube.com/embed/fS5KLM2johA?si=s1EWRLV9E0aqM9Ra" title="YouTube video player" frameborder="0" allow="accelerometer; autoplay; clipboard-write; encrypted-media; gyroscope; picture-in-picture; web-share" allowfullscreen></iframe>

## Angular :enter and :leave Animation Example

Something that we’re missing in CSS animations, at the moment, is the ability to animate elements as they’re added to or removed from the DOM. Luckily, we’re using Angular. At least in this post we are. And, this means that we can use Angular’s animation framework for this exact thing.

In our example here, when we add list items, we see that they ease in. And, likewise when we remove them, they ease out too. If you haven’t seen this before, here’s how it works. When items are added, they’ll animate in using this transition based on the enter state.

### animation.ts
```typescript
transition(':enter', [
  style({opacity: 0, transform: 'scale(0.8)'}),
  animate('500ms ease-in', style({opacity: 1, transform: 'scale(1)'}))
])
```

And when they’re removed, they will use this transition based on the leave state.

```typescript
transition(':leave', [
  style({opacity: 1, transform: 'scale(1)'}),
  animate('500ms ease-in', style({opacity: 0, transform: 'scale(0.8)'}))
])
```

Currently this animation is added right here in our app component.

### main.ts
```typescript
@Component({
  selector: 'my-app',
  ...
  animations: [
    enterLeaveAnimation
  ]
})
export class App {
  ...
}
```

And the trigger is applied to the items here in the template with the ngFor.

### app.component.html
```html
<div
  @enterLeaveAnimation
  *ngFor="let player of players; trackBy: trackByFn">
  <app-player [player]="player"></app-player>
</div>
```

When this list data changes, items are either added or removed which properly triggers our animation. But, what I’d rather do is automatically bind this enter and leave transition to the player component so that it’ll easily animate the same way every time we use it.

## Using the Angular @HostBinding Decorator to Bind an :enter and :leave Animation to a Component Host

Good news, we can do this pretty easily with the `@HostBinding` decorator within our player component. Before we can do this, there’s a couple things we need to do.

First, we need to import our animation and add it to the animations array in our component metadata.

### player.component.ts
```typescript
import { enterLeaveAnimation } from '../animation';

@Component({
  selector: 'app-player',
  ...
  animations: [
    enterLeaveAnimation
  ]
})
export class PlayerComponent {
  ...
}
```

Often, I put my animations in their own file just to reduce the amount of code in the component itself, but you can just add your animations right here in the array if you prefer.

Next, you’ll need to make sure to import the host binding decorator.

```typescript
import { HostBinding } from '@angular/core';
```

Ok, now we can bind the animation on our component. We start by adding the host binding decorator. Then we bind our animation. This looks exactly like it did in the template. Then, we bind to a property, let’s call it animate. To make sure that the animation is always bound on our host, we simply need to set it to true.

```typescript
@Component({
  selector: 'app-player',
  ...
})
export class PlayerComponent {
  @HostBinding('@enterLeaveAnimation') animate = true;
  ...
}
```

Then we can remove the animation from our app template, and from the component metadata. Alright, now when we add items to our list, we'll see that the animation is applied properly. This is pretty slick right?

But when we remove them it looks like the animation on leave is not functioning properly. We’ll there’s a reason for this. When we look back at our app component template, our `*ngFor` is applied to this wrapping `div`.

```html
<div *ngFor="let player of players; trackBy: trackByFn">
  <app-player [player]="player"></app-player>
</div>
```

Now, this worked in our original set up because we had the animation applied to the item with the `*ngFor` directly. It was on this div. Now however, it’s on our player component. Well, in our case there’s really no reason to have this div anymore, so I can simply remove it and move the `*ngFor` directly to the player component.

```html
<app-player *ngFor="let player of players; trackBy: trackByFn" [player]="player"></app-player>
```

I added this to the demo just to point out that this is an issue that you may encounter as you do this sort of thing. So don’t say I didn’t warn you.

So now, everything still looks great as they’re added. And, when we remove them, they animate like they should.

So, this just makes it nice that as our app grows and we need to use this player component elsewhere, we won’t need to worry about adding the animation, it just comes for free.

## Animation Start and Done Callback Events on a Component Host with @HostListener

Now, something else we can do here is, we can use the angular animation callback functions to react to our start and done state. For this we will use the host listener decorator within our component. So just like when we used the host binding decorator, we’ll need to import the host listener.

### player.component.ts
```typescript
import { HostListener } from '@angular/core';
```

Now we can add it. To bind to the start event, we add our animation trigger, then a dot, and then the word start. When this event fires we’ll run a function called start. For this example we’ll just change the background of the body element. We’ll change it to yellow when the animation starts.

```typescript
export class PlayerComponent {
  ...

  @HostListener('@enterLeaveAnimation.start') start() {
    document.body.style.backgroundColor = 'yellow';
  }
}
```

Now, let’s wire up to the done event to set it back to white. For this, everything will be the same accept we’re going to use the word done, call a done function, and set the background color to white.

```typescript
export class PlayerComponent {
  ...

  @HostListener('@enterLeaveAnimation.done') done() {
    document.body.style.backgroundColor = 'white';
  }
}
```

Cool, the body turns yellow when we add and remove players. So, this is a really nice way to encapsulate the animations needed for a given component, even when they’re applied to the host itself.

{% include banner-ad.html %}

In this case, I tried to keep it simple with the ``:enter` and `:leave` example, but there’s a lot more advanced animation that could be done using everything that we’ve see here.

Now remember, when using `*ngFor` and `:enter`/`:leave` animations, your animation trigger needs to be applied to the same item as the `*ngFor`.

## Want to See It in Action?
Check out the demo code and examples of these techniques in the in the stackblitz example below. If you have any questions or thoughts, don’t hesitate to leave a comment.

<iframe src="https://stackblitz.com/edit/stackblitz-starters-z3wpc9?ctl=1&embed=1&file=src%2Fplayer%2Fplayer.component.ts" style="height: 500px; width: 100%; margin-bottom: 1.5em; display: block;">