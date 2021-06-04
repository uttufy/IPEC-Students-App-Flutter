import 'dart:convert';

import 'package:flutter/foundation.dart';

import 'package:ipecstudentsapp/data/model/hangout/PollModel.dart';

class Post {
  final String id;
  final String author;
  final String authorImage;
  final String authorId;
  final String authorYr;
  final String authorSection;
  final double postedOn;
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
  Post({
    @required this.id,
    @required this.author,
    @required this.authorImage,
    @required this.authorId,
    @required this.authorYr,
    @required this.authorSection,
    @required this.postedOn,
    @required this.text,
    @required this.likes,
    @required this.comments,
    @required this.reports,
    @required this.isLinkAttached,
    @required this.link,
    @required this.isImage,
    @required this.imageUrl,
    @required this.isPoll,
    @required this.pollData,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'author': author,
      'authorImage': authorImage,
      'authorId': authorId,
      'authorYr': authorYr,
      'authorSection': authorSection,
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
    };
  }

  factory Post.fromMap(Map<String, dynamic> map) {
    return Post(
      id: map['id'],
      author: map['author'],
      authorImage: map['authorImage'],
      authorId: map['authorId'],
      authorYr: map['authorYr'],
      authorSection: map['authorSection'],
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
    );
  }

  String toJson() => json.encode(toMap());

  factory Post.fromJson(String source) => Post.fromMap(json.decode(source));

  @override
  String toString() {
    return 'Post(id: $id, author: $author, authorImage: $authorImage, authorId: $authorId, authorYr: $authorYr, authorSection: $authorSection, postedOn: $postedOn, text: $text, likes: $likes, comments: $comments, reports: $reports, isLinkAttached: $isLinkAttached, link: $link, isImage: $isImage, imageUrl: $imageUrl, isPoll: $isPoll, pollData: $pollData)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is Post &&
        other.id == id &&
        other.author == author &&
        other.authorImage == authorImage &&
        other.authorId == authorId &&
        other.authorYr == authorYr &&
        other.authorSection == authorSection &&
        other.postedOn == postedOn &&
        other.text == text &&
        other.likes == likes &&
        other.comments == comments &&
        other.reports == reports &&
        other.isLinkAttached == isLinkAttached &&
        other.link == link &&
        other.isImage == isImage &&
        other.imageUrl == imageUrl &&
        other.isPoll == isPoll &&
        other.pollData == pollData;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        author.hashCode ^
        authorImage.hashCode ^
        authorId.hashCode ^
        authorYr.hashCode ^
        authorSection.hashCode ^
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
        pollData.hashCode;
  }
}
