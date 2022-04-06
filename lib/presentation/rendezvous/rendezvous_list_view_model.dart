import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:pass_emploi_app/auth/auth_id_token.dart';
import 'package:pass_emploi_app/features/deep_link/deep_link_actions.dart';
import 'package:pass_emploi_app/features/deep_link/deep_link_state.dart';
import 'package:pass_emploi_app/features/login/login_state.dart';
import 'package:pass_emploi_app/features/rendezvous/rendezvous_actions.dart';
import 'package:pass_emploi_app/features/rendezvous/rendezvous_state.dart';
import 'package:pass_emploi_app/presentation/display_state.dart';
import 'package:pass_emploi_app/redux/app_state.dart';
import 'package:pass_emploi_app/ui/strings.dart';
import 'package:pass_emploi_app/utils/date_extensions.dart';
import 'package:redux/redux.dart';

class RendezvousListViewModel extends Equatable {
  final DisplayState displayState;
  final List<String> rendezvousIds;
  final String? deeplinkRendezvousId;
  final Function() onRetry;
  final Function() onDeeplinkUsed;
  final bool withPreviousButton;
  final bool withNextButton;
  final String title;
  final String dateLabel;

  RendezvousListViewModel({
    required this.displayState,
    required this.rendezvousIds,
    required this.deeplinkRendezvousId,
    required this.onRetry,
    required this.onDeeplinkUsed,
    this.withPreviousButton = false,
    this.withNextButton = false,
    required this.title,
    required this.dateLabel,
  });

  factory RendezvousListViewModel.create(Store<AppState> store, DateTime now, int offset) {
    final loginState = store.state.loginState;
    final rendezvousState = store.state.rendezvousState;
    final rendezvousIds = _rendezvousIds(rendezvousState, loginState, now, offset);
    return RendezvousListViewModel(
      displayState: _displayState(rendezvousState),
      rendezvousIds: rendezvousIds,
      deeplinkRendezvousId: _deeplinkRendezvousId(store.state.deepLinkState, rendezvousIds),
      onRetry: () => store.dispatch(RendezvousRequestAction()),
      onDeeplinkUsed: () => store.dispatch(ResetDeeplinkAction()),
      title: _buildTitle(offset),
      dateLabel: _buildDateLabel(now, offset),
      withNextButton: _withNextButton(rendezvousState, now, offset),
      withPreviousButton: offset >= 0,
    );
  }

  @override
  List<Object?> get props => [displayState, rendezvousIds, deeplinkRendezvousId];
}

DisplayState _displayState(RendezvousState state) {
  if (state is RendezvousNotInitializedState) return DisplayState.LOADING;
  if (state is RendezvousLoadingState) return DisplayState.LOADING;
  if (state is RendezvousSuccessState && state.rendezvous.isNotEmpty) return DisplayState.CONTENT;
  if (state is RendezvousSuccessState && state.rendezvous.isEmpty) return DisplayState.EMPTY;
  return DisplayState.FAILURE;
}

String _buildDateLabel(DateTime now, int offset) {
  if (offset < 0) {
    return "du 01/01/2022 à hier";
  } else {
    final firstDay = now.add(Duration(days: 7 * offset)).toDay();
    final lastDay = now.add(Duration(days: (7 * offset) + 6)).toDay();
    return "du $firstDay au $lastDay";
  }
}

bool _withNextButton(RendezvousState rendezvousState, DateTime now, int offset) {
  if (offset < 0) return true;
  if (rendezvousState is! RendezvousSuccessState) return false;
  final lastDay = DateUtils.dateOnly(now.add(Duration(days: (7 * offset) + 7)));
  return rendezvousState.rendezvous.any((element) => element.date.isAfter(lastDay));
}

String _buildTitle(int offset) {
  if (offset < 0) return Strings.rendezVousPassesTitre;
  if (offset == 0) return Strings.rendezVousCetteSemaineTitre;
  return Strings.rendezVousFutursTitre;
}

List<String> _rendezvousIds(RendezvousState rendezvousState, LoginState loginState, DateTime now, int offset) {
  if (rendezvousState is! RendezvousSuccessState) return [];
  if (loginState is! LoginSuccessState) return [];
  final firstDay = DateUtils.dateOnly(now.add(Duration(days: 7 * offset)));
  final lastDay = DateUtils.dateOnly(now.add(Duration(days: (7 * offset) + 7)));

  final rendezvous = rendezvousState.rendezvous;

  if (loginState.user.loginMode == LoginMode.POLE_EMPLOI) {
    rendezvous.sort((a, b) => a.date.compareTo(b.date));
  } else {
    rendezvous.sort((a, b) => b.date.compareTo(a.date));
  }

  return rendezvous
      .where((element) => offset < 0 || element.date.isAfter(firstDay))
      .where((element) => element.date.isBefore(lastDay))
      .map((rdv) => rdv.id)
      .toList();
}

String? _deeplinkRendezvousId(DeepLinkState state, List<String> rdvIds) {
  return (state.deepLink == DeepLink.ROUTE_TO_RENDEZVOUS && rdvIds.contains(state.dataId)) ? state.dataId : null;
}
