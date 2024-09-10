---
layout: post
title: "New Low-key Style Features in Angular 😮"
date: "2023-12-01"
video_id: "FX4JdusX-ic"
categories: 
  - "angular"
---

<p class="intro"><span class="dropcap">I</span>n Angular 17 we have a couple of new ways to include styles within our components. In this post we’ll take a close look at these new features, and we’ll learn how to use them. Alright, let’s get to it!</p>

<iframe width="560" height="315" src="https://www.youtube.com/embed/FX4JdusX-ic?si=8WgN1FxoOMGHXSmc" title="YouTube video player" frameborder="0" allow="accelerometer; autoplay; clipboard-write; encrypted-media; gyroscope; picture-in-picture; web-share" allowfullscreen></iframe>

You may have noticed this in the past and thought it was odd, or you may have never given it any thought, but when using the `styles` property in component metadata, we needed to provide an array of style strings.

```typescript
styles: [
    `.styles-1 {
        color: red;
    }`,
    `.styles-2 {
        color: blue;
    }`
]
```

I’m willing to bet that almost all of those of you who’ve used this property never added more than one string. I personally can’t think of a good reason to do this.

<div class="shirt-ad">
<a href="https://www.teepublic.com/user/dev-drip" title="Click to get yourself some fresh Angular merch!">
<img src="{{ '/assets/img/dev-drip-banner.png' | relative_url }}" alt="Swoop up some hip new Angular drip! - Dev Drip Merch Shop" width="960" height="275" style="width: 100%; height: auto;"></a>
</div>

## Adding Styles to a Component as an Array of Strings in Metadata With the `styles` Property

Let’s look at an example so that you’re clear on what I’m talking about. Here, in this component’s metadata, I’m going to add the styles property. It accepts an array of strings, so I’ll add that. Then, in this string, I’ll add some styles for the host. And, I’ll increase the font size for the h1.

```typescript
@Component({
    selector: 'app-root',
    template: `
        <h1>New Angular Component Style Features</h1>
    `,
    styles: [`
        :host {
            background-color: #151515;
            display: grid;
            height: 100%;
            place-items: center;
            text-align: center;
            color: #ff495d;
        }

        h1 {
            font-size: 300%;
        }
    `]
})
export class App {
}

```

See what I mean? There’s really no reason to add another string to this array as far as I can tell. I’m sure there’s some use cases out there but much of the time it’s probably not needed.

## New Feature: Adding Styles to a Component as a Single String in Metadata With the `styles` Property

Well now, as of Angular version 17, this property will accept both a single string or an array of strings. So, we can simply remove the square brackets in this case. We’re no longer required to provide an array.

```typescript
@Component({
    selector: 'app-root',
    template: `
        <h1>New Angular Component Style Features</h1>
    `,
    styles: `
        :host {
            background-color: #151515;
            display: grid;
            height: 100%;
            place-items: center;
            text-align: center;
            color: #ff495d;
        }

        h1 {
            font-size: 300%;
        }
    `
})
export class App {
}

```

So, not a huge deal but definitely more straight forward than the old way. Good to know it can be done this way now.

## Converting Styles Metadata to an Externally Referenced Stylesheet

Ok, along these lines, there’s a new feature for including an external stylesheet too. Up until Angular version 17, for including external stylesheets, we’d use the `styleUrls` property which required an array of stylesheet file path strings, but most of the time you probably only needed to include a single stylesheet. Let’s look at an example.

We’ll add a new stylesheet file, we’ll name it "app.component.css". Now let’s move our styles to this stylesheet. And let’s change the background color and font color to make this change more obvious.

### app.component.css
```css
:host {
  background-color: #4e368b;
  display: grid;
  height: 100%;
  place-items: center;
  text-align: center;
  color: white;
}

h1 {
  font-size: 300%;
}

```

## Adding Multiple Stylesheets to a Component as an Array of Strings in Metadata With the `styleUrls` Property

Back in the component metadata we used to need to add these with the `styleUrls` property. It requires an array of strings, so we add square brackets, and then a string with the path to our stylesheet.

```typescript
@Component({
    selector: 'app-root',
    template: `
        <h1>New Angular Component Style Features</h1>
    `,
    styleUrls: ['./app.component.css']
})
export class App {
}

```

Ok, so now our style sheet is properly included but, in this case and in most other cases too, we only need to include a single stylesheet.

## New Feature: Adding a Single Stylesheet to a Component as a Single String in Metadata With the New `styleUrl` Property

Well, we now have the `styleUrl` property. That’s `styleUrl` singular as opposed to the existing `styleUrls` plural property. This property only accepts a single string.

```typescript
@Component({
    selector: 'app-root',
    template: `
        <h1>New Angular Component Style Features</h1>
    `,
    styleUrl: './app.component.css'
})
export class App {
}

```

So again, nothing major, but just a little bit more straight forward for most use cases. Something new to be aware of, but everything still exists as it did previously. 

You can still provide an array of styles to the `styles` metadata property and the `styleUrls` property can still be used with an array of stylesheets so you won’t need to change anything if you don’t feel it’s necessary but you can if you like the new way better.

It’s completely up to you.

## Want to See It in Action?
Check out the demo code and examples of these techniques in the in the stackblitz example below. If you have any questions or thoughts, don’t hesitate to leave a comment.

<iframe src="https://stackblitz.com/edit/stackblitz-starters-ubxwjp?ctl=1&embed=1&file=src%2Fmain.ts" style="height: 500px; width: 100%; margin-bottom: 1.5em; display: block;">  
