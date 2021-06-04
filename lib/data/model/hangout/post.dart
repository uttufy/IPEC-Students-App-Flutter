import 'dart:convert';

import 'package:flutter/foundation.dart';

import 'package:ipecstudentsapp/data/model/hangout/hangUser.dart';

import 'PollModel.dart';

class Post {
  final String id;
  final Huser author;
  final String authorImage;
  final int postedOn;
  final String text;
  int likes;
  int comments;
  int reports;
  final bool isLinkAttached;
  final String link;
  final bool isImage;
  final String imageUrl;
  final bool isPoll;
  final PollModel pollData;
  final bool isGif;
  final String gifUrl;
  Post({
    @required this.id,
    @required this.author,
    @required this.authorImage,
    @required this.postedOn,
    @required this.text,
    this.likes = 0,
    this.comments = 0,
    this.reports = 0,
    this.isLinkAttached = false,
    @required this.link,
    this.isImage = false,
    @required this.imageUrl,
    this.isPoll = false,
    @required this.pollData,
    this.isGif = false,
    @required this.gifUrl,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'author': author.toMap(),
      'authorImage': authorImage,
      'postedOn': postedOn,
      'text': text,
      'likes': likes,
      'comments': comments,
      'reports': reports,
      'isLinkAttached': isLinkAttached,
      'link': link,
      'isImage': isImage,
      'imageUrl': imageUrl,
      'isPoll': isPoll,
      'pollData': pollData.toMap(),
      'isGif': isGif,
      'gifUrl': gifUrl
    };
  }

  factory Post.fromMap(Map<dynamic, dynamic> map) {
    return Post(
        id: map['id'],
        author: Huser.fromMap(map['author']),
        authorImage: map['authorImage'],
        postedOn: map['postedOn'],
        text: map['text'],
        likes: map['likes'],
        comments: map['comments'],
        reports: map['reports'],
        isLinkAttached: map['isLinkAttached'],
        link: map['link'],
        isImage: map['isImage'],
        imageUrl: map['imageUrl'],
        isPoll: map['isPoll'],
        pollData: PollModel.fromMap(map['pollData']),
        gifUrl: map['gifUrl'],
        isGif: map['isGif']);
  }

  String toJson() => json.encode(toMap());

  factory Post.fromJson(String source) => Post.fromMap(json.decode(source));

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is Post && other.id == id;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        author.hashCode ^
        authorImage.hashCode ^
        postedOn.hashCode ^
        text.hashCode ^
        likes.hashCode ^
        comments.hashCode ^
        reports.hashCode ^
        isLinkAttached.hashCode ^
        link.hashCode ^
        isImage.hashCode ^
        imageUrl.hashCode ^
        isPoll.hashCode ^
        pollData.hashCode ^
        isGif.hashCode ^
        gifUrl.hashCode;
  }
}
