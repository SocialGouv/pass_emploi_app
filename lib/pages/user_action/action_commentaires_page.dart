import 'package:flutter/material.dart';
import 'package:pass_emploi_app/models/commentaire.dart';
import 'package:pass_emploi_app/ui/margins.dart';
import 'package:pass_emploi_app/ui/strings.dart';
import 'package:pass_emploi_app/ui/text_styles.dart';
import 'package:pass_emploi_app/widgets/comment.dart';
import 'package:pass_emploi_app/widgets/default_app_bar.dart';
import 'package:pass_emploi_app/widgets/sepline.dart';

class ActionCommentairesPage extends StatelessWidget {
  final String actionTitle;
  final List<Commentaire> comments;

  ActionCommentairesPage(this.actionTitle, this.comments);

  static MaterialPageRoute<void> materialPageRoute({required String actionTitle, required List<Commentaire> comments}) {
    return MaterialPageRoute(builder: (context) => ActionCommentairesPage(actionTitle, comments));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: passEmploiAppBar(label: Strings.actionCommentsTitle, context: context),
      body: _body(context),
    );
  }

  Widget _body(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: Margins.spacing_m),
      child: Column(
        mainAxisSize: MainAxisSize.max,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          SizedBox(height: Margins.spacing_m),
          _Title(title: actionTitle),
          SizedBox(height: Margins.spacing_xl),
          if(comments.isNotEmpty) _CommentsList(comments: comments),
          if(comments.isEmpty) Text(Strings.noComments, style: TextStyles.textBaseRegular),

        ],
      ),
    );
  }
}

class _Title extends StatelessWidget {
  final String title;

  _Title({required this.title});

  @override
  Widget build(BuildContext context) {
    return Text(title, style: TextStyles.textLBold());
  }
}

class _CommentsList extends StatelessWidget {
  final List<Commentaire> comments;

  _CommentsList({required this.comments});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: ListView.separated(
        separatorBuilder: (_, index) => Padding(
          padding: const EdgeInsets.symmetric(vertical: 14.0),
          child: SepLine(Margins.spacing_s, Margins.spacing_s),
        ),
        itemCount: comments.length,
        itemBuilder: (context, index) => Comment(comment: comments[index]),
      ),
    );
  }
}
