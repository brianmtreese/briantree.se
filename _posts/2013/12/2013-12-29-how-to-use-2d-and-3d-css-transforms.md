---
layout: post
title: "How to Use 2D and 3D CSS Transforms"
date: "2013-12-29"
tags:
  - "Animation"
  - "CSS"
  - "CSS Transforms"
  - "HTML"
---

<p class="intro"><span class="dropcap">M</span>ost of the time when using HTML and CSS we are simply drawing flat rectangles, rounded rectangles, or circles within 2D space. CSS Transforms allow us to alter the shape, position, rotation, and scale of html elements within both 2D and 3D space. When combined with CSS transitions, transforms can really enhance the user experience although that topic will require its own post.</p>

## Effect on Content Flow

The first item to note when using CSS Transforms is that they have no effect on the flow of content around the transformed item but they do create stacking context similar to position: relative.

<style>
.example__transform {
    padding: 10px 0;
    position: relative;
} 

.example__transform p:last-child {
    margin-bottom: 0;
}

.example__transformItem {
    opacity: 0.85;
    float: right;
    height: 0;
    padding-top: 33%; 
    width: 33%; 
    margin: 3px 13px 10px 10px;
}

.example__transformItemOriginal {
    position: absolute; 
    margin: 0; 
    right: 13px; 
    top: 13px;
} 

.example__cube { 
    background-color: transparent; 
    position: relative; 
    padding-top: 0; 
    width: 200px; 
    height: 200px; 
    padding-top: 15px; 
    padding-left: 25px;
} 

.example__cube--content { 
    -webkit-transform-style: preserve-3d;
    transform-style: preserve-3d; 
    position: relative; 
    width: 152px;
} 

.example__cube--content div { 
    width: 152px; 
    height: 152px; 
    display: block; 
    position: absolute; 
} 

.example__cube--front { 
    -webkit-transform: rotateY(0deg) translateZ(76px); 
    transform: rotateY(0deg) translateZ(76px); 
    background-color: rgba(66, 66, 66, 0.65);
} 

.example__cube--back { 
    -webkit-transform: rotateX(180deg) translateZ(-76px);
    transform: rotateX(180deg) translateZ(-76px); 
    background-color: rgba(66, 66, 66, 0.65);
} 

.example__cube--right { 
    -webkit-transform: rotateY(90deg) translateZ(76px); 
    transform: rotateY(90deg) translateZ(76px); 
    background-color: rgba(255, 255, 255, 0.85);
} 

.example__cube--left { 
    -webkit-transform: rotateY(-90deg) translateZ(76px); 
    transform: rotateY(-90deg) translateZ(76px); 
    background-color: rgba(255, 255, 255, 0.85);
}

.example__cube--top { 
    -webkit-transform: rotateX(90deg) translateZ(76px); 
    transform: rotateX(90deg) translateZ(76px); 
    background-color: rgba(255, 0, 0, 0.85);
} 

.example__cube--bottom { 
    -webkit-transform: rotateX(-90deg) translateZ(76px); 
    transform: rotateX(-90deg) translateZ(76px); 
    background-color: rgba(255, 0, 0, 0.85);
}
</style>

### Before Transform:
The dark box is floated to the right and the content simply flows around it. Both the content and the floated box are on the same layer in the stacking order.

<div class="demoBox">
    <div class="example__transform">
        <div class="demoBox__item example__transformItem">&nbsp;</div>
        <p>
            Lorem ipsum dolor sit amet, consectetuer adipiscing elit. Aenean commodo ligula eget dolor. Aenean massa. Cum sociis natoque penatibus et magnis dis parturient montes, nascetur ridiculus mus. Donec quam felis, ultricies nec, pellentesque eu, pretium quis, sem. Nulla consequat massa quis enim. Donec pede justo, fringilla vel, aliquet nec, vulputate eget, arcu. In enim justo, rhoncus ut, imperdiet a, venenatis vitae, justo. Nullam dictum felis eu pede mollis pretium. Integer tincidunt. Lorem ipsum dolor sit amet, consectetuer adipiscing elit. Aenean commodo ligula eget dolor. Aenean massa. Cum sociis natoque penatibus et magnis dis parturient montes, nascetur ridiculus mus. Donec quam felis, ultricies nec, pellentesque eu, pretium quis, sem. Nulla consequat massa quis enim. Donec pede justo, fringilla vel, aliquet nec, vulputate eget, arcu. In enim justo, rhoncus ut, imperdiet a, venenatis vitae, justo. Nullam dictum felis eu pede mollis pretium. Integer tincidunt. Lorem ipsum dolor sit amet, consectetuer adipiscing elit. Aenean commodo ligula eget dolor. Aenean massa. Cum sociis natoque penatibus et magnis dis parturient montes, nascetur ridiculus mus. Donec quam felis, ultricies nec, pellentesque eu, pretium quis, sem. Nulla consequat massa quis enim.
        </p>
    </div>
</div>

### After Transform — transform: translate(-30%, 30%):

The only difference here is that I've added `transform: translate(-30%, 30%)`. The content flow remains the same but the box is now translated(moved) and placed on a layer above the content in the stacking order.

```css
.example__transformItem {
    -ms-transform: translate(-30%, 30%); /* For IE9 */
    -webkit-transform: translate(-30%, 30%); /* For Chrome & Safari */
    transform: translate(-30%, 30%); /* For Everything Else */
}
```

