// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'delete_post_controller.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(DeletePostController)
final deletePostControllerProvider = DeletePostControllerProvider._();

final class DeletePostControllerProvider
    extends $NotifierProvider<DeletePostController, DeletePostState> {
  DeletePostControllerProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'deletePostControllerProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$deletePostControllerHash();

  @$internal
  @override
  DeletePostController create() => DeletePostController();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(DeletePostState value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<DeletePostState>(value),
    );
  }
}

String _$deletePostControllerHash() =>
    r'2eea23e9d29063bc8e509afb38bf6a62f5636df4';

abstract class _$DeletePostController extends $Notifier<DeletePostState> {
  DeletePostState build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<DeletePostState, DeletePostState>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<DeletePostState, DeletePostState>,
              DeletePostState,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}
