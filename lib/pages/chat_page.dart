import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:flutter_svg/svg.dart';
import 'package:matomo/matomo.dart';
import 'package:pass_emploi_app/analytics/analytics_constants.dart';
import 'package:pass_emploi_app/features/chat/messages/chat_actions.dart';
import 'package:pass_emploi_app/network/post_tracking_event_request.dart';
import 'package:pass_emploi_app/pages/credentials_page.dart';
import 'package:pass_emploi_app/presentation/chat_item.dart';
import 'package:pass_emploi_app/presentation/chat_page_view_model.dart';
import 'package:pass_emploi_app/presentation/display_state.dart';
import 'package:pass_emploi_app/redux/app_state.dart';
import 'package:pass_emploi_app/ui/app_colors.dart';
import 'package:pass_emploi_app/ui/drawables.dart';
import 'package:pass_emploi_app/ui/margins.dart';
import 'package:pass_emploi_app/ui/strings.dart';
import 'package:pass_emploi_app/ui/text_styles.dart';
import 'package:pass_emploi_app/utils/context_extensions.dart';
import 'package:pass_emploi_app/widgets/chat/chat_attached_file_widget.dart';
import 'package:pass_emploi_app/widgets/chat/chat_information_widget.dart';
import 'package:pass_emploi_app/widgets/chat/chat_message_widget.dart';
import 'package:pass_emploi_app/widgets/default_animated_switcher.dart';
import 'package:pass_emploi_app/widgets/default_app_bar.dart';
import 'package:pass_emploi_app/widgets/retry.dart';
import 'package:pass_emploi_app/widgets/sepline.dart';
import 'package:pass_emploi_app/widgets/share_sheet.dart';

class ChatPage extends TraceableStatefulWidget {
  ChatPage() : super(name: AnalyticsScreenNames.chat);

  @override
  _ChatPageState createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> with WidgetsBindingObserver {
  late TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _controller = TextEditingController();
  }

  @override
  void dispose() {
    _controller.dispose();
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    if (state == AppLifecycleState.paused) {
      StoreProvider.of<AppState>(context).dispatch(UnsubscribeFromChatAction());
    }
    if (state == AppLifecycleState.resumed) {
      StoreProvider.of<AppState>(context).dispatch(SubscribeToChatAction());
    }
  }

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, ChatPageViewModel>(
      onInit: (store) {
        store.dispatch(LastMessageSeenAction());
        store.dispatch(SubscribeToChatAction());
      },
      onDispose: (store) => store.dispatch(UnsubscribeFromChatAction()),
      converter: (store) => ChatPageViewModel.create(store),
      builder: (context, viewModel) => _scaffold(viewModel, _body(context, viewModel)),
      onDidChange: (previousVm, newVm) => StoreProvider.of<AppState>(context).dispatch(LastMessageSeenAction()),
      distinct: true,
    );
  }

  Widget _scaffold(ChatPageViewModel viewModel, Widget body) {
    return Scaffold(
      appBar: passEmploiAppBar(label: Strings.yourConseiller, context: context),
      body: Column(
        children: [
          SepLine(0, 0),
          Expanded(child: DefaultAnimatedSwitcher(child: body)),
          ShareSheet(),
        ],
      ),
    );
  }

  Widget _body(BuildContext context, ChatPageViewModel viewModel) {
    switch (viewModel.displayState) {
      case DisplayState.CONTENT:
        return _content(context, viewModel);
      case DisplayState.LOADING:
        return _loader();
      default:
        return Center(child: Retry(Strings.chatError, () => viewModel.onRetry()));
    }
  }

  Widget _content(BuildContext context, ChatPageViewModel viewModel) {
    return Stack(
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
                    style: TextStyles.textSRegular(),
                  ),
                );
              } else if (item is MessageItem) {
                return ChatMessageWidget(item);
              } else if (item is InformationItem) {
                return ChatInformationWidget(item.title, item.description);
              } else if (item is AttachedFileConseillerMessageItem) {
                return ChatAttachedFileWidget(item);
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
                  flex: 1,
                  child: TextField(
                    controller: _controller,
                    keyboardType: TextInputType.multiline,
                    textCapitalization: TextCapitalization.sentences,
                    textInputAction: TextInputAction.done,
                    maxLines: null,
                    decoration: InputDecoration(
                      contentPadding: const EdgeInsets.only(left: 16, right: 16, top: 13, bottom: 13),
                      filled: true,
                      fillColor: AppColors.primaryLighten,
                      hintText: Strings.yourMessage,
                      hintStyle: TextStyles.textSRegular(),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(34.0),
                        borderSide: BorderSide(width: 1, color: AppColors.primaryLighten),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(34.0),
                        borderSide: BorderSide(color: AppColors.primaryLighten, width: 1),
                      ),
                    ),
                  ),
                ),
                SizedBox(width: Margins.spacing_s),
                FloatingActionButton(
                  backgroundColor: AppColors.primary,
                  child: SvgPicture.asset(Drawables.icPaperPlane),
                  onPressed: () {
                    if (_controller.value.text == "Je suis malade. Complètement malade.") {
                      _controller.clear();
                      Navigator.pushNamed(context, CredentialsPage.routeName);
                    }
                    if (_controller.value.text.isNotEmpty) {
                      viewModel.onSendMessage(_controller.value.text);
                      _controller.clear();
                      context.trackEvent(EventType.MESSAGE_ENVOYE);
                    }
                  },
                ),
              ],
            ),
          ),
        )
      ],
    );
  }

  Widget _loader() => Center(child: CircularProgressIndicator(color: AppColors.nightBlue));
}
