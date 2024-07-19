import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'generated/assets.g.dart';

@riverpod
Assets assets(AssetsRef ref) {
  return Assets();
}

class Assets {
  /// images
  final String backgroundGrid = 'assets/images/background_grid.png';
  final String backgroundNoGrid = 'assets/images/background_no_grid.png';
  final String logo = 'assets/images/logo.png';

  /// audio
  final String audioBG1 = 'bg1.mp3';
  final String btn1 = 'btn.mp3';

  /// fonts
  final String playFontRegular = 'assets/fonts/Play-Regular.ttf';
  final String playFontBold = 'assets/fonts/Play-Bold.ttf';
  final String majorMonoDisplay = 'assets/fonts/MajorMonoDisplay-Regular.ttf';

  /// animations
  final String loading = 'assets/animations/loading.json';
  final String emailVerification = 'assets/animations/email-verification.json';

  /// backgrounds
  // static final String bg1 = 'assets/animations/backgrounds/bg-1.json';
  // static final String bg2 = 'assets/animations/backgrounds/bg-2.json';
  // static final String bg3 = 'assets/animations/backgrounds/bg-3.json';
  // static final String bg4 = 'assets/animations/backgrounds/bg-4.json';

  /// background (video)
  final String bg1 = 'assets/videos/bg-1.mp4';
  final String bg2 = 'assets/videos/bg-2.mp4';
  final String bg3 = 'assets/videos/bg-3.mp4';
  final String bg4 = 'assets/videos/bg-4.mp4';
}
