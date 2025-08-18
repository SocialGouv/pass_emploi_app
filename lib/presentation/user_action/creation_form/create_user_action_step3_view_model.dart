part of 'create_user_action_form_view_model.dart';

class CreateUserActionStep3ViewModel extends CreateUserActionPageViewModel {
  static const minRappelInterval = Duration(days: 3);

  final List<DuplicatedUserAction> duplicatedUserActions;
  final bool errorsVisible;

  CreateUserActionStep3ViewModel({
    this.errorsVisible = false,
    List<DuplicatedUserAction>? initialDuplicatedUserActions,
  }) : duplicatedUserActions = initialDuplicatedUserActions ?? [DuplicatedUserAction.empty()];

  @override
  bool get isValid => duplicatedUserActions.every((action) => action.isValid);

  bool get canCreateMoreDuplicatedUserActions => duplicatedUserActions.length < 5;

  void updateDuplicatedUserAction(String id, {DateInputSource? dateSource, String? description}) {
    final index = duplicatedUserActions.indexWhere((action) => action.id == id);
    if (index != -1) {
      duplicatedUserActions[index] = duplicatedUserActions[index].copyWith(
        dateSource: dateSource,
        description: description,
      );
    }
  }

  void deleteDuplicatedUserAction(String id) {
    duplicatedUserActions.removeWhere((action) => action.id == id);
  }

  void addDuplicatedUserAction() {
    duplicatedUserActions.add(
      DuplicatedUserAction.empty(),
    );
  }

  CreateUserActionStep3ViewModel copyWith({
    bool? errorsVisible,
    List<DuplicatedUserAction>? duplicatedUserActions,
  }) {
    return CreateUserActionStep3ViewModel(
      errorsVisible: errorsVisible ?? this.errorsVisible,
      initialDuplicatedUserActions: duplicatedUserActions ?? this.duplicatedUserActions,
    );
  }

  @override
  List<Object?> get props => [duplicatedUserActions];
}

class DuplicatedUserAction extends Equatable {
  final String id;
  final DateInputSource dateSource;
  final String? description;

  DuplicatedUserAction({
    required this.id,
    required this.dateSource,
    required this.description,
  });

  factory DuplicatedUserAction.empty() => DuplicatedUserAction(
        id: Uuid().v4(),
        dateSource: DateNotInitialized(),
        description: null,
      );

  bool get isValid => isDateValid && isDescriptionValid;

  bool get isDateValid => dateSource.isValid;

  bool get isDescriptionValid => description?.isNotEmpty ?? false;

  DuplicatedUserAction copyWith({
    DateInputSource? dateSource,
    String? description,
  }) {
    return DuplicatedUserAction(
        id: id, dateSource: dateSource ?? this.dateSource, description: description ?? this.description);
  }

  @override
  List<Object?> get props => [id, dateSource, description];
}
