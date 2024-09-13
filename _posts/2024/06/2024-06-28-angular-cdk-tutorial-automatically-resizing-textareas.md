---
layout: post
title: "Angular CDK: Auto-Resizing Textareas!"
date: "2024-06-28"
video_id: "18knOB6SQ-M"
categories: 
  - "angular"
---

<p class="intro"><span class="dropcap">B</span>y default, an <a href="https://developer.mozilla.org/en-US/docs/Web/HTML/Element/textarea">HTML textarea control</a> doesn’t expand or contract as content is added and removed. Sometimes this is ok, but often it would be better if we did have some control where we could allow the height to resize automatically, to better fit the content. Well, this is possible and, in fact, it’s really easy to do in Angular when using the <a href="https://material.angular.io/cdk/categories">CDK</a>. In this example I’ll show you just how easy it is. Alright, let’s get to it!</p>

<iframe width="1280" height="720" src="https://www.youtube.com/embed/18knOB6SQ-M" title="" frameborder="0" allow="accelerometer; autoplay; clipboard-write; encrypted-media; gyroscope; picture-in-picture; web-share" allowfullscreen></iframe>

## The Demo Application

For the example in this post, we’ll be working with [this demo application](https://stackblitz.com/edit/stackblitz-starters-fq1rmg?file=src%2Fslider%2Fdescription-form%2Fdescription-form.component.html), Petpix. It’s an app where people can share cool images of their pets.

Under each image, there’s a description field where the user can add content to describe the image. We want this textarea to resize automatically as we add or remove text.

<div>
<img src="{{ '/assets/img/content/uploads/2024/06-28/demo-1.gif' | relative_url }}" alt="Example of a standard textarea not automatically resizing when adding and removing content" width="822" height="976" style="width: 100%; height: auto;">
</div>

This is what we’re going to do in this example, and we’ll be using the [Angular CDK TextFieldModule](https://material.angular.io/cdk/text-field/overview) to do it quickly and easily.

<div class="shirt-ad">
<a href="https://www.teepublic.com/user/dev-drip" title="Click to get yourself some fresh Angular merch!">
<img src="{{ '/assets/img/dev-drip-banner.png' | relative_url }}" alt="Swoop up some hip new Angular drip! - Dev Drip Merch Shop" width="960" height="275" style="width: 100%; height: auto;"></a>
</div>

## Installing the Angular CDK

Ok, since we’re using the [Angular CDK](https://material.angular.io/cdk/categories), you ‘ll need to make sure that, before you do anything else, you install it using the following command in your terminal within the root directory for your Angular application.

```shell
npm i @angular/cdk
```

Once we have it installed, we will be able to use the [TextFieldModule](https://material.angular.io/cdk/text-field/overview) to configure our description textarea to automatically size itself to the content within it.

Ok, let’s look at some code.

## How to Auto-Resize textareas in Angular Using the cdkTextareaAutosize Directive

Within the [slider component](https://stackblitz.com/edit/stackblitz-starters-fq1rmg?file=src%2Fslider%2Fslider.component.html), at the bottom of the template, there’s a description form component. Let’s take a look at the template for [this component](https://stackblitz.com/edit/stackblitz-starters-fq1rmg?file=src%2Fslider%2Fdescription-form%2Fdescription-form.component.html) to see what we’re working with. 

Within the template, there's a standard textarea element.

#### desription-form.component.html
```html
<label for="description">Image Description:</label>
<section>
    <textarea
        id="description"
        placeholder="Provide additional context about this image of your pet">
    </textarea>
</section>
```

Now, this may vary some in different browsers, but here in Chrome, the default height for a textarea will show two rows of text. So, if we type in this textarea, then hit return to go to a new line, we can see that it fits two rows of text perfectly. Then if we hit return again and add another line, we get a scrollbar.

<div>
<img src="{{ '/assets/img/content/uploads/2024/06-28/demo-2.gif' | relative_url }}" alt="Example of a standard textarea not automatically resizing when adding and removing content" width="710" height="922" style="width: 100%; height: auto;">
</div>

And this is what we want to change. To do this, we'll add the [cdkTextareaAutosize](https://material.angular.io/cdk/text-field/api#CdkTextareaAutosize) directive. But first, we need to import this module in our description form component.

#### desription-form.component.ts
```typescript
...
import { TextFieldModule } from '@angular/cdk/text-field';

@Component({
    selector: 'app-description-form',
    ...
    imports: [ TextFieldModule ]
})
export class DescriptionFormComponent {
}
```

Ok, now we can switch back to the template and add the directive to the textarea.

#### desription-form.component.html
```html
<textarea ... cdkTextareaAutosize></textarea>
```

And that’s all we need, now let’s save and see how it works.

Now we can see that the textarea no longer defaults to a height of two rows, instead it accounts for only a single row. So the directive appears to be doing its job. But what’s a little odd is that there's a scrollbar even when no text has been added. It does automatically resize as content is added, but when the content is cleared out, it doesn't resize back down to the initial height.

<div>
<img src="{{ '/assets/img/content/uploads/2024/06-28/demo-3.gif' | relative_url }}" alt="Example of the cdkTextareaAutosize directive partially functioning but without the proper styles" width="712" height="932" style="width: 100%; height: auto;">
</div>

So, it looks like it's not working properly, but there’s a simple fix for these issues.

### Including Angular CDK Auto-size Styles for Proper textarea Height Calculation 

Now, I had to find this out the hard way, but in order for this directive to calculate the height properly, we need to include the [text-field-autosize styles](https://github.com/angular/components/blob/main/src/cdk/text-field/_index.scss) from the CDK. To include these, we can include them within our global stylesheet.

Now, I’m using SCSS so I’ll add a [@use directive](https://sass-lang.com/documentation/at-rules/use/) and then path to "@angular/cdk" to include these styles. Then I can use the [@include directive](https://sass-lang.com/documentation/at-rules/mixin/) to include the [text-field-autosize mixin]((https://github.com/angular/components/blob/main/src/cdk/text-field/_index.scss)), which is the piece that contains the styles that we need.

#### global_styles.scss
```scss
@use '@angular/cdk';
@include cdk.text-field-autosize;
```

Now, it’s important to note that if you’re not using SCSS like me, you can instead import the text-field-prebuilt.css file, and that would include the styles needed for the proper height calculation.

```scss
@import '@angular/cdk/text-field-prebuilt.css';
```

But, I’m going to stick with SCSS for this example.

Alright, now that the styles have been imported, let’s save and see if it’s working correctly now.

Ok, this looks promising now right? There’s no more scrollbar. Now when we add and remove content, it should now resize properly too.

<div>
<img src="{{ '/assets/img/content/uploads/2024/06-28/demo-4.gif' | relative_url }}" alt="Example of the cdkTextareaAutosize directive functioning correctly with proper styles included" width="598" height="908" style="width: 100%; height: auto;">
</div>

Nice, it all seems to be working correctly now.

So, if you use this directive, you’ll just need to be sure to add those styles or it’ll never work correctly.

## Add Min and Max row Counts to Control Min and Max textarea Heights

Something else handy that we can do with the [cdkTextareaAutosize](https://material.angular.io/cdk/text-field/api#CdkTextareaAutosize) directive is, we can control them minimum number of rows that we want it to be able to shrink to, as well as the maximum number of rows that we want it to be able to grow to.

There are two inputs that we can use for this, cdkAutosizeMinRows, and cdkAutoSizeMaxRows.

So, let’s add these to our textarea. Let’s go with a minimum of three rows, so it will never shrink below that, and let’s go with a max of six rows. So it will add a scrollbar when the content grows to seven or more rows.

#### desription-form.component.html
```html
<textarea
    ...
    cdkTextareaAutosize
    cdkAutosizeMinRows="3"
    cdkAutosizeMaxRows="6">
</textarea>
```

Ok, let’s save and see how it looks now.

<div>
<img src="{{ '/assets/img/content/uploads/2024/06-28/demo-5.gif' | relative_url }}" alt="Example of the cdkTextareaAutosize directive functioning with cdkAutosizeMinRows and cdkAutosizeMaxRows configured" width="708" height="932" style="width: 100%; height: auto;">
</div>

Nice, now it’s taller. It fits three rows of text before it resizes. Then it grows as we add four, five, and six rows. And when we go to seven and beyond, now we get a scrollbar. Then, when we clear it all out, it goes back down to three rows.

Pretty nice right?

## Conclusion

So there you go, now you have a quick and easy way to create a textarea that automatically resizes in Angular. And it doesn’t take much effort at all thanks to the [Angular CDK](https://material.angular.io/cdk/categories).

I hope you found this tutorial helpful, and if you did, check out [my YouTube channel](https://www.youtube.com/@briantreese) for more tutorials on the [Angular CDK](https://material.angular.io/cdk/categories) and Angular in general.

## Want to See It in Action?
Check out the demo code and examples of these techniques in the in the Stackblitz example below. If you have any questions or thoughts, don’t hesitate to leave a comment.

<iframe src="https://stackblitz.com/edit/stackblitz-starters-goqnhl?ctl=1&embed=1&file=src%2Fslider%2Fdescription-form%2Fdescription-form.component.html" style="height: 500px; width: 100%; margin-bottom: 1.5em; display: block;">
