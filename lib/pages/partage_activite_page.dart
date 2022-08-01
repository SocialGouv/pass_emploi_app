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
import 'package:pass_emploi_app/widgets/loader.dart';
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
      appBar: passEmploiAppBar(context: context, label: Strings.activityShareLabel, withBackButton: true),
      body: _body(viewModel),
    );
  }

  Widget _body(PartageActivitePageViewModel viewModel) {
    switch (viewModel.displayState) {
      case DisplayState.LOADING:
        return loader();
      case DisplayState.CONTENT:
        return _content(viewModel);
      default:
        return Center(child: Retry(Strings.miscellaneousErrorRetry, () => viewModel.onRetry()));
    }
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
  final Function() onPartageFavorisValueChange;
  final DisplayState updatedState;

  const _PartageFavoris({
    Key? key,
    required this.partageFavorisEnabled,
    required this.onPartageFavorisValueChange,
    required this.updatedState,
  }) : super(key: key);

  @override
  State<_PartageFavoris> createState() => _PartageFavorisState();
}

class _PartageFavorisState extends State<_PartageFavoris> {
  var _partageFavorisEnabled = false;
  var _isLoading = false;

  @override
  void initState() {
    super.initState();
    _partageFavorisEnabled = widget.partageFavorisEnabled;
  }

  void _onPartageFavorisValueChange(bool value) {
    widget.onPartageFavorisValueChange();
    if (widget.updatedState == DisplayState.CONTENT) {
      setState(() {
        _isLoading = false;
        _partageFavorisEnabled = value;
      });
    } else if (widget.updatedState == DisplayState.FAILURE) {
      showFailedSnackBar(context, Strings.miscellaneousErrorRetry);
      setState(() => _isLoading = false);
    } else {
      setState(() => _isLoading = true);
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
                    _isLoading ? AppColors.grey500 : AppColors.contentColor,
                  ),
                )),
                Switch(
                  value: _partageFavorisEnabled,
                  onChanged: _onPartageFavorisValueChange,
                  activeColor: AppColors.primary,
                ),
                Text(
                  Strings.yes,
                  style: TextStyles.textBaseRegularWithColor(
                    _isLoading ? AppColors.grey500 : AppColors.contentColor,
                  ),
                ),
              ],
            ),
          ),
        )
      ],
    );
  }
}
