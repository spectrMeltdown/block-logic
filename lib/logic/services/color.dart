import 'dart:ui';

extension ColorBrightness on Color {
  Color brighten([double amount = 0.1]) {
    assert(amount >= 0 && amount <= 1);
    return Color.fromARGB(
      alpha,
      (red + ((255 - red) * amount)).toInt(),
      (green + ((255 - green) * amount)).toInt(),
      (blue + ((255 - blue) * amount)).toInt(),
    );
  }

  Color darken([double amount = 0.1]) {
    assert(amount >= 0 && amount <= 1);
    return Color.fromARGB(
      alpha,
      (red * (1 - amount)).toInt(),
      (green * (1 - amount)).toInt(),
      (blue * (1 - amount)).toInt(),
    );
  }
}
