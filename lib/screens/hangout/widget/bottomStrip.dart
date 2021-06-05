import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sweetsheet/sweetsheet.dart';

import '../../../data/repo/auth.dart';
import '../../../data/repo/pings.dart';
import '../../../theme/colors.dart';
import '../../../theme/style.dart';

class BottomStrip extends StatefulWidget {
  final String currentUserId;
  final String postId;
  final String authorId;

  const BottomStrip({
    Key key,
    @required this.currentUserId,
    @required this.authorId,
    @required this.postId,
  }) : super(key: key);

  @override
  _BottomStripState createState() => _BottomStripState();
}

class _BottomStripState extends State<BottomStrip> {
  bool isSamosa = false;
  final SweetSheet _sweetSheet = SweetSheet();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<Auth>(
      builder: (context, authProvider, child) {
        isSamosa = authProvider.hUser.likes.contains(widget.postId);
        print(isSamosa);
        return Consumer<Pings>(
          builder: (context, pingProvider, child) {
            final item = pingProvider.postItemsList
                .firstWhere((element) => element.id == widget.postId);

            return Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                InkWell(
                  onTap: () {
                    setState(() {
                      if (isSamosa) {
                        pingProvider.removeLike(widget.postId);
                        authProvider.removeLikeID(widget.postId);
                      } else {
                        pingProvider.addLike(widget.postId);
                        authProvider.addLikeID(widget.postId);
                      }
                    });
                  },
                  borderRadius: BorderRadius.circular(20),
                  child: Ink(
                    padding: const EdgeInsets.all(10),
                    decoration:
                        BoxDecoration(borderRadius: BorderRadius.circular(20)),
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
                          item.likes == 0 ? 'Samosa' : item.likes.toString(),
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
                    decoration:
                        BoxDecoration(borderRadius: BorderRadius.circular(20)),
                    child: Row(
                      children: [
                        Icon(
                          Icons.comment_outlined,
                          color: kLightGrey,
                        ),
                        kLowWidthPadding,
                        Text(
                          item.comments == 0
                              ? 'Chatter'
                              : item.comments.toString(),
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
                    if (widget.authorId == widget.currentUserId)
                      _onDelete(context, pingProvider);
                    else
                      _onReport(context, pingProvider, authProvider.hUser.id);
                  },
                  borderRadius: BorderRadius.circular(20),
                  child: Ink(
                    padding: const EdgeInsets.all(10),
                    decoration:
                        BoxDecoration(borderRadius: BorderRadius.circular(20)),
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
          },
        );
      },
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
          if (widget.postId != "1813119_1622898994899")
            pingProvider.removeItem('${widget.postId}');
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

  void _onReport(BuildContext context, Pings pingProvider, String id) {
    _sweetSheet.show(
      context: context,
      title: Text("Report"),
      description:
          Text('Did you find this ping to be harmful/spam/wrong/misleading?'),
      color: SweetSheetColor.WARNING,
      icon: Icons.error,
      positive: SweetSheetAction(
          onPressed: () {
            if (widget.postId != "1813119_1622898994899")
              pingProvider.reportItem(widget.postId, id);
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
