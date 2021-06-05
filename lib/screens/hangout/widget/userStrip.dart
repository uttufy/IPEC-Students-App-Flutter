import 'package:flutter/material.dart';
import 'package:ipecstudentsapp/data/const.dart';

import '../../../theme/style.dart';
import '../../../util/SizeConfig.dart';

class UserStripWidget extends StatelessWidget {
  const UserStripWidget({
    Key key,
    @required this.name,
    @required this.section,
    @required this.yr,
    @required this.id,
  }) : super(key: key);

  final String id;
  final String name;
  final String section;
  final String yr;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        //Open Profile
      },
      child: Row(
        children: [
          CircleAvatar(
            radius: SizeConfig.widthMultiplier * 5,
            backgroundImage: NetworkImage("https://robohash.org/$name"),
          ),
          kMedWidthPadding,
          Flexible(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Flexible(
                      child: Text(
                        name,
                        style: TextStyle(
                            fontSize: 12, fontWeight: FontWeight.bold),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    Visibility(
                        visible: kAdmins.contains(id), child: kLowWidthPadding),
                    Visibility(
                      visible: kAdmins.contains(id),
                      child: Image.asset(
                        'assets/icons/verified.png',
                        width: 15,
                      ),
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text(
                      yr + " year, ",
                      style: TextStyle(fontSize: 12),
                      overflow: TextOverflow.ellipsis,
                    ),
                    Text(
                      section,
                      style: TextStyle(fontSize: 12),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
