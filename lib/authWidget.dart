import 'package:flutter/cupertino.dart';
import 'package:playlist_app/apiClient.dart';
import 'package:playlist_app/playlistAppHome.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:flutter/material.dart';
import 'dart:async';

import 'package:playlist_app/constants.dart' as Constants;

class AuthWidget extends StatelessWidget {
  final Completer<WebViewController> _controller =
      Completer<WebViewController>();

  final ApiClient _client = ApiClient();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Auth'),
        toolbarHeight: 12.0,
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
              handleCodeRedirect(context, request);
            }

            return NavigationDecision.navigate;
          },
        );
      }),
    );
  }

  Future<void> handleCodeRedirect(
      BuildContext context, NavigationRequest request) async {
    String authCode = request.url.split('=')[1].split('&')[0];
    Constants.accessToken = await _client.getAccessToken(authCode);

    Navigator.push(
        context, MaterialPageRoute(builder: (context) => PlaylistAppHome()));
  }
}
