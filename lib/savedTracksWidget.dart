import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:playlist_app/blocs/models/savedTrack.dart';
import 'package:playlist_app/spotifyApi/apiClient.dart';
import 'package:playlist_app/constants.dart' as Constants;

class SavedTracksWidget extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _SavedTrackWidgetState();
}

class _SavedTrackWidgetState extends State<SavedTracksWidget> {
  final ApiClient _client = ApiClient();

  Future<List<SavedTrack>> _cachedTracks;

  _SavedTrackWidgetState() {
    _cachedTracks = _client.getSavedTracks(Constants.accessToken, null);
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _cachedTracks,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return Scaffold(
            body: SafeArea(
              child: ListView.builder(
                itemCount: snapshot.data.length,
                itemBuilder: (context, index) =>
                    TrackListItem(snapshot.data[index]),
              ),
            ),
          );
        } else {
          return Center(
            child: CircularProgressIndicator(),
          );
        }
      },
    );
  }
}

class TrackListItem extends StatelessWidget {
  final SavedTrack track;

  TrackListItem(this.track);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(track.name),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(track.formattedArtists),
              Text(track.formattedDuration),
            ],
          ),
        ],
      ),
    );
  }
}
