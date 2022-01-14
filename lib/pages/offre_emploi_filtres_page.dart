import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:matomo/matomo.dart';
import 'package:pass_emploi_app/analytics/analytics_constants.dart';
import 'package:pass_emploi_app/models/offre_emploi_filtres_parameters.dart';
import 'package:pass_emploi_app/presentation/checkbox_value_view_model.dart';
import 'package:pass_emploi_app/presentation/display_state.dart';
import 'package:pass_emploi_app/presentation/offre_emploi_filtres_view_model.dart';
import 'package:pass_emploi_app/redux/states/app_state.dart';
import 'package:pass_emploi_app/ui/app_colors.dart';
import 'package:pass_emploi_app/ui/strings.dart';
import 'package:pass_emploi_app/ui/text_styles.dart';
import 'package:pass_emploi_app/widgets/checkbox_group.dart';
import 'package:pass_emploi_app/widgets/default_app_bar.dart';
import 'package:pass_emploi_app/widgets/error_text.dart';
import 'package:pass_emploi_app/widgets/primary_action_button.dart';
import 'package:pass_emploi_app/widgets/sepline.dart';

class OffreEmploiFiltresPage extends TraceableStatefulWidget {
  OffreEmploiFiltresPage() : super(name: AnalyticsScreenNames.offreEmploiFiltres);

  static MaterialPageRoute materialPageRoute() => MaterialPageRoute(builder: (_) => OffreEmploiFiltresPage());

  @override
  State<OffreEmploiFiltresPage> createState() => _OffreEmploiFiltresPageState();
}

class _OffreEmploiFiltresPageState extends State<OffreEmploiFiltresPage> {
  double? _currentSliderValue;
  List<CheckboxValueViewModel<ExperienceFiltre>>? _currentExperiencefiltres;
  List<CheckboxValueViewModel<ContratFiltre>>? _currentContratfiltres;
  List<CheckboxValueViewModel<DureeFiltre>>? _currentDureefiltres;
  var _hasFormChanged = false;

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, OffreEmploiFiltresViewModel>(
      onInitialBuild: (viewModel) {
        _currentExperiencefiltres = viewModel.experienceFiltres.where((element) => element.isInitiallyChecked).toList();
        _currentContratfiltres = viewModel.contratFiltres.where((element) => element.isInitiallyChecked).toList();
        _currentDureefiltres = viewModel.dureeFiltres.where((element) => element.isInitiallyChecked).toList();
      },
      converter: (store) => OffreEmploiFiltresViewModel.create(store),
      builder: (context, viewModel) => _scaffold(context, viewModel),
      distinct: true,
      onWillChange: (previousViewModel, newViewModel) {
        if (previousViewModel?.displayState == DisplayState.LOADING &&
            newViewModel.displayState == DisplayState.CONTENT) {
          Navigator.pop(context, true);
        }
      },
    );
  }

  Widget _scaffold(BuildContext context, OffreEmploiFiltresViewModel viewModel) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: passEmploiAppBar(label: Strings.offresEmploiFiltresTitle, withBackButton: true),
      body: _content(context, viewModel),
    );
  }

  Widget _content(BuildContext context, OffreEmploiFiltresViewModel viewModel) {
    return SingleChildScrollView(
      child: Column(
        children: [
          SizedBox(height: 32),
          if (viewModel.shouldDisplayDistanceFiltre) ...[
            _distanceSlider(context, viewModel),
            _sepLine(),
          ],
          CheckBoxGroup<ExperienceFiltre>(
            title: Strings.experienceSectionTitle,
            options: viewModel.experienceFiltres,
            onSelectedOptionsUpdated: (selectedOptions) {
              setState(() {
                _hasFormChanged = true;
                _currentExperiencefiltres = selectedOptions as List<CheckboxValueViewModel<ExperienceFiltre>>;
              });
            },
          ),
          _sepLine(),
          CheckBoxGroup<ContratFiltre>(
            title: Strings.contratSectionTitle,
            options: viewModel.contratFiltres,
            onSelectedOptionsUpdated: (selectedOptions) {
              setState(() {
                _hasFormChanged = true;
                _currentContratfiltres = selectedOptions as List<CheckboxValueViewModel<ContratFiltre>>;
              });
            },
          ),
          _sepLine(),
          CheckBoxGroup<DureeFiltre>(
            title: Strings.dureeSectionTitle,
            options: viewModel.dureeFiltres,
            onSelectedOptionsUpdated: (selectedOptions) {
              setState(() {
                _hasFormChanged = true;
                _currentDureefiltres = selectedOptions as List<CheckboxValueViewModel<DureeFiltre>>;
              });
            },
          ),
          _sepLine(),
          if (_isError(viewModel)) ErrorText(viewModel.errorMessage),
          Padding(
            padding: const EdgeInsets.all(24),
            child: _stretchedButton(context, viewModel),
          ),
        ],
      ),
    );
  }

  Column _distanceSlider(BuildContext context, OffreEmploiFiltresViewModel viewModel) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: _sliderValue(viewModel),
        ),
        _slider(viewModel),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: _sliderCaption(),
        ),
      ],
    );
  }

  Widget _sliderValue(OffreEmploiFiltresViewModel viewModel) {
    return Row(
      children: [
        Text(Strings.searchRadius, style: TextStyles.textMdRegular),
        Text(Strings.kmFormat(_sliderValueToDisplay(viewModel).toInt()), style: TextStyles.textMdMedium),
      ],
    );
  }

  Widget _slider(OffreEmploiFiltresViewModel viewModel) {
    return Slider(
      value: _sliderValueToDisplay(viewModel),
      min: 0,
      max: 100,
      divisions: 10,
      onChanged: (value) {
        if (value > 0)
          setState(() {
            _currentSliderValue = value;
            _hasFormChanged = true;
          });
      },
    );
  }

  double _sliderValueToDisplay(OffreEmploiFiltresViewModel viewModel) =>
      _currentSliderValue != null ? _currentSliderValue! : viewModel.initialDistanceValue.toDouble();

  Widget _sliderCaption() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(Strings.kmFormat(0), style: TextStyles.textSmMedium()),
        Text(Strings.kmFormat(100), style: TextStyles.textSmMedium()),
      ],
    );
  }

  Widget _stretchedButton(BuildContext context, OffreEmploiFiltresViewModel viewModel) {
    return ConstrainedBox(
      constraints: const BoxConstraints(minWidth: double.infinity),
      child: PrimaryActionButton(
        onPressed: _hasFormChanged && viewModel.displayState != DisplayState.LOADING
            ? () => viewModel.updateFiltres(
                  _sliderValueToDisplay(viewModel).toInt(),
                  _currentExperiencefiltres ?? [],
                  _currentContratfiltres ?? [],
                  _currentDureefiltres ?? [],
                )
            : null,
        label: Strings.applyFiltres,
      ),
    );
  }

  Widget _sepLine() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: SepLine(24, 24, lineColor: AppColors.bluePurple),
    );
  }

  bool _isError(OffreEmploiFiltresViewModel viewModel) {
    return viewModel.displayState == DisplayState.FAILURE || viewModel.displayState == DisplayState.EMPTY;
  }
}
