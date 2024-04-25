import 'dart:math';
import 'package:flutter/widgets.dart';
import 'types.dart';

/// The LoopTransition widget provides a way to create animated
/// transitions on a child widget that repeat a certain number of times.
class LoopTransition extends StatefulWidget {
  /// Create a repeatable animated transition.
  const LoopTransition({
    super.key,
    this.delay = Duration.zero,
    this.duration = const Duration(milliseconds: 200),
    this.curve = Curves.linear,
    this.repeat = -1,
    this.forward = true,
    this.reverse = false,
    this.transition = LoopTransition.fade,
    required this.child,
  })  : assert(repeat >= -1),
        assert(forward == true || reverse == true);

  /// The delay before the animation starts.
  final Duration delay;

  /// The [duration] of the animation.
  final Duration duration;

  /// The [curve] of the animation. By default it's [Curves.linear].
  final Curve curve;

  /// Controls how many times the animation repeats.
  /// You can set it to repeat indefinitely by using repeat: `-1`,
  /// a specific number of times, or zero for a single play-through (repeat: `0`).
  final int repeat;

  /// Defaults to true. When set to true, the animation plays forward as defined by
  /// the provided transition function (e.g., fading in for LoopTransition.fade).
  ///
  /// When both [forward] and [reverse] are `true`,
  /// the animation plays forward for a while (defined by the animation duration)
  /// and then immediately switches to playing in reverse for the same duration.
  /// This creates a mirroring effect as the animation goes back and forth
  /// between its starting and ending states within a single loop iteration.
  final bool forward;

  /// Defaults to false. When set to true, the animation plays in reverse order.
  /// This means the transition function would be applied in a reversed manner.
  /// For example, with LoopTransition.fade and reverse: true,
  /// the child widget would start fully opaque and fade out during the animation.
  ///
  /// When both [forward] and [reverse] are `true`,
  /// the animation plays forward for a while (defined by the animation duration)
  /// and then immediately switches to playing in reverse for the same duration.
  /// This creates a mirroring effect as the animation goes back and forth
  /// between its starting and ending states within a single loop iteration.
  final bool reverse;

  /// Defines the type of animation applied to the child widget.
  /// By default, it uses a fade transition (LoopTransition.fade).
  /// You can potentially provide your own custom transition function here.
  final LoopTransitionBuilder transition;

  /// The mandatory widget that will be animated during the transition.
  final Widget child;

  /// Creates a smooth fading effect on the child widget during the animation cycle.
  static const fade = _fade;
  static Widget _fade(Widget child, Animation<double> animation) {
    return FadeTransition(
      key: ValueKey<Key?>(child.key),
      opacity: animation,
      child: child,
    );
  }

  /// Animates [child] by rotating them around a central point.
  static const spin = _spin;
  static Widget _spin(Widget child, Animation<double> animation) {
    return RotationTransition(
      key: ValueKey<Key?>(child.key),
      turns: animation,
      child: child,
    );
  }

  /// Provides a convenient way to create basic sliding animations
  /// for your [child] widget within the LoopTransition framework.
  /// Control the direction and distance of the slide using the [to] and [from] offsets.
  ///
  /// **[to]** (required, Offset) : Defines the ending position of
  /// the slide animation relative to the child widget's original location.
  /// This offset specifies the horizontal and vertical movement
  /// of the child widget during the animation.
  ///
  /// **[from]** (optional, Offset, defaults to Offset.zero) :
  /// Defines the starting position of the slide animation relative to
  /// the child widget's original location. Defaults to Offset.zero,
  /// which means the animation starts with the child widget in its original position.
  static LoopTransitionBuilder slide(
    Offset to, [
    Offset from = Offset.zero,
  ]) {
    return (child, final animation) {
      final tween = Tween<Offset>(
        begin: from,
        end: to,
      );

      return SlideTransition(
        position: tween.animate(animation),
        child: child,
      );
    };
  }

  /// Creates a transition builder that produces a zooming effect on the [child] widget.
  ///
  /// **[from]** (optional, double) : Defines the starting scale of the [child] widget
  /// during the animation cycle. Defaults to 0.0, which means the [child] widget starts off
  /// completely zoomed out (invisible).
  ///
  /// **[to]** (optional, double) : Defines the ending scale of the [child] widget
  /// during the animation cycle. Defaults to 1.0, which means the [child] widget ends up
  /// at its original size.
  static LoopTransitionBuilder zoom([
    double from = 0,
    double to = 1,
  ]) {
    return (Widget child, Animation<double> animation) {
      final tween = Tween<double>(
        begin: from,
        end: to,
      );
      return ScaleTransition(
        key: ValueKey(child.key),
        scale: tween.animate(animation),
        child: child,
      );
    };
  }

