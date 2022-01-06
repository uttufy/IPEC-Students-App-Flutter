import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:circular_profile_avatar/circular_profile_avatar.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../theme/style.dart';
import '../../widgets/simple_appbar.dart';

class AboutScreen extends StatelessWidget {
  static const String ROUTE = "/about";

  _launchURL(String url) async {
    print(url);
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = AdaptiveTheme.of(context).mode == AdaptiveThemeMode.dark;
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            SimpleAppBar(
              onBack: () {
                Navigator.popUntil(context, (route) => route.isFirst);
              },
              title: "About",
            ),
            Expanded(
              child: SingleChildScrollView(
                physics: BouncingScrollPhysics(),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 30.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Team",
                        overflow: TextOverflow.ellipsis,
                        style: Theme.of(context).textTheme.headline6.copyWith(
                              color: isDark ? Colors.white : Colors.black,
                            ),
                      ),
                      kMedPadding,
                      _aboutWidget(
                          context,
                          'https://avatars.githubusercontent.com/u/16814257?v=4',
                          'UTTU',
                          'Utkarsh\nSharma', () {
                        _launchURL('https://www.instagram.com/uttufy');
                      }, () {
                        _launchURL('https://github.com/uttusharma');
                      }, isDark),
                      kMedPadding,
                      _aboutWidget(
                          context,
                          'https://avatars.githubusercontent.com/u/60356611?v=4',
                          'Raks',
                          'Rakshit Raj\nSingh', () {
                        _launchURL(
                            'https://www.instagram.com/rakshit.raj.singh/');
                      }, () {
                        _launchURL('https://github.com/RakshitRajSingh17');
                      }, isDark),
                      kMedPadding,
                      _aboutWidget(
                          context,
                          'https://avatars.githubusercontent.com/u/82357006?v=4',
                          'Ridhi',
                          'Ridhi\nRawat', () {
                        _launchURL('https://www.instagram.com/ri_aina2411');
                      }, () {
                        _launchURL('https://github.com/ridhi-7029hash');
                      }, isDark),
                      kHighPadding,
                      Text(
                        "Message for future students",
                        overflow: TextOverflow.ellipsis,
                        style: Theme.of(context).textTheme.headline6.copyWith(
                            color: isDark ? Colors.white : Colors.black,
                            fontWeight: FontWeight.bold),
                      ),
                      kMedPadding,
                      Text("""
We have developed this app for the students that is why this app will always be ad-free. This app was developed during our mini-project in the year 2020 (In middle of the Covid-19 pandemic). Its predecessor knows as the MyIPEC app also deliver a good experience but It was slow and less modern. So, we made this app in the hope that future students of our college do not have to face some challenges when accessing attendance and never have to miss out on notices.

We hope this app works flawlessly in future too. 

On an island full of engineers you'll have light, whereas on an island full of businessmen you won't.
- 2021
                          """),
                      kMedPadding,
                      Text(
                        "Our Mantras",
                        overflow: TextOverflow.ellipsis,
                        style: Theme.of(context)
                            .textTheme
                            .headline6
                            .copyWith(fontWeight: FontWeight.bold),
                      ),
                      kMedPadding,
                      Text(
                          """"You must have chaos within you to give birth to a dancing star.”
- Utkarsh"""),
                      kMedPadding,
                      Text("""
"I wish I could,but I don't want to 😌"
- Rakshit"""),
                      kMedPadding,
                      Text(""""The way you think is the way you get”
- Ridhi"""),
                      kMedPadding,
                    ],
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  Row _aboutWidget(
    BuildContext context,
    String url,
    String intial,
    String name,
    Function ontap,
    Function onTap2,
    bool isDark,
  ) {
    return Row(
      children: [
        _profileImage(url, intial, ontap),
        kMedWidthPadding,
        Expanded(
            child: GestureDetector(
          onTap: () {
            onTap2();
          },
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                name,
                overflow: TextOverflow.ellipsis,
                style: Theme.of(context).textTheme.headline6.copyWith(
                    color: isDark ? Colors.white : Colors.black,
                    fontWeight: FontWeight.bold),
              ),
              Text(
                "Batch\n2019-2022",
                overflow: TextOverflow.ellipsis,
                style: Theme.of(context).textTheme.bodyText1.copyWith(
                      color: isDark ? Colors.white : Colors.black,
                    ),
              ),
              Text(
                "I.T",
                overflow: TextOverflow.ellipsis,
                style: Theme.of(context).textTheme.bodyText1.copyWith(
                      color: isDark ? Colors.white : Colors.black,
                    ),
              ),
            ],
          ),
        )),
      ],
    );
  }

  Widget _profileImage(String image, String intial, Function onTap) {
    return CircularProfileAvatar(
      image, //sets image path, it should be a URL string. default value is empty string, if path is empty it will display only initials
      radius: 70, // sets radius, default 50.0
      backgroundColor:
          Colors.blue, // sets background color, default Colors.white
      borderWidth: 10, // sets border, default 0.0
      initialsText: Text(
        intial,
        style: TextStyle(fontSize: 40, color: Colors.white),
      ), // sets initials text, set your own style, default Text('')
      // borderColor: Colors.blue, // sets border color, default Colors.white
      elevation:
          5.0, // sets elevation (shadow of the profile picture), default value is 0.0

      cacheImage: true, // allow widget to cache image against provided url
      onTap: () {
        onTap();
      }, // sets on tap

      showInitialTextAbovePicture:
          false, // setting it true will show initials text above profile picture, default false
    );
  }
}
