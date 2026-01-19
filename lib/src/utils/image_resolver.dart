import 'package:flutter/material.dart';
import 'package:metalink/metalink.dart';

/// A utility class for resolving image candidates from [ImageCandidate]
class ImageResolver {
  /// Returns an image URL based on the provided constraints.
  ///
  /// Note: resizing is not supported in metalink v2, so constraints are ignored.
  static String? optimizeImageUrl(
    ImageCandidate? metadata, {
    double? width,
    double? height,
    int? quality,
    BoxFit fit = BoxFit.cover,
  }) {
    if (metadata == null) {
      return null;
    }

    return metadata.url.toString();
  }

  /// Creates a set of responsive image URLs for different device sizes
  static List<ResponsiveImage> generateResponsiveImages(
    ImageCandidate metadata, {
    List<ResponsiveBreakpoint>? breakpoints,
  }) {
    // Resizing is not supported in v2, so return the original image
    return [
      ResponsiveImage(
        url: metadata.url.toString(),
        width: metadata.width,
        height: metadata.height,
        breakpoint: null,
      ),
    ];
  }

  /// Default responsive breakpoints
  static const List<ResponsiveBreakpoint> defaultBreakpoints = [
    ResponsiveBreakpoint(name: 'sm', width: 320),
    ResponsiveBreakpoint(name: 'md', width: 640),
    ResponsiveBreakpoint(name: 'lg', width: 1024),
    ResponsiveBreakpoint(name: 'xl', width: 1600),
  ];

  /// Gets the most appropriate image from a set of responsive images
  /// based on the available width
  static ResponsiveImage? getBestFitImage(
    List<ResponsiveImage> images,
    double availableWidth,
  ) {
    if (images.isEmpty) {
      return null;
    }

    // Sort images by width
    final sorted = List<ResponsiveImage>.from(images)
      ..sort((a, b) => (a.width ?? 0).compareTo(b.width ?? 0));

    // Find the first image that's larger than our available width
    for (final image in sorted) {
      if ((image.width ?? 0) >= availableWidth) {
        return image;
      }
    }

    // If all images are smaller than available width, return the largest
    return sorted.last;
  }
}

/// Represents a responsive breakpoint with optional dimensions
class ResponsiveBreakpoint {
  /// Creates a [ResponsiveBreakpoint] with the given parameters.
  const ResponsiveBreakpoint({
    required this.name,
    required this.width,
    this.height,
  });

  /// Name of this breakpoint (e.g., 'sm', 'md', 'lg')
  final String name;

  /// Width for this breakpoint
  final int width;

  /// Optional height for this breakpoint
  final int? height;
}

/// Represents a responsive image with its dimensions and source breakpoint
class ResponsiveImage {
  /// Creates a [ResponsiveImage] with the given parameters.
  const ResponsiveImage({
    required this.url,
    this.width,
    this.height,
    this.breakpoint,
  });

  /// URL of the image
  final String url;

  /// Width of the image in pixels
  final int? width;

  /// Height of the image in pixels
  final int? height;

  /// The breakpoint this image was generated for
  final ResponsiveBreakpoint? breakpoint;
}
