import 'package:flutter/material.dart';
import 'package:ipecstudentsapp/theme/colors.dart';
import 'package:ipecstudentsapp/theme/style.dart';

class BottomStrip extends StatefulWidget {
  final bool isLiked;
  final int likes;

  final int comments;
  const BottomStrip({
    Key key,
    this.likes = 0,
    this.comments = 0,
    this.isLiked = false,
  }) : super(key: key);

  @override
  _BottomStripState createState() => _BottomStripState();
}

class _BottomStripState extends State<BottomStrip> {
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        InkWell(
          onTap: () {},
          borderRadius: BorderRadius.circular(20),
          child: Ink(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(borderRadius: BorderRadius.circular(20)),
            child: Row(
              children: [
                widget.isLiked
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
                  widget.likes == 0 ? 'Samosa' : widget.likes.toString(),
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
                  widget.comments == 0 ? 'Gossip' : widget.comments.toString(),
                  style: Theme.of(context).textTheme.bodyText2.copyWith(
                        color: kLightGrey,
                      ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
