import 'package:pass_emploi_app/presentation/demarche/create_demarche_step3_view_model.dart';
import 'package:pass_emploi_app/presentation/demarche/demarche_source.dart';
import 'package:pass_emploi_app/redux/app_state.dart';
import 'package:redux/redux.dart';

class CreateDemarche2FromReferentielStep3ViewModel {
  final bool isCommentMandatory;
  final List<CommentItem> comments;

  CreateDemarche2FromReferentielStep3ViewModel({
    required this.isCommentMandatory,
    required this.comments,
  });

  factory CreateDemarche2FromReferentielStep3ViewModel.create(
      Store<AppState> store, String idDemarche, String thematiqueCode) {
    final thematiqueSource = ThematiqueDemarcheSource(thematiqueCode);
    final demarche = thematiqueSource.demarche(store, idDemarche);

    if (demarche == null) {
      return CreateDemarche2FromReferentielStep3ViewModel(
        comments: [],
        isCommentMandatory: false,
      );
    }

    return CreateDemarche2FromReferentielStep3ViewModel(
      isCommentMandatory: demarche.comments.isNotEmpty ? demarche.isCommentMandatory : false,
      comments: demarche.comments.map((comment) => CommentTextItem(label: comment.label, code: comment.code)).toList(),
    );
  }
}
