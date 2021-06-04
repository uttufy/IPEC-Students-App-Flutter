import 'package:firebase_database/firebase_database.dart';

Future<bool> checkUserExist(String docID) async {
  bool exists = false;
  DatabaseReference userRef =
      FirebaseDatabase.instance.reference().child('hangout').child('user');
  try {
    await userRef.child("$docID").once().then((doc) {
      if (doc.value != null)
        exists = true;
      else
        exists = false;
    });
    return exists;
  } catch (e) {
    return false;
  }
}
