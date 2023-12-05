part of 'create_user_action_form_state.dart';

class CreateUserActionStep2State extends CreateUserActionPageState {
  final String? title;
  final String? description;

  CreateUserActionStep2State({this.title, this.description});

  @override
  bool get isValid => title != null;

  @override
  List<Object?> get props => [title, description];

  CreateUserActionStep2State copyWith({
    String? title,
    String? description,
  }) {
    return CreateUserActionStep2State(
      title: title ?? this.title,
      description: description ?? this.description,
    );
  }
}
