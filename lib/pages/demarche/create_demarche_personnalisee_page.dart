import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:pass_emploi_app/analytics/analytics_constants.dart';
import 'package:pass_emploi_app/analytics/tracker.dart';
import 'package:pass_emploi_app/features/demarche/create/create_demarche_actions.dart';
import 'package:pass_emploi_app/presentation/demarche/create_demarche_personnalisee_view_model.dart';
import 'package:pass_emploi_app/presentation/demarche/demarche_creation_state.dart';
import 'package:pass_emploi_app/presentation/display_state.dart';
import 'package:pass_emploi_app/redux/app_state.dart';
import 'package:pass_emploi_app/ui/app_colors.dart';
import 'package:pass_emploi_app/ui/app_icons.dart';
import 'package:pass_emploi_app/ui/dimens.dart';
import 'package:pass_emploi_app/ui/strings.dart';
import 'package:pass_emploi_app/ui/text_styles.dart';
import 'package:pass_emploi_app/widgets/a11y/mandatory_fields_label.dart';
import 'package:pass_emploi_app/widgets/buttons/primary_action_button.dart';
import 'package:pass_emploi_app/widgets/date_pickers/date_picker.dart';
import 'package:pass_emploi_app/widgets/default_app_bar.dart';
import 'package:pass_emploi_app/widgets/errors/error_text.dart';
import 'package:pass_emploi_app/widgets/text_form_fields/base_text_form_field.dart';

class CreateDemarchePersonnaliseePage extends StatefulWidget {
  static MaterialPageRoute<String?> materialPageRoute() {
    return MaterialPageRoute(builder: (context) => CreateDemarchePersonnaliseePage());
  }

  @override
  State<CreateDemarchePersonnaliseePage> createState() => _CreateDemarchePageState();
}

class _CreateDemarchePageState extends State<CreateDemarchePersonnaliseePage> {
  @override
  Widget build(BuildContext context) {
    return Tracker(
      tracking: AnalyticsScreenNames.createDemarchePersonnalisee,
      child: Scaffold(
        appBar: SecondaryAppBar(title: Strings.createDemarcheTitle),
        body: DemarchePersonnaliseeForm(
          onCreateDemarcheSuccess: (demarcheId) => Navigator.pop(context, demarcheId),
          createDemarcheLabel: Strings.addALaDemarche,
        ),
      ),
    );
  }
}

class DemarchePersonnaliseeForm extends StatelessWidget {
  const DemarchePersonnaliseeForm({
    super.key,
    required this.onCreateDemarcheSuccess,
    required this.createDemarcheLabel,
  });
  final void Function(String demarcheId) onCreateDemarcheSuccess;
  final String createDemarcheLabel;

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, CreateDemarchePersonnaliseeViewModel>(
      builder: (_, viewModel) => _Body(viewModel: viewModel, createDemarcheLabel: createDemarcheLabel),
      converter: (store) => CreateDemarchePersonnaliseeViewModel.create(store),
      onDidChange: (oldVm, newVm) => _onDidChange(context, oldVm, newVm),
      onDispose: (store) => store.dispatch(CreateDemarcheResetAction()),
      distinct: true,
    );
  }

  void _onDidChange(
      BuildContext context, CreateDemarchePersonnaliseeViewModel? oldVm, CreateDemarchePersonnaliseeViewModel newVm) {
    final creationState = newVm.demarcheCreationState;
    if (creationState is DemarcheCreationSuccessState) {
      onCreateDemarcheSuccess(creationState.demarcheCreatedId);
    }
  }
}

class _Body extends StatefulWidget {
  final CreateDemarchePersonnaliseeViewModel viewModel;
  final String createDemarcheLabel;
  const _Body({required this.viewModel, required this.createDemarcheLabel});

  @override
  State<_Body> createState() => _BodyState();
}

