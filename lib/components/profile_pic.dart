import 'dart:typed_data';

import 'package:block_logic/components/custom_widgets.dart';
import 'package:block_logic/logic/providers/providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:http/http.dart';

class BLProfilePic extends ConsumerStatefulWidget {
  const BLProfilePic({super.key, this.size = 50, this.onPressed});
  final double size;
  final VoidCallback? onPressed;

  @override
  ConsumerState<BLProfilePic> createState() => _BLProfilePicState();
}

class _BLProfilePicState extends ConsumerState<BLProfilePic> {
  double _opacity = 0;
  String? oldPhotoURL;

  void onTapUp(TapUpDetails tapUp) {
    setState(() {
      _opacity = 0;
    });
    widget.onPressed?.call();
  }

  void onTapDown() {
    setState(() {
      _opacity = 1;
    });
  }

  void onTapCancel() {
    setState(() {
      _opacity = 0;
    });
  }

  @override
  Widget build(BuildContext context) {
    final photoURL = ref.watch(accountPhotoURLProvider);
    final audio = ref.read(gameAudioProvider.notifier);
    return GestureDetector(
      onTapDown: (TapDownDetails tapDown) {
        audio.playBtn();
        onTapDown();
      },
      onTapUp: onTapUp,
      onTapCancel: onTapCancel,
      child: Stack(
        children: [
          Container(
            width: widget.size,
            height: widget.size,
            padding: const EdgeInsets.all(5),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.blueGrey[300],
              border: Border.all(
                color: Colors.white,
                width: 3.0,
              ),
            ),
            child: CircleAvatar(
              child: Center(
                child: FractionallySizedBox(
                    widthFactor: 1,
                    heightFactor: 1,
                    child:
                        // Image.network(
                        //   photoURL.toString(),
                        //   fit: BoxFit.cover,
                        //   loadingBuilder: (BuildContext context, Widget child, ImageChunkEvent? loadingProgress) {
                        //     if (loadingProgress == null) {
                        //       return child;
                        //     } else {
                        //       return Center(
                        //         child: CircularProgressIndicator(
                        //           value: loadingProgress.expectedTotalBytes != null
                        //               ? loadingProgress.cumulativeBytesLoaded / (loadingProgress.expectedTotalBytes ?? 1)
                        //               : null,
                        //         ),
                        //       );
                        //     }
                        //   },
                        //   errorBuilder: (BuildContext context, Object error, StackTrace? stackTrace) {
                        //     return const Icon(FontAwesomeIcons.user);
                        //   },
                        // ),
                        photoURL.when(
                            data: (photoURL) {
                              debugPrint('update profile pic widget');
                              return photoURL == null
                                  ? const Icon(FontAwesomeIcons.user)
                                  : ClipRRect(
                                      borderRadius: const BorderRadius.all(Radius.circular(100)),
                                      child:
                                          //NonCacheNetworkImage(photoURL)
                                          Image.network(
                                        photoURL,
                                        fit: BoxFit.cover,
                                        loadingBuilder:
                                            (BuildContext context, Widget child, ImageChunkEvent? loadingProgress) {
                                          if (loadingProgress == null) {
                                            return child;
                                          } else {
                                            return Center(
                                              child: CircularProgressIndicator(
                                                value: loadingProgress.expectedTotalBytes != null
                                                    ? loadingProgress.cumulativeBytesLoaded /
                                                        (loadingProgress.expectedTotalBytes ?? 1)
                                                    : null,
                                              ),
                                            );
                                          }
                                        },
                                        errorBuilder: (BuildContext context, Object error, StackTrace? stackTrace) {
                                          return const Center(
                                            child: Icon(
                                              Icons.error,
                                              color: Colors.red,
                                            ),
                                          );
                                        },
                                      ),
                                    );
                            },
                            error: (error, stackTrace) => blankWidget,
                            loading: () => blankWidget)),
              ),
            ),
          ),
          AnimatedOpacity(
              duration: Durations.short3,
              curve: Curves.easeInOut,
              opacity: _opacity,
              child: Container(
                width: widget.size,
                height: widget.size,
                decoration: BoxDecoration(
                    color: Colors.black.withAlpha(100), borderRadius: const BorderRadius.all(Radius.circular(100))),
              )),
        ],
      ),
    );
  }
}

class NonCacheNetworkImage extends StatelessWidget {
  const NonCacheNetworkImage(this.imageUrl, {super.key});
  final String imageUrl;
  Future<Uint8List> getImageBytes() async {
    Response response = await get(Uri.parse(imageUrl));
    return response.bodyBytes;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Uint8List>(
      future: getImageBytes(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return Image.memory(
            snapshot.data!,
            fit: BoxFit.cover,
          );
        }
        return blankWidget;
      },
    );
  }
}
