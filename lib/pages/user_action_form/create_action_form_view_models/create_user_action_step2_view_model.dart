part of 'create_user_action_form_view_model.dart';

sealed class CreateActionTitleSource {
  bool get isFromSuggestions => this is CreateActionTitleFromSuggestions;
  bool get isFromUserInput => this is CreateActionTitleFromUserInput;
  bool get isNone => this is CreateActionTitleNotInitialized;

  String get title => switch (this) {
        CreateActionTitleNotInitialized() => "",
        CreateActionTitleFromSuggestions() => (this as CreateActionTitleFromSuggestions).suggestion,
        CreateActionTitleFromUserInput() => (this as CreateActionTitleFromUserInput).userInput,
      };
}

class CreateActionTitleNotInitialized extends CreateActionTitleSource {}

class CreateActionTitleFromSuggestions extends CreateActionTitleSource {
  final String suggestion;

  CreateActionTitleFromSuggestions(this.suggestion);
}

class CreateActionTitleFromUserInput extends CreateActionTitleSource {
  final String userInput;

  CreateActionTitleFromUserInput(this.userInput);
}

class CreateUserActionStep2ViewModel extends CreateUserActionPageState {
  final CreateActionTitleSource titleSource;
  final String? description;

  CreateUserActionStep2ViewModel({this.description, CreateActionTitleSource? titleSource})
      : titleSource = titleSource ?? CreateActionTitleNotInitialized();

  @override
  bool get isValid => switch (titleSource) {
        // TODO: déplacer la logique de isValid dans le CreateActionTitleSource
        CreateActionTitleNotInitialized() => false,
        CreateActionTitleFromSuggestions() => true,
        CreateActionTitleFromUserInput() => (titleSource as CreateActionTitleFromUserInput).userInput.isNotEmpty,
      };

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
