import 'package:block_logic/logic/services/assets.dart';
import 'package:flutter/material.dart';

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
  const BLCircular({
    this.url,
    this.asset,
    this.icon,
    this.backgroundColor,
    this.fit = BoxFit.cover,
    this.iconColor,
    this.iconSize = 40,
    this.imgPadding = 0,
    this.width,
    this.height,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    if ((asset == null || asset!.isEmpty) && (url == null || url!.isEmpty) && icon == null) {
      throw (ArgumentError('Provide a url, icon, or asset!!'));
    }
    if (icon != null) {
      return buildIcon();
    }
    return CircleAvatar(
      backgroundImage: url != null ? imageFromURL() : buildImage(),
      // child: url != null ? imageFromURL() : buildImage(),
    );
  }

  Widget buildIcon() {
    if (icon == null) throw (ArgumentError('Icon was null!!'));
    return Center(
      child: Icon(
        icon,
        size: iconSize,
        color: iconColor,
      ),
    );
  }

  ImageProvider buildImage() {
    //if (asset == null || asset!.isEmpty) throw (ArgumentError('asset was empty!!'));
    final asset = Assets().backgroundGrid;
    if (asset.contains('.svg')) {
      // return SvgAssetLoader(
      //   asset,
      // );
    }
    return AssetImage(
      asset,
    );
  }

  ImageProvider imageFromURL() {
    if (url == null || url!.isEmpty) throw (ArgumentError('url was empty!!'));
    return NetworkImage(
      url!,
      // fit: fit,
      // loadingBuilder: (context, child, loadingProgress) {
      //   if (loadingProgress == null) {
      //     return child;
      //   } else {
      //     return const Padding(
      //       padding: EdgeInsets.all(5),
      //       child: CircularProgressIndicator(),
      //     );
      //   }
      // },
      // errorBuilder: (context, error, stackTrace) {
      //   /// this is the default profile pic if the user has not set his/her profile pic
      //   if (error.toString().contains('file:///default')) {
      //     return Icon(Icons.person_rounded, size: iconSize);
      //   }
      //   debugPrint(error.toString());
      //   return Icon(Icons.error, color: Colors.white, size: iconSize);
      // },
    );
  }
}
