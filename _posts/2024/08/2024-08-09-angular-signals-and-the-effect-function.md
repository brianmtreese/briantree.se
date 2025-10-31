---
layout: post
title: "Feeling the Effects With the Angular effect() Function"
date: "2024-08-01"
video_id: "5d2_TIU176c"
tags: 
  - "Angular"
  - "Angular Signals"
  - "Angular Effects"
---

<p class="intro"><span class="dropcap">S</span>ignals are a pretty big deal in Angular now a days. <a href="https://www.youtube.com/playlist?list=PLp-SHngyo0_iVhDOLRQTFDenpaAXy10CB">I’ve created several videos on them</a> recently because there’s a lot to consider when using them. As you use them more over time, you’ll probably run into scenarios where you need to execute code when signal values change. Now, one way to do this is to use <a href="https://angular.dev/guide/signals#computed-signals">computed signals</a> which is something <a href="https://www.youtube.com/watch?v=GSkDLJG3104&list=PLp-SHngyo0_iVhDOLRQTFDenpaAXy10CB&index=2">I’ve covered in the past</a>, but there is a possibility that even this won’t work for your situation. We’ll if this is the case, there is another possibility. You can use the <a href="https://angular.dev/guide/signals#effects">effect function</a>.</p>

{% include youtube-embed.html %}

## The Effect Function

