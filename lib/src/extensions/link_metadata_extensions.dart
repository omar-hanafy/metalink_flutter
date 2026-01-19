import 'package:flutter/material.dart';
import 'package:metalink/metalink.dart';
import 'package:url_launcher/url_launcher.dart';

/// Extensions on [LinkMetadata] for Flutter-specific functionality
extension LinkMetadataExtensions on LinkMetadata {
  /// Returns the first image candidate.
  ImageCandidate? get imageMetadata => images.isNotEmpty ? images.first : null;

  /// Returns the first image URL if available.
  String? get imageUrl => imageMetadata?.url.toString();

  /// Returns true if the metadata contains at least one image.
  bool get hasImage => images.isNotEmpty;

  /// Returns the first favicon URL if available.
  String? get favicon => icons.isNotEmpty ? icons.first.url.toString() : null;

  /// Returns true if the metadata contains at least one icon.
  bool get hasFavicon => icons.isNotEmpty;

  /// Returns the first video candidate.
  VideoCandidate? get videoMetadata => videos.isNotEmpty ? videos.first : null;

  /// Returns the first video URL if available.
  String? get videoUrl => videoMetadata?.url.toString();

  /// Returns true if the metadata contains at least one video.
  bool get hasVideo => videos.isNotEmpty;

  /// Returns the first audio candidate.
  AudioCandidate? get audioMetadata => audios.isNotEmpty ? audios.first : null;

  /// Returns the first audio URL if available.
  String? get audioUrl => audioMetadata?.url.toString();

  /// Returns true if the metadata contains at least one audio.
  bool get hasAudio => audios.isNotEmpty;

  /// Returns the hostname of the resolved URL.
  String get hostname => resolvedUrl.host;

  /// Returns a display-friendly version of the URL (the resolved URL).
  String get displayUrl => resolvedUrl.toString();

  /// Returns an optimized image URL based on constraints.
  ///
  /// In metalink v2, this simply returns the primary image URL as resizing logic
  /// is not provided by the core library.
  String? getOptimizedImageUrl({int? width, int? height}) {
    return imageUrl;
  }

  /// Creates an [Image] widget from the primary image URL in this metadata
  Image? toImageWidget({
    double? width,
    double? height,
    BoxFit fit = BoxFit.cover,
    Widget Function(BuildContext, Object, StackTrace?)? errorBuilder,
    Widget Function(BuildContext, Widget, ImageChunkEvent?)? loadingBuilder,
  }) {
    final url = getOptimizedImageUrl(
      width: width?.toInt(),
      height: height?.toInt(),
    );

    if (url == null) return null;

    return Image.network(
      url,
      width: width,
      height: height,
      fit: fit,
      errorBuilder: errorBuilder,
      loadingBuilder: loadingBuilder,
    );
  }
}

/// Extensions on [BuildContext] for easy access to link preview utilities
extension LinkPreviewContextExtensions on BuildContext {
  /// Launches a URL from this context, returning whether the URL was launched
  Future<bool> launchUrlFromContext(String url) async {
    final uri = Uri.parse(url);
    return await canLaunchUrl(uri) && await launchUrl(uri);
  }
}
