import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../core/error/app_failure.dart';

part 'delete_post_state.freezed.dart';

@freezed
abstract class DeletePostState with _$DeletePostState {
  const factory DeletePostState({
    @Default(false) bool isDeleting,
    AppFailure? failure,
  }) = _DeletePostState;
}
