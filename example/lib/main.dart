import 'package:flutter/material.dart';
import 'package:flutter_helper_utils/flutter_helper_utils.dart';
import 'package:metalink_flutter/metalink_flutter.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MetalinkShowcaseApp());
}

class MetalinkShowcaseApp extends StatelessWidget {
  const MetalinkShowcaseApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'MetaLink Flutter Showcase',
      theme: _buildAppTheme(),
      home: const ShowcaseHome(),
      debugShowCheckedModeBanner: false,
    );
  }

  ThemeData _buildAppTheme() {
    final baseTheme = ThemeData(
      useMaterial3: true,
      colorScheme: ColorScheme.fromSeed(
        seedColor: Colors.indigo,
        brightness: Brightness.light,
      ),
    );

    // Add our link preview theme extension
    return baseTheme.copyWith(
      extensions: [
        LinkPreviewTheme(
          data: LinkPreviewThemeData(
            backgroundColor: baseTheme.colorScheme.surface,
            titleStyle: TextStyle(
              fontWeight: FontWeight.w600,
              color: baseTheme.colorScheme.onSurface,
            ),
            descriptionStyle: TextStyle(
              color: baseTheme.colorScheme.onSurface.withValues(alpha: 0.8),
            ),
            siteNameStyle: TextStyle(
              color: baseTheme.colorScheme.primary.withValues(alpha: 0.8),
              fontWeight: FontWeight.w500,
              fontSize: 12,
            ),
            borderRadius: BorderRadius.circular(16),
            elevation: 0,
            contentPadding: const EdgeInsets.all(16),
            cardShape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
              side: BorderSide(
                color: baseTheme.colorScheme.outline.withValues(alpha: 0.2),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class ShowcaseHome extends StatefulWidget {
  const ShowcaseHome({super.key});

  @override
  State<ShowcaseHome> createState() => _ShowcaseHomeState();
}

class _ShowcaseHomeState extends State<ShowcaseHome> {
  int _currentIndex = 0;

  final _pages = [
    const StylesShowcase(),
    const UrlInputShowcase(),
    const ThemeShowcase(),
    const ControllerShowcase(),
    const CustomPreviewShowcase(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('MetaLink Flutter Showcase'),
        elevation: 0,
        centerTitle: true,
      ),
      body: _pages[_currentIndex],
      bottomNavigationBar: NavigationBar(
        selectedIndex: _currentIndex,
        onDestinationSelected: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.style_outlined),
            selectedIcon: Icon(Icons.style),
            label: 'Styles',
          ),
          NavigationDestination(
            icon: Icon(Icons.link_outlined),
            selectedIcon: Icon(Icons.link),
            label: 'URL Input',
          ),
          NavigationDestination(
            icon: Icon(Icons.color_lens_outlined),
            selectedIcon: Icon(Icons.color_lens),
            label: 'Themes',
          ),
          NavigationDestination(
            icon: Icon(Icons.tune_outlined),
            selectedIcon: Icon(Icons.tune),
            label: 'Controller',
          ),
          NavigationDestination(
            icon: Icon(Icons.web_outlined),
            selectedIcon: Icon(Icons.web),
            label: 'Custom',
          ),
        ],
      ),
    );
  }
}

// First page - Different preview styles
class StylesShowcase extends StatelessWidget {
  const StylesShowcase({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        const Text(
          'Preview Styles',
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        Text(
          'MetaLink Flutter comes with three built-in styles for link previews.',
          style: Theme.of(context).textTheme.bodyLarge,
        ),
        const SizedBox(height: 24),

        // Card Style
        const Text(
          'Card Style',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
        ),
        const SizedBox(height: 8),
        LinkPreview.card(
          url: 'https://flutter.dev',
          titleMaxLines: 2,
          descriptionMaxLines: 3,
        ),
        const SizedBox(height: 24),

        // Compact Style
        const Text(
          'Compact Style',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
        ),
        const SizedBox(height: 8),
        LinkPreview.compact(
          url: 'https://pub.dev',
          titleMaxLines: 1,
          descriptionMaxLines: 1,
        ),
        const SizedBox(height: 24),

        // Large Style
        const Text(
          'Large Style',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
        ),
        const SizedBox(height: 8),
        LinkPreview.large(
          url: 'https://material.io',
          titleMaxLines: 2,
          descriptionMaxLines: 3,
        ),
        const SizedBox(height: 24),

        // Card Style without image
        const Text(
          'Card Style (No Image)',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
        ),
        const SizedBox(height: 8),
        LinkPreview.card(url: 'https://github.com', showImage: false),
        const SizedBox(height: 24),

        // Compact Style without favicon
        const Text(
          'Compact Style (No Favicon)',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
        ),
        const SizedBox(height: 8),
        LinkPreview.compact(
          url: 'https://developer.android.com',
          showFavicon: false,
        ),
      ],
    );
  }
}

// Second page - URL input and detection
class UrlInputShowcase extends StatefulWidget {
  const UrlInputShowcase({super.key});

  @override
  State<UrlInputShowcase> createState() => _UrlInputShowcaseState();
}

class _UrlInputShowcaseState extends State<UrlInputShowcase> {
  final _textController = TextEditingController();
  String? _detectedUrl;
  List<UrlMatch> _allUrls = [];

  @override
  void dispose() {
    _textController.dispose();
    super.dispose();
  }

  void _processText() {
    final text = _textController.text;
    setState(() {
      _detectedUrl = UrlDetector.extractFirstUrl(text);
      _allUrls = UrlDetector.detectUrls(text);
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = context.themeData;
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        Text('URL Detection', style: theme.headlineSmall),
        const SizedBox(height: 8),
        Text(
          'Type or paste text with URLs to automatically detect and preview them.',
          style: theme.bodySmall,
        ),
        const SizedBox(height: 16),
        TextField(
          controller: _textController,
          decoration: InputDecoration(
            hintText: 'Enter text with URLs...',
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
            suffixIcon: IconButton(
              icon: const Icon(Icons.search),
              onPressed: _processText,
            ),
          ),
          maxLines: 3,
          style: theme.bodySmall,
          onEditingComplete: _processText,
        ),
        TextButton.icon(
          icon: const Icon(Icons.content_paste),
          label: const Text('Paste example text'),
          onPressed: () {
            _textController.text =
                'Check out this Flutter site: https://flutter.dev and Material Design: https://material.io';
            _processText();
          },
        ),
        const Divider(),

        if (_detectedUrl != null) ...[
          const Text(
            'First Detected URL:',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 8),
          Text(_detectedUrl!),
          const SizedBox(height: 16),

          LinkPreview(
            url: _detectedUrl!,
            config: const LinkPreviewConfig(style: LinkPreviewStyle.card),
          ),
        ],

        if (_allUrls.isNotEmpty) ...[
          const SizedBox(height: 16),
          Text(
            'All Detected URLs ${_allUrls.length}:',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 8),
          Column(
            spacing: 16,
            children: [
              for (int index = 0; index < _allUrls.length; index++)
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'URL ${index + 1}: ${_allUrls[index].url}',
                      style: const TextStyle(fontWeight: FontWeight.w500),
                    ),
                    const SizedBox(height: 8),
                    LinkPreview.compact(url: _allUrls[index].url),
                  ],
                ),
            ],
          ),
        ],
      ],
    );
  }
}