<div class="demoBox">
    <div class="example__transform">
        <div class="demoBox__item example__transformItem example__transformItemOriginal">&nbsp;</div>
        <div class="demoBox__item--alt03 example__transformItem" style="-ms-transform: translate(-30%,30%); -webkit-transform: translate(-30%,30%); transform: translate(-30%,30%);">&nbsp;</div>
        <p>
            Lorem ipsum dolor sit amet, consectetuer adipiscing elit. Aenean commodo ligula eget dolor. Aenean massa. Cum sociis natoque penatibus et magnis dis parturient montes, nascetur ridiculus mus. Donec quam felis, ultricies nec, pellentesque eu, pretium quis, sem. Nulla consequat massa quis enim. Donec pede justo, fringilla vel, aliquet nec, vulputate eget, arcu. In enim justo, rhoncus ut, imperdiet a, venenatis vitae, justo. Nullam dictum felis eu pede mollis pretium. Integer tincidunt. Lorem ipsum dolor sit amet, consectetuer adipiscing elit. Aenean commodo ligula eget dolor. Aenean massa. Cum sociis natoque penatibus et magnis dis parturient montes, nascetur ridiculus mus. Donec quam felis, ultricies nec, pellentesque eu, pretium quis, sem. Nulla consequat massa quis enim. Donec pede justo, fringilla vel, aliquet nec, vulputate eget, arcu. In enim justo, rhoncus ut, imperdiet a, venenatis vitae, justo. Nullam dictum felis eu pede mollis pretium. Integer tincidunt. Lorem ipsum dolor sit amet, consectetuer adipiscing elit. Aenean commodo ligula eget dolor. Aenean massa. Cum sociis natoque penatibus et magnis dis parturient montes, nascetur ridiculus mus. Donec quam felis, ultricies nec, pellentesque eu, pretium quis, sem. Nulla consequat massa quis enim.
        </p>
    </div>
</div>

## The transform Property

When using CSS Transforms you will be using the `transform` property. There are many different functions that can be passed to the `transform` property:

### translate

The `translate` function simply translates or moves the item along the X and Y axis like the example above. Translate can use any unit of measure (%, em, px).

#### translateX

Translate can be applied to only the X axis if needed

```css
.example__transformItem {
    -ms-transform: translateX(-30%); /* For IE9 */
    -webkit-transform: translateX(-30%); /* For Chrome & Safari */
    transform: translateX(-30%); /* For Everything Else */
}
```

<div class="demoBox">
    <div class="example__transform">
        <div class="demoBox__item example__transformItem example__transformItemOriginal">&nbsp;</div>
        <div class="demoBox__item--alt04 example__transformItem" style="-ms-transform: translateX(-30%); -webkit-transform: translateX(-30%); transform: translateX(-30%);">&nbsp;</div>
        <p>
            Lorem ipsum dolor sit amet, consectetuer adipiscing elit. Aenean commodo ligula eget dolor. Aenean massa. Cum sociis natoque penatibus et magnis dis parturient montes, nascetur ridiculus mus. Donec quam felis, ultricies nec, pellentesque eu, pretium quis, sem. Nulla consequat massa quis enim. Donec pede justo, fringilla vel, aliquet nec, vulputate eget, arcu. In enim justo, rhoncus ut, imperdiet a, venenatis vitae, justo. Nullam dictum felis eu pede mollis pretium. Integer tincidunt. Lorem ipsum dolor sit amet, consectetuer adipiscing elit. Aenean commodo ligula eget dolor. Aenean massa. Cum sociis natoque penatibus et magnis dis parturient montes, nascetur ridiculus mus. Donec quam felis, ultricies nec, pellentesque eu, pretium quis, sem. Nulla consequat massa quis enim. Donec pede justo, fringilla vel, aliquet nec, vulputate eget, arcu. In enim justo, rhoncus ut, imperdiet a, venenatis vitae, justo. Nullam dictum felis eu pede mollis pretium. Integer tincidunt. Lorem ipsum dolor sit amet, consectetuer adipiscing elit. Aenean commodo ligula eget dolor. Aenean massa. Cum sociis natoque penatibus et magnis dis parturient montes, nascetur ridiculus mus. Donec quam felis, ultricies nec, pellentesque eu, pretium quis, sem. Nulla consequat massa quis enim.
        </p>
    </div>
</div>

#### translateY

Translate can be applied to only the Y axis if needed

```css
.example__transformItem {
    -ms-transform: translateY(30%); /* For IE9 */
    -webkit-transform: translateY(30%); /* For Chrome & Safari */
    transform: translateY(30%); /* For Everything Else */
}
```

<div class="demoBox">
    <div class="example__transform">
        <div class="demoBox__item example__transformItem example__transformItemOriginal">&nbsp;</div>
        <div class="demoBox__item--alt05 example__transformItem" style="-ms-transform: translateY(30%); -webkit-transform: translateY(30%); transform: translateY(30%);">&nbsp;</div>
        <p>
            Lorem ipsum dolor sit amet, consectetuer adipiscing elit. Aenean commodo ligula eget dolor. Aenean massa. Cum sociis natoque penatibus et magnis dis parturient montes, nascetur ridiculus mus. Donec quam felis, ultricies nec, pellentesque eu, pretium quis, sem. Nulla consequat massa quis enim. Donec pede justo, fringilla vel, aliquet nec, vulputate eget, arcu. In enim justo, rhoncus ut, imperdiet a, venenatis vitae, justo. Nullam dictum felis eu pede mollis pretium. Integer tincidunt. Lorem ipsum dolor sit amet, consectetuer adipiscing elit. Aenean commodo ligula eget dolor. Aenean massa. Cum sociis natoque penatibus et magnis dis parturient montes, nascetur ridiculus mus. Donec quam felis, ultricies nec, pellentesque eu, pretium quis, sem. Nulla consequat massa quis enim. Donec pede justo, fringilla vel, aliquet nec, vulputate eget, arcu. In enim justo, rhoncus ut, imperdiet a, venenatis vitae, justo. Nullam dictum felis eu pede mollis pretium. Integer tincidunt. Lorem ipsum dolor sit amet, consectetuer adipiscing elit. Aenean commodo ligula eget dolor. Aenean massa. Cum sociis natoque penatibus et magnis dis parturient montes, nascetur ridiculus mus. Donec quam felis, ultricies nec, pellentesque eu, pretium quis, sem. Nulla consequat massa quis enim.
        </p>
    </div>
