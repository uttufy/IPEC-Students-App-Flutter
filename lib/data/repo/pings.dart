import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:ipecstudentsapp/data/model/hangout/hangUser.dart';

import '../model/hangout/post.dart';

class Pings extends ChangeNotifier {
  Huser _hUser;

  // ignore: unnecessary_getters_setters
  Huser get hUser => _hUser;
  // ignore: unnecessary_getters_setters
  set hUser(Huser u) => _hUser = u;

  final databaseRef =
      FirebaseDatabase.instance.reference().child('hangout').child('pings');
  final databaseRef2 = FirebaseDatabase.instance.reference().child('hangout');

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

  Future<void> reportItem(String postId, String userID) async {
    final res = await databaseRef2.child('reports').child(postId).once();
    if (res.value != null) {
      List list = res.value;
      if (list.length <= 5) {
        if (!(list.contains(userID))) {
          list.add(userID);
          databaseRef2.child('reports').child(postId).set(list);
        }
      } else {
        //ban permanent
        databaseRef2
            .child('pings')
            .child(postId)
            .update({'reports': list.length});
      }
    } else {
      databaseRef2.child('reports').child(postId).set([userID]);
    }
    postItemsList.removeWhere((element) => element.id == postId);

    notifyListeners();
  }

  void addLike(
    String postId,
  ) {
    var elem = postItemsList.firstWhere((element) => element.id == postId);
    elem.likes = elem.likes + 1;
    databaseRef.child(postId).update({'likes': elem.likes});
    _hUser.likes.add(postId);
    notifyListeners();
  }

  void removeLike(
    String postId,
  ) {
    var elem = postItemsList.firstWhere((element) => element.id == postId);
    if (elem.likes > 0) {
      elem.likes = elem.likes - 1;
      databaseRef.child(postId).update({'likes': elem.likes});
      _hUser.likes.remove(postId);
      notifyListeners();
    }
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
