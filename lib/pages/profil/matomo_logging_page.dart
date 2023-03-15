import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:pass_emploi_app/redux/app_state.dart';
import 'package:pass_emploi_app/ui/app_colors.dart';
import 'package:pass_emploi_app/ui/dimens.dart';
import 'package:pass_emploi_app/ui/margins.dart';
import 'package:pass_emploi_app/ui/strings.dart';
import 'package:pass_emploi_app/ui/text_styles.dart';
import 'package:pass_emploi_app/utils/pass_emploi_matomo_tracker.dart';
import 'package:pass_emploi_app/widgets/default_app_bar.dart';
import 'package:pass_emploi_app/widgets/sepline.dart';

class MatomoLoggingPage extends StatelessWidget {
  static MaterialPageRoute<void> materialPageRoute() => MaterialPageRoute(builder: (context) => MatomoLoggingPage());

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, List<String>>(
      builder: _buildBody,
      converter: (store) => store.state.matomoLoggingState.logs,
      distinct: true,
    );
  }

  Widget _buildBody(BuildContext context, List<String> logs) {
    return Scaffold(
      appBar: SecondaryAppBar(title: Strings.developerOptionMatomoPage),
      body: ListView.separated(
        padding: EdgeInsets.all(Margins.spacing_base),
        separatorBuilder: (_, index) => SepLine(Margins.spacing_s, Margins.spacing_s),
        itemCount: logs.length,
        itemBuilder: (context, index) => _LogItem(log: logs[index]),
      ),
    );
  }
}

class _LogItem extends StatelessWidget {
  final String log;

  const _LogItem({required this.log});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _LogTag(
          log: log,
        ),
        Text(_getMessage(), style: TextStyles.textBaseRegular)
      ],
    );
  }

  String _getMessage() {
    return log
        .replaceAll(PassEmploiMatomoTracker.eventLogPrefix, '')
        .replaceAll(PassEmploiMatomoTracker.pageLogPrefix, '')
        .replaceAll(PassEmploiMatomoTracker.outLinkLogPrefix, '')
        .trim();
  }
}

class _LogTag extends StatelessWidget {
  final String log;

  const _LogTag({required this.log});

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: _color(),
        borderRadius: BorderRadius.all(Radius.circular(Dimens.radius_base)),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 6),
        child: Text(_tag(), style: TextStyles.textBaseRegularWithColor(Colors.white).copyWith(fontSize: 12)),
      ),
    );
  }

  String _tag() {
    if (log.contains(PassEmploiMatomoTracker.eventLogPrefix)) return 'événement';
    if (log.contains(PassEmploiMatomoTracker.outLinkLogPrefix)) return 'lien sortant';
    return 'page';
  }

  Color _color() {
    if (log.contains(PassEmploiMatomoTracker.eventLogPrefix)) return AppColors.additional1;
    if (log.contains(PassEmploiMatomoTracker.outLinkLogPrefix)) return AppColors.additional3;
    return AppColors.additional5;
  }
}
