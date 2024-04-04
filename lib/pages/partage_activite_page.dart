import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:pass_emploi_app/analytics/analytics_constants.dart';
import 'package:pass_emploi_app/analytics/tracker.dart';
import 'package:pass_emploi_app/features/partage_activite/partage_activite_actions.dart';
import 'package:pass_emploi_app/presentation/display_state.dart';
import 'package:pass_emploi_app/presentation/profil/partage_activite_page_view_model.dart';
import 'package:pass_emploi_app/redux/app_state.dart';
import 'package:pass_emploi_app/ui/app_colors.dart';
import 'package:pass_emploi_app/ui/margins.dart';
import 'package:pass_emploi_app/ui/strings.dart';
import 'package:pass_emploi_app/ui/text_styles.dart';
import 'package:pass_emploi_app/widgets/default_app_bar.dart';
import 'package:pass_emploi_app/widgets/retry.dart';
import 'package:pass_emploi_app/widgets/snack_bar/show_snack_bar.dart';

class PartageActivitePage extends StatelessWidget {
  static MaterialPageRoute<void> materialPageRoute() {
    return MaterialPageRoute(builder: (context) => PartageActivitePage());
  }

  @override
  Widget build(BuildContext context) {
    return Tracker(
      tracking: AnalyticsScreenNames.shareActivity,
      child: StoreConnector<AppState, PartageActivitePageViewModel>(
        onInit: (store) => store.dispatch(PartageActiviteRequestAction()),
        converter: (store) => PartageActivitePageViewModel.create(store),
        builder: (context, viewModel) => _scaffold(context, viewModel),
      ),
    );
  }

  Widget _scaffold(BuildContext context, PartageActivitePageViewModel viewModel) {
    return Scaffold(
      appBar: SecondaryAppBar(title: Strings.activityShareLabel),
      body: _body(viewModel),
    );
  }

  Widget _body(PartageActivitePageViewModel viewModel) {
    return switch (viewModel.displayState) {
      DisplayState.LOADING => Center(child: CircularProgressIndicator()),
      DisplayState.CONTENT => _content(viewModel),
      _ => Retry(Strings.miscellaneousErrorRetry, () => viewModel.onRetry())
    };
  }

  Widget _content(PartageActivitePageViewModel viewModel) {
    return Stack(children: [
      SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(Margins.spacing_m),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: Margins.spacing_base),
              _PartageDescription(),
              SizedBox(height: Margins.spacing_base),
              _PartageFavoris(
                partageFavorisEnabled: viewModel.shareFavoris,
                onPartageFavorisValueChange: viewModel.onPartageFavorisTap,
                updatedState: viewModel.updateState,
              ),
            ],
          ),
        ),
      ),
    ]);
  }
}

class _PartageDescription extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(Margins.spacing_base),
      child: Text(Strings.activityShareDescription, style: TextStyles.textBaseRegular),
    );
  }
}

class _PartageFavoris extends StatefulWidget {
  final bool partageFavorisEnabled;
  final Function(bool) onPartageFavorisValueChange;
  final DisplayState updatedState;

  const _PartageFavoris({
    required this.partageFavorisEnabled,
    required this.onPartageFavorisValueChange,
    required this.updatedState,
  });

  @override
  State<_PartageFavoris> createState() => _PartageFavorisState();
}

class _PartageFavorisState extends State<_PartageFavoris> {
  var _partageFavorisEnabled = false;

  @override
  void initState() {
    super.initState();
    _partageFavorisEnabled = widget.partageFavorisEnabled;
  }

  void _onPartageFavorisValueChange(bool value) {
    if (widget.updatedState == DisplayState.CONTENT) {
      setState(() {
        widget.onPartageFavorisValueChange(value);
        _partageFavorisEnabled = value;
      });
    } else if (widget.updatedState == DisplayState.FAILURE) {
      showSnackBarWithSystemError(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        DecoratedBox(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.all(Radius.circular(16)),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: Margins.spacing_base, vertical: Margins.spacing_s),
            child: Row(
              children: [
                Expanded(
                    child: Text(
                  Strings.shareFavoriteLabel,
                  style: TextStyles.textBaseRegularWithColor(
                    widget.updatedState == DisplayState.LOADING ? AppColors.grey500 : AppColors.contentColor,
                  ),
                )),
                Semantics(
                  label: Strings.partageFavorisEnabled(_partageFavorisEnabled),
                  child: Switch(
                    value: _partageFavorisEnabled,
                    onChanged: _onPartageFavorisValueChange,
                  ),
                ),
                SizedBox(width: Margins.spacing_xs),
                Text(
                  _partageFavorisEnabled ? Strings.yes : Strings.no,
                  style: TextStyles.textBaseRegularWithColor(
                      widget.updatedState == DisplayState.LOADING ? AppColors.grey500 : AppColors.contentColor),
                ),
              ],
            ),
          ),
        )
      ],
    );
  }
}
