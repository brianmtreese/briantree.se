---
layout: post
title: "Create a Custom Loading Screen in Your Angular App"
date: "2024-07-05"
video_id: "C6XGJlusNqY"
tags:
  - "Angular"
  - "Angular Styles"
---

<p class="intro"><span class="dropcap">I</span>f you’ve built apps in angular in the past, I’m sure you’ve experienced the blank screen while you wait for the app to be bootstrapped. In smaller applications, it’s not as noticeable but in larger, more complex applications, we may need to wait for a little bit before we see the actual content loaded. And staring at a blank screen while we wait is not ideal. Well, we can upgrade this experience by adding our own custom loading screen and it’s pretty easy to do too. In this example that’s exactly what we’re going to do.</p>

<iframe width="1280" height="720" src="https://www.youtube.com/embed/C6XGJlusNqY" title="" frameborder="0" allow="accelerometer; autoplay; clipboard-write; encrypted-media; gyroscope; picture-in-picture; web-share" allowfullscreen></iframe>

## How to Keep the Loading Screen Visible During Development

So, in order to work on our loading screen, we’re going to need to be able to see it right? We’ll need to do something to make it visible and keep it that way.

Well, I’ve found that the easiest way to do this is to simply comment out the `bootstrapApplication()` function.

#### main.ts

```typescript
...

// bootstrapApplication(App,{
//   providers: [
//     provideAnimations()
//   ]
// });
```

This is the function that basically creates the Angular application, so by removing it, the app component and everything within it shouldn’t load.

If we save, we'll see that the loading screen will remain visible now.

So now we’re ready to work on it.

## Adding Markup and Styles for a More Captivating Loading Screen

The concept for this loading screen is pretty basic. If we look at the markup in the index document, we can see that we have the `app-root` element here, which is the root component for our app, and within it there’s the word “loading…”.

#### index.html

```html
<app-root>Loading...</app-root>
```

So, what happens here is that whatever content we place within the opening and closing tags of the `app-root` element will be visible while the application is bootstrapped.

Then, once it has been bootstrapped, that content will be replaced with the content from the app root component itself.

So, all we need to do is add some styles and mark-up here to make this look more in line with our branding and application overall. We will even include the styles for this loading page right here in an embedded stylesheet too.

```html
<app-root>
  <style>
    html,
    body {
      height: 100%;
    }

    body {
      color: #6244b0;
      display: grid;
      place-items: center;
      text-align: center;
    }
  </style>
  <section>
    <img src="assets/loader.png" />
    <h1>PETPIX</h1>
  </section>
</app-root>
```

Ok, I think that should be everything that we need so let’s save and see how it looks.

<div style="text-align: center">
<img src="{{ '/assets/img/content/uploads/2024/07-12/demo-1.gif' | relative_url }}" alt="Example of a custom loading screen in Angular" width="592" height="980" style="width: 100%; height: auto; max-width: 592px;">
</div>

And there it is, pretty cool right? Much better than the old blank loading screen.

Now we can go and add back our bootstrap function, but I’m also going to wrap it in a `setTimeout()` to delay it a little bit.

#### main.ts

```typescript
...

setTimeout(() => {

  bootstrapApplication(App,{
    providers: [
      provideAnimations()
    ]
  });

}, 3000);
```

Now I wouldn’t normally want to do this, but this demo app is really small and loads super fast so I just need to slow it down a little so that we can actually see the loading screen before the app loads.

Ok, now when we save, we'll see the new loading screen for three seconds and then the app loads.

<div style="text-align: center">
<img src="{{ '/assets/img/content/uploads/2024/07-12/demo-2.gif' | relative_url }}" alt="Example of a custom loading screen in Angular with the bootstrap delayed to test the experience" width="592" height="978" style="width: 100%; height: auto; max-width: 592px;">
</div>

This is better than it was, but feels a little abrupt when it switches between the two screens.

## Adding a Basic Enter Animation to Your Component Content

I think we can make this feel a little better by adding an enter animation to ease the app content when it loads in.

Before we do this, I just want to point out that I’ve created several Youtube videos and even a [playlist](https://www.youtube.com/playlist?list=PLp-SHngyo0_ikgEN5d9VpwzwXA-eWewSM) all about the animation framework in Angular so you should totally check them out too!

If any of what you’re about to see is unclear, hopefully those videos will help.

Ok, back to this example.

Let’s add the animations array. Then we’ll need to add a trigger with the [trigger()](https://angular.dev/api/animations/trigger) function, let’s call it “enter”.

#### main.ts

```typescript
import { trigger } from '@angular/animations';

@Component({
  selector: 'app-root',
  ...
  animations: [
    trigger('enter', [
    ])
  ]
})
export class App {
}
```

Next we need a transition using the [transition()](https://angular.dev/api/animations/transition) function, and we’ll be transitioning the “enter” state of our content.

```typescript
import { ..., transition } from '@angular/animations';

@Component({
  selector: 'app-root',
  ...
  animations: [
    trigger('enter', [
        transition(':enter', [
        ])
    ])
  ]
})
export class App {
}
```

Ok, now we can add the starting state of our enter animation with the [style()](https://angular.dev/api/animations/style) function. Let’s start from an opacity of zero and a scale of point seven.

```typescript
import { ..., style } from '@angular/animations';

@Component({
  selector: 'app-root',
  ...
  animations: [
    trigger('enter', [
        transition(':enter', [
            style({ opacity: 0, scale: 0.7 })
        ])
    ])
  ]
})
export class App {
}
```

And for the last piece, we’ll animate to our final state with the [animate()](https://angular.dev/api/animations/animate) function. Let’s go with a duration of four hundred milliseconds and an easing function of ease-in.

Then we just need to add the final style with another [style()](https://angular.dev/api/animations/style) function. It will animate to an opacity of one and a scale of one too.

```typescript
import { ..., style } from '@angular/animations';

@Component({
  selector: 'app-root',
  ...
  animations: [
    trigger('enter', [
        transition(':enter', [
            style({ opacity: 0, scale: 0.7 }),
            animate('400ms ease-in', style({ opacity: 1, scale: 1 }))
        ])
    ])
  ]
})
export class App {
}
```

Ok, so that’s the animation, now we can add the trigger on this div that wraps the rest of the content in this component.

```html
<div @enter>
  <app-header></app-header>
  <app-slider></app-slider>
</div>
```

So when that div enters, this animation will run. And that’s it, so let’s save and see how it looks now.

<div style="text-align: center">
<img src="{{ '/assets/img/content/uploads/2024/07-12/demo-3.gif' | relative_url }}" alt="Example of a custom loading screen in Angular with an easing transition after the app has bootstrapped" width="588" height="978" style="width: 100%; height: auto; max-width: 592px;">
</div>

Nice, that’s a lot better.

{% include banner-ad.html %}

## In Conclusion

Now, we could probably keep going on this if we wanted, but I’ll go ahead and stop here because I’m sure you get the idea by now.

It’s pretty easy to create a much more intriguing loading screen with very little effort, and now you know exactly how to do it.

I hope you found this tutorial helpful, and if you did, check out [my YouTube channel](https://www.youtube.com/@briantreese) for more tutorials about various topics and features within Angular.

## Want to See It in Action?

Check out the demo code and examples of these techniques in the Stackblitz example below. If you have any questions or thoughts, don’t hesitate to leave a comment.

<iframe src="https://stackblitz.com/edit/stackblitz-starters-ee1aen?ctl=1&embed=1&file=src%2Findex.html" style="height: 500px; width: 100%; margin-bottom: 1.5em; display: block;"></iframe>
