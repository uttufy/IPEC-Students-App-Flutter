import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:ipecstudentsapp/widgets/loading_widget.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:http/http.dart' as http;
import '../../widgets/simple_appbar.dart';

class AboutScreen extends StatelessWidget {
  static const String ROUTE = "/about";

  @override
  Widget build(BuildContext context) {
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
              child: FutureBuilder<String>(
                future: loadGistFileFromRemote(),
                builder:
                    (BuildContext context, AsyncSnapshot<String> snapshot) {
                  print(snapshot.connectionState.toString());
                  if (snapshot.connectionState == ConnectionState.done) {
                    print(snapshot.hasData);
                    print(snapshot.hasError);
                    if (snapshot.hasData)
                      return Markdown(
                        padding: const EdgeInsets.all(40),
                        data: snapshot.data!,
                        selectable: true,
                        imageDirectory: 'https://raw.githubusercontent.com',
                        onTapLink: (String text, String? href, String title) =>
                            linkOnTapHandler(context, text, href ?? "", title),
                      );
                    else if (snapshot.hasError)
                      return Center(
                          child: Padding(
                        padding: const EdgeInsets.all(30.0),
                        child: Text(
                          "Something went wrong! Please check your internet connectivity. ERROR : ${snapshot.error.toString()}",
                          textAlign: TextAlign.center,
                        ),
                      ));
                    else
                      return Container();
                  } else {
                    return const LoadingWidget();
                  }
                },
              ),
            )
          ],
        ),
      ),
    );
  }

  Future<String> loadGistFileFromRemote() async {
    final http.Response response = await http.get(Uri.parse(
        'https://gist.githubusercontent.com/uttusharma/8ffa1b2040a907279cd35ef79038c223/raw'));
    // print(response.body);
    return response.body;
  }

// Handle the link. The [href] in the callback contains information
// from the link. The url_launcher package or other similar package
// can be used to execute the link.
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
