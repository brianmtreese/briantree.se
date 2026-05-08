---
layout: post
title: "Angular’s New injectAsync() API Explained"
date: "2026-05-07"
video_id: "YMdHXc-PEik"
tags:
  - "Angular"
  - "Angular v22"
  - "Service"
  - "Dependency Injection"
  - "Performance"
  - "TypeScript"
---

<p class="intro"><span class="dropcap">A</span>ngular v22 just made lazy-loading services much simpler. In this post, we'll explore how to leverage the new <a href="https://github.com/angular/angular/commit/444b024d49725afc8b40aec67cfdb63a1f7f23ea#diff-2e2d6a33b5784aebcbbedeb04abba424b55621fe9ec56d4e44618fdf3d7eedb1" target="_blank">injectAsync()</a> API to reduce your main bundle size and replace awkward lazy-loading workarounds. We’ll compare the older manual lazy-loading approach with Angular v22’s new <code>injectAsync()</code> API and see why the new pattern feels simpler and easier to reason about.</p>

{% include youtube-embed.html %}

## The Problem: Libraries Loading Too Early

When building Angular applications, it's common to include third-party libraries for various functionalities. 

However, if these libraries are not loaded efficiently, they can increase your initial bundle size, leading to slower application startup times. 

In our [demo application](https://github.com/brianmtreese/angular-inject-async){:target="_blank"}, we're using [highlight.js](https://highlightjs.org/){:target="_blank"} and [Marked](https://marked.js.org/){:target="_blank"} for markdown processing and syntax highlighting.

In this case, the [post-editor component](https://github.com/brianmtreese/angular-inject-async/tree/main/src/app/post-editor){:target="_blank"} itself is needed immediately, but the markdown-processing dependency isn’t.

Even though the feature might not be immediately needed by the user, these libraries are loaded upfront, contributing to a 17.2kb main bundle:

<div><img src="{{ '/assets/img/content/uploads/2026/05-07/bundle-size.jpg' | relative_url }}" alt="The bundle size of the application" width="1368" height="494" style="width: 100%; height: auto;"></div>

<div><img src="{{ '/assets/img/content/uploads/2026/05-07/external-libraries.jpg' | relative_url }}" alt="The external libraries that are loaded upfront" width="1346" height="438" style="width: 100%; height: auto;"></div>

This eager loading means users are paying for code they might never use, impacting performance.

## Understanding the Markdown Service and its Eager Usage

Our demo application features a [MarkdownService](https://github.com/brianmtreese/angular-inject-async/blob/main/src/app/markdown.service.ts){:target="_blank"} responsible for converting markdown content into HTML with syntax highlighting. 

This service leverages marked, marked-highlight, and highlight.js to achieve this functionality:

```typescript
import { Service } from '@angular/core';
import hljs from 'highlight.js/lib/common';
import { Marked } from 'marked';
import { markedHighlight } from 'marked-highlight';

@Service()
export class MarkdownService {
  private readonly marked = new Marked(
    markedHighlight({
      emptyLangClass: 'hljs',
      langPrefix: 'hljs language-',
      highlight(code, lang) {
        const language = hljs.getLanguage(lang) ? lang : 'plaintext';

        return hljs.highlight(code, { language }).value;
      },
    })
  );

  render(content: string): string {
    return this.marked.parse(content, { async: false });
  }
}
```

The core issue arises from how this service is consumed. 

Initially, the [post-editor component](https://github.com/brianmtreese/angular-inject-async/blob/main/src/app/post-editor/post-editor.component.ts){:target="_blank"} directly injects the `MarkdownService`:

```typescript
import { Component, inject, signal } from '@angular/core';
import { MarkdownService } from '../markdown.service';

@Component({
  selector: 'app-post-editor',
  templateUrl: './post-editor.component.html',
  styleUrls: ['./post-editor.component.css'],
})
export class PostEditorComponent {
  protected readonly content = signal('');
  protected readonly previewHtml = signal('');
  private markdownService = inject(MarkdownService);

  preview() {
    this.previewHtml.set(this.markdownService.render(this.content()));
  }
}
```

Because the `MarkdownService` is statically imported and injected into `PostEditorComponent`, Angular includes it and all its dependencies (`marked`, `highlight.js`) in the initial application bundle. 

This happens regardless of whether the user has interacted with the markdown preview feature, leading to unnecessary upfront loading and a larger initial bundle size. 

This is the "problem" we aim to solve with lazy loading.

## The Old Way: Manually Lazy Loading an Angular Service

Historically, addressing eager loading for services involved a fair amount of manual setup. 

To lazy load the `MarkdownService` and its dependencies, we would typically inject Angular's `Injector` and dynamically import the service.

It might look something like this:

```typescript
import { Component, inject, Injector, signal } from '@angular/core';

@Component({
  selector: 'app-post-editor',
  templateUrl: './post-editor.component.html',
  styleUrls: ['./post-editor.component.css'],
})
export class PostEditorComponent {
  protected readonly content = signal('');
  protected readonly previewHtml = signal('');
  private readonly injector = inject(Injector);
  private markdownServicePromise: Promise<MarkdownService> | null = null;

  async preview() {
    this.markdownServicePromise ??= import('../markdown.service').then(m =>
      this.injector.get(m.MarkdownService)
    );

    const markdownService = await this.markdownServicePromise;
    this.previewHtml.set(markdownService.render(this.content()));
  }
}
```

This approach solves the problem.

The bundle size is reduced, and `highlight.js` and `marked` are no longer part of the initial page load:

<div><img src="{{ '/assets/img/content/uploads/2026/05-07/bundle-size-lazy-loaded.jpg' | relative_url }}" alt="The bundle size of the application after lazy loading" width="1166" height="412" style="width: 100%; height: auto;"></div>

<div><img src="{{ '/assets/img/content/uploads/2026/05-07/initlial-dependencies.jpg' | relative_url }}" alt="The initial dependencies that are loaded upfront" width="1130" height="630" style="width: 100%; height: auto;"></div>

They are now dynamically loaded only when the `preview()` method is called:

<div><img src="{{ '/assets/img/content/uploads/2026/05-07/external-libraries-lazy-loaded.jpg' | relative_url }}" alt="The external libraries that are loaded lazily" width="1398" height="790" style="width: 100%; height: auto;"></div>

However, this manual lazy loading introduces a lot of setup, making it less ergonomic and harder to maintain.

## The New Way: Replacing Boilerplate with injectAsync()

Angular v22 introduces `injectAsync()`, a new API that simplifies lazy loading services. 

This function handles much of the orchestration we previously had to manage ourselves.

To refactor our post-editor component using `injectAsync()`, we can remove the `Injector` and the `markdownServicePromise`:

```typescript
import { Component, injectAsync, onIdle, signal } from '@angular/core';

@Component({
  selector: 'app-post-editor',
  templateUrl: './post-editor.component.html',
  styleUrls: ['./post-editor.component.css'],
})
export class PostEditorComponent {
  protected readonly content = signal('');
  protected readonly previewHtml = signal('');

  private markdownService = injectAsync(
    () => import('../markdown.service').then(m => m.MarkdownService)
  );

  async preview() {
    const svc = await this.markdownService();
    this.previewHtml.set(svc.render(this.content()));
  }
}
```

With `injectAsync()`, we pass a loader function that dynamically imports the service. 

Angular automatically captures the current injection context, resolves the service through dependency injection, and caches the result.

This makes the implementation simpler and easier to reason about.

### Prefetch Lazy Dependencies with onIdle

`injectAsync()` also offers a `prefetch` option, allowing us to load dependencies early, but without blocking the initial bundle:

```typescript
import { ..., onIdle } from '@angular/core';

private markdownService = injectAsync(
  () => import('../markdown.service').then(m => m.MarkdownService),
  { prefetch: onIdle }
);
```

By setting `prefetch: onIdle`, Angular will begin loading the dependency quietly in the background once the browser becomes idle.

This means the feature stays out of the initial bundle, but the user might never notice a loading delay because the service is already prefetched by the time they need it.

## The Final Result

The application continues to function exactly as before, but with an optimized loading strategy. 

The initial bundle size is smaller, and the markdown libraries are lazy-loaded, either on demand or prefetched during browser idle time. 

This makes the pattern much more practical for real-world applications.

## Get Ahead of Angular's Next Shift

Angular’s newest APIs are changing the way we build. 

If you’re ready to go deeper with one of the biggest shifts in modern Angular, my Signal Forms course will help you get comfortable with the new forms model.

You can access it either directly or through YouTube membership, whichever works best for you: 

👉 [Buy the course](https://www.udemy.com/course/angular-signal-forms/?couponCode=021409EC66FC6440B867){:target="_blank"}<br />
👉 [Get it with YouTube membership](https://www.youtube.com/channel/UCdPhLDznZzUeEtshDUe0R_A/join){:target="_blank"}

<div class="youtube-embed-wrapper">
  <iframe 
    width="1280" 
    height="720"
    src="https://www.youtube.com/embed/fZZ1UVkyB4I?rel=1&modestbranding=1" 
    frameborder="0" 
    allow="accelerometer; autoplay; clipboard-write; encrypted-media; gyroscope; picture-in-picture; web-share" 
    allowfullscreen
    loading="lazy"
    title="Build Modern Angular Forms with Signals (Full Course Preview)"
  ></iframe>
</div>

## Additional Resources
- [The source code for this example](https://github.com/brianmtreese/angular-inject-async){:target="_blank"}
- [Angular v22 `injectAsync` commit](https://github.com/angular/angular/commit/444b024d49725afc8b40aec67cfdb63a1f7f23ea){:target="_blank"}
- [Angular Dependency Injection Guide](https://angular.dev/guide/di?utm_campaign=deveco_gdemembers&utm_source=deveco){:target="_blank"}
- [Dynamic Imports (MDN)](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Operators/import){:target="_blank"}
- [My course "Angular: Styling Applications"](https://www.pluralsight.com/courses/angular-styling-applications){:target="_blank"}
- [My course "Angular in Practice: Zoneless Change Detection"](https://app.pluralsight.com/library/courses/angular-practice-zoneless-change-detection){:target="_blank"}
