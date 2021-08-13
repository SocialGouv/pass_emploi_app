import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:flutter_svg/svg.dart';
import 'package:pass_emploi_app/presentation/chat_item.dart';
import 'package:pass_emploi_app/presentation/chat_view_model.dart';
import 'package:pass_emploi_app/redux/states/app_state.dart';
import 'package:pass_emploi_app/ui/app_colors.dart';
import 'package:pass_emploi_app/ui/text_styles.dart';
import 'package:pass_emploi_app/widgets/chat_message_widget.dart';

class ChatPage extends StatefulWidget {
  @override
  _ChatPageState createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  late TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, ChatViewModel>(
      converter: (store) => ChatViewModel.create(store),
      builder: (context, viewModel) => _body(context, viewModel),
    );
  }

  _body(BuildContext context, ChatViewModel viewModel) {
    if (viewModel.withLoading) return Scaffold(); // TODO
    if (viewModel.withContent) return _chat(context, viewModel);
    return Scaffold(); // TODO
  }

  _chat(BuildContext context, ChatViewModel viewModel) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: AppColors.nightBlue),
        toolbarHeight: 93,
        backgroundColor: Colors.white,
        elevation: 2,
        title: Text(viewModel.title, style: TextStyles.h3Semi),
      ),
      body: Stack(
        children: [
          Container(
            color: Colors.white,
            child: ListView(
              reverse: true,
              padding: const EdgeInsets.only(left: 16.0, right: 16.0, top: 16.0, bottom: 100.0),
              children: viewModel.items.reversed.map((item) {
                if (item is DayItem) {
                  return Center(
                    child: Text(
                      item.dayLabel,
                      style: TextStyles.textSmRegular(color: AppColors.bluePurple),
                    ),
                  );
                } else if (item is MessageItem) {
                  return ChatMessageWidget(item);
                } else {
                  return Container();
                }
              }).toList(),
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              color: Colors.white,
              padding: const EdgeInsets.all(24),
              child: Row(
                children: [
                  Flexible(
                    child: TextField(
                      controller: _controller,
                      keyboardType: TextInputType.multiline,
                      maxLines: null,
                      decoration: InputDecoration(
                        contentPadding: const EdgeInsets.only(left: 16, right: 16, top: 13, bottom: 13),
                        filled: true,
                        fillColor: AppColors.lightBlue,
                        hintText: 'Votre message…',
                        hintStyle: TextStyles.textSmRegular(color: AppColors.bluePurple),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(34.0),
                          borderSide: BorderSide(width: 1, color: AppColors.lightBlue),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(34.0),
                          borderSide: BorderSide(color: AppColors.bluePurple, width: 1),
                        ),
                      ),
                      style: TextStyles.textSmRegular(color: AppColors.nightBlue),
                    ),
                    flex: 1,
                  ),
                  SizedBox(width: 10),
                  FloatingActionButton(
                    backgroundColor: AppColors.nightBlue,
                    child: SvgPicture.asset("assets/ic_paper_plane.svg"),
                    onPressed: () {
                      if (_controller.value.text.isNotEmpty) {
                        viewModel.onSendMessage(_controller.value.text);
                        _controller.clear();
                      }
                    },
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
