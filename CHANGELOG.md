# CHANGELOG

## 2.0.3

- Discontinued `metalink_flutter` in favor of using `package:metalink` directly with application-owned Flutter widgets.
- Added a migration guide linked to the complete Flutter showcase for replacing the package's cards, controller, provider, and cache helpers.
- Preserved the existing runtime API in this final compatibility release so current applications can migrate on their own schedule.

## 2.0.2

- Removed the `flutter_helper_utils` dependency; the package now relies only on native Flutter APIs, reducing its dependency footprint.

## 2.0.1

- CHORE: Align publish workflow with Trusted Publisher OIDC.

## 2.0.0

- **BREAKING**: Migrated to `metalink` v2.0.0.
- **BREAKING**: Removed image optimization features (resizing) as they are no longer supported by the core library.
- Updated `MetadataProvider` to use `MetaLinkClient` and `HiveCacheStore` for improved caching and performance.
- Updated widgets to work with the new `ImageCandidate` model.

## 1.0.2

- CHORE: updated metalink to 1.0.4

## 1.0.1

- fixed bugs.
- CHORE: updated metalink to 1.0.3

## 1.0.0

- Initial Release
