import 'dart:math';
import 'package:flutter/widgets.dart';
import 'types.dart';

/// The LoopTransition widget provides a way to create animated transitions
/// on a child widget that repeat a certain number of times.
///
/// This widget offers features like:
///  * Pre-built transitions (fade, spin, slide, zoom, shimmer)
///  * Customizable transitions using a LoopTransitionBuilder
///  * Animation control through properties like duration, curve, delay, and repeat
///  * Reversible animation direction (forward, backward, or mirroring)
///  * Pause and resume control
///  * Callbacks for animation lifecycle events (onStart, onPause, onContinue, onCycle, onComplete)
class LoopTransition extends StatefulWidget {
  /// Creates a straightforward or backward transition.
  ///
  /// This constructor allows you to specify the following properties:
  ///  * [reverse]: Controls the animation direction (forward: !reverse). Defaults to false (forward).
  ///  * [pause]: Whether to start the animation. Defaults to false.
  ///  * [delay]: The delay before the animation starts. Defaults to Duration.zero.
  ///  * [duration]: The duration of the animation. Defaults to Duration(milliseconds: 200).
  ///  * [curve]: The animation curve that controls the easing of the animation. Defaults to Curves.linear.
  ///  * [repeat]: The number of times to repeat the animation loop. Defaults to -1 (infinite).
  ///  * [transition]: The LoopTransitionBuilder function that defines the animation behavior. Defaults to LoopTransition.fade.
  ///  * [onStart]: A callback function called only once at the very beginning when the animation starts playing.
  ///  * [onPause]: A callback function called whenever the animation is paused.
  ///  * [onContinue]: A callback function called whenever the animation is resumed after being paused.
  ///  * [onCycle]: A callback function called every time the animation completes a single loop iteration (forward and potentially backward if reverse is true).
  ///  * [onComplete]: A callback function called only once when all loops have finished playing (if repeat is not set to -1 for infinite loops).
  ///  * [wrapper]: control how the child widget is transformed based on the animation's progress and current state.
  ///  * [child]: The widget that will be animated during the transition. This is a required parameter.
  const LoopTransition({
    super.key,
    this.reverse = false,
    this.pause = false,
    this.delay = Duration.zero,
    this.duration = const Duration(milliseconds: 200),
    this.curve = Curves.linear,
    this.repeat = -1,
    this.transition = LoopTransition.fade,
    this.onStart,
    this.onPause,
    this.onContinue,
    this.onCycle,
    this.onComplete,
    this.wrapper,
    required this.child,
  })  : forward = !reverse,
        reverseDelay = null,
        reverseDuration = null,
        assert(repeat >= -1);

  /// Creates a mirroring repeatable animated transition.
  ///
  /// This constructor allows for a mirroring effect where the animation plays forward
  /// and then backward seamlessly within a single loop iteration. You can optionally
  /// specify different delays and durations for the forward and backward animations using
  /// [reverseDelay] and [reverseDuration].
  ///
  /// Inherits all the properties from the base LoopTransition constructor.
  const LoopTransition.mirror({
    super.key,
    this.pause = false,
    this.delay = Duration.zero,
    this.duration = const Duration(milliseconds: 200),
    this.reverseDelay,
    this.reverseDuration,
    this.curve = Curves.linear,
    this.repeat = -1,
    this.transition = LoopTransition.fade,
    this.onStart,
    this.onPause,
    this.onContinue,
    this.onCycle,
    this.onComplete,
    this.wrapper,
    required this.child,
  })  : forward = true,
        reverse = true,
        assert(repeat >= -1);

  /// When set to true, the animation playback is paused.
  /// When set to false (default), the animation plays normally
  /// according to the defined loop count [repeat].
  final bool pause;

  /// The delay before the animation starts.
  final Duration delay;

  /// Optional properties for the LoopTransition.mirror constructor.
  ///
  /// The delay before the animation starts playing in the reverse direction.
  /// This allows for a slight pause between the forward and backward animations in the mirroring effect.
  ///
  /// Defaults to null, which means the reverse animation will use the same delay
  /// as the forward animation specified by the [delay] property.
  final Duration? reverseDelay;

  /// The [duration] of the animation.
  final Duration duration;

  /// Optional properties for the LoopTransition.mirror constructor.
  ///
  /// The duration of the animation for the backward direction.
  /// This allows you to specify a different duration for the backward animation
  /// compared to the forward animation, creating an asymmetrical mirroring effect.
  ///
  /// Defaults to null, which means the backward animation will use the same duration
  /// as the forward animation specified by the [duration] property.
  final Duration? reverseDuration;

  /// The [curve] of the animation. By default it's [Curves.linear].
  final Curve curve;

  /// Controls how many times the entire animation loop
  /// (forward and potentially backward if reverse is true) will be played.
  /// Regardless of the repeat value, the animation will always play through
  /// one complete cycle (forward and potentially backward) before considering the repeat condition.
  ///
  /// Here's how repeat actually works:
  /// * `repeat = -1` (default): Plays the animation indefinitely (loops forever).
  /// * `repeat = 0`: Plays the animation one time only (one cycle).
  /// * `repeat = 1`: Plays the animation twice (one complete loop, then repeats the entire loop again).
  /// * `repeat > 1`: Plays the animation for the specified number of loops in addition to the initial cycle. For example, repeat = 3 plays the animation four times in total (one initial cycle + three repeats).
  ///
  /// In essence, the repeat property doesn't affect whether the animation plays one cycle initially. It controls how many times the entire loop repeats after the first cycle.
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

