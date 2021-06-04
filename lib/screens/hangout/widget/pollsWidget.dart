import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:flutter/material.dart';
import 'package:ipecstudentsapp/data/model/hangout/PollModel.dart';
import 'package:ipecstudentsapp/theme/colors.dart';
import 'package:polls/polls.dart';

class PollView extends StatefulWidget {
  final PollModel poll;
  final String user;

  const PollView({Key key, @required this.poll, this.user}) : super(key: key);
  @override
  _PollViewState createState() => _PollViewState();
}

class _PollViewState extends State<PollView> {
  PollModel poll;

  @override
  void initState() {
    super.initState();
    poll = widget.poll;
  }

  @override
  Widget build(BuildContext context) {
    final isDark = AdaptiveTheme.of(context).mode == AdaptiveThemeMode.dark;

    return Container(
      child: Polls(
        children: [
          // This cannot be less than 2, else will throw an exception
          Polls.options(
              title: poll.optionLabel.first, value: poll.numberOfVotes.first),
          Polls.options(
              title: poll.optionLabel[1], value: poll.numberOfVotes[1]),
        ],
        question: Text(''),
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
        },
      ),
    );
  }
}