</div>

#### scale

The `scale` function simply re-sizes the item larger or smaller. Scale uses a unit-less decimal that represents a percentage of scale. In the examples below 1.2 = 120% of the original size.

```css
.example__transformItem {
    -ms-transform: scale(1.2); /* For IE9 */
    -webkit-transform: scale(1.2); /* For Chrome & Safari */
    transform: scale(1.2); /* For Everything Else */
}
```

<div class="demoBox">
    <div class="example__transform">
        <div class="demoBox__item example__transformItem example__transformItemOriginal">&nbsp;</div>
        <div class="demoBox__item--alt06 example__transformItem" style="-ms-transform: scale(1.2); -webkit-transform: scale(1.2); transform: scale(1.2);">&nbsp;</div>
        <p>
            Lorem ipsum dolor sit amet, consectetuer adipiscing elit. Aenean commodo ligula eget dolor. Aenean massa. Cum sociis natoque penatibus et magnis dis parturient montes, nascetur ridiculus mus. Donec quam felis, ultricies nec, pellentesque eu, pretium quis, sem. Nulla consequat massa quis enim. Donec pede justo, fringilla vel, aliquet nec, vulputate eget, arcu. In enim justo, rhoncus ut, imperdiet a, venenatis vitae, justo. Nullam dictum felis eu pede mollis pretium. Integer tincidunt. Lorem ipsum dolor sit amet, consectetuer adipiscing elit. Aenean commodo ligula eget dolor. Aenean massa. Cum sociis natoque penatibus et magnis dis parturient montes, nascetur ridiculus mus. Donec quam felis, ultricies nec, pellentesque eu, pretium quis, sem. Nulla consequat massa quis enim. Donec pede justo, fringilla vel, aliquet nec, vulputate eget, arcu. In enim justo, rhoncus ut, imperdiet a, venenatis vitae, justo. Nullam dictum felis eu pede mollis pretium. Integer tincidunt. Lorem ipsum dolor sit amet, consectetuer adipiscing elit. Aenean commodo ligula eget dolor. Aenean massa. Cum sociis natoque penatibus et magnis dis parturient montes, nascetur ridiculus mus. Donec quam felis, ultricies nec, pellentesque eu, pretium quis, sem. Nulla consequat massa quis enim.
        </p>
    </div>
</div>

#### scaleX

Scale can be applied to only the X axis if needed

```css
.example__transformItem {
    -ms-transform: scaleX(1.2); /* For IE9 */
    -webkit-transform: scaleX(1.2); /* For Chrome & Safari */
    transform: scaleX(1.2); /* For Everything Else */
}
```

<div class="demoBox">
    <div class="example__transform">
        <div class="demoBox__item example__transformItem example__transformItemOriginal">&nbsp;</div>
        <div class="demoBox__item--alt02 example__transformItem" style="-ms-transform: scaleX(1.2); -webkit-transform: scaleX(1.2); transform: scaleX(1.2);">&nbsp;</div>
        <p>
            Lorem ipsum dolor sit amet, consectetuer adipiscing elit. Aenean commodo ligula eget dolor. Aenean massa. Cum sociis natoque penatibus et magnis dis parturient montes, nascetur ridiculus mus. Donec quam felis, ultricies nec, pellentesque eu, pretium quis, sem. Nulla consequat massa quis enim. Donec pede justo, fringilla vel, aliquet nec, vulputate eget, arcu. In enim justo, rhoncus ut, imperdiet a, venenatis vitae, justo. Nullam dictum felis eu pede mollis pretium. Integer tincidunt. Lorem ipsum dolor sit amet, consectetuer adipiscing elit. Aenean commodo ligula eget dolor. Aenean massa. Cum sociis natoque penatibus et magnis dis parturient montes, nascetur ridiculus mus. Donec quam felis, ultricies nec, pellentesque eu, pretium quis, sem. Nulla consequat massa quis enim. Donec pede justo, fringilla vel, aliquet nec, vulputate eget, arcu. In enim justo, rhoncus ut, imperdiet a, venenatis vitae, justo. Nullam dictum felis eu pede mollis pretium. Integer tincidunt. Lorem ipsum dolor sit amet, consectetuer adipiscing elit. Aenean commodo ligula eget dolor. Aenean massa. Cum sociis natoque penatibus et magnis dis parturient montes, nascetur ridiculus mus. Donec quam felis, ultricies nec, pellentesque eu, pretium quis, sem. Nulla consequat massa quis enim.
        </p>
    </div>
</div>

#### scaleY

Scale can be applied to only the Y axis if needed

```css
.example__transformItem {
    -ms-transform: scaleY(1.2); /* For IE9 */
    -webkit-transform: scaleY(1.2); /* For Chrome & Safari */
    transform: scaleY(1.2); /* For Everything Else */
}
```

