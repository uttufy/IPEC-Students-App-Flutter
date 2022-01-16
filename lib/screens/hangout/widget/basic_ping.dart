import 'package:flutter/material.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:ipecstudentsapp/screens/hangout/chatter_screen.dart';
import '../../../data/model/hangout/PollModel.dart';
import '../../../data/model/hangout/post.dart';
import '../../../theme/style.dart';
import 'bottomStrip.dart';
import 'linked_widget.dart';
import 'pollsWidget.dart';
import 'userStrip.dart';
import 'package:cached_network_image/cached_network_image.dart';

class PingBasicWidget extends StatelessWidget {
  final Post? item;
  final String? userId;
  final bool detailedView;
  const PingBasicWidget({
    Key? key,
    required this.userId,
    required this.item,
    this.detailedView = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        kLowPadding,
        UserStripWidget(
            name: item!.author.name,
            section: item!.author.section,
            yr: item!.author.yr,
            id: item!.author.id),
        kLowPadding,
        buildMainBody(context),
        BottomStrip(
          isDetailed: detailedView,
          postId: item!.id,
          currentUserId: userId,
          authorId: item!.author.id,
          onChatter: () {
            _openDetailed(context);
          },
          postedOn: item!.postedOn,
        ),
        Visibility(visible: !detailedView, child: Divider())
      ],
    );
  }

  Column buildMainBody(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        InkWell(
          onTap: () {
            _openDetailed(context);
          },
          child: Text(
            item!.text!,
            textAlign: TextAlign.start,
            style: Theme.of(context)
                .textTheme
                .headline6!
                .copyWith(fontWeight: FontWeight.normal),
          ),
        ),
        if (item!.isPoll! && item!.pollData != null)
          PollView(
            poll: PollModel(
                creator: item!.author.id,
                numberOfVotes: item!.pollData.numberOfVotes,
                optionLabel: item!.pollData.optionLabel,
                userWhoVoted: item!.pollData.userWhoVoted),
            user: userId,
            postId: item!.id,
          ),
        if (item!.isLinkAttached! && item!.link != null) LinkWidget(item!.link),
        if (item!.isImage! && item!.imageUrl != null)
          GestureDetector(
            onTap: () {
              _openDetailed(context);
            },
            child: Padding(
              padding: const EdgeInsets.only(top: 10.0),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(kLowCircleRadius),
                child: CachedNetworkImage(
                  imageUrl: item!.imageUrl!,
                  // height: 180,
                  width: double.maxFinite,
                  fit: BoxFit.cover,
                  progressIndicatorBuilder: (context, url, downloadProgress) =>
                      Center(
                    child: CircularProgressIndicator(
                        value: downloadProgress.progress),
                  ),
                  errorWidget: (context, url, error) => Icon(Icons.error),
                ),
              ),
            ),
          ),
        if (item!.isGif! && item!.gifUrl != null)
          GestureDetector(
            onTap: () {
              _openDetailed(context);
            },
            child: Padding(
              padding: const EdgeInsets.only(top: 10.0),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(kLowCircleRadius),
                child: Image.network(
                  item!.gifUrl!,
                  height: 180,
                  width: double.maxFinite,
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
      ],
    );
  }

  void _openDetailed(BuildContext context) {
    if (!detailedView)
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) {
            return ChatterScreen(
              post: item,
            );
          },
        ),
      );
  }
}
