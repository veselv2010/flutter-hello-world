import 'package:playlist_app/spotifyApi/models/currentPlaybackModel.dart'
    as PlaybackResp;
import 'package:playlist_app/spotifyApi/models/savedTracksModel.dart'
    as SavedTracksResp;

class TrackInfoFormatter {
  //TODO: generics
  String getFormattedArtistsFromPlayback(List<PlaybackResp.Artists> artists) {
    String res = "";
    for (var a in artists) {
      res += a.name;
      if (artists.indexOf(a) != artists.length - 1) res += ", ";
    }

    return res;
  }

  String getFormattedArtistsFromSaved(List<SavedTracksResp.Artists> artists) {
    String res = "";
    for (var a in artists) {
      res += a.name;
      if (artists.indexOf(a) != artists.length - 1) res += ", ";
    }

    return res;
  }

  String getRemainingTime(int currentMs, int durationMs) {
    String seconds = ((durationMs - currentMs) ~/ 1000 % 60).toString();
    String minutes =
        '-' + ((durationMs - currentMs) ~/ 1000 ~/ 60).toString() + ':';

    return seconds.length > 1 ? minutes + seconds : minutes + "0" + seconds;
  }

  String getFormattedDuration(int durationMs) {
    String seconds = (durationMs ~/ 1000 % 60).toString();
    String minutes = (durationMs ~/ 1000 ~/ 60).toString() + ':';

    return seconds.length > 1 ? minutes + seconds : minutes + "0" + seconds;
  }
}
