import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:playlist_app/playingWidget.dart';
import 'package:playlist_app/savedTracksWidget.dart';

class PlaylistAppHome extends StatefulWidget {

  @override
  _PlaylistAppHomeState createState() => _PlaylistAppHomeState();
}

class _PlaylistAppHomeState extends State<PlaylistAppHome> {
  int _selectedItem = 0;

  static List<Widget> _widgetOptions;

  _PlaylistAppHomeState() {

    _widgetOptions = [
      SavedTracksWidget(),
      PlayingWidget(),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: BottomNavigationBar(
        items: [
          BottomNavigationBarItem(
            title: Text('Tracklist'),
            icon: Icon(Icons.surround_sound),
          ),
          BottomNavigationBarItem(
            title: Text('Now playing'),
            icon: Icon(Icons.play_arrow),
          ),
        ],
        onTap: (index) => _handleNavigationItemClick(index),
        currentIndex: _selectedItem,
      ),
      body: _widgetOptions.elementAt(_selectedItem),
    );
  }

  void _handleNavigationItemClick(int itemIndex) {
    setState(() {
      _selectedItem = itemIndex;
    });
  }

  void updatePlaybackInfo() {}
}
