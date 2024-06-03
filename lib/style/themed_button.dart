import 'dart:math';
import 'package:flutter/material.dart';

class ThemedButton extends StatefulWidget {
  final Widget child;
  final VoidCallback? onPressed;

  const ThemedButton({super.key, required this.child, this.onPressed});

  @override
  State<ThemedButton> createState() => _ThemedButtonState();
}

class _ThemedButtonState extends State<ThemedButton>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(
    duration: const Duration(milliseconds: 300),
    vsync: this,
  );

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (event) {
        _controller.repeat();
      },
      onExit: (event) {
        _controller.stop(canceled: false);
      },
      child: RotationTransition(
        turns: _controller.drive(const _MySineTween(0.005)),
        child: GestureDetector(
          onTap: widget.onPressed,
          child: Stack(
            alignment: Alignment.center,
            children: [
              Image.asset(
                'icon/button.png',
                fit: BoxFit.cover,
              ),
              widget.child,
            ],
          ),
        ),
      ),
    );
  }
}

class _MySineTween extends Animatable<double> {
  final double maxExtent;

  const _MySineTween(this.maxExtent);

  @override
  double transform(double t) {
    return sin(t * 2 * pi) * maxExtent;
  }
}
