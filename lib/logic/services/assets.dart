import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'generated/assets.g.dart';

@Riverpod(keepAlive: true)
Assets assets(AssetsRef ref) => Assets();

class Assets {
  /// images
  final String backgroundGrid = 'assets/images/background_grid.png';
  final String backgroundNoGrid = 'assets/images/background_no_grid.png';
  final String logo = 'assets/images/logo.png';
  final String leadeboardFirst = 'assets/images/leaderboard-first.png';
  final String leadeboardSecond = 'assets/images/leaderboard-second.png';
  final String leadeboardThird = 'assets/images/leaderboard-third.png';
  final String headerWeb = 'assets/images/header_web.jpg';
  final String feedback = 'assets/images/feedback.png';

  /// audio
  /// TODO: find the following audio
  /// - in-game music
  /// - back-button sound effect
  /// - leaderboard music (1st-3rd placer)
  /// - leaderboard music (finished game)
  final String audioBG1 = 'bg1.mp3';
  final String btn1 = 'btn.mp3';
  final String audioBGGame = 'game.ogg';

  /// fonts
  final String playFontRegular = 'assets/fonts/Play-Regular.ttf';
  final String playFontBold = 'assets/fonts/Play-Bold.ttf';
  final String majorMonoDisplay = 'assets/fonts/MajorMonoDisplay-Regular.ttf';

  /// animations
  final String emailVerification = 'assets/animations/email-verification.json';
  final String testLoading = 'assets/animations/test-loading.json';
  final String loadingBricks1 = 'assets/animations/loading-bricks-1.json';
  final String loadingBricks2 = 'assets/animations/loading-bricks-2.json';
  final String premiumCrown = 'assets/animations/premium-crown.json';
  final String like = 'assets/animations/like.json';
  final String pulse = 'assets/animations/pulse.json';

  /// backgrounds
  // static final String bg1 = 'assets/animations/backgrounds/bg-1.json';
  // static final String bg2 = 'assets/animations/backgrounds/bg-2.json';
  // static final String bg3 = 'assets/animations/backgrounds/bg-3.json';
  // static final String bg4 = 'assets/animations/backgrounds/bg-4.json';

  /// background (video)
  // final String bg1 = 'assets/videos/bg-1.mp4';
  // final String bg2 = 'assets/videos/bg-2.mp4';
  // final String bg3 = 'assets/videos/bg-3.mp4';
  // final String bg4 = 'assets/videos/bg-4.mp4';
}
