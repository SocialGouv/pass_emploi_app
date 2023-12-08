part of 'create_user_action_form_state.dart';

sealed class CreateActionTitleSource {
  bool get isFromSuggestions => this is CreateActionTitleFromSuggestions;
  bool get isFromUserInput => this is CreateActionTitleFromUserInput;
  bool get isNone => this is CreateActionTitleNone;

  String get title => switch (this) {
        CreateActionTitleNone() => "",
        CreateActionTitleFromSuggestions() => (this as CreateActionTitleFromSuggestions).suggestion,
        CreateActionTitleFromUserInput() => (this as CreateActionTitleFromUserInput).userInput,
      };
}

class CreateActionTitleNone extends CreateActionTitleSource {}

class CreateActionTitleFromSuggestions extends CreateActionTitleSource {
  final String suggestion;

  CreateActionTitleFromSuggestions(this.suggestion);
}

class CreateActionTitleFromUserInput extends CreateActionTitleSource {
  final String userInput;

  CreateActionTitleFromUserInput(this.userInput);
}

class CreateUserActionStep2State extends CreateUserActionPageState {
  final CreateActionTitleSource titleSource;
  final String? description;

  CreateUserActionStep2State({this.description, CreateActionTitleSource? titleSource})
      : titleSource = titleSource ?? CreateActionTitleNone();

  @override
  bool get isValid => switch (titleSource) {
        CreateActionTitleNone() => false,
        CreateActionTitleFromSuggestions() => true,
        CreateActionTitleFromUserInput() => (titleSource as CreateActionTitleFromUserInput).userInput.isNotEmpty,
      };

  @override
  List<Object?> get props => [description, titleSource];

  CreateUserActionStep2State copyWith({
    String? title,
    String? description,
    CreateActionTitleSource? titleSource,
  }) {
    return CreateUserActionStep2State(
      description: description ?? this.description,
      titleSource: titleSource ?? this.titleSource,
    );
  }
}
