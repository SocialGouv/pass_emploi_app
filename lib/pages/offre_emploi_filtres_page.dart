import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:matomo/matomo.dart';
import 'package:pass_emploi_app/analytics/analytics_constants.dart';
import 'package:pass_emploi_app/models/offre_emploi_filtres_parameters.dart';
import 'package:pass_emploi_app/presentation/checkbox_value_view_model.dart';
import 'package:pass_emploi_app/presentation/display_state.dart';
import 'package:pass_emploi_app/presentation/offre_emploi_filtres_view_model.dart';
import 'package:pass_emploi_app/redux/states/app_state.dart';
import 'package:pass_emploi_app/ui/strings.dart';
import 'package:pass_emploi_app/ui/text_styles.dart';
import 'package:pass_emploi_app/widgets/checkbox_group.dart';
import 'package:pass_emploi_app/widgets/default_app_bar.dart';
import 'package:pass_emploi_app/widgets/error_text.dart';
import 'package:pass_emploi_app/widgets/primary_action_button.dart';
import 'package:pass_emploi_app/widgets/sepline.dart';

class OffreEmploiFiltresPage extends TraceableStatefulWidget {
  OffreEmploiFiltresPage(bool fromAlternance)
      : super(name: fromAlternance ? AnalyticsScreenNames.alternanceFiltres : AnalyticsScreenNames.emploiFiltres);

  static MaterialPageRoute materialPageRoute(bool fromAlternance) {
    return MaterialPageRoute(builder: (_) => OffreEmploiFiltresPage(fromAlternance));
  }

  @override
  State<OffreEmploiFiltresPage> createState() => _OffreEmploiFiltresPageState();
}

class _OffreEmploiFiltresPageState extends State<OffreEmploiFiltresPage> {
  double? _currentSliderValue;
  List<CheckboxValueViewModel<ExperienceFiltre>>? _currentExperienceFiltres;
  List<CheckboxValueViewModel<ContratFiltre>>? _currentContratFiltres;
  List<CheckboxValueViewModel<DureeFiltre>>? _currentDureeFiltres;
  var _hasFormChanged = false;

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, OffreEmploiFiltresViewModel>(
      onInitialBuild: (viewModel) {
        _currentExperienceFiltres = viewModel.experienceFiltres.where((element) => element.isInitiallyChecked).toList();
        _currentContratFiltres = viewModel.contratFiltres.where((element) => element.isInitiallyChecked).toList();
        _currentDureeFiltres = viewModel.dureeFiltres.where((element) => element.isInitiallyChecked).toList();
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
          if (viewModel.shouldDisplayNonDistanceFiltres) ...[
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 16, 24, 0),
              child: CheckBoxGroup<ExperienceFiltre>(
                title: Strings.experienceSectionTitle,
                options: viewModel.experienceFiltres,
                onSelectedOptionsUpdated: (selectedOptions) {
                  setState(() {
                    _hasFormChanged = true;
                    _currentExperienceFiltres = selectedOptions as List<CheckboxValueViewModel<ExperienceFiltre>>;
                  });
                },
              ),
            ),
            SizedBox(
              height: 32,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: CheckBoxGroup<ContratFiltre>(
                title: Strings.contratSectionTitle,
                options: viewModel.contratFiltres,
                onSelectedOptionsUpdated: (selectedOptions) {
                  setState(() {
                    _hasFormChanged = true;
                    _currentContratFiltres = selectedOptions as List<CheckboxValueViewModel<ContratFiltre>>;
                  });
                },
              ),
            ),
            SizedBox(
              height: 32,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: CheckBoxGroup<DureeFiltre>(
                title: Strings.dureeSectionTitle,
                options: viewModel.dureeFiltres,
                onSelectedOptionsUpdated: (selectedOptions) {
                  setState(() {
                    _hasFormChanged = true;
                    _currentDureeFiltres = selectedOptions as List<CheckboxValueViewModel<DureeFiltre>>;
                  });
                },
              ),
            ),
          ],
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
        Text(Strings.searchRadius, style: TextStyles.textBaseBold),
        Text(Strings.kmFormat(_sliderValueToDisplay(viewModel).toInt()), style: TextStyles.textBaseBold),
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
        Text(Strings.kmFormat(0), style: TextStyles.textSBold),
        Text(Strings.kmFormat(100), style: TextStyles.textSBold),
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
                  _currentExperienceFiltres ?? [],
                  _currentContratFiltres ?? [],
                  _currentDureeFiltres ?? [],
                )
            : null,
        label: Strings.applyFiltres,
      ),
    );
  }

  Widget _sepLine() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: SepLine(24, 24),
    );
  }

  bool _isError(OffreEmploiFiltresViewModel viewModel) {
    return viewModel.displayState == DisplayState.FAILURE || viewModel.displayState == DisplayState.EMPTY;
  }
}
