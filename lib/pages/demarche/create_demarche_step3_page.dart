import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:pass_emploi_app/analytics/analytics_constants.dart';
import 'package:pass_emploi_app/analytics/tracker.dart';
import 'package:pass_emploi_app/features/demarche/create/create_demarche_actions.dart';
import 'package:pass_emploi_app/features/demarche/create/create_demarche_state.dart';
import 'package:pass_emploi_app/pages/demarche/create_demarche_step1_page.dart';
import 'package:pass_emploi_app/presentation/demarche/create_demarche_step3_view_model.dart';
import 'package:pass_emploi_app/presentation/demarche/demarche_creation_state.dart';
import 'package:pass_emploi_app/presentation/demarche/demarche_source.dart';
import 'package:pass_emploi_app/presentation/display_state.dart';
import 'package:pass_emploi_app/redux/app_state.dart';
import 'package:pass_emploi_app/ui/animation_durations.dart';
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
import 'package:redux/redux.dart';

class CreateDemarcheStep3Page extends StatelessWidget {
  final String idDemarche;
  final DemarcheSource source;

  CreateDemarcheStep3Page._(this.idDemarche, this.source);

  static MaterialPageRoute<void> materialPageRoute(String idDemarche, DemarcheSource source) {
    return MaterialPageRoute(builder: (context) => CreateDemarcheStep3Page._(idDemarche, source));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: SecondaryAppBar(title: Strings.createDemarcheTitle),
      body: Tracker(
        tracking: AnalyticsScreenNames.searchDemarcheStep3,
        child: CreateDemarcheDuReferentielForm(
          idDemarche: idDemarche,
          source: source,
          createDemarcheButtonLabel: Strings.addALaDemarche,
          onCreateDemarcheSuccess: (demarcheCreatedId) {
            PassEmploiMatomoTracker.instance.trackScreen(AnalyticsScreenNames.searchDemarcheStep3Success);
          },
        ),
      ),
    );
  }
}

class _UnicTopDemarcheTrackingWrapper extends StatefulWidget {
  const _UnicTopDemarcheTrackingWrapper({required this.source, required this.child, required this.viewModel});

  final DemarcheSource source;
  final Widget child;
  final CreateDemarcheStep3ViewModel viewModel;

  @override
  State<_UnicTopDemarcheTrackingWrapper> createState() => _UnicTopDemarcheTrackingWrapperState();
}

class _UnicTopDemarcheTrackingWrapperState extends State<_UnicTopDemarcheTrackingWrapper> {
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

class CreateDemarcheDuReferentielForm extends StatefulWidget {
  const CreateDemarcheDuReferentielForm({
    required this.idDemarche,
    required this.source,
    required this.createDemarcheButtonLabel,
    this.onCreateDemarcheSuccess,
    this.initialCodeComment,
  });

  final String idDemarche;
  final DemarcheSource source;
  final String? initialCodeComment;
  final String createDemarcheButtonLabel;
  final void Function(String demarcheCreatedId)? onCreateDemarcheSuccess;

  @override
  State<CreateDemarcheDuReferentielForm> createState() => _CreateDemarcheDuReferentielFormState();
}

class _CreateDemarcheDuReferentielFormState extends State<CreateDemarcheDuReferentielForm> {
  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, CreateDemarcheStep3ViewModel>(
      builder: (_, viewModel) => _Form(
        viewModel,
        widget.source,
        initialCodeComment: widget.initialCodeComment,
        createDemarcheButtonLabel: widget.createDemarcheButtonLabel,
      ),
      converter: (store) => CreateDemarcheStep3ViewModel.create(store, widget.idDemarche, widget.source),
      onDidChange: _onDidChange,
      onInit: _onInit,
      distinct: true,
    );
  }

  void _onInit(Store<AppState> store) {
    final creationState = store.state.createDemarcheState;
    if (creationState is CreateDemarcheSuccessState) {
      _onSuccess(creationState.demarcheCreatedId);
    }
  }