  /// Called only once at the very beginning when
  /// the animation starts playing for the first time.
  final VoidCallback? onStart;

  /// Called when the animation is paused.
  final VoidCallback? onPause;

  /// Called when the animation is resumed after being paused.
  final VoidCallback? onContinue;

  /// Called when a complete loop iteration finishes.
  final ValueSetter<int>? onCycle;

  /// Called when all specified loops have finished playing
  /// (if repeat is not set to -1 for infinite loops).
  final VoidCallback? onComplete;

  /// It allows you to control how the child widget
  /// is transformed based on the animation's progress
  /// and current state (LoopAnimationStatus).
  final LoopTransitionWrapperBuilder? wrapper;

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

  @override
  State<LoopTransition> createState() => LoopTransitionState();
}

class LoopTransitionState extends State<LoopTransition>
    with SingleTickerProviderStateMixin {
  /// The [AnimationController] that controls the animation.
  late AnimationController controller;

  /// The [Animation] that is driven by the [AnimationController].
  late Animation<double> animation;

  /// Track of how many times the animation cycle has finished playing.
  int cycle = 0;

  /// Indicates that the [cycle] has exceed the [widget.repeat] limit
  bool get cycleExceed => cycle > widget.repeat;

  /// Track whether the animation has initially run.
  bool isInitialized = false;

  /// Track whether all specified loops have finished playing
  /// (if [widget.repeat] is not set to -1 for infinite loops).
  bool isCompleted = false;

  /// Track whether the animation is running.
  bool get isAnimating => !widget.pause;

  /// Indicates both [forward] and [reverse] are `true`
  bool get isMirror => widget.forward && widget.reverse;

  /// Indicates either [forward] or [reverse] direction.
  bool get isNotMirror => !isMirror;

  /// Indicates repeat definitely
  bool get isDefinitely => widget.repeat > -1;

  /// Indicates repeat indefinitely
  bool get isIndefinitely => !isDefinitely;

  /// Connects curve with the controller
  void _buildAnimation() {
    final tween = widget.forward || isMirror
        ? Tween<double>(begin: 0, end: 1)
        : Tween<double>(begin: 1, end: 0);
    animation = tween.animate(
      CurvedAnimation(
        parent: controller,
        curve: widget.curve,
      ),
    );
  }

  /// Run the animation
  void _runAnimation() {
    // Reset the animation counter
    if (widget.pause) {
      controller.stop();
      if (isInitialized && !isCompleted) widget.onPause?.call();
    } else {
      if (isCompleted) return;

      if (isInitialized) {
        widget.onContinue?.call();
      } else {
        isInitialized = true;
        widget.onStart?.call();
      }

      if (controller.status == AnimationStatus.reverse) {
        controller.reverse();
      } else {
        controller.forward();
      }
    }
  }

  /// End the animation
  void _endAnimation() {
    setState(() {
      isCompleted = true;
    });
    widget.onComplete?.call();
  }

  /// Handle the animation events
  void _handleEvents() {
    if (controller.isCompleted) {
      cycle++;
      if (isNotMirror) {
        widget.onCycle?.call(cycle);
        if (isDefinitely && cycleExceed) {
          _endAnimation();
          return;
        }
      }
      if (isMirror) {
        Future.delayed(
          widget.reverseDelay ?? widget.delay,
          () => controller.reverse(),
        );
      } else {
        Future.delayed(widget.delay, () => controller.forward(from: 0));
      }
    }
    if (isInitialized && controller.isDismissed) {
      if (isMirror) {
        widget.onCycle?.call(cycle);
        if (isDefinitely && cycleExceed) {
          _endAnimation();
          return;
        }
      }
      Future.delayed(widget.delay, () {
        if (isMirror) {
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
      reverseDuration: widget.reverseDuration,
      vsync: this,
    )..addListener(_handleEvents);

    // Connects curve with the controller and start it.
    _buildAnimation();
    _runAnimation();
  }

  @override
  void didUpdateWidget(LoopTransition oldWidget) {
    if (!mounted) return;

    // Duration might have changed, so update the [AnimationController]
    controller.duration = widget.duration;
    controller.reverseDuration = widget.reverseDuration;

    // Restart the animation when certain prop changed
    if (widget.repeat != oldWidget.repeat ||
        widget.forward != oldWidget.forward ||
        widget.reverse != oldWidget.reverse) {
      isInitialized = false;
      isCompleted = false;
      cycle = 0;
      controller.reset();
    }

    // Connects curve with the controller and start it.
    _buildAnimation();
    _runAnimation();

    super.didUpdateWidget(oldWidget);
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final child = widget.wrapper?.call(widget.child, this) ?? widget.child;
    return widget.transition(child, animation);
  }
}
