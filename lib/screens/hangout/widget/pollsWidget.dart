import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:polls/polls.dart';

import '../../../data/model/hangout/PollModel.dart';
import '../../../theme/colors.dart';

class PollView extends StatefulWidget {
  final PollModel poll;
  final String user;
  final String postId;
  final isCreate;
  const PollView(
      {Key key,
      @required this.poll,
      this.postId,
      @required this.user,
      this.isCreate = false})
      : super(key: key);
  @override
  _PollViewState createState() => _PollViewState();
}

class _PollViewState extends State<PollView> {
  PollModel poll;

  final firebaseRef =
      FirebaseDatabase.instance.reference().child('hangout/pings');
  @override
  void initState() {
    super.initState();
    poll = widget.poll;
    if (poll.userWhoVoted == null) poll.userWhoVoted = Map<String, dynamic>();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = AdaptiveTheme.of(context).mode == AdaptiveThemeMode.dark;

    if (widget.isCreate)
      return Polls.creator(
        children: [
          // This cannot be less than 2, else will throw an exception
          Polls.options(
              title: poll.optionLabel.first, value: poll.numberOfVotes.first),
          Polls.options(
              title: poll.optionLabel[1], value: poll.numberOfVotes[1]),
        ],
        question: Text(''),
        onVoteBackgroundColor: Colors.blue,
        leadingBackgroundColor: Colors.blue,
        backgroundColor: isDark ? Colors.black54 : Colors.white,
      );
    else
      return Polls(
        children: [
          // This cannot be less than 2, else will throw an exception
          Polls.options(
              title: poll.optionLabel.first, value: poll.numberOfVotes.first),
          Polls.options(
              title: poll.optionLabel[1], value: poll.numberOfVotes[1]),
        ],
        question: Text(
          '',
          style: TextStyle(fontSize: 1),
        ),
        currentUser: widget.user,
        creatorID: poll.creator,
        voteData: poll.userWhoVoted,
        userChoice: poll.userWhoVoted[widget.user],
        onVoteBackgroundColor: Colors.blue,
        leadingBackgroundColor: Colors.blue,
        outlineColor: kBlue,
        backgroundColor: isDark ? Colors.black54 : Colors.white,
        onVote: (choice) {
          print(choice);
          setState(() {
            poll.userWhoVoted[widget.user] = choice;
          });
          if (choice == 1) {
            setState(() {
              poll.numberOfVotes.first += 1.0;
            });
          }
          if (choice == 2) {
            setState(() {
              poll.numberOfVotes[1] += 1.0;
            });
          }
          firebaseRef.child(widget.postId).update({'pollData': poll.toMap()});
        },
      );
  }
}
