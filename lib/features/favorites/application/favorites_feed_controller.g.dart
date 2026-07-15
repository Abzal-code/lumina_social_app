// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'favorites_feed_controller.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Resolves the favorited post IDs into [Post] entities, displayed in
/// ascending post ID order. Posts already loaded by the posts list are
/// reused; the rest are fetched individually and cached for the lifetime
/// of this controller.

@ProviderFor(FavoritesFeedController)
final favoritesFeedControllerProvider = FavoritesFeedControllerProvider._();

/// Resolves the favorited post IDs into [Post] entities, displayed in
/// ascending post ID order. Posts already loaded by the posts list are
/// reused; the rest are fetched individually and cached for the lifetime
/// of this controller.
final class FavoritesFeedControllerProvider
    extends $NotifierProvider<FavoritesFeedController, FavoritesFeedState> {
  /// Resolves the favorited post IDs into [Post] entities, displayed in
  /// ascending post ID order. Posts already loaded by the posts list are
  /// reused; the rest are fetched individually and cached for the lifetime
  /// of this controller.
  FavoritesFeedControllerProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'favoritesFeedControllerProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$favoritesFeedControllerHash();

  @$internal
  @override
  FavoritesFeedController create() => FavoritesFeedController();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(FavoritesFeedState value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<FavoritesFeedState>(value),
    );
  }
}

String _$favoritesFeedControllerHash() =>
    r'004bd1a64f410e030bc60aa2becc26f978b296ae';

/// Resolves the favorited post IDs into [Post] entities, displayed in
/// ascending post ID order. Posts already loaded by the posts list are
/// reused; the rest are fetched individually and cached for the lifetime
/// of this controller.

abstract class _$FavoritesFeedController extends $Notifier<FavoritesFeedState> {
  FavoritesFeedState build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<FavoritesFeedState, FavoritesFeedState>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<FavoritesFeedState, FavoritesFeedState>,
              FavoritesFeedState,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}
