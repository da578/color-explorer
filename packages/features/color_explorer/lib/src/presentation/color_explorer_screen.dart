import 'package:color_explorer/src/presentation/color_explorer_notifier.dart';
import 'package:color_explorer/src/presentation/scroll_effect_item.dart';
import 'package:color_explorer/src/presentation/sound_helper/sound_helper_web.dart';
import 'package:design_system/design_system.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

/// A screen that displays an infinite scrollable
/// list of colors with transition effects.
///
/// This screen acts as the primary user interface for exploring colors.
/// It retrieves the color list from the provided [notifier] and renders
/// each color as a [ColorStrip] wrapped in a [ScrollEffectItem]. It also
/// tracks the color in the center of the screen to dynamically update the
/// application's theme.
class ColorExplorerScreen extends StatefulWidget {
  /// Creates a color explorer screen.
  ///
  /// The [notifier] parameter provides the state management for the screen.
  const ColorExplorerScreen({
    required this.notifier,
    super.key,
  });

  /// The state notifier managing the color data.
  final ColorExplorerNotifier notifier;

  @override
  State<ColorExplorerScreen> createState() => _ColorExplorerScreenState();
}

class _ColorExplorerScreenState extends State<ColorExplorerScreen> {
  late final ScrollController _scrollController;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController
      ..removeListener(_onScroll)
      ..dispose();
    super.dispose();
  }

  /// Tracks the scroll position and smoothly interpolates between the two
  /// colors closest to the center of the viewport
  /// to update the active theme color.
  void _onScroll() {
    if (!_scrollController.hasClients) return;

    final scrollOffset = _scrollController.offset;
    final viewportHeight = _scrollController.position.viewportDimension;
    final calculatedHeight = viewportHeight / 7.0;

    if (calculatedHeight > 0) {
      // Calculate the exact fractional index at the center of the viewport.
      final centerOffset = scrollOffset + (viewportHeight / 2.0);
      final fractionalIndex = centerOffset / calculatedHeight;

      // Identify the two adjacent color indices
      // and the interpolation factor (t).
      final lowerIndex = fractionalIndex.floor();
      final upperIndex = lowerIndex + 1;
      final t = fractionalIndex - lowerIndex;

      final colors = widget.notifier.colors;
      if (colors.isNotEmpty) {
        // Use Euclidean modulo to safely handle
        // negative indices during overscroll.
        final color1 = colors[lowerIndex % colors.length];
        final color2 = colors[upperIndex % colors.length];

        // Smoothly blend the two colors based on the scroll position.
        final blendedColor = Color.lerp(color1, color2, t) ?? color1;
        widget.notifier.updateActiveColor(blendedColor);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Color Explorer'),
        elevation: 0,
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          // Calculate the height of each strip so exactly 7 fit the screen.
          final calculatedHeight = constraints.maxHeight / 7.0;

          return ListenableBuilder(
            listenable: widget.notifier,
            builder: (context, _) {
              final colors = widget.notifier.colors;

              // Wrap with Listener to intercept and accelerate mouse wheel scrolling on Web/Desktop.
              return Listener(
                onPointerSignal: (pointerSignal) {
                  if (pointerSignal is PointerScrollEvent) {
                    // Multiply the scroll delta to increase scroll speed.
                    final newOffset =
                        _scrollController.offset +
                        pointerSignal.scrollDelta.dy * 1.5;
                    _scrollController.jumpTo(
                      newOffset.clamp(
                        _scrollController.position.minScrollExtent,
                        _scrollController.position.maxScrollExtent,
                      ),
                    );
                  }
                },
                child: ListView.builder(
                  controller: _scrollController,
                  physics: const BouncingScrollPhysics(
                    parent: AlwaysScrollableScrollPhysics(),
                  ),
                  itemBuilder: (context, index) {
                    final color = colors[index % colors.length];

                    return ScrollEffectItem(
                      index: index,
                      scrollController: _scrollController,
                      stripHeight: calculatedHeight,
                      onLeaveScreen: playBeepThrottled,
                      child: ColorStrip(
                        color: color,
                        height: calculatedHeight,
                      ),
                    );
                  },
                ),
              );
            },
          );
        },
      ),
    );
  }
}
