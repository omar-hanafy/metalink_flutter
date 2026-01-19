import 'package:flutter/material.dart';
import 'package:flutter_helper_utils/flutter_helper_utils.dart';

import 'package:metalink_flutter/src/models/link_preview_style.dart';
import 'package:metalink_flutter/src/themes/link_preview_theme.dart';

/// A skeleton loading placeholder for link previews
class LinkPreviewSkeleton extends StatelessWidget {
  /// Creates a [LinkPreviewSkeleton] with the given style.
  const LinkPreviewSkeleton({
    super.key,
    this.style = LinkPreviewStyle.card,
    this.animate = true,
    this.width,
    this.height,
    this.showImage = true,
  });

  /// The style of the skeleton
  final LinkPreviewStyle style;

  /// Whether to animate the skeleton
  final bool animate;

  /// Width of the skeleton
  final double? width;

  /// Height of the skeleton
  final double? height;

  /// Whether to include an image placeholder
  final bool showImage;

  @override
  Widget build(BuildContext context) {
    return switch (style) {
      LinkPreviewStyle.compact => _CompactSkeleton(
          animate: animate,
          width: width,
          height: height,
          showImage: showImage,
        ),
      LinkPreviewStyle.large => _LargeSkeleton(
          animate: animate,
          width: width,
          height: height,
          showImage: showImage,
        ),
      LinkPreviewStyle.card => _CardSkeleton(
          animate: animate,
          width: width,
          height: height,
          showImage: showImage,
        ),
    };
  }
}

class _CardSkeleton extends StatelessWidget {
  const _CardSkeleton({
    required this.animate,
    this.width,
    this.height,
    this.showImage = true,
  });

  final bool animate;
  final double? width;
  final double? height;
  final bool showImage;

