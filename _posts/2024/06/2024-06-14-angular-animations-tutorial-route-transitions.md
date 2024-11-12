---
layout: post
title: "Angular Animations: Router Transitions"
date: "2024-06-14"
video_id: "7d8UDEKT1pU"
tags: 
  - "Angular"
  - "Angular Animations"
---

<p class="intro"><span class="dropcap">I</span>f you’ve ever worked with an Angular application that has <a href="https://angular.dev/guide/routing">routing</a>, you may have wanted to add transitions as you navigate between routes. It just makes the app feel more elegant overall. Well, if you didn’t know, this is totally doable with the <a href="https://angular.dev/guide/animations">Animation module</a> and in this example, I’ll show you just how easy it is. Alright, let’s get to it.
</p>

<iframe width="1280" height="720" src="https://www.youtube.com/embed/7d8UDEKT1pU" title="" frameborder="0" allow="accelerometer; autoplay; clipboard-write; encrypted-media; gyroscope; picture-in-picture; web-share" allowfullscreen></iframe>

## Before We Get Started

Now, before we get too far along, it’s important to note that I’ve already created several posts focused on the animation framework in Angular.

#### Angular Animation Tutorials:
- [Learn the Basics]({% post_url /2024/02/2024-02-09-angular-animations-tutorial-learn-the-basics %})
- [Enter and Leave Animations]({% post_url /2024/02/2024-02-16-angular-animations-tutorial-enter-and-leave %}) 
- [The Keyframes Function]({% post_url /2024/02/2024-02-23-angular-animations-tutorial-the-keyframes-function %})
- [Query and Stagger Function]({% post_url /2024/03/2024-03-01-angular-animations-tutorial-query-and-stagger %})
- [Start and Done Events]({% post_url /2024/03/2024-03-08-angular-animations-tutorial-start-and-done-events %})
- [Parallel Animations]({% post_url /2024/03/2024-03-15-angular-animations-tutorial-parallel-animations %})
- [Animating to an unknown height]({% post_url /2024/03/2024-03-29-angular-animations-tutorial-animating-height %})
- [Adding Flexibility with Params]({% post_url /2024/05/2024-05-04-angular-animations-tutorial-add-flexibility-with-params %})
- [Creating Reusable Animations]({% post_url /2024/05/2024-05-11-angular-animations-tutorial-creating-reusable-animations %})
- [Disable and Enable Animations]({% post_url /2024/05/2024-05-19-angular-animations-tutorial-disable-and-enable-animations %})

These posts cover many different animation topics so if any of these concepts look unfamiliar to you, you’ll probably want to check these posts out first, so that you’re not lost in this example.

