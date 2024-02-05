import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:pass_emploi_app/analytics/analytics_constants.dart';
import 'package:pass_emploi_app/analytics/tracker.dart';
import 'package:pass_emploi_app/features/agenda/agenda_actions.dart';
import 'package:pass_emploi_app/network/post_tracking_event_request.dart';
import 'package:pass_emploi_app/pages/demarche/create_demarche_step1_page.dart';
import 'package:pass_emploi_app/pages/demarche/demarche_detail_page.dart';
import 'package:pass_emploi_app/presentation/agenda/agenda_view_model.dart';
import 'package:pass_emploi_app/presentation/demarche/demarche_state_source.dart';
import 'package:pass_emploi_app/presentation/display_state.dart';
import 'package:pass_emploi_app/presentation/rendezvous/rendezvous_state_source.dart';
import 'package:pass_emploi_app/redux/app_state.dart';
import 'package:pass_emploi_app/ui/animation_durations.dart';
import 'package:pass_emploi_app/ui/app_colors.dart';
import 'package:pass_emploi_app/ui/app_icons.dart';
import 'package:pass_emploi_app/ui/dimens.dart';
import 'package:pass_emploi_app/ui/margins.dart';
import 'package:pass_emploi_app/ui/strings.dart';
import 'package:pass_emploi_app/ui/text_styles.dart';
import 'package:pass_emploi_app/utils/context_extensions.dart';
import 'package:pass_emploi_app/utils/pass_emploi_matomo_tracker.dart';
import 'package:pass_emploi_app/widgets/animated_list_loader.dart';
import 'package:pass_emploi_app/widgets/big_title_separator.dart';
import 'package:pass_emploi_app/widgets/buttons/primary_action_button.dart';
import 'package:pass_emploi_app/widgets/cards/demarche_card.dart';
import 'package:pass_emploi_app/widgets/cards/generic/card_container.dart';
import 'package:pass_emploi_app/widgets/cards/rendezvous_card.dart';
import 'package:pass_emploi_app/widgets/default_animated_switcher.dart';
import 'package:pass_emploi_app/widgets/illustration/empty_state_placeholder.dart';
import 'package:pass_emploi_app/widgets/illustration/illustration.dart';
import 'package:pass_emploi_app/widgets/not_up_to_date_message.dart';
import 'package:pass_emploi_app/widgets/retry.dart';
import 'package:pass_emploi_app/widgets/snack_bar/show_snack_bar.dart';

class AgendaPage extends StatelessWidget {
  final Function() onActionDelayedTap;

  AgendaPage(this.onActionDelayedTap);

  @override
  Widget build(BuildContext context) {
    return Tracker(
      tracking: AnalyticsScreenNames.agenda,
      child: StoreConnector<AppState, AgendaPageViewModel>(
        onInit: (store) => store.dispatch(AgendaRequestAction(DateTime.now())),
        onDidChange: (previous, current) => _onDidChange(context, previous, current),
        builder: (context, viewModel) => _Scaffold(viewModel: viewModel, onActionDelayedTap: onActionDelayedTap),
        converter: (store) => AgendaPageViewModel.create(store),
        distinct: true,
      ),
    );
  }

  void _onDidChange(BuildContext context, AgendaPageViewModel? previous, AgendaPageViewModel current) {
    if (previous?.isReloading == true && _currentAgendaIsUpToDate(current)) {
      showSnackBarWithInformation(context, Strings.agendaPeUpToDate);
    }
  }

  bool _currentAgendaIsUpToDate(AgendaPageViewModel current) {
    return [DisplayState.CONTENT, DisplayState.EMPTY].contains(current.displayState) &&
        (current.events.isEmpty || current.events.first is! NotUpToDateAgendaItem);
  }
}

class _Scaffold extends StatelessWidget {
  final AgendaPageViewModel viewModel;
  final Function() onActionDelayedTap;

  const _Scaffold({required this.viewModel, required this.onActionDelayedTap});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.grey100,
      body: Stack(children: [
        DefaultAnimatedSwitcher(child: _Body(viewModel: viewModel, onActionDelayedTap: onActionDelayedTap)),
        _CreateButton(
          label: Strings.addADemarche,
          onPressed: () => Navigator.push(context, CreateDemarcheStep1Page.materialPageRoute()).then((value) {
            if (value != null) _showDemarcheSnackBarWithDetail(context, value);
          }),
        ),
      ]),
    );
  }

  void _showDemarcheSnackBarWithDetail(BuildContext context, String demarcheId) {
    PassEmploiMatomoTracker.instance.trackEvent(
      eventCategory: AnalyticsEventNames.createActionEventCategory,
      action: AnalyticsEventNames.createActionDisplaySnackBarAction,
    );
    showSnackBarWithSuccess(
      context,
      Strings.createDemarcheSuccess,
      () {
        PassEmploiMatomoTracker.instance.trackEvent(
          eventCategory: AnalyticsEventNames.createActionEventCategory,
          action: AnalyticsEventNames.createActionClickOnSnackBarAction,
        );
        Navigator.push(context, DemarcheDetailPage.materialPageRoute(demarcheId, DemarcheStateSource.agenda));
      },
    );
  }
}

