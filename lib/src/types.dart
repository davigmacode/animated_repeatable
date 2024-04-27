import 'package:flutter/widgets.dart';
import 'widget.dart';

/// Used within the LoopTransition widget to specify
/// the animation function that controls how the child widget
/// is transformed during the animation cycle.
typedef LoopTransitionBuilder = Widget Function(
  Widget child,
  Animation<double> animation,
);

/// This typedef defines a function signature used
/// within the LoopTransition widget. It's essentially a function
/// that builds the animated widget based on the provided parameters.
typedef LoopTransitionWrapperBuilder = Widget Function(
  Widget child,
  LoopTransitionState status,
);

/// Provides a way to dynamically position a gradient
/// within a defined area by sliding it in a specified direction
/// with a controllable amount of movement.
class GradientSlide extends GradientTransform {
  const GradientSlide({
    this.direction = AxisDirection.right,
    required this.progress,
  }) : assert(progress >= 0 && progress <= 1);

  /// Defines the direction in which the gradient will slide.
  /// Defaults to AxisDirection.right.
  final AxisDirection direction;

  /// A value between 0.0 and 1.0 that controls the position of the slide.
  final double progress;

  @override
  Matrix4? transform(Rect bounds, {TextDirection? textDirection}) {
    double offset = 0;
    // horizontal direction
    if (direction == AxisDirection.right || direction == AxisDirection.left) {
      offset = bounds.width * progress;
      offset = direction == AxisDirection.left ? -offset : offset;
      return Matrix4.translationValues(offset, 0.0, 0.0);
    }
    // vertical direction
    offset = bounds.height * progress;
    offset = direction == AxisDirection.up ? -offset : offset;
    return Matrix4.translationValues(0.0, offset, 0.0);
  }
}
