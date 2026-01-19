import 'package:flutter/material.dart';
import 'package:metalink_flutter/metalink_flutter.dart';

/// the call back of on tap on any [LinkPreview] widget.
typedef LinkPreviewTapCallBack = void Function(LinkMetadata? data);

/// Main link preview widget that can be configured and used directly
class LinkPreview extends StatelessWidget {
  /// Creates a [LinkPreview] with the given URL and configuration.
  const LinkPreview({
    required this.url,
    super.key,
    this.controller,
    this.provider,
    this.config = const LinkPreviewConfig(),
    this.onTap,
    this.useCache = true,
    this.cacheDuration,
    this.forceRefresh = false,
    this.errorBuilder,
    this.loadingBuilder,
    this.emptyBuilder,
    this.previewBuilder,
  });

  static const int _defaultMaxLines = 2;
  static const int _defaultTitleMaxLines = 2;
  static const int _defaultDescriptionMaxLines = 3;

  /// Creates a large style link preview
  factory LinkPreview.large({
    required String url,
    Key? key,
    LinkPreviewController? controller,
    MetadataProvider? provider,
    int titleMaxLines = 2,
    int descriptionMaxLines = 4,
    bool showImage = true,
    bool showFavicon = true,
    LinkPreviewTapCallBack? onTap,
    bool handleNavigation = true,
    bool useCache = true,
    Duration? cacheDuration,
    bool forceRefresh = false,
    Widget Function(BuildContext context, Object error)? errorBuilder,
    Widget Function(BuildContext context)? loadingBuilder,
    Widget Function(BuildContext context)? emptyBuilder,
  }) {
    return LinkPreview(
      key: key,
      url: url,
      controller: controller,
      provider: provider,
      config: LinkPreviewConfig(
        style: LinkPreviewStyle.large,
        titleMaxLines: titleMaxLines,
        descriptionMaxLines: descriptionMaxLines,
        showImage: showImage,
        showFavicon: showFavicon,
        handleNavigation: handleNavigation,
      ),
      onTap: onTap,
      useCache: useCache,
      cacheDuration: cacheDuration,
      forceRefresh: forceRefresh,
      errorBuilder: errorBuilder,
      loadingBuilder: loadingBuilder,
      emptyBuilder: emptyBuilder,
    );
  }

  /// Creates a compact style link preview
  factory LinkPreview.compact({
    required String url,
    Key? key,
    LinkPreviewController? controller,
    MetadataProvider? provider,
    int titleMaxLines = 1,
    int descriptionMaxLines = 1,
    bool showImage = true,
    bool showFavicon = true,
    LinkPreviewTapCallBack? onTap,
    bool handleNavigation = true,
    bool useCache = true,
    Duration? cacheDuration,
    bool forceRefresh = false,
    Widget Function(BuildContext context, Object error)? errorBuilder,
    Widget Function(BuildContext context)? loadingBuilder,
    Widget Function(BuildContext context)? emptyBuilder,
  }) {
    return LinkPreview(
      key: key,
      url: url,
      controller: controller,
      provider: provider,
      config: LinkPreviewConfig(
        style: LinkPreviewStyle.compact,
        titleMaxLines: titleMaxLines,
        descriptionMaxLines: descriptionMaxLines,
        showImage: showImage,
        showFavicon: showFavicon,
        handleNavigation: handleNavigation,
      ),
      onTap: onTap,
      useCache: useCache,
      cacheDuration: cacheDuration,
      forceRefresh: forceRefresh,
      errorBuilder: errorBuilder,
      loadingBuilder: loadingBuilder,
      emptyBuilder: emptyBuilder,
    );
  }

  /// Creates a card style link preview
  factory LinkPreview.card({
    required String url,
    Key? key,
    LinkPreviewController? controller,
    MetadataProvider? provider,
    int titleMaxLines = 2,
    int descriptionMaxLines = 3,
    bool showImage = true,
    bool showFavicon = true,
    LinkPreviewTapCallBack? onTap,
    bool handleNavigation = true,
    bool useCache = true,
    Duration? cacheDuration,
    bool forceRefresh = false,
    Widget Function(BuildContext context, Object error)? errorBuilder,
    Widget Function(BuildContext context)? loadingBuilder,
    Widget Function(BuildContext context)? emptyBuilder,
  }) {
    return LinkPreview(
      key: key,
      url: url,
      controller: controller,
      provider: provider,
      config: LinkPreviewConfig(
        style: LinkPreviewStyle.card,
        titleMaxLines: titleMaxLines,
        descriptionMaxLines: descriptionMaxLines,
        showImage: showImage,
        showFavicon: showFavicon,
        handleNavigation: handleNavigation,
      ),
      onTap: onTap,
      useCache: useCache,
      cacheDuration: cacheDuration,
      forceRefresh: forceRefresh,
      errorBuilder: errorBuilder,
      loadingBuilder: loadingBuilder,
      emptyBuilder: emptyBuilder,
    );
  }

