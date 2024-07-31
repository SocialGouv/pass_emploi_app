import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:pass_emploi_app/analytics/analytics_constants.dart';
import 'package:pass_emploi_app/analytics/tracker.dart';
import 'package:pass_emploi_app/features/demarche/search/seach_demarche_actions.dart';
import 'package:pass_emploi_app/pages/demarche/create_demarche_step2_page.dart';
import 'package:pass_emploi_app/pages/demarche/demarche_detail_page.dart';
import 'package:pass_emploi_app/pages/demarche/thematiques_demarche_page.dart';
import 'package:pass_emploi_app/pages/demarche/top_demarche_page.dart';
import 'package:pass_emploi_app/presentation/demarche/create_demarche_step1_view_model.dart';
import 'package:pass_emploi_app/presentation/demarche/demarche_source.dart';
import 'package:pass_emploi_app/redux/app_state.dart';
import 'package:pass_emploi_app/ui/app_colors.dart';
import 'package:pass_emploi_app/ui/app_icons.dart';
import 'package:pass_emploi_app/ui/margins.dart';
import 'package:pass_emploi_app/ui/strings.dart';
import 'package:pass_emploi_app/ui/text_styles.dart';
import 'package:pass_emploi_app/utils/pass_emploi_matomo_tracker.dart';
import 'package:pass_emploi_app/widgets/buttons/primary_action_button.dart';
import 'package:pass_emploi_app/widgets/cards/generic/card_container.dart';
import 'package:pass_emploi_app/widgets/default_app_bar.dart';
import 'package:pass_emploi_app/widgets/pressed_tip.dart';
import 'package:pass_emploi_app/widgets/snack_bar/show_snack_bar.dart';
import 'package:pass_emploi_app/widgets/text_form_fields/base_text_form_field.dart';

const _minQueryLength = 2;

class CreateDemarcheStep1Page extends StatefulWidget {
  static MaterialPageRoute<String?> materialPageRoute() {
    return MaterialPageRoute(builder: (context) => CreateDemarcheStep1Page());
  }

  static void showDemarcheSnackBarWithDetail(BuildContext context, String demarcheId) {
    PassEmploiMatomoTracker.instance.trackEvent(
      eventCategory: AnalyticsEventNames.createActionEventCategory,
      action: AnalyticsEventNames.createActionDisplaySnackBarAction,
    );
    // As context is not available anymore in callback, navigator needs to be instantiated here.
    final navigator = Navigator.of(context);
    showSnackBarWithSuccess(
      context,
      Strings.createDemarcheSuccess,
      () {
        PassEmploiMatomoTracker.instance.trackEvent(
          eventCategory: AnalyticsEventNames.createActionEventCategory,
          action: AnalyticsEventNames.createActionClickOnSnackBarAction,
        );
        navigator.push(DemarcheDetailPage.materialPageRoute(demarcheId));
      },
    );
  }

  @override
  State<CreateDemarcheStep1Page> createState() => _CreateDemarcheStep1PageState();
}

class _CreateDemarcheStep1PageState extends State<CreateDemarcheStep1Page> {
  String _query = '';

  @override
  Widget build(BuildContext context) {
    return Tracker(
      tracking: AnalyticsScreenNames.searchDemarcheStep1,
      child: StoreConnector<AppState, CreateDemarcheStep1ViewModel>(
        builder: _buildBody,
        converter: (store) => CreateDemarcheStep1ViewModel.create(store),
        onDispose: (store) => store.dispatch(SearchDemarcheResetAction()),
        distinct: true,
      ),
    );
  }

