// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_profile_controller.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(UserProfileController)
final userProfileControllerProvider = UserProfileControllerFamily._();

final class UserProfileControllerProvider
    extends $NotifierProvider<UserProfileController, UserProfileState> {
  UserProfileControllerProvider._({
    required UserProfileControllerFamily super.from,
    required int super.argument,
  }) : super(
         retry: null,
         name: r'userProfileControllerProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$userProfileControllerHash();

  @override
  String toString() {
    return r'userProfileControllerProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  UserProfileController create() => UserProfileController();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(UserProfileState value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<UserProfileState>(value),
    );
  }

  @override
  bool operator ==(Object other) {
    return other is UserProfileControllerProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$userProfileControllerHash() =>
    r'1f0a8fa131be04fefa150dbb3dc15e5f11503a7f';

final class UserProfileControllerFamily extends $Family
    with
        $ClassFamilyOverride<
          UserProfileController,
          UserProfileState,
          UserProfileState,
          UserProfileState,
          int
        > {
  UserProfileControllerFamily._()
    : super(
        retry: null,
        name: r'userProfileControllerProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  UserProfileControllerProvider call(int userId) =>
      UserProfileControllerProvider._(argument: userId, from: this);

  @override
  String toString() => r'userProfileControllerProvider';
}

abstract class _$UserProfileController extends $Notifier<UserProfileState> {
  late final _$args = ref.$arg as int;
  int get userId => _$args;

  UserProfileState build(int userId);
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<UserProfileState, UserProfileState>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<UserProfileState, UserProfileState>,
              UserProfileState,
              Object?,
              Object?
            >;
    element.handleCreate(ref, () => build(_$args));
  }
}