  @override
  Widget build(BuildContext context) {
    final themeData = LinkPreviewTheme.of(context);
    final colorScheme = Theme.of(context).colorScheme;

    return Container(
      width: width ?? double.infinity,
      constraints: BoxConstraints(
        maxHeight: height ?? themeData.maxHeight ?? 320.0,
        maxWidth: themeData.maxWidth ?? double.infinity,
      ),
      decoration: BoxDecoration(
        color: themeData.backgroundColor ?? colorScheme.surface,
        borderRadius: themeData.borderRadius ?? BorderRadius.circular(12),
        border: Border.all(
          color: colorScheme.outline.addOpacity(0.2),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          if (showImage)
            Container(
              height: themeData.imageHeight ?? 150.0,
              width: double.infinity,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.only(
                  topLeft: themeData.borderRadius
                          ?.resolve(context.directionality)
                          .topLeft ??
                      const Radius.circular(12),
                  topRight: themeData.borderRadius
                          ?.resolve(context.directionality)
                          .topRight ??
                      const Radius.circular(12),
                ),
                color: _shimmerColor(colorScheme),
              ),
            ),
          Padding(
            padding: themeData.contentPadding ?? const EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Title skeleton
                _SkeletonBox(
                  animate: animate,
                  width: double.infinity,
                  height: 16,
                  borderRadius: BorderRadius.circular(4),
                ),
                const SizedBox(height: 8),

                // Description skeleton
                _SkeletonBox(
                  animate: animate,
                  width: double.infinity,
                  height: 12,
                  borderRadius: BorderRadius.circular(4),
                ),
                const SizedBox(height: 4),
                _SkeletonBox(
                  animate: animate,
                  width: double.infinity * 0.7,
                  height: 12,
                  borderRadius: BorderRadius.circular(4),
                ),
                const SizedBox(height: 8),

                // URL skeleton
                Row(
                  children: [
                    _SkeletonBox(
                      animate: animate,
                      width: 16,
                      height: 16,
                      borderRadius: BorderRadius.circular(4),
                    ),
                    const SizedBox(width: 8),
                    _SkeletonBox(
                      animate: animate,
                      width: 120,
                      height: 10,
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Color _shimmerColor(ColorScheme colorScheme) {
    return colorScheme.surfaceContainerHighest.addOpacity(0.5);
  }
}

class _CompactSkeleton extends StatelessWidget {
  const _CompactSkeleton({
    required this.animate,
    this.width,
    this.height,
    this.showImage = true,
  });

  final bool animate;
  final double? width;
  final double? height;
  final bool showImage;

  @override
  Widget build(BuildContext context) {
    final themeData = LinkPreviewTheme.of(context);
    final colorScheme = Theme.of(context).colorScheme;

    return Container(
      width: width ?? double.infinity,
      constraints: BoxConstraints(
        maxHeight: height ?? 80.0,
        maxWidth: themeData.maxWidth ?? double.infinity,
      ),
      decoration: BoxDecoration(
        color: themeData.backgroundColor ?? colorScheme.surface,
        borderRadius: themeData.borderRadius ?? BorderRadius.circular(12),
        border: Border.all(
          color: colorScheme.outline.addOpacity(0.2),
        ),
      ),
      padding: themeData.padding ?? const EdgeInsets.all(8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          if (showImage)
            _SkeletonBox(
              animate: animate,
              width: 60,
              height: 60,
              borderRadius: BorderRadius.circular(8),
            ),
          if (showImage) SizedBox(width: themeData.compactSpacing ?? 8.0),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                // Title skeleton
                _SkeletonBox(
                  animate: animate,
                  width: double.infinity,
                  height: 14,
                  borderRadius: BorderRadius.circular(4),
                ),
                const SizedBox(height: 6),

                // Description skeleton
                _SkeletonBox(
                  animate: animate,
                  width: double.infinity * 0.7,
                  height: 10,
                  borderRadius: BorderRadius.circular(4),
                ),
                const SizedBox(height: 6),

                // URL skeleton
                Row(
                  children: [
                    _SkeletonBox(
                      animate: animate,
                      width: 10,
                      height: 10,
                      borderRadius: BorderRadius.circular(4),
                    ),
                    const SizedBox(width: 4),
                    _SkeletonBox(
                      animate: animate,
                      width: 80,
                      height: 8,
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _LargeSkeleton extends StatelessWidget {
  const _LargeSkeleton({
    required this.animate,
    this.width,
    this.height,
    this.showImage = true,
  });

  final bool animate;
  final double? width;
  final double? height;
  final bool showImage;

  @override
  Widget build(BuildContext context) {
    final themeData = LinkPreviewTheme.of(context);
    final colorScheme = Theme.of(context).colorScheme;

    return Container(
      width: width ?? double.infinity,
      constraints: BoxConstraints(
        maxHeight: height ?? themeData.maxHeight ?? 400.0,
        maxWidth: themeData.maxWidth ?? double.infinity,
      ),
      decoration: BoxDecoration(
        color: themeData.backgroundColor ?? colorScheme.surface,
        borderRadius: themeData.borderRadius ?? BorderRadius.circular(12),
        border: Border.all(
          color: colorScheme.outline.addOpacity(0.2),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          if (showImage)
            Container(
              height: themeData.imageHeight != null
                  ? themeData.imageHeight! * 1.5
                  : 200.0,
              width: double.infinity,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.only(
                  topLeft: themeData.borderRadius
                          ?.resolve(context.directionality)
                          .topLeft ??
                      const Radius.circular(12),
                  topRight: themeData.borderRadius
                          ?.resolve(context.directionality)
                          .topRight ??
                      const Radius.circular(12),
                ),
                color: _shimmerColor(colorScheme),
              ),
            ),
          Padding(
            padding: themeData.contentPadding ?? const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Site name skeleton
                Row(
                  children: [
                    _SkeletonBox(
                      animate: animate,
                      width: 16,
                      height: 16,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    const SizedBox(width: 8),
                    _SkeletonBox(
                      animate: animate,
                      width: 100,
                      height: 10,
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ],
                ),
                const SizedBox(height: 12),

                // Title skeleton
                _SkeletonBox(
                  animate: animate,
                  width: double.infinity,
                  height: 20,
                  borderRadius: BorderRadius.circular(4),
                ),
                const SizedBox(height: 4),
                _SkeletonBox(
                  animate: animate,
                  width: double.infinity * 0.8,
                  height: 20,
                  borderRadius: BorderRadius.circular(4),
                ),
                const SizedBox(height: 12),

                // Description skeleton
                _SkeletonBox(
                  animate: animate,
                  width: double.infinity,
                  height: 14,
                  borderRadius: BorderRadius.circular(4),
                ),
                const SizedBox(height: 4),
                _SkeletonBox(
                  animate: animate,
                  width: double.infinity,
                  height: 14,
                  borderRadius: BorderRadius.circular(4),
                ),
                const SizedBox(height: 4),
                _SkeletonBox(
                  animate: animate,
                  width: double.infinity * 0.5,
                  height: 14,
                  borderRadius: BorderRadius.circular(4),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Color _shimmerColor(ColorScheme colorScheme) {
    return colorScheme.surfaceContainerHighest.addOpacity(0.5);
  }
}

/// A box that can be animated with a shimmer effect
class _SkeletonBox extends StatefulWidget {
  const _SkeletonBox({
    required this.animate,
    required this.width,
    required this.height,
    required this.borderRadius,
  });

  final bool animate;
  final double width;
  final double height;
  final BorderRadius borderRadius;

  @override
  State<_SkeletonBox> createState() => _SkeletonBoxState();
}

class _SkeletonBoxState extends State<_SkeletonBox>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    );

    _animation = Tween<double>(begin: 0, end: 1).animate(_controller);

    if (widget.animate) {
      _controller.repeat();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    if (!widget.animate) {
      return Container(
        width: widget.width,
        height: widget.height,
        decoration: BoxDecoration(
          borderRadius: widget.borderRadius,
          color: colorScheme.surfaceContainerHighest.addOpacity(0.5),
        ),
      );
    }

    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        return Container(
          width: widget.width,
          height: widget.height,
          decoration: BoxDecoration(
            borderRadius: widget.borderRadius,
            gradient: LinearGradient(
              begin: AlignmentDirectional.centerStart,
              end: AlignmentDirectional.centerEnd,
              colors: [
                colorScheme.surfaceContainerHighest.addOpacity(0.3),
                colorScheme.surfaceContainerHighest.addOpacity(0.6),
                colorScheme.surfaceContainerHighest.addOpacity(0.3),
              ],
              stops: [
                _clamp(_animation.value - 0.3),
                _animation.value,
                _clamp(_animation.value + 0.3),
              ],
            ),
          ),
        );
      },
    );
  }

  double _clamp(double value) {
    return value.clamp(0.0, 1.0);
  }
}
