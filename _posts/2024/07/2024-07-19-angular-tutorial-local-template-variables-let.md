---
layout: post
title: "Angular Tutorial: Local Component Template Variables with @let"
date: "2024-07-19"
video_id: "DYDzf2JOOho"
categories: 
  - "angular"
---

<p class="intro"><span class="dropcap">I</span>n Angular, we can now create variables for reuse right within our component templates. Now that might seem odd but it’s actually pretty cool. If you’re like me, you may have a hard time understanding the benefits at first. So, in this example, I’ll show you how to create these template variables, and then I’ll show you several different possible use cases and benefits to help you better understand why you may want to use them in your projects.</p>

<iframe width="1280" height="720" src="https://www.youtube.com/embed/DYDzf2JOOho" title="" frameborder="0" allow="accelerometer; autoplay; clipboard-write; encrypted-media; gyroscope; picture-in-picture; web-share" allowfullscreen></iframe>

## The Anatomy of the @let Syntax

To create a template variable we need to add the @ symbol, followed by the word “let”. The variables set with this [@let syntax](https://angular.dev/guide/templates/let-template-variables) are a lot like variables set using [JavaScript’s let declaration](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Statements/let). So next, we add one or more whitespaces followed by a variable name, and then one or more whitespaces again. Then, as with JavaScript variables, we set it using the equals sign followed by a valid JavaScript expression. This expression can be single or multi-line expression, and then we terminate the expression with a semicolon.

```html
@let name = expression;
```

So that’s how we create them, now let’s look at a few use cases.

## A Simple String Variable Example

Let’s start with a basic example to see it in action. In our demo application's [app header component](https://stackblitz.com/edit/stackblitz-starters-l6avsj?file=src%2Fheader%2Fheader.component.html), we’re going to take the brand name “Petpix” and set it to a variable.

To do this, let’s create the variable using the @let syntax, let’s call it “name”. Then, let’s set it to the string “Petpix”, and then we just need to add a semicolon. And to use this variable, in this case we can just string interpolate the value.

#### Before:
```html
<h1>
    <svg ..></svg>
    Petpix
</h1>
```

#### After:
```html
<h1>
    <svg ..></svg>
    @let name = 'Petpix';
    {% raw %}{{ name }}{% endraw %}
</h1>
```

Now if we were to save we would see that nothing changed which is a good thing right? It means that this variable has been set correctly and is working just as we’d expect.

Now this is just a simple example to demonstrate how this syntax works. The only reason I could see to make a variable for something this simple is if this brand name were used in more than one place in this template. So, just keep that in mind.

Ok, how about a little bit more of an advanced example?

## Simplifying Async Pipe Subscriptions With @let

This new syntax can help simplify usages of [observables](https://angular.dev/guide/pipes/unwrapping-data-observables) that use the [async pipe](https://angular.dev/api/common/AsyncPipe). For example, if we open up our [slider component template](https://stackblitz.com/edit/stackblitz-starters-l6avsj?file=src%2Fheader%2Fheader.component.html,src%2Fslider%2Fslider.component.html), we have a “selectedImage” observable used to provide the image description to the [description form component](https://stackblitz.com/edit/stackblitz-starters-l6avsj?file=src%2Fslider%2Fdescription-form%2Fdescription-form.component.html).

#### slider.component.html
```html
@if ($selectedImage | async; as image) {
    <app-description-form [description]="image.description"></app-description-form>
}
```

This observable is updated every time we navigate to a new image. We’re using the async pipe here in order to easily update the view when the observable emits with a new value. And we are also using this same variable and async pipe to conditionally display the location the photo was taken in.

#### slider.component.html
```html
@if ($selectedImage | async; as image) {
    @if (image.location) {
        <h3>Photo Location</h3>
        <address>
            {% raw %}{{ image.location.city }}{% endraw %},
            {% raw %}{{ image.location.state }}{% endraw %}
            {% raw %}{{ image.location.postalCode }}{% endraw %}
        </address>
    }
}
```

Now, in the latest versions of Angular, you may find yourself using observables with the async pipe much less often because we can easily convert them to [signals](https://angular.dev/guide/signals) with the new [toSignal()](https://angular.dev/api/core/rxjs-interop/toSignal) function. And if you’re doing this, this example won’t really provide much value for you.

But for those of you who are still using this configuration, we can simplify it a little with the @let syntax. 

Let’s add a new variable and we’ll add it outside of the “isAnonymous” condition. Let’s call it “image”, and let’s set it to our observable with the async pipe. Then let’s add the [nullish coalescing operator](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Operators/Nullish_coalescing) and if it’s undefined, we’ll fallback to the first image in the list.

#### slider.component.html
```html
@let image = ($selectedImage | async) ?? images[0];
```

And now we can remove this condition wrapping the description form because we’ll always have an image and description with how we’ve set our variable up.

#### Before:
```html
@if ($selectedImage | async; as image) {
    <app-description-form [description]="image.description"></app-description-form>
}
```

#### After:
```html
<app-description-form [description]="image.description"></app-description-form>
```

We can also eliminate this condition wrapping the location since we have our new variable.

#### Before:
```html
@if ($selectedImage | async; as image) {
    @if (image.location) {
        <h3>Photo Location</h3>
        <address>
            {% raw %}{{ image.location.city }}{% endraw %},
            {% raw %}{{ image.location.state }}{% endraw %}
            {% raw %}{{ image.location.postalCode }}{% endraw %}
        </address>
    }
}
```

#### After:
```html
@if (image.location) {
    <h3>Photo Location</h3>
    <address>
        {% raw %}{{ image.location.city }}{% endraw %},
        {% raw %}{{ image.location.state }}{% endraw %}
        {% raw %}{{ image.location.postalCode }}{% endraw %}
    </address>
}
```

So that’s definitely better than it was before but you just may not really need this depending upon your code base. So let’s look at another example.

## Simplifying Repetitive Complex Logic with @let

With @let we can clean up repetitive and complex template logic making things easier to read, understand, and maintain. Let’s look at our slider component template again.

Here we have a pretty long, ugly condition:

#### slider.component.html
```html
@if (!isAnonymous && images.length > 1 && accountType === 'paid') {
    <nav>
        ...
    </nav>
}
```

We check to make sure the user is not anonymous, we check that the list length is greater than one, and we check that the account type is “paid” before we show the buttons to navigate the gallery. Now, not only is this a long, ugly condition, this exact condition is used to conditionally display the description as well.

#### slider.component.html
```html
@if (!isAnonymous && images.length > 1 && accountType === 'paid') {
    <app-description-form [description]="image.description"></app-description-form>
}
```

Well, this is another great use for the @let syntax. Let’s make this condition a variable. Let’s add it at the top of the template. We’ll call it “advancedFeatures”.

#### slider.component.html
```html
@let advancedFeatures = !isAnonymous && images.length > 1 && accountType === 'paid';
```

Ok, now we just need to update both of those conditions to use the new variable.

#### Before:
```html
@if (!isAnonymous && images.length > 1 && accountType === 'paid') {
    <nav>
        ...
    </nav>
}
...
@if (!isAnonymous && images.length > 1 && accountType === 'paid') {
    <app-description-form [description]="image.description"></app-description-form>
}
```

#### After:
```html
@if (advancedFeatures) {
    <nav>
        ...
    </nav>
}
...
@if (advancedFeatures) {
    <app-description-form [description]="image.description"></app-description-form>
}
```

So, this can be a great way to clean up repetitive and complex logic in the template.

## Creating a Dynamic Variable Based on a Form Control Value with @let

We can also do cool things like create dynamic variables based off things like the values of form controls. For example, let’s take a look at our [description form component](https://stackblitz.com/edit/stackblitz-starters-xetajy?file=src%2Fslider%2Fdescription-form%2Fdescription-form.component.html).

Here we have a textarea with its value bound to a description input:

#### description-form.component.html
```html
<textarea
    ...
    [value]="description()"></textarea>
```

Well, we can create a variable based on the value of this field. To do this, we first need to add a template reference variable on the textarea itself.

#### description-form.component.html
```html
<textarea
    ...
    #textarea
    [value]="description()"></textarea>
```

Then, let’s add a new variable called “descriptionVal”. We’ll set this variable accessing the value property off of the reference variable for the textarea. Then we can output the string interpolated value of this variable.

#### description-form.component.html
```html
<p>
    @let descriptionVal = textarea.value;
    <strong>Value:</strong>
    {% raw %}{{ descriptionVal }}{% endraw %}
</p>
```

Ok, now let’s save and take look:

<div>
<img src="{{ '/assets/img/content/uploads/2024/07-19/demo-1.png' | relative_url }}" alt="Example of the output of the variable created using the dynamic value of a textarea" width="772" height="759" style="width: 100%; height: auto;">
</div>

Cool, now we can see the description value repeated out here. That’s nice right? But what’s even more cool is that we can type in this textarea and, when we do, we see the value change as we type.

<div>
<img src="{{ '/assets/img/content/uploads/2024/07-19/demo-2.gif' | relative_url }}" alt="Example of a dynamic variable based on the value of a textarea updating as we type in the textarea" width="582" height="680" style="width: 100%; height: auto;">
</div>

Very cool. So that may come in handy for you in certain situations.

## Signal Type Narrowing with @let

Something else that we can do is use the @let syntax for type narrowing on signal values.

What exactly does this mean? Well, Let’s take a look at an example.

Back in the example for our [slider component](https://stackblitz.com/edit/stackblitz-starters-l6avsj?file=src%2Fheader%2Fheader.component.html,src%2Fslider%2Fslider.component.html), we actually already have a signal for the selected image that we can use instead of the observable. So, we can eliminate the image variable that we added earlier and instead set the description with our “selectedImage” signal.

#### Before:
```html
@let image = ($selectedImage | async) ?? images[0];

@if (advancedFeatures) {
    <app-description-form [description]="image.description"></app-description-form>
}
```

#### After:
```html
@if (advancedFeatures) {
    <app-description-form [description]="selectedImage().description"></app-description-form>
}
```

Now what we can do is create a “location” variable. We’ll set this variable based on the "selectedImage" signal instead, accessing the location object off of that signal. This allows us to simplify this address and also allows us to eliminate the conditional check on each of these as well.

```html
@if (image.location) {
    <h3>Photo Location</h3>
    <address>
        {% raw %}{{ image.location?.city }}{% endraw %},
        {% raw %}{{ image.location?.state }}{% endraw %}
        {% raw %}{{ image.location?.postalCode }}{% endraw %}
    </address>
}
```

#### After:
```html
@let location = selectedImage().location;

@if (location) {
    <h3>Photo Location</h3>
    <address>
        {% raw %}{{ location.city }}{% endraw %},
        {% raw %}{{ location.state }}{% endraw %}
        {% raw %}{{ location.postalCode }}{% endraw %}
    </address>
}
```

So overall, this syntax can really help simplify a lot of different things right within component template. And this is pretty handy, but there are a couple of things to be aware of.

## Variables Using @let Syntax Can’t be Reassigned

First, unlike JavaScript variables set using let, these template variables are read-only and cannot be reassigned.

Now, they will update when the view changes like what we saw when the description input changed on our description form, but if we try to reassign the variable directly, we’ll get an error.

For example, if we try to redeclare the “advancedFeatures” variable in our [slider component](https://stackblitz.com/edit/stackblitz-starters-xetajy?file=src%2Fslider%2Fslider.component.html%3AL97), we won’t be able to. Let’s go ahead and set it to false right after its original declaration.

#### slider.component.html
```html
@let advancedFeatures = !isAnonymous && images.length > 1 && accountType === 'paid';
@let advancedFeatures = false;
```

Now let’s save and see what happens:

<div>
<img src="{{ '/assets/img/content/uploads/2024/07-19/demo-3.png' | relative_url }}" alt="Example of an error when trying to reassign a variable using the @let syntax" width="560" height="420" style="width: 100%; height: auto;">
</div>

Well, we get an error letting us know that we can’t declare this variable because it already exists. So that’s something to be on the look out for. 

## Variables Using @let are Scoped

Another thing to be aware of is that variable scope matters. Variables defined with @let can only be accessed by the current view and its descendants. They cannot be access by any parent. 

An easy way to see this is to add a variable within an @if block. Let’s add a test variable and then let’s try to access this variable outside of the scope of the @if block.

#### slider.component.html
```html
@if (advancedFeatures) {
    @let testVar = 'test';
    ...
}
{% raw %}{{ testVar }}{% endraw %}
```

Now let’s save and see what happens.

<div>
<img src="{{ '/assets/img/content/uploads/2024/07-19/demo-4.png' | relative_url }}" alt="Example of an error when trying to access a variable using the @let syntax outside of its scope" width="558" height="336" style="width: 100%; height: auto;">
</div>

Well, we get an error when we try to do this because that variable is scoped within the @if block condition and is not accessible outside.

## In Conclusion

The ability to add variables right within the template is pretty handy in some situations. Now, I’m sure that there are several of you out there who may not be impressed or may just dislike the idea of doing this altogether. And if you’re one of these folks, that’s fine just remember, it’s ok you don’t have to use it. Just know it’s there for you if you ever do need it.

I hope you found this tutorial helpful, and if you did, check out [my YouTube channel](https://www.youtube.com/@briantreese) for more tutorials about various topics and features within Angular.

## Additional Resources
* [The issue that started it all](https://github.com/angular/angular/issues/15280)
* [Angular’s local template variables documentation](https://angular.dev/guide/templates/let-template-variables)
* [Exploring Angular’s New @let Syntax: Enhancing Template Variable Declarations](https://netbasal.com/exploring-angulars-new-let-syntax-enhancing-template-variable-declarations-40487b022b44)
* [Introducing @let in Angular](https://blog.angular.dev/introducing-let-in-angular-686f9f383f0f)

## Want to See It in Action?
Check out the demo code and examples of these techniques in the in the Stackblitz example below. If you have any questions or thoughts, don’t hesitate to leave a comment.

<iframe src="https://stackblitz.com/edit/stackblitz-starters-xetajy?ctl=1&embed=1&file=src%2Fslider%2Fslider.component.html" style="height: 500px; width: 100%; margin-bottom: 1.5em; display: block;"></iframe>



