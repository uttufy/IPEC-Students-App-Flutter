import 'package:html/parser.dart';

import '../data/const.dart';
import '../data/model/User.dart';

class SugarParser {
  User user(String body, username) {
    var document = parse(body);
    var name = document.querySelector("#lblname").text;
    print(name);
    var userImage =
        document.querySelector("#UserImage").attributes.values.elementAt(1);
    if (name != null) {
      if (userImage == null) {
        userImage = kDefaultUserImage;
      }
      return User(
          id: username, name: name.toString().split(',')[0], img: userImage);
    }
    return User(id: username, name: "User", img: userImage);
  }
}