<div class="demoBox">
    <div class="example__transform">
        <div class="demoBox__item example__transformItem example__transformItemOriginal">&nbsp;</div>
        <div class="demoBox__item--alt03 example__transformItem" style="-ms-transform: scaleY(1.2); -webkit-transform: scaleY(1.2); transform: scaleY(1.2);">&nbsp;</div>
        <p>
            Lorem ipsum dolor sit amet, consectetuer adipiscing elit. Aenean commodo ligula eget dolor. Aenean massa. Cum sociis natoque penatibus et magnis dis parturient montes, nascetur ridiculus mus. Donec quam felis, ultricies nec, pellentesque eu, pretium quis, sem. Nulla consequat massa quis enim. Donec pede justo, fringilla vel, aliquet nec, vulputate eget, arcu. In enim justo, rhoncus ut, imperdiet a, venenatis vitae, justo. Nullam dictum felis eu pede mollis pretium. Integer tincidunt. Lorem ipsum dolor sit amet, consectetuer adipiscing elit. Aenean commodo ligula eget dolor. Aenean massa. Cum sociis natoque penatibus et magnis dis parturient montes, nascetur ridiculus mus. Donec quam felis, ultricies nec, pellentesque eu, pretium quis, sem. Nulla consequat massa quis enim. Donec pede justo, fringilla vel, aliquet nec, vulputate eget, arcu. In enim justo, rhoncus ut, imperdiet a, venenatis vitae, justo. Nullam dictum felis eu pede mollis pretium. Integer tincidunt. Lorem ipsum dolor sit amet, consectetuer adipiscing elit. Aenean commodo ligula eget dolor. Aenean massa. Cum sociis natoque penatibus et magnis dis parturient montes, nascetur ridiculus mus. Donec quam felis, ultricies nec, pellentesque eu, pretium quis, sem. Nulla consequat massa quis enim.
        </p>
    </div>
</div>

#### rotate

The `rotate` function simply rotates the item at an angle by the degrees specified. Rotate uses either degrees(deg) or radians(rad). To rotate items counter-clockwise you can simply use a negative value.

```css
.example__transformItem {
    -ms-transform: rotate(45deg); /* For IE9 */
    -webkit-transform: rotate(45deg); /* For Chrome & Safari */
    transform: rotate(45deg); /* For Everything Else */
}
```

<div class="demoBox">
    <div class="example__transform">
        <div class="demoBox__item example__transformItem example__transformItemOriginal">&nbsp;</div>
        <div class="demoBox__item--alt04 example__transformItem" style="-ms-transform: rotate(45deg); -webkit-transform: rotate(45deg); transform: rotate(45deg);">&nbsp;</div>
        <p>
            Lorem ipsum dolor sit amet, consectetuer adipiscing elit. Aenean commodo ligula eget dolor. Aenean massa. Cum sociis natoque penatibus et magnis dis parturient montes, nascetur ridiculus mus. Donec quam felis, ultricies nec, pellentesque eu, pretium quis, sem. Nulla consequat massa quis enim. Donec pede justo, fringilla vel, aliquet nec, vulputate eget, arcu. In enim justo, rhoncus ut, imperdiet a, venenatis vitae, justo. Nullam dictum felis eu pede mollis pretium. Integer tincidunt. Lorem ipsum dolor sit amet, consectetuer adipiscing elit. Aenean commodo ligula eget dolor. Aenean massa. Cum sociis natoque penatibus et magnis dis parturient montes, nascetur ridiculus mus. Donec quam felis, ultricies nec, pellentesque eu, pretium quis, sem. Nulla consequat massa quis enim. Donec pede justo, fringilla vel, aliquet nec, vulputate eget, arcu. In enim justo, rhoncus ut, imperdiet a, venenatis vitae, justo. Nullam dictum felis eu pede mollis pretium. Integer tincidunt. Lorem ipsum dolor sit amet, consectetuer adipiscing elit. Aenean commodo ligula eget dolor. Aenean massa. Cum sociis natoque penatibus et magnis dis parturient montes, nascetur ridiculus mus. Donec quam felis, ultricies nec, pellentesque eu, pretium quis, sem. Nulla consequat massa quis enim.
        </p>
    </div>
</div>

#### skew

The `skew` function turns the item in at an angle by the degrees specified. Skew uses degrees(deg).

```css
.example__transformItem {
    -ms-transform: skew(10deg, 10deg); /* For IE9 */
    -webkit-transform: skew(10deg, 10deg); /* For Chrome & Safari */
    transform: skew(10deg, 10deg); /* For Everything Else */
}
```

<div class="demoBox">
    <div class="example__transform">
        <div class="demoBox__item example__transformItem example__transformItemOriginal">&nbsp;</div>
        <div class="demoBox__item--alt05 example__transformItem" style="-ms-transform: skew(10deg, 10deg); -webkit-transform: skew(10deg, 10deg); transform: skew(10deg, 10deg);">&nbsp;</div>
        <p>
            Lorem ipsum dolor sit amet, consectetuer adipiscing elit. Aenean commodo ligula eget dolor. Aenean massa. Cum sociis natoque penatibus et magnis dis parturient montes, nascetur ridiculus mus. Donec quam felis, ultricies nec, pellentesque eu, pretium quis, sem. Nulla consequat massa quis enim. Donec pede justo, fringilla vel, aliquet nec, vulputate eget, arcu. In enim justo, rhoncus ut, imperdiet a, venenatis vitae, justo. Nullam dictum felis eu pede mollis pretium. Integer tincidunt. Lorem ipsum dolor sit amet, consectetuer adipiscing elit. Aenean commodo ligula eget dolor. Aenean massa. Cum sociis natoque penatibus et magnis dis parturient montes, nascetur ridiculus mus. Donec quam felis, ultricies nec, pellentesque eu, pretium quis, sem. Nulla consequat massa quis enim. Donec pede justo, fringilla vel, aliquet nec, vulputate eget, arcu. In enim justo, rhoncus ut, imperdiet a, venenatis vitae, justo. Nullam dictum felis eu pede mollis pretium. Integer tincidunt. Lorem ipsum dolor sit amet, consectetuer adipiscing elit. Aenean commodo ligula eget dolor. Aenean massa. Cum sociis natoque penatibus et magnis dis parturient montes, nascetur ridiculus mus. Donec quam felis, ultricies nec, pellentesque eu, pretium quis, sem. Nulla consequat massa quis enim.
        </p>
    </div>
