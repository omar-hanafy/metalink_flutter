import 'package:flutter/material.dart';

import 'package:metalink_flutter/src/themes/link_preview_theme.dart';
import 'package:metalink_flutter/src/themes/link_preview_theme_data.dart';

/// Extensions on [BuildContext] to easily access link preview theming
extension LinkPreviewThemeExtension on BuildContext {
  /// Returns the [LinkPreviewThemeData] from the current theme.
  LinkPreviewThemeData get linkPreviewTheme => LinkPreviewTheme.of(this);

  /// Convenient access to theme properties specifically for link previews
  Color get linkPreviewBackground =>
      linkPreviewTheme.backgroundColor ?? Theme.of(this).colorScheme.surface;

  /// title style for the link preview widget.
  TextStyle? get linkPreviewTitleStyle => linkPreviewTheme.titleStyle;

  /// description style for the link preview widget.
  TextStyle? get linkPreviewDescriptionStyle =>
      linkPreviewTheme.descriptionStyle;

  /// url style for the link preview widget.
  TextStyle? get linkPreviewUrlStyle => linkPreviewTheme.urlStyle;

  /// border radius to be applied for the link preview widget.
  BorderRadiusGeometry get linkPreviewBorderRadius =>
      linkPreviewTheme.borderRadius ?? BorderRadius.circular(12.0);

  /// elevation to be applied for the link preview widget.
  double get linkPreviewElevation => linkPreviewTheme.elevation ?? 0.0;
}

/// Add theme extension methods to ThemeData
extension ThemeDataExtensions on ThemeData {
  /// Gets the link preview theme from this theme.
  LinkPreviewThemeData get linkPreviewTheme {
    return extension<LinkPreviewTheme>()?.data ??
        LinkPreviewThemeData.defaults(
          _FakeContext(this),
          colorScheme,
        );
  }

  /// Returns a copy of this theme with the link preview theme extension applied.
  ThemeData withLinkPreviewTheme(LinkPreviewThemeData data) {
    final existingExtensions =
        extensions.values.where((ext) => ext is! LinkPreviewTheme);
    return copyWith(
      extensions: [
        ...existingExtensions,
        LinkPreviewTheme(data: data),
      ],
    );
  }
}

/// A fake context that provides just enough for the theme data to work with
class _FakeContext implements BuildContext {
  _FakeContext(this._theme);

  final ThemeData _theme;

  ThemeData get theme => _theme;

  // Implement all required BuildContext methods
  // Only minimal implementation needed for theme access
  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}
