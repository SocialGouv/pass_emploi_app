part of 'create_user_action_form_view_model.dart';

sealed class CreateActionTitleSource {
  bool get isValid;

  bool get isFromSuggestions => this is CreateActionTitleFromSuggestions;
  bool get isFromUserInput => this is CreateActionTitleFromUserInput;
  bool get isNone => this is CreateActionTitleNotInitialized;

  String get title => switch (this) {
        CreateActionTitleNotInitialized() => "",
        CreateActionTitleFromSuggestions() => (this as CreateActionTitleFromSuggestions).suggestion,
        CreateActionTitleFromUserInput() => (this as CreateActionTitleFromUserInput).userInput,
      };
}

class CreateActionTitleNotInitialized extends CreateActionTitleSource {
  @override
  bool get isValid => false;
}

class CreateActionTitleFromSuggestions extends CreateActionTitleSource {
  final String suggestion;

  CreateActionTitleFromSuggestions(this.suggestion);

  @override
  bool get isValid => true;
}

class CreateActionTitleFromUserInput extends CreateActionTitleSource {
  final String userInput;

  CreateActionTitleFromUserInput(this.userInput);

  @override
  bool get isValid => userInput.trim().isNotEmpty;
}

class CreateUserActionStep2ViewModel extends CreateUserActionPageState {
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