// Third page - Theme customization
class ThemeShowcase extends StatefulWidget {
  const ThemeShowcase({super.key});

  @override
  State<ThemeShowcase> createState() => _ThemeShowcaseState();
}

class _ThemeShowcaseState extends State<ThemeShowcase> {
  Color _backgroundColor = Colors.white;
  Color _textColor = Colors.black;
  double _borderRadius = 16;
  double _elevation = 0;
  bool _showImage = true;
  bool _showFavicon = true;

  @override
  Widget build(BuildContext context) {
    // Create custom theme data
    final customThemeData = LinkPreviewThemeData(
      backgroundColor: _backgroundColor,
      titleStyle: TextStyle(fontWeight: FontWeight.w600, color: _textColor),
      descriptionStyle: TextStyle(color: _textColor.withValues(alpha: 0.7)),
      borderRadius: BorderRadius.circular(_borderRadius),
      elevation: _elevation,
      showImage: _showImage,
      showFavicon: _showFavicon,
    );

    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Theme Customization',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          Text(
            'Customize the appearance of link previews.',
            style: Theme.of(context).textTheme.bodyLarge,
          ),
          const SizedBox(height: 16),

          Expanded(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Controls
                Expanded(
                  flex: 1,
                  child: Card(
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: SingleChildScrollView(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Controls',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            const SizedBox(height: 16),

                            // Background color
                            const Text('Background Color'),
                            const SizedBox(height: 8),
                            Row(
                              children: [
                                for (final color in [
                                  Colors.white,
                                  Colors.grey.shade100,
                                  Colors.grey.shade900,
                                  Colors.blue.shade50,
                                  Colors.indigo.shade50,
                                ])
                                  Padding(
                                    padding: const EdgeInsetsDirectional.only(
                                      end: 8,
                                    ),
                                    child: InkWell(
                                      onTap: () {
                                        setState(() {
                                          _backgroundColor = color;
                                          if (color == Colors.grey.shade900) {
                                            _textColor = Colors.white;
                                          } else {
                                            _textColor = Colors.black;
                                          }
                                        });
                                      },
                                      child: Container(
                                        width: 24,
                                        height: 24,
                                        decoration: BoxDecoration(
                                          color: color,
                                          border: Border.all(
                                            color:
                                                _backgroundColor == color
                                                    ? Colors.blue
                                                    : Colors.grey,
                                            width:
                                                _backgroundColor == color
                                                    ? 2
                                                    : 1,
                                          ),
                                          borderRadius: BorderRadius.circular(
                                            4,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                              ],
                            ),
                            const SizedBox(height: 16),

                            // Border radius
                            const Text('Border Radius'),
                            Slider(
                              value: _borderRadius,
                              min: 0,
                              max: 32,
                              divisions: 8,
                              label: _borderRadius.round().toString(),
                              onChanged: (value) {
                                setState(() {
                                  _borderRadius = value;
                                });
                              },
                            ),
                            const SizedBox(height: 16),

                            // Elevation
                            const Text('Elevation'),
                            Slider(
                              value: _elevation,
                              min: 0,
                              max: 10,
                              divisions: 10,
                              label: _elevation.round().toString(),
                              onChanged: (value) {
                                setState(() {
                                  _elevation = value;
                                });
                              },
                            ),
                            const SizedBox(height: 16),

                            // Show image
                            Row(
                              children: [
                                Checkbox(
                                  value: _showImage,
                                  onChanged: (value) {
                                    setState(() {
                                      _showImage = value ?? true;
                                    });
                                  },
                                ),
                                const Text('Show Image'),
                              ],
                            ),

                            // Show favicon
                            Row(
                              children: [
                                Checkbox(
                                  value: _showFavicon,
                                  onChanged: (value) {
                                    setState(() {
                                      _showFavicon = value ?? true;
                                    });
                                  },
                                ),
                                const Text('Show Favicon'),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),

                const SizedBox(width: 16),

                // Preview
                Expanded(
                  flex: 2,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Preview',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 16),

                      // Link preview with custom theme
                      Builder(
                        builder: (context) {
                          // Apply the custom theme to this subtree
                          return Theme(
                            data: Theme.of(context).copyWith(
                              extensions: [
                                LinkPreviewTheme(data: customThemeData),
                              ],
                            ),
                            child: Column(
                              children: [
                                LinkPreview.card(
                                  url: 'https://flutter.dev',
                                  titleMaxLines: 2,
                                  descriptionMaxLines: 3,
                                ),
                                const SizedBox(height: 16),
                                LinkPreview.compact(
                                  url: 'https://material.io',
                                  titleMaxLines: 1,
                                  descriptionMaxLines: 2,
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// Fourth page - Controller and advanced management
class ControllerShowcase extends StatefulWidget {
  const ControllerShowcase({super.key});

  @override
  State<ControllerShowcase> createState() => _ControllerShowcaseState();
}

class _ControllerShowcaseState extends State<ControllerShowcase> {
  final _urlController = TextEditingController();
  final _previewController = LinkPreviewController();
  bool _isLoading = false;
  Object? _error;

  @override
  void initState() {
    super.initState();
    _previewController.addListener(_onControllerUpdate);
  }

  @override
  void dispose() {
    _urlController.dispose();
    _previewController.removeListener(_onControllerUpdate);
    _previewController.dispose();
    super.dispose();
  }

  void _onControllerUpdate() {
    setState(() {
      _isLoading = _previewController.isLoading;
      _error = _previewController.error;
    });
  }

  void _loadPreview() {
    final url = _urlController.text.trim();
    if (url.isNotEmpty) {
      _previewController.setUrl(url);
    }
  }

  void _refreshPreview() {
    _previewController.fetchData(forceRefresh: true);
  }

  void _clearPreview() {
    _previewController.clear();
    _urlController.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Controller Usage',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          Text(
            'Use a controller to manage link preview state and actions.',
            style: Theme.of(context).textTheme.bodyLarge,
          ),
          const SizedBox(height: 16),

          // URL input with validation
          TextField(
            controller: _urlController,
            decoration: InputDecoration(
              labelText: 'Enter URL',
              hintText: 'https://example.com',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              suffixIcon: IconButton(
                icon: const Icon(Icons.search),
                onPressed: _loadPreview,
              ),
            ),
            onEditingComplete: _loadPreview,
          ),
          const SizedBox(height: 8),

          // Action buttons
          Row(
            children: [
              ElevatedButton.icon(
                icon: const Icon(Icons.refresh),
                label: const Text('Load Preview'),
                onPressed: _loadPreview,
              ),
              const SizedBox(width: 6),
              TextButton.icon(
                icon: const Icon(Icons.refresh),
                label: const Text('Refresh'),
                onPressed: _refreshPreview,
              ),
              const SizedBox(width: 6),
              TextButton.icon(
                icon: const Icon(Icons.clear),
                label: const Text('Clear'),
                onPressed: _clearPreview,
              ),
            ],
          ),
          const SizedBox(height: 16),

          // Status display
          Container(
            padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.surfaceContainerHighest,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              children: [
                Text(
                  'Status:',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
                ),
                const SizedBox(width: 8),
                if (_isLoading)
                  Row(
                    children: [
                      const SizedBox(
                        width: 16,
                        height: 16,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        'Loading...',
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.onSurfaceVariant,
                        ),
                      ),
                    ],
                  )
                else if (_error != null)
                  Text(
                    'Error: $_error',
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.error,
                    ),
                  )
                else if (_previewController.hasData)
                  Text(
                    'Preview loaded',
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.primary,
                    ),
                  )
                else
                  Text(
                    'No preview loaded',
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                    ),
                  ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          const Divider(),

          // Link preview with the controller
          Expanded(child: Center(child: _buildPreviewOrMessage())),
        ],
      ),
    );
  }

  Widget _buildPreviewOrMessage() {
    if (_isLoading) {
      return const Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          LinkPreviewSkeleton(style: LinkPreviewStyle.card, animate: true),
          SizedBox(height: 16),
          Text('Loading preview...'),
        ],
      );
    } else if (_error != null) {
      return Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.error_outline,
            size: 64,
            color: Theme.of(context).colorScheme.error,
          ),
          const SizedBox(height: 16),
          Text(
            'Failed to load preview',
            style: Theme.of(context).textTheme.titleMedium,
          ),
          const SizedBox(height: 8),
          Text(
            _error.toString(),
            style: TextStyle(color: Theme.of(context).colorScheme.error),
            textAlign: TextAlign.center,
          ),
        ],
      );
    } else if (!_previewController.hasData) {
      return Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.link_outlined,
            size: 64,
            color: Theme.of(
              context,
            ).colorScheme.onSurfaceVariant.withValues(alpha: 0.5),
          ),
          const SizedBox(height: 16),
          Text(
            'Enter a URL to see the preview',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              color: Theme.of(
                context,
              ).colorScheme.onSurfaceVariant.withValues(alpha: 0.7),
            ),
          ),
          const SizedBox(height: 24),
          OutlinedButton.icon(
            icon: const Icon(Icons.add_link),
            label: const Text('Try Example URLs'),
            onPressed: () {
              _showExampleUrlsMenu();
            },
          ),
        ],
      );
    } else {
      return LinkPreview(
        url: '', // URL is controlled by the controller
        controller: _previewController,
        config: const LinkPreviewConfig(
          style: LinkPreviewStyle.card,
          titleMaxLines: 2,
          descriptionMaxLines: 3,
        ),
      );
    }
  }

  void _showExampleUrlsMenu() {
    final exampleUrls = [
      'https://flutter.dev',
      'https://material.io',
      'https://pub.dev',
      'https://github.com',
      'https://medium.com',
    ];

    showModalBottomSheet(
      context: context,
      builder: (context) {
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: const EdgeInsets.all(16),
              child: Text(
                'Example URLs',
                style: Theme.of(context).textTheme.titleMedium,
              ),
            ),
            const Divider(height: 1),
            ListView.separated(
              shrinkWrap: true,
              itemCount: exampleUrls.length,
              separatorBuilder: (context, index) => const Divider(height: 1),
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(exampleUrls[index]),
                  onTap: () {
                    Navigator.of(context).pop();
                    _urlController.text = exampleUrls[index];
                    _loadPreview();
                  },
                );
              },
            ),
          ],
        );
      },
    );
  }
}

