import 'package:flutter/material.dart';

/// A horizontal colored bar with a fixed height.
///
/// This widget renders a solid color block spanning the full width of its
/// parent container. It is designed to represent a single color band in
/// the color explorer list.
class ColorStrip extends StatelessWidget {
  /// Creates a color strip widget.
  ///
  /// The [color] parameter specifies the background color of the strip.
  /// The [height] parameter defines the vertical thickness of the strip.
  ///
  /// Example:
  /// ```dart
  /// const strip = ColorStrip(
  ///   color: Colors.red,
  ///   height: 20.0,
  /// );
  /// ```
  const ColorStrip({required this.color, required this.height, super.key});

  /// The background color of the strip.
  final Color color;

  /// The vertical thickness of the strip in logical pixels.
  final double height;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height + 1.0,
      color: color,
      width: double.infinity,
    );
  }
}
