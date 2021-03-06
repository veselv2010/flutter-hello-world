import 'dart:async';

import 'package:playlist_app/blocs/models/playback.dart';
import 'package:playlist_app/blocs/playbackEvents.dart';
import 'package:playlist_app/spotifyApi/apiClient.dart';
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

    _playbackEventController.stream.listen(_eventToState);
    playbackEventSink.add(PlaybackUpdateEvent());

    Timer.periodic(Duration(seconds: 1),
        (timer) => playbackEventSink.add(PlaybackUpdateEvent()));
  }

  void _eventToState(PlaybackEvent event) async {
    if (event is NextTrackEvent) {
      await client.nextTrack(Constants.accessToken);
    } else if (event is PrevTrackEvent) {
      await client.prevTrack(Constants.accessToken);
    } else if (event is ChangeIsPlayingStateEvent) {
      await _handleStateEvent();
    } else if (event is PlaybackUpdateEvent) {
      await _handlePlaybackUpdateEvent();
    } else {
      throw Exception("there is no such event");
    }
    _inPlayback.add(_playback);
  }

  void dispose() {
    _playbackStateController.close();
    _playbackEventController.close();
  }

  Future<void> _handleStateEvent() async {
    if (_playback.isPlaying)
      await client.pausePlayback(Constants.accessToken);
    else
      await client.resumePlayback(
          Constants.accessToken, _playback.progressMs.toString());
  }

  Future<void> _handlePlaybackUpdateEvent() async {
    var resp = await client.getCurrentPlaybackInfo(Constants.accessToken);

    _playback =
        resp == null ? _playback.getEmpty() : _playback.fromResponse(resp);
  }
}
