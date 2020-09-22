import 'package:flutter/cupertino.dart';
import 'package:playlist_app/spotifyClient.dart';
import 'package:playlist_app/spotifyTracksWidget.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:flutter/material.dart';
import 'dart:async';

import 'package:playlist_app/constants.dart' as Constants;
import 'package:playlist_app/savedTracksModel.dart';

class SpotifyAuthWidget extends StatefulWidget {
  @override
  _SpotifyAuthWidgetState createState() => _SpotifyAuthWidgetState();
}

class _SpotifyAuthWidgetState extends State<SpotifyAuthWidget> {
  final Completer<WebViewController> _controller =
      Completer<WebViewController>();

  String _authCode;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Auth'),
      ),
      body: Builder(builder: (BuildContext context) {
        return WebView(
          initialUrl: Constants.AUTH_URL,
          javascriptMode: JavascriptMode.unrestricted,
          onWebViewCreated: (WebViewController webViewController) {
            _controller.complete(webViewController);
          },
          navigationDelegate: (NavigationRequest request) {
            if (request.url.startsWith('https://blank.org')) {
              handleCodeRedirect(request);
            }

            return NavigationDecision.navigate;
          },
        );
      }),
    );
  }

  Future<void> handleCodeRedirect(NavigationRequest request) async {
    _authCode = request.url.split('=')[1].split('&')[0];
    var spotifyClient = SpotifyClient();

    String token = await spotifyClient.getAccessToken(_authCode);

    List<Track> trackList = await spotifyClient.getSavedTracks(token, null);

    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => SpotifyTracksWidget(trackList)));
  }
}
