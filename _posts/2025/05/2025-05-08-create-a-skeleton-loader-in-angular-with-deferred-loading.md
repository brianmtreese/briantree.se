---
layout: post
title: "Nobody Wants to See a Blank Screen… Build Smarter Loaders!"
date: "2025-05-08"
video_id: "ZiVbfFeuy-I"
tags:
  - "Angular"
  - "Angular Animations"
  - "Angular Components"
  - "Angular Signals"
  - "Angular Styles"
  - "Deferrable Views"
  - "JavaScript"
  - "Performance"
  - "TypeScript"
---

<p class="intro"><span class="dropcap">W</span>hen your app loads data, what do users see, a blank screen, a lonely spinner? Today we’re going to build something better: a smart skeleton loader that instantly shows your UI structure, feels fast, and transitions smoothly into real content as soon as it’s ready. And we’re doing it the modern Angular way: using <a href="https://angular.dev/guide/templates/defer" target="_blank">deferred loading</a> to manage content rendering, <a href="https://angular.dev/guide/signals" target="_blank">signals</a> to track state reactively, and animations to make the transition feel seamless. By the end of this tutorial, you’ll know how to build a loader that’s not just functional, but delightful.</p>

{% include youtube-embed.html %}

## Baseline Setup: A Simple Profile Card with Simulated Delay

This is our basic app. I’ll refresh it a couple of times, and you’ll notice there’s a delay before anything shows up:

<div>
<img src="{{ '/assets/img/content/uploads/2025/05-08/demo-1.gif' | relative_url }}" alt="Example of a list of mostly blank profile cards before content loads after a delay" width="784" height="1030" style="width: 100%; height: auto;">
</div>

That delay is mocking the type of thing that may occur with a real API request.

