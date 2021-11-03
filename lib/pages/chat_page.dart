import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:flutter_svg/svg.dart';
import 'package:pass_emploi_app/analytics/analytics_constants.dart';
import 'package:pass_emploi_app/presentation/chat_item.dart';
import 'package:pass_emploi_app/presentation/chat_page_view_model.dart';
import 'package:pass_emploi_app/redux/actions/ui_actions.dart';
import 'package:pass_emploi_app/redux/states/app_state.dart';
import 'package:pass_emploi_app/ui/app_colors.dart';
import 'package:pass_emploi_app/ui/strings.dart';
import 'package:pass_emploi_app/ui/text_styles.dart';
import 'package:pass_emploi_app/widgets/chat_message_widget.dart';
import 'package:pass_emploi_app/widgets/default_app_bar.dart';
import 'package:redux/redux.dart';

class ChatPage extends StatefulWidget {
  //ChatPage._(); //TODO-16

  static MaterialPageRoute materialPageRoute() {
    return MaterialPageRoute(builder: (context) => ChatPage(), settings: AnalyticsRouteSettings.chat()); //TODO-16
  }

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
    return StoreConnector<AppState, ChatPageViewModel>(
      converter: (store) => ChatPageViewModel.create(store),
      builder: (context, viewModel) => _body(context, viewModel),
      distinct: true,
      onInit: (store) => sendLastMessageSeenAction(store),
      onDidChange: (previousVm, newVm) => sendLastMessageSeenAction(StoreProvider.of<AppState>(context)),
    );
  }

  sendLastMessageSeenAction(Store<AppState> store) => store.dispatch(LastMessageSeenAction());

  _body(BuildContext context, ChatPageViewModel viewModel) {
    if (viewModel.withContent) return _chat(context, viewModel);
    return Scaffold(); // TODO How could we refresh subscription?
  }

  _chat(BuildContext context, ChatPageViewModel viewModel) {
    return Scaffold(
      appBar: DefaultAppBar(title: Text(viewModel.title, style: TextStyles.h3Semi)),
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
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  Flexible(
                    child: TextField(
                      controller: _controller,
                      keyboardType: TextInputType.multiline,
                      textCapitalization: TextCapitalization.sentences,
                      maxLines: null,
                      decoration: InputDecoration(
                        contentPadding: const EdgeInsets.only(left: 16, right: 16, top: 13, bottom: 13),
                        filled: true,
                        fillColor: AppColors.lightBlue,
                        hintText: Strings.yourMessage,
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
