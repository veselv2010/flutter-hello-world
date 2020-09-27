import 'dart:async';

import 'package:playlist_app/blocs/models/playback.dart';
import 'package:playlist_app/blocs/playbackEvents.dart';
import 'package:playlist_app/apiClient.dart';
import 'package:playlist_app/constants.dart' as Constants;

class PlaybackBloc {
  Playback _playback;
  final ApiClient client = ApiClient();
  final _playbackStateController = StreamController<Playback>();

  StreamSink<Playback> get _inPlayback => _playbackStateController.sink;
  Stream<Playback> get playback => _playbackStateController.stream;

  final _playbackEventController = StreamController<PlaybackEvent>();

  Sink<PlaybackEvent> get playbackEventSink => _playbackEventController.sink;

  PlaybackBloc() {
    _playback = Playback();
    playbackEventSink.add(PlaybackUpdateEvent());
    
    _playbackEventController.stream.listen(_eventToState);

    Timer.periodic(Duration(seconds: 1),
        (timer) => playbackEventSink.add(PlaybackUpdateEvent()));
  }

  void _eventToState(PlaybackEvent event) async {
    if (event is NextTrackEvent) {
      //TODO
    } else if (event is PrevTrackEvent) {
      //TODO
    } else if (event is ChangeIsPlayingStateEvent) {
      //TODO
    } else if (event is PlaybackUpdateEvent) {
      _playback = _playback.fromResponse(
          await client.getCurrentPlaybackInfo(Constants.accessToken));
    } else {
      throw Exception("there is no such event");
    }
    _inPlayback.add(_playback);
  }

  void dispose() {
    _playbackStateController.close();
    _playbackEventController.close();
  }
}
