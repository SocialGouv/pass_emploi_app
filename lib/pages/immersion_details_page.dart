import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:matomo/matomo.dart';
import 'package:pass_emploi_app/analytics/analytics_constants.dart';
import 'package:pass_emploi_app/presentation/display_state.dart';
import 'package:pass_emploi_app/presentation/immersion_details_view_model.dart';
import 'package:pass_emploi_app/redux/actions/named_actions.dart';
import 'package:pass_emploi_app/redux/states/app_state.dart';
import 'package:pass_emploi_app/ui/app_colors.dart';
import 'package:pass_emploi_app/ui/margins.dart';
import 'package:pass_emploi_app/ui/strings.dart';
import 'package:pass_emploi_app/ui/text_styles.dart';
import 'package:pass_emploi_app/widgets/action_buttons.dart';
import 'package:pass_emploi_app/widgets/default_animated_switcher.dart';
import 'package:pass_emploi_app/widgets/default_app_bar.dart';
import 'package:pass_emploi_app/widgets/immersion_tags.dart';
import 'package:pass_emploi_app/widgets/retry.dart';
import 'package:pass_emploi_app/widgets/sepline.dart';
import 'package:url_launcher/url_launcher.dart';

class ImmersionDetailsPage extends TraceableStatelessWidget {
  final String _immersionId;

  ImmersionDetailsPage._(this._immersionId) : super(name: AnalyticsScreenNames.immersionDetails);

  static MaterialPageRoute materialPageRoute(String id) {
    return MaterialPageRoute(builder: (context) => ImmersionDetailsPage._(id));
  }

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, ImmersionDetailsViewModel>(
      onInit: (store) => store.dispatch(ImmersionDetailsAction.request(_immersionId)),
      onDispose: (store) => store.dispatch(ImmersionDetailsAction.reset()),
      converter: (store) => ImmersionDetailsViewModel.create(store),
      builder: (context, viewModel) => _scaffold(_body(context, viewModel)),
      distinct: true,
    );
  }

  Widget _body(BuildContext context, ImmersionDetailsViewModel viewModel) {
    switch (viewModel.displayState) {
      case DisplayState.CONTENT:
        return _content(context, viewModel);
      case DisplayState.LOADING:
        return _loading();
      default:
        return Retry(Strings.offreDetailsError, () => viewModel.onRetry(_immersionId));
    }
  }

  Scaffold _scaffold(Widget body) {
    return Scaffold(
      appBar: FlatDefaultAppBar(title: Text(Strings.offreDetails, style: TextStyles.textLgMedium)),
      body: Center(child: DefaultAnimatedSwitcher(child: body)),
    );
  }

  Widget _loading() => CircularProgressIndicator(color: AppColors.nightBlue);

  Widget _content(BuildContext context, ImmersionDetailsViewModel viewModel) {
    return Stack(
      children: [
        SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(Margins.medium, Margins.medium, Margins.medium, 100),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(viewModel.title, style: TextStyles.textLgMedium),
                SizedBox(height: 20),
                Text(viewModel.companyName, style: TextStyles.textMdRegular),
                SizedBox(height: 20),
                ImmersionTags(secteurActivite: viewModel.secteurActivite, ville: viewModel.ville),
                SizedBox(height: 20),
                Text(viewModel.explanationLabel, style: TextStyles.textMdRegular),
                SizedBox(height: 20),
                Text(Strings.immersionDescriptionLabel, style: TextStyles.textMdRegular),
                SizedBox(height: 20),
                _contactBlock(viewModel),
              ],
            ),
          ),
        ),
        Align(
          child: _footer(context, "url"),
          alignment: Alignment.bottomCenter,
        )
      ],
    );
  }

  Widget _contactBlock(ImmersionDetailsViewModel viewModel) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(Strings.immersionContactTitle, style: TextStyles.chapoSemi()),
        SepLine(12, 20),
        if (viewModel.contactLabel.isNotEmpty)
          Padding(
            padding: const EdgeInsets.only(bottom: 20),
            child: Text(viewModel.contactLabel, style: TextStyles.textSmMedium()),
          ),
        Text(viewModel.contactInformation, style: TextStyles.textSmRegular()),
      ],
    );
  }

  //geo:0,0?q=my+street+address
  //Service des ressources humaines, 40 RUE DU DEPUTE HALLEZ, 67500 HAGUENAU

  String? encodeQueryParameters(Map<String, String> params) {
    return params.entries.map((e) => '${Uri.encodeComponent(e.key)}=${Uri.encodeComponent(e.value)}').join('&');
  }

  Widget _footer(BuildContext context, String url) {
    final Uri uri = Uri(
      scheme: 'geo',
      path: '0,0',
      query: encodeQueryParameters(
          <String, String>{'q': 'Service des ressources humaines, 40 RUE DU DEPUTE HALLEZ, 67500 HAGUENAU'}),
    );

    return Container(
      color: Colors.white,
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          Expanded(child: actionButton(onPressed: () => launch(uri.toString()), label: Strings.postulerButtonTitle)),
        ],
      ),
    );
  }
}
