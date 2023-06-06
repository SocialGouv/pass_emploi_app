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
import 'package:pass_emploi_app/widgets/buttons/filter_button.dart';
import 'package:pass_emploi_app/widgets/checkbox_group.dart';
import 'package:pass_emploi_app/widgets/default_app_bar.dart';
import 'package:pass_emploi_app/widgets/errors/error_text.dart';

class EvenementEmploiFiltresPage extends StatefulWidget {
  static MaterialPageRoute<bool> materialPageRoute() {
    return MaterialPageRoute(builder: (_) => EvenementEmploiFiltresPage());
  }

  @override
  State<EvenementEmploiFiltresPage> createState() => _EvenementEmploiFiltresPageState();
}

class _EvenementEmploiFiltresPageState extends State<EvenementEmploiFiltresPage> {
  @override
  Widget build(BuildContext context) {
    return Tracker(
      tracking: AnalyticsScreenNames.emploiFiltres, // TODO-1674 Tracking
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

class _Scaffold extends StatelessWidget {
  final EvenementEmploiFiltresViewModel viewModel;

  const _Scaffold(this.viewModel);

  @override
  Widget build(BuildContext context) {
    const backgroundColor = Colors.white;
    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: SecondaryAppBar(title: Strings.evenementEmploiFiltres, backgroundColor: backgroundColor),
      body: _Content(viewModel: viewModel),
    );
  }
}

class _Content extends StatefulWidget {
  final EvenementEmploiFiltresViewModel viewModel;

  _Content({required this.viewModel});

  @override
  State<_Content> createState() => _ContentState();
}

class _ContentState extends State<_Content> {
  EvenementEmploiType? _currentTypeValue;
  List<CheckboxValueViewModel<EvenementEmploiModalite>>? _currentModaliteFiltres;
  var _hasFormChanged = false;

  @override
  void initState() {
    super.initState();
    _currentTypeValue = widget.viewModel.initialTypeValue;
    _currentModaliteFiltres = widget.viewModel.modalitesFiltres.where((element) => element.isInitiallyChecked).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.bottomCenter,
      children: [
        _Filtres(
          viewModel: widget.viewModel,
          onTypeValueChange: (type) => _setTypeFiltreState(type),
          onModalitesValueChange: (selectedOptions) => _setModalitesFiltreState(selectedOptions),
        ),
        Padding(
          padding: const EdgeInsets.all(Margins.spacing_m),
          child: FilterButton(
            isEnabled: _isButtonEnabled(widget.viewModel.displayState),
            onPressed: () => {_onButtonClick(widget.viewModel)},
          ),
        ),
      ],
    );
  }

  void _setTypeFiltreState(EvenementEmploiType? type) {
    setState(() {
      _hasFormChanged = true;
      _currentTypeValue = type;
    });
  }

  void _setModalitesFiltreState(List<CheckboxValueViewModel<EvenementEmploiModalite>> selectedOptions) {
    setState(() {
      _hasFormChanged = true;
      _currentModaliteFiltres = selectedOptions;
    });
  }

  bool _isButtonEnabled(DisplayState displayState) => _hasFormChanged && displayState != DisplayState.LOADING;

  void _onButtonClick(EvenementEmploiFiltresViewModel viewModel) {
    viewModel.updateFiltres(
      _currentTypeValue,
      _currentModaliteFiltres ?? [],
      null, // TODO-1674 dateDebut
      null, // TODO-1674 dateFin
    );
  }
}

class _Filtres extends StatefulWidget {
  final EvenementEmploiFiltresViewModel viewModel;
  final Function(EvenementEmploiType?) onTypeValueChange;
  final Function(List<CheckboxValueViewModel<EvenementEmploiModalite>>) onModalitesValueChange;

  _Filtres({
    required this.viewModel,
    required this.onTypeValueChange,
    required this.onModalitesValueChange,
  });

  @override
  State<_Filtres> createState() => _FiltresState();
}

class _FiltresState extends State<_Filtres> {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          SizedBox(height: Margins.spacing_l),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: Margins.spacing_m),
            child: _TypeFiltre(
              initialTypeValue: widget.viewModel.initialTypeValue,
              onValueChange: (value) => widget.onTypeValueChange(value),
            ),
          ),
          SizedBox(height: Margins.spacing_m),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: Margins.spacing_m),
            child: CheckBoxGroup<EvenementEmploiModalite>(
              title: Strings.evenementEmploiFiltresModalites,
              options: widget.viewModel.modalitesFiltres,
              onSelectedOptionsUpdated: (selectedOptions) {
                widget.onModalitesValueChange(selectedOptions as List<CheckboxValueViewModel<EvenementEmploiModalite>>);
              },
            ),
          ),
          if (widget.viewModel.displayState.isFailure()) ErrorText(Strings.genericError),
          SizedBox(height: 100),
        ],
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
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [null, ...EvenementEmploiType.values]
                .map((type) => RadioListTile<EvenementEmploiType?>(
                    controlAffinity: ListTileControlAffinity.trailing,
                    selected: type == _currentValue,
                    title: Text(type?.label ?? Strings.evenementEmploiTypeAll),
                    value: type,
                    groupValue: _currentValue,
                    onChanged: (value) {
                      widget.onValueChange(value);
                      setState(() => _currentValue = value);
                    }))
                .toList(),
          ),
        ),
      ],
    );
  }
}
