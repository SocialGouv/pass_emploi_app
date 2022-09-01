import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:flutter_svg/svg.dart';
import 'package:pass_emploi_app/analytics/tracker.dart';
import 'package:pass_emploi_app/features/rendezvous/rendezvous_actions.dart';
import 'package:pass_emploi_app/network/post_tracking_event_request.dart';
import 'package:pass_emploi_app/pages/rendezvous/rendezvous_details_page.dart';
import 'package:pass_emploi_app/presentation/display_state.dart';
import 'package:pass_emploi_app/presentation/rendezvous/list/rendezvous_list_view_model.dart';
import 'package:pass_emploi_app/presentation/rendezvous/rendezvous_card_view_model.dart';
import 'package:pass_emploi_app/redux/app_state.dart';
import 'package:pass_emploi_app/ui/app_colors.dart';
import 'package:pass_emploi_app/ui/drawables.dart';
import 'package:pass_emploi_app/ui/margins.dart';
import 'package:pass_emploi_app/ui/strings.dart';
import 'package:pass_emploi_app/ui/text_styles.dart';
import 'package:pass_emploi_app/utils/context_extensions.dart';
import 'package:pass_emploi_app/widgets/buttons/primary_action_button.dart';
import 'package:pass_emploi_app/widgets/buttons/secondary_icon_button.dart';
import 'package:pass_emploi_app/widgets/cards/rendezvous_card.dart';
import 'package:pass_emploi_app/widgets/default_animated_switcher.dart';
import 'package:pass_emploi_app/widgets/retry.dart';
import 'package:pass_emploi_app/widgets/sepline.dart';

class RendezvousListPage extends StatefulWidget {
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
      onDidChange: (_, viewModel) => _openDeeplinkIfNeeded(viewModel, context),
      distinct: true,
      key: ValueKey(_pageOffset),
    );
  }

  @override
  void deactivate() {
    StoreProvider.of<AppState>(context).dispatch(RendezvousResetAction());
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
          onTap: (rdvId) {
            context.trackEvent(EventType.RDV_DETAIL);
            return Navigator.push(
              context,
              RendezvousDetailsPage.materialPageRoute(rdvId),
            );
          },
        ),
      ),
    );
  }

  void _openDeeplinkIfNeeded(RendezvousListViewModel viewModel, BuildContext context) {
    if (viewModel.deeplinkRendezvousId != null) {
      Navigator.push(
        context,
        RendezvousDetailsPage.materialPageRoute(viewModel.deeplinkRendezvousId!),
      );
      viewModel.onDeeplinkUsed();
    }
  }
}

class _Scaffold extends StatelessWidget {
  const _Scaffold({Key? key, required this.body}) : super(key: key);

  final Widget body;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.grey100,
      body: Center(child: DefaultAnimatedSwitcher(child: body)),
    );
  }
}

class _Body extends StatelessWidget {
  const _Body({
    Key? key,
    required this.viewModel,
    required this.onPageOffsetChanged,
    required this.onNextRendezvousButtonTap,
    required this.onTap,
  }) : super(key: key);

  final RendezvousListViewModel viewModel;
  final Function(String) onTap;
  final Function(int) onPageOffsetChanged;
  final Function() onNextRendezvousButtonTap;

  @override
  Widget build(BuildContext context) {
    switch (viewModel.displayState) {
      case DisplayState.LOADING:
        return CircularProgressIndicator();
      case DisplayState.CONTENT:
        return _Content(
          viewModel: viewModel,
          onTap: (rdvId) => onTap(rdvId),
          onPageOffsetChanged: onPageOffsetChanged,
          onNextRendezvousButtonTap: onNextRendezvousButtonTap,
        );
      case DisplayState.FAILURE:
      default:
        return Retry(Strings.rendezVousError, () => viewModel.onRetry());
    }
  }
}

class _Content extends StatelessWidget {
  const _Content({
    Key? key,
    required this.viewModel,
    required this.onTap,
    required this.onPageOffsetChanged,
    required this.onNextRendezvousButtonTap,
  }) : super(key: key);

  final RendezvousListViewModel viewModel;
  final Function(String) onTap;
  final Function(int) onPageOffsetChanged;
  final Function() onNextRendezvousButtonTap;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.max,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _DateHeader(viewModel: viewModel, onPageOffsetChanged: onPageOffsetChanged),
        if (viewModel.rendezvous.isEmpty)
          _EmptyWeek(
            title: viewModel.emptyLabel,
            subtitle: viewModel.emptySubtitleLabel,
            withNextRendezvousButton: viewModel.nextRendezvousPageOffset != null,
            onNextRendezvousButtonTap: onNextRendezvousButtonTap,
          ),
        if (viewModel.rendezvous.isNotEmpty)
          Expanded(
            child: ListView.separated(
              itemCount: viewModel.rendezvous.length,
              padding: const EdgeInsets.all(Margins.spacing_s),
              separatorBuilder: (context, index) => SizedBox(height: Margins.spacing_base),
              itemBuilder: (context, index) {
                final section = viewModel.rendezvous[index];
                return _RendezvousSection(section: section, onTap: onTap);
              },
            ),
          ),
      ],
    );
  }
}

class _RendezvousSection extends StatelessWidget {
  final RendezvousSection section;
  final Function(String) onTap;

  _RendezvousSection({required this.section, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _DayDivider(section.title),
        ...section.displayedRendezvous.cards(onTap: onTap),
        if (section.expandableRendezvous.isNotEmpty)
          Theme(
            data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
            child: ExpansionTile(
              title: Center(child: Text(Strings.seeMoreRendezvous)),
              children: section.expandableRendezvous.cards(onTap: onTap),
            ),
          ),
      ],
    );
  }
}

extension _RendezvousIdCards on List<String> {
  List<Widget> cards({required Function(String) onTap}) {
    return map(
      (id) => Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: Margins.spacing_s),
        child: RendezvousCard(
          converter: (store) => RendezvousCardViewModel.createFromRendezvousState(store, id),
          onTap: () => onTap(id),
        ),
      ),
    ).toList();
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
    return Expanded(
      child: Column(
        mainAxisSize: MainAxisSize.max,
        children: [
          Flexible(child: SvgPicture.asset(Drawables.icEmptyOffres)),
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
      ),
    );
  }
}

class _DayDivider extends StatelessWidget {
  final String label;

  _DayDivider(this.label);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.max,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          width: 48,
          height: 2,
          color: AppColors.contentColor,
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Text(
            label,
            style: TextStyles.textMBold,
          ),
        ),
        Container(
          width: 48,
          height: 2,
          color: AppColors.contentColor,
        ),
      ],
    );
  }
}

class _DateHeader extends StatelessWidget {
  final RendezvousListViewModel viewModel;
  final Function(int) onPageOffsetChanged;

  const _DateHeader({Key? key, required this.viewModel, required this.onPageOffsetChanged}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 24),
      child: Row(
        mainAxisSize: MainAxisSize.max,
        children: [
          if (viewModel.withPreviousPageButton)
            SecondaryIconButton(
              drawableRes: Drawables.icChevronLeft,
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
              drawableRes: Drawables.icChevronRight,
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
