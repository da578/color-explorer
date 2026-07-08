import 'package:flutter/material.dart';

/// Manages the state of the color explorer feature.
///
/// This class holds the list of colors to be displayed and provides
/// methods to query the state. It extends [ChangeNotifier] to allow
/// UI components to rebuild when the state changes.
class ColorExplorerNotifier extends ChangeNotifier {
  /// Creates a notifier with an initial list of colors.
  ///
  /// The [initialColors] parameter must not be empty.
  ///
  /// Throws an [ArgumentError] if [initialColors] is empty.
  ColorExplorerNotifier({
    required List<Color> initialColors,
  }) : _colors = List<Color>.unmodifiable(initialColors) {
    if (initialColors.isEmpty) {
      throw ArgumentError('The initialColors list must not be empty.');
    }
    _activeColor = initialColors.first;
  }

  final List<Color> _colors;
  late Color _activeColor;

  /// Returns the list of colors currently being explored.
  List<Color> get colors => _colors;

  /// Returns the currently active color in the center of the screen.
  Color get activeColor => _activeColor;

  /// Updates the active color and notifies listeners if the color has changed.
  ///
  /// The [color] parameter specifies the new active color.
  void updateActiveColor(Color color) {
    if (_activeColor != color) {
      _activeColor = color;
      notifyListeners();
    }
  }
}
