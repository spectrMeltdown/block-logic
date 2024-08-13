// import 'package:flutter/material.dart';

// class TypewriterText extends StatefulWidget {
//   final String text;
//   final TextStyle? textStyle;
//   final Duration duration;

//   const TypewriterText(
//       {required this.text,
//       this.textStyle,
//       this.duration = const Duration(milliseconds: 500),
//       super.key});

//   @override
//   State<TypewriterText> createState() => _TypewriterTextState();
// }

// class _TypewriterTextState extends State<TypewriterText>
//     with SingleTickerProviderStateMixin {
//   late AnimationController _controller;
//   late Animation<int> _characterCount;

//   @override
//   Widget build(BuildContext context) {
//     return Text(
//       widget.text.substring(0, _characterCount.value),
//       style: widget.textStyle,
//     );
//   }

//   @override
//   void dispose() {
//     _controller.dispose();
//     super.dispose();
//   }

//   @override
//   void initState() {
//     super.initState();
//     _controller = AnimationController(
//       duration: widget.duration,
//       vsync: this,
//     );

//     _characterCount =
//         StepTween(begin: 0, end: widget.text.length).animate(_controller)
//           ..addListener(() {
//             setState(() {});
//           });

//     _controller.forward();
//   }
// }
