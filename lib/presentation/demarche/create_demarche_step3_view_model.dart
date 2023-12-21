import 'package:equatable/equatable.dart';
import 'package:pass_emploi_app/features/demarche/create/create_demarche_actions.dart';
import 'package:pass_emploi_app/features/demarche/create/create_demarche_state.dart';
import 'package:pass_emploi_app/models/demarche_du_referentiel.dart';
import 'package:pass_emploi_app/presentation/demarche/demarche_creation_state.dart';
import 'package:pass_emploi_app/presentation/demarche/demarche_source.dart';
import 'package:pass_emploi_app/presentation/display_state.dart';
import 'package:pass_emploi_app/redux/app_state.dart';
import 'package:redux/redux.dart';

class CreateDemarcheStep3ViewModel extends Equatable {
  final DisplayState displayState;
  final DemarcheCreationState demarcheCreationState;
  final String pourquoi;
  final String quoi;
  final bool isCommentMandatory;
  final List<CommentItem> comments;
  final Function(String? codeComment, DateTime endDate) onCreateDemarche;

  CreateDemarcheStep3ViewModel({
    required this.displayState,
    required this.demarcheCreationState,
    required this.pourquoi,
    required this.quoi,
    required this.isCommentMandatory,
    required this.comments,
    required this.onCreateDemarche,
  });

  factory CreateDemarcheStep3ViewModel.create(Store<AppState> store, String idDemarche, DemarcheSource source) {
    final demarche = source.demarche(store, idDemarche);
    if (demarche != null) {
      return CreateDemarcheStep3ViewModel(
        displayState: _displayState(store),
        demarcheCreationState: _demarcheCreationState(store),
        pourquoi: demarche.pourquoi,
        quoi: demarche.quoi,
        isCommentMandatory: demarche.comments.length != 1 ? demarche.isCommentMandatory : false,
        comments: _comments(demarche.comments),
        onCreateDemarche: (codeComment, endDate) => {
          store.dispatch(
            CreateDemarcheRequestAction(
              codeQuoi: demarche.codeQuoi,
              codePourquoi: demarche.codePourquoi,
              codeComment: codeComment,
              dateEcheance: endDate,
            ),
          )
        },
      );
    }
    return CreateDemarcheStep3ViewModel(
      displayState: DisplayState.erreur,
      demarcheCreationState: DemarcheCreationPendingState(),
      pourquoi: '',
      quoi: '',
      isCommentMandatory: false,
      comments: _comments([]),
      onCreateDemarche: (_, __) => {},
    );
  }

  @override
  List<Object?> get props => [displayState, demarcheCreationState, pourquoi, quoi, isCommentMandatory, comments];
}

DisplayState _displayState(Store<AppState> store) {
  if (store.state.createDemarcheState is CreateDemarcheFailureState) return DisplayState.erreur;
  if (store.state.createDemarcheState is CreateDemarcheLoadingState) return DisplayState.chargement;
  return DisplayState.contenu;
}

DemarcheCreationState _demarcheCreationState(Store<AppState> store) {
  final createState = store.state.createDemarcheState;
  return createState is CreateDemarcheSuccessState
      ? DemarcheCreationSuccessState(createState.demarcheCreatedId)
      : DemarcheCreationPendingState();
}

List<CommentItem> _comments(List<Comment> comments) {
  if (comments.length == 1) return [CommentTextItem(label: comments.first.label, code: comments.first.code)];
  return comments.map((comment) => CommentRadioButtonItem(label: comment.label, code: comment.code)).toList();
}

abstract class CommentItem extends Equatable {
  final String label;
  final String code;

  CommentItem({required this.label, required this.code});

  @override
  List<Object?> get props => [label, code];
}

class CommentTextItem extends CommentItem {
  CommentTextItem({required super.label, required super.code});
}

class CommentRadioButtonItem extends CommentItem {
  CommentRadioButtonItem({required super.label, required super.code});
}
