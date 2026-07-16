import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../core/error/app_failure.dart';
import '../domain/entities/post.dart';

part 'post_form_state.freezed.dart';

@freezed
abstract class PostFormState with _$PostFormState {
  const factory PostFormState({
    /// Post being edited; null in create mode.
    Post? initialPost,
    @Default(false) bool isLoadingPost,
    AppFailure? loadFailure,
    @Default(false) bool isSubmitting,
    AppFailure? submitFailure,
  }) = _PostFormState;
}
