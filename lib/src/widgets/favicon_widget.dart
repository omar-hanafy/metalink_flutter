import 'package:flutter/material.dart';

/// A widget that displays a website's favicon
class FaviconWidget extends StatelessWidget {
  /// Creates a [FaviconWidget] with the given URL and size.
  const FaviconWidget({
    required this.url,
    super.key,
    this.size = 16.0,
    this.backgroundColor,
    this.borderRadius,
    this.placeholderIcon,
    this.errorBuilder,
  });

  /// The URL of the favicon
  final String url;

  /// Size of the favicon (both width and height)
  final double size;

  /// Optional background color
  final Color? backgroundColor;

  /// Optional border radius
  final BorderRadius? borderRadius;

  /// Icon to display when loading or if no favicon is available
  final IconData? placeholderIcon;

  /// Builder for handling errors when loading the favicon
  final Widget Function(BuildContext, Object, StackTrace?)? errorBuilder;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size,
      height: size,
      child: ClipRRect(
        borderRadius: borderRadius ?? BorderRadius.circular(size / 4),
        child: Container(
          color: backgroundColor,
          child: Image.network(
            url,
            width: size,
            height: size,
            fit: BoxFit.cover,
            errorBuilder: errorBuilder ?? _defaultErrorBuilder,
            loadingBuilder: _loadingBuilder,
          ),
        ),
      ),
    );
  }

  Widget _defaultErrorBuilder(
      BuildContext context, Object error, StackTrace? stackTrace) {
    final colorScheme = Theme.of(context).colorScheme;
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: backgroundColor ?? colorScheme.primary.withValues(alpha: 0.1),
        borderRadius: borderRadius ?? BorderRadius.circular(size / 4),
      ),
      child: Icon(
        placeholderIcon ?? Icons.language,
        size: size * 0.6,
        color: colorScheme.primary.withValues(alpha: 0.6),
      ),
    );
  }

  Widget _loadingBuilder(
      BuildContext context, Widget child, ImageChunkEvent? loadingProgress) {
    if (loadingProgress == null) {
      return child;
    }

    final colorScheme = Theme.of(context).colorScheme;
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: backgroundColor ?? colorScheme.primary.withValues(alpha: 0.1),
        borderRadius: borderRadius ?? BorderRadius.circular(size / 4),
      ),
      child: Icon(
        placeholderIcon ?? Icons.language,
        size: size * 0.6,
        color: colorScheme.primary.withValues(alpha: 0.6),
      ),
    );
  }
}
