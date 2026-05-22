---
layout: post
title: "Better Loading Buttons in Angular Material v22"
date: "2026-05-21"
video_id: "lhywQYRmWOI"
tags:
  - "Angular"
  - "Angular Material"
  - "Angular v22"
  - "Angular Components"
  - "TypeScript"
---

<p class="intro"><span class="dropcap">A</span>ngular Material v22 adds a small but surprisingly useful improvement to buttons: <a href="https://github.com/angular/components/commit/b4a89d5996864e591cfac762db420ec591d931e2" target="_blank">built-in progress indicator support</a>. Instead of manually swapping button text with a spinner and dealing with layout jumpiness, we can let the <a href="https://v9.material.angular.dev/components/button/overview" target="_blank">Material button directive</a> manage the loading UI for us. In this post, I'll show you the old manual approach, why it creates a small UX issue, and how Angular Material v22 cleans it up.</p>

{% include youtube-embed.html %}

## A Simple Example

Let's start with a simple reports page:

<div><img src="{{ '/assets/img/content/uploads/2026/05-21/reports-page.jpg' | relative_url }}" alt="A simple reports page with a list of reports and a download button for each report" width="1932" height="1010" style="width: 100%; height: auto;"></div>

We have a list of reports, and each report has a "Download" button using the [matButton](https://material.angular.dev/components/button/overview){:target="_blank"} directive:

```html
<section>
  <ul class="report-list">
    @for (report of reports(); track report.id) {
      <li class="report-row">
        <div class="report-info">
          <span class="report-name">{% raw %}{{ report.name }}{% endraw %}</span>
          <span class="report-meta">{% raw %}{{ report.date }} · {{ report.size }}{% endraw %}</span>
        </div>

        <button
          matButton="outlined"
          [disabled]="downloadingId() !== null"
          (click)="download(report)">
          Download
        </button>
      </li>
    }
  </ul>
</section>
```

Nothing unusual here.

But the loading UI is where this usually gets a little clunky.

## The Old Way: Swap the Label for a Spinner

Before this new Angular Material v22 feature, a common approach was to conditionally replace the button label with a spinner.

First, we need to import the [progress spinner](https://material.angular.dev/components/progress-spinner/overview){:target="_blank"} in our component:

```typescript
import { MatProgressSpinner } from '@angular/material/progress-spinner';

@Component({
  selector: 'app-report-list',
  templateUrl: './report-list.component.html',
  styleUrl: './report-list.component.scss',
  changeDetection: ChangeDetectionStrategy.OnPush,
  imports: [MatButton, MatProgressSpinner],
})
export class ReportListComponent {
  // ...
}
```

Then we can update the button template to include the progress spinner conditionally when the report is downloading and the label when it isn't:

```html
<button
  matButton="outlined"
  [disabled]="downloadingId() !== null"
  (click)="download(report)">
  @if (downloadingId() === report.id) {
    <mat-progress-spinner
      mode="indeterminate"
      [diameter]="20"
      aria-label="Downloading"
    />
  } @else {
    Download
  }
</button>
```

Since this download doesn't expose a real percentage, `mode="indeterminate"` is the right fit here.

The `diameter` keeps the spinner small enough to fit inside the button, and the `aria-label` gives assistive technologies meaningful loading-state text since the visible label is being replaced.

And this works fine:

<div><img src="{{ '/assets/img/content/uploads/2026/05-21/reports-page-downloading.gif' | relative_url }}" alt="A reports page with a list of reports and a download button for each report. When the report is downloading, we show a spinner. When it isn't, we show the label." width="1120" height="922" style="width: 100%; height: auto;"></div>

When the report is downloading, we show a spinner. 

When it isn't, we show the label.

But there's still a UX issue.

The button shrinks when the label disappears and only the spinner remains.

That's because we're swapping the button's content entirely. 

The text has one width, the spinner has another, and the button resizes to fit whatever is currently rendered.

It's not broken, but it feels a little janky.

And we had to write the conditional content logic ourselves.

## The Angular Material v22 Way: Use `showProgress` and `progressIndicator`

Angular Material v22 gives us another option.

Instead of swapping the label and spinner manually, both can live inside the button at the same time:

```html
<button
  matButton="outlined"
  [showProgress]="downloadingId() === report.id"
  [disabled]="downloadingId() !== null"
  (click)="download(report)">
  <mat-progress-spinner
    progressIndicator
    mode="indeterminate"
    [diameter]="20"
    aria-label="Downloading"
  />
  Download
</button>
```

There are two important pieces here.

First, the button gets the `showProgress` input, which is new in Angular Material v22:

```html
[showProgress]="downloadingId() === report.id"
```

This tells the `matButton` directive when the progress UI should be shown.

In this case, we only want progress on the button for the report currently being downloaded.

Then, the spinner gets the `progressIndicator` attribute:

```html
<mat-progress-spinner progressIndicator />
```

This marks the spinner as the button's projected progress indicator.

So instead of us writing an `@if` block to decide what appears, Angular Material controls that progress indicator slot for us.

## Why This Feels Better

<div><img src="{{ '/assets/img/content/uploads/2026/05-21/reports-page-downloading-with-progress.gif' | relative_url }}" alt="A reports page with a list of reports and a download button for each report. When the report is downloading, we show a spinner. When it isn't, we show the label, this time using the new showProgress input." width="950" height="882" style="width: 100%; height: auto;"></div>

The important detail is that the normal button content stays in the layout, even when the progress indicator is visible.

So the button still knows how wide the "Download" label is, even while the spinner is being displayed.

That means we avoid the width jump caused by replacing the content completely.

The end result is a loading button that feels stable instead of jumpy.

## This Does Not Have to Be a Material Spinner

One nice part of this API is that `progressIndicator` is a projection slot.

That means the projected content doesn't have to be `mat-progress-spinner` specifically.

You could use a custom loading element if that fits your design system better.

The main thing is to make sure the progress indicator still communicates meaningful loading-state information, especially when the visible button label is hidden or visually replaced.

## Cleaner Loading Buttons in Angular Material

This is one of those Angular Material updates that isn't huge, but it's immediately useful.

The old approach works, but it usually means manually swapping content and accepting small layout issues.

With `showProgress` and `progressIndicator`, Angular Material gives us a built-in pattern for loading buttons that feels more polished with less template logic.

## Want to Go Deeper With Modern Angular?

Angular's newest APIs are changing the way we build.

If you're ready to go deeper with one of the biggest shifts in modern Angular, my Signal Forms course will help you get comfortable with the new forms model.

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
- [The source code for this example](https://github.com/brianmtreese/angular-material-button-progress-indicator){:target="_blank"}
- [The commit that made this possible](https://github.com/angular/components/commit/b4a89d5996864e591cfac762db420ec591d931e2){:target="_blank"}
- [Angular Material Button Docs](https://material.angular.dev/components/button/overview){:target="_blank"}
- [Angular Material Progress Spinner Docs](https://material.angular.dev/components/progress-spinner/overview){:target="_blank"}
- [My course "Angular: Styling Applications"](https://www.pluralsight.com/courses/angular-styling-applications){:target="_blank"}
- [My course "Angular in Practice: Zoneless Change Detection"](https://app.pluralsight.com/library/courses/angular-practice-zoneless-change-detection){:target="_blank"}
