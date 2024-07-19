import 'package:flutter/material.dart';

class BLCircularImage extends StatelessWidget {
  const BLCircularImage(this.url,
      {this.background, this.fit = BoxFit.cover, super.key});
  final String url;
  final BoxFit fit;
  final Color? background;
  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: const BorderRadius.all(Radius.circular(100)),
      child: Container(
        decoration: BoxDecoration(
            color: background,
            borderRadius: const BorderRadius.all(Radius.circular(100))),
        child: Image.network(
          url,
          fit: fit,
          loadingBuilder: (BuildContext context, Widget child,
              ImageChunkEvent? loadingProgress) {
            if (loadingProgress == null) {
              return child;
            } else {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
          },
          errorBuilder:
              (BuildContext context, Object error, StackTrace? stackTrace) {
            return const Center(
              child: Icon(
                Icons.error,
                color: Colors.red,
              ),
            );
          },
        ),
      ),
    );
  }
}
