---
layout: post
title: "Host Decorators Are Dead… Use Host Element Binding Instead"
date: "2024-07-05"
video_id: "hfu0edMz_fk"
tags: 
  - "Angular"
---

<p class="intro"><span class="dropcap">I</span>n the newest versions of Angular, the <a href="https://angular.dev/guide/components/host-elements#the-hostbinding-and-hostlistener-decorators">@HostBinding</a> and <a href="https://angular.dev/guide/components/host-elements#the-hostbinding-and-hostlistener-decorators">@HostListener</a> decorators are no longer intended for use. As the new <a href="https://angular.dev/guide/components/host-elements/">documentation</a> states, they “exist exclusively for backwards compatibility”. There’s a new, more streamlined way to do this type of thing, and if you’ve worked with Angular in the past, it may look familiar to you. It’s kind of an old concept made new again. In this video we’ll look at a couple of examples I created for past videos about these decorators, and we’ll replace them with the newer methods. Also, we’ll update a few other concepts in these components and directives along the way too. Ok, let’s start with a @HostBinding example.</p>

<iframe width="1280" height="720" src="https://www.youtube.com/embed/hfu0edMz_fk" title="" frameborder="0" allow="accelerometer; autoplay; clipboard-write; encrypted-media; gyroscope; picture-in-picture; web-share" allowfullscreen></iframe>

## Using Host Element Class Binding to Replace the @HostBinding Decorator

