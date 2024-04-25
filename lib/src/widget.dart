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
