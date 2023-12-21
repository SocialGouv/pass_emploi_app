import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:pass_emploi_app/analytics/analytics_constants.dart';
import 'package:pass_emploi_app/analytics/tracker.dart';
import 'package:pass_emploi_app/pages/demarche/create_custom_demarche.dart';
import 'package:pass_emploi_app/pages/demarche/create_demarche_step3_page.dart';
import 'package:pass_emploi_app/presentation/demarche/create_demarche_step2_view_model.dart';
import 'package:pass_emploi_app/presentation/demarche/demarche_source.dart';
import 'package:pass_emploi_app/presentation/display_state.dart';
import 'package:pass_emploi_app/redux/app_state.dart';
import 'package:pass_emploi_app/ui/app_icons.dart';
import 'package:pass_emploi_app/ui/margins.dart';
import 'package:pass_emploi_app/ui/strings.dart';
import 'package:pass_emploi_app/ui/text_styles.dart';
import 'package:pass_emploi_app/widgets/buttons/primary_action_button.dart';
import 'package:pass_emploi_app/widgets/cards/demarche_du_referentiel_card.dart';
import 'package:pass_emploi_app/widgets/default_app_bar.dart';
import 'package:pass_emploi_app/widgets/illustration/empty_state_placeholder.dart';
import 'package:pass_emploi_app/widgets/illustration/illustration.dart';

class CreateDemarcheStep2Page extends StatelessWidget {
  const CreateDemarcheStep2Page({super.key, required this.source, this.query, this.analyticsDetailsName});

  static MaterialPageRoute<String?> materialPageRoute({
    required DemarcheSource source,
    String? query,
    String? analyticsDetailsName,
  }) {
    return MaterialPageRoute(
      builder: (context) => CreateDemarcheStep2Page(
        source: source,
        query: query,
        analyticsDetailsName: analyticsDetailsName,
      ),
    );
  }

  final DemarcheSource source;
  final String? query;
  final String? analyticsDetailsName;

  @override
  Widget build(BuildContext context) {
    return Tracker(
      tracking: analyticsName(source, analyticsDetailsName: analyticsDetailsName),
      child: StoreConnector<AppState, CreateDemarcheStep2ViewModel>(
        builder: _buildBody,
        converter: (store) => CreateDemarcheStep2ViewModel.create(store, source, query: query),
        distinct: true,
      ),
    );
  }

  Widget _buildBody(BuildContext context, CreateDemarcheStep2ViewModel viewModel) {
    return Scaffold(
        appBar: SecondaryAppBar(title: Strings.createDemarcheTitle),
        body: switch (viewModel.displayState) {
          DisplayState.chargement => Center(child: CircularProgressIndicator()),
          DisplayState.erreur => _ErrorMessage(viewModel),
          DisplayState.contenu || DisplayState.vide => _Content(
              source: source,
              query: query,
              viewModel: viewModel,
            ),
        });
  }

  String analyticsName(DemarcheSource source, {String? analyticsDetailsName}) {
    final sanitizedName = analyticsDetailsName ?? "unknown";
    return switch (source) {
      ThematiqueDemarcheSource() => AnalyticsScreenNames.thematiquesDemarcheDetails(sanitizedName),
      _ => AnalyticsScreenNames.searchDemarcheStep2,
    };
  }
}

class _Content extends StatelessWidget {
  const _Content({required this.source, required this.query, required this.viewModel});

  final DemarcheSource source;
  final String? query;
  final CreateDemarcheStep2ViewModel viewModel;

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      itemCount: viewModel.items.length,
      padding: const EdgeInsets.all(Margins.spacing_m),
      separatorBuilder: (context, index) => SizedBox(height: Margins.spacing_base),
      itemBuilder: (context, index) {
        final item = viewModel.items[index];
        return switch (item) {
          final CreateDemarcheStep2TitleItem item => Text(item.title, style: TextStyles.textBaseMedium),
          final CreateDemarcheStep2DemarcheFoundItem item => DemarcheDuReferentielCard(
              source: source,
              idDemarche: item.idDemarche,
              onTap: () {
                Navigator.push(context, CreateDemarcheStep3Page.materialPageRoute(item.idDemarche, source))
                    .then((value) {
                  // forward result to previous page
                  if (value != null) Navigator.pop(context, value);
                });
              },
            ),
          CreateDemarcheStep2ButtonItem() => CreateCustomDemarche(),
          CreateDemarcheStep2EmptyItem() => _EmptyPlaceholder(query: query),
        };
      },
    );
  }
}

class _EmptyPlaceholder extends StatelessWidget {
  final String? query;

  _EmptyPlaceholder({this.query});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: EmptyStatePlaceholder(
        illustration: Illustration.grey(Icons.search, withWhiteBackground: true),
        title: query != null
            ? Strings.createDemarcheStep2EmptyTitleWithQuery(query!)
            : Strings.createDemarcheStep2EmptyTitle,
        subtitle: Strings.createDemarcheStep2EmptySubtitle,
      ),
    );
  }
}

class _ErrorMessage extends StatelessWidget {
  const _ErrorMessage(this.viewModel);
  final CreateDemarcheStep2ViewModel viewModel;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: Margins.spacing_base),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            EmptyStatePlaceholder(
              illustration: Illustration.orange(AppIcons.construction),
              title: Strings.thematiquesErrorTitle,
              subtitle: Strings.thematiquesErrorSubtitle,
            ),
            const SizedBox(height: Margins.spacing_m),
            PrimaryActionButton(label: Strings.retry, onPressed: viewModel.onRetry),
            const SizedBox(height: Margins.spacing_xl),
            CreateCustomDemarche(),
          ],
        ),
      ),
    );
  }
}