We have [this application](https://stackblitz.com/edit/stackblitz-starters-ef6phx?file=src%2Fform%2Fform.component.ts) that was originally created to [demonstrate different ways to bind classes on elements](https://youtu.be/IBuZv_WmyrE). 

<div>
<img src="{{ '/assets/img/content/uploads/2024/07-05/demo-1.png' | relative_url }}" alt="Example of a simple email subscription form component with" width="644" height="326" style="width: 100%; height: auto;">
</div>

For one of the examples in this video, I used the @HostBinding decorator to conditionally bind a class on the host element of this form component when the email field status changes from invalid to valid.

<div>
<img src="{{ '/assets/img/content/uploads/2024/07-05/demo-2.png' | relative_url }}" alt="Example of a component class added with the Angular @HostBinding decorator" width="790" height="230" style="width: 100%; height: auto;">
</div>

So, If I add a valid email here, you can see that the style changes.

<div>
<img src="{{ '/assets/img/content/uploads/2024/07-05/demo-3.png' | relative_url }}" alt="Example of several styles changing when a form's validity changes by toggling a class with the Angular @HostBinding decorator" width="668" height="388" style="width: 100%; height: auto;">
</div>

Now part of this is the host bound class changing, and the rest is a class that’s toggled on the body. All of this happens in an observable subscription to the email control’s status change.

<div>
<img src="{{ '/assets/img/content/uploads/2024/07-05/demo-4.png' | relative_url }}" alt="Example of several styles changing within a reactive form control value change observable subscription" width="842" height="386" style="width: 100%; height: auto;">
</div>

So, let’s modernize all of this. First, we can remove the @HostBinding decorator and we can remove its import too since we won’t need it anymore.

Ok, what we'll use now is something that existed back in the day, after we switched from [AngularJS](https://angularjs.org/) to Angular 2 or modern Angular. We'll use the old/new host property on the component decorator.

In this property, we can bind classes just as we would in the template. Since we’re binding a “valid” class, we’ll use square brackets to bind to the class attribute. And then this class will be bound to our “isValid” property.

#### form.component.ts
```typescript
@Component({
  selector: 'app-form',
  ...
  host: {
    '[class.valid]': 'isValid'
  }
})
export class FormComponent {
    private isValid = false;
    ...
}
```

Ok, at this point, what we have now is equivalent to what we had before we removed the decorator, but there’s still more we can do here.

### How to Convert Form Value Observable to a Signal

One thing we can do is use [signals](https://angular.dev/guide/signals) to bind directly to the email control value status with the new [toSignal()](https://angular.dev/api/core/rxjs-interop/toSignal) function. This function will convert an observable to a signal.

So, we need to pass it the control status changes observable. Then we’ll add a [pipe](https://rxjs.dev/api/index/function/pipe), and we’ll [map](https://rxjs.dev/api/operators/map) the status so that we can return a Boolean value based on whether the control status is valid or not.

```typescript
private isValid = toSignal(this.emailControl.statusChanges
    .pipe(map(status => { return status === 'VALID'; })));
```

So now this “isValid” property is a signal that will automatically update when status of the control changes. This means that we’ll need to add parenthesis to the property in our class binding.

#### Before:
```typescript
host: {
    '[class.valid]': 'isValid'
}
```

#### After:
```typescript
host: {
    '[class.valid]': 'isValid()'
}
```

Ok, now that the status change has been converted to a signal, we can actually use the new [effect()](https://angular.dev/guide/signals#effects) function to toggle the valid class on the body instead of the subscription.

### How to Use an effect() to Toggle a Class When a Form Field Status Changes

To do this, let’s add the effect() function within the constructor. Then we can just copy the code that toggles the class currently and paste it into the effect().

Then we just need to change this condition to instead use the “isValid” signal. Now this will execute every time the “isValid” signal value changes, so we won’t need the old subscription. We won’t need the OnInit() method anymore either. We can remove the DestroyRef too. Then, we can remove all of the imports as well.

```typescript
constructor(private renderer: Renderer2) {
    effect(() => {
      this.isValid() 
        ? this.renderer.addClass(document.body, 'valid')
        : this.renderer.removeClass(document.body, 'valid');
    });
}
```

Ok, that’s about all we can probably change here. Now it should look and work just like it did before, but everything is now updated to work in a modern Angular way without the @HostBinding decorator.

So that’s the new way to bind to the host element, but what about host events using the @HostListener decorator? Well, this has changed too.

## Using Host Element Events to Replace the @HostListener Decorator

We have [an example](https://stackblitz.com/edit/stackblitz-starters-zhmaxq?file=src%2Fhost-listener.directive.ts) that, like the last demo, was created to [demonstrate different ways to listen to events in Angular](https://youtu.be/IBuZv_WmyrE).

For one of the examples I used the @HostListener decorator to listen for a click event on the host of a directive and emit the event using the @Output decorator and an EventEmitter.

<div>
<img src="{{ '/assets/img/content/uploads/2024/07-05/demo-5.png' | relative_url }}" alt="Example of a @HostListener click event emitting a value with the @Output decorator" width="862" height="280" style="width: 100%; height: auto;">
</div>

So, if I simply click on the “submit” button, we will see a message that the button click occurred.

<div>
<img src="{{ '/assets/img/content/uploads/2024/07-05/demo-6.gif' | relative_url }}" alt="Example of a @HostListener click event emitting a value with the @Output decorator" width="570" height="316" style="width: 100%; height: auto;">
</div>

So just like the @HostBinding decorator, we can remove the @Hostlistener because we don’t need it anymore. We’ll instead use the host property again.

And this time, since we’re binding to an event, we’ll use parenthesis. When the event fires, we’ll call our handleHostClick() function and we’ll pass it the click event.

#### host-listener.directive.ts
```typescript
@Directive({
  selector: '[appHostListener]',
  ...
  host: {
    '(click)': 'handleHostClick($event)'
  }
})
export class HostListenerDirective {
  @Output() buttonClick = new EventEmitter<PointerEvent>();
  private handleHostClick(event: PointerEvent) {
    event.preventDefault();
    this.buttonClick.emit(event);
  }
}
```

### How to Convert an Output Using the @Output Decorator to the New output() Function

Ok, now that we got rid of the @HostListener, we can also update this output to use the new [output()](https://angular.dev/guide/components/output-fn) function instead.

We can then remove the @Output decorator and the EventEmitter too since neither are needed with the new output() function. Then, we can replace them the new output() function.

#### Before:
```typescript
@Output() buttonClick = new EventEmitter<PointerEvent>();
```

#### After:
```typescript
buttonClick = output<PointerEvent>();
```

And everything else remains the same for this so we don’t need to change anything else.

So, that’s about all we can update in this directive, If we were to save we should see everything working working the same as it did with the @HostListener decorator, @Output decorator, and EventEmitter, but it's now all updated to work in a modern Angular way.

{% include banner-ad.html %}

## Conclusion

Ok, so that’s about it. Now you should have a solid understanding of how to bind to and listen to events on component and directive host elements without using the old decorators.

I hope you found this tutorial helpful, and if you did, check out [my YouTube channel](https://www.youtube.com/@briantreese) for more tutorials about various topics and features within Angular.

## Want to See It in Action?
Check out the demo code and examples of these techniques in the in the Stackblitz example below. If you have any questions or thoughts, don’t hesitate to leave a comment.

### After Replacing the @HostBinding Decorator
<iframe src="https://stackblitz.com/edit/stackblitz-starters-jfcdps?ctl=1&embed=1&file=src%2Fform%2Fform.component.ts" style="height: 500px; width: 100%; margin-bottom: 1.5em; display: block;"></iframe>

### After Replacing the @HostListener Decorator
<iframe src="https://stackblitz.com/edit/stackblitz-starters-anxtb5?ctl=1&embed=1&file=src%2Fhost-listener.directive.ts" style="height: 500px; width: 100%; margin-bottom: 1.5em; display: block;"></iframe>

