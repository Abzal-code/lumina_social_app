// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'post_form_controller.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Owns submission state for the post form; [postId] is null in create mode.

@ProviderFor(PostFormController)
final postFormControllerProvider = PostFormControllerFamily._();

/// Owns submission state for the post form; [postId] is null in create mode.
final class PostFormControllerProvider
    extends $NotifierProvider<PostFormController, PostFormState> {
  /// Owns submission state for the post form; [postId] is null in create mode.
  PostFormControllerProvider._({
    required PostFormControllerFamily super.from,
    required int? super.argument,
  }) : super(
         retry: null,
         name: r'postFormControllerProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$postFormControllerHash();

  @override
  String toString() {
    return r'postFormControllerProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  PostFormController create() => PostFormController();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(PostFormState value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<PostFormState>(value),
    );
  }

  @override
  bool operator ==(Object other) {
    return other is PostFormControllerProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$postFormControllerHash() =>
    r'57fdc24529408b1866ca495040bfda88605641a6';

/// Owns submission state for the post form; [postId] is null in create mode.

final class PostFormControllerFamily extends $Family
    with
        $ClassFamilyOverride<
          PostFormController,
          PostFormState,
          PostFormState,
          PostFormState,
          int?
        > {
  PostFormControllerFamily._()
    : super(
        retry: null,
        name: r'postFormControllerProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  /// Owns submission state for the post form; [postId] is null in create mode.

  PostFormControllerProvider call(int? postId) =>
      PostFormControllerProvider._(argument: postId, from: this);

  @override
  String toString() => r'postFormControllerProvider';
}

/// Owns submission state for the post form; [postId] is null in create mode.

abstract class _$PostFormController extends $Notifier<PostFormState> {
  late final _$args = ref.$arg as int?;
  int? get postId => _$args;

  PostFormState build(int? postId);
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<PostFormState, PostFormState>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<PostFormState, PostFormState>,
              PostFormState,
              Object?,
              Object?
            >;
    element.handleCreate(ref, () => build(_$args));
  }
}
