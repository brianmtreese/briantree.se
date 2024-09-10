---
layout: post
title: "Angular Animations: Animating to an Unknown Height"
date: "2024-03-29"
video_id: "HSxQbGXDo3U"
categories: 
  - "angular"
---

<p class="intro"><span class="dropcap">H</span>ave you ever tried to animate an element to an unknown height with CSS alone? If so, you’ve probably found that it’s not as easy as it seems. To animate a CSS height, you need to animate to a specific value, one hundred percent and auto both won’t work. You can transition <code>max-height</code> but this means that you probably need to use a random arbitrary value that may not work in all cases. It’s just weird and may not even work depending on what you’re trying to do. Well, this is something that is available with Angular animations. In this post, I’ll show you how. Alright, let’s get to it.</p>

<iframe width="1280" height="720" src="https://www.youtube.com/embed/HSxQbGXDo3U" title="" frameborder="0" allow="accelerometer; autoplay; clipboard-write; encrypted-media; gyroscope; picture-in-picture; web-share" allowfullscreen></iframe>

## Before We Get Started

Now, before we get too far along, it’s important to note that I’ve already created several posts focused on the animation framework in Angular. They cover the basics of setting up and using Angular animations, creating state-based and `enter`/`leave` animations, using the `keyframes()`, `query()`, and `stagger()` functions to create more complex animation sequences, using the `start`/`done` animation events, and creating animations that run in parallel versus in sequence.

So, if any of those concepts are unfamiliar to you, you’ll probably want to check those posts out first so that you’re not lost in this post.

#### Angular Animation Tutorials:
- [Learn the Basics]({% post_url /2024/02/2024-02-09-angular-animations-tutorial-learn-the-basics %})
- [Enter and Leave Animations]({% post_url /2024/02/2024-02-16-angular-animations-tutorial-enter-and-leave %}) 
- [The Keyframes Function]({% post_url /2024/02/2024-02-23-angular-animations-tutorial-the-keyframes-function %})
- [Query and Stagger Function]({% post_url /2024/03/2024-03-01-angular-animations-tutorial-query-and-stagger %})
- [Start and Done Events]({% post_url /2024/03/2024-03-08-angular-animations-tutorial-start-and-done-events %})
- [Parallel Animations]({% post_url /2024/03/2024-03-15-angular-animations-tutorial-parallel-animations %})