</div>

#### skewX

Skew can be applied to only the X axis if needed

```css
.example__transformItem {
    -ms-transform: skewX(10deg); /* For IE9 */
    -webkit-transform: skewX(10deg); /* For Chrome & Safari */
    transform: skewX(10deg); /* For Everything Else */
}
```

<div class="demoBox">
    <div class="example__transform">
        <div class="demoBox__item example__transformItem example__transformItemOriginal">&nbsp;</div>
        <div class="demoBox__item--alt06 example__transformItem" style="-ms-transform: skewX(10deg); -webkit-transform: skewX(10deg); transform: skewX(10deg);">&nbsp;</div>
        <p>
            Lorem ipsum dolor sit amet, consectetuer adipiscing elit. Aenean commodo ligula eget dolor. Aenean massa. Cum sociis natoque penatibus et magnis dis parturient montes, nascetur ridiculus mus. Donec quam felis, ultricies nec, pellentesque eu, pretium quis, sem. Nulla consequat massa quis enim. Donec pede justo, fringilla vel, aliquet nec, vulputate eget, arcu. In enim justo, rhoncus ut, imperdiet a, venenatis vitae, justo. Nullam dictum felis eu pede mollis pretium. Integer tincidunt. Lorem ipsum dolor sit amet, consectetuer adipiscing elit. Aenean commodo ligula eget dolor. Aenean massa. Cum sociis natoque penatibus et magnis dis parturient montes, nascetur ridiculus mus. Donec quam felis, ultricies nec, pellentesque eu, pretium quis, sem. Nulla consequat massa quis enim. Donec pede justo, fringilla vel, aliquet nec, vulputate eget, arcu. In enim justo, rhoncus ut, imperdiet a, venenatis vitae, justo. Nullam dictum felis eu pede mollis pretium. Integer tincidunt. Lorem ipsum dolor sit amet, consectetuer adipiscing elit. Aenean commodo ligula eget dolor. Aenean massa. Cum sociis natoque penatibus et magnis dis parturient montes, nascetur ridiculus mus. Donec quam felis, ultricies nec, pellentesque eu, pretium quis, sem. Nulla consequat massa quis enim.
        </p>
    </div>
</div>

#### skewY

Skew can be applied to only the Y axis if needed

```css
.example__transformItem {
    -ms-transform: skewY(10deg); /* For IE9 */
    -webkit-transform: skewY(10deg); /* For Chrome & Safari */
    transform: skewY(10deg); /* For Everything Else */
}
```

<div class="demoBox">
    <div class="example__transform">
        <div class="demoBox__item example__transformItem example__transformItemOriginal">&nbsp;</div>
        <div class="demoBox__item--alt02 example__transformItem" style="-ms-transform: skewY(10deg); -webkit-transform: skewY(10deg); transform: skewY(10deg);">&nbsp;</div>
        <p> 
            Lorem ipsum dolor sit amet, consectetuer adipiscing elit. Aenean commodo ligula eget dolor. Aenean massa. Cum sociis natoque penatibus et magnis dis parturient montes, nascetur ridiculus mus. Donec quam felis, ultricies nec, pellentesque eu, pretium quis, sem. Nulla consequat massa quis enim. Donec pede justo, fringilla vel, aliquet nec, vulputate eget, arcu. In enim justo, rhoncus ut, imperdiet a, venenatis vitae, justo. Nullam dictum felis eu pede mollis pretium. Integer tincidunt. Lorem ipsum dolor sit amet, consectetuer adipiscing elit. Aenean commodo ligula eget dolor. Aenean massa. Cum sociis natoque penatibus et magnis dis parturient montes, nascetur ridiculus mus. Donec quam felis, ultricies nec, pellentesque eu, pretium quis, sem. Nulla consequat massa quis enim. Donec pede justo, fringilla vel, aliquet nec, vulputate eget, arcu. In enim justo, rhoncus ut, imperdiet a, venenatis vitae, justo. Nullam dictum felis eu pede mollis pretium. Integer tincidunt. Lorem ipsum dolor sit amet, consectetuer adipiscing elit. Aenean commodo ligula eget dolor. Aenean massa. Cum sociis natoque penatibus et magnis dis parturient montes, nascetur ridiculus mus. Donec quam felis, ultricies nec, pellentesque eu, pretium quis, sem. Nulla consequat massa quis enim.
        </p>
    </div>
</div>

## The transform-origin Property

When using the `transform` property it will be applied based on the center(50% 50% 0) of the item. To change this you can explicitly specify the `transform-origin`. This property works on the X and Y axis as well as the Z axis for 3D transforms. In the example below you can see the transformed item with the `transform-origin` changed to `10% 30%`:

```css
.example__transformItem {
    /* For IE9 */
    -ms-transform: rotate(45deg);
    -ms-transform-origin: 10% 30%;
 
    /* For Chrome & Safari */
    -webkit-transform: rotate(45deg); 
    -webkit-transform-origin: 10% 30%;

    /* For Everything Else */
    transform: rotate(45deg);
    transform-origin: 10% 30%;
}
```

