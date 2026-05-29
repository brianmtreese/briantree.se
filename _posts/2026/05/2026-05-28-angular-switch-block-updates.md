---
layout: post
title: "The Angular @switch Upgrades You Should Know About"
date: 2026-05-28
video_id: "hkN68hCbzHU"
tags:
  - "Angular"
  - "Angular Templates"
  - "TypeScript"
  - "Template Syntax"
  - "Conditional Content"
  - "Angular 21"
---

<p class="intro"><span class="dropcap">A</span>ngular's <a href="https://angular.dev/api/core/@switch" target="_blank">@switch</a> block has become a lot more useful recently. With exhaustive type checking, Angular can now catch missing template states when a <a href="https://www.typescriptlang.org/docs/handbook/2/everyday-types.html#union-types" target="_blank">TypeScript union</a> or <a href="https://www.typescriptlang.org/docs/handbook/enums.html" target="_blank">enum</a> changes. And with grouped cases, we can remove duplicate markup when multiple states render the same UI. In this post, I'll show both improvements using a real-world example.</p>

{% include youtube-embed.html %}

## The Problem: UI States Can Drift from Your Types

Let's start with a common pattern.

We have a support queue where each ticket has a status:

<div>
<img src="{{ '/assets/img/content/uploads/2026/05-28/support-queue.jpg' | relative_url }}" alt="Support queue showing tickets with New, In Progress, Resolved, and Closed status labels" width="2560" height="1440" style="width: 100%; height: auto;">
</div>

There are four possible statuses, and we’re modeling them with a TypeScript union:

```typescript
type TicketStatus =
  | 'new'
  | 'in-progress'
  | 'resolved'
  | 'closed';

interface Ticket {
  id: number;
  title: string;
  customer: string;
  status: TicketStatus;
}
```

Then, we have a signal containing a list of tickets:

```typescript
protected readonly tickets = signal<Ticket[]>([
  {
    id: 1024,
    title: 'User cannot reset password',
    customer: 'Acme Corp',
    status: 'new',
  },
  {
    id: 1025,
    title: 'Billing page shows incorrect total',
    customer: 'Northstar Health',
    status: 'in-progress',
  },
  {
    id: 1026,
    title: 'Exported report is missing rows',
    customer: 'Velocity Labs',
    status: 'resolved',
  },
  {
    id: 1027,
    title: 'Login button disabled after failed attempt',
    customer: 'Summit Bank',
    status: 'closed',
  },
  {
    id: 1028,
    title: 'Production checkout error for enterprise account',
    customer: 'Atlas Retail',
    status: 'new',
  }
]);
```

So far, this is simple enough.

The status is strongly typed, and every ticket has to use one of the values from the `TicketStatus` union.

Now let's look at the template.

## A Basic Angular @switch Block

In the template, we're looping over the tickets with [@for](https://angular.dev/api/core/@for){:target="_blank"} and rendering each one as a card.

Inside each card, we use an Angular `@switch` block to render the status badge:

```html
@switch (ticket.status) {
  @case ('new') {
    <span class="badge active">Active</span>
  }
  @case ('in-progress') {
    <span class="badge active">Active</span>
  }
  @case ('resolved') {
    <span class="badge done">Done</span>
  }
  @case ('closed') {
    <span class="badge done">Done</span>
  }
}
```

Then, a little lower in the card, we have another `@switch` block for the status message:

```html
@switch (ticket.status) {
  @case ('new') {
    <p class="status-message active">
      This ticket is new and needs to be triaged.
    </p>
  }
  @case ('in-progress') {
    <p class="status-message active">
      Someone is actively working on this issue.
    </p>
  }
  @case ('resolved') {
    <p class="status-message done">
      The issue has been resolved and is waiting for confirmation.
    </p>
  }
  @case ('closed') {
    <p class="status-message done">
      This ticket is closed and no further action is needed.
    </p>
  }
}
```

This works, but there's a subtle problem.

Neither `@switch` block has a default case.

That means if the status ever becomes something other than these four values, Angular won't render anything for that part of the UI.

No badge.

No message.

Just a quiet little bug.

And those are the worst kind.

## Adding a New Union Value

Now let's say the product changes.

We need to support urgent tickets, so we add a new status called "escalated":

```typescript
type TicketStatus =
  | 'new'
  | 'in-progress'
  | 'resolved'
  | 'closed'
  | 'escalated';
```

