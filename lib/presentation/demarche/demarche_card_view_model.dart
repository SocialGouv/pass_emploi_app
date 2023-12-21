import 'package:collection/collection.dart';
import 'package:equatable/equatable.dart';
import 'package:pass_emploi_app/models/demarche.dart';
import 'package:pass_emploi_app/presentation/demarche/demarche_state_source.dart';
import 'package:pass_emploi_app/presentation/demarche/demarche_view_model_helper.dart';
import 'package:pass_emploi_app/redux/app_state.dart';
import 'package:pass_emploi_app/ui/strings.dart';
import 'package:pass_emploi_app/utils/date_extensions.dart';
import 'package:pass_emploi_app/widgets/cards/base_cards/widgets/card_pillule.dart';
import 'package:redux/redux.dart';

class DemarcheCardViewModel extends Equatable {
  final String id;
  final String titre;
  final String? sousTitre;
  final DemarcheStatus status;
  final bool createdByAdvisor;
  final bool modifiedByAdvisor;
  final CardPilluleType? pilluleType;
  final String date;
  final bool isLate;

  DemarcheCardViewModel({
    required this.id,
    required this.titre,
    required this.sousTitre,
    required this.status,
    required this.createdByAdvisor,
    required this.modifiedByAdvisor,
    required this.pilluleType,
    required this.date,
    required this.isLate,
  });

  factory DemarcheCardViewModel.create({
    required Store<AppState> store,
    required DemarcheStateSource stateSource,
    required String demarcheId,
  }) {
    final demarche = getDemarche(store, stateSource, demarcheId);
    final isLate = _isLate(demarche);
    return DemarcheCardViewModel(
      id: demarche.id,
      titre: demarche.content ?? Strings.withoutContent,
      sousTitre: _description(demarche),
      status: demarche.status,
      createdByAdvisor: demarche.createdByAdvisor,
      modifiedByAdvisor: demarche.modifiedByAdvisor,
      pilluleType: _pillule(demarche, isLate),
      date: _dateFormat(demarche, isLate),
      isLate: isLate,
    );
  }

  @override
  List<Object?> get props => [
        id,
        titre,
        sousTitre,
        status,
        createdByAdvisor,
        modifiedByAdvisor,
        pilluleType,
        date,
        isLate,
      ];
}

String? _description(Demarche demarche) {
  return demarche.attributs.firstWhereOrNull((e) => e.key == 'description')?.value;
}

String _dateFormat(Demarche demarche, bool isLate) {
  final String formattedDate;
  if (demarche.status == DemarcheStatus.annulee && demarche.deletionDate != null) {
    formattedDate = demarche.deletionDate!.toDay();
  } else if (demarche.endDate != null) {
    formattedDate = demarche.endDate!.toDay();
  } else {
    formattedDate = Strings.withoutDate;
  }
  return formattedDate;
}

CardPilluleType? _pillule(Demarche demarche, bool isLate) {
  if (isLate) {
    return CardPilluleType.late;
  }
  return switch (demarche.status) {
    DemarcheStatus.annulee => CardPilluleType.canceled,
    DemarcheStatus.terminee => CardPilluleType.done,
    DemarcheStatus.enCours => CardPilluleType.doing,
    DemarcheStatus.pasCommencee => CardPilluleType.todo,
  };
}

bool _isLate(Demarche demarche) {
  if (demarche.endDate != null &&
      (demarche.status == DemarcheStatus.pasCommencee || demarche.status == DemarcheStatus.enCours)) {
    return demarche.endDate!.isBefore(DateTime.now()) && (demarche.endDate!.numberOfDaysUntilToday() > 0);
  }
  return false;
}
