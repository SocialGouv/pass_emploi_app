part of '../create_demarche_form_view_model.dart';

class CreateDemarcheFromThematiqueStep3ViewModel extends CreateDemarcheViewModel {
  final DateInputSource dateSource;
  final CommentItem? commentItem;
  CreateDemarcheFromThematiqueStep3ViewModel({DateInputSource? initialDateInput, this.commentItem})
      : dateSource = initialDateInput ?? DateNotInitialized();

  @override
  List<Object?> get props => [dateSource];

  CreateDemarcheFromThematiqueStep3ViewModel copyWith({DateInputSource? dateSource, CommentItem? commentItem}) {
    return CreateDemarcheFromThematiqueStep3ViewModel(
      initialDateInput: dateSource ?? this.dateSource,
      commentItem: commentItem ?? this.commentItem,
    );
  }

  bool isValid(bool isCommentMandatory) {
    if (isCommentMandatory) {
      return dateSource.isValid && commentItem != null;
    }
    return dateSource.isValid;
  }
}
