import 'package:flutter/material.dart';
import 'package:loop_transition/loop_transition.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Loop Transition Example',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatelessWidget {
  const MyHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Wrap(
              spacing: 20,
              children: [
                const LoopTransition(
                  curve: Curves.bounceInOut,
                  duration: Duration(milliseconds: 1500),
                  reverse: true,
                  child: FlutterLogo(size: 64),
                ),
                LoopTransition.mirror(
                  curve: Curves.easeInOut,
                  duration: const Duration(milliseconds: 1500),
                  reverseDuration: const Duration(milliseconds: 500),
                  transition: LoopTransition.zoom(.5, 1.2),
                  child: const Icon(
                    Icons.favorite,
                    size: 64,
                    color: Colors.red,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            const Wrap(
              spacing: 20,
              children: [
                LoopTransition(
                  duration: Duration(milliseconds: 1500),
                  transition: LoopTransition.spin,
                  child: Icon(
                    Icons.settings,
                    size: 64,
                  ),
                ),
                PausableTransition(),
                LoopTransition(
                  duration: Duration(milliseconds: 1500),
                  reverse: true,
                  transition: LoopTransition.spin,
                  child: Icon(
                    Icons.settings,
                    size: 64,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            Wrap(
              spacing: 20,
              children: [
                const LoopTransition(
                  curve: Curves.bounceOut,
                  delay: Duration(milliseconds: 1000),
                  duration: Duration(milliseconds: 700),
                  transition: LoopTransition.shakeX,
                  child: Text('Shake Horizontally'),
                ),
                LoopTransition(
                  curve: Curves.bounceOut,
                  delay: const Duration(milliseconds: 1000),
                  duration: const Duration(milliseconds: 700),
                  transition: LoopTransition.shake(
                    direction: Axis.vertical,
                    distance: 7,
                  ),
                  child: const Text('Shake Vertically'),
                ),
              ],
            ),
            const SizedBox(height: 20),
            Wrap(
              crossAxisAlignment: WrapCrossAlignment.center,
              spacing: 20,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(
                    vertical: 10,
                    horizontal: 20,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.black87,
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: LoopTransition(
                    curve: Curves.linear,
                    delay: const Duration(milliseconds: 1000),
                    duration: const Duration(milliseconds: 900),
                    transition: LoopTransition.shimmer(
                      colors: [
                        Colors.white,
                        Colors.amber,
                        Colors.green,
                        Colors.white,
                        Colors.white,
                      ],
                    ),
                    child: DefaultTextStyle.merge(
                      style:
                          Theme.of(context).textTheme.headlineSmall?.copyWith(
                        fontWeight: FontWeight.bold,
                        shadows: [
                          const Shadow(
                            blurRadius: 1.0,
                            color: Colors.white,
                            offset: Offset(0, 0),
                          ),
                        ],
                      ),
                      child: IconTheme.merge(
                        data: const IconThemeData(size: 34),
                        child: Wrap(
                          crossAxisAlignment: WrapCrossAlignment.center,
                          spacing: 10,
                          children: [
                            Transform.translate(
                              offset: const Offset(0, 1.5),
                              child: const ThreeArrows(),
                            ),
                            const Text('Slide to unlock'),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
                const InteractiveThreeArrows(),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class PausableTransition extends StatefulWidget {
  const PausableTransition({super.key});

  @override
  State<PausableTransition> createState() => _PausableTransitionState();
}

class _PausableTransitionState extends State<PausableTransition> {
  bool paused = false;

  void toggle([bool? value]) {
    setState(() {
      paused = value ?? !paused;
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: toggle,
      child: MouseRegion(
        onEnter: (_) => toggle(true),
        onExit: (_) => toggle(false),
        child: LoopTransition.mirror(
          pause: paused,
          repeat: 5,
          onStart: () => debugPrint('Animation Started'),
          onPause: () => debugPrint('Animation Paused'),
          onContinue: () => debugPrint('Animation Continued'),
          onCycle: (cycle) => debugPrint('Animation Cycle: $cycle'),
          onComplete: () => debugPrint('Animation Completed'),
          duration: const Duration(milliseconds: 1000),
          transition: LoopTransition.spin,
          wrapper: (child, status) {
            if (status.isCompleted) {
              return const Icon(
                Icons.check,
                size: 64,
              );
            }
            return child;
          },
          child: const Icon(
            Icons.refresh,
            size: 64,
          ),
        ),
      ),
    );
  }
}

class InteractiveThreeArrows extends StatelessWidget {
  const InteractiveThreeArrows({super.key});

  @override
  Widget build(BuildContext context) {
    return LoopTransition.mirror(
      curve: Curves.easeInCubic,
      delay: const Duration(milliseconds: 500),
      duration: const Duration(milliseconds: 900),
      reverseDelay: Duration.zero,
      transition: LoopTransition.slide(const Offset(0, -.3)),
      child: LoopTransition(
        curve: Curves.linear,
        delay: const Duration(milliseconds: 1000),
        duration: const Duration(milliseconds: 900),
        transition: LoopTransition.shimmer(
          colors: [
            Colors.blue,
            Colors.white,
            Colors.blue,
            Colors.blue,
          ],
          end: Alignment.topCenter,
          begin: Alignment.bottomCenter,
          direction: AxisDirection.up,
        ),
        child: const ThreeArrows(
          direction: AxisDirection.up,
          size: 32,
        ),
      ),
    );
  }
}

class ThreeArrows extends StatelessWidget {
  const ThreeArrows({
    super.key,
    this.direction = AxisDirection.right,
    this.size,
  });

  final AxisDirection direction;

  final double? size;

  int get turns {
    switch (direction) {
      case AxisDirection.down:
        return 1;
      case AxisDirection.left:
        return 2;
      case AxisDirection.up:
        return 3;
      default:
        return 0;
    }
  }

  @override
  Widget build(BuildContext context) {
    return IconTheme.merge(
      data: IconThemeData(
        size: size,
        shadows: const [
          Shadow(
            blurRadius: 1.0,
            color: Colors.white,
            offset: Offset(0, 0),
          ),
        ],
      ),
      child: RotatedBox(
        quarterTurns: turns,
        child: const Wrap(
          children: [
            Align(
              widthFactor: .3,
              child: Icon(Icons.keyboard_arrow_right),
            ),
            Align(
              widthFactor: .3,
              child: Icon(Icons.keyboard_arrow_right),
            ),
            Align(
              widthFactor: .3,
              child: Icon(Icons.keyboard_arrow_right),
            ),
          ],
        ),
      ),
    );
  }
}
