# MetaLink Flutter

[![Discontinued](https://img.shields.io/badge/status-discontinued-orange.svg)](https://pub.dev/packages/metalink_flutter)
[![Replacement: metalink](https://img.shields.io/badge/replacement-metalink-blue.svg)](https://pub.dev/packages/metalink)
[![License: BSD-3-Clause](https://img.shields.io/badge/license-BSD--3--Clause-blue.svg)](LICENSE)

> [!IMPORTANT]
> **This package is discontinued.** Version `2.0.3` is the final compatibility
> release. Existing versions remain available, but no new features or fixes are
> planned. New and existing applications should use
> [`package:metalink`](https://pub.dev/packages/metalink) directly and render
> metadata with their own Flutter widgets.

MetaLink Flutter provided Material link-preview cards on top of the MetaLink
metadata engine. The package is being retired so that MetaLink can remain
focused on reliable extraction, parsing, ranking, diagnostics, networking, and
caching without owning an application-specific UI layer.

## Why the package was discontinued

Link previews are part of an application's visual language. Chat messages,
article lists, bookmarks, search results, and social feeds need different
layouts, interaction rules, loading states, accessibility behavior, and image
policies. A generic card package either becomes too opinionated or accumulates
configuration that applications still need to work around.

The non-visual conveniences in this package also became redundant as MetaLink
evolved:

- MetaLink owns request orchestration, caching, concurrent-request coalescing,
  batch extraction, lifecycle, and diagnostics.
- Flutter applications already have established choices for state management,
  image loading, navigation, persistence, and design systems.
- Keeping another controller and cache layer between the application and
  MetaLink hides structured partial results and makes engine upgrades slower.
- URL detection and card styling are application concerns rather than metadata
  extraction capabilities.

This is a product-boundary decision, not a replacement of Flutter support.
`package:metalink` continues to work in Flutter applications. Only the
prebuilt UI package is being retired.

## What happens to existing applications?

- Published versions remain available from pub.dev.
- The `2.0.3` release keeps the existing public API intact for compatibility.
- The source repository is archived as a read-only historical reference.
- No security, compatibility, or Flutter-version updates are planned for this
  package after `2.0.3`.
- MetaLink engine updates continue in the
  [`metalink`](https://github.com/omar-hanafy/metalink) repository.

Applications do not need to migrate immediately, but should avoid introducing
new dependencies on `metalink_flutter`.

## Migration

### 1. Replace the dependency

```yaml
dependencies:
  metalink: ^2.1.0
```

Remove `metalink_flutter` and add any UI dependencies your application actually
uses.

MetaLink 2.1 requires Dart 3.11. Applications on an older Dart toolchain can
first replace the Flutter widgets while staying on a compatible MetaLink 2.0.x
release, then upgrade the engine and SDK separately.

### 2. Extract metadata directly

For a small widget or one-off request, keep the extraction future in state:

```dart
import 'package:flutter/material.dart';
import 'package:metalink/metalink.dart';

class LinkPreview extends StatefulWidget {
  const LinkPreview({required this.url, super.key});

  final String url;

  @override
  State<LinkPreview> createState() => _LinkPreviewState();
}

class _LinkPreviewState extends State<LinkPreview> {
  late Future<ExtractionResult<LinkMetadata>> _result;

  @override
  void initState() {
    super.initState();
    _result = MetaLink.extract(widget.url);
  }

  @override
  void didUpdateWidget(LinkPreview oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.url != widget.url) {
      _result = MetaLink.extract(widget.url);
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<ExtractionResult<LinkMetadata>>(
      future: _result,
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const SizedBox(
            height: 120,
            child: Center(child: CircularProgressIndicator()),
          );
        }

        final result = snapshot.requireData;
        final metadata = result.metadataOrNull;
        if (metadata == null) {
          return Text(result.primaryError?.message ?? 'Preview unavailable');
        }

        final image = metadata.images.firstOrNull;
        return Card(
          clipBehavior: Clip.antiAlias,
          child: Row(
            children: [
              if (image != null)
                Image.network(
                  image.url.toString(),
                  width: 120,
                  height: 120,
                  fit: BoxFit.cover,
                  errorBuilder: (_, _, _) => const SizedBox(width: 120),
                ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        metadata.title ?? metadata.resolvedUrl.host,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                      if (metadata.description case final description?) ...[
                        const SizedBox(height: 6),
                        Text(
                          description,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
```

`images` and `icons` are already ordered by MetaLink's ranking policy. Your UI
can choose a different candidate when its dimensions, MIME type, or aspect ratio
better match the layout.

### 3. Use a reusable client when the screen performs multiple requests

```dart
final client = MetaLinkClient(
  options: MetaLinkClientOptions(
    fetch: FetchOptions(
      timeout: Duration(seconds: 10),
      totalTimeout: Duration(seconds: 20),
      requestPolicy: RequestPolicy.secure(),
    ),
    cache: const CacheOptions(
      enabled: true,
      ttl: Duration(minutes: 30),
    ),
  ),
);

try {
  final result = await client.extract('https://dart.dev');
  final metadata = result.metadataOrNull;
  // Pass metadata to your own widget or state layer.
} finally {
  await client.dispose();
}
```

Keep a long-lived client in your repository, service, provider, BLoC, Riverpod
provider, or other application state layer. MetaLink does not require any one
Flutter state-management package.

### 4. Handle partial and failed results explicitly

```dart
switch (result.status) {
  case ExtractionStatus.success:
    showPreview(result.metadata);
  case ExtractionStatus.partial:
    showPreview(result.metadata, isPartial: true);
  case ExtractionStatus.failure:
    showError(
      result.primaryError?.message ?? 'Preview unavailable',
      canRetry: result.retryable,
    );
}
```

This preserves information that the old `MetadataProvider` converted into a
single loading/data/error model.

## API migration map

| `metalink_flutter` API | Migration |
| --- | --- |
| `LinkPreview`, `LinkPreviewCard`, `LinkPreviewCompact`, `LinkPreviewLarge` | Build an application widget from `LinkMetadata`. |
| `LinkPreviewBuilder` | Use `FutureBuilder`, your state-management solution, or a repository abstraction. |
| `LinkPreviewController` | Store `ExtractionResult<LinkMetadata>` in application state. |
| `MetadataProvider` | Use a long-lived `MetaLinkClient`. |
| `MetadataFlutterCacheFactory` | Use MetaLink's memory cache or initialize an application-owned `HiveCacheStore`. |
| `LinkPreviewTheme` | Use your application's `ThemeData`, component theme, or design tokens. |
| `ImageResolver` | Select from ranked `metadata.images`; apply your own CDN or image provider. |
| `UrlDetector` | Keep URL detection in the text-input/domain layer or use a dedicated parser. |
| `launchUrlFromContext` | Call `url_launcher` directly where navigation is owned. |

## Flutter showcase

The MetaLink repository includes a complete, custom Flutter implementation:

[`examples/flutter_link_preview`](https://github.com/omar-hanafy/metalink/tree/main/examples/flutter_link_preview)

It demonstrates a responsive card, loading and failure states, ranked images,
diagnostics, caching, cancellation, and deterministic client disposal without
depending on `metalink_flutter`. It is intentionally example code, so teams can
adapt its styling and ownership model instead of inheriting another package's
UI contract.

## Flutter web

Browsers commonly prevent direct metadata extraction from third-party sites
through CORS and do not expose every redirect hop. For untrusted browser-side
URLs, use a policy-aware backend proxy or provide a custom MetaLink `Fetcher`
that can enforce the required network policy. The showcase targets native
Flutter platforms for that reason.

## Historical documentation

The final source remains available in this repository for existing users who
need to inspect or temporarily maintain the old widgets. Earlier usage examples
remain available through the README attached to previous tags.

For active documentation and support, use:

- [MetaLink on pub.dev](https://pub.dev/packages/metalink)
- [MetaLink repository](https://github.com/omar-hanafy/metalink)
- [MetaLink issue tracker](https://github.com/omar-hanafy/metalink/issues)

## License

MetaLink Flutter remains available under the BSD 3-Clause License.
