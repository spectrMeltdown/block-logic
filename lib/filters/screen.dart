import 'package:flutter/material.dart';

class AnimatedTVScreenEffect extends StatefulWidget {
  const AnimatedTVScreenEffect({required this.child, super.key});
  final Widget child;

  @override
  State<AnimatedTVScreenEffect> createState() => _AnimatedTVScreenEffectState();
}

class _AnimatedTVScreenEffectState extends State<AnimatedTVScreenEffect>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 1),
      vsync: this,
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        widget.child,
        AnimatedBuilder(
          animation: _controller,
          builder: (context, child) {
            return CustomPaint(
              painter: AnimatedTVScreenPainter(_controller.value),
              child: Container(),
            );
          },
        ),
      ],
    );
  }
}

class AnimatedTVScreenPainter extends CustomPainter {
  final double animationValue;

  AnimatedTVScreenPainter(this.animationValue);

  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = Paint();

    // Draw scanlines
    paint.color = Colors.black.withOpacity(0.1 + (0.1 * animationValue));
    for (double y = 0; y < size.height; y += 4) {
      canvas.drawRect(Rect.fromLTWH(0, y, size.width, 2), paint);
    }

    // Draw color distortion (optional)
    paint.color = Colors.blue.withOpacity(0.05 + (0.05 * animationValue));
    canvas.drawRect(Rect.fromLTWH(0, 0, size.width / 2, size.height), paint);
    paint.color = Colors.red.withOpacity(0.05 + (0.05 * animationValue));
    canvas.drawRect(
        Rect.fromLTWH(size.width / 2, 0, size.width / 2, size.height), paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
