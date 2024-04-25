import 'package:flutter/widgets.dart';
import 'types.dart';

class LoopTransition extends StatefulWidget {
  /// Create a repeatable transition.
  const LoopTransition({
    super.key,
    this.delay = Duration.zero,
    this.duration = const Duration(milliseconds: 200),
    this.curve = Curves.linear,
    this.repeat = 0,
    this.builder = fade,
    required this.child,
  }) : assert(repeat >= -1);

  /// The delay before the animation starts.
  final Duration delay;

  /// The [duration] of the animation.
  final Duration duration;

  /// The [curve] of the animation. By default it's [Curves.linear].
  final Curve curve;

  final int repeat;

  final LoopTransitionBuilder builder;

  final Widget child;

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
  // The [AnimationController] that controls the animation.
  late AnimationController controller;

  // The [Animation] that is driven by the [AnimationController].
  late Animation<double> animation;

  double counter = 0;

  void _buildAnimation() {
    // Chain tween with curve and connect it to the [AnimationController].
    animation = CurvedAnimation(parent: controller, curve: widget.curve);
  }

  @override
  void initState() {
    super.initState();
    controller = AnimationController(
      duration: widget.duration,
      vsync: this,
    );

    /// Connects tween with the [AnimationController].
    _buildAnimation();

    /// Register the [AnimationStatusListener]
    controller.addListener(() {
      if (controller.isCompleted) {
        counter++;
        if (widget.repeat > -1 && counter > widget.repeat) return;
        Future.delayed(widget.delay, () {
          controller.forward(from: 0);
        });
      }
    });

    controller.forward();
  }

  @override
  void didUpdateWidget(LoopTransition oldWidget) {
    // Duration might have changed, so update the [AnimationController]
    controller.duration = widget.duration;

    _buildAnimation();

    // Reset the animation counter
    counter = 0;

    controller.forward(from: 0);

    super.didUpdateWidget(oldWidget);
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: controller,
      builder: (context, child) {
        return widget.builder(child!, animation);
      },
      child: widget.child,
    );
  }
}
