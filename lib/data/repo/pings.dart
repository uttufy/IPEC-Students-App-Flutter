import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:ipecstudentsapp/data/model/hangout/post.dart';

class Pings extends ChangeNotifier {
  final databaseRef =
      FirebaseDatabase.instance.reference().child('hangout').child('pings');

  List<Post> postItemsList = [];

  Future<void> loadPings(int pageSize) async {
    var query = databaseRef.orderByChild('postedOn').limitToFirst(pageSize);
    try {
      final snapshot = await query.once();
      var keys = snapshot.value.keys;
      var data = snapshot.value;

      for (var indivisualKey in keys) {
        final postItem = Post.fromSnapshot(data, indivisualKey);
        if (!(postItemsList.contains(postItem))) postItemsList.add(postItem);
      }
      postItemsList = postItemsList.reversed.toList();
      notifyListeners();
    } catch (e) {
      print(e.toString());
      throw Exception(e);
    }
  }

  void removeItem(String postId) {
    postItemsList.removeWhere((element) => element.id == postId);
    databaseRef.child(postId).remove();
    notifyListeners();
  }

  void deleteEvent(DataSnapshot snapshot) {
    postItemsList.removeWhere((element) => element.id == snapshot.key);
    notifyListeners();
  }

  void addEvent(DataSnapshot snapshot) {
    final newPost = Post.fromMap(snapshot.value);
    if (!(postItemsList.contains(newPost))) postItemsList.insert(0, newPost);
    notifyListeners();
  }
}
