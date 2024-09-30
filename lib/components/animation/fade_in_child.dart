// import 'package:flutter/material.dart';

// class FadeInChildWidget extends StatefulWidget {
//   final Widget child;

//   const FadeInChildWidget({super.key, required this.child});

//   @override
//   State<FadeInChildWidget> createState() => _FadeInChildWidgetState();
// }

// class _FadeInChildWidgetState extends State<FadeInChildWidget> {
//   double _opacity = 0.0; // Start with the child widget fully transparent

//   @override
//   void dispose() {
//     super.dispose();
//   }

//   @override
//   void initState() {
//     super.initState();
//     _fadeInChild(); // Start the fade-in animation when the widget is loaded
//   }

//   void _fadeInChild() {
//     Future.delayed(const Duration(milliseconds: 100), () {
//       setState(() {
//         _opacity = 1.0; // Change the opacity to fully visible
//       });
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return AnimatedOpacity(
//       opacity: _opacity,
//       curve: Curves.easeInOut,
//       duration: Duration(milliseconds: 300),
//       child: widget.child,
//     );
//   }
// }
