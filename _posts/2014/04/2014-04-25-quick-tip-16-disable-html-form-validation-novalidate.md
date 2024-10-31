---
layout: post
title: "Quick Tip - 16: Disable HTML Form Validation With novalidate"
date: "2014-04-25"
tags: 
  - "HTML"
  - "Forms"
---

<p class="intro"><span class="dropcap">W</span>ith HTML5 we have been given new input types (email, tel, url, number, etc.) and built in browser validation to validate them. This is great but you may want to disable this validation if you want to test your server side validation, use custom validation, or something else.</p>

This is where the `novalidate` property comes into play. Simply add it to your form tag and the default browser validation will be disabled.

```html
<form novalidate="">
    <label for="phone">Phone:</label> 
    <input name="phone" required="" type="tel" /> 
    <input type="submit" value="Submit" />
</form>
```
