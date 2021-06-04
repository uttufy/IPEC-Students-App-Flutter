import 'dart:convert';

import 'package:flutter/foundation.dart';

class PollModel {
  final String creator;
  Map userWhoVoted;
  List<double> numberOfVotes;
  List<String> optionLabel;

  PollModel(
      {@required this.creator,
      @required this.userWhoVoted,
      @required this.numberOfVotes,
      @required this.optionLabel});

  Map<String, dynamic> toMap() {
    return {
      'creator': creator,
      'userWhoVoted': userWhoVoted,
      'numberOfVotes': numberOfVotes,
      'optionLabel': optionLabel,
    };
  }

  factory PollModel.fromMap(Map<String, dynamic> map) {
    return PollModel(
      creator: map['creator'],
      userWhoVoted: map['userWhoVoted'],
      numberOfVotes: List<double>.from(map['numberOfVotes']),
      optionLabel: List<String>.from(map['optionLabel']),
    );
  }

  String toJson() => json.encode(toMap());

  factory PollModel.fromJson(String source) =>
      PollModel.fromMap(json.decode(source));
}
