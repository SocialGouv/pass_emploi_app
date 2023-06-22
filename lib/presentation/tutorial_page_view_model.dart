import 'package:equatable/equatable.dart';
import 'package:pass_emploi_app/features/tutorial/tutorial_actions.dart';
import 'package:pass_emploi_app/features/tutorial/tutorial_state.dart';
import 'package:pass_emploi_app/models/tutorial/tutorial_page.dart';
import 'package:pass_emploi_app/redux/app_state.dart';
import 'package:redux/redux.dart';

class TutorialPageViewModel extends Equatable {
  final List<TutorialPage> pages;
  final Function() onDone;
  final Function() onDelay;

  TutorialPageViewModel._({
    required this.pages,
    required this.onDone,
    required this.onDelay,
  });

  factory TutorialPageViewModel.create(Store<AppState> store) {
    final tutorialState = store.state.tutorialState as ShowTutorialState;
    return TutorialPageViewModel._(
      pages: tutorialState.pages,
      onDone: () => store.dispatch(TutorialDoneAction()),
      onDelay: () => store.dispatch(TutorialDelayedAction()));
  }

  @override
  List<Object?> get props => [pages];
}
