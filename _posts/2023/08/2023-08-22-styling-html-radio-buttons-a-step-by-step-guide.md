---
layout: post
title: "How to Style HTML Radio Buttons: A Step-by-Step Guide"
date: "2023-08-22"
video_id: "PlldXyuTnUw"
tags: 
  - "CSS"
  - "HTML"
  - "Forms"
coverImage: "thumbnail-2.jpg"
---

<p class="intro"><span class="dropcap">D</span>efault HTML radio buttons look outdated and inconsistent across browsers, but styling them directly is impossible due to browser limitations. This tutorial demonstrates how to create custom-styled radio buttons using CSS, hiding the native input and creating accessible, visually appealing alternatives that work across all browsers and maintain full functionality.</p>

{% include youtube-embed.html %}

## Let's Begin by Hiding the Radio Buttons!

We need to start by acknowledging the limitations of cross-browser styling for radio buttons. While it's frustrating that we can't style them directly, we can use workarounds. In this example, the first step is to hide the actual radio button input. I know this sounds odd but we know that we can't style them, so we just need to take them out of the equation. However, this should be done in an accessible manner, ensuring that it remains functional for all users. This can be achieved by using the following set of styles that visually hide the content while retaining its usability:

```css
input[type="radio"] {
  border: 0 !important;
  clip: rect(1px, 1px, 1px, 1px);
  height: 1px !important;
  overflow: hidden;
  padding: 0 !important;
  position: absolute !important;
  width: 1px !important;
}
```

## Creating the Custom Radio Buttons

To create the custom appearance of the radio button, we'll leverage the `::before` pseudo-element on our label along with some simple CSS to create the look we're looking for.

For our example, the HTML looks like this:

```html
<form>
    <h1>Can We Style HTML Radio Buttons?</h1>
    <ul>
        <li>
            <input type="radio" value="yes" name="option" id="yes" />
            <label for="yes">Yes</label>
        </li>
        <li>
            <input type="radio" value="no" name="option" id="no" />
            <label for="no">No</label>
        </li>
        <li>
            <input type="radio" value="maybe" name="option" id="maybe" />
            <label for="maybe">Maybe</label>
        </li>
      </ul>
</form>
```

To start, we'll add the following styles to our label element:

```css
label {
  display: inline-flex;
  align-items: center;
}
```

This will ensure that once we add our radio button styles it will be properly vertically aligned with the label text.

Now, we'll add our mock radio buttons using the `::before` pseudo-element:

```css
label::before {
  content: '';
  display: block;
  height: 1.25em;
  width: 1.25em;
  border: solid 1px #ccc;
  border-radius: 50%;
  margin-right: 0.5em;
}
```

At this point we have something that is starting to resemble a radio button list but if we click on the radios, we will see that nothing is happening. Although the pseudo-element visually resembles a radio button, it lacks interactivity because we have not yet handled the checked state.

## Handling Interaction and States

We can handle the checked state with the `:checked` pseudo-class and adjacent sibling selector on our label:

```css
input[type="radio"]:checked + label {
  color: black;
}
```

For the inner dot we can leverage a radial gradient on our pseudo-element:

```css
input[type="radio"]:checked + label::before {
  background: radial-gradient(0.75em circle at center, currentColor 50%, transparent 55%);
  box-shadow: 0 0 1em 0 rgba(10, 150, 255, 0.75);
  border-color: currentColor;
}
```

There, now when we click on these they function much like native radio buttons. And we can enhance the interactions by adding some transition effects:

```css
label::before {
  ...
  transition: border ease-in 150ms, box-shadow ease-in 150ms;
}
```

### Let's not Forget About Focus

To improve accessibility, we will also need address the focused state of the mock radio buttons. This time we will need to utilize the `:focus` pseudo-class and the adjacent sibling selector with the label:

```css
input[type="radio"]:checked + label,
input[type="radio"]:focus + label {
  color: black;
}

input[type="radio"]:focus + label::before {
  box-shadow: 0 0 1em 0 rgba(10, 150, 255, 0.75);
  border-color: currentColor;
}
```

## Conclusion

By following this method, we can create stylish and accessible custom radio buttons that greatly enhance the user experience. These customized radio buttons not only look better than the standard ones but can also provide better feedback and interaction when implemented properly.

This was a pretty simple example that may not even really look much different than the native browser styles but the key is, with this set up we can pretty much do whatever we want. So, feel free to experiment with the styles and adapt them to your project's design.

### Want to See It in Action?

Check out the demo code and examples of this technique in the codepen example below. If you have any questions or thoughts, don't hesitate to leave a comment.

Remember that with a little creativity and some CSS, you can transform the appearance of HTML radio buttons to match your design while maintaining accessibility and usability!

<p class="codepen" data-height="600" data-slug-hash="bGOGeBJ" data-user="brianmtreese" style="height: 600px; box-sizing: border-box; display: flex; align-items: center; justify-content: center; border: 2px solid; margin: 1em 0; padding: 1em;">
  <span>See the Pen <a href="https://codepen.io/brianmtreese/pen/bGOGeBJ">
  Can We Style HTML Radio Buttons?</a> by Brian (<a href="https://codepen.io/brianmtreese">@brianmtreese</a>)
  on <a href="https://codepen.io">CodePen</a>.</span>
</p>
<script async src="https://cpwebassets.codepen.io/assets/embed/ei.js"></script>