  Widget _buildBody(BuildContext context, CreateDemarcheStep1ViewModel viewModel) {
    return Scaffold(
      appBar: SecondaryAppBar(title: Strings.createDemarcheTitle),
      body: Padding(
        padding: const EdgeInsets.all(Margins.spacing_base),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _Subtitle(text: Strings.demarcheRechercheSubtitle),
              SizedBox(height: Margins.spacing_base),
              Text(Strings.searchDemarcheHint, style: TextStyles.textBaseMedium),
              SizedBox(height: Margins.spacing_base),
              _ChampRecherche(
                onChanged: (value) => setState(() => _query = value),
              ),
              SizedBox(height: Margins.spacing_xl),
              SizedBox(
                width: double.infinity,
                child: PrimaryActionButton(
                  icon: AppIcons.search_rounded,
                  label: Strings.searchDemarcheButton,
                  onPressed: _query.trim().length >= _minQueryLength
                      ? () => _onSearchStarted(viewModel, context) //
                      : null,
                ),
              ),
              SizedBox(height: Margins.spacing_xl),
              _Subtitle(text: Strings.demarcheCategoriesSubtitle),
              SizedBox(height: Margins.spacing_base),
              _ThematicCard(),
              SizedBox(height: Margins.spacing_base),
              _TopDemarcheCard(),
              SizedBox(height: Margins.spacing_huge),
            ],
          ),
        ),
      ),
    );
  }

  void _onSearchStarted(CreateDemarcheStep1ViewModel viewModel, BuildContext context) {
    viewModel.onSearchDemarche(_query);

    Navigator.push(
        context,
        CreateDemarcheStep2Page.materialPageRoute(
          source: RechercheDemarcheSource(),
          query: _query,
        ));
  }
}

class _ThematicCard extends StatelessWidget {
  const _ThematicCard();

  @override
  Widget build(BuildContext context) {
    return _DemarcheCardBase(
      icon: AppIcons.signpost_rounded,
      title: Strings.demarcheThematiqueTitle,
      description: Strings.demarchesCategoriesDescription,
      pressedTip: Strings.demarchesCategoriesPressedTip,
      onTap: () {
        Navigator.push(context, ThematiqueDemarchePage.materialPageRoute());
      },
    );
  }
}

class _TopDemarcheCard extends StatelessWidget {
  const _TopDemarcheCard();

  @override
  Widget build(BuildContext context) {
    return _DemarcheCardBase(
      icon: AppIcons.favorite_rounded,
      title: Strings.topDemarchesTitle,
      description: Strings.topDemarchesSubtitle,
      pressedTip: Strings.topDemarchesPressedTip,
      onTap: () {
        Navigator.push(context, TopDemarchePage.materialPageRoute());
      },
    );
  }
}

class _DemarcheCardBase extends StatelessWidget {
  const _DemarcheCardBase({
    required this.icon,
    required this.title,
    required this.description,
    required this.pressedTip,
    this.onTap,
  });

  final IconData icon;
  final String title;
  final String description;
  final String pressedTip;
  final void Function()? onTap;

  @override
  Widget build(BuildContext context) {
    return CardContainer(
        onTap: onTap,
        child: Column(
          children: [
            Row(
              children: [
                Icon(icon, color: AppColors.primary),
                SizedBox(width: Margins.spacing_s),
                Text(title, style: TextStyles.textMBold),
              ],
            ),
            SizedBox(height: Margins.spacing_base),
            Text(description, style: TextStyles.textBaseRegular),
            SizedBox(height: Margins.spacing_base),
            PressedTip(pressedTip),
          ],
        ));
  }
}

class _Subtitle extends StatelessWidget {
  const _Subtitle({
    required this.text,
  });

  final String text;

  @override
  Widget build(BuildContext context) {
    return Text(text, style: TextStyles.textMBold.copyWith(color: AppColors.grey800));
  }
}

class _ChampRecherche extends StatefulWidget {
  final ValueChanged<String> onChanged;

  const _ChampRecherche({required this.onChanged});

  @override
  State<_ChampRecherche> createState() => _ChampRechercheState();
}

class _ChampRechercheState extends State<_ChampRecherche> {
  late final TextEditingController _controller;
  int changeCount = 0;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController();
    _controller.addListener(() => onChanged(_controller.text));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void onChanged(String value) {
    setState(() {
      changeCount++;
    });
  }

  @override
  Widget build(BuildContext context) {
    return BaseTextField(
      controller: _controller,
      keyboardType: TextInputType.text,
      textInputAction: TextInputAction.done,
      errorText: changeCount > 1 && _controller.text.trim().isEmpty ? Strings.mandatoryField : null,
      onChanged: widget.onChanged,
    );
  }
}
