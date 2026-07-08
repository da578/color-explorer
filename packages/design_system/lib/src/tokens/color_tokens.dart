import 'package:flutter/material.dart';

/// A collection of color tokens representing the standard rainbow spectrum.
///
/// These tokens define the core color palette used across the application
/// to ensure visual consistency.
@immutable
class ColorTokens {
  /// Private constructor to prevent instantiation.
  const ColorTokens._();

  /// The red color token.
  static const Color red = Color(0xFFFF0000);

  /// The orange color token.
  static const Color orange = Color(0xFFFF7F00);

  /// The yellow color token.
  static const Color yellow = Color(0xFFFFFF00);

  /// The green color token.
  static const Color green = Color(0xFF00FF00);

  /// The blue color token.
  static const Color blue = Color(0xFF0000FF);

  /// The indigo color token.
  static const Color indigo = Color(0xFF4B0082);

  /// The violet color token.
  static const Color violet = Color(0xFF9400D3);

  /// An unmodifiable list of all rainbow color tokens in spectral order.
  ///
  /// The order flows from [red] to [violet].
  static const List<Color> rainbow = [
    red,
    orange,
    yellow,
    green,
    blue,
    indigo,
    violet,
  ];

  /// Generates a detailed spectrum of rainbow colors.
  ///
  /// This method uses the HSV (Hue, Saturation, Value) color space to create
  /// a smooth transition across the visible spectrum. The generated colors
  /// transition from red, through orange, yellow, green, blue, indigo,
  /// and violet, before wrapping back towards red.
  ///
  /// The [count] parameter specifies the total number of colors to generate.
  /// A higher count results in a smoother gradient transition.
  ///
  /// Returns a list of [Color] objects representing the spectrum.
  ///
  /// Throws an [ArgumentError] if [count] is less than or equal to zero.
  ///
  /// Example:
  /// ```dart
  /// final spectrum = ColorTokens.generateDetailedSpectrum(360);
  /// ```
  static List<Color> generateDetailedSpectrum(int count) {
    if (count <= 0) {
      throw ArgumentError('The count must be greater than zero.');
    }

    return List.generate(count, (index) {
      final hue = (index * 360.0 / count) % 360.0;
      return HSVColor.fromAHSV(1, hue, 1, 1).toColor();
    });
  }
}
