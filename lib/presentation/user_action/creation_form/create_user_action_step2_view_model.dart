part of 'create_user_action_form_view_model.dart';

sealed class CreateActionTitleSource {
  bool get isValid;
  String get title;
  String get descriptionHint;

  bool get isFromSuggestions => this is CreateActionTitleFromSuggestions;
  bool get isFromUserInput => this is CreateActionTitleFromUserInput;
  bool get isNone => this is CreateActionTitleNotInitialized;
  bool get isNotNone => this is! CreateActionTitleNotInitialized;
}

class CreateActionTitleNotInitialized extends CreateActionTitleSource {
  @override
  bool get isValid => false;

  @override
  String get title => "";

  @override
  String get descriptionHint => Strings.hintUserActionOther;
}

class CreateActionTitleFromSuggestions extends CreateActionTitleSource {
  final UserActionCategory suggestion;

  CreateActionTitleFromSuggestions(this.suggestion);

  @override
  bool get isValid => true;

  @override
  String get title => suggestion.value;

  @override
  String get descriptionHint => suggestion.hint;
}

class CreateActionTitleFromUserInput extends CreateActionTitleSource {
  final String userInput;

  CreateActionTitleFromUserInput(this.userInput);

  @override
  bool get isValid => userInput.trim().isNotEmpty;

  @override
  String get title => userInput;

  @override
  String get descriptionHint => Strings.hintUserActionOther;
}

class CreateUserActionStep2ViewModel extends CreateUserActionPageViewModel {
  final CreateActionTitleSource titleSource;
  final String? description;

  bool get showDescriptionField {
    if (titleSource.isNone) {
      return false;
    }

    return switch (titleSource) {
      final CreateActionTitleFromSuggestions titleSource => !titleSource.suggestion.allowBatchCreate,
      CreateActionTitleFromUserInput() => false,
      CreateActionTitleNotInitialized() => false,
    };
  }

  final GlobalKey titleInputKey = GlobalKey();
  final GlobalKey descriptionKey = GlobalKey();

  CreateUserActionStep2ViewModel({this.description, CreateActionTitleSource? titleSource})
      : titleSource = titleSource ?? CreateActionTitleNotInitialized();

  @override
  bool get isValid => titleSource.isValid;

  @override
  List<Object?> get props => [description, titleSource];

  CreateUserActionStep2ViewModel copyWith({
    String? title,
    String? description,
    CreateActionTitleSource? titleSource,
  }) {
    return CreateUserActionStep2ViewModel(
      description: description ?? this.description,
      titleSource: titleSource ?? this.titleSource,
    );
  }
}
