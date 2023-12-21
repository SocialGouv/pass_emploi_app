import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:pass_emploi_app/analytics/tracker.dart';
import 'package:pass_emploi_app/features/rendezvous/list/rendezvous_list_actions.dart';
import 'package:pass_emploi_app/network/post_tracking_event_request.dart';
import 'package:pass_emploi_app/pages/rendezvous/rendezvous_details_page.dart';
import 'package:pass_emploi_app/pages/rendezvous/rendezvous_list_loader.dart';
import 'package:pass_emploi_app/presentation/display_state.dart';
import 'package:pass_emploi_app/presentation/rendezvous/list/rendezvous_list_view_model.dart';
import 'package:pass_emploi_app/presentation/rendezvous/rendezvous_state_source.dart';
import 'package:pass_emploi_app/redux/app_state.dart';
import 'package:pass_emploi_app/ui/app_colors.dart';
import 'package:pass_emploi_app/ui/app_icons.dart';
import 'package:pass_emploi_app/ui/margins.dart';
import 'package:pass_emploi_app/ui/strings.dart';
import 'package:pass_emploi_app/ui/text_styles.dart';
import 'package:pass_emploi_app/widgets/big_title_separator.dart';
import 'package:pass_emploi_app/widgets/buttons/primary_action_button.dart';
import 'package:pass_emploi_app/widgets/buttons/secondary_icon_button.dart';
import 'package:pass_emploi_app/widgets/cards/rendezvous_card.dart';
import 'package:pass_emploi_app/widgets/default_animated_switcher.dart';
import 'package:pass_emploi_app/widgets/default_app_bar.dart';
import 'package:pass_emploi_app/widgets/illustration/illustration.dart';
import 'package:pass_emploi_app/widgets/not_up_to_date_message.dart';
import 'package:pass_emploi_app/widgets/refresh_indicator_ext.dart';
import 'package:pass_emploi_app/widgets/retry.dart';
import 'package:pass_emploi_app/widgets/sepline.dart';
import 'package:pass_emploi_app/widgets/snack_bar/show_snack_bar.dart';

class RendezvousListPage extends StatefulWidget {
  static MaterialPageRoute<void> materialPageRoute() {
    return MaterialPageRoute(
      builder: (context) {
        return Scaffold(appBar: SecondaryAppBar(title: Strings.rendezvousTabTitle), body: RendezvousListPage());
      },
    );
  }

  @override
  State<RendezvousListPage> createState() => _RendezvousListPageState();
}

class _RendezvousListPageState extends State<RendezvousListPage> {
  int _pageOffset = 0;

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, RendezvousListViewModel>(
      onInit: (store) => RendezvousListViewModel.fetchRendezvous(store, _pageOffset),
      converter: (store) => RendezvousListViewModel.create(store, DateTime.now(), _pageOffset),
      builder: _builder,
      onDidChange: _onDidChange,
      distinct: true,
      key: ValueKey(_pageOffset),
    );
  }

  @override
  void deactivate() {
    StoreProvider.of<AppState>(context).dispatch(RendezvousListResetAction());
    super.deactivate();
  }

  Widget _builder(BuildContext context, RendezvousListViewModel viewModel) {
    return Tracker(
      tracking: viewModel.analyticsLabel,
      child: _Scaffold(
        body: _Body(
          viewModel: viewModel,
          onPageOffsetChanged: (i) {
            final newOffset = _pageOffset + i;
            setState(() {
              _pageOffset = newOffset;
            });
          },
          onNextRendezvousButtonTap: () {
            setState(() {
              _pageOffset = viewModel.nextRendezvousPageOffset!;
            });
          },
        ),
      ),
    );
  }

  void _onDidChange(RendezvousListViewModel? previous, RendezvousListViewModel current) {
    _openDeeplinkIfNeeded(current, context);
    if (previous?.isReloading == true && _currentRendezvousAreUpToDate(current)) {
      showSnackBarWithInformation(context, Strings.rendezvousUpToDate);
    }
  }

  bool _currentRendezvousAreUpToDate(RendezvousListViewModel current) {
    return [DisplayState.contenu, DisplayState.vide].contains(current.displayState) &&
        (current.rendezvousItems.isEmpty || current.rendezvousItems.first is! RendezvousNotUpToDateItem);
  }

  void _openDeeplinkIfNeeded(RendezvousListViewModel viewModel, BuildContext context) {
    if (viewModel.deeplink != null) {
      Navigator.push(
        context,
        RendezvousDetailsPage.materialPageRoute(viewModel.deeplink!.source, viewModel.deeplink!.deeplinkId),
      );
      viewModel.onDeeplinkUsed();
    }
  }
}