<div class="demoBox">
    <div class="example__transform">
        <div class="demoBox__item example__transformItem example__transformItemOriginal">&nbsp;</div>
        <div class="demoBox__item--alt03 example__transformItem" style="-ms-transform: rotate(15deg); -ms-transform-origin: 10% 30%; -webkit-transform: rotate(15deg); -webkit-transform-origin: 10% 30%; transform: rotate(15deg); transform-origin: 10% 30%;">&nbsp;</div>
        <p>
            Lorem ipsum dolor sit amet, consectetuer adipiscing elit. Aenean commodo ligula eget dolor. Aenean massa. Cum sociis natoque penatibus et magnis dis parturient montes, nascetur ridiculus mus. Donec quam felis, ultricies nec, pellentesque eu, pretium quis, sem. Nulla consequat massa quis enim. Donec pede justo, fringilla vel, aliquet nec, vulputate eget, arcu. In enim justo, rhoncus ut, imperdiet a, venenatis vitae, justo. Nullam dictum felis eu pede mollis pretium. Integer tincidunt. Lorem ipsum dolor sit amet, consectetuer adipiscing elit. Aenean commodo ligula eget dolor. Aenean massa. Cum sociis natoque penatibus et magnis dis parturient montes, nascetur ridiculus mus. Donec quam felis, ultricies nec, pellentesque eu, pretium quis, sem. Nulla consequat massa quis enim. Donec pede justo, fringilla vel, aliquet nec, vulputate eget, arcu. In enim justo, rhoncus ut, imperdiet a, venenatis vitae, justo. Nullam dictum felis eu pede mollis pretium. Integer tincidunt. Lorem ipsum dolor sit amet, consectetuer adipiscing elit. Aenean commodo ligula eget dolor. Aenean massa. Cum sociis natoque penatibus et magnis dis parturient montes, nascetur ridiculus mus. Donec quam felis, ultricies nec, pellentesque eu, pretium quis, sem. Nulla consequat massa quis enim.
        </p>
    </div>
</div>

## 3D Transforms

Now for the really cool stuff, CSS 3D transforms. While CSS 2D transforms are nice and very useful, 3D transforms really allow us to think about our user experiences in a whole new way.

### 3D Functions

Just as with 2D transforms, 3D transforms use the `transform` property with their own set of functions.

#### translate3d

Translate can be applied for 3D objects. When using `translate3d` the values are passed in the following order (X, Y, Z) where the Z axis is the third dimension.

```css
.example__transformItem {
    -webkit-transform: translate3d(-30%, 30%, 30px); /* For Chrome & Safari */
    transform: translate3d(-30%, 30%, 30px); /* For Everything Else */
}
```

<div class="demoBox">
    <div class="example__transform">
        <div class="demoBox__item example__transformItem example__transformItemOriginal">&nbsp;</div>
        <div class="demoBox__item--alt04 example__transformItem" style="-webkit-transform: translate3d(-30%, 30%, 30px); transform: translate3d(-30%, 30%, 30px);">&nbsp;</div>
        <p>
            Lorem ipsum dolor sit amet, consectetuer adipiscing elit. Aenean commodo ligula eget dolor. Aenean massa. Cum sociis natoque penatibus et magnis dis parturient montes, nascetur ridiculus mus. Donec quam felis, ultricies nec, pellentesque eu, pretium quis, sem. Nulla consequat massa quis enim. Donec pede justo, fringilla vel, aliquet nec, vulputate eget, arcu. In enim justo, rhoncus ut, imperdiet a, venenatis vitae, justo. Nullam dictum felis eu pede mollis pretium. Integer tincidunt. Lorem ipsum dolor sit amet, consectetuer adipiscing elit. Aenean commodo ligula eget dolor. Aenean massa. Cum sociis natoque penatibus et magnis dis parturient montes, nascetur ridiculus mus. Donec quam felis, ultricies nec, pellentesque eu, pretium quis, sem. Nulla consequat massa quis enim. Donec pede justo, fringilla vel, aliquet nec, vulputate eget, arcu. In enim justo, rhoncus ut, imperdiet a, venenatis vitae, justo. Nullam dictum felis eu pede mollis pretium. Integer tincidunt. Lorem ipsum dolor sit amet, consectetuer adipiscing elit. Aenean commodo ligula eget dolor. Aenean massa. Cum sociis natoque penatibus et magnis dis parturient montes, nascetur ridiculus mus. Donec quam felis, ultricies nec, pellentesque eu, pretium quis, sem. Nulla consequat massa quis enim.
        </p>
    </div>
</div>

#### translateZ

Translate can be applied to only the Z axis if needed using `transform: translateZ(value);`

#### scale3d

Scale can be applied for 3D objects. When using `scale3d` the values are passed in the following order (X, Y, Z) where the Z axis is the third dimension.

```css
.example__transformItem {
    -webkit-transform: scale3d(1.2, 1.2, 1.2); /* For Chrome & Safari */
    transform: scale3d(1.2, 1.2, 1.2); /* For Everything Else */
}
```

