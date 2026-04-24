---
layout: post
title: "This completely changed my Angular development workflow"
date: "2026-04-23"
video_id: "V1MM8Sejuak"
tags:
  - "AI Code Editor"
  - "AI Coding Assistant"
  - "Angular"
  - "Artificial Intelligence"
  - "Cursor AI"
---

<p class="intro"><span class="dropcap">Y</span>ou ever use AI to generate Angular code that's <em>almost</em> right, but not quite? You end up renaming things, swapping decorators for signals, and rewriting <code>*ngIf</code> to <code>@if</code> every single time. Well, in this post, I'll show you how to use <a href="https://cursor.com/docs/skills" target="_blank">Cursor Skills</a> to encode those fixes once and automate your Angular workflow for the whole team.</p>

{% include youtube-embed.html %}

## The Problem: Fixing "Almost Right" Code

When we use AI to generate Angular code, it often defaults to generic patterns. 

We end up spending time manually refactoring it to match our specific architecture or modern Angular conventions like signals and standalone components.

Instead of repeating these manual fixes every time, we can use Cursor Skills to tell the AI exactly how we want our code built.

## The Old Way: Manual Refactoring

Before Cursor Skills, we'd ask the AI for a component and get back something that maybe looked like this:

```typescript
import { Component, Input, Output, EventEmitter } from '@angular/core';
import { CommonModule } from '@angular/common';

@Component({
  selector: 'app-hello-world',
  standalone: true,
  imports: [CommonModule],
  template: `
    <section class="hello-world">
      <h2>Hello, world</h2>
      <p *ngIf="todayDate">{% raw %}{{ todayDate }}{% endraw %}</p>
      <button type="button" (click)="onClick()">Update time</button>
    </section>
  `,
})
export class HelloWorldComponent {
  @Input() todayDate!: string;
  @Output() updateTime = new EventEmitter<string>();

  onClick() {
    this.updateTime.emit(new Date().toISOString());
  }
}
```

