import 'dart:async';

import 'package:playlist_app/blocs/models/savedTrack.dart';
import 'package:playlist_app/blocs/savedTracksEvents.dart';
import 'package:playlist_app/blocs/trackInfoFormatter.dart';
import 'package:playlist_app/spotifyApi/apiClient.dart';
import 'package:playlist_app/constants.dart' as Constants;
import 'package:playlist_app/spotifyApi/models/savedTracksModel.dart';

class SavedTracksBloc {
  List<SavedTrack> _savedTracks;

  final ApiClient client = ApiClient();
  final TrackInfoFormatter formatter = TrackInfoFormatter();

  final _savedTracksStateController = StreamController<List<SavedTrack>>();

  StreamSink<List<SavedTrack>> get _inSavedTracks =>
      _savedTracksStateController.sink;

  Stream<List<SavedTrack>> get savedTracks =>
      _savedTracksStateController.stream;

  final _savedTracksEventController = StreamController<SavedTracksEvent>();

  Sink<SavedTracksEvent> get savedTracksEventSink =>
      _savedTracksEventController.sink;

  SavedTracksBloc() {
    _savedTracks = List<SavedTrack>();

    _savedTracksEventController.stream.listen(_eventToState);
  }

  void _eventToState(SavedTracksEvent event) async {
    if (event is SavedTracksInitialized) {
      var resp = await client.getSavedTracks(Constants.accessToken, null);

      _savedTracks = _fromRespList(resp);
    }

    _inSavedTracks.add(_savedTracks);
  }

  void dispose() {
    _savedTracksStateController.close();
    _savedTracksEventController.close();
  }

  List<SavedTrack> _fromRespList(List<Track> tracks) {
    var list = List<SavedTrack>();
    tracks.forEach(
      (element) => list.add(
        new SavedTrack(
            formattedArtists:
                formatter.getFormattedArtistsFromSaved(element.artists),
            formattedDuration:
                formatter.getFormattedDuration(element.durationMs),
            id: element.id,
            name: element.name),
      ),
    );

    return list;
  }
}
