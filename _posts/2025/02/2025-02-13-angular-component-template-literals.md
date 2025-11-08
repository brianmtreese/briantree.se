---
layout: post
title: "Untagged Template Literals... The Upgrade You Didn’t Know You Needed!"
date: "2025-02-13"
video_id: "UEEymZPv6dg"
tags:
  - "Angular"
  - "Angular Components"
  - "Angular Styles"
  - "CSS"
  - "Class Binding"
  - "Date Pipe"
  - "HTML"
  - "JavaScript"
  - "RxJS"
  - "Template Literals"
---

<p class="intro"><span class="dropcap">H</span>ave you ever felt like some of the dynamic expressions in your Angular component templates are a tangled mess? What if I told you we now have a cleaner, more modern way to handle dynamic classes, styles, and even complex interpolations, without the headache?</p>

In this tutorial, I’ll show you how Angular 19.2-next.0 introduces untagged [template literals](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Template_literals) that make your templates cleaner, easier to maintain, and even unlock some tricks you couldn’t do before.

{% include youtube-embed.html %}

## Simplify Your Class Bindings

For this example, we'll be using a [basic message component](https://stackblitz.com/edit/stackblitz-starters-np3g1kjg?file=src%2Fmessage%2Fmessage.component.html).

This component can be in three different states: an “error” state, a “success” state, or a “warning” state:

<div>
<img src="{{ '/assets/img/content/uploads/2025/02-13/demo-1.jpg' | relative_url }}" alt="Example of a simple message component in Angular that uses traditional string concatenation for dynamic property binding before switching to newly introduced template literals" width="800" height="314" style="width: 100%; height: auto;">
</div>

