import 'dart:convert';

class PollModel {
  final String? creator;
  Map<dynamic, dynamic>? userWhoVoted;
  List<double?> numberOfVotes;
  List<String> optionLabel;

  PollModel(
      {required this.creator,
      this.userWhoVoted = const {},
      this.numberOfVotes = const [0.0, 0.0],
      required this.optionLabel});

  Map<String, dynamic> toMap() {
    return {
      'creator': creator,
      'userWhoVoted': userWhoVoted,
      'numberOfVotes': numberOfVotes,
      'optionLabel': optionLabel,
    };
  }

  factory PollModel.fromMap(Map<dynamic, dynamic> map) {
    List<double?> temp = [];
    (map['numberOfVotes'] as List).forEach((element) {
      temp.add(element.toDouble());
    });
    return PollModel(
      creator: map['creator'],
      userWhoVoted: map['userWhoVoted'] as Map<dynamic, dynamic>?,
      numberOfVotes: temp,
      optionLabel: List<String>.from(map['optionLabel']),
    );
  }

  String toJson() => json.encode(toMap());

  factory PollModel.fromJson(String source) =>
      PollModel.fromMap(json.decode(source));
}