  /// Creates a custom style link preview with complete control over rendering
  factory LinkPreview.custom({
    required String url,
    required Widget Function(BuildContext context, LinkMetadata data) builder,
    Key? key,
    LinkPreviewController? controller,
    MetadataProvider? provider,
    LinkPreviewTapCallBack? onTap,
    bool useCache = true,
    Duration? cacheDuration,
    bool forceRefresh = false,
    Widget Function(BuildContext context, Object error)? errorBuilder,
    Widget Function(BuildContext context)? loadingBuilder,
    Widget Function(BuildContext context)? emptyBuilder,
  }) {
    return LinkPreview(
      key: key,
      url: url,
      controller: controller,
      provider: provider,
      onTap: onTap,
      useCache: useCache,
      cacheDuration: cacheDuration,
      forceRefresh: forceRefresh,
      errorBuilder: errorBuilder,
      loadingBuilder: loadingBuilder,
      emptyBuilder: emptyBuilder,
      previewBuilder: builder,
    );
  }

  /// URL to load preview for
  final String url;

  /// Optional controller for managing the preview
  final LinkPreviewController? controller;

  /// Optional metadata provider
  final MetadataProvider? provider;

  /// Configuration for the preview
  final LinkPreviewConfig config;

  /// Callback when the preview is tapped
  final LinkPreviewTapCallBack? onTap;

  /// Whether to use caching
  final bool useCache;

  /// Optional custom cache duration
  final Duration? cacheDuration;

  /// Whether to force refresh the data
  final bool forceRefresh;

  /// Builder for handling errors
  final Widget Function(BuildContext context, Object error)? errorBuilder;

  /// Builder for customizing the loading state
  final Widget Function(BuildContext context)? loadingBuilder;

  /// Builder for when no data is available
  final Widget Function(BuildContext context)? emptyBuilder;

  /// Custom builder for the preview
  final Widget Function(BuildContext context, LinkMetadata data)?
      previewBuilder;

  int _resolveTitleMaxLines() {
    if (config.titleMaxLines == _defaultTitleMaxLines &&
        config.maxLines != _defaultMaxLines) {
      return config.maxLines;
    }
    return config.titleMaxLines;
  }

  int _resolveDescriptionMaxLines() {
    if (config.descriptionMaxLines == _defaultDescriptionMaxLines &&
        config.maxLines != _defaultMaxLines) {
      return config.maxLines;
    }
    return config.descriptionMaxLines;
  }

  @override
  Widget build(BuildContext context) {
    final effectiveCacheDuration = cacheDuration ?? config.cacheDuration;
    final effectiveOnTap = config.enableTap ? onTap : null;
    final effectiveHandleNavigation =
        config.enableTap && config.handleNavigation;
    final effectiveTitleMaxLines = _resolveTitleMaxLines();
    final effectiveDescriptionMaxLines = _resolveDescriptionMaxLines();

    if (previewBuilder != null) {
      return _CustomLinkPreview(
        url: url,
        controller: controller,
        provider: provider,
        onTap: effectiveOnTap,
        useCache: useCache,
        cacheDuration: effectiveCacheDuration,
        forceRefresh: forceRefresh,
        proxyUrl: config.proxyUrl,
        userAgent: config.userAgent,
        errorBuilder: errorBuilder,
        loadingBuilder: loadingBuilder,
        emptyBuilder: emptyBuilder,
        previewBuilder: previewBuilder!,
      );
    }

    return LinkPreviewBuilder(
      url: url,
      controller: controller,
      provider: provider,
      style: config.style,
      titleMaxLines: effectiveTitleMaxLines,
      descriptionMaxLines: effectiveDescriptionMaxLines,
      showImage: config.showImage,
      showFavicon: config.showFavicon,
      proxyUrl: config.proxyUrl,
      userAgent: config.userAgent,
      animateLoading: config.animateLoading,
      onTap: effectiveOnTap,
      handleNavigation: effectiveHandleNavigation,
      useCache: useCache,
      cacheDuration: effectiveCacheDuration,
      forceRefresh: forceRefresh,
      errorBuilder: errorBuilder,
      loadingBuilder: loadingBuilder,
      emptyBuilder: emptyBuilder,
    );
  }
}

