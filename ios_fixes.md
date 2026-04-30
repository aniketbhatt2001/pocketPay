# iOS Build Fixes — Simple Explanation

---

## Fix 1: CocoaPods Profile Configuration Warning

### A quick background: what is CocoaPods?

When you build a Flutter app for iOS, it uses extra libraries (like Supabase, url_launcher, etc.).
CocoaPods is the tool that **downloads and wires those libraries into your iOS project**.
Think of it like `pub get` but for the iOS side.

### What is a `.xcconfig` file?

Xcode (Apple's IDE) uses `.xcconfig` files as **instruction sheets** — they tell Xcode things like:
- Where to find the libraries
- Which settings to use when building

### The 3 build modes

Every iOS app can be built in 3 modes:

| Mode | When it's used |
|------|---------------|
| **Debug** | While developing — slow but has logs and hot reload |
| **Profile** | For measuring performance — like a lighter Release |
| **Release** | Final app for the App Store |

Each mode needs its own instruction sheet (`.xcconfig` file).

### What was the problem?

Flutter provides `Debug.xcconfig` and `Release.xcconfig` out of the box.
But it **does not** create a `Profile.xcconfig`.

So what was Xcode doing? It was borrowing `Release.xcconfig` for Profile mode too.

When CocoaPods runs, it needs to **add its own settings** to each mode's instruction sheet.
For Debug and Release it could do this fine.
But for Profile — the instruction sheet slot was already taken by `Release.xcconfig`, so CocoaPods couldn't write its settings there. It gave up and printed a warning.

This meant Profile builds were **missing CocoaPods settings**, which could cause crashes when you try to profile the app.

### What was fixed?

Created a proper `Profile.xcconfig` file for Flutter — just like `Debug.xcconfig` and `Release.xcconfig` already existed — and told Xcode to use it for Profile mode.

CocoaPods could now write its settings into Profile mode properly. Warning gone.

---

## Fix 2: Firebase Import Crashing the Build

### A quick background: what is AppDelegate?

On iOS, every app has a file called `AppDelegate.swift`.
Think of it as the **front door of your app** — it's the very first code that runs when the app launches.

### What is Firebase?

Firebase is Google's backend service. This project originally used Firebase for user login (phone OTP).
Later, it was **switched to Supabase** (a different backend service).

### What was the problem?

When the team switched from Firebase to Supabase, they updated the Flutter/Dart code.
But they forgot to update the iOS front door — `AppDelegate.swift`.

It still had two Firebase lines sitting in it:

```swift
import FirebaseCore         ← "load the Firebase library"
...
FirebaseApp.configure()     ← "start Firebase when app opens"
```

The problem: Firebase was removed from the project, so the library no longer existed.
When Xcode tried to build the app, it went looking for `FirebaseCore` — and couldn't find it anywhere.
The build failed immediately with an error.

It's like telling someone to use a tool that's no longer in the toolbox.

### What was fixed?

Removed those two Firebase lines from `AppDelegate.swift`.

The app's front door now only starts what actually exists in the project.
Build succeeds and the app launches on the simulator.

---

## Summary

| # | File changed | Problem | Fix |
|---|---|---|---|
| 1 | `ios/Flutter/Profile.xcconfig` (created) + project file | CocoaPods couldn't write settings for Profile build mode | Created a proper Profile instruction sheet |
| 2 | `ios/Runner/AppDelegate.swift` | Firebase was removed from the project but still referenced in code | Removed the two leftover Firebase lines |
