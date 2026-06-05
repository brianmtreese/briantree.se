---
layout: post
title: "Angular Material Dialogs Now Support Real Component Bindings"
date: 2026-06-04
video_id: KHRPIAPe1wc
tags: [Angular, Angular Material, Angular v22, Angular Components, Angular Input, Angular Model, Angular Signals, TypeScript]
---

<p class="intro"><span class="dropcap">A</span>ngular <a href="https://material.angular.dev/components/dialog/overview?utm_campaign=deveco_gdemembers&utm_source=deveco" target="_blank">Material dialogs</a> just got a practical upgrade. In Angular 22, dialogs can now bind directly to component inputs, outputs, and model inputs. That means we can build one reusable component, use it inline, and then open that same component inside a dialog without creating a special wrapper component.</p>

{% include youtube-embed.html %}

## The Problem

In this demo, we have a reusable [notification settings component](https://github.com/brianmtreese/angular-material-dialog-input-output-model-bindings/tree/main/src/app/notification-settings){:target="_blank"}.

It needs three things:

```typescript
readonly user = input<User | null>(null);
readonly enabled = model(false);
readonly saved = output<NotificationSettingsSaved>();
```

So inline, we can use it like this:

```html
<app-notification-settings
  [user]="user()"
  [(enabled)]="notificationsEnabled"
  (saved)="saveNotificationSettings($event)"
/>
```

This is normal Angular component communication.

<div>
<img src="{{ '/assets/img/content/uploads/2026/06-04/angular-notification-settings-input-model-output-bindings-inline-component.png' | relative_url }}" alt="An example of the notification settings component with an input, model, and output being used inline in the parent template" width="1730" height="1224" style="width: 100%; height: auto;">
</div>

The parent passes in the user, keeps the notification value synced, and listens for the save event.

But when we open that same component in an Angular Material dialog, things are different:

```typescript
protected openSettingsDialog() {
  this.dialog.open(NotificationSettingsComponent, {
    width: '28rem',
    panelClass: 'settings-dialog',
  });
}
```

The component renders, but it is disconnected:

<div>
<img src="{{ '/assets/img/content/uploads/2026/06-04/angular-material-dialog-notification-settings-component-disconnected-from-parent.png' | relative_url }}" alt="An example of the notification settings component rendered in a dialog, but disconnected from the parent" width="2061" height="1085" style="width: 100%; height: auto;">
</div>

It does not receive the `user` [input](https://angular.dev/api/core/input?utm_campaign=deveco_gdemembers&utm_source=deveco){:target="_blank"}.

It does not sync the `enabled` [model input](https://angular.dev/guide/components/inputs?utm_campaign=deveco_gdemembers&utm_source=deveco#model-inputs) value.

And the parent does not listen for the `saved` [output](https://angular.dev/api/core/output?utm_campaign=deveco_gdemembers&utm_source=deveco){:target="_blank"}.

So the goal is simple: use the same component API inside the dialog that we already use inline.

## The Reusable Component

Here’s the notification settings component:

```typescript
@Component({
  selector: 'app-notification-settings',
  imports: [MatButtonModule, MatSlideToggleModule],
  templateUrl: './notification-settings.html',
  styleUrl: './notification-settings.css',
})
export class NotificationSettingsComponent {
  readonly user = input<User | null>(null);
  readonly enabled = model(false);
  readonly saved = output<NotificationSettingsSaved>();

  protected save() {
    if (this.user()) {
      this.saved.emit({
        userId: this.user()!.id,
        enabled: this.enabled(),
      });
    }
  }
}
```

And here’s the template:

```html
<section class="settings-card">
  <div>
    <h2>Notification Settings</h2>

    @if (user()) {
      <p>
        Manage email notifications for
        <strong>{% raw %}{{ user()!.name }}{% endraw %}</strong>.
      </p>
    }
  </div>

  <mat-slide-toggle
    [checked]="enabled()"
    (change)="enabled.set($event.checked)">
    Email notifications
  </mat-slide-toggle>

  <button matButton="filled" (click)="save()">
    Save Settings
  </button>
</section>
```

The important thing here is that this component knows nothing about dialogs.

It does not inject [MAT_DIALOG_DATA](https://material.angular.dev/components/dialog/api?utm_campaign=deveco_gdemembers&utm_source=deveco#MAT_DIALOG_DATA){:target="_blank"}.

It does not need [MatDialogRef](https://material.angular.dev/components/dialog/api?utm_campaign=deveco_gdemembers&utm_source=deveco#MatDialogRef){:target="_blank"}.

It is just a regular Angular component with inputs, a model input, and an output.

## Add Dialog Bindings

In [Angular 22](https://github.com/angular/components/commit/bf3596b53ba1cf118ec06343f8a7772e0fb0e55d){:target="_blank"}, `MatDialog` supports a new `bindings` array.

This lets us bind to the component that gets rendered inside the dialog using [inputBinding()](https://angular.dev/api/core/inputBinding?utm_campaign=deveco_gdemembers&utm_source=deveco){:target="_blank"}, [outputBinding()](https://angular.dev/api/core/outputBinding?utm_campaign=deveco_gdemembers&utm_source=deveco){:target="_blank"}, and [twoWayBinding()](https://angular.dev/api/core/twoWayBinding?utm_campaign=deveco_gdemembers&utm_source=deveco){:target="_blank"}:

```typescript
import {
  inputBinding,
  outputBinding,
  twoWayBinding,
} from '@angular/core';

// ...

protected openSettingsDialog() {
  this.dialog.open(NotificationSettingsComponent, {
    width: '28rem',
    panelClass: 'settings-dialog',
    bindings: [
      inputBinding('user', this.user),
      outputBinding<NotificationSettingsSaved>('saved', settings => {
        this.saveNotificationSettings(settings);
      }),
      twoWayBinding('enabled', this.notificationsEnabled),
    ],
  });
}
```

### What Each Binding Does

This passes the current user into the dialog component:

```typescript
inputBinding('user', this.user)
```

It is the programmatic version of this:

```html
[user]="user()"
```

This listens for the save event:

```typescript
outputBinding<NotificationSettingsSaved>('saved', settings => {
  this.saveNotificationSettings(settings);
})
```

It is the programmatic version of this:

```html
(saved)="saveNotificationSettings($event)"
```

And this keeps the model input synced:

```typescript
twoWayBinding('enabled', this.notificationsEnabled)
```

It is the programmatic version of this:

```html
[(enabled)]="notificationsEnabled"
```

So now the dialog component receives the user, starts with the correct notification value, updates the parent signal when the toggle changes, and emits the same save event as the inline version.

## The Final Result

Now we can use the same component in both places.

Inline:

```html
<app-notification-settings
  [user]="user()"
  [(enabled)]="notificationsEnabled"
  (saved)="saveNotificationSettings($event)"
/>
```

<div>
<img src="{{ '/assets/img/content/uploads/2026/06-04/angular-notification-settings-input-model-output-bindings-final-inline-component.png' | relative_url }}" alt="An example of the notification settings component with an input, model, and output being used inline in the parent template" width="1730" height="1224" style="width: 100%; height: auto;">
</div>

And inside a dialog:

```typescript
this.dialog.open(NotificationSettingsComponent, {
  width: '28rem',
  panelClass: 'settings-dialog',
  bindings: [
    inputBinding('user', this.user),
    outputBinding<NotificationSettingsSaved>('saved', settings => {
      this.saveNotificationSettings(settings);
    }),
    twoWayBinding('enabled', this.notificationsEnabled),
  ],
});
```

<div>
<img src="{{ '/assets/img/content/uploads/2026/06-04/angular-material-dialog-notification-settings-input-model-output-bindings.png' | relative_url }}" alt="An example of the notification settings component with an input, model, and output being used inside a dialog" width="2145" height="1130" style="width: 100%; height: auto;">
</div>

No wrapper component.

No dialog-specific API.

No manual component instance wiring.

Just one reusable component with a clean Angular API.

## Final Thoughts

This is a small feature, but it makes dynamic components feel much more like components used directly in a template.

With `inputBinding()`, `outputBinding()`, and `twoWayBinding()`, Angular Material dialogs can now work with the same component contracts we already use everywhere else.

Build the component normally, then let the dialog bind to it.

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

- [The source code for this example](https://github.com/brianmtreese/angular-material-dialog-input-output-model-bindings){:target="_blank"}
- [Angular Material Dialog Documentation](https://material.angular.dev/components/dialog/overview?utm_campaign=deveco_gdemembers&utm_source=deveco){:target="_blank"}
- [Angular `inputBinding()` API](https://angular.dev/api/core/inputBinding?utm_campaign=deveco_gdemembers&utm_source=deveco){:target="_blank"}
- [Angular `outputBinding()` API](https://angular.dev/api/core/outputBinding?utm_campaign=deveco_gdemembers&utm_source=deveco){:target="_blank"}
- [Angular `twoWayBinding()` API](https://angular.dev/api/core/twoWayBinding?utm_campaign=deveco_gdemembers&utm_source=deveco){:target="_blank"}