class _Scaffold extends StatelessWidget {
  final Widget body;

  const _Scaffold({required this.body});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.grey100,
      body: Center(child: DefaultAnimatedSwitcher(child: body)),
    );
  }
}

class _Body extends StatelessWidget {
  final RendezvousListViewModel viewModel;
  final Function(int) onPageOffsetChanged;
  final Function() onNextRendezvousButtonTap;

  const _Body({
    required this.viewModel,
    required this.onPageOffsetChanged,
    required this.onNextRendezvousButtonTap,
  });

  @override
  Widget build(BuildContext context) {
    switch (viewModel.displayState) {
      case DisplayState.chargement:
        return RendezVousListLoader();
      case DisplayState.contenu:
        return _Content(
          viewModel: viewModel,
          onPageOffsetChanged: onPageOffsetChanged,
          onNextRendezvousButtonTap: onNextRendezvousButtonTap,
        );
      case DisplayState.erreur:
      default:
        return Retry(Strings.rendezVousListError, () => viewModel.onRetry());
    }
  }
}

class _Content extends StatelessWidget {
  final RendezvousListViewModel viewModel;
  final Function(int) onPageOffsetChanged;
  final Function() onNextRendezvousButtonTap;

  const _Content({
    required this.viewModel,
    required this.onPageOffsetChanged,
    required this.onNextRendezvousButtonTap,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.max,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _DateHeader(viewModel: viewModel, onPageOffsetChanged: onPageOffsetChanged),
        if (viewModel.rendezvousItems.isEmpty)
          Expanded(
            child: RefreshIndicatorAddingScrollview(
              onRefresh: () async => viewModel.onRetry(),
              child: _EmptyWeek(
                title: viewModel.emptyLabel,
                subtitle: viewModel.emptySubtitleLabel,
                withNextRendezvousButton: viewModel.nextRendezvousPageOffset != null,
                onNextRendezvousButtonTap: onNextRendezvousButtonTap,
              ),
            ),
          ),
        if (viewModel.rendezvousItems.isNotEmpty)
          Expanded(
            child: RefreshIndicator.adaptive(
              onRefresh: () async => viewModel.onRetry(),
              child: ListView.separated(
                itemCount: viewModel.rendezvousItems.length,
                padding: const EdgeInsets.all(Margins.spacing_base),
                separatorBuilder: (context, index) => SizedBox(height: Margins.spacing_base),
                itemBuilder: (context, index) {
                  final item = viewModel.rendezvousItems[index];
                  if (item is RendezvousSection) return _RendezvousSection(section: item);
                  if (item is RendezvousNotUpToDateItem) return _NotUpToDate(viewModel: viewModel);
                  return Container();
                },
              ),
            ),
          ),
      ],
    );
  }
}

class _NotUpToDate extends StatelessWidget {
  final RendezvousListViewModel viewModel;

  const _NotUpToDate({required this.viewModel});

  @override
  Widget build(BuildContext context) {
    final hasOnlyNotUpToDateItem = viewModel.rendezvousItems.every((element) => element is RendezvousNotUpToDateItem);
    return Column(
      children: [
        NotUpToDateMessage(
          margin: EdgeInsets.only(bottom: Margins.spacing_s),
          message: Strings.rendezvousNotUpToDateMessage,
          onRefresh: viewModel.onRetry,
        ),
        if (hasOnlyNotUpToDateItem) ...[
          SizedBox(height: Margins.spacing_base),
          Text(viewModel.emptyLabel, style: TextStyles.textBaseBold, textAlign: TextAlign.center)
        ],
      ],
    );
  }
}

