<h1 align="center">MetaLink Flutter</h1>

<p align="center">
  <a href="https://pub.dev/packages/metalink_flutter"><img src="https://img.shields.io/pub/v/metalink_flutter.svg" alt="Pub"></a>
  <a href="https://github.com/omar-hanafy/metalink_flutter/stargazers"><img src="https://img.shields.io/github/stars/omar-hanafy/metalink_flutter" alt="Stars"></a>
  <a href="https://github.com/omar-hanafy/metalink_flutter/blob/main/LICENSE"><img src="https://img.shields.io/github/license/omar-hanafy/metalink_flutter" alt="License"></a>
  <a href="https://flutter.dev"><img src="https://img.shields.io/badge/Platform-Flutter-02569B?logo=flutter" alt="Platform"></a>
</p>

<p align="center">
  A Flutter package for beautiful, highly customizable link preview widgets, built on top of the <a href="https://pub.dev/packages/metalink">MetaLink</a> package.
</p>

<p align="center">
  <img src="https://raw.githubusercontent.com/omar-hanafy/metalink_flutter/refs/heads/main/screenshots/cover.png" width="100%" alt="Cover">
</p>

## ✨ Features

- 🔗 **Rich link previews** with images, favicon, title, and description
- 🎨 **Multiple styles**: Card, Compact, Large, and custom
- 🎭 **Fully themeable** with Material 3 integration
- 🖼️ **Image candidate helpers** for selection and display
- 💾 **Built-in caching** for faster loading
- 👆 **Tap handling** with URL launching or custom callbacks
- 🚧 **Loading skeleton placeholders** with shimmer effects
- 🧩 **Highly customizable components**
- 📱 **RTL support** using Flutter's logical directional properties

## 📸 Screenshots

<p align="center">
  <img src="https://raw.githubusercontent.com/omar-hanafy/metalink_flutter/refs/heads/main/screenshots/1.png" width="40%" alt="Card Style">
  <img src="https://raw.githubusercontent.com/omar-hanafy/metalink_flutter/refs/heads/main/screenshots/2.png" width="40%" alt="Compact Style">
  <img src="https://raw.githubusercontent.com/omar-hanafy/metalink_flutter/refs/heads/main/screenshots/3.png" width="40%" alt="Large Style">
  <img src="https://raw.githubusercontent.com/omar-hanafy/metalink_flutter/refs/heads/main/screenshots/4.png" width="40%" alt="Large Style">
</p>


## 🚀 Getting Started

### Installation

Add the package to your pubspec.yaml:

```yaml
dependencies:
  metalink_flutter: ^<LATEST VERSION>
```

Run the installation command:

```bash
flutter pub get
```

### Basic Usage

Import the package:

```dart
import 'package:metalink_flutter/metalink_flutter.dart';
```

Add a simple link preview widget:

```dart
LinkPreview(
  url: 'https://flutter.dev',
)
```

That's it! The widget will automatically fetch metadata and display a card-style preview of the link.

## 🎨 Link Preview Styles

MetaLink Flutter comes with three built-in styles and the ability to create custom styles.

### Card Style (Default)

Displays a card with the link's image on top, and title, description, and site information below.

```dart
LinkPreview.card(
  url: 'https://flutter.dev',
  titleMaxLines: 2,
  descriptionMaxLines: 3,
)
```

### Compact Style

A horizontal layout suitable for inline previews in chat interfaces or lists.

```dart
LinkPreview.compact(
  url: 'https://flutter.dev',
  titleMaxLines: 1,
  descriptionMaxLines: 1,
)
```

### Large Style

A prominent display with a large image and detailed content, suitable for featured links.

```dart
LinkPreview.large(
  url: 'https://flutter.dev',
  titleMaxLines: 2,
  descriptionMaxLines: 4,
)
```

### Custom Style

Create your own unique link preview style:

```dart
LinkPreview.custom(
  url: 'https://flutter.dev',
  builder: (context, data) {
    return Card(
      child: Column(
        children: [
          if (data.hasImage) 
            Image.network(data.imageUrl!),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  data.title ?? 'No Title',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                if (data.description != null)
                  Text(data.description!),
                Text(data.hostname, style: TextStyle(color: Colors.blue)),
              ],
            ),
          ),
        ],
      ),
    );
  },
)
```

## 🔧 Advanced Configuration

### Configuration Options

The `LinkPreview` widget accepts a `config` parameter for customizing its behavior:

```dart
LinkPreview(
  url: 'https://flutter.dev',
  config: LinkPreviewConfig(
    style: LinkPreviewStyle.card,
    titleMaxLines: 2,
    descriptionMaxLines: 3,
    showImage: true,
    showFavicon: true,
    handleNavigation: true,
    animateLoading: true,
    cacheDuration: Duration(hours: 24),
  ),
  onTap: (data) {
    print('Link tapped!');
  },
)
```

### Error and Loading Handling

Customize the appearance of loading and error states:

```dart
LinkPreview(
  url: 'https://flutter.dev',
  errorBuilder: (context, error) {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.red),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text('Failed to load preview: $error'),
    );
  },
  loadingBuilder: (context) {
    return Container(
      padding: EdgeInsets.all(16),
      child: Row(
        children: [
          CircularProgressIndicator(),
          SizedBox(width: 16),
          Text('Loading preview...'),
        ],
      ),
    );
  },
)
```

## 🎮 Using Controllers

The `LinkPreviewController` allows you to programmatically control link previews:

