[![Pub Version](https://img.shields.io/pub/v/loop_transition)](https://pub.dev/packages/loop_transition) ![GitHub](https://img.shields.io/github/license/davigmacode/flutter_loop_transition) [![GitHub](https://badgen.net/badge/icon/buymeacoffee?icon=buymeacoffee&color=yellow&label)](https://www.buymeacoffee.com/davigmacode) [![GitHub](https://badgen.net/badge/icon/ko-fi?icon=kofi&color=red&label)](https://ko-fi.com/davigmacode)

The `loop_transition` package offers a versatile widget called `LoopTransition` that allows you to apply repeatable animated transitions to a child widget. These transitions cycle through a specified number of times, creating dynamic effects within your UI.

[![Preview](https://github.com/davigmacode/flutter_loop_transition/raw/main/media/preview.gif)](https://davigmacode.github.io/flutter_loop_transition)

[Demo](https://davigmacode.github.io/flutter_loop_transition)

## Features

* Applies repeatable animated transitions to a child widget.
* Offers various built-in transition functions (`fade`, `spin`, `slide`, `zoom`, `shimmer`).
* Allows customization of transitions using the LoopTransitionBuilder.
* Supports pausing and resuming playback using the pause property.
* Provides control over animation behavior with properties like:
  * `duration`: Animation duration for each direction (forward and backward if applicable)
  * `curve`: Animation curve for easing the animation
  * `delay`: Delay before the animation starts
  * `repeat`: Number of times to repeat the animation loop (-1 for infinite)
  * `reverse`: Controls the initial animation direction (forward or backward)
  * `reverseDelay`: Delay before starting the reverse animation (in mirroring effect)
  * `reverseDuration`: Optional duration for the backward animation (mirroring effect)
* Triggers callbacks at various animation lifecycle stages:
  * `onStart`: Called only once at the very beginning of the first animation play-through.
  * `onPause`: Called whenever the animation is paused.
  * `onContinue`: Called whenever the animation is resumed after being paused.
  * `onCycle`: Called every time the animation completes a single loop iteration (forward and potentially backward if reverse is true).
  * `onComplete`: Called only once when all specified loops have finished playing (if repeat is not set to -1 for infinite loops).

## Usage

To read more about classes and other references used by `loop_transition`, see the [API Reference](https://pub.dev/documentation/loop_transition/latest/).

### Import the package
```dart
import 'package:loop_transition/loop_transition.dart';
```

### Create a straightforward or backward transition
```dart
LoopTransition(
  // Play the animation in reverse initially (optional)
  reverse: true,

  // Start the animation paused
  pause: true,

  // Delay the animation start by 1 second
  delay: const Duration(seconds: 1),

  // Set the animation duration to 500 milliseconds for each direction (forward and backward)
  duration: const Duration(milliseconds: 500),

  // Use a curve to ease the animation (optional)
  curve: Curves.easeInOut,

  // Repeat the animation loop 3 times (in addition to the initial cycle)
  repeat: 3,

  // Built-in fade transition animation (you can use a custom LoopTransitionBuilder for more complex animations)
  transition: LoopTransition.fade,

  // Callbacks for various animation lifecycle events (optional)
  onStart: () => debugPrint('Animation Started'),
  onPause: () => debugPrint('Animation Paused'),
  onContinue: () => debugPrint('Animation Continued'),
  onCycle: (cycle) => debugPrint('Animation Cycle: $cycle'),
  onComplete: () => debugPrint('Animation Completed'),

  // Animate the child widget
  child: const MyWidget(
    text: 'This is the widget that will be animated',
  ),
)
```

### Create a mirroring transition widget
```dart
LoopTransition.mirror(
  // Start the animation paused
  pause: false,

  // Delay the animation start by 1 second
  delay: const Duration(seconds: 1),

  // Set the forward animation duration to 300 milliseconds
  duration: const Duration(milliseconds: 300),

  // Set a delay before the reverse animation starts (optional)
  reverseDelay: const Duration(milliseconds: 200),

  // Set a different duration for the backward animation (optional)
  reverseDuration: const Duration(milliseconds: 500),

  // Use a curve to ease the animation (optional)
  curve: Curves.easeIn,

  // Repeat the entire loop (forward + backward) 2 times (in addition to the initial cycle)
  repeat: 2,

  // Built-in fade transition animation (you can use a custom LoopTransitionBuilder for more complex animations)
  transition: LoopTransition.fade,

  // Callbacks for various animation lifecycle events (optional)
  onStart: () => debugPrint('Animation Started'),
  onPause: () => debugPrint('Animation Paused'),
  onContinue: () => debugPrint('Animation Continued'),
  onCycle: (cycle) => debugPrint('Animation Cycle: $cycle'),
  onComplete: () => debugPrint('Animation Completed'),

  // Animate the child widget
  child: const MyWidget(
    text: 'This is the widget that will be animated',
  ),
)
```

### Built-in transitions
The package provides various built-in transitions you can use directly:

* `LoopTransition.fade`: Fades the child widget in and out during the animation cycle.
* `LoopTransition.spin`: Rotates the child widget around a central point.
* `LoopTransition.slide`: Slides the child widget to a specified position.
* `LoopTransition.zoom`: Zooms the child widget in and out.
* `LoopTransition.shimmer`: Creates a shimmering effect on the child widget.
* `LoopTransition.shakeX`: Shakes the child widget horizontally.
* `LoopTransition.shakeY`: Shakes the child widget vertically.

### Custom transitions
For more control, define your own transition functions using `LoopTransitionBuilder`:

```dart
final myCustomTransition = (child, animation) {
  // Implement your custom animation logic here
  return Container(child: child); // Wrap the child widget
};

LoopTransition(
  transition: myCustomTransition,
  child: MyWidget(),
),
```

## Sponsoring

<a href="https://www.buymeacoffee.com/davigmacode" target="_blank"><img src="https://cdn.buymeacoffee.com/buttons/v2/default-yellow.png" alt="Buy Me A Coffee" height="45"></a>
<a href="https://ko-fi.com/davigmacode" target="_blank"><img src="https://storage.ko-fi.com/cdn/brandasset/kofi_s_tag_white.png" alt="Ko-Fi" height="45"></a>

If this package or any other package I created is helping you, please consider to sponsor me so that I can take time to read the issues, fix bugs, merge pull requests and add features to these packages.