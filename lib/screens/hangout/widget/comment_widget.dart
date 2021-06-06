import 'package:flutter/material.dart';
import 'package:ipecstudentsapp/data/model/hangout/comment.dart';
import 'package:ipecstudentsapp/screens/hangout/widget/userStrip.dart';
import 'package:ipecstudentsapp/theme/colors.dart';
import 'package:ipecstudentsapp/theme/style.dart';

class CommentWidget extends StatelessWidget {
  final CommentModel commentModel;
  final String currentUserID;
  const CommentWidget({
    Key key,
    @required this.commentModel,
    @required this.currentUserID,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final date = DateTime.fromMillisecondsSinceEpoch(commentModel.postedOn);

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
          commentModel.text,
          textAlign: TextAlign.start,
          style: Theme.of(context)
              .textTheme
              .bodyText1
              .copyWith(fontWeight: FontWeight.normal, fontSize: 16),
        ),
        if (commentModel.isGif && commentModel.gifUrl != null)
          GestureDetector(
            onTap: () {},
            child: Padding(
              padding: const EdgeInsets.only(top: 10.0),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(kLowCircleRadius),
                child: Image.network(
                  commentModel.gifUrl,
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
                // if (widget.authorId == widget.currentUserId)
                //   _onDelete(context, pingProvider);
                // else
                //   _onReport(context, pingProvider,
                //       pings.hUser.id);
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
      ],
    );
  }
}