class _RendezvousSection extends StatelessWidget {
  final RendezvousSection section;

  _RendezvousSection({required this.section});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        BigTitleSeparator(section.title),
        SizedBox(height: Margins.spacing_base),
        ...section.displayedRendezvous.cards(context),
        if (section.expandableRendezvous.isNotEmpty)
          Theme(
            data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
            child: ExpansionTile(
              title: Center(child: Text(Strings.seeMoreRendezvous)),
              children: section.expandableRendezvous.cards(context),
            ),
          ),
      ],
    );
  }
}

extension _RendezvousIdCards on List<RendezvousListId> {
  List<Widget> cards(BuildContext context) {
    return map(
      (element) => Padding(
        padding: const EdgeInsets.symmetric(vertical: Margins.spacing_s),
        child: element.id.rendezvousCard(
          context: context,
          stateSource: element.source(),
          trackedEvent: EventType.RDV_DETAIL,
        ),
      ),
    ).toList();
  }
}

extension _RendezvousIdCard on RendezvousListId {
  RendezvousStateSource source() {
    return switch (this) {
      RendezvousId _ => RendezvousStateSource.rendezvousList,
      SessionMiloId _ => RendezvousStateSource.rendezvousListSession,
    };
  }
}

class _EmptyWeek extends StatelessWidget {
  final String title;
  final String? subtitle;
  final bool withNextRendezvousButton;
  final Function() onNextRendezvousButtonTap;

  _EmptyWeek({
    required this.title,
    required this.subtitle,
    required this.withNextRendezvousButton,
    required this.onNextRendezvousButtonTap,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.max,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        ConstrainedBox(
          constraints: BoxConstraints(maxHeight: 130, maxWidth: 130),
          child: Illustration.grey(Icons.calendar_today_rounded, withWhiteBackground: true),
        ),
        Padding(
          padding: const EdgeInsets.only(top: 20, left: 24, right: 24, bottom: 20),
          child: Column(
            children: [
              Text(title, style: TextStyles.textBaseBold, textAlign: TextAlign.center),
              if (subtitle != null) ...[
                SepLine(Margins.spacing_s, Margins.spacing_s),
                Text(subtitle ?? "", style: TextStyles.textBaseRegular, textAlign: TextAlign.center),
              ],
              if (withNextRendezvousButton)
                Padding(
                  padding: const EdgeInsets.only(top: Margins.spacing_base),
                  child: PrimaryActionButton(onPressed: onNextRendezvousButtonTap, label: Strings.goToNextRendezvous),
                ),
            ],
          ),
        ),
      ],
    );
  }
}

class _DateHeader extends StatelessWidget {
  final RendezvousListViewModel viewModel;
  final Function(int) onPageOffsetChanged;

  const _DateHeader({required this.viewModel, required this.onPageOffsetChanged});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 24),
      child: Row(
        mainAxisSize: MainAxisSize.max,
        children: [
          if (viewModel.withPreviousPageButton)
            SecondaryIconButton(
              icon: AppIcons.chevron_left_rounded,
              iconColor: AppColors.primary,
              borderColor: Colors.transparent,
              onTap: () {
                onPageOffsetChanged(-1);
              },
            ),
          if (!viewModel.withPreviousPageButton) SizedBox(width: 59),
          Expanded(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  viewModel.title,
                  style: viewModel.pageOffset == 0
                      ? TextStyles.textMBold.copyWith(color: AppColors.primary)
                      : TextStyles.textMBold,
                ),
                SizedBox(height: 4),
                Text(
                  viewModel.dateLabel,
                  style: TextStyles.textBaseRegular,
                ),
              ],
            ),
          ),
          if (viewModel.withNextPageButton)
            SecondaryIconButton(
              icon: AppIcons.chevron_right_rounded,
              iconColor: AppColors.primary,
              borderColor: Colors.transparent,
              onTap: () {
                onPageOffsetChanged(1);
              },
            ),
          if (!viewModel.withNextPageButton) SizedBox(width: 59),
        ],
      ),
    );
  }
}
