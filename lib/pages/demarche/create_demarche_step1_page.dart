import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:matomo/matomo.dart';
import 'package:pass_emploi_app/analytics/analytics_constants.dart';
import 'package:pass_emploi_app/analytics/analytics_extensions.dart';
import 'package:pass_emploi_app/features/demarche/search/seach_demarche_actions.dart';
import 'package:pass_emploi_app/pages/demarche/create_demarche_step2_page.dart';
import 'package:pass_emploi_app/presentation/demarche/create_demarche_step1_view_model.dart';
import 'package:pass_emploi_app/redux/app_state.dart';
import 'package:pass_emploi_app/ui/app_colors.dart';
import 'package:pass_emploi_app/ui/drawables.dart';
import 'package:pass_emploi_app/ui/margins.dart';
import 'package:pass_emploi_app/ui/strings.dart';
import 'package:pass_emploi_app/ui/text_styles.dart';
import 'package:pass_emploi_app/widgets/buttons/primary_action_button.dart';
import 'package:pass_emploi_app/widgets/default_app_bar.dart';
import 'package:pass_emploi_app/widgets/errors/error_text.dart';

class CreateDemarcheStep1Page extends TraceableStatefulWidget {
  CreateDemarcheStep1Page._() : super(name: AnalyticsScreenNames.searchDemarcheStep1);

  static MaterialPageRoute<void> materialPageRoute() {
    return MaterialPageRoute(builder: (context) => CreateDemarcheStep1Page._());
  }

  @override
  State<CreateDemarcheStep1Page> createState() => _CreateDemarcheStep1PageState();
}

class _CreateDemarcheStep1PageState extends State<CreateDemarcheStep1Page> {
  String _query = '';

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, CreateDemarcheStep1ViewModel>(
      builder: _buildBody,
      converter: (store) => CreateDemarcheStep1ViewModel.create(store),
      onDidChange: (oldVm, newVm) {
        if (newVm.shouldGoToStep2) {
          widget.pushAndTrackBack(
            context,
            CreateDemarcheStep2Page.materialPageRoute(),
            AnalyticsScreenNames.searchDemarcheStep1,
          );
        }
      },
      onDispose: (store) => store.dispatch(SearchDemarcheResetAction()),
      distinct: true,
    );
  }

  Scaffold _buildBody(BuildContext context, CreateDemarcheStep1ViewModel viewModel) {
    return Scaffold(
      appBar: passEmploiAppBar(label: Strings.createDemarcheTitle, context: context),
      body: Padding(
        padding: const EdgeInsets.all(Margins.spacing_base),
        child: Column(
          children: [
            Text(Strings.searchDemarcheHint, style: TextStyles.textBaseMedium),
            SizedBox(height: Margins.spacing_base),
            _ChampRecherche(
              onChanged: (value) {
                setState(() {
                  _query = value;
                });
              },
            ),
            if (viewModel.displayState.isFailure()) ErrorText(Strings.genericError),
            SizedBox(height: Margins.spacing_xl),
            PrimaryActionButton(
              drawableRes: Drawables.icSearch,
              label: Strings.searchDemarcheButton,
              onPressed: _buttonIsActive(viewModel) ? () => viewModel.onSearchDemarche(_query) : null,
            ),
          ],
        ),
      ),
    );
  }

  bool _buttonIsActive(CreateDemarcheStep1ViewModel viewModel) {
    return _query.trim().isNotEmpty && !viewModel.displayState.isLoading();
  }
}

class _ChampRecherche extends StatelessWidget {
  final ValueChanged<String> onChanged;

  const _ChampRecherche({required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      style: TextStyles.textBaseBold,
      keyboardType: TextInputType.text,
      textInputAction: TextInputAction.done,
      validator: (value) {
        if (value == null || value.trim().isEmpty) return Strings.mandatoryField;
        return null;
      },
      autovalidateMode: AutovalidateMode.onUserInteraction,
      decoration: InputDecoration(
        contentPadding: const EdgeInsets.only(
          left: Margins.spacing_m,
          top: Margins.spacing_base,
          bottom: Margins.spacing_base,
        ),
        border: _Border(AppColors.contentColor),
        focusedBorder: _Border(AppColors.primary),
        errorBorder: _Border(AppColors.warning),
        focusedErrorBorder: _Border(AppColors.warning),
      ),
      onChanged: onChanged,
    );
  }
}

class _Border extends OutlineInputBorder {
  _Border(Color color)
      : super(
          borderRadius: BorderRadius.circular(8.0),
          borderSide: BorderSide(color: color, width: 1.0),
        );
}