```dart
class _MyWidgetState extends State<MyWidget> {
  late LinkPreviewController _controller;
  
  @override
  void initState() {
    super.initState();
    _controller = LinkPreviewController();
  }
  
  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
  
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TextField(
          decoration: InputDecoration(labelText: 'Enter URL'),
          onSubmitted: (url) {
            _controller.setUrl(url);
          },
        ),
        SizedBox(height: 16),
        LinkPreview(
          url: '', // Will be set by controller
          controller: _controller,
        ),
        Row(
          children: [
            ElevatedButton(
              onPressed: () => _controller.fetchData(forceRefresh: true),
              child: Text('Refresh'),
            ),
            SizedBox(width: 8),
            ElevatedButton(
              onPressed: () => _controller.clear(),
              child: Text('Clear'),
            ),
          ],
        ),
      ],
    );
  }
}
```

## 🎭 Theming

### Adding Theme Extension

MetaLink Flutter integrates with your app's theme system using Theme Extensions:

```dart
final myTheme = ThemeData.light().copyWith(
  extensions: [
    LinkPreviewTheme(
      data: LinkPreviewThemeData(
        backgroundColor: Colors.grey[100],
        titleStyle: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.bold,
          color: Colors.indigo,
        ),
        descriptionStyle: TextStyle(
          fontSize: 14,
          color: Colors.black87,
        ),
        urlStyle: TextStyle(
          fontSize: 12,
          color: Colors.blue,
        ),
        borderRadius: BorderRadius.circular(12),
        elevation: 2.0,
        imageHeight: 150.0,
        faviconSize: 16.0,
        cardShape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
          side: BorderSide(color: Colors.grey.withValues(alpha: 0.2)),
        ),
      ),
    ),
  ],
);

// Apply the theme
MaterialApp(
  theme: myTheme,
  // ...
)
```

### Theme Extension Method

You can also use the extension method on `ThemeData`:

```dart
final myTheme = ThemeData.light().withLinkPreviewTheme(
  LinkPreviewThemeData(
    backgroundColor: Colors.grey[100],
    titleStyle: TextStyle(fontWeight: FontWeight.bold),
    borderRadius: BorderRadius.circular(12),
    // ...other properties
  ),
);
```

## 🔍 URL Detection

Automatically detect URLs in text:

```dart
final text = "Check out this cool site: https://flutter.dev and this one www.example.com";
final urls = UrlDetector.detectUrls(text);

for (final match in urls) {
  print('URL: ${match.url}, Position: ${match.start}-${match.end}');
  
  // Create a preview for each detected URL
  LinkPreview.compact(url: match.url);
}
```

## 📦 MetadataProvider

The `MetadataProvider` class handles caching and fetching metadata:

```dart
// Create a provider with caching enabled
final provider = await MetadataProvider.createWithCache(
  cacheDuration: Duration(hours: 24),
);

// Get metadata for a URL
final metadata = await provider.getMetadata('https://flutter.dev');

// Get metadata for multiple URLs in parallel
final metadataList = await provider.getMultipleMetadata([
  'https://flutter.dev',
  'https://pub.dev',
  'https://material.io',
]);

// Clear the memory cache
provider.clearMemoryCache();

// Clear the storage cache
await MetadataProvider.clearStorageCache();
```

## Web Platform Limitations

When using this package in Flutter Web, browser security policies,
specifically Cross-Origin Resource Sharing ([CORS](https://developer.mozilla.org/en-US/docs/Web/HTTP/CORS)), restrict direct HTTP requests to external domains.
To work around this limitation, consider the following options:

- **If you control the server**: Enable [CORS](https://developer.mozilla.org/en-US/docs/Web/HTTP/CORS) by configuring the server to include appropriate response headers (e.g., `Access-Control-Allow-Origin: *` or your app’s domain). This allows the browser to permit requests from your Flutter Web app.
- **Alternative**: Set up your server to act as a proxy. Make a direct request from your Flutter Web app to your server, which then fetches the metadata from the external domain and returns it to your app. This bypasses [CORS](https://developer.mozilla.org/en-US/docs/Web/HTTP/CORS) restrictions entirely, as the request originates server-side.

## 📄 API Documentation

### Main Classes

- `LinkPreview` - The main widget for displaying link previews
- `LinkPreviewController` - Controls the state of link previews
- `MetadataProvider` - Handles caching and fetching metadata
- `LinkPreviewTheme` - Theme extension for customizing appearance
- `UrlDetector` - Utility for finding and analyzing URLs in text
- `ImageResolver` - Utility for selecting image candidates

For complete API documentation, please see the [API reference](https://pub.dev/documentation/metalink_flutter/latest/).

## 🙋 FAQ

**Q: Does this work with any URL?**  
A: Yes, the package attempts to extract metadata from any valid URL.
The quality of the preview depends on the metadata available on the target website.

**Q: Why do I get errors when fetching metadata on Flutter Web?**  
A: On Flutter Web, browser CORS restrictions prevent direct requests to external domains. To resolve this, either enable
CORS on the target server (if you control it) by adding headers like `Access-Control-Allow-Origin`, or use a proxy
server to fetch the metadata and relay it to your app. See "Web Platform Limitations" for details.

**Q: How is caching handled?**  
A: The package caches metadata in memory and optionally on disk using `hive_ce`. You can configure the cache duration
and clear the cache programmatically.

**Q: Does it resize or optimize images?**  
A: In v2, MetaLink does not provide image resizing. The Flutter widgets use the original image URLs. If you need resizing,
use an image proxy or CDN.

**Q: Does it support RTL languages?**  
A: Yes, the package uses Flutter's logical directional properties (`start`/`end` instead of `left`/`right`) for proper
RTL support.

**Q: Can I customize the loading animation?**  
A: Yes, you can provide your own loading widget using the `loadingBuilder` parameter.

## 👨‍💻 Contributing

Contributions are welcome!
If you find a bug or want a feature, please open an issue.
If you want to contribute code, please fork the repository and submit a pull request.

## 📄 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.
