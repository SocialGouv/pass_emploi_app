import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:matomo/matomo.dart';
import 'package:pass_emploi_app/analytics/analytics_constants.dart';
import 'package:pass_emploi_app/models/service_civique/domain.dart';
import 'package:pass_emploi_app/presentation/display_state.dart';
import 'package:pass_emploi_app/presentation/service_civique/service_civique_filtres_view_model.dart';
import 'package:pass_emploi_app/redux/app_state.dart';
import 'package:pass_emploi_app/ui/app_colors.dart';
import 'package:pass_emploi_app/ui/drawables.dart';
import 'package:pass_emploi_app/ui/margins.dart';
import 'package:pass_emploi_app/ui/strings.dart';
import 'package:pass_emploi_app/ui/text_styles.dart';
import 'package:pass_emploi_app/utils/date_extensions.dart';
import 'package:pass_emploi_app/widgets/buttons/primary_action_button.dart';
import 'package:pass_emploi_app/widgets/default_app_bar.dart';

class ServiceCiviqueFiltresPage extends TraceableStatefulWidget {
  ServiceCiviqueFiltresPage() : super(name: AnalyticsScreenNames.serviceCiviqueFiltres);

  static MaterialPageRoute<bool> materialPageRoute() {
    return MaterialPageRoute(builder: (_) => ServiceCiviqueFiltresPage());
  }

  @override
  State<ServiceCiviqueFiltresPage> createState() => _ServiceCiviqueFiltresPageState();
}

