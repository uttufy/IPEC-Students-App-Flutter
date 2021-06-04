import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:ipecstudentsapp/data/model/hangout/post.dart';

import '../../../data/model/hangout/PollModel.dart';
import '../../../theme/style.dart';
import 'bottomStrip.dart';
import 'pollsWidget.dart';
import 'userStrip.dart';

class PingBasicWidget extends StatelessWidget {
  final Post item;

  const PingBasicWidget({
    Key key,
    @required this.name,
    @required this.item,
  }) : super(key: key);
  final String name;
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        kLowPadding,
        UserStripWidget(
          name: item.author.name,
          section: item.author.section,
          yr: item.author.yr,
        ),
        kLowPadding,
        InkWell(onTap: () {}, child: buildMainBody(context)),
        BottomStrip(
          likes: item.likes,
          comments: item.comments,
        ),
        Divider()
      ],
    );
  }

  Column buildMainBody(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          item.text,
          textAlign: TextAlign.start,
          style: Theme.of(context)
              .textTheme
              .headline6
              .copyWith(fontWeight: FontWeight.normal),
        ),
        if (item.isPoll && item.pollData != null)
          PollView(
            poll: PollModel(
                creator: item.author.name,
                numberOfVotes: item.pollData.numberOfVotes,
                optionLabel: item.pollData.optionLabel,
                userWhoVoted: item.pollData.userWhoVoted),
            user: name,
          ),
        if (item.isLinkAttached && item.link != null) LinkWidget(item.link),
        if (item.isImage && item.imageUrl != null)
          Padding(
            padding: const EdgeInsets.only(top: 10.0),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(kLowCircleRadius),
              child: Image.network(
                item.imageUrl,
                height: 180,
                width: double.maxFinite,
                fit: BoxFit.cover,
              ),
            ),
          ),
        if (item.isGif && item.gifUrl != null)
          Padding(
            padding: const EdgeInsets.only(top: 10.0),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(kLowCircleRadius),
              child: Image.network(
                item.gifUrl,
                height: 180,
                width: double.maxFinite,
                fit: BoxFit.cover,
              ),
            ),
          ),
      ],
    );
  }
}

class LinkWidget extends StatelessWidget {
  final String url;

  const LinkWidget(
    this.url, {
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final isDark = AdaptiveTheme.of(context).mode == AdaptiveThemeMode.dark;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: InkWell(
        onTap: () {},
        child: Ink(
          padding: const EdgeInsets.all(10.0),
          decoration: BoxDecoration(
              color: isDark ? Colors.black45 : Colors.grey.shade200,
              borderRadius: BorderRadius.circular(10)),
          child: Row(
            children: [
              Icon(Icons.link),
              kMedWidthPadding,
              Expanded(
                  child: Text(
                url,
                overflow: TextOverflow.ellipsis,
              )),
            ],
          ),
        ),
      ),
    );
  }
}
