import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:pass_emploi_app/analytics/analytics_constants.dart';
import 'package:pass_emploi_app/analytics/tracker.dart';
import 'package:pass_emploi_app/models/evenement_emploi/evenement_emploi_modalite.dart';
import 'package:pass_emploi_app/models/evenement_emploi/evenement_emploi_type.dart';
import 'package:pass_emploi_app/presentation/checkbox_value_view_model.dart';
import 'package:pass_emploi_app/presentation/display_state.dart';
import 'package:pass_emploi_app/presentation/evenement_emploi/evenement_emploi_filtres_view_model.dart';
import 'package:pass_emploi_app/redux/app_state.dart';
import 'package:pass_emploi_app/ui/dimens.dart';
import 'package:pass_emploi_app/ui/margins.dart';
import 'package:pass_emploi_app/ui/shadows.dart';
import 'package:pass_emploi_app/ui/strings.dart';
import 'package:pass_emploi_app/ui/text_styles.dart';
import 'package:pass_emploi_app/widgets/bottom_sheets/bottom_sheets.dart';
import 'package:pass_emploi_app/widgets/buttons/filter_button.dart';
import 'package:pass_emploi_app/widgets/checkbox_group.dart';
import 'package:pass_emploi_app/widgets/date_pickers/date_picker.dart';
import 'package:pass_emploi_app/widgets/errors/error_text.dart';
import 'package:pass_emploi_app/widgets/radio_list_tile.dart';

class EvenementEmploiFiltresPage extends StatelessWidget {
  static Future<bool?> show(BuildContext context) {
    return showPassEmploiBottomSheet<bool>(
      context: context,
      builder: (context) => EvenementEmploiFiltresPage(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Tracker(
      tracking: AnalyticsScreenNames.evenementEmploiFiltres,
      child: StoreConnector<AppState, EvenementEmploiFiltresViewModel>(
        converter: (store) => EvenementEmploiFiltresViewModel.create(store),
        builder: (_, viewModel) => _Scaffold(viewModel),
        distinct: true,
        onWillChange: (previousVM, newVM) {
          if (previousVM?.displayState == DisplayState.LOADING && newVM.displayState == DisplayState.CONTENT) {
            Navigator.pop(context, true);
          }
        },
      ),
    );
  }
}

class _Scaffold extends StatefulWidget {
  final EvenementEmploiFiltresViewModel viewModel;

  _Scaffold(this.viewModel);

  @override
  State<_Scaffold> createState() => _ScaffoldState();
}

class _ScaffoldState extends State<_Scaffold> {
  EvenementEmploiType? _currentTypeValue;
  List<CheckboxValueViewModel<EvenementEmploiModalite>>? _currentModaliteFiltres;
  DateTime? _currentDateDebut;
  DateTime? _currentDateFin;

  @override
  void initState() {
    super.initState();
    _currentTypeValue = widget.viewModel.initialTypeValue;
    _currentModaliteFiltres = widget.viewModel.modalitesFiltres.where((element) => element.isInitiallyChecked).toList();
    _currentDateDebut = widget.viewModel.initialDateDebut;
    _currentDateFin = widget.viewModel.initialDateFin;
  }

  @override
  Widget build(BuildContext context) {
    return BottomSheetWrapper(
      title: Strings.evenementEmploiFiltres,
      padding: EdgeInsets.symmetric(horizontal: Margins.spacing_m),
      body: Scaffold(
        body: _Filtres(
          viewModel: widget.viewModel,
          currentDateDebut: _currentDateDebut,
          currentDateFin: _currentDateFin,
          onTypeValueChange: (type) => _setTypeFiltreState(type),
          onModalitesValueChange: (selectedOptions) => _setModalitesFiltreState(selectedOptions),
          onDateDebutValueChange: (dateTime) => _setDateDebutFiltreState(dateTime),
          onDateFinValueChange: (dateTime) => _setDateFinFiltreState(dateTime),
        ),
        floatingActionButton: FilterButton(
          isEnabled: _isButtonEnabled(widget.viewModel.displayState),
          onPressed: () => {_onButtonClick(widget.viewModel)},
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      ),
    );
  }

  void _setTypeFiltreState(EvenementEmploiType? type) {
    setState(() => _currentTypeValue = type);
  }

  void _setModalitesFiltreState(List<CheckboxValueViewModel<EvenementEmploiModalite>> selectedOptions) {
    setState(() => _currentModaliteFiltres = selectedOptions);
  }

  void _setDateDebutFiltreState(DateTime dateTime) {
    setState(() {
      _currentDateDebut = dateTime;
      if (_currentDateFin?.isBefore(dateTime) == true) _currentDateFin = null;
    });
  }

  void _setDateFinFiltreState(DateTime dateTime) {
    setState(() {
      _currentDateFin = dateTime;
    });
  }

  bool _isButtonEnabled(DisplayState displayState) => displayState != DisplayState.LOADING;

  void _onButtonClick(EvenementEmploiFiltresViewModel viewModel) {
    viewModel.updateFiltres(_currentTypeValue, _currentModaliteFiltres, _currentDateDebut, _currentDateFin);
  }
}

class _Filtres extends StatelessWidget {
  final EvenementEmploiFiltresViewModel viewModel;
  final DateTime? currentDateDebut;
  final DateTime? currentDateFin;
  final Function(EvenementEmploiType?) onTypeValueChange;
  final Function(List<CheckboxValueViewModel<EvenementEmploiModalite>>) onModalitesValueChange;
  final Function(DateTime) onDateDebutValueChange;
  final Function(DateTime) onDateFinValueChange;

  _Filtres({
    required this.viewModel,
    required this.currentDateDebut,
    required this.currentDateFin,
    required this.onTypeValueChange,
    required this.onModalitesValueChange,
    required this.onDateDebutValueChange,
    required this.onDateFinValueChange,
  });

  @override
  Widget build(BuildContext context) {
    return ColoredBox(
      color: Colors.white,
      child: SingleChildScrollView(
        clipBehavior: Clip.none,
        child: Column(
          children: [
            SizedBox(height: Margins.spacing_m),
            _TypeFiltre(
              initialTypeValue: viewModel.initialTypeValue,
              onValueChange: (value) => onTypeValueChange(value),
            ),
            SizedBox(height: Margins.spacing_m),
            CheckBoxGroup<EvenementEmploiModalite>(
              contentPadding: EdgeInsets.only(left: Margins.spacing_base, right: Margins.spacing_s),
              title: Strings.evenementEmploiFiltresModalites,
              options: viewModel.modalitesFiltres,
              onSelectedOptionsUpdated: (selectedOptions) {
                onModalitesValueChange(selectedOptions as List<CheckboxValueViewModel<EvenementEmploiModalite>>);
              },
            ),
            SizedBox(height: Margins.spacing_m),
            _DateFiltres(
              onDateDebutValueChange: onDateDebutValueChange,
              onDateFinValueChange: onDateFinValueChange,
              initialDateDebut: currentDateDebut,
              initialDateFin: currentDateFin,
            ),
            if (viewModel.displayState.isFailure()) ErrorText(Strings.genericError),
            SizedBox(height: 200),
          ],
        ),
      ),
    );
  }
}

class _TypeFiltre extends StatefulWidget {
  final Function(EvenementEmploiType?) onValueChange;
  final EvenementEmploiType? initialTypeValue;

  _TypeFiltre({required this.onValueChange, required this.initialTypeValue});

  @override
  State<_TypeFiltre> createState() => _TypeFiltreState();
}

class _TypeFiltreState extends State<_TypeFiltre> {
  EvenementEmploiType? _currentValue;

  @override
  void initState() {
    super.initState();
    _currentValue = widget.initialTypeValue;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(Strings.evenementEmploiFiltresType, style: TextStyles.textBaseBold),
        SizedBox(height: Margins.spacing_base),
        DecoratedBox(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.all(Radius.circular(Dimens.radius_base)),
            boxShadow: [Shadows.radius_base],
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: Margins.spacing_base, vertical: Margins.spacing_s),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [null, ...EvenementEmploiType.values]
                  .map((type) => CustomRadioGroup<EvenementEmploiType?>(
                      title: type?.label ?? Strings.evenementEmploiTypeAll,
                      value: type,
                      groupValue: _currentValue,
                      onChanged: (value) {
                        widget.onValueChange(value);
                        setState(() => _currentValue = value);
                      }))
                  .toList(),
            ),
          ),
        ),
      ],
    );
  }
}

