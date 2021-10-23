import 'package:firebase_database/firebase_database.dart';

Future<Map> checkUserExist(String docID) async {
  DatabaseReference userRef =
      FirebaseDatabase.instance.reference().child('hangout').child('user');
  Map<String, dynamic> res = Map<String, dynamic>();
  try {
    await userRef.child("$docID").once().then((doc) {
      if (doc.value != null) {
        res['exists'] = true;
        res['data'] = doc.value;
      } else
        res['exists'] = false;
    });
    return res;
  } catch (e) {
    res['exists'] = false;
    return res;
  }
}
