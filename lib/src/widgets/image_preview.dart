import 'package:flutter/material.dart';
import 'package:metalink/metalink.dart';

import 'package:metalink_flutter/src/themes/link_preview_theme.dart';

/// A widget that displays a preview image from a URL
class ImagePreview extends StatelessWidget {
  /// Creates an [ImagePreview] with the given URL and metadata.
  const ImagePreview({
    required this.imageUrl,
    super.key,
    this.imageMetadata,
    this.width,
    this.height,
    this.borderRadius,
    this.fit = BoxFit.cover,
    this.placeholderColor,
    this.loadingBuilder,
    this.errorBuilder,
  });

  /// The URL of the image to display
  final String imageUrl;

  /// Optional metadata for the image
  final ImageCandidate? imageMetadata;

  /// Width of the image
  final double? width;

  /// Height of the image
  final double? height;

  /// Border radius for the image
  final BorderRadiusGeometry? borderRadius;

  /// How the image should be inscribed into the box
  final BoxFit fit;

  /// Color to use for the placeholder
  final Color? placeholderColor;

  /// Builder for customizing the loading state
  final Widget Function(BuildContext, Widget, ImageChunkEvent?)? loadingBuilder;

  /// Builder for handling errors
  final Widget Function(BuildContext, Object, StackTrace?)? errorBuilder;

  @override
  Widget build(BuildContext context) {
    final linkPreviewTheme = LinkPreviewTheme.of(context);
    final effectiveBorderRadius = borderRadius ??
        linkPreviewTheme.imageBorderRadius ??
        BorderRadius.circular(8.0);
    final effectiveLoadingBuilder = loadingBuilder ??
        linkPreviewTheme.defaultImageLoadingBuilder ??
        _defaultLoadingBuilder;
    final effectiveErrorBuilder = errorBuilder ??
        linkPreviewTheme.defaultImageErrorBuilder ??
        _defaultErrorBuilder;

    return ClipRRect(
      borderRadius: effectiveBorderRadius,
      child: Image.network(
        imageUrl,
        width: width,
        height: height,
        fit: fit,
        loadingBuilder: effectiveLoadingBuilder,
        errorBuilder: effectiveErrorBuilder,
      ),
    );
  }

  Widget _defaultLoadingBuilder(
      BuildContext context, Widget child, ImageChunkEvent? loadingProgress) {
    if (loadingProgress == null) {
      return child;
    }

    final linkPreviewTheme = LinkPreviewTheme.of(context);
    final effectivePlaceholderColor = placeholderColor ??
        linkPreviewTheme.imagePlaceholderColor ??
        Theme.of(context).colorScheme.surfaceContainerHighest;

    return Container(
      width: width,
      height: height,
      color: effectivePlaceholderColor,
      child: Center(
        child: loadingProgress.expectedTotalBytes != null
            ? CircularProgressIndicator(
                value: loadingProgress.cumulativeBytesLoaded /
                    (loadingProgress.expectedTotalBytes ?? 1),
              )
            : const CircularProgressIndicator(),
      ),
    );
  }

  Widget _defaultErrorBuilder(
      BuildContext context, Object error, StackTrace? stackTrace) {
    final linkPreviewTheme = LinkPreviewTheme.of(context);
    final effectivePlaceholderColor = placeholderColor ??
        linkPreviewTheme.imagePlaceholderColor ??
        Theme.of(context).colorScheme.surfaceContainerHighest;

    return Container(
      width: width,
      height: height,
      color: effectivePlaceholderColor,
      child: const Center(
        child: Icon(Icons.broken_image_outlined),
      ),
    );
  }
}
