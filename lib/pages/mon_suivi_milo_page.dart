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
import 'package:pass_emploi_app/widgets/connectivity_widgets.dart';
import 'package:pass_emploi_app/widgets/default_app_bar.dart';
import 'package:pass_emploi_app/widgets/retry.dart';

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
        DisplayState.CONTENT => _Content(viewModel),
        _ => CircularProgressIndicator(),
      },
    );
  }
}

class _Content extends StatelessWidget {
  final MonSuiviViewModel viewModel;

  const _Content(this.viewModel);

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: const EdgeInsets.only(top: Margins.spacing_base, bottom: Margins.spacing_x_huge),
      itemCount: viewModel.items.length,
      itemBuilder: (context, index) {
        final item = viewModel.items[index];
        return switch (item) {
          SemaineSectionMonSuiviItem() => _SemaineSectionItem(item.interval, item.boldTitle),
          EmptyDayMonSuiviItem() => _EmptyDayItem(item.day),
          DayMonSuiviItem() => _DayItem(item.day, item.entries),
        };
      },
    );
  }
}

class _SemaineSectionItem extends StatelessWidget {
  final String interval;
  final String? boldTitle;

  const _SemaineSectionItem(this.interval, this.boldTitle);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (boldTitle != null) Text(boldTitle!, style: TextStyles.textMBold),
        Text(interval, style: TextStyles.textBaseRegular),
      ],
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
      children: [
        _Day(day),
        const SizedBox(width: Margins.spacing_base),
        Expanded(child: Text(Strings.monSuiviEmptyDay, style: TextStyles.textBaseRegular)),
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
        Text(day.shortened, style: TextStyles.textBaseRegular),
        Text(day.number, style: TextStyles.textMBold),
      ],
    );
  }
}
