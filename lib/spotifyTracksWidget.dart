import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:playlist_app/savedTracksModel.dart';

class SpotifyTracksWidget extends StatefulWidget {
  final List<Track> tracks;

  SpotifyTracksWidget(this.tracks);

  @override
  _SpotifyTracksWidgetState createState() => _SpotifyTracksWidgetState(tracks);
}

class _SpotifyTracksWidgetState extends State<SpotifyTracksWidget> {
  _SpotifyTracksWidgetState(List<Track> tracks) {
    this._tracks = tracks;
  }

  List<Track> _tracks;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('TrackList'),
      ),
      body: ListView.builder(
        itemCount: _tracks.length,
        itemBuilder: (context, index) {
          return TrackListItem(_tracks[index]);
        },
      ),
    );
  }
}

class TrackListItem extends StatelessWidget {
  final Track track;

  TrackListItem(this.track);

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: EdgeInsets.all(16.0),
        child: Row(children: [
          Column(crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(track.name), 
              Text(track.id),
              ],
          ),
        ]));
  }
}
