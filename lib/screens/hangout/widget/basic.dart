import 'package:flutter/material.dart';
import 'userStrip.dart';
import '../../../theme/colors.dart';
import '../../../theme/style.dart';

class BasicWidget extends StatelessWidget {
  const BasicWidget({
    Key key,
    @required this.name,
  }) : super(key: key);

  final String name;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        UserStripWidget(
          name: name,
          section: 'IT - B',
          yr: '3',
        ),
        kMedPadding,
        Text(
          "Only after disaster can we be resurrected. It's only after you've lost everything that you're free to do anything. Nothing is static, everything is evolving, everything is falling apart.",
          style: Theme.of(context)
              .textTheme
              .headline6
              .copyWith(fontWeight: FontWeight.normal),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            InkWell(
              onTap: () {},
              borderRadius: BorderRadius.circular(20),
              child: Ink(
                padding: const EdgeInsets.all(10),
                decoration:
                    BoxDecoration(borderRadius: BorderRadius.circular(20)),
                child: Row(
                  children: [
                    false
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
                      '3',
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
                      '3',
                      style: Theme.of(context).textTheme.bodyText2.copyWith(
                            color: kLightGrey,
                          ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
        Divider()
      ],
    );
  }
}
