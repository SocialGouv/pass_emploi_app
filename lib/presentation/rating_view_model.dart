import 'package:equatable/equatable.dart';
import 'package:pass_emploi_app/features/rating/rating_actions.dart';
import 'package:pass_emploi_app/models/brand.dart';
import 'package:pass_emploi_app/presentation/email_subject_view_model.dart';
import 'package:pass_emploi_app/redux/app_state.dart';
import 'package:pass_emploi_app/utils/platform.dart';
import 'package:redux/redux.dart';

class RatingViewModel extends Equatable {
  final bool shouldSendEmailOnNegativeRating;
  final String ratingEmailObject;
  final Function() onDone;

  RatingViewModel._({
    required this.shouldSendEmailOnNegativeRating,
    required this.ratingEmailObject,
    required this.onDone,
  });

  factory RatingViewModel.create(Store<AppState> store, Platform platform) {
    final isPassEmploi = store.state.configurationState.getBrand().isPassEmploi;
    return RatingViewModel._(
      shouldSendEmailOnNegativeRating: !(isPassEmploi && platform.isIos),
      ratingEmailObject: EmailObjectViewModel.create(store).ratingEmailObject,
      onDone: () => store.dispatch(RatingDoneAction()),
    );
  }

  @override
  List<Object?> get props => [shouldSendEmailOnNegativeRating, ratingEmailObject];
}
