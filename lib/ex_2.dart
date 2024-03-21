import 'package:flutter/material.dart';

enum CircleSide { left, right }

extension ToPath on CircleSide {
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

  //! Half a circle(180 degress) is pi & 90 degress is pi/2
  @override
  State<Example2> createState() => _Example2State();
}

class _Example2State extends State<Example2> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade800,
      body: SafeArea(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ClipPath(
              clipper: const HalfCircleClipper(side: CircleSide.left),
              child: Container(
                height: 150,
                width: 150,
                color: const Color(0xff0057b7),
              ),
            ),
            ClipPath(
              clipper: const HalfCircleClipper(side: CircleSide.right),
              child: Container(
                height: 150,
                width: 150,
                color: const Color(0xffffd700),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
