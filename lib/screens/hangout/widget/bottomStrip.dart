import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:ipecstudentsapp/data/repo/pings.dart';
import 'package:provider/provider.dart';

import '../../../theme/colors.dart';
import '../../../theme/style.dart';

class BottomStrip extends StatefulWidget {
  final bool isLiked;
  final int likes;
  final String currentUserId;
  final String postId;
  final String authorId;
  final int comments;
  const BottomStrip({
    Key key,
    this.likes = 0,
    this.comments = 0,
    this.isLiked = false,
    @required this.currentUserId,
    @required this.authorId,
    @required this.postId,
  }) : super(key: key);

  @override
  _BottomStripState createState() => _BottomStripState();
}

class _BottomStripState extends State<BottomStrip> {
  bool isSamosa = false;
  int likes = 0;
  DatabaseReference _firebaseRef;

  @override
  void initState() {
    super.initState();
    isSamosa = widget.isLiked;
    likes = widget.likes;
  }

  @override
  Widget build(BuildContext context) {
    final _pingProvider = Provider.of<Pings>(context, listen: false);
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        InkWell(
          onTap: () {
            setState(() {
              likes = isSamosa ? likes - 1 : likes + 1;
              isSamosa = !isSamosa;
            });
          },
          borderRadius: BorderRadius.circular(20),
          child: Ink(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(borderRadius: BorderRadius.circular(20)),
            child: Row(
              children: [
                isSamosa
                    ? Image.asset(
                        'assets/icons/sam2.png',
                        width: 22,
                      )
                    : ImageIcon(
                        AssetImage('assets/icons/sam1.png'),
                        color: kLightGrey,
                      ),
                kLowWidthPadding,
                Text(
                  likes == 0 ? 'Samosa' : likes.toString(),
                  style: Theme.of(context).textTheme.bodyText2.copyWith(
                        color: kLightGrey,
                      ),
                ),
              ],
            ),
          ),
        ),
        InkWell(
          onTap: () {},
          borderRadius: BorderRadius.circular(20),
          child: Ink(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(borderRadius: BorderRadius.circular(20)),
            child: Row(
              children: [
                Icon(
                  Icons.comment_outlined,
                  color: kLightGrey,
                ),
                kLowWidthPadding,
                Text(
                  widget.comments == 0 ? 'Chatter' : widget.comments.toString(),
                  style: Theme.of(context).textTheme.bodyText2.copyWith(
                        color: kLightGrey,
                      ),
                ),
              ],
            ),
          ),
        ),
        Spacer(),
        InkWell(
          onTap: () {
            if (widget.authorId == widget.currentUserId) {
              _pingProvider.removeItem('${widget.postId}');
            }
          },
          borderRadius: BorderRadius.circular(20),
          child: Ink(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(borderRadius: BorderRadius.circular(20)),
            child: Row(
              children: [
                Icon(
                  widget.authorId == widget.currentUserId
                      ? Icons.delete_forever
                      : Icons.report,
                  color: kLightGrey,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
