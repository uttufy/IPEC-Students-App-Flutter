import 'dart:convert';
import 'hangUser.dart';

class CommentModel {
  String? commentId;
  final String? id;
  final Huser author;
  final String? authorImage;
  final int? postedOn;
  final String? text;
  int? reports;
  final bool? isGif;
  final String? gifUrl;
  CommentModel({
    this.commentId = "",
    required this.id,
    required this.author,
    required this.authorImage,
    required this.postedOn,
    required this.text,
    required this.reports,
    required this.isGif,
    required this.gifUrl,
  });

  Map<String, dynamic> toMap() {
    return {
      'commentId': commentId,
      'id': id,
      'author': author.toMap(),
      'authorImage': authorImage,
      'postedOn': postedOn,
      'text': text,
      'reports': reports,
      'isGif': isGif,
      'gifUrl': gifUrl,
    };
  }

  factory CommentModel.fromMap(Map<dynamic, dynamic> map) {
    return CommentModel(
      commentId: map['commentId'],
      id: map['id'],
      author: Huser.fromMap(map['author']),
      authorImage: map['authorImage'],
      postedOn: map['postedOn'],
      text: map['text'],
      reports: map['reports'],
      isGif: map['isGif'],
      gifUrl: map['gifUrl'],
    );
  }

  factory CommentModel.fromSnapshot(data, indivisualKey) {
    CommentModel commentItem = new CommentModel(
        commentId: indivisualKey,
        id: data[indivisualKey]['id'],
        author: Huser.fromMap(data[indivisualKey]['author']),
        authorImage: data[indivisualKey]['authorImage'],
        postedOn: data[indivisualKey]['postedOn'],
        text: data[indivisualKey]['text'],
        reports: data[indivisualKey]['reports'],
        gifUrl: data[indivisualKey]['gifUrl'],
        isGif: data[indivisualKey]['isGif']);
    return commentItem;
  }

  String toJson() => json.encode(toMap());

  factory CommentModel.fromJson(String source) =>
      CommentModel.fromMap(json.decode(source));

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is CommentModel && other.id == id;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        author.hashCode ^
        authorImage.hashCode ^
        postedOn.hashCode ^
        text.hashCode ^
        reports.hashCode ^
        isGif.hashCode ^
        gifUrl.hashCode;
  }
}
