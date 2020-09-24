import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:playlist_app/models/spotifyTracksModel.dart';

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
        padding: EdgeInsets.all(14.0),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(track.name),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(_getAllArtists(track.artists)),
              Text(_getFormattedDuration(track.durationMs)),
            ],
          ),
        ]));
  }

  String _getAllArtists(List<Artists> artists) {
    String res = "";
    for (var a in artists) {
      res += a.name;
      if (artists.indexOf(a) != artists.length - 1) res += ", ";
    }

    return res;
  }

  String _getFormattedDuration(int durationMs) {
    String seconds = ((durationMs % 60)).toString();
    String res = '${(durationMs ~/ 1000 ~/ 60)}:';

    return seconds.length > 1 ? res + seconds : res + "0" + seconds;
  }
}