class _BodyState extends State<_Body> {
  String _commentaire = "";
  DateTime? _dateEcheance;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _PremierTitre(),
          _SecondTitre(),
          _Separateur(),
          _CommentaireTitre(),
          _DescriptionTitre(),
          _NombreCaracteresRegle(_isCommentaireValid()),
          _ChampCommentaire((query) {
            setState(() {
              _commentaire = query;
            });
          }, _isCommentaireValid()),
          _NombreCaracteresCompteur(_commentaire.length, _isCommentaireValid()),
          if (!_isCommentaireValid()) _MessageError(),
          _Separateur2(),
          _QuandTitre(),
          _EcheanceTitre(),
          Padding(
            padding: const EdgeInsets.only(right: 24, left: 24, top: 12),
            child: DatePicker(
              onDateSelected: (date) {
                setState(() {
                  _dateEcheance = date;
                });
              },
              initialDateValue: _dateEcheance,
              isActiveDate: true,
            ),
          ),
          if (widget.viewModel.displayState == DisplayState.FAILURE) ErrorText(Strings.genericCreationError),
          Padding(
            padding: const EdgeInsets.only(right: 24, left: 24, top: 32),
            child: PrimaryActionButton(
              label: widget.createDemarcheLabel,
              onPressed: _buttonShouldBeActive(widget.viewModel)
                  ? () => widget.viewModel.onCreateDemarche(_commentaire, _dateEcheance!)
                  : null,
            ),
          ),
          SizedBox(height: 20),
        ],
      ),
    );
  }

  bool _buttonShouldBeActive(CreateDemarchePersonnaliseeViewModel viewModel) {
    return _isFormValid() && viewModel.displayState != DisplayState.LOADING;
  }

  bool _isCommentaireValid() {
    return _commentaire.length <= 255;
  }

  bool _isFormValid() {
    return _isCommentaireValid() && _commentaire.isNotEmpty && _dateEcheance != null;
  }
}

class _PremierTitre extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 24, right: 24, top: 16),
      child: Text(
        Strings.createDemarchePersonnalisee,
        style: TextStyles.textBaseBoldWithColor(AppColors.primary),
      ),
    );
  }
}

class _SecondTitre extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 24, right: 24, top: 12),
      child: MandatoryFieldsLabel.all(),
    );
  }
}

class _Separateur extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 24, right: 24, top: 32),
      child: Container(
        color: AppColors.primaryLighten,
        height: 2,
      ),
    );
  }
}

class _CommentaireTitre extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 24, right: 24, top: 24),
      child: Text(
        Strings.commentaire,
        style: TextStyles.textBaseBold,
      ),
    );
  }
}

class _DescriptionTitre extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 24, right: 24, top: 24),
      child: Text(
        Strings.descriptionDemarche,
        style: TextStyles.textBaseMedium,
      ),
    );
  }
}

class _NombreCaracteresRegle extends StatelessWidget {
  final bool _isCommentaireValid;

  _NombreCaracteresRegle(this._isCommentaireValid);

  @override
  Widget build(BuildContext context) {
    final textColor = _isCommentaireValid ? AppColors.contentColor : AppColors.warning;
    return Align(
      alignment: Alignment.centerRight,
      child: Padding(
        padding: const EdgeInsets.only(right: 24, top: 8),
        child: Text(
          Strings.caracteres255,
          style: TextStyles.textXsRegular(color: textColor),
        ),
      ),
    );
  }
}

class _Separateur2 extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 24, right: 24, top: 32),
      child: Container(
        color: AppColors.primaryLighten,
        height: 2,
      ),
    );
  }
}

class _QuandTitre extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 24, right: 24, top: 24),
      child: Text(
        Strings.quand,
        style: TextStyles.textBaseBold,
      ),
    );
  }
}

class _EcheanceTitre extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 24, right: 24, top: 24),
      child: Text(
        Strings.selectEcheance,
        style: TextStyles.textBaseMedium,
      ),
    );
  }
}

class _NombreCaracteresCompteur extends StatelessWidget {
  final int _nombreCarateres;
  final bool _isCommentaireValid;

  _NombreCaracteresCompteur(this._nombreCarateres, this._isCommentaireValid);

  @override
  Widget build(BuildContext context) {
    final textColor = _isCommentaireValid ? AppColors.contentColor : AppColors.warning;
    return Align(
      alignment: Alignment.centerRight,
      child: Padding(
        padding: const EdgeInsets.only(right: 24, top: 8),
        child: Text(
          "$_nombreCarateres/255",
          style: TextStyles.textXsRegular(color: textColor),
        ),
      ),
    );
  }
}

class _ChampCommentaire extends StatelessWidget {
  final Function(String) _onChanged;
  final bool _isCommentaireValid;

  _ChampCommentaire(this._onChanged, this._isCommentaireValid);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 24, left: 24, top: 8),
      child: BaseTextField(
        onChanged: _onChanged,
        minLines: null,
        maxLines: null,
        isInvalid: !_isCommentaireValid,
      ),
    );
  }
}

class _MessageError extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 24, right: 24, top: 24),
      child: Row(
        mainAxisSize: MainAxisSize.max,
        children: [
          Icon(
            AppIcons.error_rounded,
            size: Dimens.icon_size_m,
            color: AppColors.warning,
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(left: 13),
              child: Text(
                Strings.addAMessageError,
                style: TextStyles.textBaseMediumWithColor(AppColors.warning),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
