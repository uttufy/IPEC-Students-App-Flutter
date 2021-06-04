import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';

import '../../../data/model/hangout/PollModel.dart';
import '../../../theme/style.dart';
import 'bottomStrip.dart';
import 'pollsWidget.dart';
import 'userStrip.dart';

class PingBasicWidget extends StatelessWidget {
  final bool havePhoto;
  final String imageURl;
  final String url;
  final bool isLinkAttached;
  final String pingTxt;
  final bool isPool;
  final PollModel pollModel;

  const PingBasicWidget({
    Key key,
    @required this.name,
    this.havePhoto = false,
    this.imageURl,
    this.url,
    this.isLinkAttached,
    this.pingTxt = "",
    this.isPool = false,
    this.pollModel,
  }) : super(key: key);
  final String name;
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        kLowPadding,
        UserStripWidget(
          name: name,
          section: 'IT - B',
          yr: '3',
        ),
        kLowPadding,
        InkWell(onTap: () {}, child: buildMainBody(context)),
        BottomStrip(
          likes: 2,
          // comments: 4,
        ),
        Divider()
      ],
    );
  }

  Column buildMainBody(BuildContext context) {
    return Column(
      children: [
        Text(
          pingTxt,
          style: Theme.of(context)
              .textTheme
              .headline6
              .copyWith(fontWeight: FontWeight.normal),
        ),
        // if (isPool && pollModel != null)
        PollView(
          poll: PollModel(
              creator: 'asd',
              numberOfVotes: [1.0, 0.0],
              optionLabel: ["Backend", "Frontend"],
              userWhoVoted: {'cme': 1}),
          user: 'Utkarsh',
        ),
        if (isLinkAttached && url != null) LinkWidget(url),
        if (havePhoto && imageURl != null)
          Padding(
            padding: const EdgeInsets.only(top: 10.0),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(kLowCircleRadius),
              child: Image.network(
                imageURl,
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
