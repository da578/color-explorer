import 'package:flutter/material.dart';

/// A widget that monitors its visibility within
/// the viewport to trigger sound effects.
///
/// This widget renders its child normally without any visual transformations
/// (such as scaling or opacity changes),
/// providing a clean and standard scroll experience.
/// It tracks when the item leaves the visible screen area
/// to trigger the [onLeaveScreen] callback.
///
/// **Performance Considerations:**
/// Since this widget is used inside a lazy-loading scroll view, only visible
/// items are instantiated and register listeners on the [scrollController].
class ScrollEffectItem extends StatefulWidget {
  /// Creates a scroll effect item.
  ///
  /// The [index] parameter specifies the position of the item in the list.
  /// The [scrollController] is used to track the current scroll offset.
  /// The [stripHeight] defines the height of the item.
  /// The [onLeaveScreen] callback is triggered
  /// when the item scrolls off-screen.
  const ScrollEffectItem({
    required this.index,
    required this.scrollController,
    required this.stripHeight,
    required this.child,
    required this.onLeaveScreen,
    super.key,
  });

  /// The index of the item in the list.
  final int index;

  /// The scroll controller of the parent scroll view.
  final ScrollController scrollController;

  /// The height of the item in logical pixels.
  final double stripHeight;

  /// The child widget to be rendered.
  final Widget child;

  /// Callback triggered when the item leaves the visible screen area.
  final VoidCallback onLeaveScreen;

  @override
  State<ScrollEffectItem> createState() => _ScrollEffectItemState();
}

class _ScrollEffectItemState extends State<ScrollEffectItem> {
  bool _wasVisible = false;

  @override
  void initState() {
    super.initState();
    widget.scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    widget.scrollController.removeListener(_onScroll);
    super.dispose();
  }

  void _onScroll() {
    if (mounted) {
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    if (!widget.scrollController.hasClients) {
      return SizedBox(height: widget.stripHeight, child: widget.child);
    }

    final scrollOffset = widget.scrollController.offset;
    final viewportHeight = widget.scrollController.position.viewportDimension;

    // Theoretical top position of this item in the scrollable area.
    final itemTop = widget.index * widget.stripHeight;
    // Position of the item relative to the top of the viewport.
    final relativeTop = itemTop - scrollOffset;

    // Check visibility and trigger sound when leaving the screen.
    final isCurrentlyVisible =
        relativeTop > -widget.stripHeight && relativeTop < viewportHeight;
    if (_wasVisible && !isCurrentlyVisible) {
      widget.onLeaveScreen();
    }
    _wasVisible = isCurrentlyVisible;

    // Render the child with a fixed layout height, but allow the visual
    // representation to overflow slightly downwards using a Stack with
    // Clip.none. This eliminates subpixel rendering gaps between adjacent
    // items without causing cumulative layout drift in the scroll view.
    return SizedBox(
      height: widget.stripHeight,
      width: double.infinity,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            height: widget.stripHeight + 1.0,
            child: widget.child,
          ),
        ],
      ),
    );
  }
}