// Fifth page - Custom preview and advanced usage
class CustomPreviewShowcase extends StatefulWidget {
  const CustomPreviewShowcase({super.key});

  @override
  State<CustomPreviewShowcase> createState() => _CustomPreviewShowcaseState();
}

class _CustomPreviewShowcaseState extends State<CustomPreviewShowcase> {
  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        const Text(
          'Custom Previews',
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        Text(
          'Create custom link preview designs with the builder pattern.',
          style: Theme.of(context).textTheme.bodyLarge,
        ),
        const SizedBox(height: 24),

        // Social media style
        const Text(
          'Social Media Style',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
        ),
        const SizedBox(height: 8),
        LinkPreview.custom(
          url: 'https://twitter.com',
          builder: (context, data) => _buildSocialMediaPreview(context, data),
        ),
        const SizedBox(height: 24),

        // Video style
        const Text(
          'Video Preview Style',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
        ),
        const SizedBox(height: 8),
        LinkPreview.custom(
          url: 'https://youtube.com',
          builder: (context, data) => _buildVideoPreview(context, data),
        ),
        const SizedBox(height: 24),

        // News article style
        const Text(
          'News Article Style',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
        ),
        const SizedBox(height: 8),
        LinkPreview.custom(
          url: 'https://news.google.com',
          builder: (context, data) => _buildNewsArticle(context, data),
        ),
        const SizedBox(height: 24),

        // Product style
        const Text(
          'Product Card Style',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
        ),
        const SizedBox(height: 8),
        LinkPreview.custom(
          url: 'https://store.google.com',
          builder: (context, data) => _buildProductCard(context, data),
        ),
      ],
    );
  }

  Widget _buildSocialMediaPreview(BuildContext context, LinkMetadata data) {
    final colorScheme = Theme.of(context).colorScheme;

    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: colorScheme.outline.withValues(alpha: 0.2)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(12),
            child: Row(
              children: [
                if (data.hasFavicon)
                  ClipOval(
                    child: SizedBox(
                      width: 40,
                      height: 40,
                      child: FaviconWidget(
                        url: data.favicon!,
                        size: 40,
                        backgroundColor: colorScheme.primaryContainer,
                      ),
                    ),
                  )
                else
                  CircleAvatar(
                    radius: 20,
                    backgroundColor: colorScheme.primaryContainer,
                    child: Icon(Icons.person, color: colorScheme.primary),
                  ),
                const SizedBox(width: 12),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      data.siteName ?? data.hostname,
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    Text(
                      '@${data.hostname.split('.').first}',
                      style: TextStyle(
                        color: colorScheme.onSurface.withValues(alpha: 0.6),
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          if (data.description != null)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: Text(
                data.description!,
                style: TextStyle(fontSize: 15, color: colorScheme.onSurface),
              ),
            ),
          if (data.hasImage)
            Padding(
              padding: const EdgeInsets.all(12),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: ImagePreview(
                  imageUrl: data.imageUrl!,
                  imageMetadata: data.imageMetadata,
                  height: 200,
                  width: double.infinity,
                ),
              ),
            ),
          Padding(
            padding: const EdgeInsets.fromLTRB(12, 0, 12, 12),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  data.displayUrl,
                  style: TextStyle(color: colorScheme.primary, fontSize: 12),
                ),
                Row(
                  children: [
                    IconButton(
                      icon: Icon(
                        Icons.favorite_border,
                        size: 18,
                        color: colorScheme.primary,
                      ),
                      onPressed: () {},
                    ),
                    IconButton(
                      icon: Icon(
                        Icons.share_outlined,
                        size: 18,
                        color: colorScheme.primary,
                      ),
                      onPressed: () {},
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

  Widget _buildProductCard(BuildContext context, LinkMetadata data) {
    final colorScheme = Theme.of(context).colorScheme;

    return Container(
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (data.hasImage)
            ClipRRect(
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(16),
              ),
              child: Stack(
                children: [
                  ImagePreview(
                    imageUrl: data.imageUrl!,
                    imageMetadata: data.imageMetadata,
                    height: 200,
                    width: double.infinity,
                  ),
                  Positioned(
                    top: 12,
                    right: 12,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: colorScheme.primary,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        'NEW',
                        style: TextStyle(
                          color: colorScheme.onPrimary,
                          fontWeight: FontWeight.bold,
                          fontSize: 12,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    if (data.hasFavicon)
                      FaviconWidget(url: data.favicon!, size: 16),
                    if (data.hasFavicon) const SizedBox(width: 8),
                    Text(
                      data.siteName ?? data.hostname,
                      style: TextStyle(
                        color: colorScheme.primary,
                        fontWeight: FontWeight.w500,
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                if (data.title != null)
                  Text(
                    data.title!,
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: colorScheme.onSurface,
                    ),
                  ),
                const SizedBox(height: 8),
                if (data.description != null)
                  Text(
                    data.description!,
                    style: TextStyle(
                      fontSize: 14,
                      color: colorScheme.onSurface.withValues(alpha: 0.7),
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      '\$129.99',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: colorScheme.primary,
                      ),
                    ),
                    ElevatedButton.icon(
                      onPressed: () {},
                      icon: const Icon(Icons.shopping_cart),
                      label: const Text('Buy Now'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: colorScheme.primary,
                        foregroundColor: colorScheme.onPrimary,
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
  }

  Widget _buildNewsArticle(BuildContext context, LinkMetadata data) {
    final colorScheme = Theme.of(context).colorScheme;

    return Container(
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: colorScheme.outline.withValues(alpha: 0.2)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (data.hasImage)
            ClipRRect(
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(8),
              ),
              child: ImagePreview(
                imageUrl: data.imageUrl!,
                imageMetadata: data.imageMetadata,
                height: 180,
                width: double.infinity,
              ),
            ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: colorScheme.primaryContainer,
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text(
                        'BREAKING NEWS',
                        style: TextStyle(
                          color: colorScheme.onPrimaryContainer,
                          fontWeight: FontWeight.bold,
                          fontSize: 10,
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      '• 2 hours ago',
                      style: TextStyle(
                        color: colorScheme.onSurface.withValues(alpha: 0.6),
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                if (data.title != null)
                  Text(
                    data.title!,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                const SizedBox(height: 8),
                if (data.description != null)
                  Text(
                    data.description!,
                    style: TextStyle(
                      fontSize: 14,
                      color: colorScheme.onSurface.withValues(alpha: 0.8),
                    ),
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                  ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    if (data.hasFavicon)
                      CircleAvatar(
                        radius: 12,
                        backgroundColor: colorScheme.surfaceContainerHighest,
                        child: ClipOval(
                          child: FaviconWidget(url: data.favicon!, size: 16),
                        ),
                      )
                    else
                      CircleAvatar(
                        radius: 12,
                        backgroundColor: colorScheme.surfaceContainerHighest,
                        child: Icon(
                          Icons.newspaper,
                          size: 12,
                          color: colorScheme.primary,
                        ),
                      ),
                    const SizedBox(width: 8),
                    Text(
                      data.siteName ?? data.hostname,
                      style: TextStyle(
                        fontWeight: FontWeight.w500,
                        color: colorScheme.onSurface,
                      ),
                    ),
                    const Spacer(),
                    TextButton(
                      onPressed: () {},
                      child: const Text('Read More'),
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

  Widget _buildVideoPreview(BuildContext context, LinkMetadata data) {
    final colorScheme = Theme.of(context).colorScheme;

    return Container(
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: colorScheme.outline.withValues(alpha: 0.2)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (data.hasImage)
            ClipRRect(
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(12),
              ),
              child: Stack(
                alignment: AlignmentDirectional.center,
                children: [
                  ImagePreview(
                    imageUrl: data.imageUrl!,
                    imageMetadata: data.imageMetadata,
                    height: 200,
                    fit: BoxFit.cover,
                    width: double.infinity,
                  ),
                  Container(
                    width: 60,
                    height: 60,
                    decoration: BoxDecoration(
                      color: colorScheme.surface.withValues(alpha: 0.8),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      Icons.play_arrow,
                      size: 36,
                      color: colorScheme.primary,
                    ),
                  ),
                  Positioned(
                    bottom: 8,
                    right: 8,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.black.withValues(alpha: 0.7),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: const Text(
                        '3:24',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 12,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (data.title != null)
                  Text(
                    data.title!,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    if (data.hasFavicon)
                      CircleAvatar(
                        radius: 12,
                        backgroundColor: colorScheme.surfaceContainerHighest,
                        child: ClipOval(
                          child: FaviconWidget(url: data.favicon!, size: 16),
                        ),
                      )
                    else
                      CircleAvatar(
                        radius: 12,
                        backgroundColor: colorScheme.surfaceContainerHighest,
                        child: Icon(
                          Icons.ondemand_video,
                          size: 12,
                          color: colorScheme.primary,
                        ),
                      ),
                    const SizedBox(width: 8),
                    Text(
                      data.siteName ?? data.hostname,
                      style: TextStyle(
                        fontSize: 14,
                        color: colorScheme.onSurface.withValues(alpha: 0.8),
                      ),
                    ),
                    const Spacer(),
                    Row(
                      children: [
                        Icon(
                          Icons.visibility,
                          size: 16,
                          color: colorScheme.onSurface.withValues(alpha: 0.6),
                        ),
                        const SizedBox(width: 4),
                        Text(
                          '5.2K views',
                          style: TextStyle(
                            fontSize: 12,
                            color: colorScheme.onSurface.withValues(alpha: 0.6),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    IconButton.outlined(
                      icon: const Icon(Icons.thumb_up_outlined, size: 18),
                      onPressed: () {},
                    ),
                    const SizedBox(width: 8),
                    IconButton.outlined(
                      icon: const Icon(Icons.share_outlined, size: 18),
                      onPressed: () {},
                    ),
                    const SizedBox(width: 8),
                    IconButton.outlined(
                      icon: const Icon(Icons.bookmark_outline, size: 18),
                      onPressed: () {},
                    ),
                    const Spacer(),
                    ElevatedButton.icon(
                      icon: const Icon(Icons.play_arrow),
                      label: const Text('Watch'),
                      onPressed: () {},
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
