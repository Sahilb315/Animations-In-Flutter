import 'dart:developer';

import 'package:flutter/material.dart';
import 'dart:math' show pi;

class AnimationEx1 extends StatefulWidget {
  const AnimationEx1({super.key});

  @override
  State<AnimationEx1> createState() => _AnimationEx1State();
}

class _AnimationEx1State extends State<AnimationEx1>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1),
    );
    //? pi * 2 means 360 degrees
    _animation = Tween<double>(begin: 0.0, end: pi).animate(_controller);
    _controller.repeat();
    // _controller.forward();
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade800,
      body: Center(
        child: AnimatedBuilder(
          animation: _animation,
          builder: (context, child) {
            log(_animation.value.toString());
            return Transform(
              transform: Matrix4.identity()..rotateZ(_animation.value),
              alignment: Alignment.center,
              child: GestureDetector(
                // onTap: () => _controller.repeat(),
                // onDoubleTap: () => _controller.stop(),
                child: Container(
                  height: 100,
                  width: 100,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    color: Colors.blue,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.3),
                        spreadRadius: 7,
                        blurRadius: 5,
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
