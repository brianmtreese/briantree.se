---
layout: post
title: "Oh Wow, That's Neat - 03: Myth.io"
date: "2014-01-22"
tags: 
  - "CSS"
---

<p class="intro"><span class="dropcap">C</span>SS Preprocessors like <a href="http://www.lesscss.org/" target="_blank">LESS</a>, <a href="http://sass-lang.com/" target="_blank">SASS</a>, and <a href="http://learnboost.github.io/stylus/" target="_blank">Stylus</a> are all the rage now-a-days and rightfully so. They all do some great stuff allowing us to write CSS in a more programmatic way where we repeat ourselves less and operate at a higher efficiency level. With all the good that they provide for us they do add a layer of complexity.</p>

Preprocessors require us to learn a new syntax and think about things differently than if we were writing plain ol' CSS. Also they allow us to implement complex solutions to problems which can make it difficult for others to work with in the end. All of this depends on the implementer of course but they do allow you to get into trouble if you don't take care to fully understand how they work.

## [Myth.io](http://www.myth.io/)

[Myth.io](http://www.myth.io/), by [Segment](https://segment.io/), is a CSS Preprocessor taking a slightly different approach. Rather than using it's own syntax, it acts as a "polyfill" for CSS to fill in the gaps between what browsers actually support, what's in the spec, and what is proposed. The overall goal is to make it so as the spec evolves you can just stop using Myth and it will just work. You also don't have to worry about learning all of the nuances of another language since you are essentially writing CSS for the future.

Myth is built on top of [Rework](https://github.com/reworkcss/rework) which is a powerful, open source library for building custom preprocessors. It also makes use of [autoprefixer](https://github.com/ai/autoprefixer) to automate the process of adding vendor specific prefixes where necessary based on the [caniuse.com](http://caniuse.com/) database.

The key to Myth is its simplicity. It doesn't try to do too much. It simply gives you what you need, although some of you may need more, most of you won't.

### More Info

You can get more info [here](http://www.myth.io/)

### View the Source

You can view the source on github [here](https://github.com/segmentio/myth)
