// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'post_details_controller.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(PostDetailsController)
final postDetailsControllerProvider = PostDetailsControllerFamily._();

final class PostDetailsControllerProvider
    extends $NotifierProvider<PostDetailsController, PostDetailsState> {
  PostDetailsControllerProvider._({
    required PostDetailsControllerFamily super.from,
    required int super.argument,
  }) : super(
         retry: null,
         name: r'postDetailsControllerProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$postDetailsControllerHash();

  @override
  String toString() {
    return r'postDetailsControllerProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  PostDetailsController create() => PostDetailsController();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(PostDetailsState value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<PostDetailsState>(value),
    );
  }

  @override
  bool operator ==(Object other) {
    return other is PostDetailsControllerProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$postDetailsControllerHash() =>
    r'f51fb86f76da958db5d28b777a8680809ed1d2ca';

final class PostDetailsControllerFamily extends $Family
    with
        $ClassFamilyOverride<
          PostDetailsController,
          PostDetailsState,
          PostDetailsState,
          PostDetailsState,
          int
        > {
  PostDetailsControllerFamily._()
    : super(
        retry: null,
        name: r'postDetailsControllerProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  PostDetailsControllerProvider call(int postId) =>
      PostDetailsControllerProvider._(argument: postId, from: this);

  @override
  String toString() => r'postDetailsControllerProvider';
}

abstract class _$PostDetailsController extends $Notifier<PostDetailsState> {
  late final _$args = ref.$arg as int;
  int get postId => _$args;

  PostDetailsState build(int postId);
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<PostDetailsState, PostDetailsState>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<PostDetailsState, PostDetailsState>,
              PostDetailsState,
              Object?,
              Object?
            >;
    element.handleCreate(ref, () => build(_$args));
  }
}
