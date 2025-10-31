---
layout: post
title: "Tired of Console Logs? Meet Angular’s Signal Graph"
date: "2025-08-21"
video_id: "yFfHhdFiq6k"
tags:
  - "Angular"
  - "Angular Signals"
  - "Angular Debugging"
  - "Angular DevTools"
---

<p class="intro"><span class="dropcap">A</span>ngular recently released something pretty neat: a new debugging tool that changes everything about how we understand our applications. It’s called the Signal Graph, and it was introduced in Angular 20.1 just a few months ago. If you’ve ever felt like you’re debugging in the dark, this tool will flip the lights on.</p>

{% include youtube-embed.html %}

## The Problem: Debugging in the Dark

As Angular developers we’re often left wondering:

- When you click a button, which components update?  
- Which signals recalculate?  
- What’s the order of operations?  

Up until now, we’ve had to rely on console logs, breakpoints, and a lot of guesswork. But not anymore.

Let’s check it out!

## Install Angular DevTools and Enable the Signal Graph

First, you’ll need Angular DevTools.  

If you don’t already have it, grab it from the [Chrome Web Store](https://chromewebstore.google.com/detail/ienfalfjdbdpebioblfackkekamfmbnh){:target="_blank"} or [Firefox Add-ons](https://addons.mozilla.org/en-US/firefox/addon/angular-devtools/){:target="_blank"}. 

Just search for "Angular DevTools" and hit install.

Once installed, open your app in development mode, head into your browser’s DevTools, and select the “Angular” tab:

<div>
<img src="{{ '/assets/img/content/uploads/2025/08-21/demo-1.png' | relative_url }}" alt="Pointing out the Angular tab in the DevTools" width="900" height="458" style="width: 100%; height: auto;">
</div>

If you don't see the Angular tab, make sure you're running your app in development mode, not production.

Because the Signal Graph is still experimental, you’ll need to enable it in the settings menu:

<div>
<img src="{{ '/assets/img/content/uploads/2025/08-21/demo-2.png' | relative_url }}" alt="Enabling the Angular Signal Graph in the DevTools" width="860" height="504" style="width: 100%; height: auto;">
</div>

Once that’s done, you’re ready to go.

## Using the Signal Graph

Let’s look at the [simple counter app](https://github.com/brianmtreese/angular-signal-graph-example){:target="_blank"} that I created for this tutorial:

<div>
<img src="{{ '/assets/img/content/uploads/2025/08-21/demo-3.png' | relative_url }}" alt="Example of a very simple counter app in Angular" width="922" height="920" style="width: 100%; height: auto;">
</div>

To use the Signal Graph, you'll first need to select the component that you want to inspect in the tree:

<div>
<img src="{{ '/assets/img/content/uploads/2025/08-21/demo-4.png' | relative_url }}" alt="Selecting the counter component in the DevTools" width="750" height="348" style="width: 100%; height: auto;">
</div>

In this case it’s pretty easy, we only have the counter component, so we'll select it.

Then we just need to click the "Show Signal Graph" button:

<div>
<img src="{{ '/assets/img/content/uploads/2025/08-21/demo-5.png' | relative_url }}" alt="Clicking the Show Signal Graph button in the DevTools to display the Signal Graph for the counter component" width="732" height="354" style="width: 100%; height: auto;">
</div>

Now you’ll see a beautiful graph of all the signals in this component:

<div>
<img src="{{ '/assets/img/content/uploads/2025/08-21/demo-6.png' | relative_url }}" alt="The Signal Graph showing all of the signals in the counter component" width="944" height="702" style="width: 100%; height: auto;">
</div>

When we click the "+1" button, the signals light up, showing exactly what updates when we interact with our app:

<div>
<img src="{{ '/assets/img/content/uploads/2025/08-21/demo-7.gif' | relative_url }}" alt="Interacting with the counter component and seeing the Signal Graph update in real time" width="1592" height="1076" style="width: 100%; height: auto;">
</div>

## Signal Types and Colors

You’ll notice that signals are shown in different colors:

- **Blue** → [Writable signals](https://angular.dev/guide/signals#writable-signals){:target="_blank"} (like the counter value).  
- **Green** → [Computed signals](https://angular.dev/guide/signals#computed-signals){:target="_blank"} (values derived from others).  
- **Purple** → [Effects](https://angular.dev/guide/signals#effects){:target="_blank"} (side effects such as logging or API calls).  
- **Red** → [Linked signals](https://angular.dev/guide/signals/linked-signal){:target="_blank"} (a writable signal derived from others).  
- **Gray** → The template.  

The lines between boxes represent data flow, like a family tree for your app’s state.

## Explore Signal Details

Click on any signal to view more details:

<div>
<img src="{{ '/assets/img/content/uploads/2025/08-21/demo-8.png' | relative_url }}" alt="Clicking on a signal in the Signal Graph to view more details" width="944" height="648" style="width: 100%; height: auto;">
</div>

You can see the following details:

- **Name** → The name of the signal
- **Type** → signal, computed, effect, etc.
- **Epoch** → how many times it has changed since the app started
- **Current value**

Now, as you interact with the app, you can see both the "value" and the "epoch" updating in real time:

<div>
<img src="{{ '/assets/img/content/uploads/2025/08-21/demo-9.gif' | relative_url }}" alt="Interacting with the counter component and seeing the Signal Graph update in real time" width="958" height="798" style="width: 100%; height: auto;">
</div>

## Spotting a Broken Signal

Here’s where Signal Graph shines.  

You'll notice that a computed "double" signal always stays at 0. 

And in the graph, you don’t see a connection from "count" to "double":

<div>
<img src="{{ '/assets/img/content/uploads/2025/08-21/demo-10.png' | relative_url }}" alt="The Signal Graph showing a broken dependency" width="888" height="832" style="width: 100%; height: auto;">
</div>

That missing connection is a red flag, the graph visually shows that the dependency isn’t wired correctly.  

This makes it easy to spot bugs that would be frustrating to track down otherwise.

## Fixing the Computed Signal

After checking the code, we find the culprit: instead of reading the "count" signal, the computed "double" was hardcoded with a 0:

```typescript
export class CounterComponent {
    protected count = signal(0);
    ...
    protected double = computed(() => {
        const currentValue = 0; // This should be this.count()
        return currentValue * 2;
    });
}
```

By updating the code to properly read the "count" signal, we should be able to fix this:

```typescript
export class CounterComponent {
    protected count = signal(0);
    ...
    protected double = computed(() => {
        const currentValue = this.count();
        return currentValue * 2;
    });
}
```

After saving, the Signal Graph now shows the connection between "count" and "double":

<div>
<img src="{{ '/assets/img/content/uploads/2025/08-21/demo-11.png' | relative_url }}" alt="The Signal Graph showing the correct dependency" width="812" height="704" style="width: 100%; height: auto;">
</div>

And then, when we click the button, both "count" and "double" light up, and the UI updates as expected:

<div>
<img src="{{ '/assets/img/content/uploads/2025/08-21/demo-12.gif' | relative_url }}" alt="The Signal Graph showing the correct dependency and the UI updating as expected" width="1728" height="1078" style="width: 100%; height: auto;">
</div>

## Wrap-Up & Key Takeaways

And there it is, the Signal Graph turned debugging from guesswork into crystal-clear vision.  

With it, we:

- Spotted a broken dependency.  
- Fixed the bug.  
- Instantly confirmed the results visually.  

The more signals your app has, the more powerful this tool becomes.  

So give it a try, it’s like switching on the lights in a dark room.  

If this saved you some console.logs, don’t forget to [subscribe](https://www.youtube.com/c/briantreese?sub_confirmation=1) for more Angular deep dives.  

{% include banner-ad.html %}

## Additional Resources
- [The counter app used in this tutorial](https://github.com/brianmtreese/angular-signal-graph-example){:target="_blank"}
- [Angular DevTools (Chrome Web Store)](https://chromewebstore.google.com/detail/ienfalfjdbdpebioblfackkekamfmbnh){:target="_blank"}
- [Angular DevTools (Firefox Add-ons)](https://addons.mozilla.org/en-US/firefox/addon/angular-devtools/){:target="_blank"}
- [Angular Signals Documentation](https://angular.dev/guide/signals){:target="_blank"}
- [My Angular Signals Playlist](https://www.youtube.com/playlist?list=PLp-SHngyo0_iboYPhI2YV2dGQFT1mctOQ){:target="_blank"}
- [My course "Angular: Styling Applications"](https://www.pluralsight.com/courses/angular-styling-applications){:target="_blank"}
- [My course "Angular in Practice: Zoneless Change Detection"](https://app.pluralsight.com/library/courses/angular-practice-zoneless-change-detection){:target="_blank"}
