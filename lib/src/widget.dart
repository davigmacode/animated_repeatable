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
    this.repeat = 0,
    this.transition = LoopTransition.fade,
    required this.child,
  }) : assert(repeat >= -1);

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
  double counter = 0;

  /// Connects curve with the controller
  void buildAnimation() {
    animation = CurvedAnimation(parent: controller, curve: widget.curve);
  }

  /// Start the animation
  void startAnimation() {
    // Reset the animation counter
    counter = 0;
    controller.forward(from: 0);
  }

  void _handleEvents() {
    if (controller.isCompleted) {
      counter++;
      if (widget.repeat > -1 && counter > widget.repeat) return;
      Future.delayed(widget.delay, () {
        controller.forward(from: 0);
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
