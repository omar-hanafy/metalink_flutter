import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:hive_ce_flutter/adapters.dart';
import 'package:http/http.dart' as http;
import 'package:metalink/metalink.dart';

/// Provider for link metadata with integration with MetaLink's caching system
class MetadataProvider extends ChangeNotifier {
  /// Factory constructor that creates a [MetadataProvider] with a provided MetaLinkClient instance
  factory MetadataProvider.withClient(MetaLinkClient client) {
    return MetadataProvider._(client: client);
  }

  /// Creates a [MetadataProvider] with a pre-initialized MetaLinkClient instance
  MetadataProvider._({
    required MetaLinkClient client,
    CacheStore? cacheStore,
    bool ownsCacheStore = false,
  })  : _client = client,
        _cacheStore = cacheStore,
        _ownsCacheStore = ownsCacheStore;

  /// Factory constructor that creates a [MetadataProvider] with default settings
  ///
  /// This creates a non-cached instance that's immediately available
  factory MetadataProvider.create({
    http.Client? client,
    Duration timeout = const Duration(seconds: 10),
    String? userAgent,
    bool followRedirects = true,
    int maxRedirects = 5,
    bool extractStructuredData = true,
    String? proxyUrl,
  }) =>
      MetadataProvider._(
        client: MetaLinkClient(
          httpClient: client,
          options: MetaLinkClientOptions(
            fetch: FetchOptions(
              timeout: timeout,
              userAgent: userAgent ?? _getDefaultUserAgent(),
              followRedirects: followRedirects,
              maxRedirects: maxRedirects,
              proxyUrl: proxyUrl,
            ),
            extract: ExtractOptions(
              extractJsonLd: extractStructuredData,
            ),
            cache: const CacheOptions(enabled: false),
          ),
        ),
      );

  /// Asynchronously creates a [MetadataProvider] with caching enabled.
  ///
  /// Falls back to an in-memory cache store if Hive initialization fails.
  static Future<MetadataProvider> createWithCache({
    http.Client? client,
    Duration timeout = const Duration(seconds: 20),
    String? userAgent,
    Duration cacheDuration = const Duration(hours: 24),
    bool followRedirects = true,
    int maxRedirects = 5,
    bool extractStructuredData = true,
    String? proxyUrl,
  }) async {
    CacheStore cacheStore;
    try {
      cacheStore = await MetadataFlutterCacheFactory.createHiveStore();
    } catch (e, s) {
      debugPrint(
        'Failed to initialize Hive cache store, falling back to memory: $e\n$s',
      );
      cacheStore = MemoryCacheStore(defaultTtl: cacheDuration);
    }

    final metaLinkClient = MetaLinkClient(
      httpClient: client,
      cacheStore: cacheStore,
      options: MetaLinkClientOptions(
        fetch: FetchOptions(
          timeout: timeout,
          userAgent: userAgent ?? _getDefaultUserAgent(),
          followRedirects: followRedirects,
          maxRedirects: maxRedirects,
          proxyUrl: proxyUrl,
        ),
        extract: ExtractOptions(
          extractJsonLd: extractStructuredData,
        ),
        cache: CacheOptions(
          enabled: true,
          ttl: cacheDuration,
        ),
      ),
    );
    return MetadataProvider._(
      client: metaLinkClient,
      cacheStore: cacheStore,
      ownsCacheStore: true,
    );
  }

  /// Returns a default user agent string appropriate for the platform
  static String _getDefaultUserAgent() {
    if (kIsWeb) {
      return 'Mozilla/5.0 MetaLink Flutter Web Client';
    } else {
      return 'MetaLink Flutter Client';
    }
  }

  /// Internal MetaLinkClient instance for metadata extraction
  final MetaLinkClient _client;

  /// Cache store used by the MetaLinkClient, if provided.
  final CacheStore? _cacheStore;

  /// Whether this provider owns the cache store and should close it.
  final bool _ownsCacheStore;

  /// A map tracking currently loading URLs to avoid duplicate requests
  final Map<String, Completer<LinkMetadata>> _loadingUrls = {};

  /// In-memory cache for quick access (separate from MetaLink's cache)
  final Map<String, LinkMetadata> _uiCache = {};

