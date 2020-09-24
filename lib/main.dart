import 'package:flutter/material.dart';
import 'spotifyAuthWidget.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: SpotifyAuthWidget(),//MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}