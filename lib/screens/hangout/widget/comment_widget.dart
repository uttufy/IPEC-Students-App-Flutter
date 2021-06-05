import 'package:flutter/material.dart';
import 'package:ipecstudentsapp/data/model/hangout/comment.dart';
import 'package:ipecstudentsapp/screens/hangout/widget/userStrip.dart';
import 'package:ipecstudentsapp/theme/colors.dart';
import 'package:ipecstudentsapp/theme/style.dart';

class CommentWidget extends StatelessWidget {
  final CommentModel commentModel;
  final String userId;
  const CommentWidget({
    Key key,
    @required this.commentModel,
    this.userId,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
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
          "This will give us a messaging section with a text field to type the messages and a button to send the messages:",
          textAlign: TextAlign.start,
          style: Theme.of(context)
              .textTheme
              .bodyText1
              .copyWith(fontWeight: FontWeight.normal, fontSize: 16),
        ),
        Row(
          children: [
            Text(
              // '${date.day}/${date.month}/${date.year}',
              '10/20',
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
                      // widget.authorId ==
                      //         widget.currentUserId
                      true ? Icons.delete_forever : Icons.report,
                      color: kLightGrey,
                    ),
                  ],
                ),
              ),
            ),
          ],
        )
      ],
    );
  }
}