class _ServiceCiviqueFiltresPageState extends State<ServiceCiviqueFiltresPage> {
  double? _currentSliderValue;
  Domaine? _currentDomainValue;
  bool _currentActiveDate = false;
  DateTime? _currentStartDate;
  var _isFiltersUpdated = false;

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, ServiceCiviqueFiltresViewModel>(
      onInitialBuild: (viewModel) {
        setState(() {
          _currentStartDate = viewModel.initialStartDateValue;
          _currentActiveDate = viewModel.initialStartDateValue != null;
          _currentDomainValue = viewModel.initialDomainValue;
        });
      },
      converter: (store) => ServiceCiviqueFiltresViewModel.create(store),
      builder: (context, viewModel) => _scaffold(context, viewModel),
      distinct: true,
    );
  }

  Widget _scaffold(BuildContext context, ServiceCiviqueFiltresViewModel viewModel) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: passEmploiAppBar(label: Strings.serviceCiviqueFiltresTitle, context: context, withBackButton: true),
      body: _content(context, viewModel),
    );
  }

  Widget _content(BuildContext context, ServiceCiviqueFiltresViewModel viewModel) {
    return Stack(
      alignment: Alignment.bottomCenter,
      children: [
        SingleChildScrollView(
          child: Column(
            children: [
              if (viewModel.shouldDisplayDistanceFiltre) ...[
                SizedBox(height: Margins.spacing_l),
                _distanceSlider(context, viewModel),
              ],
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: Margins.spacing_m, vertical: Margins.spacing_l),
                child: _startDateFiltres(context),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: Margins.spacing_m),
                child: _domainFilters(),
              ),
              SizedBox(height: 100),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(Margins.spacing_m),
          child: _stretchedButton(viewModel),
        ),
      ],
    );
  }

  Column _distanceSlider(BuildContext context, ServiceCiviqueFiltresViewModel viewModel) {
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

  Widget _sliderValue(ServiceCiviqueFiltresViewModel viewModel) {
    return Row(
      children: [
        Text(Strings.searchRadius, style: TextStyles.textSRegular()),
        Text(Strings.kmFormat(_sliderValueToDisplay(viewModel).toInt()), style: TextStyles.textBaseBold),
      ],
    );
  }

  Widget _slider(ServiceCiviqueFiltresViewModel viewModel) {
    return Slider(
      value: _sliderValueToDisplay(viewModel),
      min: 0,
      max: 100,
      divisions: 10,
      onChanged: (value) {
        if (value > 0) {
          setState(() {
            _currentSliderValue = value;
            _isFiltersUpdated = true;
          });
        }
      },
    );
  }

  double _sliderValueToDisplay(ServiceCiviqueFiltresViewModel viewModel) =>
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

  Column _startDateFiltres(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(Strings.startDateFiltreTitle, style: TextStyles.textBaseBold),
        _dateToggle(),
        _datePicker(context),
      ],
    );
  }

  Widget _dateToggle() {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 20),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(Strings.startDate, style: TextStyles.textSRegular()),
              _startDateToggle(),
            ],
          ),
        ),
      ],
    );
  }

  Switch _startDateToggle() {
    return Switch.adaptive(
      value: _currentActiveDate,
      onChanged: (newValue) => setState(() {
        _currentActiveDate = newValue;
        _isFiltersUpdated = true;
        _currentStartDate = _currentActiveDate ? DateTime.now() : null;
      }),
    );
  }

  Widget _datePicker(BuildContext context) {
    return TextField(
      enabled: _currentActiveDate,
      decoration: InputDecoration(
          suffixIcon: SvgPicture.asset(Drawables.icCalendar, color: AppColors.grey800, fit: BoxFit.scaleDown),
          hintText: _currentStartDate != null ? _currentStartDate!.toDay() : "",
          contentPadding: const EdgeInsets.all(16),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8.0),
            borderSide: BorderSide(color: AppColors.grey800, width: 1.0),
          )),
      keyboardType: TextInputType.none,
      textCapitalization: TextCapitalization.sentences,
      onTap: () => Platform.isIOS ? _iOSDatePicker(context) : _androidDatePicker(context),
      showCursor: false,
    );
  }

  Future<void> _iOSDatePicker(BuildContext context) async {
    showCupertinoModalPopup(
        context: context,
        builder: (_) => Container(
              height: 190,
              color: Colors.white,
              child: Column(
                children: [
                  SizedBox(
                    height: 180,
                    child: CupertinoDatePicker(
                        initialDateTime: DateTime.now(),
                        mode: CupertinoDatePickerMode.date,
                        onDateTimeChanged: (val) {
                          setState(() {
                            _currentStartDate = val;
                            _isFiltersUpdated = true;
                          });
                        }),
                  ),
                ],
              ),
            ));
  }

  Future<void> _androidDatePicker(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      firstDate: DateTime.now(),
      lastDate: DateTime(2101),
      initialDate: DateTime.now(),
      locale: const Locale("fr", "FR"),
    );
    if (picked != null && picked != _currentStartDate) {
      setState(() {
        _currentStartDate = picked;
        _isFiltersUpdated = true;
      });
    }
  }

  Column _domainFilters() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(bottom: 10.0),
          child: Text(Strings.domainFiltreTitle, style: TextStyles.textBaseBold),
        ),
        _domainList(),
      ],
    );
  }

  Column _domainList() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: Domaine.values
          .map((domain) => RadioListTile<Domaine>(
                controlAffinity: ListTileControlAffinity.trailing,
                selected: domain == _currentDomainValue,
                title: Text(domain.titre),
                value: domain,
                groupValue: _currentDomainValue,
                onChanged: (Domaine? value) {
                  setState(() {
                    _currentDomainValue = value;
                    _isFiltersUpdated = true;
                  });
                },
              ))
          .toList(),
    );
  }

  Widget _stretchedButton(ServiceCiviqueFiltresViewModel viewModel) {
    return PrimaryActionButton(
      onPressed: _ifButtonEnabled(viewModel) ? () => _onButtonClick(viewModel) : null,
      label: Strings.applyFiltres,
    );
  }

  bool _ifButtonEnabled(ServiceCiviqueFiltresViewModel viewModel) =>
      _isFiltersUpdated && viewModel.displayState != DisplayState.LOADING;

  void _onButtonClick(ServiceCiviqueFiltresViewModel viewModel) {
    viewModel.updateFiltres(_sliderValueToDisplay(viewModel).toInt(), _currentDomainValue, _currentStartDate);
    Navigator.pop(context, true);
  }
}
