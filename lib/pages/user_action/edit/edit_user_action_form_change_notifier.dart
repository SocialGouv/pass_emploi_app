import 'package:flutter/material.dart';
import 'package:pass_emploi_app/models/user_action_type.dart';
import 'package:pass_emploi_app/presentation/model/date_input_source.dart';

class EditUserActionFormChangeNotifier extends ChangeNotifier {
  DateInputSource dateInputSource;
  String title;
  String description;
  UserActionReferentielType? type;
  bool requireUpdate;

  EditUserActionFormChangeNotifier({
    required DateTime date,
    required this.title,
    required this.description,
    required this.type,
    required this.requireUpdate,
  }) : dateInputSource = DateFromPicker(date);

  void updateDate(DateInputSource dateSource) {
    dateInputSource = dateSource;
    notifyListeners();
  }

  void updateTitle(String title) {
    this.title = title;
    notifyListeners();
  }

  void updateDescription(String description) {
    this.description = description;
    notifyListeners();
  }

  void updateType(UserActionReferentielType? type) {
    if (type != null) {
      this.type = type;
      notifyListeners();
    }
  }

  @override
  void notifyListeners() {
    requireUpdate = false;
    super.notifyListeners();
  }

  bool canSave() => !requireUpdate && title.trim().isNotEmpty && dateInputSource.isValid;
}
