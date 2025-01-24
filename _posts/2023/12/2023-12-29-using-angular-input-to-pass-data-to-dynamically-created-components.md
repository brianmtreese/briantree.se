---
layout: post
title: "Use Inputs to Pass Data to Dynamically Created Angular Components"
date: "2023-12-29"
video_id: "MT2JP8pn1qU"
tags: 
  - "Angular"
---

<p class="intro"><span class="dropcap">I</span>f you’re using dynamically created components in Angular, you’ve probably found it difficult to pass information between the parent and child components when needed. You need to provide the info in the parent and then inject it within the child component. While it’s not necessarily difficult to do, it results in a lot of extra boilerplate code. It would be so much better if we could just use the `@Input` decorator like we’re used to. Well, guess what? Angular supports doing this exact thing as of version sixteen. In this post, I’ll show you how. Alright, let’s get to it.</p>

<iframe width="560" height="315" src="https://www.youtube.com/embed/MT2JP8pn1qU?si=Nbir9Qce-fIM0srR" title="YouTube video player" frameborder="0" allow="accelerometer; autoplay; clipboard-write; encrypted-media; gyroscope; picture-in-picture; web-share" allowfullscreen></iframe>

## Passing Data the Old Way Using the Angular Injector

First, let’s look at how we used to pass data to dynamically created components from the parent. Here, in this example, within the component template, we have our `*ngComponentOutlet`, and we’re passing it our player component. In this case we’re also passing a custom child injector and this is how we’d inject the data for the child component before.

### main.ts

```typescript
@Component({
    selector: 'app-root',
    template: `
        <ng-container *ngComponentOutlet="playerComponent; injector: childInjector"></ng-container>
    `
})
export class App {
    protected playerComponent = PlayerComponent;
}
```

And to create this child injector, we needed to create a property so that it could be set and then used within the template.

```typescript
export class App {
    protected childInjector?: Injector;
    ...
}
```

Then we needed to inject in the Injector from angular core within the constructor.

```typescript
export class App {
    ...
    constructor(private injector: Injector) {
    }
}
```

After that we needed to set the child injector using the create method and the providers array to provide our player token to the child.

```typescript
export class App {
    ...
    constructor(private injector: Injector) {
        this.childInjector = Injector.create({
            providers: [
                { provide: PlayerToken, useValue: this.player }
            ],
            parent: this.injector
        });
    }
}
```

And finally, over in the child component, our player component, we needed to set our player property with the inject method from angular core.

### player.component.ts

```typescript
export class PlayerComponent {
    protected player?: Player = inject(PlayerToken);
}
```

So, all of this just to pass a simple player object to a dynamic component. I mean, if this wasn’t a dynamic component, we’d simply make this an `@Input` and just bind the player data object to the `@Input` in the parent. But this is a dynamically created component so we can’t do this right?

We’ll as of Angular sixteen, we actually can use `@Input`s instead and it’s much simpler than what we’ve seen so far.

## Passing Data the New Way Using the `*ngComponentOutlet` Inputs Object

We start by changing this player property to an `@Input` instead. And, it’s simply typed to our player interface.

### player.component.ts

```typescript
export class PlayerComponent {
    @Input() player?: Player;
}
```

Now we can remove the inject method and player token imports since they’re no longer needed. Then, back over in our parent, in the template we can remove the injector, and instead replace it with an inputs object. We can pass this object any number of inputs. So, if we had five inputs, we’d just include their names, and then pass each one whatever data we need. But in this case, we have only one input on our child component, player, so that’s all we need to pass it.

### main.ts

```typescript
@Component({
    selector: 'app-root',
    template: `
        <ng-container *ngComponentOutlet="playerComponent; inputs: { player }"></ng-container>
    `
})
```

Now we can remove the child injector. This means we can also remove the constructor altogether. And finally, we can remove the Injector from angular core and the player token import since were no longer using them.

```typescript
export class App {
    protected player: Player = {
        name: 'LeBron James',
        games: 1421,
        points: 38652,
        fieldGoalPercentage: 0.505,
        threePointPercentage: 0.345,
        imageName: 'lebron-james'
  };
  protected playerComponent = PlayerComponent;
}
```

And that’s it. We can see everything works just as it used to. So quite a bit easier to pull off and less code too which is always great.

{% include banner-ad.html %}

One bummer though is that while `@Input`s are supported, `@Output`s aren’t. Kind of a bummer, but it is what it is. Hopefully they’ll add support in the future because this would be very handy as well, but we’ll just have to wait and see.

## Want to See It in Action?
Check out the demo code and examples of these techniques in the in the stackblitz example below. If you have any questions or thoughts, don’t hesitate to leave a comment.

<iframe src="https://stackblitz.com/edit/stackblitz-starters-9xzkkf?ctl=1&embed=1&file=src%2Fmain.ts" style="height: 500px; width: 100%; margin-bottom: 1.5em; display: block;">  
