import 'package:playlist_app/blocs/trackInfoFormatter.dart';
import 'package:playlist_app/spotifyApi/models/currentPlaybackModel.dart'
    as Resp;

class Playback {
  final bool isPlaying;
  final String album;
  final String albumCoverUrl;
  final String formattedArtists;
  final String name;
  final String duration;
  final String progress;
  final String currentDevice;
  final String id;
  final int durationMs;
  final int progressMs;
  final String deviceId;

  final TrackInfoFormatter formatter = TrackInfoFormatter();

  Playback({
    this.isPlaying,
    this.album,
    this.albumCoverUrl,
    this.formattedArtists,
    this.currentDevice,
    this.duration,
    this.progress,
    this.id,
    this.name,
    this.durationMs,
    this.progressMs,
    this.deviceId,
  });

  Playback fromResponse(Resp.CurrentPlaybackModel resp) => new Playback(
      isPlaying: resp.isPlaying,
      album: resp.item.album.name,
      albumCoverUrl: resp.item.album.images[0].url,
      formattedArtists: formatter.getFormattedArtistsFromPlayback(resp.item.artists),
      currentDevice: resp.device.name,
      duration: formatter.getFormattedDuration(resp.item.durationMs),
      progress: formatter.getRemainingTime(resp.progressMs, resp.item.durationMs),
      id: resp.item.id,
      name: resp.item.name,
      durationMs: resp.item.durationMs,
      progressMs: resp.progressMs,
      deviceId: resp.device.id);

  Playback getEmpty() => new Playback(
      album: "Nothing is playing!",
      albumCoverUrl: null,
      currentDevice: "Nothing is playing!",
      deviceId: "Nothing is playing!",
      duration: "0",
      durationMs: 10000,
      formattedArtists: "Nothing is playing!",
      id: "Nothing is playing!",
      isPlaying: false,
      name: "Nothing is playing!",
      progress: "0",
      progressMs: 0);
}
