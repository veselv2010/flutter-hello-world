import 'package:http/http.dart' as http;
import 'package:playlist_app/blocs/models/savedTrack.dart';
import 'package:playlist_app/blocs/trackInfoFormatter.dart';
import 'package:playlist_app/constants.dart' as Constants;
import 'dart:convert';
import 'package:playlist_app/spotifyApi/models/savedTracksModel.dart';
import 'package:playlist_app/spotifyApi/models/currentPlaybackModel.dart'
    as Playback;

class ApiClient {
  List<Track> _cachedTracks;
  http.Client _http;
  ApiClient({httpClient}) {
    _cachedTracks = List();
    _http = httpClient ?? http.Client;
  }

  Future<String> getAccessToken(String code) async {
    var resp = await _http.post(Constants.ACCESS_TOKEN_ENDPOINT, body: {
      'grant_type': 'authorization_code',
      'code': code,
      'redirect_uri': Constants.REDIRECT_URI
    }, headers: {
      'Authorization': 'Basic ${getBase64Id()}'
    });

    Map<String, dynamic> map = jsonDecode(resp.body);

    return map['access_token'];
  }

  //TODO: разнести на два метода, уничтожить рекурсию
  Future<List<SavedTrack>> getSavedTracks(
      String accessToken, String url) async {
    url = url == null
        ? Constants.SAVED_TRACKS_ENDPOINT + "?limit=50" + "&offset=0"
        : url;

    var resp = await _http.get(url, headers: getAuthHeader(accessToken));

    if (resp.statusCode == 204) return null;

    Map<String, dynamic> map = jsonDecode(resp.body);
    var model = SavedTracksModel.fromJson(map);

    model.items.forEach((element) => _cachedTracks.add(element.track));

    String nextUrl = model.next;

    if (nextUrl != null) await getSavedTracks(accessToken, nextUrl);

    var formatter = TrackInfoFormatter();

    return formatter.fromRespList(_cachedTracks);
  }

  Future<Playback.CurrentPlaybackModel> getCurrentPlaybackInfo(
      String accessToken) async {
    var resp = await _http.get(Constants.CURRENT_PLAYBACK_ENDPOINT,
        headers: getAuthHeader(accessToken));

    //nothing is playing
    if (resp.statusCode == 204) return null;

    Map<String, dynamic> map = jsonDecode(resp.body);

    return Playback.CurrentPlaybackModel.fromJson(map);
  }

  Map<String, String> getAuthHeader(String accessToken) {
    return {'Authorization': 'Bearer $accessToken'};
  }

  String getBase64Id() {
    var res = "${Constants.CLIENT_ID}:197776909380429dac9d7263317b6811";
    var bytes = utf8.encode(res);

    return base64.encode(bytes);
  }

  Future<void> nextTrack(String accessToken, {String deviceId}) async {
    String url = deviceId == null || deviceId == ""
        ? Constants.PLAYER_NEXT_ENDPOINT
        : Constants.PLAYER_NEXT_ENDPOINT + "?device_id=$deviceId";

    await _http.post(url, headers: getAuthHeader(accessToken));
  }

  Future<void> prevTrack(String accessToken, {String deviceId}) async {
    String url = deviceId == null || deviceId == ""
        ? Constants.PLAYER_PREV_ENDPOINT
        : Constants.PLAYER_PREV_ENDPOINT + "?device_id=$deviceId";

    await _http.post(url, headers: getAuthHeader(accessToken));
  }

  Future<void> pausePlayback(String accessToken, {String deviceId}) async {
    String url = deviceId == null || deviceId == ""
        ? Constants.PLAYER_PAUSE_ENDPOINT
        : Constants.PLAYER_PAUSE_ENDPOINT + "?device_id=$deviceId";

    await _http.put(url, headers: getAuthHeader(accessToken));
  }

  Future<void> resumePlayback(String accessToken, String positionMs,
      {String deviceId}) async {
    String url = deviceId == null || deviceId == ""
        ? Constants.PLAYER_RESUME_ENDPOINT
        : Constants.PLAYER_RESUME_ENDPOINT + "?device_id=$deviceId";

    await _http.put(url,
        headers: getAuthHeader(accessToken),
        body: '{"position_ms": $positionMs}');
  }
}
