import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:flutter_svg/svg.dart';
import 'package:pass_emploi_app/pages/chat_page.dart';
import 'package:pass_emploi_app/presentation/chat_state_view_model.dart';
import 'package:pass_emploi_app/redux/states/app_state.dart';
import 'package:pass_emploi_app/ui/app_colors.dart';
import 'package:pass_emploi_app/ui/text_styles.dart';

class ChatFloatingActionButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, ChatStatusViewModel>(
      converter: (store) => ChatStatusViewModel.create(store),
      builder: (context, viewModel) {
        return Stack(
          alignment: Alignment.topRight,
          children: [
            FloatingActionButton(
              backgroundColor: AppColors.bluePurple,
              child: SvgPicture.asset("assets/ic_envelope.svg"),
              onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (context) => ChatPage())),
            ),
            if (viewModel.withUnreadMessages)
              Container(
                width: 24,
                height: 24,
                decoration: BoxDecoration(
                  color: AppColors.purple,
                  border: Border.all(width: 1, color: Colors.white),
                  borderRadius: BorderRadius.all(Radius.circular(16)),
                ),
                child: Center(
                  child: Text(viewModel.unreadMessageCount, style: TextStyles.textSmMedium(color: Colors.white)),
                ),
              ),
          ],
        );
      },
    );
  }
}
