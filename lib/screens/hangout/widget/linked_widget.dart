import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:flutter/material.dart';
import 'package:ipecstudentsapp/theme/style.dart';
import 'package:sweetsheet/sweetsheet.dart';
import 'package:url_launcher/url_launcher.dart';

class LinkWidget extends StatelessWidget {
  final String url;

  LinkWidget(
    this.url, {
    Key key,
  }) : super(key: key);

  _launchURL(String url) async {
    print(url);
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  final SweetSheet _sweetSheet = SweetSheet();

  @override
  Widget build(BuildContext context) {
    final isDark = AdaptiveTheme.of(context).mode == AdaptiveThemeMode.dark;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: InkWell(
        onTap: () {
          _sweetSheet.show(
            context: context,
            title: Text("Warning!"),
            description: Text('Do you really want open link ? '),
            color: SweetSheetColor.NICE,
            icon: Icons.link,
            positive: SweetSheetAction(
              onPressed: () {
                _launchURL(url);
                Navigator.of(context).pop();
              },
              title: 'OPEN IN BROWSER',
              icon: Icons.open_in_browser,
            ),
            negative: SweetSheetAction(
              onPressed: () {
                Navigator.of(context).pop();
              },
              title: 'CANCEL',
            ),
          );
        },
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
