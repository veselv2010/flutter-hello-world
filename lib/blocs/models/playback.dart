import 'package:playlist_app/models/currentPlaybackModel.dart' as Resp;

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

  Playback(
      {this.isPlaying,
      this.album,
      this.albumCoverUrl,
      this.formattedArtists,
      this.currentDevice,
      this.duration,
      this.progress,
      this.id,
      this.name});

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Playback && id == other.id && progress == other.progress;

  Playback fromResponse(Resp.CurrentPlaybackModel resp) => new Playback(
      isPlaying: resp.isPlaying,
      album: resp.item.album.name,
      albumCoverUrl: resp.item.album.images[0].url,
      formattedArtists: _getFormattedArtists(resp.item.artists),
      currentDevice: resp.device.name,
      duration: _getFormattedDuration(resp.item.durationMs),
      progress: _getRemainingTime(resp.progressMs, resp.item.durationMs),
      id: resp.item.id,
      name: resp.item.name);

  String _getFormattedArtists(List<Resp.Artists> artists){
        String res = "";
    for (var a in artists) {
      res += a.name;
      if (artists.indexOf(a) != artists.length - 1) res += ", ";
    }

    return res;
  }

  String _getRemainingTime(int currentMs, int durationMs) {
    String seconds = (((durationMs - currentMs) % 60)).toString();
    String res = '-${(currentMs ~/ 1000 ~/ 60)}:';

    return seconds.length > 1 ? res + seconds : res + "0" + seconds;
  }

  String _getFormattedDuration(int durationMs) {
    String seconds = ((durationMs % 60)).toString();
    String res = '${(durationMs ~/ 1000 ~/ 60)}:';

    return seconds.length > 1 ? res + seconds : res + "0" + seconds;
  }
}
