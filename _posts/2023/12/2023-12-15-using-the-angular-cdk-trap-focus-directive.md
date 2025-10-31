---
layout: post
title: "Using the Angular CDK Trap Focus Directive"
date: "2023-12-15"
video_id: "JKHAjYJ5T2o"
tags: 
  - "Angular"
  - "Angular CDK"
---

<p class="intro"><span class="dropcap">A</span> focus trap is a very important accessibility feature within a web application. In this post I’ll first help you understand what it is, then why it’s important, and finally I’ll show how to quickly and easily add the concept within your Angular apps where needed. And, it’s pretty easy thanks to the Angular CDK. Alright, let’s get to it.</p>

{% include youtube-embed.html %}

Accessibility can be a little difficult to understand or even think about if you’re someone who can see, hear, and use the web easily with different devices, so it can also be easy to build things that don’t work well for those who can’t.

## What is a Focus Trap?

A focus trap is a feature that helps make experiences better for these folks. It’s a way of managing user focus within a given container.

Take for example, a modal. If a user opens a modal without managing focus, when they start navigating via the keyboard by using the tab key, items behind the modal continue to receive focus. This is weird and not what the user would expect right? We need to programmatically focus them within the modal.

But this isn’t enough, if we stop here, as we tab through the modal, eventually we’ll tab through all of the focusable items and then, we’ll be back to focusing items within the original document behind the modal again.

What we need to do instead is trap the focus so that when the user focuses on the last item in the modal, focus will be placed back on the first focusable element in the modal on the next tab.

Ok, now that we know what a focus trap is, we are probably beginning to realize that there’s going to be some effort to create this functionality right?

Well, not within Angular. With the CDK this is pretty easy using the `cdkTrapFocus` directive from the `A11yModule`.

## The Angular `cdkTrapFocus` directive

Let's look at an example. Here we have a web app for the vans shoe brand. 

<div>
<img src="{{ '/assets/img/content/uploads/2023/12-15/vans-website-demo.png' | relative_url }}" alt="Vans demo website" width="842" height="672" style="width: 100%; height: auto;">
</div>

Up at the top, we have a sign-up button. When we click it, and then tab around, we can see focus is moving around the items in the background.

<div>
<img src="{{ '/assets/img/content/uploads/2023/12-15/vans-website-demo-sign-up-modal.gif' | relative_url }}" alt="Vans demo website with sign-up modal open tabbing through focalsable items" width="860" height="674" style="width: 100%; height: auto;">
</div>

Not what we want right?

Ok, let’s add the `cdkTrapFocus`. First thing we need to do in order to use it is, we need to import the `A11yModule`.

### sign-up-modal.component.ts

```typescript
import { A11yModule } from '@angular/cdk/a11y';

@Component({
    selector: 'app-sign-up-modal',
    ...
    imports: [A11yModule]
})
export class SignUpModalComponent {
}
```

For those of you who are unfamiliar with this acronym, Ally is an abbreviation for the word accessibility. It comes from the concept that the word begins with an A, ends with a Y, and there are eleven characters in between. 

<div>
<img src="{{ '/assets/img/content/uploads/2023/12-15/a11y-acronym.gif' | relative_url }}" alt="The a11y acronym" width="1280" height="720" style="width: 100%; height: auto;">
</div>

The Angular CDK has several accessibility features within their accessibility module, and the `cdkTrapFocus` directive is one of them.

So, once we have it imported, we can now use it within the template. We just need to add it to an element that wraps our form.

### sign-up-modal.component.html

```html
<div cdkTrapFocus>
    <app-sign-up-form (formSubmitted)="modalClose.emit()"></app-sign-up-form>
    ...
</div>
```

Now, when open our sign-up form again it looks like, even though we’ve added the directive, we still need to programmatically add focus to our modal container when it’s opened.

<div>
<img src="{{ '/assets/img/content/uploads/2023/12-15/opening-modal-with-cdk-trap-focus-directive.gif' | relative_url }}" alt="Opening a modal with the cdkTrapFocus directive without programmatic focus" width="860" height="674" style="width: 100%; height: auto;">
</div>

### Providing focus on Initialization With the `cdkTrapFocusAutoCapture` `@Input`

Good news, the `cdkTrapFocus` directive has an auto focus feature built right in. We can use the `cdkTrapFocusAutoCapture` `@Input`. This input will automatically focus the first focusable item within the directive when it’s initialized. It defaults to false so, we need to provide a value of true.

```html
<div cdkTrapFocus [cdkTrapFocusAutoCapture]="true">
    <app-sign-up-form (formSubmitted)="modalClose.emit()"></app-sign-up-form>
    ...
</div>
```

Now when we open the modal the name field is properly focused when it’s opened. And, as we tab through, when we get to the close button, we’ll cycle back to the name field. Also, if we hit `shift` + `tab` to navigate backwards, we’ll go in reverse order all without leaving the modal.

<div>
<img src="{{ '/assets/img/content/uploads/2023/12-15/navigating-modal-with-cdk-trap-focus-directive-and-auto-capture.gif' | relative_url }}" alt="Navigating a modal with the cdkTrapFocus directive and cdkTrapFocusAutoCapture input" width="862" height="674" style="width: 100%; height: auto;">
</div>

So, not only is it super helpful for all users really but it’s super easy to implement too.

{% include banner-ad.html %}

One last thing to note, the trap focus directive keeps track of the last focused element before its initialization, so when we close the modal, the focus is returned to the button that opened it.

Nice, we just saved a ton of work and made our modal more accessible.

## Want to See It in Action?
Check out the demo code and examples of these techniques in the stackblitz example below. If you have any questions or thoughts, don’t hesitate to leave a comment.

<iframe src="https://stackblitz.com/edit/stackblitz-starters-2bznzs?ctl=1&embed=1&file=src%2Fsign-up-modal%2Fsign-up-modal.component.html" style="height: 500px; width: 100%; margin-bottom: 1.5em; display: block;">  