<div class="demoBox">
    <div class="example__transform">
        <div class="demoBox__item example__transformItem example__transformItemOriginal">&nbsp;</div>
        <div class="demoBox__item--alt05 example__transformItem" style="-webkit-transform: scale3d(1.2, 1.2, 1.2); transform: scale3d(1.2, 1.2, 1.2);">&nbsp;</div>
        <p>
            Lorem ipsum dolor sit amet, consectetuer adipiscing elit. Aenean commodo ligula eget dolor. Aenean massa. Cum sociis natoque penatibus et magnis dis parturient montes, nascetur ridiculus mus. Donec quam felis, ultricies nec, pellentesque eu, pretium quis, sem. Nulla consequat massa quis enim. Donec pede justo, fringilla vel, aliquet nec, vulputate eget, arcu. In enim justo, rhoncus ut, imperdiet a, venenatis vitae, justo. Nullam dictum felis eu pede mollis pretium. Integer tincidunt. Lorem ipsum dolor sit amet, consectetuer adipiscing elit. Aenean commodo ligula eget dolor. Aenean massa. Cum sociis natoque penatibus et magnis dis parturient montes, nascetur ridiculus mus. Donec quam felis, ultricies nec, pellentesque eu, pretium quis, sem. Nulla consequat massa quis enim. Donec pede justo, fringilla vel, aliquet nec, vulputate eget, arcu. In enim justo, rhoncus ut, imperdiet a, venenatis vitae, justo. Nullam dictum felis eu pede mollis pretium. Integer tincidunt. Lorem ipsum dolor sit amet, consectetuer adipiscing elit. Aenean commodo ligula eget dolor. Aenean massa. Cum sociis natoque penatibus et magnis dis parturient montes, nascetur ridiculus mus. Donec quam felis, ultricies nec, pellentesque eu, pretium quis, sem. Nulla consequat massa quis enim.
        </p>
    </div>
</div>

#### scaleZ

Scale can be applied to only the Z axis if needed using `transform: scaleZ(value);`

#### rotate3d

Rotate can be applied for 3D objects. When using `rotate3d` the values are passed in the following order (X, Y, Z, angle) where the Z axis is the third dimension.

```css
.example__transformItem {
    -webkit-transform: rotate3d(1, 1, 0,5, 45deg); /* For Chrome & Safari */
    transform: rotate3d(1, 1, 0.5, 45deg); /* For Everything Else */
}
```

<div class="demoBox">
    <div class="example__transform">
        <div class="demoBox__item example__transformItem example__transformItemOriginal">&nbsp;</div>
        <div class="demoBox__item--alt06 example__transformItem" style="-webkit-transform: rotate3d(1, 1, 0.5, 45deg); transform: rotate3d(1, 1, 0.5, 45deg);">&nbsp;</div>
        <p>
            Lorem ipsum dolor sit amet, consectetuer adipiscing elit. Aenean commodo ligula eget dolor. Aenean massa. Cum sociis natoque penatibus et magnis dis parturient montes, nascetur ridiculus mus. Donec quam felis, ultricies nec, pellentesque eu, pretium quis, sem. Nulla consequat massa quis enim. Donec pede justo, fringilla vel, aliquet nec, vulputate eget, arcu. In enim justo, rhoncus ut, imperdiet a, venenatis vitae, justo. Nullam dictum felis eu pede mollis pretium. Integer tincidunt. Lorem ipsum dolor sit amet, consectetuer adipiscing elit. Aenean commodo ligula eget dolor. Aenean massa. Cum sociis natoque penatibus et magnis dis parturient montes, nascetur ridiculus mus. Donec quam felis, ultricies nec, pellentesque eu, pretium quis, sem. Nulla consequat massa quis enim. Donec pede justo, fringilla vel, aliquet nec, vulputate eget, arcu. In enim justo, rhoncus ut, imperdiet a, venenatis vitae, justo. Nullam dictum felis eu pede mollis pretium. Integer tincidunt. Lorem ipsum dolor sit amet, consectetuer adipiscing elit. Aenean commodo ligula eget dolor. Aenean massa. Cum sociis natoque penatibus et magnis dis parturient montes, nascetur ridiculus mus. Donec quam felis, ultricies nec, pellentesque eu, pretium quis, sem. Nulla consequat massa quis enim.
        </p>
    </div>
</div>

#### rotateZ

Rotate can be applied to only the Z axis if needed using `transform: rotateZ(value);`

* * *

### The perspective Property

The `perspective` is used to create depth by making objects that are closer to the viewer appear larger and objects that are further away appear smaller. Items that have a value greater than zero will be larger and items that have a value less than zero will be smaller. The `perspective` property only applies to child items and will only apply to items that are using the `transform` property.

```css
.example__cube {
    /* For Chrome & Safari */
    -webkit-perspective: 800px;
    -webkit-perspective-origin: -150px -100px;

    /* For Everything Else */
    perspective: 800px;
    perspective-origin: -150px -100px;
}
```

<div class="demoBox">
    <div class="example__transform">
        <div class="example__transformItem example__cube" style="-webkit-perspective: 800px; -webkit-perspective-origin: -150px -100px; perspective: 800px; perspective-origin: -150px -100px;">
            <div class="example__cube--content" style="perspective: 800px; perspective-origin: -150px -100px;">
                <div class="example__cube--back">&nbsp;</div>
                <div class="example__cube--right">&nbsp;</div>
                <div class="example__cube--top">&nbsp;</div>
                <div class="example__cube--bottom">&nbsp;</div>
                <div class="example__cube--left">&nbsp;</div>
                <div class="example__cube--front">&nbsp;</div>
            </div>
        </div>
        <p>
            Lorem ipsum dolor sit amet, consectetuer adipiscing elit. Aenean commodo ligula eget dolor. Aenean massa. Cum sociis natoque penatibus et magnis dis parturient montes, nascetur ridiculus mus. Donec quam felis, ultricies nec, pellentesque eu, pretium quis, sem. Nulla consequat massa quis enim. Donec pede justo, fringilla vel, aliquet nec, vulputate eget, arcu. In enim justo, rhoncus ut, imperdiet a, venenatis vitae, justo. Nullam dictum felis eu pede mollis pretium. Integer tincidunt.
        </p>
    </div>
</div>

### The perspective-origin Property

`perspective-origin` simply sets the perspective angle that the viewer is looking from. When using the `perspective` property it will be applied based on the center(50% 50%) of the item. To change this you can explicitly specify the `perspective-origin` for the X and Y axes. In the example above I used `perspective-origin: -150px -100px;` to clearly illustrate the 3D shape of the object. The example below demonstrates how you can change these values to achieve a new viewing perspective.

