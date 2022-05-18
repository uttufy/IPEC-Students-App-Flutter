import 'package:circular_profile_avatar/circular_profile_avatar.dart';
import 'package:flutter/material.dart';
import 'package:ipecstudentsapp/theme/colors.dart';

import '../../theme/style.dart';

Column aboutWidget(
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
      profileImage(url, intial, ontap),
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

Widget profileImage(String image, String intial, Function onTap) {
  return CircularProfileAvatar(
    image, //sets image path, it should be a URL string. default value is empty string, if path is empty it will display only initials
    radius: 100, // sets radius, default 50.0
    backgroundColor: kBlue, // sets background color, default Colors.white
    borderWidth: 1, // sets border, default 0.0
    initialsText: Text(
      intial,
      style: TextStyle(
          fontSize: 40, color: Colors.white, fontWeight: FontWeight.bold),
    ), // sets initials text, set your own style, default Text('')
    // borderColor: Colors.blue, // sets border color, default Colors.white
    elevation:
        10.0, // sets elevation (shadow of the profile picture), default value is 0.0

    cacheImage: true, // allow widget to cache image against provided url
    onTap: () {
      onTap();
    }, // sets on tap

    showInitialTextAbovePicture:
        false, // setting it true will show initials text above profile picture, default false
  );
}
