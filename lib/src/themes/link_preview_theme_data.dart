import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

/// Defines the visual properties for link preview widgets.
///
/// This class allows customizing the appearance of link preview components
/// across the application.
@immutable
class LinkPreviewThemeData with Diagnosticable {
  /// Creates a [LinkPreviewThemeData].
  const LinkPreviewThemeData({
    this.backgroundColor,
    this.titleStyle,
    this.descriptionStyle,
    this.urlStyle,
    this.siteNameStyle,
    this.borderRadius,
    this.elevation,
    this.padding,
    this.imageHeight,
    this.maxHeight,
    this.maxWidth,
    this.imageBorderRadius,
    this.imagePlaceholderColor,
    this.faviconSize,
    this.compactSpacing,
    this.contentPadding,
    this.cardShape,
    this.defaultImageErrorBuilder,
    this.defaultImageLoadingBuilder,
    this.showFavicon = true,
    this.showImage = true,
  });

  /// Linearly interpolate between two [LinkPreviewThemeData] objects.
  factory LinkPreviewThemeData.lerp(
      LinkPreviewThemeData? a, LinkPreviewThemeData? b, double t) {
    if (a == null && b == null) return const LinkPreviewThemeData();
    if (a == null) return b!;
    if (b == null) return a;
    return LinkPreviewThemeData(
      backgroundColor: Color.lerp(a.backgroundColor, b.backgroundColor, t),
      titleStyle: TextStyle.lerp(a.titleStyle, b.titleStyle, t),
      descriptionStyle:
          TextStyle.lerp(a.descriptionStyle, b.descriptionStyle, t),
      urlStyle: TextStyle.lerp(a.urlStyle, b.urlStyle, t),
      siteNameStyle: TextStyle.lerp(a.siteNameStyle, b.siteNameStyle, t),
      borderRadius:
          BorderRadiusGeometry.lerp(a.borderRadius, b.borderRadius, t),
      elevation: t < 0.5 ? a.elevation : b.elevation,
      padding: EdgeInsetsGeometry.lerp(a.padding, b.padding, t),
      imageHeight: t < 0.5 ? a.imageHeight : b.imageHeight,
      maxHeight: t < 0.5 ? a.maxHeight : b.maxHeight,
      maxWidth: t < 0.5 ? a.maxWidth : b.maxWidth,
      imageBorderRadius: BorderRadiusGeometry.lerp(
          a.imageBorderRadius, b.imageBorderRadius, t),
      imagePlaceholderColor:
          Color.lerp(a.imagePlaceholderColor, b.imagePlaceholderColor, t),
      faviconSize: t < 0.5 ? a.faviconSize : b.faviconSize,
      compactSpacing: t < 0.5 ? a.compactSpacing : b.compactSpacing,
      contentPadding:
          EdgeInsetsGeometry.lerp(a.contentPadding, b.contentPadding, t),
      cardShape: t < 0.5 ? a.cardShape : b.cardShape,
      defaultImageErrorBuilder:
          t < 0.5 ? a.defaultImageErrorBuilder : b.defaultImageErrorBuilder,
      defaultImageLoadingBuilder:
          t < 0.5 ? a.defaultImageLoadingBuilder : b.defaultImageLoadingBuilder,
      showFavicon: t < 0.5 ? a.showFavicon : b.showFavicon,
      showImage: t < 0.5 ? a.showImage : b.showImage,
    );
  }

  /// Returns a [LinkPreviewThemeData] with default values
  /// based on the provided [context] and [colorScheme].
  factory LinkPreviewThemeData.defaults(
      BuildContext context, ColorScheme colorScheme) {
    final textTheme = Theme.of(context).textTheme;

    return LinkPreviewThemeData(
      backgroundColor: colorScheme.surface,
      titleStyle: textTheme.titleMedium?.copyWith(
        color: colorScheme.onSurface,
        fontWeight: FontWeight.w600,
      ),
      descriptionStyle: textTheme.bodyMedium?.copyWith(
        color: colorScheme.onSurface.withValues(alpha: 0.7),
      ),
      urlStyle: textTheme.bodySmall?.copyWith(
        color: colorScheme.primary,
      ),
      siteNameStyle: textTheme.labelMedium?.copyWith(
        color: colorScheme.onSurface.withValues(alpha: 0.6),
      ),
      borderRadius: BorderRadiusDirectional.circular(12.0),
      elevation: 0.0,
      padding: const EdgeInsets.all(12.0),
      imageHeight: 150.0,
      maxHeight: 320.0,
      maxWidth: double.infinity,
      imageBorderRadius: BorderRadiusDirectional.circular(8.0),
      imagePlaceholderColor: colorScheme.surfaceContainerHighest,
      faviconSize: 16.0,
      compactSpacing: 8.0,
      contentPadding: const EdgeInsets.all(12.0),
      cardShape: RoundedRectangleBorder(
        borderRadius: BorderRadiusDirectional.circular(12.0),
        side: BorderSide(color: colorScheme.outline.withValues(alpha: 0.2)),
      ),
      showFavicon: true,
      showImage: true,
    );
  }

