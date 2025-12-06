---
layout: post
title: "Event Listening in Angular: The Updated Playbook for 2025"
date: "2025-06-19"
video_id: "slt4bVO_-YU"
tags:
  - "Accessibility"
  - "Angular"
  - "Angular Components"
  - "Angular Model"
  - "Angular Outputs"
  - "Angular Signals"
---

<p class="intro"><span class="dropcap">E</span>vent handling in Angular has evolved significantly, with modern patterns replacing deprecated decorators and improving type safety. This updated tutorial demonstrates the latest event listening techniques in Angular, covering template event bindings, host event bindings, Renderer2 for global events, and the <code>output()</code> function for component communication. You'll learn when to use each approach and how to avoid deprecated patterns like <code>@HostListener</code> and <code>@Output</code> decorators.</p>

{% include youtube-embed.html %}

{% include update-banner.html title="Updated for Modern Angular" message="This tutorial has been updated for 2025 with modern Angular patterns. Note that <code>@HostListener</code> and <code>@Output</code> are no longer recommended - use host event bindings and the <code>output()</code> function instead." %}

## Event Binding: Still The Everyday Tool

First up, we have basic [event binding](https://angular.dev/guide/templates/event-listeners){:target="_blank"}.

In my previous tutorial, I mentioned that this should basically be the default way to listen to events, and only if it doesn’t work would you need something else. 

Well, this is still true even in modern Angular.

It can easily be added any time you need to react to a [click](https://developer.mozilla.org/en-US/docs/Web/API/Element/click_event){:target="_blank"}, a [focus](https://developer.mozilla.org/en-US/docs/Web/API/Element/focus_event){:target="_blank"}, a [blur](https://developer.mozilla.org/en-US/docs/Web/API/Element/blur_event){:target="_blank"}, or any other event along those lines.

All you need to do is simply add parentheses with the event name inside.

In this case we are listening to [focus](https://developer.mozilla.org/en-US/docs/Web/API/Element/focus_event){:target="_blank"}, [blur](https://developer.mozilla.org/en-US/docs/Web/API/Element/blur_event){:target="_blank"}, and [input](https://developer.mozilla.org/en-US/docs/Web/API/Element/input_event){:target="_blank"} events on this textbox. 

When any of these events fire, we add a message to our messages array:

```html
<input
    type="text"
    id="textbox"
    (focus)="messages.push('input focus')"
    (blur)="messages.push('input blur')"
    (input)="messages.push('input input')"
/>
```

So, when we [focus](https://developer.mozilla.org/en-US/docs/Web/API/Element/focus_event){:target="_blank"} in the input, we see a message for the focus event:

<div>
<img src="{{ '/assets/img/content/uploads/2025/06-19/demo-1.png' | relative_url }}" alt="An example of a focus event being logged to the console using event binding" width="854" height="366" style="width: 100%; height: auto;">
</div>

When we [blur](https://developer.mozilla.org/en-US/docs/Web/API/Element/blur_event){:target="_blank"}, we get a message for that event too.

<div>
<img src="{{ '/assets/img/content/uploads/2025/06-19/demo-2.png' | relative_url }}" alt="An example of a blur event being logged to the console using event binding" width="824" height="456" style="width: 100%; height: auto;">
</div>

Then when we type in the textbox, the [input](https://developer.mozilla.org/en-US/docs/Web/API/Element/input_event){:target="_blank"} event fires.

<div>
<img src="{{ '/assets/img/content/uploads/2025/06-19/demo-3.png' | relative_url }}" alt="An example of an input event being logged to the console using event binding" width="820" height="1002" style="width: 100%; height: auto;">
</div>

This type of event binding in Angular is simple and effective. 

But, it won’t always work.

## Host Event Binding: The Modern Angular Way

Sometimes you may find that you need to bind to events on the [host element](https://angular.dev/guide/components/host-elements){:target="_blank"} of a component or directive.

In my previous tutorial we had a custom [host-listener directive](https://stackblitz.com/edit/stackblitz-starters-3srm2utq?file=src%2Fhost-listener%2Fhost-listener.directive.ts):

```typescript
import { Directive, EventEmitter, HostListener, Output } from '@angular/core';

@Directive({
    selector: '[appHostListener]',
})
export class HostListenerDirective {
    @Output() buttonClick = new EventEmitter<PointerEvent>();
    @HostListener('click', ['$event']) 
    handleHostClick(event: PointerEvent) {
        event.preventDefault();
        this.buttonClick.emit();
    }
}
```

Now I’m not sure how realistic of an example this directive is because all it does is listen for a [click event](https://developer.mozilla.org/en-US/docs/Web/API/Element/click_event){:target="_blank"} on the host and then emit that event.

It’s really basic, but in that tutorial, we used the [@HostListener](https://angular.dev/api/core/HostListener){:target="_blank"} decorator to listen for those [click events](https://developer.mozilla.org/en-US/docs/Web/API/Element/click_event){:target="_blank"} because that was the right way to do it at the time.

But now, the [@HostListener](https://angular.dev/api/core/HostListener){:target="_blank"} decorator is no longer recommended for use. 

Instead, we should use the [host](https://angular.dev/api/core/Component#host){:target="_blank"} metadata property on the component or directive.

In this object, we bind to events just like we do in the template: we use parentheses with the event name. 

Then we can just call our same function and pass it the event.

Then we can remove the decorator and its import:

```typescript
import { Directive, output } from '@angular/core';

@Directive({
    selector: '[appHostListener]',
    host: {
        '(click)': 'handleHostClick($event)'
    }
})
export class HostListenerDirective {
    private handleHostClick(event: PointerEvent) {
        ...
    }
}
```

This is the modern way to listen to events on component or directive host elements.

In this [example component](https://stackblitz.com/edit/stackblitz-starters-3srm2utq?file=src%2Fexample%2Fexample.component.html) we’re currently using this directive on the “submit” button:

```html
<button 
    appHostListener 
    (buttonClick)="messages.push('button click')">
    Submit
</button>
```

When the [click event](https://developer.mozilla.org/en-US/docs/Web/API/Element/click_event){:target="_blank"} from the host is emitted, we add a “button click” message:

<div>
<img src="{{ '/assets/img/content/uploads/2025/06-19/demo-4.gif' | relative_url }}" alt="An example of a button click event being logged to the console using the host property" width="842" height="704" style="width: 100%; height: auto;">
</div>

So don’t use the [@HostListener](https://angular.dev/api/core/HostListener){:target="_blank"} decorator anymore, this is the new way to do it.

## Custom Events: Outputs (Updated)

Now, something else that we were doing in [this directive](https://stackblitz.com/edit/stackblitz-starters-3srm2utq?file=src%2Fhost-listener%2Fhost-listener.directive.ts) was using the [@Output](https://angular.dev/api/core/Output){:target="_blank"} decorator and an [EventEmitter](https://angular.dev/api/core/EventEmitter){:target="_blank"} to emit this custom event:

```typescript
import { ..., EventEmitter, Output } from '@angular/core';

export class HostListenerDirective {
    @Output() buttonClick = new EventEmitter<PointerEvent>();
    ...
    handleHostClick(event: PointerEvent) {
        ...
        this.buttonClick.emit();
    }
}
```

This is because [@Output](https://angular.dev/api/core/Output){:target="_blank"} and [EventEmitter](https://angular.dev/api/core/EventEmitter){:target="_blank"} were the standard for custom events, but now it’s all about the [output()](https://angular.dev/api/core/output){:target="_blank"} function.

So, we can just switch this to the new [output()](https://angular.dev/api/core/output){:target="_blank"} function and we can remove the [EventEmitter](https://angular.dev/api/core/EventEmitter){:target="_blank"} because it’s no longer needed when using this new function:

```typescript
buttonClick = output<PointerEvent>();
```

Other than that, it basically stays the same. 

Just use the emit() function to send out the event. (We actually had this wrong in the original example!):

```typescript
this.buttonClick.emit(event);
```

So, don’t use the old [@Output](https://angular.dev/api/core/Output){:target="_blank"} decorator and [EventEmitter](https://angular.dev/api/core/EventEmitter){:target="_blank"} anymore, use the new [output()](https://angular.dev/api/core/output){:target="_blank"} function instead.

## Global Events: Renderer2 Listeners

Okay, now what about listening to global events?

Well, just like the previous tutorial, when we need to listen to global events in Angular, we can still use the [Renderer2](https://angular.dev/api/core/Renderer2){:target="_blank"} class and its [listen()](https://angular.dev/api/core/Renderer2#listen){:target="_blank"} method like we’re doing here:

```typescript
ngOnInit() {
    this.bodyClickListener = this.renderer.listen(
        document.body,
        'click',
        (event) => {
            this.messages.push('body click');
        }
    );
}
```

The idea here is to use the [Renderer2](https://angular.dev/api/core/Renderer2){:target="_blank"} [listen()](https://angular.dev/api/core/Renderer2#listen){:target="_blank"} method, passing in the element you want to listen on, in this case, the body. 

Then we pass the event that we want to monitor, in this case it’s [click events](https://developer.mozilla.org/en-US/docs/Web/API/Element/click_event){:target="_blank"} on the body.

When listening to events like this, though, we have to handle the cleanup manually to prevent performance issues, which is what we’re doing here in the [ngOnDestroy](https://angular.dev/api/core/OnDestroy){:target="_blank"} lifecycle hook:

```typescript
ngOnDestroy() {
    this.bodyClickListener?.();
}
```

So now, if we save, whenever we click anywhere in the body, an event fires:

<div>
<img src="{{ '/assets/img/content/uploads/2025/06-19/demo-5.gif' | relative_url }}" alt="An example of a global body click event being logged to the console using the Renderer2 listen method" width="860" height="932" style="width: 100%; height: auto;">
</div>

This is more of a rare situation in Angular and really should be used as a last resort when nothing else will work.

## Bonus: The model() Input Pattern

Ok, now we have the new kid on the block… [model()](https://angular.dev/api/core/model){:target="_blank"} inputs.

Think of this as [two-way binding](https://angular.dev/guide/templates/two-way-binding){:target="_blank"} for the modern Angular era.

To add this concept, we’ll add a “value” property using the new [model()](https://angular.dev/api/core/model){:target="_blank"} function, and it’ll be typed as a string:

```typescript
import { ..., model } from '@angular/core';

@Component({
    selector: 'app-example',
    ...
})
export class ExampleComponent implements OnInit, OnDestroy {
    value = model<string>();
    ...
}
```

Now, let’s jump to the template.

Here we’ll add a [template reference variable](https://angular.dev/guide/templates/variables#template-reference-variables) to grab the current value, then we’ll wire up our input event to keep the model in sync:

```html
<input
    type="text"
    ...
    #textbox
    (input)="
        messages.push('input input'); 
        value.set(textbox.value)"
/>
```


A [model()](https://angular.dev/api/core/model){:target="_blank"} input is like an [input](https://angular.dev/guide/components/inputs){:target="_blank"} and an [output](https://angular.dev/guide/inputs-outputs){:target="_blank"} in one, so it keeps the value in sync between the parent and child components.

So, if there was a value coming from the parent it would flow through like an [input](https://angular.dev/guide/components/inputs){:target="_blank"}. 

Then, when we change the value in the child, it gets emitted back up to the parent.

So, here we also need to bind the value of the textbox to the model as well:

```html
<input
    ...
    [value]="value()"
/>
```

Now let’s switch to the [root app component](https://stackblitz.com/edit/stackblitz-starters-3srm2utq?file=src%2Fmain.ts){:target="_blank"} where this component is included.

The first thing we need to do is add a property, let’s call it "formValue", and it will be a [signal](https://angular.dev/guide/signals#writable-signals){:target="_blank"} initialized to some default label:

```typescript
import { ..., signal } from '@angular/core';

export class AppComponent {
    protected readonly formValue = signal('test');
}
```

Okay, now we can use the "banana in a box" syntax, that's [two-way binding](https://angular.dev/guide/templates/two-way-binding){:target="_blank"}, to bind to the value [model()](https://angular.dev/api/core/model){:target="_blank"} input:

```html
<app-example [(value)]="formValue"></app-example>
```

It’s important to note that when using [two-way binding](https://angular.dev/guide/templates/two-way-binding){:target="_blank"} like this, we don’t include the parentheses for the signal.

Now, there’s a [slot](https://angular.dev/guide/components/content-projection){:target="_blank"} in this component between the form and the list of events so here we’re going to output the value of this property so we can see how this works as we interact with the form:

```html
<app-example [(value)]="formValue">
    <pre>Value: {% raw %}{{ formValue() }}{% endraw %}</pre>
</app-example>  
```

Let's save and see how this looks:

<div>
<img src="{{ '/assets/img/content/uploads/2025/06-19/demo-6.gif' | relative_url }}" alt="An example of a model input updating the child and parent values" width="1058" height="512" style="width: 100%; height: auto;">
</div>

Now, when the app is initialized, we can see that the value of this property is passed to the child just like a standard signal input.

But now, when we type in this field the value emits back to the parent and updates the property in the parent too.

So, just like that, you’ve got a value that flows smoothly between parent and child, updates reactively, and feels right at home in a modern Angular app.

## Let’s Recap the Modern Angular Playbook

So now you’ve got five battle-tested ways to handle events in modern Angular.

Whether you like it simple, modern, or just a little fancy.

If you saw my original tutorial, now you’ve got the updated edition, complete with new syntax and a bonus modern approach.

Let’s recap:

- Standard event binding: simple and works in most cases.

- Host events now use the [host property](https://angular.dev/api/core/Component#host) instead of the old decorator.

- Custom events use the new [output()](https://angular.dev/api/core/output){:target="_blank"} function instead of the old decorator and [EventEmitter](https://angular.dev/api/core/EventEmitter){:target="_blank"}.

- Global events can still use [Renderer2](https://angular.dev/api/core/Renderer2){:target="_blank"} but it should really be a last resort.

- And then we have the new [model()](https://angular.dev/api/core/model){:target="_blank"} input, a modern two-way binding concept with signals.

If you found this helpful, don't forget to [subscribe](https://www.youtube.com/c/briantreese?sub_confirmation=1) and check out [my other Angular tutorials](https://www.youtube.com/@briantreese) for more tips and tricks!

{% include banner-ad.html %}

## Additional Resources

- [The demo app BEFORE any changes](https://stackblitz.com/edit/stackblitz-starters-3srm2utq?file=src%2Fhost-listener%2Fhost-listener.directive.ts)
- [The demo app AFTER making changes](https://stackblitz.com/edit/stackblitz-starters-mdvckkrv?file=src%2Fhost-listener%2Fhost-listener.directive.ts)
- [Angular: Adding event listeners](https://angular.dev/guide/templates/event-listeners)
- [Angular: Binding to the host element](https://angular.dev/guide/components/host-elements#binding-to-the-host-element)
- [Model inputs](https://angular.dev/guide/components/inputs#model-inputs)
- [Modern Inputs & Outputs in Angular](https://angular.dev/guide/components/inputs)
- [Angular Renderer2 Documentation](https://angular.dev/api/core/Renderer2)
- [My course: "Angular: Styling Applications"](https://www.pluralsight.com/courses/angular-styling-applications)

## Want to See It in Action?

Want to experiment with the final version? Explore the full StackBlitz demo below. If you have any questions or thoughts, don’t hesitate to leave a comment.

<iframe src="https://stackblitz.com/edit/stackblitz-starters-mdvckkrv?ctl=1&embed=1&file=src%2Fhost-listener%2Fhost-listener.directive.ts" style="height: 500px; width: 100%; margin-bottom: 1.5em; display: block;"></iframe>
