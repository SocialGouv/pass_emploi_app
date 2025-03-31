part of '../create_demarche_form_view_model.dart';

class CreateDemarche2FromThematiqueStep3ViewModel extends CreateDemarche2ViewModel {
  final DateInputSource dateSource;
  final CommentItem? commentItem;
  CreateDemarche2FromThematiqueStep3ViewModel({DateInputSource? initialDateInput, this.commentItem})
      : dateSource = initialDateInput ?? DateNotInitialized();

  @override
  List<Object?> get props => [dateSource];

  CreateDemarche2FromThematiqueStep3ViewModel copyWith({DateInputSource? dateSource, CommentItem? commentItem}) {
    return CreateDemarche2FromThematiqueStep3ViewModel(
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
