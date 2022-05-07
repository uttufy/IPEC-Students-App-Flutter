import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sweetsheet/sweetsheet.dart';

import '../../../data/model/hangout/comment.dart';
import '../../../data/repo/pings.dart';
import '../../../theme/colors.dart';
import '../../../theme/style.dart';
import 'userStrip.dart';

class CommentWidget extends StatelessWidget {
  final CommentModel commentModel;
  final String? currentUserID;
  final String? postID;
  CommentWidget({
    Key? key,
    required this.commentModel,
    required this.currentUserID,
    required this.postID,
  }) : super(key: key);

  final SweetSheet _sweetSheet = SweetSheet();
  @override
  Widget build(BuildContext context) {
    final date = DateTime.fromMicrosecondsSinceEpoch(commentModel.postedOn!);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        UserStripWidget(
          name: commentModel.author.name,
          section: commentModel.author.section,
          yr: commentModel.author.yr,
          id: commentModel.author.id,
          isCompact: true,
        ),
        kLowPadding,
        Text(
          commentModel.text!,
          textAlign: TextAlign.start,
          style: Theme.of(context)
              .textTheme
              .bodyText1!
              .copyWith(fontWeight: FontWeight.normal, fontSize: 16),
        ),
        if (commentModel.isGif! && commentModel.gifUrl != null)
          GestureDetector(
            onTap: () {},
            child: Padding(
              padding: const EdgeInsets.only(top: 10.0),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(kLowCircleRadius),
                child: Image.network(
                  commentModel.gifUrl!,
                  height: 150,
                  width: double.maxFinite,
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
        Row(
          children: [
            Text(
              '${date.day}/${date.month}/${date.year}',
              style: TextStyle(color: kLightGrey, fontSize: 12),
            ),
            Spacer(),
            InkWell(
              onTap: () {
                final _pingProvider =
                    Provider.of<Pings>(context, listen: false);
                if (commentModel.author.id == currentUserID)
                  _onDelete(context, _pingProvider);
                else
                  _onReport(context, _pingProvider);
              },
              borderRadius: BorderRadius.circular(20),
              child: Ink(
                padding: const EdgeInsets.all(10),
                decoration:
                    BoxDecoration(borderRadius: BorderRadius.circular(20)),
                child: Row(
                  children: [
                    Icon(
                      commentModel.author.id == currentUserID
                          ? Icons.delete_forever
                          : Icons.report,
                      color: kLightGrey,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
        Divider(),
      ],
    );
  }

  void _onDelete(BuildContext context, Pings pingProvider) {
    _sweetSheet.show(
      context: context,
      title: Text("Are you sure ?"),
      description: Text('This action will delete your ping'),
      color: SweetSheetColor.DANGER,
      icon: Icons.remove_circle_outline,
      positive: SweetSheetAction(
        onPressed: () {
          pingProvider.removeComment(commentModel.commentId!, postID!);
          Navigator.of(context).pop();
        },
        title: 'DELETE',
        icon: Icons.delete_rounded,
      ),
      negative: SweetSheetAction(
        onPressed: () {
          Navigator.of(context).pop();
        },
        title: 'CANCEL',
      ),
    );
  }

  void _onReport(BuildContext context, Pings pingProvider) {
    _sweetSheet.show(
      context: context,
      title: Text("Report"),
      description:
          Text('Did you find this ping to be harmful/spam/wrong/misleading?'),
      color: SweetSheetColor.WARNING,
      icon: Icons.error,
      positive: SweetSheetAction(
          onPressed: () {
            pingProvider.reportComment(
                commentModel.commentId!, postID!, currentUserID);
            Navigator.of(context).pop();
          },
          title: 'REPORT',
          icon: Icons.warning),
      negative: SweetSheetAction(
        onPressed: () {
          Navigator.of(context).pop();
        },
        title: 'CANCEL',
      ),
    );
  }
}