class _DateFiltres extends StatelessWidget {
  final Function(DateTime) onDateDebutValueChange;
  final Function(DateTime) onDateFinValueChange;
  final DateTime? initialDateDebut;
  final DateTime? initialDateFin;

  const _DateFiltres({
    required this.onDateDebutValueChange,
    required this.onDateFinValueChange,
    required this.initialDateDebut,
    required this.initialDateFin,
  });

  @override
  Widget build(BuildContext context) {
    final (DateTime? initialDateFin, DateTime? firstDateFin, bool showInitialDateFin) = _dateFinParams();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(Strings.evenementEmploiFiltresDate, style: TextStyles.textBaseBold),
        SizedBox(height: Margins.spacing_base),
        DecoratedBox(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.all(Radius.circular(Dimens.radius_base)),
            boxShadow: [Shadows.radius_base],
          ),
          child: Padding(
            padding: const EdgeInsets.all(Margins.spacing_base),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(Strings.evenementEmploiFiltresDateDebut, style: TextStyles.textBaseMedium),
                SizedBox(height: Margins.spacing_s),
                DatePicker(
                  onDateSelected: onDateDebutValueChange,
                  initialDateValue: initialDateDebut,
                  isActiveDate: true,
                  firstDate: DateTime.now(),
                ),
                SizedBox(height: Margins.spacing_base),
                Text(Strings.evenementEmploiFiltresDateFin, style: TextStyles.textBaseMedium),
                SizedBox(height: Margins.spacing_s),
                DatePicker(
                  onDateSelected: onDateFinValueChange,
                  initialDateValue: initialDateFin,
                  isActiveDate: true,
                  firstDate: firstDateFin,
                  showInitialDate: showInitialDateFin,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  (DateTime? intialDate, DateTime? firstDate, bool showInitialDate) _dateFinParams() {
    if (initialDateFin != null) return (initialDateFin, DateTime.now(), true);
    if (initialDateDebut != null) return (initialDateDebut, initialDateDebut, false);
    return (null, DateTime.now(), true);
  }
}