If we look at the code in [the profile service](https://stackblitz.com/edit/stackblitz-starters-hawehhid?file=src%2Fprofile.service.ts){:target="_blank"} where this data comes from, we can see why: we’re using [setTimeout()](https://developer.mozilla.org/en-US/docs/Web/API/Window/setTimeout){:target="_blank"} to simulate a network call:

```typescript
loadProfile() {
  setTimeout(() => {
    this._profile.set({
      name: 'Brian Treese',
      avatar: 'https://avatars.githubusercontent.com/u/9142917',
      memberSince: 2020
    });
  }, 3000);
}
```

It's fake, but realistic. You could imagine this data coming from your backend or [Firebase](https://firebase.google.com/){:target="_blank"} or whatever you use.

Let’s look at the [profile-card.component.ts](https://stackblitz.com/edit/stackblitz-starters-hawehhid?file=src%2Fprofile-card%2Fprofile-card.component.ts){:target="_blank"} to see how this service is implemented.

Here, the component injects the [profile service](https://stackblitz.com/edit/stackblitz-starters-hawehhid?file=src%2Fprofile.service.ts){:target="_blank"}, and in the constructor, we load the profile if it isn’t already set:

```typescript
export class ProfileCardComponent {
  private profileService = inject(ProfileService);
  protected profile = this.profileService.profile;

  constructor() {
    effect(() => {
      if (!this.profile()) {
        this.profileService.loadProfile();
      }
    });
  }
}
```

This is all pretty simple and reactive, using Angular [signals](https://angular.dev/guide/signals){:target="_blank"}.

Over in [the template](https://stackblitz.com/edit/stackblitz-starters-hawehhid?file=src%2Fprofile-card%2Fprofile-card.component.html){:target="_blank"}, we’ve got a basic [@if block](https://angular.dev/guide/templates/control-flow#conditionally-display-content-with-if-else-if-and-else){:target="_blank"} to conditionally render the content once it’s available.

## Using @defer to Replace Conditional Rendering

In the existing setup, we simply check if the profile data was loaded, then we load the card content.

This works fine, the content only shows once the data is available. But Angular now gives us something better: deferred loading with the [@defer](https://angular.dev/guide/templates/defer){:target="_blank"} block.

Think of [@defer](https://angular.dev/guide/templates/defer){:target="_blank"} as a smarter conditional rendering tool.

It lets you wait for a specific condition to become true, show placeholder content while you’re waiting, and optimize for lazy loading, improving perceived performance.

It’s perfect for API-driven content, dashboard widgets, or anything with async data.

We can simply replace the [@if](https://angular.dev/guide/templates/control-flow#conditionally-display-content-with-if-else-if-and-else){:target="_blank"} with [@defer](https://angular.dev/guide/templates/defer){:target="_blank"} instead.

Then, we have [several triggers](https://angular.dev/guide/templates/defer#controlling-deferred-content-loading-with-triggers){:target="_blank"} to choose from to control when Angular loads and displays the content.

In this case, we’ll use the [when](https://angular.dev/guide/templates/defer#when){:target="_blank"} trigger which will simply trigger the content to load once the profile [signal](https://angular.dev/guide/signals){:target="_blank"} becomes truthy:

```html
@defer (when profile()) {
  <div>
    <img [src]="profile()!.avatar" class="avatar" />
    <h2>{% raw %}{{ profile()!.name }}{% endraw %}</h2>
    <em>Member Since: {% raw %}{{ profile()!.memberSince }}{% endraw %}</em>
  </div>
}
```
This behaves the same way as [@if](https://angular.dev/guide/templates/control-flow#conditionally-display-content-with-if-else-if-and-else){:target="_blank"}, but now we can expand it, and that’s where the power comes in.

## Building the Skeleton Loader UI

Here’s what makes [@defer](https://angular.dev/guide/templates/defer){:target="_blank"} so useful: it lets us show something else while we wait, like a skeleton loader.

We just add a [@placeholder](https://angular.dev/guide/templates/defer#show-placeholder-content-with-placeholder){:target="_blank"} block.

Within this block we can add markup that we want to render while we wait for the profile to load.

I’ll add several divs with some classes so that I can easily style placeholder markers for each of the corresponding pieces of content from the actual card:

```html
@defer (when profile()) {
  ...
} @placeholder {
  <div class="skeleton">
    <div class="avatar"></div>
    <div class="text title"></div>
    <div class="text subtitle"></div>
  </div>
}
```

Now Angular will render the placeholder immediately, and then swap it out only once the profile signal emits a non-null value.

It’s like telling Angular...

> “don’t render this part of the page until I have the data, but while you wait, show something helpful.”

Ok, now we just need to add some styles to make this look right so let’s switch to the [SCSS](https://stackblitz.com/edit/stackblitz-starters-hawehhid?file=src%2Fprofile-card%2Fprofile-card.component.scss){:target="_blank"}.

Here, for our skeleton, let’s add some styles for the mock avatar and text label regions:

```scss
.skeleton {
  .avatar {
    background: #ccc;
  }

  .text {
    background: #ccc;
    margin-inline: auto;
  }

  .title {
    border-radius: 8px;
    width: 70%;
    height: 28px;
    margin-block: 9px 3px;
  }

  .subtitle {
    height: 15px;
    border-radius: 6px;
    width: 50%;
  }
}
```

Okay, this should be enough to style our skeleton markup and give us something to show while the profile loads.

Let’s save and see how it works:

<div>
<img src="{{ '/assets/img/content/uploads/2025/05-08/demo-2.gif' | relative_url }}" alt="Example of a profile card with a skeleton loader using deferred loading in Angular" width="756" height="1056" style="width: 100%; height: auto;">
</div>

There we go! The skeleton appears instantly, and once the data is ready, the real content pops in. Huge win for the user experience already.

This is quite a bit better than before right?

But, I think we can make it even better.

## Animating the Skeleton with CSS Shimmer Effects

Let’s level it up with animation. A static skeleton like this might make it feel as if nothing is actually happening.

First, I’ll remove the background color from the mock avatar and text elements and I’ll replace this background with a [linear-gradient](https://developer.mozilla.org/en-US/docs/Web/CSS/linear-gradient){:target="_blank"}.

We also need to add a [background-size](https://developer.mozilla.org/en-US/docs/Web/CSS/background-size){:target="_blank"} that’s larger than these shapes so that we can animate the background position:

```scss
.skeleton {
  .avatar,
  .text {
    background: linear-gradient(
      90deg,
      #eee 25%,
      #fff 50%,
      #eee 75%
    );
    background-size: 400% 100%;
  }
}
```

Okay, now that we have the gradient, we need to create a [keyframe animation](https://developer.mozilla.org/en-US/docs/Web/CSS/@keyframes){:target="_blank"} to animate it.

We’ll start with the gradient offset to the left, and then we’ll end offset to the right:

```scss
@keyframes shimmer {
  0% {
    background-position: -200% 0;
  }
  100% {
    background-position: 200% 0;
  }
}
```

So, it will slide left-to-right.

Okay, we have the gradient, and now we have the [keyframe animation](https://developer.mozilla.org/en-US/docs/Web/CSS/@keyframes){:target="_blank"}, let’s add this animation to the mock avatar and text labels with the [animation](https://developer.mozilla.org/en-US/docs/Web/CSS/animation){:target="_blank"} property.

We’ll animate this left-to-right transition over two seconds and we’ll make it loop with the [infinite](https://developer.mozilla.org/en-US/docs/Web/CSS/infinite){:target="_blank"} property:

```scss
.skeleton {
  .avatar,
  .text {
    ...
    animation: shimmer 2s infinite linear;
  }
}
```

Alright, that’s all we need, so let’s save and try it now:

<div>
<img src="{{ '/assets/img/content/uploads/2025/05-08/demo-3.gif' | relative_url }}" alt="Example of a profile card with a shimmering CSS keyframe animation skeleton loader using deferred loading in Angular" width="758" height="1058" style="width: 100%; height: auto;">
</div>

Look at that shimmer!

Now, it gives the illusion that the app is "working" on loading the content. Pretty slick.

## Adding Angular Animations for a Smooth Transition

This is looking pretty good, right? But I think we can still make it even better.

The change between the skeleton loader and the actual content is pretty abrupt.

I think it would be better to animate this transition too.

But this is a little more difficult to animate.

Since we have an item that’s leaving the DOM and an item that’s entering, we’ll need to use [Angular animations](https://angular.dev/guide/animations){:target="_blank"} to handle this.

In order to do this, we first need to enable animations in this application.

Let’s open up the [main.ts](https://stackblitz.com/edit/stackblitz-starters-hawehhid?file=src%2Fmain.ts){:target="_blank"} file.

Here, we need to provide the animations module to the bootstrap application function.

Let’s add the providers array, and then we need to add the [provideAnimationsAsync](https://angular.dev/api/animations/provideAnimationsAsync){:target="_blank"} method:

```typescript
import { provideAnimationsAsync } from '@angular/platform-browser/animations/async';

bootstrapApplication(AppComponent, {
  providers: [provideAnimationsAsync()],
});
```

This enables Angular’s animation system, so now, we can use it.

Let’s switch back to the [profile-card.component.ts](https://stackblitz.com/edit/stackblitz-starters-hawehhid?file=src%2Fprofile-card%2Fprofile-card.component.ts){:target="_blank"} file.

To add [Angular animations](https://angular.dev/guide/animations){:target="_blank"}, we need to add the animations array:

```typescript
@Component({
  selector: 'app-profile-card',
  ...,
  animations: [
  ]
})
```

Then, we can use the [trigger](https://angular.dev/api/animations/trigger){:target="_blank"} function to create an animation, let’s call it “fadeOut”:

```typescript
animations: [
  trigger('fadeOut', [
  ])
]
```

Then, we need to add a transition with the [transition](https://angular.dev/api/animations/transition){:target="_blank"} function.

Here, we’ll select the “leaving” element which will be our skeleton div:

```typescript
animations: [
  trigger('fadeOut', [
    transition(':leave', [
    ])
  ])
]
```

Now we can use the [animate](https://angular.dev/api/animations/animate){:target="_blank"} function to animate this div.

First, we add the duration and [easing function](https://developer.mozilla.org/en-US/docs/Web/CSS/easing-function){:target="_blank"} to use.

We’ll go with five hundred milliseconds and "ease-out":

```typescript
animations: [
  trigger('fadeOut', [
    transition(':leave', [
      animate('500ms ease-out')
    ])
  ])
]
```

Now we can add the style that we want to animate to with the [style](https://angular.dev/api/animations/style){:target="_blank"} function.

All we’re going to do is animate to an [opacity](https://developer.mozilla.org/en-US/docs/Web/CSS/opacity){:target="_blank"} of zero:

```typescript
animations: [
  trigger('fadeOut', [
    transition(':leave', [
      animate('500ms ease-out', style({ opacity: 0 }))
    ])
  ])
]
```

Okay that’s all we need for our skeleton "leave" animation, so now we can add another trigger called “fadeIn”:

```typescript
animations: [
  trigger('fadeOut', [...]),
  trigger('fadeIn', [
  ])
]
```

Then we’ll add another transition, this time for the element that’s “entering”:

```typescript
animations: [
  trigger('fadeOut', [...]),
  trigger('fadeIn', [
    transition(':enter', [
    ])
  ])
]
```

Now this animation is a little different because we need to provide the animation starting state, so we’ll add a [style](https://angular.dev/api/animations/style){:target="_blank"} function, and we’ll start with an [opacity](https://developer.mozilla.org/en-US/docs/Web/CSS/opacity){:target="_blank"} of zero:

```typescript
animations: [
  trigger('fadeOut', [...]),
  trigger('fadeIn', [
    transition(':enter', [
      style({ opacity: 0 }),
    ])
  ])
]
```

Now, we can add the animation for this element with another [animation](https://angular.dev/api/animations/animation){:target="_blank"} function.

Let’s use a duration of six hundred milliseconds this time and an [easing function](https://developer.mozilla.org/en-US/docs/Web/CSS/easing-function){:target="_blank"} of, "ease-in":

```typescript
animations: [
  trigger('fadeOut', [...]),
  trigger('fadeIn', [
    transition(':enter', [
      style({ opacity: 0 }),
      animate('600ms ease-in')
    ])
  ])
]
```

Then we’ll animate to a final style with the [style](https://angular.dev/api/animations/style){:target="_blank"} function and an [opacity](https://developer.mozilla.org/en-US/docs/Web/CSS/opacity){:target="_blank"} of one:

```typescript
animations: [
  trigger('fadeOut', [...]),
  trigger('fadeIn', [
    transition(':enter', [
      style({ opacity: 0 }),
      animate('600ms ease-in', style({ opacity: 1 }))
    ])
  ])
]
```

So, “fadeOut” animates when the placeholder leaves. “fadeIn” kicks in when the real content shows up.

These are lifecycle-aware transitions built into Angular’s animation system.

Okay, now we just need to switch over to [the template](https://stackblitz.com/edit/stackblitz-starters-hawehhid?file=src%2Fprofile-card%2Fprofile-card.component.html){:target="_blank"} and add the animation triggers on the items that need to animate:

```html
@defer (when profile()) {
  <div @fadeIn>
    ...
  </div>
} @placeholder {
  <div class="skeleton" @fadeOut>
    ...
  </div>
}
```

This is the final touch, so now let’s save and see how it looks:

<div>
<img src="{{ '/assets/img/content/uploads/2025/05-08/demo-4.gif' | relative_url }}" alt="Example of a profile card with a smooth transition animation between a skeleton loader and real content using deferred loading in Angular" width="744" height="1076" style="width: 100%; height: auto;">
</div>

Nice, now our skeleton fades out, and the real content fades in. No jump cuts, no hard swaps, just smooth motion.

Now it feels fast. Feels thoughtful, and really just improves the user's experience overall.

## Conclusion: Smarter Loading UX with Modern Angular

Alright, you now know how to build a smart skeleton loader in Angular using [deferred loading](https://angular.dev/guide/defer-blocks){:target="_blank"}, [signals](https://angular.dev/guide/signals){:target="_blank"}, and [animations](https://angular.dev/guide/animations){:target="_blank"}. 

We kept it clean, modern, and pretty much, boilerplate-free.

If you found this helpful, don't forget to [subscribe](https://www.youtube.com/c/briantreese?sub_confirmation=1){:target="_blank"} and check out [my other Angular tutorials](https://www.youtube.com/@briantreese){:target="_blank"} for more tips and tricks!

{% include banner-ad.html %}

## Additional Resources

- [The demo app BEFORE any changes](https://stackblitz.com/edit/stackblitz-starters-hawehhid?file=src%2Fprofile-card%2Fprofile-card.component.html){:target="_blank"}
- [The demo app AFTER making changes](https://stackblitz.com/edit/stackblitz-starters-jxwoj96l?file=src%2Fprofile-card%2Fprofile-card.component.html){:target="_blank"} 
- [Angular Deferred Loading](https://angular.dev/guide/templates/defer){:target="_blank"}
- [Angular Signals Guide](https://angular.dev/guide/signals){:target="_blank"}
- [Angular Animations Overview](https://angular.dev/guide/animations){:target="_blank"}
- [My course: "Styling Angular Applications"](https://app.pluralsight.com/library/courses/angular-styling-applications/table-of-contents){:target="_blank"}

## Want to See It in Action?

Check out the demo code showcasing these techniques in the StackBlitz project below. If you have any questions or thoughts, don’t hesitate to leave a comment.

<iframe src="https://stackblitz.com/edit/stackblitz-starters-jxwoj96l?ctl=1&embed=1&file=src%2Fprofile-card%2Fprofile-card.component.html" style="height: 500px; width: 100%; margin-bottom: 1.5em; display: block;"></iframe>
