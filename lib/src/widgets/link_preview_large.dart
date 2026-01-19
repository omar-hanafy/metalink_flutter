import 'package:flutter/material.dart';
import 'package:flutter_helper_utils/flutter_helper_utils.dart';
import 'package:metalink_flutter/metalink_flutter.dart';
import 'package:url_launcher/url_launcher.dart';

/// A large link preview widget with prominent image and detailed content
class LinkPreviewLarge extends StatelessWidget {
  /// Creates a [LinkPreviewLarge] with the given data.
  const LinkPreviewLarge({
    required this.data,
    super.key,
    this.titleMaxLines = 2,
    this.descriptionMaxLines = 4,
    this.showImage = true,
    this.showFavicon = true,
    this.onTap,
    this.handleNavigation = true,
  });

  /// The data to display in the preview
  final LinkMetadata data;

  /// Maximum number of lines for the title
  final int titleMaxLines;

  /// Maximum number of lines for the description
  final int descriptionMaxLines;

  /// Whether to show the image
  final bool showImage;

  /// Whether to show the favicon
  final bool showFavicon;

  /// Callback when the preview is tapped
  final LinkPreviewTapCallBack? onTap;

  /// Whether to handle navigation when tapped
  final bool handleNavigation;

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
            if (showImage && data.imageUrl != null)
              ImagePreview(
                imageUrl: data.imageUrl!,
                imageMetadata: data.imageMetadata,
                height: themeData.imageHeight != null
                    ? themeData.imageHeight! * 1.5
                    : 200.0,
                width: double.infinity,
                borderRadius: BorderRadius.only(
                  topLeft: borderRadius.resolve(context.directionality).topLeft,
                  topRight:
                      borderRadius.resolve(context.directionality).topRight,
                ),
              ),
            Padding(
              padding: themeData.contentPadding ?? const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Site name and favicon
                  if (data.siteName != null || data.hasFavicon)
                    Row(
                      children: [
                        if (showFavicon && data.hasFavicon)
                          FaviconWidget(
                            url: data.favicon!,
                            size: themeData.faviconSize ?? 16.0,
                            backgroundColor:
                                colorScheme.surfaceContainerHighest,
                          ),
                        if (showFavicon && data.hasFavicon)
                          const SizedBox(width: 8.0),
                        Expanded(
                          child: Text(
                            data.siteName ?? data.hostname,
                            style: themeData.siteNameStyle ??
                                Theme.of(context).textTheme.bodySmall?.copyWith(
                                      color: colorScheme.onSurface
                                          .withValues(alpha: 0.6),
                                      fontWeight: FontWeight.w500,
                                    ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),

                  if (data.siteName != null || data.hasFavicon)
                    const SizedBox(height: 12.0),

                  // Title
                  if (data.title != null)
                    Text(
                      data.title!,
                      style: themeData.titleStyle ??
                          Theme.of(context).textTheme.titleLarge?.copyWith(
                                fontWeight: FontWeight.w600,
                              ),
                      maxLines: titleMaxLines,
                      overflow: TextOverflow.ellipsis,
                    ),

                  if (data.title != null && data.description != null)
                    const SizedBox(height: 12.0),

                  // Description
                  if (data.description != null)
                    Text(
                      data.description!,
                      style: themeData.descriptionStyle ??
                          Theme.of(context).textTheme.bodyMedium?.copyWith(
                                color: colorScheme.onSurface
                                    .withValues(alpha: 0.7),
                              ),
                      maxLines: descriptionMaxLines,
                      overflow: TextOverflow.ellipsis,
                    ),

                  const SizedBox(height: 16.0),

                  // URL display
                  Text(
                    data.displayUrl,
                    style: themeData.urlStyle ??
                        Theme.of(context).textTheme.bodySmall?.copyWith(
                              color: colorScheme.primary,
                            ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
          ],
        ),
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
