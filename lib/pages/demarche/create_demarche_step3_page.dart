import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:matomo_tracker/matomo_tracker.dart';
import 'package:pass_emploi_app/analytics/analytics_constants.dart';
import 'package:pass_emploi_app/analytics/tracker.dart';
import 'package:pass_emploi_app/features/demarche/create/create_demarche_actions.dart';
import 'package:pass_emploi_app/presentation/demarche/create_demarche_step3_view_model.dart';
import 'package:pass_emploi_app/presentation/display_state.dart';
import 'package:pass_emploi_app/redux/app_state.dart';
import 'package:pass_emploi_app/ui/app_colors.dart';
import 'package:pass_emploi_app/ui/font_sizes.dart';
import 'package:pass_emploi_app/ui/margins.dart';
import 'package:pass_emploi_app/ui/strings.dart';
import 'package:pass_emploi_app/ui/text_styles.dart';
import 'package:pass_emploi_app/widgets/buttons/primary_action_button.dart';
import 'package:pass_emploi_app/widgets/date_pickers/date_picker.dart';
import 'package:pass_emploi_app/widgets/default_app_bar.dart';
import 'package:pass_emploi_app/widgets/errors/error_text.dart';
import 'package:pass_emploi_app/widgets/sepline.dart';
import 'package:pass_emploi_app/widgets/snack_bar/show_snack_bar.dart';
import 'package:pass_emploi_app/widgets/tags/status_tag.dart';

class CreateDemarcheStep3Page extends StatefulWidget {
  final String idDemarche;

  CreateDemarcheStep3Page._(this.idDemarche);

  static MaterialPageRoute<void> materialPageRoute(String idDemarche) {
    return MaterialPageRoute(builder: (context) => CreateDemarcheStep3Page._(idDemarche));
  }

  @override
  State<CreateDemarcheStep3Page> createState() => _CreateDemarcheStep3PageState();
}

class _CreateDemarcheStep3PageState extends State<CreateDemarcheStep3Page> {
  String? _codeComment;
  DateTime? _endDate;

  @override
  Widget build(BuildContext context) {
    return Tracker(
      tracking: AnalyticsScreenNames.searchDemarcheStep3,
      child: StoreConnector<AppState, CreateDemarcheStep3ViewModel>(
        builder: _buildBody,
        converter: (store) => CreateDemarcheStep3ViewModel.create(store, widget.idDemarche),
        onDidChange: _onDidChange,
        onDispose: (store) => store.dispatch(CreateDemarcheResetAction()),
        distinct: true,
      ),
    );
  }

  Widget _buildBody(BuildContext context, CreateDemarcheStep3ViewModel viewModel) {
    return Scaffold(
      appBar: passEmploiAppBar(label: Strings.createDemarcheTitle, context: context),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(Margins.spacing_m),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              StatutTag(
                backgroundColor: AppColors.accent2Lighten,
                textColor: AppColors.accent2,
                title: viewModel.pourquoi,
              ),
              SizedBox(height: Margins.spacing_s),
              Text(viewModel.quoi, style: TextStyles.textBaseBoldWithColor(AppColors.primary)),
              if (viewModel.isCommentMandatory) _Mandatory(),
              if (viewModel.comments.isNotEmpty) _Section(Strings.comment),
              if (viewModel.isCommentMandatory) _SelectLabel(Strings.selectComment),
              ..._buildComments(viewModel.comments),
              _Section(Strings.quand),
              _SelectLabel(Strings.selectQuand),
              DatePicker(
                onValueChange: (date) {
                  setState(() {
                    _endDate = date;
                  });
                },
                initialDateValue: _endDate,
                isActiveDate: true,
              ),
              SizedBox(height: Margins.spacing_xl),
              if (viewModel.displayState == DisplayState.FAILURE) ErrorText(Strings.genericCreationError),
              Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  PrimaryActionButton(
                    label: Strings.addALaDemarche,
                    onPressed:
                        _buttonIsActive(viewModel) ? () => viewModel.onCreateDemarche(_codeComment, _endDate!) : null,
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }

  void _onDidChange(CreateDemarcheStep3ViewModel? oldVm, CreateDemarcheStep3ViewModel newVm) {
    if (newVm.shouldGoBack) {
      Navigator.popUntil(context, (route) => route.settings.name == Navigator.defaultRouteName);
      MatomoTracker.instance.trackScreen(context, eventName: AnalyticsScreenNames.searchDemarcheStep3Success);
      showSuccessfulSnackBar(context, Strings.demarcheCreationSuccess);
    }
  }

  bool _buttonIsActive(CreateDemarcheStep3ViewModel viewModel) {
    return viewModel.displayState != DisplayState.LOADING &&
        _endDate != null &&
        (_codeComment != null || !viewModel.isCommentMandatory);
  }

  List<Widget> _buildComments(List<CommentItem> comments) {
    return comments.map((comment) {
      if (comment is CommentTextItem) {
        _codeComment = comment.code;
        return Text(comment.label, style: TextStyles.textBaseBold);
      }
      return RadioListTile<String>(
          controlAffinity: ListTileControlAffinity.trailing,
          title: Text(comment.label),
          contentPadding: const EdgeInsets.all(0),
          value: comment.code,
          groupValue: _codeComment,
          onChanged: (value) {
            setState(() {
              _codeComment = value;
            });
          });
    }).toList();
  }
}

class _Mandatory extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: Margins.spacing_l),
      child: Text(Strings.mandatoryFields, style: TextStyles.textSRegular()),
    );
  }
}

class _SelectLabel extends StatelessWidget {
  final String _label;

  const _SelectLabel(this._label);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: Margins.spacing_l),
      child: Text(_label, style: TextStyles.textSRegular()),
    );
  }
}

class _Section extends StatelessWidget {
  final String _section;

  const _Section(this._section);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: Margins.spacing_m),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          RichText(
            text: TextSpan(
              children: [
                TextSpan(
                  text: '•',
                  style: TextStyle(color: AppColors.primary, fontSize: FontSizes.huge, fontWeight: FontWeight.w900),
                ),
                WidgetSpan(child: SizedBox(width: Margins.spacing_base)),
                TextSpan(text: _section, style: TextStyles.textMBold),
              ],
            ),
          ),
          SepLine(Margins.spacing_m, Margins.spacing_m),
        ],
      ),
    );
  }
}
