import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:http/http.dart' as http;
import '../../theme/style.dart';
import '../../widgets/simple_appbar.dart';
import 'about_widget.dart';

class AboutScreen extends StatelessWidget {
  static const String ROUTE = "/about";
  _launchURL(String url) async {
    print(url);
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = AdaptiveTheme.of(context).mode == AdaptiveThemeMode.dark;
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            SimpleAppBar(
              onBack: () {
                Navigator.popUntil(context, (route) => route.isFirst);
              },
              title: "About",
            ),
            Expanded(
              child: SingleChildScrollView(
                // physics: BouncingScrollPhysics(),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 30.0, vertical: 30),
                      child: Text(
                        '🔨 Developers',
                        style: Theme.of(context).textTheme.headline5,
                      ),
                    ),
                    SingleChildScrollView(
                      physics: BouncingScrollPhysics(),
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: [
                          kHighWidthPadding,
                          aboutWidget(
                              context,
                              'https://avatars.githubusercontent.com/u/16814257?v=4',
                              'UTTU',
                              'Utkarsh Sharma', () {
                            _launchURL('https://www.instagram.com/uttufy');
                          }, () {
                            _launchURL('https://github.com/uttusharma');
                          }, isDark),
                          kHighWidthPadding,
                          aboutWidget(
                              context,
                              'https://avatars.githubusercontent.com/u/60356611?v=4',
                              'Raks',
                              'Rakshit Raj Singh', () {
                            _launchURL(
                                'https://www.instagram.com/rakshit.raj.singh/');
                          }, () {
                            _launchURL('https://github.com/RakshitRajSingh17');
                          }, isDark),
                          kHighWidthPadding,
                          aboutWidget(
                              context,
                              'https://avatars.githubusercontent.com/u/82357006?v=4',
                              'Ridhi',
                              'Ridhi Rawat', () {
                            _launchURL('https://www.instagram.com/ri_aina2411');
                          }, () {
                            _launchURL('https://github.com/ridhi-7029hash');
                          }, isDark),
                          kHighWidthPadding,
                        ],
                      ),
                    ),

                    Padding(
                      padding: const EdgeInsets.all(30.0),
                      child: Text(
                        "Tap image to connect on instagram and name to connect on github",
                        overflow: TextOverflow.clip,
                        textAlign: TextAlign.center,
                        style: Theme.of(context).textTheme.bodyText1!.copyWith(
                              color: isDark ? Colors.grey : Colors.grey,
                            ),
                      ),
                    ),
                    // kMedPadding,
                    _loadMdFile(),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _loadMdFile() {
    return FutureBuilder<String>(
      future: loadGistFileFromRemote(),
      builder: (BuildContext context, AsyncSnapshot<String> snapshot) {
        // print(snapshot.connectionState.toString());
        if (snapshot.connectionState == ConnectionState.done) {
          // print(snapshot.hasData);
          // print(snapshot.hasError);
          if (snapshot.hasData)
            return Markdown(
              padding: const EdgeInsets.all(30),
              shrinkWrap: true,
              data: snapshot.data!,
              selectable: true,
              physics: NeverScrollableScrollPhysics(),
              // imageDirectory: 'https://raw.githubusercontent.com',
              onTapLink: (String text, String? href, String title) =>
                  linkOnTapHandler(context, text, href ?? "", title),
            );
          else if (snapshot.hasError)
            return Padding(
              padding: const EdgeInsets.all(30.0),
              child: Text(
                "Something went wrong! Please check your internet connectivity. ERROR : ${snapshot.error.toString()}",
                textAlign: TextAlign.center,
              ),
            );
          else
            return Container();
        } else {
          return Center(
            child: SizedBox(
                width: 200,
                height: 200,
                child: const CircularProgressIndicator()),
          );
        }
      },
    );
  }

  Future<String> loadGistFileFromRemote() async {
    final http.Response response = await http.get(Uri.parse(
        // 'https://gist.githubusercontent.com/uttusharma/8ffa1b2040a907279cd35ef79038c223/raw/ebce8dff7d6b3da481abfe0cc6d982a8fd02e6e0/IPEC-APP-INFO-BOARD'));
        'https://gist.githubusercontent.com/uttusharma/8ffa1b2040a907279cd35ef79038c223/raw'));
    print(response.body);
    return response.body;
  }

  Future<void> linkOnTapHandler(
    BuildContext context,
    String text,
    String url,
    String title,
  ) async {
    print(url);
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }
}
