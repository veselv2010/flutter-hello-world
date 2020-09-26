import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:playlist_app/models/savedTracksModel.dart';
import 'package:playlist_app/apiClient.dart';
import 'package:playlist_app/constants.dart' as Constants;

class SavedTracksWidget extends StatelessWidget {
  List<Track> _savedTracks;
  ApiClient _client;

  SavedTracksWidget(ApiClient spotifyClient) {
    this._client = spotifyClient;
    _init();
  }

  Future _init() async {
    this._savedTracks =
        await _client.getSavedTracks(Constants.accessToken, null);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView.builder(
        itemCount: _savedTracks.length,
        itemBuilder: (context, index) {
          return TrackListItem(_savedTracks[index]);
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
              Text(ApiClient.getFormattedDuration(track.durationMs)),
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
}