Then we update one of the tickets to use the new status:

```typescript
{
  id: 1028,
  title: 'Production checkout error for enterprise account',
  customer: 'Atlas Retail',
  status: 'escalated',
}
```

TypeScript is happy.

The app still compiles.

And at first glance, everything looks fine.

But when the escalated ticket renders, the card is incomplete:

<div>
<img src="{{ '/assets/img/content/uploads/2026/05-28/escalated-ticket.jpg' | relative_url }}" alt="Escalated ticket showing the ticket title and customer, but no badge or message" width="2454" height="712" style="width: 100%; height: auto;">
</div>

The ticket title and customer show up, but the badge and message are missing because neither `@switch` block handles the new value.

The type changed.

The data changed.

But the template didn't keep up.

## Exhaustive @switch Checking with @default never

This is where the newer `@switch` behavior helps.

Instead of adding a normal fallback UI, we can add this:

```html
@default never;
```

This tells Angular that if the `@switch` reaches the default case, there should be no possible value left to handle.

So the badge `@switch` becomes this:

```html
@switch (ticket.status) {
  @case ('new') {
    <span class="badge active">Active</span>
  }
  @case ('in-progress') {
    <span class="badge active">Active</span>
  }
  @case ('resolved') {
    <span class="badge done">Done</span>
  }
  @case ('closed') {
    <span class="badge done">Done</span>
  }
  @default never;
}
```

Now Angular can type-check the `@switch` exhaustively.

Since `TicketStatus` includes `escalated`, but the template doesn't handle it yet, Angular reports an error:

<div>
<img src="{{ '/assets/img/content/uploads/2026/05-28/escalated-ticket-error.jpg' | relative_url }}" alt="Escalated ticket error showing the template error message" width="2372" height="596" style="width: 100%; height: auto;">
</div>

That's the win.

Instead of silently rendering broken UI, Angular forces us to update the template when the union type changes.

This is especially useful for UI states like:

- ticket statuses
- order states
- payment states
- deployment states
- user invite states
- feature flag states

Any time a known set of values drives intentional UI, exhaustive checking is worth considering.

To fix the error, we just need to add the missing `escalated` case in both `@switch` blocks.

## Cleaning Up Duplicate @case Blocks

Now that the `@switch` is safer, let's make it cleaner.

In the badge `@switch`, `new` and `in-progress` both render the same badge:

```html
@case ('new') {
  <span class="badge active">Active</span>
}
@case ('in-progress') {
  <span class="badge active">Active</span>
}
```

And `resolved` and `closed` both render the same badge too:

```html
@case ('resolved') {
  <span class="badge done">Done</span>
}
@case ('closed') {
  <span class="badge done">Done</span>
}
```

That duplication isn't terrible in a small example, but it gets annoying fast in real templates.

Modern Angular lets us combine consecutive cases that render the same block.

So we can rewrite the badge `@switch` like this:

```html
@switch (ticket.status) {
  @case ('new')
  @case ('in-progress') {
    <span class="badge active">Active</span>
  }
  @case ('resolved')
  @case ('closed') {
    <span class="badge done">Done</span>
  }
  @case ('escalated') {
    <span class="badge escalated">Escalated</span>
  }
  @default never;
}
```

Angular treats those consecutive `@case` statements as multiple conditions for the same template block.

So `new` and `in-progress` both render the `Active` badge, while `resolved` and `closed` both render the `Done` badge.

We get the same UI, but without repeating the same markup in multiple cases.

Fewer places to forget something later.

## Safer Templates, Cleaner Code

That’s the real upgrade.

The UI stays the same, but the template becomes safer, cleaner, and easier to maintain.

Exhaustive checking helps Angular catch missing states, and grouped cases help remove duplicate markup.

Small change, safer template.

## Get Ahead of Angular's Next Shift

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
- [The source code for this example](https://github.com/brianmtreese/angular-switch-block-updates){:target="_blank"}
- [Angular @switch API Reference](https://angular.dev/api/core/%40switch){:target="_blank"}
- [Angular Control Flow Docs](https://angular.dev/guide/templates/control-flow){:target="_blank"}
- [My course "Angular: Styling Applications"](https://www.pluralsight.com/courses/angular-styling-applications){:target="_blank"}
- [My course "Angular in Practice: Zoneless Change Detection"](https://app.pluralsight.com/library/courses/angular-practice-zoneless-change-detection){:target="_blank"}