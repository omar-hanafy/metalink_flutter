import 'package:flutter/material.dart';
import 'package:flutter_helper_utils/flutter_helper_utils.dart';
import 'package:metalink_flutter/metalink_flutter.dart';
import 'package:url_launcher/url_launcher.dart';

/// A video-style link preview widget with play button overlay.
///
/// This widget displays a video thumbnail with a centered play button,
/// making it ideal for video platform links like YouTube, Vimeo, etc.
///
/// ### Example
/// ```dart
/// VideoPreview(
///   data: metadata,
///   onTap: (data) => print('Tapped: ${data.title}'),
/// )
/// ```
class VideoPreview extends StatelessWidget {
  /// Creates a [VideoPreview] with the given data.
  const VideoPreview({
    required this.data,
    super.key,
    this.titleMaxLines = 2,
    this.showImage = true,
    this.showFavicon = true,
    this.showPlayButton = true,
    this.onTap,
    this.handleNavigation = true,
    this.imageHeight,
    this.playButtonSize = 60.0,
    this.playIconSize = 36.0,
  });

  /// The metadata to display in the preview.
  final LinkMetadata data;

  /// Maximum number of lines for the title.
  final int titleMaxLines;

  /// Whether to show the thumbnail image.
  final bool showImage;

  /// Whether to show the favicon.
  final bool showFavicon;

  /// Whether to show the play button overlay.
  final bool showPlayButton;

  /// Callback when the preview is tapped.
  final LinkPreviewTapCallBack? onTap;

  /// Whether to handle navigation when tapped.
  final bool handleNavigation;

  /// Height of the thumbnail image.
  final double? imageHeight;

  /// Size of the play button container.
  final double playButtonSize;

  /// Size of the play icon inside the button.
  final double playIconSize;

  @override
  Widget build(BuildContext context) {
    final themeData = LinkPreviewTheme.of(context);
    final colorScheme = Theme.of(context).colorScheme;

    final borderRadius =
        themeData.borderRadius ?? BorderRadiusDirectional.circular(12.0);

    return Card(
      elevation: themeData.elevation ?? 0.0,
      shape: themeData.cardShape ??
          RoundedRectangleBorder(
            borderRadius: borderRadius,
            side: BorderSide(color: colorScheme.outline.withValues(alpha: 0.2)),
          ),
      clipBehavior: Clip.antiAlias,
      color: themeData.backgroundColor ?? colorScheme.surface,
      margin: EdgeInsets.zero,
      child: InkWell(
        onTap: () => onTap != null
            ? onTap?.call(data)
            : handleNavigation
                ? _launchUrl(data.originalUrl.toString())
                : null,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            if (showImage && data.hasImage)
              ClipRRect(
                borderRadius: BorderRadius.only(
                  topLeft: borderRadius.resolve(context.directionality).topLeft,
                  topRight:
                      borderRadius.resolve(context.directionality).topRight,
                ),
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    ImagePreview(
                      imageUrl: data.imageUrl!,
                      imageMetadata: data.imageMetadata,
                      height: imageHeight ?? themeData.imageHeight ?? 180.0,
                      width: double.infinity,
                      borderRadius: BorderRadius.zero,
                    ),
                    if (showPlayButton) _buildPlayButton(context, colorScheme),
                  ],
                ),
              ),
            Padding(
              padding: themeData.contentPadding ?? const EdgeInsets.all(12.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (data.title != null)
                    Text(
                      data.title!,
                      style: themeData.titleStyle ??
                          Theme.of(context).textTheme.titleMedium?.copyWith(
                                fontWeight: FontWeight.w600,
                              ),
                      maxLines: titleMaxLines,
                      overflow: TextOverflow.ellipsis,
                    ),
                  const SizedBox(height: 8.0),
                  Row(
                    children: [
                      if (showFavicon && data.hasFavicon)
                        FaviconWidget(
                          url: data.favicon!,
                          size: themeData.faviconSize ?? 16.0,
                          backgroundColor: colorScheme.surfaceContainerHighest,
                        )
                      else
                        Container(
                          width: themeData.faviconSize ?? 16.0,
                          height: themeData.faviconSize ?? 16.0,
                          decoration: BoxDecoration(
                            color: colorScheme.surfaceContainerHighest,
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            Icons.play_circle_outline,
                            size: (themeData.faviconSize ?? 16.0) * 0.75,
                            color: colorScheme.primary,
                          ),
                        ),
                      const SizedBox(width: 8.0),
                      Expanded(
                        child: Text(
                          data.siteName ?? data.hostname,
                          style: themeData.siteNameStyle ??
                              Theme.of(context).textTheme.bodySmall?.copyWith(
                                    color:
                                        colorScheme.onSurface.withValues(alpha: 0.6),
                                  ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPlayButton(BuildContext context, ColorScheme colorScheme) {
    return Container(
      width: playButtonSize,
      height: playButtonSize,
      decoration: BoxDecoration(
        color: colorScheme.surface.withValues(alpha: 0.85),
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.2),
            blurRadius: 8.0,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Icon(
        Icons.play_arrow,
        size: playIconSize,
        color: colorScheme.primary,
      ),
    );
  }

  Future<void> _launchUrl(String url) async {
    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    }
  }
}
