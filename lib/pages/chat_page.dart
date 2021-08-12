import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:pass_emploi_app/presentation/chat_item.dart';
import 'package:pass_emploi_app/presentation/chat_view_model.dart';
import 'package:pass_emploi_app/redux/states/app_state.dart';
import 'package:pass_emploi_app/ui/app_colors.dart';
import 'package:pass_emploi_app/ui/text_styles.dart';
import 'package:pass_emploi_app/widgets/chat_message_widget.dart';

class ChatPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, ChatViewModel>(
      converter: (store) => ChatViewModel.create(store),
      builder: (context, viewModel) => _body(context, viewModel),
    );
  }

  _body(BuildContext context, ChatViewModel viewModel) {
    if (viewModel.withLoading) return Scaffold();
    if (viewModel.withContent) return _chat(context, viewModel);
    return Scaffold();
  }

  _chat(BuildContext context, ChatViewModel viewModel) {
    return Scaffold(
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: viewModel.items.map((item) {
          if (item is DayItem) {
            return Center(
              child: Text(item.dayLabel, style: TextStyles.textSmRegular(color: AppColors.purpleBlue)),
            );
          } else if (item is MessageItem) {
            return ChatMessageWidget(item);
          } else {
            return Container();
          }
        }).toList(),
      ),
    );
  }
}
