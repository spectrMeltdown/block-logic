import 'dart:ui';

extension ColorBrightness on Color {
  Color brighten([double amount = 0.1]) {
    assert(amount >= 0 && amount <= 1);
    return Color.fromARGB(
      a.toInt(),
      (r + ((255 - r) * amount)).toInt(),
      (g + ((255 - g) * amount)).toInt(),
      (b + ((255 - b) * amount)).toInt(),
    );
  }

  Color darken([double amount = 0.1]) {
    assert(amount >= 0 && amount <= 1);
    return Color.fromARGB(
      a.toInt(),
      (r * (1 - amount)).toInt(),
      (g * (1 - amount)).toInt(),
      (b * (1 - amount)).toInt(),
    );
  }
}
