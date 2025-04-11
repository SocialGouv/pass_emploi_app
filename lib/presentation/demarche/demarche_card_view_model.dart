import 'package:equatable/equatable.dart';
import 'package:pass_emploi_app/models/demarche.dart';
import 'package:pass_emploi_app/presentation/demarche/demarche_store_extension.dart';
import 'package:pass_emploi_app/redux/app_state.dart';
import 'package:pass_emploi_app/ui/strings.dart';
import 'package:pass_emploi_app/utils/date_extensions.dart';
import 'package:pass_emploi_app/widgets/cards/base_cards/widgets/card_pillule.dart';
import 'package:redux/redux.dart';

class DemarcheCardViewModel extends Equatable {
  final String id;
  final String title;
  final String? categoryText;
  final CardPilluleType pillule;

  DemarcheCardViewModel({
    required this.id,
    required this.title,
    required this.categoryText,
    required this.pillule,
  });

  factory DemarcheCardViewModel.create({
    required Store<AppState> store,
    required String demarcheId,
  }) {
    final demarche = store.getDemarche(demarcheId);
    return DemarcheCardViewModel(
      id: demarche.id,
      title: demarche.content ?? Strings.withoutContent,
      categoryText: demarche.label,
      pillule: demarche.pillule(),
    );
  }

  @override
  List<Object?> get props => [
        id,
        title,
        categoryText,
        pillule,
      ];
}

extension DemarchePillule on Demarche {
  CardPilluleType pillule() {
    if (isLate()) return CardPilluleType.late;
    return switch (status) {
      DemarcheStatus.CANCELLED => CardPilluleType.canceled,
      DemarcheStatus.DONE => CardPilluleType.done,
      DemarcheStatus.IN_PROGRESS => CardPilluleType.doing,
      DemarcheStatus.NOT_STARTED => CardPilluleType.todo,
    };
  }

  bool isLate() {
    if (endDate != null && (status == DemarcheStatus.NOT_STARTED || status == DemarcheStatus.IN_PROGRESS)) {
      return endDate!.isBefore(DateTime.now()) && (endDate!.numberOfDaysUntilToday() > 0);
    }
    return false;
  }
}