  /// Loads metadata for the given URL, using MetaLink's cache if enabled
  Future<LinkMetadata> getMetadata(
    String url, {
    bool forceRefresh = false,
  }) async {
    if (url.isEmpty) {
      throw ArgumentError('URL cannot be empty');
    }

    // Normalize the URL by removing trailing slash
    final normalizedUrl =
        url.endsWith('/') ? url.substring(0, url.length - 1) : url;

    // If this URL is already being loaded, wait for the result
    if (_loadingUrls.containsKey(normalizedUrl)) {
      return _loadingUrls[normalizedUrl]!.future;
    }

    // Check UI memory cache first if not forcing refresh
    if (!forceRefresh && _uiCache.containsKey(normalizedUrl)) {
      final cachedData = _uiCache[normalizedUrl]!;
      return cachedData;
    }

    // Create a completer to track this URL's loading state
    final completer = Completer<LinkMetadata>();
    _loadingUrls[normalizedUrl] = completer;

    try {
      // Fetch metadata (MetaLink will handle its own caching)
      final result = await _client.extract(
        normalizedUrl,
        skipCache: forceRefresh,
      );

      // In v2, extract does not throw. Check errors.
      if (result.errors.isNotEmpty) {
        // If there are errors, we might still have partial metadata.
        // But if it's a fatal error (like network), we might want to throw or return partial.
        // For backward compatibility (and general usefulness), if metadata is empty and we have errors, throw.
        if (result.metadata.isEmpty) {
          final firstError = result.errors.first;
          final errorText = firstError.cause?.toString() ?? firstError.message;
          // Handle web-specific errors with more informative messages
          if (kIsWeb &&
              (errorText.contains('Failed to fetch') ||
                  errorText.contains('XMLHttpRequest'))) {
            // Simplified check
            throw Exception(
                'CORS error: Unable to fetch metadata for $normalizedUrl. '
                'This is a browser security restriction when running on the web platform. '
                'Please use a CORS proxy in your application.');
          }
          throw Exception(firstError.message);
        }
      }

      final previewData = result.metadata;

      // Update UI memory cache
      _uiCache[normalizedUrl] = previewData;

      completer.complete(previewData);
      _loadingUrls.remove(normalizedUrl);
      return previewData;
    } catch (e) {
      _loadingUrls.remove(normalizedUrl);
      completer.completeError(e);
      rethrow;
    }
  }

  /// Gets data for multiple URLs in parallel
  Future<List<LinkMetadata>> getMultipleMetadata(
    List<String> urls, {
    bool forceRefresh = false,
    int concurrentRequests = 3,
  }) async {
    if (urls.isEmpty) {
      return [];
    }

    final results = List<LinkMetadata?>.filled(urls.length, null);
    final fetchUrls = <String>[];
    final fetchIndexes = <int>[];

    for (var i = 0; i < urls.length; i++) {
      final url = urls[i];
      if (url.isEmpty) {
        results[i] = LinkMetadata(
          originalUrl: Uri.parse('about:blank'),
          resolvedUrl: Uri.parse('about:blank'),
        );
        continue;
      }

      final normalizedUrl =
          url.endsWith('/') ? url.substring(0, url.length - 1) : url;

      if (!forceRefresh && _uiCache.containsKey(normalizedUrl)) {
        results[i] = _uiCache[normalizedUrl];
        continue;
      }

      fetchUrls.add(normalizedUrl);
      fetchIndexes.add(i);
    }

    if (fetchUrls.isNotEmpty) {
      final safeConcurrency = concurrentRequests < 1 ? 1 : concurrentRequests;

      // Use extractBatch from v2 which handles concurrency.
      final batchResults = await _client.extractBatch(
        fetchUrls,
        skipCache: forceRefresh,
        concurrency: safeConcurrency,
      );

      for (var i = 0; i < batchResults.length; i++) {
        final metadata = batchResults[i].metadata;
        final normalizedUrl = fetchUrls[i];
        _uiCache[normalizedUrl] = metadata;
        results[fetchIndexes[i]] = metadata;
      }
    }

    return results
        .map(
          (metadata) =>
              metadata ??
              LinkMetadata(
                originalUrl: Uri.parse('about:blank'),
                resolvedUrl: Uri.parse('about:blank'),
              ),
        )
        .toList();
  }

  /// clears the storage caches
  /// Note: This only clears the Storage cache, not UI cache.
  static Future<void> clearStorageCache() async {
    try {
      final cacheStore = await MetadataFlutterCacheFactory.createHiveStore();
      await cacheStore.clear();
      await cacheStore.close();
    } catch (e, s) {
      debugPrint('Failed to clear storage cache: $e\n$s');
    }
  }

  /// Clear the memory cache
  /// Note: This only clears the UI cache, not MetaLink's internal cache
  void clearMemoryCache() {
    _uiCache.clear();
    notifyListeners();
  }

  @override
  void dispose() {
    _client.close();
    if (_ownsCacheStore && _cacheStore != null) {
      unawaited(_cacheStore!.close());
    }
    super.dispose();
  }
}

/// Factory for creating metadata cache instances
class MetadataFlutterCacheFactory {
  /// The name of the Hive box used for caching
  static const String _boxName = 'metalink_flutter_cache';

  /// Creates a HiveCacheStore properly initialized for Flutter
  static Future<HiveCacheStore> createHiveStore() async {
    // Try to initialize Hive for Flutter - will throw if already initialized
    try {
      await Hive.initFlutter();
    } catch (_) {
      // Hive is already initialized, which is fine
    }

    // Open the box
    final box = await Hive.openBox<String>(_boxName);

    // Create HiveCacheStore with the opened box
    return HiveCacheStore(box: box);
  }
}