In the template, we’re currently using [traditional string concatenation](https://developer.mozilla.org/en-US/docs/Learn_web_development/Core/Scripting/Strings#concatenation_using), with plus symbols, and a [ternary operator](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Operators/Conditional_operator), to bind the "message-error" or "message-success" class.

```html
<div [class]="'message-' + (isError() ? 'error' : 'success')">...</div>
```

That’s how we used to do it, but not anymore.

Now, we can replace the old-school concatenation with [template/string literals](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Template_literals).

Just wrap the expression in backticks and replace the plus signs and parentheses with the embedded expression syntax using the dollar sign and curly braces. That’s it!:

```html
<div [class]="`message-${isError() ? 'error' : 'success'}`">...</div>
```

This does the exact same thing, just in a slightly cleaner, more readable way.

This is pretty cool because it can really simplify expressions in templates.

## Dynamic Styles, Now Cleaner Than Ever!

Now, let’s apply this concept to some existing dynamic styles.

Here, we’re setting three different [custom properties](https://developer.mozilla.org/en-US/docs/Web/CSS/Using_CSS_custom_properties) using [traditional concatenation](https://developer.mozilla.org/en-US/docs/Learn_web_development/Core/Scripting/Strings#concatenation_using):

```html
<div
  [style]="
    '--error:' + errorColor + 
    '; --success:' + successColor + 
    '; --warning:' + warningColor + ';'"
>
  ...
</div>
```

But since we now have [template literals](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Template_literals), we can clean this up:

```html
<div
  [style]="`
    --error: ${errorColor}; 
    --success: ${successColor}; 
    --warning: ${warningColor};`"
>
  ...
</div>
```

With just one quick change, the expression becomes simpler and easier to maintain.

And this too is equivalent to what we had before, just in a slightly cleaner, more readable fashion.

## Easier Image Paths & File Names

Next up, we can improve dynamic image paths and file names too.

Here’s an SVG icon that updates based on the message state using attribute binding:

```html
<svg aria-hidden="true" viewBox="0 0 24 24">
  <use [attr.href]="'/assets/icons.svg#' + iconName()"></use>
</svg>
```

It does this by adding a dynamic SVG fragment name that matches the identifier from the SVG file itself:

```html
<svg xmlns="http://www.w3.org/2000/svg">
  <symbol id="success">...</symbol>
  <symbol id="error">...</symbol>
  <symbol id="warning">...</symbol>
</svg>
```

Right now, the fragment name is built using [string concatenation](https://developer.mozilla.org/en-US/docs/Learn_web_development/Core/Scripting/Strings#concatenation_using), but we can replace that with a [template literal](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Template_literals) instead:

```html
<svg aria-hidden="true" viewBox="0 0 24 24">
  <use [attr.href]="`/assets/icons.svg#${iconName()}`"></use>
</svg>
```

There, that’s better.

And after saving, everything should still work perfectly.

## Simplify Clunky Interpolations with Multiple Expressions

[Template literals](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Template_literals) also shine when combining multiple [interpolations](https://angular.dev/guide/templates/binding#render-dynamic-text-with-text-interpolation).

Take this message:

```html
<p>
  Message type: [{% raw %}{{ messageType() }}{% endraw %}] - {% raw %}{{
  message() }}{% endraw %}
</p>
```

It’s built with a mix of static text, a [string interpolated](https://angular.dev/guide/templates/binding#render-dynamic-text-with-text-interpolation) “messageType” [input](https://angular.dev/guide/components/inputs), more text, and then the [string interpolated](https://angular.dev/guide/templates/binding#render-dynamic-text-with-text-interpolation) “message” [input](https://angular.dev/guide/components/inputs) itself.

This isn’t horrible as it stands, but now we can turn this into one single [template literal](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Template_literals), keeping everything in a single, readable expression:

```html
<p>
  {% raw %}{{ `Message type: [${messageType()}] - ${message()}` }}{% endraw %}
</p>
```

So, that’s just another way this can be done.

Now, would I use this approach in this case?

Maybe not. But it’s nice to have the option!

## Unlocking New Possibilities with Pipes

Now here’s a case where [template literals](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Template_literals) actually unlock new possibilities.

Here we have some static text again followed by the date using a dynamic "date" property and the built-in [Angular date pipe](https://angular.dev/api/common/DatePipe) to format it appropriately:

```html
<time>today is: {% raw %}{{ today | date:'fullDate' }}{% endraw %}</time>
```

Now, we want to convert this entire expression to uppercase characters.

Well, Angular has a built-in pipe for this too, the [Uppercase pipe](https://angular.dev/api/common/UpperCasePipe).

Unfortunately, we have no way to apply this to the current expression as is, because it’s partially static text and partially a formatted date with the [date pipe](https://angular.dev/api/common/DatePipe).

But, by switching this all over to a single expression using a [template literal](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Template_literals) instead, we can actually add the [uppercase pipe](https://angular.dev/api/common/UpperCasePipe) now:

```html
<time
  >{% raw %}{{ `today is ${today | date:'fullDate'}` | uppercase }}{% endraw
  %}</time
>
```

This is pretty cool because before, you couldn’t do this in the template.

You’d have to format it programmatically.

Now, it’s just one line, all within the template.

## Conclusion – Cleaner, Simpler, Better Templates!

Just like that, our template expressions are cleaner with [template literals](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Template_literals)!

No more clunky [string concatenations](https://developer.mozilla.org/en-US/docs/Learn_web_development/Core/Scripting/Strings#concatenation_using), just simple, modern syntax that gets the job done.

So, what do you think?

Will this make your Angular templates cleaner?

If you found this helpful, don't forget to [subscribe](https://www.youtube.com/c/briantreese?sub_confirmation=1), and check out [my other Angular tutorials](https://www.youtube.com/@briantreese) for more tips and tricks!

{% include banner-ad.html %}

## Additional Resources

- [The demo app BEFORE any changes](https://stackblitz.com/edit/stackblitz-starters-np3g1kjg?file=src%2Fmessage%2Fmessage.component.html)
- [The demo app AFTER making changes](https://stackblitz.com/edit/stackblitz-starters-goyft68r?file=src%2Fmessage%2Fmessage.component.html)
- [My course: “Styling Angular Applications”](https://app.pluralsight.com/library/courses/angular-styling-applications/table-of-contents)
- [Enhancing Angular Templates with Untagged Template Literals](https://medium.com/netanelbasal/enhancing-angular-templates-with-untagged-template-literals-0baa5b4f8371)
- [Template literals (Template strings)](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Template_literals)
- [Concatenation using "+"](https://developer.mozilla.org/en-US/docs/Learn_web_development/Core/Scripting/Strings#concatenation_using)
- [The Angular Date Pipe](https://angular.dev/api/common/DatePipe)
- [The Angular Uppercase Pipe](https://angular.dev/api/common/UpperCasePipe)

## Want to See It in Action?

Check out the demo code showcasing these techniques in the StackBlitz project below. If you have any questions or thoughts, don’t hesitate to leave a comment.

<iframe src="https://stackblitz.com/edit/stackblitz-starters-goyft68r?ctl=1&embed=1&file=src%2Fmessage%2Fmessage.component.html" style="height: 500px; width: 100%; margin-bottom: 1.5em; display: block;"></iframe>