  /// Creates a transition builder specifically
  /// designed for creating a shimmering effect.
  ///
  /// **[colors]** (required, List<Color>) : A list of colors
  /// used to create the shimmering effect. The animation cycles
  /// through these colors to produce the shimmer.
  ///
  /// **[stops]** (optional, List<double>) : A list of values between 0.0 and 1.0
  /// that specify the position of each color within the gradient. If omitted,
  /// colors will be spread evenly.
  ///
  /// **[begin]** (optional, AlignmentGeometry) : Defines the starting point of
  /// the shimmer gradient. Defaults to Alignment.topLeft.
  ///
  /// **[end]** (optional, AlignmentGeometry) : Defines the ending point of the shimmer gradient.
  /// Defaults to Alignment.centerRight. This controls the direction of the shimmer animation.
  ///
  /// **[tileMode]** (optional, TileMode) : Specifies how the gradient should be tiled
  /// if the child widget is larger than the gradient itself. Defaults to TileMode.clamp,
  /// which clamps the gradient to the edges of the child widget.
  ///
  /// **[direction]** (optional, AxisDirection) : Defines the direction in which
  /// the shimmer animation moves. Defaults to AxisDirection.right,
  /// which means the shimmer moves from left to right.
  ///
  /// **[blendMode]** (optional, BlendMode) : Determines how the shimmer gradient
  /// is blended with the child widget. Defaults to BlendMode.srcATop,
  /// which places the source color over the destination color.
  static LoopTransitionBuilder shimmer({
    required List<Color> colors,
    List<double>? stops,
    AlignmentGeometry begin = Alignment.topLeft,
    AlignmentGeometry end = Alignment.centerRight,
    TileMode tileMode = TileMode.clamp,
    AxisDirection direction = AxisDirection.right,
    BlendMode blendMode = BlendMode.srcATop,
  }) {
    return (child, final animation) {
      final gradient = LinearGradient(
        colors: colors,
        stops: stops,
        begin: begin,
        end: end,
        tileMode: tileMode,
        transform: GradientSlide(
          direction: direction,
          progress: animation.value,
        ),
      );
      return ShaderMask(
        blendMode: blendMode,
        shaderCallback: (bounds) {
          return gradient.createShader(bounds);
        },
        child: child,
      );
    };
  }

  /// Creates a transition builder for that animates [child]
  /// by shaking it horizontally or vertically.
  ///
  /// [direction] (optional): An `Axis` value that controls the shaking direction.
  /// Defaults to `Axis.horizontal`, which shakes the widget back and forth horizontally.
  /// You can also use `Axis.vertical` to shake the widget up and down vertically.
  ///
  /// [distance] (optional): A `double` value that determines
  /// the maximum offset of the shaking movement. Defaults to `3.0`,
  /// which creates a moderate shaking effect. Higher values will
  /// result in more pronounced shaking.
  static LoopTransitionBuilder shake({
    Axis direction = Axis.horizontal,
    double distance = 5,
  }) {
    return (child, final animation) {
      final isHorizontal = direction == Axis.horizontal;
      final d = sin(animation.value * pi * distance) * distance;
      return Transform.translate(
        offset: Offset(
          isHorizontal ? d : 0.0,
          isHorizontal ? 0 : d,
        ),
        child: child,
      );
    };
  }

  /// Animates [child] by shake them along the horizontal axis.
  static const shakeX = _shakeX;
  static Widget _shakeX(Widget child, Animation<double> animation) {
    return shake(direction: Axis.horizontal)(child, animation);
  }

  /// Animates [child] by shake them along the vertical axis.
  static const shakeY = _shakeY;
  static Widget _shakeY(Widget child, Animation<double> animation) {
    return shake(direction: Axis.vertical)(child, animation);
  }

  /// Indicates both [forward] and [reverse] are `true`
  bool get mirror => forward && reverse;

  @override
  State<LoopTransition> createState() => _LoopTransitionState();
}

class _LoopTransitionState extends State<LoopTransition>
    with SingleTickerProviderStateMixin {
  /// The [AnimationController] that controls the animation.
  late AnimationController controller;

  /// The [Animation] that is driven by the [AnimationController].
  late Animation<double> animation;

  /// Track of how many times the animation cycle has finished playing.
  int cycle = 0;

  /// Connects curve with the controller
  void buildAnimation() {
    final tween = widget.forward || widget.mirror
        ? Tween<double>(begin: 0, end: 1)
        : Tween<double>(begin: 1, end: 0);
    animation = tween.animate(
      CurvedAnimation(
        parent: controller,
        curve: widget.curve,
      ),
    );
  }

  /// Start the animation
  void startAnimation() {
    // Reset the animation counter
    cycle = 0;
    controller.forward(from: 0);
  }

  void _handleEvents() {
    if (controller.isCompleted) {
      if (widget.repeat > -1 && cycle > widget.repeat) return;
      cycle++;
      Future.delayed(widget.delay, () {
        if (widget.mirror) {
          controller.reverse();
        } else {
          controller.forward(from: 0);
        }
      });
    }
    if (controller.isDismissed) {
      if (widget.repeat > -1 && cycle > widget.repeat) return;
      Future.delayed(widget.delay, () {
        if (widget.mirror) {
          controller.forward();
        }
      });
    }
    setState(() {});
  }

  @override
  void setState(VoidCallback fn) {
    if (mounted) {
      super.setState(fn);
    }
  }

  @override
  void initState() {
    super.initState();

    // Create controller and register the events handler
    controller = AnimationController(
      duration: widget.duration,
      vsync: this,
    )..addListener(_handleEvents);

    // Connects curve with the controller and start it.
    buildAnimation();
    startAnimation();
  }

  @override
  void didUpdateWidget(LoopTransition oldWidget) {
    // Duration might have changed, so update the [AnimationController]
    controller.duration = widget.duration;

    // Connects curve with the controller and start it.
    buildAnimation();
    startAnimation();

    super.didUpdateWidget(oldWidget);
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return widget.transition(widget.child, animation);
  }
}