And, to make them easier to find, I’ve created an [Angular Animations playlist](https://youtube.com/playlist?list=PLp-SHngyo0_ikgEN5d9VpwzwXA-eWewSM&si=3WnQgeDxdAZJGGFy) on my [YouTube channel](https://www.youtube.com/@briantreese) to help, so check it out!

Ok, enough of that, onto the example for this post.

<div class="shirt-ad">
<a href="https://www.teepublic.com/user/dev-drip" title="Click to get yourself some fresh Angular merch!">
<img src="{{ '/assets/img/dev-drip-banner.png' | relative_url }}" alt="Swoop up some hip new Angular drip! - Dev Drip Merch Shop" width="960" height="275" style="width: 100%; height: auto;"></a>
</div>

## The Demo Application

Here we have a demo application for the vans shoe brand. It has a sign-up form with multiple steps. After the user adds their email address, they switch to a new step where they need to create a password for their new account.

<div>
<img src="{{ '/assets/img/content/uploads/2024/03-28/example-1.gif' | relative_url }}" alt="Example of a demo application before adding unknown height animation" width="598" height="614" style="width: 100%; height: auto;">
</div>

This is cool, but as we switch between these two steps, it switches abruptly. It would be better to change this a little, so that it feels more smooth. It would be better to transition as the user switches between the steps like this.

<div>
<img src="{{ '/assets/img/content/uploads/2024/03-28/example-2.gif' | relative_url }}" alt="Example of a demo application after adding unknown height animations" width="596" height="612" style="width: 100%; height: auto;">
</div>

And this is exactly what we are going to do in this post. And in order to build this animation, we will need to animate between the varying, dynamic heights of the two different form steps. Ok, let’s look at the code.

Here, in the template for our sign-up form component, we can see the two panes that we are switching between. First, we have the pane for the email address form. 

#### sign-up-form.component.html
```html
<div class="pane">
    <label>
        <span>Email Address</span>
        <input type="email" formControlName="email" />
    </label>
</div>
```

Then, we have the pane for the password form.

```html
<div class="pane">
    <label>
        <span>Password</span>
        <input type="password" formControlName="password" />
    </label>
    <label>
    <span>Confirm Password</span>
        <input type="password" formControlName="password" />
    </label>
    <footer>
        <p>Password must contain:</p>
        <ul>
            <li>At least 8 characters</li>
            <li>At least 1 lowercase character</li>
            <li>At least 1 uppercase character</li>
            <li>At leaset 1 number or special character</li>
        </ul>
    </footer>
</div>
```

And, we’re using a switch to conditionally determine the appropriate step to show based on our “activePane” property.

```html
@switch(activePane()) {
    @case(0) {
        ...
    }
    @case(1) {
        ...
    }
}
```

So, this means, as far as animations go, these items will be entering and leaving the DOM as we switch between the steps.

## Creating the Pane Toggle Fade In/Out Animation

So, let’s switch to the code for this component and let’s add the animations array. Then, let’s add a trigger with the [`trigger()`](https://angular.io/api/animations/trigger) function named “paneChange”.

#### sign-up-form.component.ts
```typescript
import { trigger } from '@angular/animations';

@Component({
    selector: 'app-sign-up-form',
    ...
    animations: [
        trigger('paneChange', [
        ])
    ]
})
```

Now, let’s add a transition with the [`transition()`](https://angular.io/api/animations/transition) function. For this animation we are going to animate when the “activePane” property value changes. This property is a number and we want this `paneChange` animation to animate any time that number changes. So, let’s animate from any state to any state with asterisk, arrow, and asterisk.

```typescript
import { ..., transition } from '@angular/animations';

@Component({
    selector: 'app-sign-up-form',
    ...
    animations: [
        trigger('paneChange', [
            transition('* => *', [
            ])
        ])
    ]
})
```

Ok, now we’re going to add some animations. What we want to do is we want to start the pane that’s entering in a hidden state while the pane that’s leaving completes its transition to the hidden state. Then, once it’s done, we’ll animate the item entering into the view.

So, let’s add a [`query()`](https://angular.io/api/animations/query), and we’ll query for item’s entering first. Within this query, let’s add the style for the hidden pane with the [`style()`](https://angular.io/api/animations/style) function. Let’s set the opacity to zero, and let’s set the scale to point nine.

```typescript
import { ..., query, style } from '@angular/animations';

@Component({
    selector: 'app-sign-up-form',
    ...
    animations: [
        trigger('paneChange', [
            transition('* => *', [
                query(':enter', [
                    style({opacity: 0, scale: 0.9})
                ])
            ])
        ])
    ]
})
```

Ok, now we’re going to add the animation for the pane that’s leaving, so let’s add another query. This time we’ll query for items leaving. Within this, let’s add the starting style. It will have an opacity of one, and it’ll have a scale of one too.

```typescript
@Component({
    selector: 'app-sign-up-form',
    ...
    animations: [
        trigger('paneChange', [
            transition('* => *', [
                ...
                query(':leave', [
                    style({opacity: 1, scale: 1})
                ])
            ])
        ])
    ]
})
```

Now let’s add the animation with the [`animate()`](https://angular.io/api/animations/animate) function. Let’s give it a duration of point two seconds and an easing function of `ease-in`.
Then, let’s add another `style()` function to animate to. Let’s animate to an opacity of zero, and let’s animate to a scale of point nine.

```typescript
import { ..., animate } from '@angular/animations';

@Component({
    selector: 'app-sign-up-form',
    ...
    animations: [
        trigger('paneChange', [
            transition('* => *', [
                ...
                query(':leave', [
                    ...
                    animate('0.2s ease-in', style({opacity: 0, scale: 0.9}))
                ])
            ])
        ])
    ]
})
```

Ok, next we need to animate the pane that’s entering. So, let’s add one more `query()`. For our enter animation, we already added our starting style, so we just need the actual animation. So, let’s add the `animate()` function, and we’ll add the same point two second duration, with the `ease-in` timing function too. Then, we need to add the final style with the `style()` function. We’ll animate to an opacity of one, and a scale of one two.

```typescript
@Component({
    selector: 'app-sign-up-form',
    ...
    animations: [
        trigger('paneChange', [
            transition('* => *', [
                ...
                query(':enter', [
                    animate('0.2s ease-in', style({opacity: 1, scale: 1}))
                ])
            ])
        ])
    ]
})
```

Ok, so that should be it for our animation. We just need to add it in the template. So, let’s switch to the HTML.

Now, since we set our animation up to query for items entering and leaving, we can add the animation on the “panes” div, and we’ll need to bind it to the “activePane” property so that it will be triggered when that property changes.

#### sign-up-form.component.html
```html
<div [@paneChange]="activePane()" class="panes">
    @switch(activePane()) {
        @case(0) {
            <div class="pane">
                ...
            </div>
        }
        @case(1) {
            <div class="pane">
                ...
            </div>
        }
</div>
```

Ok, let’s save and see where we’re at.

<div>
<img src="{{ '/assets/img/content/uploads/2024/03-28/example-3.gif' | relative_url }}" alt="Example of a demo application after adding pane change animations" width="600" height="616" style="width: 100%; height: auto;">
</div>

Ok, so it’s a little better but it’s still not very good. It still feels very abrupt.

Well this is because the height is changing because the content on the two panes is different.
So, we need to ease this height change. Well, as I mentioned earlier, this is doable with Angular animations. We do this by animating the height property and using a value of asterisk.

<div>
<img src="{{ '/assets/img/content/uploads/2024/03-28/unknown-dimensions-slide.gif' | relative_url }}" alt="Explanation of using the asterisk to animate to unknown heights and widths" width="1280" height="720" style="width: 100%; height: auto;">
</div>

This asterisk is a wildcard value that can be used for both height and width when we’re not sure the final length value of an animating item.

## Animating to an Unknown Height

Ok, so let’s add a height animation here. For this, we’ll be animating the height of the parent element, our panes element that has the `trigger`. So, let’s start by adding another `query()`. This time we’ll query for a value of `:self` which will target the item with the trigger. And within this query, let’s add an animation. We’ll go with the same point two second duration, and `ease-in` timing function that we used for the others. Then we’ll add the style function. We’ll add height, and we’ll give it a string value of asterisk.

#### sign-up-form.component.ts
```typescript
@Component({
    selector: 'app-sign-up-form',
    ...
    animations: [
        trigger('paneChange', [
            transition('* => *', [
                ...
                query(':self', [
                    animate('0.2s ease-in', style({height: '*'}))
                ])
            ])
        ])
    ]
})
```

Ok, one more thing here, we don’t want the height to change when the first pane is leaving. So let’s group the enter and self animations with the [`group()`](https://angular.io/api/animations/group) function so that the height will only animate when the entering item is animating, after the leave has completed.

```typescript
@Component({
    selector: 'app-sign-up-form',
    ...
    animations: [
        trigger('paneChange', [
            transition('* => *', [
                ...
                group([
                    query(':self', [
                        ...
                    ]),
                    query(':enter', [
                        ...
                    ])
                ])
            ])
        ])
    ]
})
```

Ok, now let’s save and see how this looks.

<div>
<img src="{{ '/assets/img/content/uploads/2024/03-28/example-3.gif' | relative_url }}" alt="Example of a demo application attepting to animate to unknown heights without providing a starting height" width="600" height="616" style="width: 100%; height: auto;">
</div>

Ugh, it looks the same right. It’s not animating the height.

Well, this is because we need to provide a starting value. Now, sometimes you may know the starting value, so you can provide a hard-coded value. But here, we don’t know the starting height of the container. Sometimes it will be the height of the email step, and then others, it’ll be the height of the password step.

So what we need to do is provide the starting height of the element to the animation. Well, this can be done using animation params.

## Using Animation Params to Add a Starting Height for the Animation

Params allow us to pass information along to the animation so that it can use the values provided during its animation steps.

<div>
<img src="{{ '/assets/img/content/uploads/2024/03-28/animation-params-slide.gif' | relative_url }}" alt="Explanation of using params to provide values to angular animations" width="1280" height="720" style="width: 100%; height: auto;">
</div>

We can add params with the `params` object on the `transition()` function. In this object we can define whatever params we need. So, in our example, let’s add params.

Let’s add a “startHeight” param, and we’ll just give it an initial value of zero.

```typescript
@Component({
    selector: 'app-sign-up-form',
    ...
    animations: [
        trigger('paneChange', [
            transition('* => *', [
                ...
            ])
        ], { params: { startHeight: 0 } })
    ]
})
```

Ok, now let’s use this param for our starting style in the animation. Let’s add another `:self` query by our `:enter` starting style. And let’s give it a starting style of our param `startHeight`.

To do this, we use the param name inside double curly braces. Also, in this case, we are going to pass the `clientHeight` of our element which will give us a number value for the number of pixels it is tall, so we need to include the `px` unit here too.

```typescript
@Component({
    selector: 'app-sign-up-form',
    ...
    animations: [
        trigger('paneChange', [
            transition('* => *', [
                query(':self', [
                    style({height: '{{startHeight}}px'})
                ]),
                query(':enter', [
                    ...
                ]),
                ...
            ])
        ], { params: { startHeight: 0 } })
    ]
})
```

Ok, so that’s how we add and use the params in the animation. Now we need to pass the value to our animation trigger in the template. So, let’s switch over to the template.

Now, rather than bind directly to the `activePane()` property, where going to switch this to an object so that we can pass our params object. The first item in this object will be the value to trigger the animation, which is our activePane property.

Then, we can add a params object. Inside of this object, we need to add our `startHeight`. Now what we want to do here is pass the `clientHeight` of this element as the `startHeight`.

To do this, let’s add a template reference variable to the panes element. Ok, now we can use this element to access its `clientHeight`.

#### sign-up-form.component.html
```html
<div
    #panes
    [@paneChange]="{
        value: activePane(),
        params: {
            startHeight: panes.clientHeight
        }
    }"
    class="panes">
    ...
</div>
```

And that should be it. Let’s save this and try it out.

<div>
<img src="{{ '/assets/img/content/uploads/2024/03-28/example-2.gif' | relative_url }}" alt="Example of a demo application after adding unknown height animations" width="596" height="612" style="width: 100%; height: auto;">
</div>

Nice, now it’s transitioning the height as we navigate between these two panes like we want. It looks a lot nicer, at least in my opinion. Hopefully in yours too.

## Conclusion

Now remember, the asterisk not only animates unknown heights, but it also can be used for widths. I feel like, in my experience, needing to animate to unknown heights is more common but I’ve definitely needed to use this technique for widths as well.

So, now you have another handy tool to help with animations in Angular apps. I hope you found this tutorial useful.

Now remember, there’s a lot to the animation framework, so I’ll go ahead and stop here for now, but I will be creating more posts on Angular animations in the future so stay tuned!

## Want to See It in Action?
Check out the demo code and examples of these techniques in the in the Stackblitz example below. If you have any questions or thoughts, don’t hesitate to leave a comment.

<iframe src="https://stackblitz.com/edit/stackblitz-starters-3ufzct?ctl=1&embed=1&file=src%2Fsign-up-form%2Fsign-up-form.component.ts" style="height: 500px; width: 100%; margin-bottom: 1.5em; display: block;">
