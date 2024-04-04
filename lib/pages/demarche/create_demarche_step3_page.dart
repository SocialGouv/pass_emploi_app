import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:pass_emploi_app/analytics/analytics_constants.dart';
import 'package:pass_emploi_app/analytics/tracker.dart';
import 'package:pass_emploi_app/features/demarche/create/create_demarche_actions.dart';
import 'package:pass_emploi_app/presentation/demarche/create_demarche_step3_view_model.dart';
import 'package:pass_emploi_app/presentation/demarche/demarche_creation_state.dart';
import 'package:pass_emploi_app/presentation/demarche/demarche_source.dart';
import 'package:pass_emploi_app/presentation/display_state.dart';
import 'package:pass_emploi_app/redux/app_state.dart';
import 'package:pass_emploi_app/ui/app_colors.dart';
import 'package:pass_emploi_app/ui/font_sizes.dart';
import 'package:pass_emploi_app/ui/margins.dart';
import 'package:pass_emploi_app/ui/strings.dart';
import 'package:pass_emploi_app/ui/text_styles.dart';
import 'package:pass_emploi_app/utils/pass_emploi_matomo_tracker.dart';
import 'package:pass_emploi_app/widgets/a11y/mandatory_fields_label.dart';
import 'package:pass_emploi_app/widgets/buttons/primary_action_button.dart';
import 'package:pass_emploi_app/widgets/date_pickers/date_picker.dart';
import 'package:pass_emploi_app/widgets/default_app_bar.dart';
import 'package:pass_emploi_app/widgets/errors/error_text.dart';
import 'package:pass_emploi_app/widgets/radio_list_tile.dart';
import 'package:pass_emploi_app/widgets/sepline.dart';

class CreateDemarcheStep3Page extends StatefulWidget {
  final String idDemarche;
  final DemarcheSource source;

  CreateDemarcheStep3Page._(this.idDemarche, this.source);

  static MaterialPageRoute<String?> materialPageRoute(String idDemarche, DemarcheSource source) {
    return MaterialPageRoute(builder: (context) => CreateDemarcheStep3Page._(idDemarche, source));
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
        converter: (store) => CreateDemarcheStep3ViewModel.create(store, widget.idDemarche, widget.source),
        onDidChange: _onDidChange,
        onDispose: (store) => store.dispatch(CreateDemarcheResetAction()),
        distinct: true,
      ),
    );
  }

  Widget _buildBody(BuildContext context, CreateDemarcheStep3ViewModel viewModel) {
    return UnicTopDemarcheTrackingWrapper(
      source: widget.source,
      viewModel: viewModel,
      child: Scaffold(
        appBar: SecondaryAppBar(title: Strings.createDemarcheTitle),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(Margins.spacing_m),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(viewModel.quoi, style: TextStyles.textBaseBoldWithColor(AppColors.primary)),
                if (viewModel.isCommentMandatory) _Mandatory(),
                if (viewModel.comments.isNotEmpty) _Section(Strings.comment),
                if (viewModel.isCommentMandatory) _SelectLabel(Strings.selectComment),
                ..._buildComments(viewModel.comments),
                _Section(Strings.quand),
                MandatoryFieldsLabel.all(),
                SizedBox(height: Margins.spacing_base),
                _SelectLabel(Strings.selectQuand),
                DatePicker(
                  onDateSelected: (date) {
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
      ),
    );
  }

  void _onDidChange(CreateDemarcheStep3ViewModel? oldVm, CreateDemarcheStep3ViewModel newVm) {
    final creationState = newVm.demarcheCreationState;
    if (creationState is DemarcheCreationSuccessState) {
      PassEmploiMatomoTracker.instance.trackScreen(AnalyticsScreenNames.searchDemarcheStep3Success);
      Navigator.pop(context, creationState.demarcheCreatedId);
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
      return RadioGroup<String>(
          title: comment.label,
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
      child: MandatoryFieldsLabel.some(),
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

class UnicTopDemarcheTrackingWrapper extends StatefulWidget {
  const UnicTopDemarcheTrackingWrapper({super.key, required this.source, required this.child, required this.viewModel});

  final DemarcheSource source;
  final Widget child;
  final CreateDemarcheStep3ViewModel viewModel;

  @override
  State<UnicTopDemarcheTrackingWrapper> createState() => _UnicTopDemarcheTrackingWrapperState();
}

class _UnicTopDemarcheTrackingWrapperState extends State<UnicTopDemarcheTrackingWrapper> {
  @override
  void initState() {
    super.initState();
    if (widget.source is TopDemarcheSource) {
      final quoi = widget.viewModel.quoi;
      PassEmploiMatomoTracker.instance.trackScreen(AnalyticsScreenNames.topDemarcheDetails(quoi));
    }
  }

  @override
  Widget build(BuildContext context) {
    return widget.child;
  }
}
