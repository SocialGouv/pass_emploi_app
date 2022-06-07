import 'package:flutter/material.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:flutter_svg/svg.dart';
import 'package:pass_emploi_app/network/cache_manager.dart';
import 'package:pass_emploi_app/presentation/chat_item.dart';
import 'package:pass_emploi_app/repositories/attached_file_repository.dart';
import 'package:pass_emploi_app/ui/app_colors.dart';
import 'package:pass_emploi_app/ui/drawables.dart';
import 'package:pass_emploi_app/ui/margins.dart';
import 'package:pass_emploi_app/ui/strings.dart';
import 'package:pass_emploi_app/ui/text_styles.dart';
import 'package:pass_emploi_app/widgets/buttons/primary_action_button.dart';
import 'package:share_plus/share_plus.dart';

class ChatAttachedFileWidget extends StatelessWidget {
  final AttachedFileConseillerMessageItem item;

  const ChatAttachedFileWidget(this.item) : super();

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 10, bottom: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _MessageBubble(
            children: [
              Text(item.message, style: TextStyles.textSRegular()),
              SizedBox(height: 14),
              _PieceJointeName(item.filename),
              SizedBox(height: 20),
              _DownloadButton(),
            ],
          ),
          _Caption(item.caption),
        ],
      ),
    );
  }
}

class _MessageBubble extends StatelessWidget {
  final List<Widget> children;

  const _MessageBubble({required this.children}) : super();

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(
        left: 0,
        right: 77.0,
      ),
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: AppColors.primaryLighten,
        borderRadius: BorderRadius.all(Radius.circular(16)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: children,
      ),
    );
  }
}

class _PieceJointeName extends StatelessWidget {
  final String filename;

  const _PieceJointeName(this.filename) : super();

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Padding(padding: const EdgeInsets.only(right: 10), child: SvgPicture.asset(Drawables.icClip)),
        Flexible(
          child: Text(
            filename,
            style: TextStyles.textSBoldWithColor(Colors.black),
          ),
        ),
      ],
    );
  }
}

class _Caption extends StatelessWidget {
  final String text;

  const _Caption(this.text) : super();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(height: Margins.spacing_xs),
        Text(text, style: TextStyles.textXsRegular()),
      ],
    );
  }
}

class _DownloadButton extends StatelessWidget {
  const _DownloadButton() : super();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: PrimaryActionButton(
        label: Strings.download,
        drawableRes: Drawables.icDownload,
        onPressed: () => {
          _share()
        },
        heightPadding: 2,
      ),
    );
  }

  // todo : PoC to remove
  _share() async {
    final hardcodedUrl = "https://www.messagerbenin.info/wp-content/uploads/2021/06/14481-google-logo-3-s-.jpg";
    final cache = PassEmploiCacheManager(Config("aaa"));
    final fileInfo = await cache.downloadFile(hardcodedUrl);
    final path = fileInfo.file.path;
    print('downloaded file path = $path');
    Share.shareFiles(['$path'], text: 'Cute one');
  }
}
