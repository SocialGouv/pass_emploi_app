import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:pass_emploi_app/features/mon_suivi/mon_suivi_actions.dart';
import 'package:pass_emploi_app/presentation/display_state.dart';
import 'package:pass_emploi_app/presentation/mon_suivi/mon_suivi_view_model.dart';
import 'package:pass_emploi_app/redux/app_state.dart';
import 'package:pass_emploi_app/ui/animation_durations.dart';
import 'package:pass_emploi_app/ui/app_colors.dart';
import 'package:pass_emploi_app/ui/margins.dart';
import 'package:pass_emploi_app/ui/strings.dart';
import 'package:pass_emploi_app/ui/text_styles.dart';
import 'package:pass_emploi_app/widgets/buttons/secondary_button.dart';
import 'package:pass_emploi_app/widgets/connectivity_widgets.dart';
import 'package:pass_emploi_app/widgets/dashed_box.dart';
import 'package:pass_emploi_app/widgets/default_app_bar.dart';
import 'package:pass_emploi_app/widgets/retry.dart';

final centerKey = GlobalKey();

class MonSuiviMiloPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, MonSuiviViewModel>(
      onInit: (store) => store.dispatch(MonSuiviRequestAction(MonSuiviPeriod.current)),
      converter: (store) => MonSuiviViewModel.create(store),
      builder: (context, viewModel) => _Scaffold(_Body(viewModel)),
      onDispose: (store) => store.dispatch(MonSuiviResetAction()),
    );
  }
}

class _Scaffold extends StatelessWidget {
  final Widget body;

  const _Scaffold(this.body);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.grey100,
      appBar: PrimaryAppBar(title: Strings.monSuiviAppBarTitle),
      body: ConnectivityContainer(child: body),
    );
  }
}

class _Body extends StatelessWidget {
  final MonSuiviViewModel viewModel;

  const _Body(this.viewModel);

  @override
  Widget build(BuildContext context) {
    return AnimatedSwitcher(
      duration: AnimationDurations.fast,
      child: switch (viewModel.displayState) {
        DisplayState.FAILURE => Center(child: Retry(Strings.monSuiviError, () => viewModel.onRetry())),
        DisplayState.CONTENT => _TodayAnchoredMonSuiviList(viewModel),
        _ => Center(child: CircularProgressIndicator()),
      },
    );
  }
}

class _TodayAnchoredMonSuiviList extends StatelessWidget {
  final MonSuiviViewModel viewModel;
  final List<MonSuiviItem> pastItems;
  final List<MonSuiviItem> presentAndFutureItems;

  _TodayAnchoredMonSuiviList(this.viewModel)
      : pastItems = viewModel.items.sublist(0, viewModel.indexOfTodayItem).reversed.toList(),
        presentAndFutureItems = viewModel.items.sublist(viewModel.indexOfTodayItem);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: Margins.spacing_base),
      child: CustomScrollView(
        center: centerKey,
        slivers: [
          SliverList.separated(
            separatorBuilder: (context, index) => const SizedBox(height: Margins.spacing_base),
            itemCount: pastItems.length + 1,
            itemBuilder: (context, index) {
              if (index == pastItems.length) {
                return _LoadMoreButton(
                  label: 'Afficher les semaines précédentes',
                  onPressed: () => viewModel.onLoadPreviousPeriod(),
                );
              }
              return pastItems[index].toWidget();
            },
          ),
          SliverList.separated(
            key: centerKey,
            separatorBuilder: (context, index) => const SizedBox(height: Margins.spacing_base),
            itemCount: presentAndFutureItems.length + 1,
            itemBuilder: (context, index) {
              if (index == presentAndFutureItems.length) {
                return _LoadMoreButton(
                  label: 'Afficher les semaines suivantes',
                  onPressed: () => viewModel.onLoadNextPeriod(),
                );
              }
              return presentAndFutureItems[index].toWidget();
            },
          ),
        ],
      ),
    );
  }
}

class _SemaineSectionItem extends StatelessWidget {
  final String interval;
  final String? boldTitle;

  const _SemaineSectionItem(this.interval, this.boldTitle);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: Margins.spacing_s),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (boldTitle != null) ...[
            Text(boldTitle!, style: TextStyles.textMBold),
            const SizedBox(height: Margins.spacing_xs),
          ],
          Text(interval, style: TextStyles.textXsRegular(color: AppColors.grey800)),
        ],
      ),
    );
  }
}

class _DayItem extends StatelessWidget {
  final MonSuiviDay day;
  final List<MonSuiviEntry> entries;

  const _DayItem(this.day, this.entries);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        _Day(day),
        const SizedBox(width: Margins.spacing_base),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: entries.map((entry) => Text(entry.toString())).toList(),
          ),
        ),
      ],
    );
  }
}

class _EmptyDayItem extends StatelessWidget {
  final MonSuiviDay day;

  const _EmptyDayItem(this.day);

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(child: _Day(day)),
        const SizedBox(width: Margins.spacing_base),
        Expanded(
          flex: 9,
          child: DashedBox(
            padding: const EdgeInsets.all(Margins.spacing_base),
            color: AppColors.disabled,
            child: Text(Strings.monSuiviEmptyDay, style: TextStyles.textXsMedium(color: AppColors.disabled)),
          ),
        ),
      ],
    );
  }
}

class _Day extends StatelessWidget {
  final MonSuiviDay day;

  const _Day(this.day);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(day.shortened, style: TextStyles.textXsMedium()),
        Text(day.number, style: TextStyles.textBaseBold),
      ],
    );
  }
}

class _LoadMoreButton extends StatefulWidget {
  final String label;
  final VoidCallback onPressed;

  const _LoadMoreButton({required this.label, required this.onPressed});

  @override
  State<_LoadMoreButton> createState() => _LoadMoreButtonState();
}

class _LoadMoreButtonState extends State<_LoadMoreButton> {
  CrossFadeState crossFadeState = CrossFadeState.showFirst;

  @override
  Widget build(BuildContext context) {
    return AnimatedCrossFade(
      key: widget.key,
      crossFadeState: crossFadeState,
      sizeCurve: Curves.ease,
      duration: Duration(milliseconds: 200),
      firstChild: SizedBox(
        width: double.infinity,
        child: SecondaryButton(
          label: widget.label,
          onPressed: () {
            widget.onPressed();
            setState(() => crossFadeState = CrossFadeState.showSecond);
          },
        ),
      ),
      secondChild: Center(
        child: Padding(
          padding: const EdgeInsets.all(Margins.spacing_base),
          child: CircularProgressIndicator(),
        ),
      ),
    );
  }
}

extension on MonSuiviItem {
  Widget toWidget() {
    return switch (this) {
      final SemaineSectionMonSuiviItem item => _SemaineSectionItem(item.interval, item.boldTitle),
      final EmptyDayMonSuiviItem item => _EmptyDayItem(item.day),
      final FilledDayMonSuiviItem item => _DayItem(item.day, item.entries),
    };
  }
}