class _CreateButton extends StatelessWidget {
  final String label;
  final VoidCallback onPressed;

  const _CreateButton({required this.label, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.bottomCenter,
      child: Padding(
        padding: const EdgeInsets.only(bottom: 24),
        child: PrimaryActionButton(
          label: label,
          icon: AppIcons.add_rounded,
          rippleColor: AppColors.primaryDarken,
          onPressed: onPressed,
        ),
      ),
    );
  }
}

class _Body extends StatelessWidget {
  final AgendaPageViewModel viewModel;
  final Function() onActionDelayedTap;

  const _Body({required this.viewModel, required this.onActionDelayedTap});

  @override
  Widget build(BuildContext context) {
    return AnimatedSwitcher(
      duration: AnimationDurations.fast,
      child: switch (viewModel.displayState) {
        DisplayState.LOADING => _AgendaLoading(),
        DisplayState.CONTENT => _Content(viewModel: viewModel, onActionDelayedTap: onActionDelayedTap),
        DisplayState.EMPTY => SizedBox.shrink(),
        DisplayState.FAILURE => _Retry(viewModel: viewModel),
      },
    );
  }
}

class _Retry extends StatelessWidget {
  final AgendaPageViewModel viewModel;

  const _Retry({required this.viewModel});

  @override
  Widget build(BuildContext context) {
    return Center(
        child: Padding(
      padding: const EdgeInsets.symmetric(horizontal: Margins.spacing_base),
      child: Retry(Strings.agendaError, () => viewModel.reload(DateTime.now())),
    ));
  }
}

class _Content extends StatelessWidget {
  final AgendaPageViewModel viewModel;
  final Function() onActionDelayedTap;

  const _Content({required this.viewModel, required this.onActionDelayedTap});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: Margins.spacing_base),
      child: RefreshIndicator.adaptive(
        onRefresh: () async => viewModel.reload(DateTime.now()),
        child: ListView.builder(
          clipBehavior: Clip.none,
          padding: const EdgeInsets.only(top: Margins.spacing_base, bottom: Margins.spacing_x_huge),
          itemCount: viewModel.events.length,
          itemBuilder: (context, index) {
            final item = viewModel.events[index];
            return switch (item) {
              final WeekSeparatorAgendaItem item => _WeekSeparator(item),
              final DaySeparatorAgendaItem item => _DaySeparatorAgendaItem(item),
              final EmptyMessageAgendaItem item => _MessageAgendaItem(item),
              final RendezvousAgendaItem item => _RendezvousAgendaItem(item),
              final SessionMiloAgendaItem item => _SessionMiloAgendaItem(item),
              final DemarcheAgendaItem item => _DemarcheAgendaItem(item),
              final DelayedActionsBannerAgendaItem item => _DelayedActionsBanner(item, onActionDelayedTap),
              final NotUpToDateAgendaItem _ => _NotUpToDateMessage(viewModel),
              EmptyAgendaItem() => _EmptyPlaceholder(),
            };
          },
        ),
      ),
    );
  }
}

class _EmptyPlaceholder extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: EmptyStatePlaceholder(
        illustration: Illustration.grey(Icons.calendar_today_rounded, withWhiteBackground: true),
        title: Strings.agendaEmptyTitle,
        subtitle: Strings.agendaEmptySubtitlePoleEmploi,
      ),
    );
  }
}

class _NotUpToDateMessage extends StatelessWidget {
  final AgendaPageViewModel _viewModel;

  const _NotUpToDateMessage(this._viewModel);

  @override
  Widget build(BuildContext context) {
    return NotUpToDateMessage(
      message: Strings.agendaPeNotUpToDate,
      margin: EdgeInsets.only(bottom: Margins.spacing_base),
      onRefresh: () => _viewModel.reload(DateTime.now()),
    );
  }
}

class _DelayedActionsBanner extends StatelessWidget {
  final DelayedActionsBannerAgendaItem banner;
  final Function() onActionDelayedTap;

  _DelayedActionsBanner(this.banner, this.onActionDelayedTap);

  @override
  Widget build(BuildContext context) {
    return CardContainer(
      onTap: onActionDelayedTap,
      child: Row(
        mainAxisSize: MainAxisSize.max,
        children: [
          _WarningIcon(),
          _NumberOfDelayedActions(banner.delayedLabel),
          Text(Strings.see, style: TextStyles.textBaseRegular),
          _ChevronIcon(),
        ],
      ),
    );
  }
}

