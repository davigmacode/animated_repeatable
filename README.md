[![Pub Version](https://img.shields.io/pub/v/animated_repeatable)](https://pub.dev/packages/animated_repeatable) ![GitHub](https://img.shields.io/github/license/davigmacode/flutter_animated_repeatable) [![GitHub](https://badgen.net/badge/icon/buymeacoffee?icon=buymeacoffee&color=yellow&label)](https://www.buymeacoffee.com/davigmacode) [![GitHub](https://badgen.net/badge/icon/ko-fi?icon=kofi&color=red&label)](https://ko-fi.com/davigmacode)

The `animated_repeatable` package offers a versatile widget called `AnimatedRepeatable` that allows you to apply repeatable animated transitions to a child widget. These transitions cycle through a specified number of times, creating dynamic effects within your UI.

[![Preview](https://github.com/davigmacode/flutter_animated_repeatable/raw/main/media/preview.gif)](https://davigmacode.github.io/flutter_animated_repeatable)

[Demo](https://davigmacode.github.io/flutter_animated_repeatable)

## Features

* Applies repeatable animated transitions to a child widget.
* Offers various built-in transition functions (`fade`, `spin`, `slide`, `zoom`, `shimmer`).
* Allows customization of transitions using the AnimatedRepeatableTransitionBuilder.
* Supports pausing and resuming playback using the pause property.
* Provides control over animation behavior with properties like:
  * `repeat`: Number of times to repeat the animation loop (-1 for infinite)
  * `pause`: Whether to pause the animation.
  * `continuity`: Controls whether the animation should maintain continuity when paused.
  * `mirror`: Whether the animation should play forward, then backward in a mirroring effect.
  * `reverse`: Controls the initial animation direction (forward or backward)
  * `transition`: The AnimatedRepeatableBuilder function that defines the animation behavior.
  * `curve`: The animation curve that controls the easing of the animation.
  * `delay`: Delay before the animation starts.
  * `duration`: Animation duration for each direction (forward and backward if applicable).
  * `reverseTransition`: The transition applied for the backward direction (in mirroring).
  * `reverseCurve`: The curve to use in the backward direction (in mirroring effect).
  * `reverseDelay`: Delay before starting the backward animation (in mirroring effect)
  * `reverseDuration`: Optional duration for the backward animation (mirroring effect)
* Triggers callbacks at various animation lifecycle stages:
  * `onStart`: Called only once at the very beginning of the first animation play-through.
  * `onPause`: Called whenever the animation is paused.
  * `onContinue`: Called whenever the animation is resumed after being paused.
  * `onCycle`: Called every time the animation completes a single loop iteration (forward and potentially backward if reverse is true).
  * `onComplete`: Called only once when all specified loops have finished playing (if repeat is not set to -1 for infinite loops).

## Usage

To read more about classes and other references used by `animated_repeatable`, see the [API Reference](https://pub.dev/documentation/animated_repeatable/latest/).

### Import the package
```dart
import 'package:animated_repeatable/animated_repeatable.dart';
```

### Create a repeatable transition widget
```dart
AnimatedRepeatable(
  // Repeat the animation loop 3 times (in addition to the initial cycle)
  repeat: 3,

  // Start the animation
  pause: false,

  // When [pause] set to `true` then `false`, reset the animation to continue
  continuity: false,

  // Enable the mirror effect
  mirror: true,

  // Play the animation in reverse initially (optional)
  reverse: true,

  // Built-in fade transition animation, you can use
  // a custom AnimatedRepeatableBuilder for more complex animations
  transition: AnimatedRepeatable.fade,

  // Use a curve to ease the animation (optional)
  curve: Curves.easeInOut,

  // Delay the animation start by 1 second
  delay: const Duration(seconds: 1),

  // Set the animation duration to 500 milliseconds for each direction (forward and backward)
  duration: const Duration(milliseconds: 500),

  // Use different transition for backward animation (optional)
  reverseTransition: AnimatedRepeatable.shakeX,

  // Use a curve to ease the backward animation (optional)
  reverseCurve: Curves.bounceOut,

  // Set a delay before the reverse animation starts (optional)
  reverseDelay: const Duration(milliseconds: 200),

  // Set a different duration for the backward animation (optional)
  reverseDuration: const Duration(milliseconds: 500),

  // Callbacks for various animation lifecycle events (optional)
  onStart: () => debugPrint('Animation Started'),
  onPause: () => debugPrint('Animation Paused'),
  onContinue: () => debugPrint('Animation Continued'),
  onCycle: (cycle) => debugPrint('Animation Cycle: $cycle'),
  onComplete: () => debugPrint('Animation Completed'),

  // Allows chain effect
  wrapper: (child, state) {
    if (state.isCompleted) {
      return AnimatedRepeatable(
        delay: const Duration(milliseconds: 300),
        duration: const Duration(milliseconds: 700),
        transition: AnimatedRepeatable.shimmer(colors: [
          Colors.black87,
          Colors.blue,
          Colors.black87,
          Colors.black87,
        ]),
        child: child,
      );
    }
    return child;
  },

  // Animate the child widget
  child: const MyWidget(
    text: 'This is the widget that will be animated',
  ),
)
```

### Built-in transitions
The package provides various built-in transitions you can use directly:

* `AnimatedRepeatable.fade`: Fades the child widget in and out during the animation cycle.
* `AnimatedRepeatable.spin`: Rotates the child widget around a central point.
* `AnimatedRepeatable.slide`: Slides the child widget to a specified position.
* `AnimatedRepeatable.zoom`: Zooms the child widget in and out.
* `AnimatedRepeatable.shimmer`: Creates a shimmering effect on the child widget.
* `AnimatedRepeatable.shakeX`: Shakes the child widget horizontally.
* `AnimatedRepeatable.shakeY`: Shakes the child widget vertically.

### Custom transitions
For more control, define your own transition functions using `AnimatedRepeatableBuilder`:

```dart
final myCustomTransition = (child, animation) {
  // Implement your custom animation logic here
  return Container(child: child); // Wrap the child widget
};

AnimatedRepeatable(
  transition: myCustomTransition,
  child: MyWidget(),
),
```

### Programmatic Play/Pause
With this approach, you can control the animation playback (play/pause) of the AnimatedRepeatable widget from anywhere in your code using the globally accessible key.
```dart
import 'package:flutter/material.dart';
import 'package:animated_repeatable/animated_repeatable.dart';

final repeatableKey = GlobalKey<AnimatedRepeatableState>();

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Programmatic AnimatedRepeatable'),
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              AnimatedRepeatable(
                key: repeatableKey,
                repeat: -1, // repeat infinitely
                mirror: true,
                transition: AnimatedRepeatable.fade,
                duration: const Duration(seconds: 2),
                child: const FlutterLogo(size: 100),
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      repeatableKey.currentState?.play();
                    },
                    child: const Text('Play'),
                  ),
                  const SizedBox(width: 10),
                  ElevatedButton(
                    onPressed: () {
                      repeatableKey.currentState?.pause();
                    },
                    child: const Text('Pause'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
```

## Sponsoring

<a href="https://www.buymeacoffee.com/davigmacode" target="_blank"><img src="https://cdn.buymeacoffee.com/buttons/v2/default-yellow.png" alt="Buy Me A Coffee" height="45"></a>
<a href="https://ko-fi.com/davigmacode" target="_blank"><img src="https://storage.ko-fi.com/cdn/brandasset/kofi_s_tag_white.png" alt="Ko-Fi" height="45"></a>

If this package or any other package I created is helping you, please consider to sponsor me so that I can take time to read the issues, fix bugs, merge pull requests and add features to these packages.