And, to make them easier to find, I’ve created an [Angular Animations playlist](https://youtube.com/playlist?list=PLp-SHngyo0_ikgEN5d9VpwzwXA-eWewSM&si=3WnQgeDxdAZJGGFy) on my [YouTube channel](https://www.youtube.com/@briantreese) to help, so check it out!

Ok, enough of that, onto the example for this post.

<div class="shirt-ad">
<a href="https://devdrip.creator-spring.com" title="Click to get yourself some fresh Angular merch!">
<img src="{{ '/assets/img/dev-drip-banner.png' | relative_url }}" alt="Swoop up some hip new Angular drip! - Dev Drip Merch Shop" width="960" height="275" style="width: 100%; height: auto;"></a>
</div>

## The Demo Application

For this example we’ll be using this simple [demo application](https://stackblitz.com/edit/stackblitz-starters-dn697m?file=src%2Fmain.ts). We have a few different pages that we can navigate to. This app has already been set up with [routing](https://angular.dev/guide/routing) so when we click the links in the main nav we will navigate to the appropriate page.

<div>
<img src="{{ '/assets/img/content/uploads/2024/06-14/demo-1.gif' | relative_url }}" alt="Example of a simple application built with Angular and the Angular Routing Module and no route transitions" width="840" height="980" style="width: 100%; height: auto;">
</div>

But when we navigate to the different pages, it would be better if we had some sort of transition. Maybe some sort of crossfade as we’re seeing here:

<div>
<img src="{{ '/assets/img/content/uploads/2024/06-14/demo-2.gif' | relative_url }}" alt="Example of a simple application built with Angular and the Angular Routing Module and and route transitions" width="836" height="980" style="width: 100%; height: auto;">
</div>

Well, this is exactly what we’re going to do in this example. But first, let’s look at the existing code to better understand what we need.

## The Existing Code

Ok, so like mentioned, this app has already been set up with [routing](https://angular.dev/guide/routing). So, if we take a look at the [app component](https://stackblitz.com/edit/stackblitz-starters-dn697m?file=src%2Fmain.ts), in the template we have a [router-outlet](https://angular.dev/api/router/RouterOutlet).

#### main.ts
```typescript
@Component({
    selector: 'app-root',
    template: `
        <app-nav></app-nav>
        <router-outlet></router-outlet>
    `,
    ...
})
export class App {
}
```

When we click any of the links in the navigation component, the routed component will be inserted as a sibling of the [router-outlet](https://angular.dev/api/router/RouterOutlet) element. If we look at the [route config](https://stackblitz.com/edit/stackblitz-starters-dn697m?file=src%2Froutes.ts), we can see that this is where we’ve provided both the path that we want to see in the address bar as well as the component that we want to display when navigating to that path.

So, when we navigate to the “blog” path for example, the BlogComponent will be displayed.

```typescript
{
    path: 'blog',
    component: BlogComponent,
    title: 'Our Blog',
}
```

Or if we navigate to the “contact” path, the ContactComponent will be displayed.

```typescript
{
    path: 'contact',
    component: ContactComponent,
    title: 'Contact Us',
}
```

You get the idea. So, what this means as that the active component for the new route will be considered an “entering” item as far as Angular animations are concerned. And the component from the previous path will be considered a “leaving” item. This means, we’ll have a way to animate them both.

Now, if you’re unfamiliar with the concept of “:enter” and “:leave” animations, I’ve got a [video here](https://youtu.be/tDXkcITKDDY) for you, so be sure to check it out to better understand the concept.

## Creating the Route Transition Animation

Ok, now that we have an understanding of how this all works currently, let’s start by creating our animation. To do this, we’ll start by adding a new file for the animation code, let’s name it “route-transition.ts”.

Now, let’s add an exportable const so that we’ll be able to import this animation into our app component. Let’s call it "routeTransition". We will set it using the [trigger() function](https://angular.dev/api/animations/trigger) from the Angular animations module. For the name, we can call it routeTransition as well.

#### route-transition.ts
```typescript
import { trigger } from '@angular/animations';

export const routeTransition = trigger('routeTransition', [
]);
```

Ok, next we need a [transition() function](https://angular.dev/api/animations/transition). For this route transition, we will want it to run whenever the route data changes. So, we’ll animate from any state with the asterisk to any other state.

```typescript
import { ..., transition } from '@angular/animations';

export const routeTransition = trigger('routeTransition', [
    transition('* => *', [
    ])
]);
```

Now, the first thing that we’ll want to do in this animation is set the item entering to start from a “hidden” state. So, let’s add the [query() function](https://angular.dev/api/animations/query) to query for the entering component. Then we’ll add the [style() function](https://angular.dev/api/animations/style) so that we can provide the starting styles. We’ll start with an opacity of zero, and a scale of point nine. The last thing we need to do is add the optional flag for when no entering items are found.

```typescript
import { ..., query, style } from '@angular/animations';

export const routeTransition = trigger('routeTransition', [
    transition('* => *', [
        query(':enter', [
            style({ opacity: 0, scale: 0.9 }),
        ], { optional: true })
    ])
]);
```

Ok, next we’ll transition the leaving component. So, let’s add another [query() function](https://angular.dev/api/animations/query) and query for leaving items this time.

For this item, we don’t need any starting styles since it will automatically start from a fully opaque, full scaled size. All we need to do is add the animation so we can add the [animate() function](https://angular.dev/api/animations/animate). To make sure we can really see this animation, let’s start out by animating over one second. Then let’s add the style we’re animating to with another [style() function](https://angular.dev/api/animations/style).

We’ll want to animate to an opacity of zero, and a scale of point nine. And then this needs to be optional as well.

```typescript
import { ..., animate } from '@angular/animations';

export const routeTransition = trigger('routeTransition', [
    transition('* => *', [
        ...,
        query(':leave', [
            animate('1s', style({ opacity: 0, scale: 0.9 }))
        ], { optional: true })
    ])
]);
```

Ok, the last thing we need to do is animate the entering item to its final visible state. So, let’s add another [query()](https://angular.dev/api/animations/query) and query for entering items.

Since we already set its starting style, we can just add the [animate() function](https://angular.dev/api/animations/animate) to animate to the final state. We’ll animate over one second again. Then let’s add another style function and we’ll animate to an opacity of one, and a scale of one too. Then we just need to make it optional.

```typescript
export const routeTransition = trigger('routeTransition', [
    transition('* => *', [
        ...,
        query(':enter', [
            animate('1s', style({ opacity: 1, scale: 1 }))
        ], { optional: true })
    ])
]);
```

Ok, that should be everything we need for the animation. Now we can switch over and add it to the app component.

### Adding the Route Transition Animation to the Parent Component

To use the animation, let’s first add the animations array in our component metadata. Within this array, let’s add our new "routeTransition" animation.

#### main.ts
```typescript
import { routeTransition } from './route-transition';

@Component({
    selector: 'app-root',
    ...,
    animations: [
        routeTransition
    ]
})
export class App {
}
```

Ok, so now we can wire this up But before we do, it’s important to understand how this layout works. It uses a grid. The first column is for the navigation and the second column is for the routed components. Anything that is a sibling of the [router-outlet](https://angular.dev/api/router/RouterOutlet) will be placed into the second grid column, meaning both the entering and leaving items will exist within this column on top of one another.

<div>
<img src="{{ '/assets/img/content/uploads/2024/06-14/demo-3.gif' | relative_url }}" alt="Diagram explaining the columns of the overall grid layout" width="1016" height="1078" style="width: 100%; height: auto;">
</div>

The bummer here is that we need to add a container around the [router-outlet](https://angular.dev/api/router/RouterOutlet) in order to properly bind our animation since it needs to be able to query for entering and leaving items.

But, that’s ok, we can set it to [`display: contents`](https://developer.mozilla.org/en-US/docs/Web/CSS/display#contents) so it will essentially be invisible. So, let’s add a div and on this div let’s add a style with display, contents.

```html
<div style="display: contents">
    <router-outlet></router-outlet>
</div>
```

Ok so this is where we’ll bind our animation trigger, but what will we bind it to in order to trigger it when changing routes?

### Triggering the Route Transition when Changing Routes

Well, for this we can use the [ActivatedRoute](https://angular.dev/api/router/ActivatedRoute) [snapshot](https://angular.dev/api/router/ActivatedRouteSnapshot) data object.

To do this, we need to add a constructor. Then we need to inject in the [ActivatedRoute](https://angular.dev/api/router/ActivatedRoute). Let’s create a protected field named “route”, and then we need to inject in the [ActivatedRoute](https://angular.dev/api/router/ActivatedRoute) class.

```typescript
import { ..., ActivatedRoute } from '@angular/router';

@Component({
    selector: 'app-root',
    ...
})
export class App {
    constructor(protected route: ActivatedRoute) {
    }
}
```

Now, let’s bind our animation trigger on the div. We’ll bind to the route, snapshot, data object. This object is updated every time the route changes so it should properly trigger our animation.

```html
<div [@routeTransition]="route.snapshot.data" style="display: contents">
    <router-outlet></router-outlet>
</div>
```

Ok, we’re almost there, but before this animation will run, we need to enable animations by adding the [provideAnimations() function](https://angular.dev/api/platform-browser/animations/provideAnimations) to our providers array.

```typescript
import { provideAnimations } from '@angular/platform-browser/animations';

bootstrapApplication(App, {
    providers: [ 
        ...,
        provideAnimations()
    ]
});
```

Ok, so that should be everything we need to properly transition when navigating between routes. So, let’s save and try it out.

<div>
<img src="{{ '/assets/img/content/uploads/2024/06-14/demo-4.gif' | relative_url }}" alt="Example of Angular Route Transitions working correctly but with a very slow duration" width="880" height="1080" style="width: 100%; height: auto;">
</div>

Nice, looks like it’s properly animating both the component that is leaving and then animating the component that is entering. Now, it looks a little odd, primarily because of how slow it animates but, if you remember, we are animating over one second for the leaving item and then one more second for the entering item. This is pretty slow for these types of transitions, but I just really wanted to illustrate how this animation works.

Now that we can see it working, and understand it, let’s switch to a duration like point two seconds instead.

#### route-transition.ts
```typescript
export const routeTransition = trigger('routeTransition', [
    transition('* => *', [
        ...,
        query(':leave', [
            animate('0.2s', ...)
        ], ...),
        query(':enter', [
            animate('0.2s', ...)
        ], ...)
    ])
]);
```

Now let’s save and try it again.

<div>
<img src="{{ '/assets/img/content/uploads/2024/06-14/demo-5.gif' | relative_url }}" alt="Example of Angular Route Transitions working correctly but with a better, quicker duration" width="880" height="1078" style="width: 100%; height: auto;">
</div>

There, much better.

## Conclusion

Of course, there’s many different ways to animate this type of thing, your imagination is really all that’s holding you back because now you know everything else you need to add route transitions in your Angular applications.

Now, there’s still plenty more to cover on angular animations so I’ll go ahead and stop here for now, but keep an eye out for more posts in the future.

## Want to See It in Action?
Check out the demo code and examples of these techniques in the in the Stackblitz example below. If you have any questions or thoughts, don’t hesitate to leave a comment.

<iframe src="https://stackblitz.com/edit/stackblitz-starters-lgwtkw?ctl=1&embed=1&file=src%2Fmain.ts" style="height: 500px; width: 100%; margin-bottom: 1.5em; display: block;">
 