// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'favorites_feed_controller.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Resolves favorite IDs into cached posts ordered by post ID.

@ProviderFor(FavoritesFeedController)
final favoritesFeedControllerProvider = FavoritesFeedControllerProvider._();

/// Resolves favorite IDs into cached posts ordered by post ID.
final class FavoritesFeedControllerProvider
    extends $NotifierProvider<FavoritesFeedController, FavoritesFeedState> {
  /// Resolves favorite IDs into cached posts ordered by post ID.
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
    r'a0f9abf8d6b79509e7590f432a3395df536f1920';

/// Resolves favorite IDs into cached posts ordered by post ID.

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
