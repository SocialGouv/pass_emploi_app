import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:pass_emploi_app/analytics/analytics_constants.dart';
import 'package:pass_emploi_app/analytics/tracker.dart';
import 'package:pass_emploi_app/features/chat/brouillon/chat_brouillon_actions.dart';
import 'package:pass_emploi_app/features/chat/messages/chat_actions.dart';
import 'package:pass_emploi_app/network/post_tracking_event_request.dart';
import 'package:pass_emploi_app/pages/credentials_page.dart';
import 'package:pass_emploi_app/presentation/chat_item.dart';
import 'package:pass_emploi_app/presentation/chat_page_view_model.dart';
import 'package:pass_emploi_app/presentation/display_state.dart';
import 'package:pass_emploi_app/presentation/onboarding/onboarding_bottom_sheet.dart';
import 'package:pass_emploi_app/redux/app_state.dart';
import 'package:pass_emploi_app/ui/app_colors.dart';
import 'package:pass_emploi_app/ui/app_icons.dart';
import 'package:pass_emploi_app/ui/margins.dart';
import 'package:pass_emploi_app/ui/strings.dart';
import 'package:pass_emploi_app/ui/text_styles.dart';
import 'package:pass_emploi_app/utils/context_extensions.dart';
import 'package:pass_emploi_app/widgets/apparition_animation.dart';
import 'package:pass_emploi_app/widgets/chat/chat_information.dart';
import 'package:pass_emploi_app/widgets/chat/chat_piece_jointe.dart';
import 'package:pass_emploi_app/widgets/chat/chat_text_message.dart';
import 'package:pass_emploi_app/widgets/chat/partage_message.dart';
import 'package:pass_emploi_app/widgets/connectivity_widgets.dart';
import 'package:pass_emploi_app/widgets/default_animated_switcher.dart';
import 'package:pass_emploi_app/widgets/default_app_bar.dart';
import 'package:pass_emploi_app/widgets/illustration/empty_state_placeholder.dart';
import 'package:pass_emploi_app/widgets/illustration/illustration.dart';
import 'package:pass_emploi_app/widgets/preview_file_invisible_handler.dart';
import 'package:pass_emploi_app/widgets/retry.dart';
import 'package:pass_emploi_app/widgets/sepline.dart';
import 'package:pass_emploi_app/widgets/text_form_fields/base_text_form_field.dart';
import 'package:redux/redux.dart';

class ChatPage extends StatefulWidget {
  @override
  ChatPageState createState() => ChatPageState();
}

