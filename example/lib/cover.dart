import 'package:flutter/material.dart';
import 'package:flutter_helper_utils/flutter_helper_utils.dart';
import 'package:metalink_flutter/metalink_flutter.dart';

/// The entry point for the MetaLink showcase application.
///
/// This function:
/// 1. Initializes the Flutter binding.
/// 2. Clears the [MetadataProvider] cache to ensure fresh data fetching for demonstration purposes.
/// 3. Launches the [LinkPreviewShowcase] widget.
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // Clear cache to demonstrate fresh fetching behavior on every run.
  await MetadataProvider.clearStorageCache();
  runApp(
    const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: LinkPreviewShowcase(),
    ),
  );
}

/// A gallery widget demonstrating the various rendering styles of [LinkPreview].
///
/// This widget renders a horizontally scrolling list containing:
/// *   [LinkPreview.card] - The default card layout.
/// *   [LinkPreview.compact] - A smaller, row-based layout.
/// *   [LinkPreview.large] - A prominent layout with large media.
/// *   [LinkPreview.custom] - Fully custom layouts using the builder pattern.
///
/// Use this to visually verify how [LinkMetadata] is parsed and displayed across different styles.
class LinkPreviewShowcase extends StatelessWidget {
  /// Creates a [LinkPreviewShowcase] demonstration widget.
  const LinkPreviewShowcase({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = context.themeData;

    return Scaffold(
      appBar: AppBar(title: const Text('MetaLink Flutter'), centerTitle: true),
      body: Center(
        child: ListView(
          scrollDirection: Axis.horizontal,
          padding: const EdgeInsetsDirectional.all(16),
          children: [
            _buildPreviewSection(
              url: 'https://pub.dev',
              context,
              'Card Style',
              // Standard card layout for general usage.
              LinkPreview.card(url: 'https://pub.dev', handleNavigation: false),
            ),
            const SizedBox(width: 24),
            _buildPreviewSection(
              context,
              url: 'https://pub.dev',
              'Compact Style',
              // Compact layout suitable for lists or dense UIs.
              LinkPreview.compact(
                url: 'https://pub.dev',
                handleNavigation: false,
              ),
            ),
            const SizedBox(width: 24),
            _buildPreviewSection(
              context,
              url: 'https://github.com',
              'Large Style',
              // Large layout emphasizing the open-graph image.
              LinkPreview.large(
                url: 'https://github.com',
                handleNavigation: false,
              ),
            ),
            const SizedBox(width: 24),
            _buildPreviewSection(
              context,
              url: 'https://developer.apple.com',
              'Image Only',
              // Demonstrating a custom builder that only shows the image.
              LinkPreview.custom(
                url: 'https://developer.apple.com',
                builder: (context, data) {
                  final imageUrl = data.imageMetadata?.url.toString();
                  if (imageUrl == null) {
                    return SizedBox.square(
                      dimension: 50,
                      child: CircularProgressIndicator(),
                    );
                  }
                  return Image.network(imageUrl);
                },
              ),
            ),
            const SizedBox(width: 24),
            _buildPreviewSection(
              context,
              url: 'https://developer.android.com',
              'Custom Style',
              // A complex custom layout implementing a completely bespoke design system.
              LinkPreview.custom(
                url: 'https://developer.android.com',

                builder: (BuildContext context, LinkMetadata data) {
                  return Container(
                    decoration: BoxDecoration(
                      color: theme.surfaceContainerHighest,
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.1),
                          blurRadius: 8,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    clipBehavior: Clip.antiAlias,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        if (data.imageUrl != null)
                          Image.network(
                            data.imageUrl!,
                            height: 140,
                            width: double.infinity,
                            fit: BoxFit.cover,
                            errorBuilder:
                                (context, error, stackTrace) => Container(
                                  height: 140,
                                  color: theme.primaryContainer,
                                  child: Center(
                                    child: Icon(
                                      Icons.image,
                                      size: 48,
                                      color: theme.onPrimaryContainer,
                                    ),
                                  ),
                                ),
                          ),
                        Padding(
                          padding: const EdgeInsetsDirectional.all(12),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                data.title ?? 'No Title',
                                style: theme.titleMedium?.copyWith(
                                  fontWeight: FontWeight.bold,
                                ),
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                              const SizedBox(height: 4),
                              if (data.siteName != null) ...[
                                Text(
                                  data.siteName!,
                                  style: theme.bodySmall?.copyWith(
                                    color: theme.primary,
                                  ),
                                ),
                                const SizedBox(height: 4),
                              ],
                              Row(
                                children: [
                                  if (data.favicon != null)
                                    Padding(
                                      padding: const EdgeInsetsDirectional.only(
                                        end: 4,
                                      ),
                                      child: Image.network(
                                        data.favicon!,
                                        width: 16,
                                        height: 16,
                                        errorBuilder:
                                            (context, error, stackTrace) =>
                                                Icon(
                                                  Icons.link,
                                                  size: 16,
                                                  color: theme.primary,
                                                ),
                                      ),
                                    ),
                                  Expanded(
                                    child: Text(
                                      data.displayUrl.replaceAll(
                                        'https://',
                                        '',
                                      ),
                                      style: theme.bodySmall?.copyWith(
                                        color: theme.outline,
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
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Encapsulates the layout logic for a single preview section.
  //
  // We use a fixed width constraint to ensure all examples align neatly in the horizontal list,
  // making visual comparison easier.
  Widget _buildPreviewSection(
    BuildContext context,
    String title,
    Widget preview, {
    required String url,
  }) {
    final theme = context.themeData;

    return SizedBox(
      width: 400,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Display the raw URL for reference.
          Text(url),
          Padding(
            padding: const EdgeInsetsDirectional.only(
              start: 4,
              bottom: 8,
              top: 4,
            ),
            child: Text(
              title,
              style: theme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
            ),
          ),
          preview,
        ],
      ),
    );
  }
}