```css
.example__cube {
    /* For Chrome & Safari */
    -webkit-perspective: 1500px;
    -webkit-perspective-origin: 400px 500px;

    /* For Everything Else */
    perspective: 1500px;
    perspective-origin: 400px 500px;
}
```

<div class="demoBox">
    <div class="example__transform">
        <div class="example__transformItem example__cube" style="-webkit-perspective: 1500px; -webkit-perspective-origin: 400px 500px; perspective: 1500px; perspective-origin: 400px 500px; height: 170px; padding-top: 30px; padding-left: 35px;">
            <div class="example__cube--content" style="perspective: 1500px; perspective-origin: 400px 500px;">
                <div class="example__cube--back">&nbsp;</div>
                <div class="example__cube--top">&nbsp;</div>
                <div class="example__cube--right">&nbsp;</div>
                <div class="example__cube--left">&nbsp;</div>
                <div class="example__cube--bottom">&nbsp;</div>
                <div class="example__cube--front">&nbsp;</div>
            </div>
        </div>
        <p>
            Lorem ipsum dolor sit amet, consectetuer adipiscing elit. Aenean commodo ligula eget dolor. Aenean massa. Cum sociis natoque penatibus et magnis dis parturient montes, nascetur ridiculus mus. Donec quam felis, ultricies nec, pellentesque eu, pretium quis, sem. Nulla consequat massa quis enim. Donec pede justo, fringilla vel, aliquet nec, vulputate eget, arcu. In enim justo, rhoncus ut, imperdiet a, venenatis vitae, justo. Nullam dictum felis eu pede mollis pretium. Integer tincidunt.
        </p>
    </div>
</div>

### The backface-visibility Property

`backface-visibility` essentially just sets whether or not the transformed items can be seen through regardless of opacity. The property has two parameters: `visible` and `hidden`. The default is `visible`, but when set to `hidden` you cannot see through the panes of the cube below.

```css
.example__cubePane {
    -webkit-backface-visibility: hidden; /* For Chrome & Safari */
    backface-visibility: hidden; /* For Everything Else */
}
```

<div class="demoBox">
    <div class="example__transform">
        <div class="example__transformItem example__cube" style="-webkit-perspective: 1500px; -webkit-perspective-origin: 400px 500px; perspective: 1500px; perspective-origin: 400px 500px; height: 170px; padding-top: 30px; padding-left: 35px;">
            <div class="example__cube--content" style="perspective: 1500px; perspective-origin: 400px 500px;">
                <div class="example__cube--back" style="-webkit-backface-visibility: hidden; backface-visibility: hidden;">&nbsp;</div>
                <div class="example__cube--top" style="-webkit-backface-visibility: hidden; backface-visibility: hidden;">&nbsp;</div>
                <div class="example__cube--right" style="-webkit-backface-visibility: hidden; backface-visibility: hidden;">&nbsp;</div>
                <div class="example__cube--left" style="-webkit-backface-visibility: hidden; backface-visibility: hidden;">&nbsp;</div>
                <div class="example__cube--bottom" style="-webkit-backface-visibility: hidden; backface-visibility: hidden;">&nbsp;</div>
                <div class="example__cube--front" style="-webkit-backface-visibility: hidden; backface-visibility: hidden;">&nbsp;</div>
            </div>
        </div>
        <p>
            Lorem ipsum dolor sit amet, consectetuer adipiscing elit. Aenean commodo ligula eget dolor. Aenean massa. Cum sociis natoque penatibus et magnis dis parturient montes, nascetur ridiculus mus. Donec quam felis, ultricies nec, pellentesque eu, pretium quis, sem. Nulla consequat massa quis enim. Donec pede justo, fringilla vel, aliquet nec, vulputate eget, arcu. In enim justo, rhoncus ut, imperdiet a, venenatis vitae, justo. Nullam dictum felis eu pede mollis pretium. Integer tincidunt.
        </p>
    </div>
</div>

## Browser Support

<div class="browserSupport__list">
    <img src="../../assets/img/ie.svg" alt="ie9 and above" title="ie9 and above">
    <img src="../../assets/img/chrome.svg" alt="Chrome 29 and above" title="Chrome 29 and above">
    <img src="../../assets/img/firefox.svg" alt="Fire Fox 24 and above" title="Fire Fox 24 and above">
    <img src="../../assets/img/safari.svg" alt="Safari 5.1 and above" title="Safari 5.1 and above">
</div>

The transform property has good browser support working in all modern browsers using the "-ms-" prefix for IE9 and "-webkit-" prefix for Chrome and Safari. 3D transforms are not supported in Internet Explorer 9 and below.

- [http://www.w3.org/TR/css3-transforms/](http://www.w3.org/TR/css3-transforms/)
- [http://www.sitepoint.com/css3-transformations-2d-functions/](http://www.sitepoint.com/css3-transformations-2d-functions/)
- [https://developer.mozilla.org/en-US/docs/Web/Guide/CSS/Using\_CSS\_transforms](https://developer.mozilla.org/en-US/docs/Web/Guide/CSS/Using_CSS_transforms)
- [http://www.w3schools.com/cssref/css3\_pr\_transform-origin.asp](http://www.w3schools.com/cssref/css3_pr_transform-origin.asp)
- [http://www.w3schools.com/cssref/css3\_pr\_perspective.asp](http://www.w3schools.com/cssref/css3_pr_perspective.asp)
- [https://developer.mozilla.org/en-US/docs/Web/CSS/perspective](https://developer.mozilla.org/en-US/docs/Web/CSS/perspective)
