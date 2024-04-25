[![Pub Version](https://img.shields.io/pub/v/loop_transition)](https://pub.dev/packages/loop_transition) ![GitHub](https://img.shields.io/github/license/davigmacode/flutter_loop_transition) [![GitHub](https://badgen.net/badge/icon/buymeacoffee?icon=buymeacoffee&color=yellow&label)](https://www.buymeacoffee.com/davigmacode) [![GitHub](https://badgen.net/badge/icon/ko-fi?icon=kofi&color=red&label)](https://ko-fi.com/davigmacode)

The `loop_transition` package offers a versatile widget called `LoopTransition` that allows you to apply repeatable animated transitions to a child widget. These transitions cycle through a specified number of times, creating dynamic effects within your UI.

[![Preview](https://github.com/davigmacode/flutter_loop_transition/raw/main/media/preview.gif)](https://davigmacode.github.io/flutter_loop_transition)

[Demo](https://davigmacode.github.io/flutter_loop_transition)

## Features

* **Repeatable Animations:** Define the number of times the animation loop should play using the `repeat` parameter. A value of `-1` signifies indefinite looping.
* **Pre-built Transitions:** The package provides several built-in transition functions like `fade`, `spin`, `slide`, `zoom`, and `shimmer`, making it easy to add common animation effects to your child widget.
* **Customizable Transitions:** You can define your own transition functions using the `LoopTransitionBuilder`, granting you complete control over the animation behavior.
* **Pause Control:** The addition of the `pause` parameter allows you to pause and resume the animation playback dynamically.
* **Animation Direction:** Independently control the animation's play direction using the `forward` and `reverse` parameters. Play the animation forward `(forward: true, reverse: false)`, backward `(forward:false, reverse: true)`, or both to `true` for a mirroring effect.
* **Mirroring Effect:** By setting both `forward` and `reverse` to `true`, you can create a mirroring effect where the animation plays forward and then backward within a single loop iteration.
* **Customization:** Control animation `duration`, `delay`, `curve`, and other parameters to tailor the animation behavior to your needs.

## Usage

To read more about classes and other references used by `loop_transition`, see the [API Reference](https://pub.dev/documentation/loop_transition/latest/).

### Import the package
```dart
import 'package:loop_transition/loop_transition.dart';
```

### Create a LoopTransition widget
```dart
LoopTransition(
  transition: LoopTransition.fade, // Choose a built-in transition
  duration: Duration(milliseconds: 500), // Adjust animation duration
  repeat: 2, // Repeat the animation twice
  pause: false, // Start the animation playing
  forward: true, // Play animation forward (optional)
  reverse: false, // Play animation in reverse (optional)
  child: MyWidget(), // The widget you want to animate
),
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