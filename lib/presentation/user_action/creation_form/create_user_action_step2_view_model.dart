part of 'create_user_action_form_view_model.dart';

sealed class CreateActionTitleSource {
  bool get isValid;
  String get title;

  bool get isFromSuggestions => this is CreateActionTitleFromSuggestions;
  bool get isFromUserInput => this is CreateActionTitleFromUserInput;
  bool get isNone => this is CreateActionTitleNotInitialized;
}

class CreateActionTitleNotInitialized extends CreateActionTitleSource {
  @override
  bool get isValid => false;

  @override
  String get title => "";
}

class CreateActionTitleFromSuggestions extends CreateActionTitleSource {
  final String suggestion;

  CreateActionTitleFromSuggestions(this.suggestion);

  @override
  bool get isValid => true;

  @override
  String get title => suggestion;
}

class CreateActionTitleFromUserInput extends CreateActionTitleSource {
  final String userInput;

  CreateActionTitleFromUserInput(this.userInput);

  @override
  bool get isValid => userInput.trim().isNotEmpty;

  @override
  String get title => userInput;
}

class CreateUserActionStep2ViewModel extends CreateUserActionPageViewModel {
  final CreateActionTitleSource titleSource;
  final String? description;

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
