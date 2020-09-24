import 'package:flutter/material.dart';
import 'package:playlist_app/models/spotifyTracksModel.dart';
import 'package:flutter/widgets.dart';
import 'package:playlist_app/spotifyTracksWidget.dart';

class SpotifyTracksPage extends StatefulWidget {
  final List<Track> tracks;

  SpotifyTracksPage(this.tracks);

  @override
  _SpotifyTracksPageState createState() => _SpotifyTracksPageState(tracks);
}

class _SpotifyTracksPageState extends State<SpotifyTracksPage> {
  var _tracks;

  _SpotifyTracksPageState(List<Track> tracks) {
    this._tracks = tracks;
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
      ),
      body: SpotifyTracksWidget(_tracks),
    );
  }
}
