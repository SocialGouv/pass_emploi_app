import 'package:pass_emploi_app/models/user_action.dart';
import 'package:pass_emploi_app/widgets/cards/base_cards/widgets/card_pillule.dart';

extension UserActionPilluleExtension on UserAction {
  CardPilluleType pillule() {
    if (status == UserActionStatus.DONE) return CardPilluleType.done;
    if (status.todo() && isLate()) return CardPilluleType.late;
    return CardPilluleType.todo;
  }
}