That's almost right, but every single line needs a touch-up: 
- Drop `standalone: true` (it's the default now)
- Remove `CommonModule` 
- Swap `@Input()` / `@Output()` for `input()` / `output()`
- And replace `*ngIf` with `@if`
- And add `OnPush` change detection

Doing that by hand every time is slow, inconsistent, and worst of all, a guaranteed source of drift across a team. 

Of course we can continue running the old component generation schematic but it's not as flexible as using AI.

## The New Way: Project-Level Cursor Skills

Cursor Skills allow us to define reusable workflows that are committed directly into our source code. 

This ensures every developer on the team follows the same standards.

### Step 1: Setting Up the Skills Directory

We create a `.cursor/skills` directory in our project root. 

Inside, we add a folder for each skill. 

In this case we'll create an `angular-component-generator` folder. 

Inside this folder, we then need to add a `SKILL.md` file inside it.

<div><img src="{{ '/assets/img/content/uploads/2026/04-23/cursor-skills-folder-structure.jpg' | relative_url }}" alt="The folder structure showing the .cursor/skills directory and the SKILL.md file." width="684" height="312" style="width: 100%; height: auto;"></div>

It's important to note that the name "SKILL" in this file must be capitalized for Cursor to recognize it as a skill.

This file is just Markdown with a bit of frontmatter. 

The frontmatter tells Cursor when to use the skill, and the body is the "training material", the conventions, a template, and an example.

Here's the shape of our component-generator skill (with the full template omitted for brevity):

````markdown
---
name: angular-component-generator
description: Generates a modern Angular standalone component using signals, OnPush change detection, native control flow, and the latest Angular conventions. Use when the user asks to create, scaffold, or generate an Angular component.
---

# Angular Component Generator

Creates a single, modern Angular component file that follows current Angular (v20+) conventions.

## Conventions to Follow

- **Standalone** — do NOT set `standalone: true` (it's the default in v20+)
- **Change detection** — always set `changeDetection: ChangeDetectionStrategy.OnPush`
- **Inputs / outputs** — use `input()` and `output()` functions, not decorators
- **State** — use `signal()` for local state, `computed()` for derived state
- **Templates** — prefer inline `template`; use `@if` / `@for` / `@switch`
- **Injection** — use the `inject()` function, not constructor injection
- **Selector** — kebab-case with an `app-` prefix
- **Class name** — PascalCase ending in `Component`

## Workflow

1. Confirm the component name with the user (if not provided).
2. Generate the file using the template below.
3. Only split into separate `.html` / `.css` files if they're large enough to justify it.

## Template

```ts
// ... a reference template the AI uses as a starting point ...
```

## Don'ts

- Don't add `standalone: true`
- Don't use `NgModule`
- Don't use `@Input()` / `@Output()` decorators
- Don't use `*ngIf` / `*ngFor` / `*ngSwitch`
- Don't import `CommonModule` just to use control flow
````

The full version is in the [project repo](https://github.com/brianmtreese/create-angular-skills-cursor){:target="_blank"}, but notice the pattern: 
- Describe the conventions
- Provide a template
- And list the things you never want to see

That last section is the one that makes the biggest difference in practice. 

It directly counters the AI's default habits.

### Step 2: Running the Skill

To use the skill, we open a new chat and invoke it by typing a forward slash followed by the skill name:

<div><img src="{{ '/assets/img/content/uploads/2026/04-23/cursor-skills-slash-command.jpg' | relative_url }}" alt="Typing the /angular-component-generator slash command in a new Cursor chat." width="1030" height="542" style="width: 100%; height: auto;"></div>

Cursor reads our `SKILL.md` and asks for anything missing.

In this case it looks like we need to provide some more information:

<div><img src="{{ '/assets/img/content/uploads/2026/04-23/cursor-skills-clarifying-questions.jpg' | relative_url }}" alt="Cursor asking follow-up questions for the component name, inputs, and outputs." width="1034" height="916" style="width: 100%; height: auto;"></div>

So here's what I added:

<div><img src="{{ '/assets/img/content/uploads/2026/04-23/cursor-skills-user-response.jpg' | relative_url }}" alt="The user's reply with the hello-world component details: todayDate input and updateTime output." width="780" height="392" style="width: 100%; height: auto;"></div>

Then, after it does its work, we've got a new component:

<div><img src="{{ '/assets/img/content/uploads/2026/04-23/cursor-skills-generated-component.jpg' | relative_url }}" alt="The generated HelloWorldComponent file open in the editor after the skill runs." width="762" height="378" style="width: 100%; height: auto;"></div>

Here's what the generated code looks like:

```typescript
import { ChangeDetectionStrategy, Component, input, output } from '@angular/core';

@Component({
  selector: 'app-hello-world',
  changeDetection: ChangeDetectionStrategy.OnPush,
  template: `
    <section class="hello-world">
      <h2>Hello, world</h2>
      <p class="hello-world__date">{% raw %}{{ todayDate() }}{% endraw %}</p>
      <button type="button" (click)="emitUpdateTime()">Update time</button>
    </section>
  `,
  styles: `
    .hello-world {
      display: block;
    }

    .hello-world__date {
      margin: 0.5rem 0;
    }
  `,
})
export class HelloWorldComponent {
  readonly todayDate = input.required<string>();
  readonly updateTime = output<string>();

  protected emitUpdateTime(): void {
    this.updateTime.emit(new Date().toISOString());
  }
}
```

Compare that to the generic version from earlier: 
- No `standalone: true`
- No `CommonModule`
- No decorators
- And no `*ngIf` 

Exactly the code we would have spent time hand-editing, or following up with AI, generated for us in one shot.

## Automating Unit Tests

And skills compose nicely. 

Once we have one for generating components, the obvious next move is a matching skill for generating their tests. 

For this we create a second folder, `add-component-unit-tests`, with its own `SKILL.md` that encodes how our team writes specs:

<div><img src="{{ '/assets/img/content/uploads/2026/04-23/cursor-skills-add-component-unit-tests-folder.jpg' | relative_url }}" alt="The .cursor/skills directory with the add-component-unit-tests folder and its SKILL.md file alongside the component generator skill." width="796" height="720" style="width: 100%; height: auto;"></div>

And here's what the code for that skill might look like (the spec template is abbreviated below for brevity):

````markdown
---
name: add-component-unit-tests
description: Evaluates an Angular standalone component and generates unit tests that cover its inputs, outputs, signals, computed values, methods, and template behavior following unit-testing best practices. Use when the user asks to add, generate, scaffold, or write unit tests for an Angular component.
---

# Add Angular Component Unit Tests

Creates a `.component.spec.ts` file next to an Angular component that covers its public API and rendered behavior using Angular's `TestBed` and Jasmine.

## Assumptions

- Angular v20+ standalone components (no `NgModule`, no `standalone: true`).
- Inputs/outputs declared with `input()` / `input.required()` / `output()`.
- State with `signal()` and derived state with `computed()`.
- Native control flow (`@if`, `@for`, `@switch`) in templates.
- Host bindings/listeners declared via the `host` object.
- `ChangeDetectionStrategy.OnPush`.

## Workflow

1. **Read the component file** to build an inventory of inputs, outputs, signals, computed values, methods, host bindings, template elements, and injected dependencies.
2. **Derive the test plan** using the Test Plan Heuristics below. Briefly list the cases you will cover before writing code.
3. **Write the spec file** at `<folder>/<name>.component.spec.ts` using the Spec Template.
4. **Follow the Best Practices** — one behavior per test, arrange-act-assert, no snapshot tests for signals, no testing of private implementation details.
5. **Do not modify the component** to make it testable unless the user asks. If something is genuinely untestable, flag it instead of refactoring silently.

## Test Plan Heuristics

For each component, generate tests from this checklist. Skip categories that don't apply.

- **Creation**: component compiles and renders with required inputs set.
- **Inputs**: required inputs render the provided value; optional inputs use defaults; input changes propagate via `componentRef.setInput(...)` + `detectChanges()`.
- **Outputs**: each `output()` emits with the expected payload when its trigger fires.
- **Signals / computed**: initial value, updates when dependencies change, edge cases (empty, null, boundary).
- **Methods**: each method produces its documented side effect.
- **Template**: `@if` both branches, `@for` empty / one / many, `@switch` each case, event bindings, class/style bindings.
- **Host**: host classes, attributes, and listeners behave correctly.
- **Dependencies**: injected services replaced with fakes/spies via `providers`.

## Spec Template

```ts
// ... a reference spec template with TestBed setup, setInput for required inputs,
//     and sections for inputs / outputs / signals / template ...
```

## Best Practices

- **One behavior per test.** Each `it` asserts a single observable outcome.
- **Arrange / Act / Assert** — keep the three phases visually separated.
- **Test public behavior, not implementation.** Drive the component through inputs and DOM events; assert on outputs, rendered DOM, and public signals. Never test `private` members directly.
- **Use `setInput`, not field assignment.** Signal inputs must be set via `fixture.componentRef.setInput(name, value)`.
- **Call `fixture.detectChanges()`** after every state change that should affect the view.
- **Query the DOM with `By.css`** and assert against `textContent`, attributes, or element presence — not on stringified HTML.
- **Stub dependencies.** Replace injected services with jasmine spy objects via `{ provide: X, useValue: ... }` in `providers`.
- **Async.** Use `fakeAsync` + `tick` for timers, `await fixture.whenStable()` for promises.
- **No snapshot tests** for templates — write explicit assertions.
- **Deterministic.** No reliance on real dates, random values, or network. Inject or freeze those.
- **Descriptive names.** `it('emits selected with the row id when the row is clicked')`, not `it('works')`.

## Don'ts

- Don't assign signal inputs directly (`component.foo = ...`) — use `setInput`.
- Don't use `TestBed.overrideComponent` just to swap a template.
- Don't test `private` or `protected` members by casting to `any`.
- Don't assert on CSS selectors that include Angular-generated attributes (`_ngcontent-...`)
- Don't write a single giant `it` that exercises every behavior.
- Don't re-test framework behavior (that `@Input` works, that `output()` emits at all) — test your component's use of it.
- Don't modify the component under test to make it easier to test without asking first.
````

The full version, including the complete spec template and a worked example, is in the [project repo](https://github.com/brianmtreese/create-angular-skills-cursor){:target="_blank"}. 

Notice the same pattern as before: 
- Assumptions
- A workflow
- A template
- Best practices
- And a list of don'ts. 

The don'ts are what stop the AI from falling back to legacy patterns like assigning signal inputs with `component.foo = ...` or casting to `any` to poke at private members.

With that in place, we run `/add-component-unit-tests` against our `HelloWorldComponent` and get a full spec file that seeds the required signal input, exercises the output with a payload assertion, and verifies the rendered template:

```typescript
import { ComponentFixture, TestBed } from '@angular/core/testing';
import { By } from '@angular/platform-browser';
import { HelloWorldComponent } from './hello-world.component';

describe('HelloWorldComponent', () => {
  let fixture: ComponentFixture<HelloWorldComponent>;
  let component: HelloWorldComponent;

  beforeEach(async () => {
    await TestBed.configureTestingModule({
      imports: [HelloWorldComponent],
    }).compileComponents();

    fixture = TestBed.createComponent(HelloWorldComponent);
    component = fixture.componentInstance;
    fixture.componentRef.setInput('todayDate', 'Monday, April 20, 2026');
    fixture.detectChanges();
  });

  it('creates', () => {
    expect(component).toBeTruthy();
  });

  describe('inputs', () => {
    it('renders the provided todayDate value', () => {
      const el = fixture.debugElement.query(By.css('.hello-world__date')).nativeElement;
      expect(el.textContent).toContain('Monday, April 20, 2026');
    });

    it('reflects updates to todayDate', () => {
      fixture.componentRef.setInput('todayDate', 'Tuesday, April 21, 2026');
      fixture.detectChanges();

      const el = fixture.debugElement.query(By.css('.hello-world__date')).nativeElement;
      expect(el.textContent).toContain('Tuesday, April 21, 2026');
    });
  });

  describe('outputs', () => {
    it('emits updateTime exactly once when the button is clicked', () => {
      const emitSpy = spyOn(component.updateTime, 'emit');
      const button = fixture.debugElement.query(By.css('button')).nativeElement as HTMLButtonElement;

      button.click();

      expect(emitSpy).toHaveBeenCalledTimes(1);
    });

    it('emits an ISO-formatted string as the updateTime payload', () => {
      const emitSpy = spyOn(component.updateTime, 'emit');
      const button = fixture.debugElement.query(By.css('button')).nativeElement as HTMLButtonElement;

      button.click();

      expect(emitSpy).toHaveBeenCalledWith(
        jasmine.stringMatching(/^\d{4}-\d{2}-\d{2}T\d{2}:\d{2}:\d{2}/),
      );
    });
  });

  describe('template', () => {
    it('renders the heading', () => {
      const heading = fixture.debugElement.query(By.css('h2')).nativeElement;
      expect(heading.textContent).toContain('Hello, world');
    });

    it('renders the date inside the .hello-world__date element', () => {
      const date = fixture.debugElement.query(By.css('.hello-world__date'));
      expect(date).not.toBeNull();
    });

    it('renders a button with the correct type and label', () => {
      const button = fixture.debugElement.query(By.css('button')).nativeElement as HTMLButtonElement;
      expect(button.type).toBe('button');
      expect(button.textContent).toContain('Update time');
    });
  });
});
```

A lot of the skill's rules are baked into this output:
- The hardcoded date isn't magic, it comes from the `setInput` call in `beforeEach`. The skill enforces seeding required signal inputs *before* the first `detectChanges`, so the template has the data it needs to render.
- The **inputs** block covers both the initial render and how the component responds to `setInput` updates, not just "does it work once?" but "does it react to change?"
- The **outputs** block goes beyond "was it called?" and also asserts on the **payload shape** with `jasmine.stringMatching(...)`.
- The **template** block queries the rendered DOM for each meaningful element, heading, date container, button, rather than stringifying HTML or relying on snapshots.

All of that comes out of the box because we told the AI once, in the skill, how we expect our team's specs to look.

And then, we can run `npm test` to see the tests pass:

<div><img src="{{ '/assets/img/content/uploads/2026/04-23/cursor-skills-tests-passing.jpg' | relative_url }}" alt="The tests passing in the terminal after running npm test." width="1772" height="1027" style="width: 100%; height: auto;"></div>

## Skills vs. Rules: When to Use Which

If you're already using Cursor Rules (`.cursor/rules/`) or `AGENTS.md`, you might be wondering where Skills fit in. 

The short version:
- **Rules** are always-on guidance. They apply automatically to every request that matches their scope.
- **Skills** are on-demand workflows. You invoke them explicitly when you want that specific behavior.

Rules are great for baseline conventions ("we use signals in this repo"). 

Skills are great for **repeatable, parameterized tasks** ("scaffold a new component", "generate tests for this file") where you want a guided, interactive workflow instead of passive nudging.

## Final Thoughts: Automating Angular Workflows with Cursor Skills

Here’s the real takeaway: with skills, Cursor isn’t just generating code, it’s letting you encode how your team builds software.

And this is just the beginning.

Because next, we could apply something like this to migrate an existing reactive form over to signal forms, which gets way more interesting!

## Get Ahead of Angular's Next Shift

And speaking of signal forms, they’re still pretty new and not widely adopted yet, which makes this a good time to get ahead of the curve.

I created a course that walks through everything in a real-world context if you want to get up to speed early: 👉 [Angular Signal Forms: Build Modern Forms with Signals](https://www.udemy.com/course/angular-signal-forms/?couponCode=021409EC66FC6440B867){:target="_blank"}

[Build Modern Angular Forms with Signals](https://www.udemy.com/course/angular-signal-forms/?couponCode=021409EC66FC6440B867){:target="_blank"}.

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
- [The source code for this example](https://github.com/brianmtreese/create-angular-skills-cursor){:target="_blank"}
- [Cursor Skills Documentation](https://cursor.com/docs/skills){:target="_blank"}
- [My course "Angular Signal Forms: Build Modern Forms with Signals"](https://www.udemy.com/course/angular-signal-forms/?couponCode=021409EC66FC6440B867){:target="_blank"}
- [My course "Angular: Styling Applications"](https://www.pluralsight.com/courses/angular-styling-applications){:target="_blank"}
- [My course "Angular in Practice: Zoneless Change Detection"](https://app.pluralsight.com/library/courses/angular-practice-zoneless-change-detection){:target="_blank"}