  void _onDidChange(CreateDemarcheStep3ViewModel? _, CreateDemarcheStep3ViewModel newVm) {
    final creationState = newVm.demarcheCreationState;
    if (creationState is DemarcheCreationSuccessState) {
      _onSuccess(creationState.demarcheCreatedId);
    }
  }

  void _onSuccess(String demarcheId) {
    // To avoid poping during the build
    Future.delayed(
      AnimationDurations.veryFast,
      () {
        CreateDemarcheStep1Page.showDemarcheSnackBarWithDetail(context, demarcheId);
        widget.onCreateDemarcheSuccess?.call(demarcheId);
        StoreProvider.of<AppState>(context).dispatch(CreateDemarcheResetAction());
        Navigator.of(context).popUntil((route) => route.settings.name == Navigator.defaultRouteName);
      },
    );
  }
}

class _Form extends StatefulWidget {
  const _Form(this.viewModel, this.source, {this.initialCodeComment, required this.createDemarcheButtonLabel});

  final DemarcheSource source;
  final String? initialCodeComment;
  final String createDemarcheButtonLabel;
  final CreateDemarcheStep3ViewModel viewModel;

  @override
  State<_Form> createState() => _FormState();
}

class _FormState extends State<_Form> {
  String? _codeComment;
  DateTime? _endDate;

  @override
  void initState() {
    _codeComment = widget.initialCodeComment ?? widget.viewModel.comments.firstOrNull?.code;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.viewModel.demarcheCreationState is DemarcheCreationSuccessState) {
      return SizedBox.shrink();
    }

    return _UnicTopDemarcheTrackingWrapper(
      source: widget.source,
      viewModel: widget.viewModel,
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(Margins.spacing_m),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(widget.viewModel.quoi, style: TextStyles.textBaseBoldWithColor(AppColors.primary)),
              if (widget.viewModel.isCommentMandatory) _Mandatory(),
              if (widget.viewModel.comments.isNotEmpty) _Section(Strings.comment),
              if (widget.viewModel.isCommentMandatory) _SelectLabel(Strings.selectComment),
              _Comments(
                widget.viewModel.comments,
                _codeComment,
                (codeComment) => setState(() => _codeComment = codeComment),
              ),
              _Section(Strings.quand),
              _SelectLabel(Strings.selectQuand),
              DatePicker(
                onDateSelected: (date) => setState(() => _endDate = date),
                initialDateValue: _endDate,
                isActiveDate: true,
              ),
              SizedBox(height: Margins.spacing_xl),
              if (widget.viewModel.displayState == DisplayState.FAILURE) ErrorText(Strings.genericCreationError),
              Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  PrimaryActionButton(
                    label: widget.createDemarcheButtonLabel,
                    onPressed: _buttonIsActive(widget.viewModel)
                        ? () => widget.viewModel.onCreateDemarche(_codeComment, _endDate!)
                        : null,
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }

  bool _buttonIsActive(CreateDemarcheStep3ViewModel viewModel) {
    return viewModel.displayState != DisplayState.LOADING &&
        _endDate != null &&
        (_codeComment != null || !viewModel.isCommentMandatory);
  }
}

class _Comments extends StatelessWidget {
  const _Comments(this.comments, this.codeComment, this.onCommentSelected);

  final List<CommentItem> comments;
  final String? codeComment;
  final void Function(String? codeComment) onCommentSelected;

  @override
  Widget build(BuildContext context) {
    return Column(
        children: comments.map((comment) {
      if (comment is CommentTextItem) {
        return Text(comment.label, style: TextStyles.textBaseBold);
      }
      return RadioGroup<String>(
        title: comment.label,
        value: comment.code,
        groupValue: codeComment,
        onChanged: onCommentSelected,
      );
    }).toList());
  }
}

class _Mandatory extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: Margins.spacing_l),
      child: MandatoryFieldsLabel.all(),
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
