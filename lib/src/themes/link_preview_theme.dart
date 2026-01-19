import 'package:flutter/material.dart';
import 'package:metalink_flutter/src/themes/link_preview_theme_data.dart';

/// A theme extension for customizing link preview styles throughout an app
class LinkPreviewTheme extends ThemeExtension<LinkPreviewTheme> {
  /// Creates a [LinkPreviewTheme].
  const LinkPreviewTheme({
    required this.data,
  });

  /// The data representing the link preview styling
  final LinkPreviewThemeData data;

  /// Returns the [LinkPreviewThemeData] from the closest [LinkPreviewTheme]
  /// ancestor. If there is no ancestor, it returns the default theme data.
  static LinkPreviewThemeData of(BuildContext context) {
    final theme = Theme.of(context);
    final extension = theme.extension<LinkPreviewTheme>();

    // If no custom theme is provided through the theme extension,
    // return the default theme based on the current color scheme
    return extension?.data ??
        LinkPreviewThemeData.defaults(context, theme.colorScheme);
  }

  @override
  LinkPreviewTheme copyWith({
    LinkPreviewThemeData? data,
  }) {
    return LinkPreviewTheme(
      data: data ?? this.data,
    );
  }

  @override
  ThemeExtension<LinkPreviewTheme> lerp(
    ThemeExtension<LinkPreviewTheme>? other,
    double t,
  ) {
    if (other is! LinkPreviewTheme) {
      return this;
    }

    return LinkPreviewTheme(
      data: LinkPreviewThemeData.lerp(data, other.data, t),
    );
  }
}
