import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class BumpingLogo extends StatefulWidget {
  const BumpingLogo({super.key});

  @override
  _BumpingLogoState createState() => _BumpingLogoState();
}

class _BumpingLogoState extends State<BumpingLogo>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<Offset> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1),
    )..repeat(reverse: true);

    _animation = Tween<Offset>(
      begin: const Offset(0, 0),
      end: const Offset(0, -0.05),
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    ));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SlideTransition(
      position: _animation,
      child: SvgPicture.asset('assets/icon.svg', height: 100, width: 75),
    );
  }
}