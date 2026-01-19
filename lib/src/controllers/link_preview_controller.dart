import 'package:flutter/foundation.dart';
import 'package:flutter_helper_utils/flutter_helper_utils.dart';
import 'package:http/http.dart' as http;
import 'package:metalink/metalink.dart';

import 'package:metalink_flutter/src/controllers/metadata_provider.dart';
import 'package:metalink_flutter/src/extensions/link_metadata_extensions.dart';

/// Controller for managing link preview state and data loading
class LinkPreviewController extends ChangeNotifier {
  /// Creates a [LinkPreviewController] with default settings
  ///
  /// This creates a non-cached instance that's immediately available
  factory LinkPreviewController({
    MetadataProvider? provider,
    String? initialUrl,
    http.Client? client,
    String? proxyUrl,
    String? userAgent,
  }) {
    return LinkPreviewController._(
      provider: provider ??
          MetadataProvider.create(
            client: client,
            proxyUrl: proxyUrl,
            userAgent: userAgent,
          ),
      initialUrl: initialUrl,
    );
  }

  /// Creates a [LinkPreviewController] with the given provider
  LinkPreviewController._({
    required MetadataProvider provider,
    String? initialUrl,
  })  : _provider = provider,
        _url = initialUrl {
    if (initialUrl != null && initialUrl.isNotEmpty) {
      fetchData();
    }
  }

  /// Creates a [LinkPreviewController] with caching enabled
  ///
  /// Since caching requires async initialization, this factory
  /// returns a Future that completes when the controller is ready
  static Future<LinkPreviewController> withCache({
    String? initialUrl,
    Duration cacheDuration = const Duration(hours: 24),
    http.Client? client,
    String? proxyUrl,
    String? userAgent,
  }) async {
    final provider = await MetadataProvider.createWithCache(
      cacheDuration: cacheDuration,
      client: client,
      proxyUrl: proxyUrl,
      userAgent: userAgent,
    );
    return LinkPreviewController._(
      provider: provider,
      initialUrl: initialUrl,
    );
  }

  /// The metadata provider
  final MetadataProvider _provider;

  /// Current URL being previewed
  String? _url;

  /// Current loading state
  bool _isLoading = false;

  /// Current error, if any
  Object? _error;

  /// Current preview data
  LinkMetadata? _data;

  /// Gets the current URL
  String? get url => _url;

  /// Gets whether data is currently loading
  bool get isLoading => _isLoading;

  /// Gets the current error, if any
  Object? get error => _error;

  /// Gets the current preview data
  LinkMetadata? get data => _data;

  /// Returns true if data is available
  bool get hasData => _data != null;

  /// Returns true if the preview has an image
  bool get hasImage => _data?.hasImage ?? false;

  /// Returns true if the preview has a favicon
  bool get hasFavicon => _data?.hasFavicon ?? false;

  /// Changes the URL and fetches new preview data
  Future<void> setUrl(String? url, {bool forceRefresh = false}) async {
    if (url == null || url.isEmpty || url == _url && !forceRefresh) {
      return;
    }

    _url = url;
    await fetchData(forceRefresh: forceRefresh);
  }

  /// Fetches preview data for the current URL
  Future<void> fetchData({bool forceRefresh = false}) async {
    if (_url.isEmptyOrNull) return;

    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      _data = await _provider.getMetadata(_url!, forceRefresh: forceRefresh);
      _isLoading = false;
      _error = null;
    } catch (e, s) {
      debugPrint('fetchData error: $e\n$s');
      _isLoading = false;
      _error = e;
      _data = null;
    }

    notifyListeners();
  }

  /// Clears the current preview data
  void clear() {
    _url = null;
    _data = null;
    _isLoading = false;
    _error = null;
    notifyListeners();
  }

  /// Get the provider instance
  MetadataProvider get provider => _provider;

  @override
  void dispose() {
    _provider.dispose();
    super.dispose();
  }
}
