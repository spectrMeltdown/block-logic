import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

/// Displays a image in a circular cut.
class BLCircular extends StatelessWidget {
  final String? url;
  final String? asset;
  final IconData? icon;
  final Color? iconColor;
  final double imgPadding;
  final BoxFit fit;
  final Color? backgroundColor;
  final double iconSize;
  final double? width;
  final double? height;
  const BLCircular(
      {this.url,
      this.asset,
      this.icon,
      this.backgroundColor,
      this.fit = BoxFit.cover,
      this.iconColor,
      this.iconSize = 40,
      this.imgPadding = 0,
      this.width,
      this.height,
      super.key});

  @override
  Widget build(BuildContext context) {
    if (asset == null && url == null && icon == null) {
      throw (ArgumentError('Provide a url, icon, or asset!!'));
    }
    return ClipRRect(
      borderRadius: const BorderRadius.all(Radius.circular(100)),
      child: Container(
        decoration: BoxDecoration(
            color: backgroundColor ?? Colors.white,
            borderRadius: const BorderRadius.all(Radius.circular(100))),
        child: Padding(
            padding: EdgeInsets.all(imgPadding),
            child: url != null
                ? imageFromURL()
                : icon != null
                    ? buildIcon()
                    : buildImage()),
      ),
    );
  }

  Widget buildIcon() {
    if (icon == null) throw (ArgumentError('Icon was null!!'));
    return Icon(
      icon,
      size: iconSize,
      color: iconColor,
    );
  }

  Widget buildImage() {
    if (asset == null) throw (ArgumentError('asset was empty!!'));
    if (asset!.contains('.svg')) {
      return SvgPicture.asset(
        asset!,
        fit: fit,
      );
    }
    return Image.asset(
      asset!,
      fit: fit,
      width: width,
      height: height,
    );
  }

  Widget imageFromURL() {
    if (url == null) throw (ArgumentError('url was empty!!'));
    return Image.network(
      url!,
      fit: fit,
      loadingBuilder: (context, child, loadingProgress) {
        if (loadingProgress == null) {
          return child;
        } else {
          return const CircularProgressIndicator();
        }
      },
      errorBuilder: (context, error, stackTrace) {
        if (error
            .toString()
            .contains('No host specified in URI file:///default')) {
          return Icon(Icons.person_rounded, size: iconSize);
        }
        if (kDebugMode) {
          return Icon(
            Icons.person_rounded,
            size: iconSize,
            color: Colors.black,
          );
        }
        return Icon(Icons.error, color: Colors.white, size: iconSize);
      },
    );
  }
}