/// Widget for custom link previews
class _CustomLinkPreview extends StatefulWidget {
  const _CustomLinkPreview({
    required this.url,
    required this.previewBuilder,
    this.controller,
    this.provider,
    this.onTap,
    this.useCache = true,
    this.cacheDuration,
    this.forceRefresh = false,
    this.proxyUrl,
    this.userAgent,
    this.errorBuilder,
    this.loadingBuilder,
    this.emptyBuilder,
  });

  final String url;
  final LinkPreviewController? controller;
  final MetadataProvider? provider;
  final LinkPreviewTapCallBack? onTap;
  final bool useCache;
  final Duration? cacheDuration;
  final bool forceRefresh;
  final String? proxyUrl;
  final String? userAgent;
  final Widget Function(BuildContext context, Object error)? errorBuilder;
  final Widget Function(BuildContext context)? loadingBuilder;
  final Widget Function(BuildContext context)? emptyBuilder;
  final Widget Function(BuildContext context, LinkMetadata data) previewBuilder;

  @override
  State<_CustomLinkPreview> createState() => _CustomLinkPreviewState();
}

class _CustomLinkPreviewState extends State<_CustomLinkPreview> {
  LinkPreviewController? _controller;
  bool _isLocalController = false;
  bool _isInitializing = false;

  @override
  void initState() {
    super.initState();
    _initializeController();
  }

  Future<void> _initializeController() async {
    // If a controller was provided by the parent, use it
    if (widget.controller != null) {
      setState(() {
        _controller = widget.controller;
        _isLocalController = false;

        // If the controller has a different URL, update it
        if (_controller?.url != widget.url) {
          _controller?.setUrl(widget.url, forceRefresh: widget.forceRefresh);
        }
      });
      return;
    }

    // Otherwise, we need to create our own controller
    setState(() => _isInitializing = true);

    try {
      // Create controller based on caching preference
      if (widget.useCache) {
        final controller = await LinkPreviewController.withCache(
          initialUrl: widget.url,
          cacheDuration: widget.cacheDuration ?? const Duration(hours: 24),
          proxyUrl: widget.proxyUrl,
          userAgent: widget.userAgent,
        );

        // Check if widget is still mounted before updating state
        if (!mounted) return;

        setState(() {
          _controller = controller;
          _isLocalController = true;
          _isInitializing = false;
        });
      } else {
        // Create a non-cached controller immediately
        final controller = LinkPreviewController(
          provider: widget.provider,
          initialUrl: widget.url,
          proxyUrl: widget.proxyUrl,
          userAgent: widget.userAgent,
        );

        if (!mounted) return;

        setState(() {
          _controller = controller;
          _isLocalController = true;
          _isInitializing = false;
        });
      }
    } catch (e) {
      // Handle initialization errors
      if (!mounted) return;

      setState(() {
        _isInitializing = false;
        // We'll create a basic controller without cache
        _controller = LinkPreviewController(
          initialUrl: widget.url,
          proxyUrl: widget.proxyUrl,
          userAgent: widget.userAgent,
        );
        _isLocalController = true;
      });
    }
  }

  @override
  void didUpdateWidget(_CustomLinkPreview oldWidget) {
    super.didUpdateWidget(oldWidget);

    // Update URL if it changed
    if (oldWidget.url != widget.url && _controller != null) {
      _controller!.setUrl(widget.url, forceRefresh: widget.forceRefresh);
    }

    // Handle controller changes
    if (oldWidget.controller != widget.controller) {
      _disposeLocalController();
      _initializeController();
    }
  }

  void _disposeLocalController() {
    if (_isLocalController && _controller != null) {
      _controller!.dispose();
      _controller = null;
    }
  }

  @override
  void dispose() {
    _disposeLocalController();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // If the controller is still initializing, show loading state
    if (_isInitializing || _controller == null) {
      return widget.loadingBuilder?.call(context) ??
          const CircularProgressIndicator();
    }

    return AnimatedBuilder(
      animation: _controller!,
      builder: (context, child) {
        if (_controller!.isLoading) {
          return widget.loadingBuilder?.call(context) ??
              const CircularProgressIndicator();
        }

        if (_controller!.error != null) {
          return widget.errorBuilder?.call(context, _controller!.error!) ??
              const SizedBox.shrink();
        }

        if (!_controller!.hasData) {
          return widget.emptyBuilder?.call(context) ?? const SizedBox.shrink();
        }

        return GestureDetector(
          onTap: () => widget.onTap?.call(_controller?.data),
          child: widget.previewBuilder(context, _controller!.data!),
        );
      },
    );
  }
}