  /// Default background color for the link preview card.
  final Color? backgroundColor;

  /// Text style for the link title.
  final TextStyle? titleStyle;

  /// Text style for the link description.
  final TextStyle? descriptionStyle;

  /// Text style for the display URL.
  final TextStyle? urlStyle;

  /// Text style for the site name.
  final TextStyle? siteNameStyle;

  /// Border radius for the link preview container.
  final BorderRadiusGeometry? borderRadius;

  /// Elevation for the link preview card.
  final double? elevation;

  /// Padding for the entire link preview widget.
  final EdgeInsetsGeometry? padding;

  /// Image height for the preview image.
  final double? imageHeight;

  /// Maximum height of the entire link preview widget.
  final double? maxHeight;

  /// Maximum width of the entire link preview widget.
  final double? maxWidth;

  /// Border radius for the preview image.
  final BorderRadiusGeometry? imageBorderRadius;

  /// Color used for image placeholders when loading.
  final Color? imagePlaceholderColor;

  /// Size for the favicon display.
  final double? faviconSize;

  /// Spacing between elements in compact layout.
  final double? compactSpacing;

  /// Padding for the content section of the preview.
  final EdgeInsetsGeometry? contentPadding;

  /// Shape for the card-style link preview.
  final ShapeBorder? cardShape;

  /// Default builder for handling image loading errors.
  final Widget Function(BuildContext, Object, StackTrace?)?
      defaultImageErrorBuilder;

  /// Default builder for customizing the image loading state.
  final Widget Function(BuildContext, Widget, ImageChunkEvent?)?
      defaultImageLoadingBuilder;

  /// Whether to show the favicon in the preview.
  final bool showFavicon;

  /// Whether to show the image in the preview.
  final bool showImage;

  /// Creates a copy of this [LinkPreviewThemeData] with the given fields replaced
  /// with new values.
  LinkPreviewThemeData copyWith({
    Color? backgroundColor,
    TextStyle? titleStyle,
    TextStyle? descriptionStyle,
    TextStyle? urlStyle,
    TextStyle? siteNameStyle,
    BorderRadiusGeometry? borderRadius,
    double? elevation,
    EdgeInsetsGeometry? padding,
    double? imageHeight,
    double? maxHeight,
    double? maxWidth,
    BorderRadiusGeometry? imageBorderRadius,
    Color? imagePlaceholderColor,
    double? faviconSize,
    double? compactSpacing,
    EdgeInsetsGeometry? contentPadding,
    ShapeBorder? cardShape,
    Widget Function(BuildContext, Object, StackTrace?)?
        defaultImageErrorBuilder,
    Widget Function(BuildContext, Widget, ImageChunkEvent?)?
        defaultImageLoadingBuilder,
    bool? showFavicon,
    bool? showImage,
  }) {
    return LinkPreviewThemeData(
      backgroundColor: backgroundColor ?? this.backgroundColor,
      titleStyle: titleStyle ?? this.titleStyle,
      descriptionStyle: descriptionStyle ?? this.descriptionStyle,
      urlStyle: urlStyle ?? this.urlStyle,
      siteNameStyle: siteNameStyle ?? this.siteNameStyle,
      borderRadius: borderRadius ?? this.borderRadius,
      elevation: elevation ?? this.elevation,
      padding: padding ?? this.padding,
      imageHeight: imageHeight ?? this.imageHeight,
      maxHeight: maxHeight ?? this.maxHeight,
      maxWidth: maxWidth ?? this.maxWidth,
      imageBorderRadius: imageBorderRadius ?? this.imageBorderRadius,
      imagePlaceholderColor:
          imagePlaceholderColor ?? this.imagePlaceholderColor,
      faviconSize: faviconSize ?? this.faviconSize,
      compactSpacing: compactSpacing ?? this.compactSpacing,
      contentPadding: contentPadding ?? this.contentPadding,
      cardShape: cardShape ?? this.cardShape,
      defaultImageErrorBuilder:
          defaultImageErrorBuilder ?? this.defaultImageErrorBuilder,
      defaultImageLoadingBuilder:
          defaultImageLoadingBuilder ?? this.defaultImageLoadingBuilder,
      showFavicon: showFavicon ?? this.showFavicon,
      showImage: showImage ?? this.showImage,
    );
  }