The [effect() function](https://angular.dev/guide/signals#effects) works a lot like the [computed() function](https://angular.dev/guide/signals#computed-signals). It allows us to react when the value of a Signal or multiple Signals change.

When using an effect, you can count on it to run at least once, and then it will only run when a Signal within it changes.

### Why Use an Effect When You can Use a Computed Signal?

With all of that said, if you are familiar with computed signals, you are probably asking yourself, “why would I use an effect?”

Well, that’s a good question. The truth is, you should use a computed signal if you can. An effect should only be used when a computed signal won’t work. They are handy for things like debugging, or executing code that that can’t be run using the standard template syntax.

So, in this post we’ll look at a couple of different use cases. Up first, let’s look at a simple example, logging out the value of a signal as it changes.

## Debugging a Signal Value with the Effect Function

In this post, we’ll be using a demo application “Petpix”. In this app, we have a “details” button in the bottom right corner of each image.

<div>
<img src="{{ '/assets/img/content/uploads/2024/08-09/demo-1.png' | relative_url }}" alt="The demo pet photo sharing application Petpix with 'details' button that doesn't do anything" width="792" height="1090" style="width: 100%; height: auto;">
</div>

Right now, it doesn’t do anything when we click it. But, if we look at [the code for this button](https://stackblitz.com/edit/stackblitz-starters-rwzwb8?file=src%2Fslider%2Fphoto-details%2Fphoto-details.component.html), currently it toggles the value of a “detailsVisible” signal when clicked.

#### photo-details.component.html
```html
<button (click)="detailsVisible.set(!detailsVisible())">
    ...
</button>
```

Now, let’s say we need to troubleshoot this signal value for some reason. This is a great use case for the effect function.

Now, in order to use this function, we need to use it within an [“injection context”](https://angular.dev/guide/di/dependency-injection-context). The easiest way to do this is use the constructor.

Within the constructor, we just need to add the effect function. Then, within the callback, we can log out the value of our “detailsVisible” signal.

#### photo-details.component.ts
```typescript
import { ..., effect } from "@angular/core";

export class PhotoDetailsComponent {
    ...
    constructor() {
        effect(() => {
            console.log('Visible', this.detailsVisible());
        });
    }
}
```

Now, we should be able to save and see the value of the signal in the console when we click the button.

<div>
<img src="{{ '/assets/img/content/uploads/2024/08-09/demo-2.png' | relative_url }}" alt="Console showing a value of true after clicking the button when using an effect to log out the value of a signal" width="990" height="510" style="width: 100%; height: auto;">
</div>

Ok, we can see that the value is true after we click it, and when we click it again, false is logged out.

<div>
<img src="{{ '/assets/img/content/uploads/2024/08-09/demo-3.png' | relative_url }}" alt="Console showing a value of false after clicking the button when using an effect to log out the value of a signal" width="862" height="518" style="width: 100%; height: auto;">
</div>

So, an effect can come in handy when troubleshooting signals.

## Using the Effect Function to Call a Service When a Signal Value Changes

An effect can also be used in situations where we simply need to react to the change of a signal. Like, when we need to call a [service](https://angular.dev/guide/di/creating-injectable-service).

In this example, we want to call our [modal service](https://stackblitz.com/edit/stackblitz-starters-rwzwb8?file=src%2Fmodal%2Fmodal.service.ts) to open a modal when the signal value changes.

In our constructor, we’re already injecting our modal service.

#### photo-details.component.ts
```typescript
import { ModalService } from "../../modal/modal.service";

export class PhotoDetailsComponent {
    ...
    constructor(private modal: ModalService) {
    }
}
```

So, we can add an effect. Then, within the callback, if our “detailsVisible” signal changes to true, we can call the open method on our modal service. This method requires a [CdkPortal](https://material.angular.io/cdk/portal/overview) instance which we already have access to with a [viewChild](https://angular.dev/guide/signals/queries#viewchild). So, we just need to pass the portal as a parameter to our modal service open() method.

#### photo-details.component.ts
```typescript
import { CdkPortal } from '@angular/cdk/portal';

export class PhotoDetailsComponent {
    protected modalContent = viewChild<CdkPortal>(CdkPortal);
    ...
    constructor(private modal: ModalService) {
        if (this.detailsVisible()) {
            this.modal.open(this.modalContent()!);
        }
    }
}
```

This portal contains the content to be displayed in the modal for the given image.

So, now let’s save and click the details button to see how it looks.

<div>
<img src="{{ '/assets/img/content/uploads/2024/08-09/demo-4.gif' | relative_url }}" alt="Example of a modal service opening a modal when a signal value changes using an effect" width="776" height="1074" style="width: 100%; height: auto;">
</div>

Now the modal opens up with the info for this image when the button is clicked and the signal is changed.

So, that’s another handy use case for an effect, calling a service when a signal value changes.

## Using the Effect Function to Execute Timer-Based Logic After a Signal Value Changes

Another useful scenario is to execute timer-based logic when a signal value changes.

So, let’s say we want the modal to open when the component is initialized, and then automatically close it after a certain time duration.

To do this, let’s add the [ngAfterViewInit](https://angular.dev/api/core/AfterViewInit) method. Then, within this method, let’s use our modal service to automatically open the modal on view init.

#### photo-details.component.ts
```typescript
import { ..., AfterViewInit } from "@angular/core";

export class PhotoDetailsComponent {
    ...
    ngAfterViewInit() {
        this.modal.open(this.modalContent()!);
    }
}
```

Then, let’s add an effect within the constructor. Within this effect, let’s add a condition to check the value of our "image" input. Then let’s add a [setTimeout](https://developer.mozilla.org/en-US/docs/Web/API/setTimeout) function, and within this function, let’s call the close method on our modal service after five seconds.

#### photo-details.component.ts
```typescript
export class PhotoDetailsComponent {
    ...
    constructor(private modal: ModalService) {
        effect(() => {
            if (this.image()) {
                setTimeout(() => this.modal.close(), 5000);
            }
        });
    }
}
```

So, now it should open the modal when the component is initialized, the modal should remain open for five seconds, and then it should automatically close.

So, let’s save and see how it looks.

<div>
<img src="{{ '/assets/img/content/uploads/2024/08-09/demo-5.gif' | relative_url }}" alt="Example opening a modal on init and then closing after after a timer executes using an effect" width="776" height="1072" style="width: 100%; height: auto;">
</div>

We can see the modal opened and then closed automatically after five seconds. 

So, this code triggers the component to initialize which causes the modal to open up. It also triggers the effect to run because the "image" input value changed which starts the five second timer. Then once that timer completes, the close method is called, and the modal is closed.

So, this is another handy use for the effect function.

## Updating a Form Control Value with the Effect Function

Now, just to give you another idea of a use case for the effect function, let’s look at an example where we set the value of a [form control](https://angular.dev/guide/forms/reactive-forms#adding-a-basic-form-control) when the value of a signal input changes.

In this example, we’ll be working with our [description form component](https://stackblitz.com/edit/stackblitz-starters-rwzwb8?file=src%2Fslider%2Fdescription-form%2Fdescription-form.component.ts). This component has a “description” Form Control for the description textarea.

#### description-form.component.ts
```typescript
import { FormControl, FormsModule, ReactiveFormsModule } from '@angular/forms';

export class DescriptionFormComponent {
    protected description = new FormControl<string>('');
}
```

This component also has an input for the “imageDescription” value.

#### description-form.component.ts
```typescript
import { ..., input } from "@angular/core";

export class DescriptionFormComponent {
    imageDescription = input<string | null>();
}
```

What we want to do is, when this input value changes, we want to set the value of the form control to the value of this input.

So, let’s add a constructor and an effect. Within this effect, let’s call the [setValue()](https://angular.dev/guide/forms/reactive-forms#replacing-a-form-control-value) function on our description form control and pass it the value of our "imageDescription" input.

#### description-form.component.ts
```typescript
export class DescriptionFormComponent {
    ...
    constructor() {
        effect(() => {
            this.description.setValue(this.imageDescription()!);
        });
    }
}
```

Ok, that should do it. Let’s save and see how it works.

<div>
<img src="{{ '/assets/img/content/uploads/2024/08-09/demo-6.gif' | relative_url }}" alt="Example of a form control value getting set when a signa value changes using an effect" width="776" height="1074" style="width: 100%; height: auto;">
</div>

Now we have the description value automatically set within the textarea. And as we switch to the different images, we can see that the description value changes as the image changes.

So just another possible use case for an effect.

{% include banner-ad.html %}

## In Conclusion

The bottom line is that you should avoid using an effect if you can. But if you run into a scenario where a computed signal won’t work, you should consider an effect. And the examples you’ve seen here are not an exhaustive list, just a few ideas that could possibly require an effect.

I hope you found this tutorial helpful, and if you did, check out [my YouTube channel](https://www.youtube.com/@briantreese) for more tutorials about various topics and features within Angular.


## Additional Resources
* [The official Angular effects Documentation](https://angular.dev/guide/signals#effects)
* [The official Angular signals Documentation](https://angular.dev/guide/signals)

## Want to See It in Action?
Check out the demo code and examples of these techniques in the Stackblitz example below. If you have any questions or thoughts, don’t hesitate to leave a comment.

<iframe src="https://stackblitz.com/edit/stackblitz-starters-8rywdq?ctl=1&embed=1&file=src%2Fslider%2Fphoto-details%2Fphoto-details.component.ts" style="height: 500px; width: 100%; margin-bottom: 1.5em; display: block;"></iframe>

