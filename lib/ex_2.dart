import 'package:flutter/material.dart';
import 'dart:math' show pi;


enum CircleSide { left, right }

extension on CircleSide {
  Path toPath(Size size) {
    final path = Path();  

    late Offset offset;
    late bool clockwiseOrNot;

    switch (this) {
      case CircleSide.left:
        //* Imagine this as a pencil & moving the pencil to the end of the container
        path.moveTo(size.width, 0);
        //* Now we specify till where we want the circle to end
        offset = Offset(size.width, size.height);
        //* It should be Anti-Clockwise because we are drawing the circle on the left
        clockwiseOrNot = false;
        break;

      case CircleSide.right:
        //* Imagine this as a pencil & moving the pencil to the start of the container
        // We dont really need to specify the path(0, 0) because it is the default
        // path.moveTo(0, 0);
        //* Now we specify till where we want the circle to end
        offset = Offset(0, size.height);
        //* It should be Clockwise because we are drawing the circle on the right
        clockwiseOrNot = true;
        break;
      default:
    }
    path.arcToPoint(
      offset,
      //* This asks where is the center of your circle (Its the radius)
      radius: Radius.elliptical(size.width / 2, size.height / 2),
      clockwise: clockwiseOrNot,
    );
    //* Path close means that the curve is drawn & now connect the start and end points
    path.close();
    return path;
  }
}

extension on VoidCallback {
  Future<void> delayed(Duration duration) => Future.delayed(duration, this);
}

class HalfCircleClipper extends CustomClipper<Path> {
  final CircleSide side;

  const HalfCircleClipper({required this.side});

  @override
  Path getClip(Size size) => side.toPath(size);

  //* It tells the app to should it redraw the clipper if something changes (The changes to the parent widget might change size of the clipper)
  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) => true;
}

class Example2 extends StatefulWidget {
  const Example2({super.key});

  @override
  State<Example2> createState() => _Example2State();
}

class _Example2State extends State<Example2> with TickerProviderStateMixin {
  //! Half a circle(180 degress) is pi & 90 degress is pi/2
  //* In Flutter the canvas is rotated so it starts at the TOP Left of the screen

  late AnimationController _antiClockwiseRotationController;
  late Animation<double> _antiClockwiseRotationAnimation;

  late AnimationController _flipController;
  late Animation<double> _flipAnimation;

  @override
  void initState() {
    super.initState();
    _antiClockwiseRotationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1),
    );
    _antiClockwiseRotationAnimation = Tween<double>(
      begin: 0,

      ///? End is in negative as the canvas in flutter is rotated so when we want to rotate the Circle 90 degree
      ///? it would be -90 degree in the canvas
      end: -(pi / 2),
    ).animate(
      CurvedAnimation(
        parent: _antiClockwiseRotationController,
        curve: Curves.bounceOut,
      ),
    );

    _flipController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1),
    );

    _flipAnimation = Tween<double>(
      begin: 0,
      end: pi,
    ).animate(
      CurvedAnimation(
        parent: _flipController,
        curve: Curves.bounceOut,
      ),
    );
    // Calls listener every time the status of the animation changes.
    _antiClockwiseRotationController.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        _flipAnimation = Tween<double>(
          begin: _flipAnimation.value,
          end: _flipAnimation.value + pi,
        ).animate(
          CurvedAnimation(
            parent: _flipController,
            curve: Curves.bounceOut,
          ),
        );
        _flipController
          ..reset()
          ..forward();
      }
    });
    _flipController.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        _antiClockwiseRotationAnimation = Tween<double>(
          begin: _antiClockwiseRotationAnimation.value,
          end: _antiClockwiseRotationAnimation.value + -(pi / 2),
        ).animate(
          CurvedAnimation(
            parent: _antiClockwiseRotationController,
            curve: Curves.bounceOut,
          ),
        );
        _antiClockwiseRotationController
          ..reset()
          ..forward();
      }
    });
  }

  @override
  void dispose() {
    _antiClockwiseRotationController.dispose();
    _flipController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    _antiClockwiseRotationController
      ..reset()
      ..forward.delayed(const Duration(seconds: 1));

    return Scaffold(
      backgroundColor: Colors.grey.shade800,
      body: SafeArea(
        child: Center(
          child: AnimatedBuilder(
            animation: _antiClockwiseRotationController,
            builder: (context, child) {
              return Transform(
                alignment: Alignment.center,
                transform: Matrix4.identity()
                  ..rotateZ(_antiClockwiseRotationAnimation.value),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    AnimatedBuilder(
                      animation: _flipController,
                      builder: (context, child) => Transform(
                        alignment: Alignment.centerRight,
                        transform: Matrix4.identity()
                          ..rotateY(_flipAnimation.value),
                        child: ClipPath(
                          clipper:
                              const HalfCircleClipper(side: CircleSide.left),
                          child: Container(
                            height: 150,
                            width: 150,
                            color: const Color(0xff0057b7),
                          ),
                        ),
                      ),
                    ),
                    AnimatedBuilder(
                      animation: _flipAnimation,
                      builder: (context, child) => Transform(
                        alignment: Alignment.centerLeft,
                        transform: Matrix4.identity()
                          ..rotateY(_flipAnimation.value),
                        child: ClipPath(
                          clipper:
                              const HalfCircleClipper(side: CircleSide.right),
                          child: Container(
                            height: 150,
                            width: 150,
                            color: const Color(0xffffd700),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