  /// Merges this [LinkPreviewThemeData] with another.
  LinkPreviewThemeData merge(LinkPreviewThemeData? other) {
    if (other == null) return this;
    return copyWith(
      backgroundColor: other.backgroundColor,
      titleStyle: other.titleStyle,
      descriptionStyle: other.descriptionStyle,
      urlStyle: other.urlStyle,
      siteNameStyle: other.siteNameStyle,
      borderRadius: other.borderRadius,
      elevation: other.elevation,
      padding: other.padding,
      imageHeight: other.imageHeight,
      maxHeight: other.maxHeight,
      maxWidth: other.maxWidth,
      imageBorderRadius: other.imageBorderRadius,
      imagePlaceholderColor: other.imagePlaceholderColor,
      faviconSize: other.faviconSize,
      compactSpacing: other.compactSpacing,
      contentPadding: other.contentPadding,
      cardShape: other.cardShape,
      defaultImageErrorBuilder: other.defaultImageErrorBuilder,
      defaultImageLoadingBuilder: other.defaultImageLoadingBuilder,
      showFavicon: other.showFavicon,
      showImage: other.showImage,
    );
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(ColorProperty('backgroundColor', backgroundColor))
      ..add(DiagnosticsProperty<TextStyle>('titleStyle', titleStyle))
      ..add(
          DiagnosticsProperty<TextStyle>('descriptionStyle', descriptionStyle))
      ..add(DiagnosticsProperty<TextStyle>('urlStyle', urlStyle))
      ..add(DiagnosticsProperty<TextStyle>('siteNameStyle', siteNameStyle))
      ..add(DiagnosticsProperty<BorderRadiusGeometry>(
          'borderRadius', borderRadius))
      ..add(DoubleProperty('elevation', elevation))
      ..add(DiagnosticsProperty<EdgeInsetsGeometry>('padding', padding))
      ..add(DoubleProperty('imageHeight', imageHeight))
      ..add(DoubleProperty('maxHeight', maxHeight))
      ..add(DoubleProperty('maxWidth', maxWidth))
      ..add(DiagnosticsProperty<BorderRadiusGeometry>(
          'imageBorderRadius', imageBorderRadius))
      ..add(ColorProperty('imagePlaceholderColor', imagePlaceholderColor))
      ..add(DoubleProperty('faviconSize', faviconSize))
      ..add(DoubleProperty('compactSpacing', compactSpacing))
      ..add(DiagnosticsProperty<EdgeInsetsGeometry>(
          'contentPadding', contentPadding))
      ..add(DiagnosticsProperty<ShapeBorder>('cardShape', cardShape))
      ..add(FlagProperty('showFavicon',
          value: showFavicon,
          ifTrue: 'showFavicon: true',
          ifFalse: 'showFavicon: false'))
      ..add(FlagProperty('showImage',
          value: showImage,
          ifTrue: 'showImage: true',
          ifFalse: 'showImage: false'));
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other.runtimeType != runtimeType) return false;
    return other is LinkPreviewThemeData &&
        other.backgroundColor == backgroundColor &&
        other.titleStyle == titleStyle &&
        other.descriptionStyle == descriptionStyle &&
        other.urlStyle == urlStyle &&
        other.siteNameStyle == siteNameStyle &&
        other.borderRadius == borderRadius &&
        other.elevation == elevation &&
        other.padding == padding &&
        other.imageHeight == imageHeight &&
        other.maxHeight == maxHeight &&
        other.maxWidth == maxWidth &&
        other.imageBorderRadius == imageBorderRadius &&
        other.imagePlaceholderColor == imagePlaceholderColor &&
        other.faviconSize == faviconSize &&
        other.compactSpacing == compactSpacing &&
        other.contentPadding == contentPadding &&
        other.cardShape == cardShape &&
        other.defaultImageErrorBuilder == defaultImageErrorBuilder &&
        other.defaultImageLoadingBuilder == defaultImageLoadingBuilder &&
        other.showFavicon == showFavicon &&
        other.showImage == showImage;
  }

  @override
  int get hashCode {
    return Object.hash(
      backgroundColor,
      titleStyle,
      descriptionStyle,
      urlStyle,
      siteNameStyle,
      borderRadius,
      elevation,
      padding,
      imageHeight,
      maxHeight,
      maxWidth,
      imageBorderRadius,
      imagePlaceholderColor,
      faviconSize,
      compactSpacing,
      contentPadding,
      cardShape,
      showFavicon,
      showImage,
      // Note: We don't include the builders in the hash code as they're functions
    );
  }
}
