import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:pass_emploi_app/analytics/analytics_constants.dart';
import 'package:pass_emploi_app/analytics/tracker.dart';
import 'package:pass_emploi_app/features/cv/cv_actions.dart';
import 'package:pass_emploi_app/models/cv_pole_emploi.dart';
import 'package:pass_emploi_app/presentation/cv/cv_view_model.dart';
import 'package:pass_emploi_app/presentation/display_state.dart';
import 'package:pass_emploi_app/redux/app_state.dart';
import 'package:pass_emploi_app/ui/app_colors.dart';
import 'package:pass_emploi_app/ui/app_icons.dart';
import 'package:pass_emploi_app/ui/margins.dart';
import 'package:pass_emploi_app/ui/strings.dart';
import 'package:pass_emploi_app/ui/text_styles.dart';
import 'package:pass_emploi_app/widgets/buttons/primary_action_button.dart';
import 'package:pass_emploi_app/widgets/buttons/secondary_button.dart';
import 'package:pass_emploi_app/widgets/cards/generic/card_container.dart';
import 'package:pass_emploi_app/widgets/default_app_bar.dart';
import 'package:pass_emploi_app/widgets/preview_file_invisible_handler.dart';
import 'package:pass_emploi_app/widgets/retry.dart';

class CvListPage extends StatelessWidget {
  static MaterialPageRoute<void> materialPageRoute() => MaterialPageRoute(builder: (context) => CvListPage());

  const CvListPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Tracker(
      tracking: AnalyticsScreenNames.cvListPage,
      child: StoreConnector<AppState, CvViewModel>(
        onInit: (store) => store.dispatch(CvRequestAction()),
        converter: (store) => CvViewModel.create(store),
        builder: (context, viewModel) => _Scaffold(viewModel: viewModel),
        distinct: true,
      ),
    );
  }
}

class _Scaffold extends StatelessWidget {
  final CvViewModel viewModel;

  const _Scaffold({
    Key? key,
    required this.viewModel,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: SecondaryAppBar(title: Strings.cvListPageTitle),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: Margins.spacing_m),
        child: _Body(viewModel),
      ),
    );
  }
}

class _Body extends StatelessWidget {
  final CvViewModel viewModel;

  const _Body(this.viewModel);

  @override
  Widget build(BuildContext context) {
    if (viewModel.apiPeKo) {
      return _ApiPeKo(viewModel);
    }
    switch (viewModel.displayState) {
      case DisplayState.LOADING:
        return Center(child: CircularProgressIndicator());
      case DisplayState.CONTENT:
        return _Content(viewModel);
      case DisplayState.EMPTY:
        return _Empty();
      case DisplayState.FAILURE:
        return Center(child: Retry(Strings.cvError, () => viewModel.retry()));
    }
  }
}

class _Empty extends StatelessWidget {
  const _Empty({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(Strings.cvEmpty, style: TextStyles.textMBold, textAlign: TextAlign.center),
          SizedBox(height: Margins.spacing_m),
          PrimaryActionButton(onPressed: () => Navigator.of(context).pop(), label: Strings.cvEmptyButton),
        ],
      ),
    );
  }
}

class _Content extends StatelessWidget {
  final CvViewModel viewModel;

  const _Content(this.viewModel);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(Strings.cvListPageSubtitle, style: TextStyles.textBaseRegular),
        SizedBox(height: Margins.spacing_m),
        Expanded(child: _CvListView(viewModel)),
        PreviewFileInvisibleHandler(),
      ],
    );
  }
}

class _CvListView extends StatelessWidget {
  final CvViewModel viewModel;

  const _CvListView(this.viewModel);

  @override
  Widget build(BuildContext context) {
    final List<CvPoleEmploi> cvList = viewModel.cvList;
    return ListView.builder(
      itemCount: cvList.length,
      itemBuilder: (context, index) {
        final cv = cvList[index];
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: Margins.spacing_s),
          child: CardContainer(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(cv.titre, style: TextStyles.textMBold),
                SizedBox(height: Margins.spacing_base),
                viewModel.downloadStatus(cv.url).isLoading()
                    ? Center(child: CircularProgressIndicator())
                    : SecondaryButton(
                        label: Strings.cvDownload,
                        icon: AppIcons.download_rounded,
                        onPressed: () => viewModel.onDownload(cv),
                      )
              ],
            ),
          ),
        );
      },
    );
  }
}

class _ApiPeKo extends StatelessWidget {
  const _ApiPeKo(this.viewModel);

  final CvViewModel viewModel;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Expanded(
          child: Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  AppIcons.construction,
                  size: 80,
                  color: AppColors.primary,
                ),
                SizedBox(height: Margins.spacing_m),
                Text(Strings.cvErrorApiPeKoMessage, style: TextStyles.textBaseBold, textAlign: TextAlign.center),
              ],
            ),
          ),
        ),
        PrimaryActionButton(
          label: Strings.cvErrorApiPeKoButton,
          icon: AppIcons.refresh_rounded,
          onPressed: viewModel.retry,
        ),
        SizedBox(height: Margins.spacing_huge),
      ],
    );
  }
}
