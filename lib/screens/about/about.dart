import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:circular_profile_avatar/circular_profile_avatar.dart';
import 'package:flutter/material.dart';
import '../../theme/colors.dart';
import '../../util/SizeConfig.dart';
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
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      kMedPadding,
                      _aboutWidget(
                          context,
                          'https://avatars.githubusercontent.com/u/16814257?v=4',
                          'UTTU',
                          'Utkarsh Sharma', () {
                        _launchURL('https://www.instagram.com/uttufy');
                      }, () {
                        _launchURL('https://github.com/uttusharma');
                      }, isDark),
                      kMedPadding,
                      _aboutWidget(
                          context,
                          'https://avatars.githubusercontent.com/u/60356611?v=4',
                          'Raks',
                          'Rakshit Raj Singh', () {
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
                          'Ridhi Rawat', () {
                        _launchURL('https://www.instagram.com/ri_aina2411');
                      }, () {
                        _launchURL('https://github.com/ridhi-7029hash');
                      }, isDark),
                      kHighPadding,
                      Text(
                        "Tap image to connect on instagram and name to connect on github",
                        overflow: TextOverflow.clip,
                        textAlign: TextAlign.center,
                        style: Theme.of(context).textTheme.bodyText1!.copyWith(
                              color: isDark ? Colors.white : Colors.black,
                            ),
                      ),
                      kMedPadding,
                      Text(
                        "Support this project",
                        overflow: TextOverflow.ellipsis,
                        style: Theme.of(context)
                            .textTheme
                            .headline6!
                            .copyWith(fontWeight: FontWeight.bold),
                      ),
                      kMedPadding,
                      Text(
                          """This project is open-source make a pull request to improve this app."""),
                      kMedPadding,
                      InkWell(
                        onTap: () {
                          _launchURL(
                              'https://github.com/uttusharma/IPEC-Students-App-Flutter');
                        },
                        borderRadius: BorderRadius.circular(30),
                        highlightColor: kPrimaryLightColor,
                        child: Ink(
                          padding: const EdgeInsets.all(20),
                          decoration: BoxDecoration(
                              color: kBlue,
                              borderRadius: BorderRadius.circular(30)),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.link),
                              kLowWidthPadding,
                              Text(
                                "Github",
                                textAlign: TextAlign.center,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(),
                              ),
                            ],
                          ),
                        ),
                      ),
                      kMedPadding,
                      Text(
                        "Message for future students",
                        overflow: TextOverflow.ellipsis,
                        style: Theme.of(context).textTheme.headline6!.copyWith(
                            color: isDark ? Colors.white : Colors.black,
                            fontWeight: FontWeight.bold),
                      ),
                      kMedPadding,
                      Text("""
We have developed this app for the students that is why this app will always be ad-free. This app was developed during our mini-project in the year 2020 (In middle of the Covid-19 pandemic). Its predecessor knows as the MyIPEC app also deliver a good experience but It was slow and less modern. So, we made this app in the hope that future students of our college do not have to face some challenges when accessing attendance and never have to miss out on notices.

We hope this app works flawlessly in future too. 

On an island full of engineers you'll have light, whereas on an island full of businessmen you won't.
                          """),
                      kHighPadding,
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

  Column _aboutWidget(
    BuildContext context,
    String url,
    String intial,
    String name,
    Function ontap,
    Function onTap2,
    bool isDark,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        _profileImage(url, intial, ontap),
        kMedPadding,
        GestureDetector(
          onTap: () {
            onTap2();
          },
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                name,
                overflow: TextOverflow.ellipsis,
                style: Theme.of(context).textTheme.headline6!.copyWith(
                    color: isDark ? Colors.white : Colors.black,
                    fontWeight: FontWeight.bold),
              ),
              Text(
                "I.T Batch 2019-2022",
                overflow: TextOverflow.ellipsis,
                style: Theme.of(context).textTheme.bodyText1!.copyWith(
                      color: isDark ? Colors.white : Colors.black,
                    ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _profileImage(String image, String intial, Function onTap) {
    return CircularProfileAvatar(
      image, //sets image path, it should be a URL string. default value is empty string, if path is empty it will display only initials
      radius: 100, // sets radius, default 50.0
      backgroundColor:
          Colors.blue, // sets background color, default Colors.white
      borderWidth: 2, // sets border, default 0.0
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
