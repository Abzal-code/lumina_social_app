// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'posts_controller.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(PostsController)
final postsControllerProvider = PostsControllerProvider._();

final class PostsControllerProvider
    extends $NotifierProvider<PostsController, PostsState> {
  PostsControllerProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'postsControllerProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$postsControllerHash();

  @$internal
  @override
  PostsController create() => PostsController();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(PostsState value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<PostsState>(value),
    );
  }
}

String _$postsControllerHash() => r'6b156aacc16bc61b2d046d770c8318c1fed8d54f';

abstract class _$PostsController extends $Notifier<PostsState> {
  PostsState build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<PostsState, PostsState>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<PostsState, PostsState>,
              PostsState,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}