class _WarningIcon extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 10),
      child: Icon(AppIcons.error_rounded, color: AppColors.warning, size: Dimens.icon_size_m),
    );
  }
}

class _ChevronIcon extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10.0),
      child: Icon(AppIcons.chevron_right_rounded, color: AppColors.contentColor),
    );
  }
}

class _NumberOfDelayedActions extends StatelessWidget {
  final String delayedLabel;

  _NumberOfDelayedActions(this.delayedLabel);

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: RichText(
        text: TextSpan(
          children: [
            TextSpan(text: Strings.late, style: TextStyles.textBaseBoldWithColor(AppColors.warning)),
            TextSpan(text: delayedLabel, style: TextStyles.textSRegularWithColor(AppColors.warning))
          ],
        ),
      ),
    );
  }
}

class _WeekSeparator extends StatelessWidget {
  final WeekSeparatorAgendaItem weekSeparator;

  const _WeekSeparator(this.weekSeparator);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: Margins.spacing_m, bottom: Margins.spacing_base),
      child: BigTitleSeparator(weekSeparator.text),
    );
  }
}

class _DaySeparatorAgendaItem extends StatelessWidget {
  final DaySeparatorAgendaItem daySeparatorAgendaItem;

  _DaySeparatorAgendaItem(this.daySeparatorAgendaItem);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: Margins.spacing_base, bottom: Margins.spacing_s),
      child: Align(
        alignment: Alignment.centerLeft,
        child: Text(daySeparatorAgendaItem.text, style: TextStyles.textBaseMedium),
      ),
    );
  }
}

class _MessageAgendaItem extends StatelessWidget {
  final EmptyMessageAgendaItem emptyMessageAgendaItem;

  const _MessageAgendaItem(this.emptyMessageAgendaItem);

  @override
  Widget build(BuildContext context) {
    return Text(
      emptyMessageAgendaItem.text,
      style: TextStyles.textBaseRegularWithColor(AppColors.grey700),
    );
  }
}

class _RendezvousAgendaItem extends StatelessWidget {
  final RendezvousAgendaItem rendezvousAgendaItem;

  const _RendezvousAgendaItem(this.rendezvousAgendaItem);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: Margins.spacing_s),
      child: rendezvousAgendaItem.rendezvousId.rendezvousCard(
        context: context,
        stateSource: RendezvousStateSource.agenda,
        trackedEvent: EventType.RDV_DETAIL,
      ),
    );
  }
}

class _SessionMiloAgendaItem extends StatelessWidget {
  final SessionMiloAgendaItem sessionMiloAgendaItem;

  const _SessionMiloAgendaItem(this.sessionMiloAgendaItem);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: Margins.spacing_s),
      child: sessionMiloAgendaItem.sessionId.rendezvousCard(
        context: context,
        stateSource: RendezvousStateSource.monSuiviSessionMilo,
        trackedEvent: EventType.RDV_DETAIL,
      ),
    );
  }
}

class _DemarcheAgendaItem extends StatelessWidget {
  final DemarcheAgendaItem demarcheAgendaItem;

  const _DemarcheAgendaItem(this.demarcheAgendaItem);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: Margins.spacing_s),
      child: DemarcheCard(
        demarcheId: demarcheAgendaItem.demarcheId,
        stateSource: DemarcheStateSource.agenda,
        onTap: () {
          context.trackEvent(EventType.ACTION_DETAIL);
          Navigator.push(
            context,
            DemarcheDetailPage.materialPageRoute(demarcheAgendaItem.demarcheId, DemarcheStateSource.agenda),
          );
        },
      ),
    );
  }
}

class _AgendaLoading extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final placeholders = _placeholders(screenWidth);
    return AnimatedListLoader(
      placeholders: placeholders,
    );
  }

  List<Widget> _placeholders(double screenWidth) => [
        SizedBox(height: Margins.spacing_base),
        AnimatedListLoader.placeholderBuilder(
          width: screenWidth * 0.4,
          height: 35,
        ),
        SizedBox(height: Margins.spacing_base),
        AnimatedListLoader.placeholderBuilder(
          width: screenWidth,
          height: 180,
        ),
        SizedBox(height: Margins.spacing_m),
        AnimatedListLoader.placeholderBuilder(
          width: screenWidth * 0.4,
          height: 35,
        ),
        SizedBox(height: Margins.spacing_base),
        AnimatedListLoader.placeholderBuilder(
          width: screenWidth,
          height: 180,
        ),
        SizedBox(height: Margins.spacing_m),
        AnimatedListLoader.placeholderBuilder(
          width: screenWidth * 0.4,
          height: 35,
        ),
        SizedBox(height: Margins.spacing_base),
        AnimatedListLoader.placeholderBuilder(
          width: screenWidth,
          height: 180,
        ),
      ];
}