class ChatPageState extends State<ChatPage> with WidgetsBindingObserver {
  final ScrollController _scrollController = ScrollController();
  TextEditingController? _controller;
  bool _animateMessage = false;
  bool _isLoadingMorePast = false;
  bool _onboardingShown = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _scrollController.addListener(() {
      final hasReachedTop = _scrollController.position.pixels >= _scrollController.position.maxScrollExtent * 0.9;
      if (hasReachedTop && _isLoadingMorePast == false) {
        _isLoadingMorePast = true;
        StoreProvider.of<AppState>(context).dispatch(ChatRequestMorePastAction());
      }
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _controller?.dispose();
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
    return Tracker(
      tracking: AnalyticsScreenNames.chat,
      child: StoreConnector<AppState, ChatPageViewModel>(
        onInit: (store) {
          store.dispatch(LastMessageSeenAction());
          store.dispatch(SubscribeToChatAction());
        },
        onDispose: (store) => _onDispose(store),
        converter: (store) => ChatPageViewModel.create(store),
        builder: (context, viewModel) => _builder(viewModel, _body(context, viewModel)),
        onDidChange: (previousVm, newVm) {
          StoreProvider.of<AppState>(context).dispatch(LastMessageSeenAction());
          _animateMessage = true;
          _isLoadingMorePast = false;
          _handleOnboarding(newVm);
        },
        distinct: true,
      ),
    );
  }

  void _handleOnboarding(ChatPageViewModel viewModel) {
    if (viewModel.shouldShowOnboarding && !_onboardingShown) {
      _onboardingShown = true;
      OnboardingBottomSheet.show(context, source: OnboardingSource.chat);
    }
  }

  void _onDispose(Store<AppState> store) {
    store.dispatch(UnsubscribeFromChatAction());
    if (_controller != null) store.dispatch(SaveChatBrouillonAction(_controller!.value.text));
  }

  Widget _builder(ChatPageViewModel viewModel, Widget body) {
    return Scaffold(
      backgroundColor: AppColors.grey100,
      appBar: PrimaryAppBar(title: Strings.menuChat),
      body: ConnectivityContainer(
        child: Column(
          children: [
            SepLine(0, 0),
            Expanded(child: DefaultAnimatedSwitcher(child: body)),
            PreviewFileInvisibleHandler(),
          ],
        ),
      ),
    );
  }

  Widget _body(BuildContext context, ChatPageViewModel viewModel) {
    switch (viewModel.displayState) {
      case DisplayState.CONTENT:
        return _content(context, viewModel);
      case DisplayState.LOADING:
        return Center(child: CircularProgressIndicator());
      default:
        return Center(child: Retry(Strings.chatError, () => viewModel.onRetry()));
    }
  }

  Widget _content(BuildContext context, ChatPageViewModel viewModel) {
    _controller = (_controller != null) ? _controller : TextEditingController(text: viewModel.brouillon);
    final reversedList = viewModel.items.reversed.toList();
    return Stack(
      children: [
        reversedList.isEmpty
            ? _EmptyChatPlaceholder()
            : ListView.builder(
                reverse: true,
                padding: const EdgeInsets.only(left: 16.0, right: 16.0, top: 16.0, bottom: 100.0),
                keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
                controller: _scrollController,
                itemCount: reversedList.length,
                itemBuilder: (context, index) {
                  final item = reversedList[index];

                  if (index == 0 && _animateMessage && item.shouldAnimate) {
                    return ApparitionAnimation(
                      key: ValueKey(item.messageId),
                      child: SizedBox(
                        width: double.infinity,
                        child: _messageBuilder(item),
                      ),
                    );
                  }
                  return _messageBuilder(item);
                }),
        Align(
          alignment: Alignment.bottomCenter,
          child: Container(
            color: Colors.white,
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Flexible(
                  flex: 1,
                  child: BaseTextField(
                    controller: _controller,
                    keyboardType: TextInputType.multiline,
                    minLines: 1,
                    maxLines: 5,
                    hintText: Strings.yourMessage,
                  ),
                ),
                SizedBox(width: Margins.spacing_s),
                FloatingActionButton(
                  backgroundColor: AppColors.primary,
                  tooltip: Strings.sendMessageTooltip,
                  child: Icon(
                    AppIcons.send_rounded,
                    color: Colors.white,
                  ),
                  onPressed: () {
                    if (_controller?.value.text == "Je suis malade. Complètement malade.") {
                      _controller!.clear();
                      Navigator.push(context, CredentialsPage.materialPageRoute());
                    }
                    if (_controller?.value.text.isNotEmpty == true) {
                      viewModel.onSendMessage(_controller!.value.text);
                      _controller!.clear();
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

  Widget _messageBuilder(ChatItem item) {
    if (item is DayItem) {
      return Center(child: Text(item.dayLabel, style: TextStyles.textSRegular()));
    } else if (item is TextMessageItem) {
      return ChatTextMessage(item);
    } else if (item is InformationItem) {
      return ChatInformation(item.title, item.description);
    } else if (item is PieceJointeConseillerMessageItem) {
      return ChatPieceJointe(item);
    } else if (item is PartageMessageItem) {
      return PartageMessage(item);
    } else {
      return Container();
    }
  }
}

class _EmptyChatPlaceholder extends StatelessWidget {
  const _EmptyChatPlaceholder();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: EmptyStatePlaceholder(
        illustration: Illustration.grey(AppIcons.forum_rounded),
        title: Strings.chatEmpty,
        subtitle: Strings.chatEmptySubtitle,
      ),
    );
  }
}
