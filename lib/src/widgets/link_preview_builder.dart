import 'package:flutter/material.dart';
import 'package:metalink_flutter/metalink_flutter.dart';

/// A builder widget for creating link previews from a URL
class LinkPreviewBuilder extends StatefulWidget {
  /// Creates a [LinkPreviewBuilder] that extracts metadata from the given URL.
  const LinkPreviewBuilder({
    required this.url,
    super.key,
    this.controller,
    this.provider,
    this.style = LinkPreviewStyle.card,
    this.titleMaxLines = 2,
    this.descriptionMaxLines = 3,
    this.showImage = true,
    this.showFavicon = true,
    this.onTap,
    this.handleNavigation = true,
    this.useCache = true,
    this.cacheDuration,
    this.forceRefresh = false,
    this.proxyUrl,
    this.userAgent,
    this.animateLoading = true,
    this.errorBuilder,
    this.loadingBuilder,
    this.emptyBuilder,
  });

  /// URL to load preview for
  final String url;

  /// Optional controller for managing the preview
  final LinkPreviewController? controller;

  /// Optional metadata provider
  final MetadataProvider? provider;

  /// Style of the preview
  final LinkPreviewStyle style;

  /// Maximum number of lines for the title
  final int titleMaxLines;

  /// Maximum number of lines for the description
  final int descriptionMaxLines;

  /// Whether to show the image in the preview
  final bool showImage;

  /// Whether to show the favicon in the preview
  final bool showFavicon;

  /// Callback when the preview is tapped
  final LinkPreviewTapCallBack? onTap;

  /// Whether to handle navigation when tapped
  final bool handleNavigation;

  /// Whether to use caching
  final bool useCache;

  /// Optional custom cache duration
  final Duration? cacheDuration;

  /// Whether to force refresh the data
  final bool forceRefresh;

  /// Optional CORS proxy URL for web platform
  final String? proxyUrl;

  /// Optional user agent to use when fetching metadata
  final String? userAgent;

  /// Whether to animate the loading skeleton
  final bool animateLoading;

  /// Builder for handling errors
  final Widget Function(BuildContext context, Object error)? errorBuilder;

  /// Builder for customizing the loading state
  final Widget Function(BuildContext context)? loadingBuilder;

  /// Builder for when no data is available
  final Widget Function(BuildContext context)? emptyBuilder;

  @override
  State<LinkPreviewBuilder> createState() => _LinkPreviewBuilderState();
}

class _LinkPreviewBuilderState extends State<LinkPreviewBuilder> {
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
  void didUpdateWidget(LinkPreviewBuilder oldWidget) {
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
          LinkPreviewSkeleton(
            style: widget.style,
            animate: widget.animateLoading,
          );
    }

    return AnimatedBuilder(
      animation: _controller!,
      builder: (context, child) {
        if (_controller!.isLoading) {
          return widget.loadingBuilder?.call(context) ??
              LinkPreviewSkeleton(
                style: widget.style,
                animate: widget.animateLoading,
              );
        }

        if (_controller!.error != null) {
          return widget.errorBuilder?.call(context, _controller!.error!) ??
              const SizedBox.shrink();
        }

        if (!_controller!.hasData) {
          return widget.emptyBuilder?.call(context) ?? const SizedBox.shrink();
        }

        return _buildPreview(_controller!.data!);
      },
    );
  }

  Widget _buildPreview(LinkMetadata data) {
    return switch (widget.style) {
      LinkPreviewStyle.compact => LinkPreviewCompact(
          data: data,
          titleMaxLines: widget.titleMaxLines,
          descriptionMaxLines: widget.descriptionMaxLines,
          showImage: widget.showImage,
          showFavicon: widget.showFavicon,
          onTap: widget.onTap,
          handleNavigation: widget.handleNavigation,
        ),
      LinkPreviewStyle.large => LinkPreviewLarge(
          data: data,
          titleMaxLines: widget.titleMaxLines,
          descriptionMaxLines: widget.descriptionMaxLines,
          showImage: widget.showImage,
          showFavicon: widget.showFavicon,
          onTap: widget.onTap,
          handleNavigation: widget.handleNavigation,
        ),
      _ => LinkPreviewCard(
          data: data,
          titleMaxLines: widget.titleMaxLines,
          descriptionMaxLines: widget.descriptionMaxLines,
          showImage: widget.showImage,
          showFavicon: widget.showFavicon,
          onTap: widget.onTap,
          handleNavigation: widget.handleNavigation,
        ),
    };
  }
}
