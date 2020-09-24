import 'package:http/http.dart' as http;
import 'package:playlist_app/constants.dart' as Constants;
import 'package:playlist_app/models/spotifyCurrentPlaybackModel.dart';
import 'dart:convert';
import 'models/spotifyTracksModel.dart';

class SpotifyClient {
  List<Track> _cachedTracks;

  SpotifyClient() {
    _cachedTracks = List();
  }

  Future<String> getAccessToken(String code) async {
    try {
      var resp = await http.post(Constants.ACCESS_TOKEN_ENDPOINT, body: {
        'grant_type': 'authorization_code',
        'code': code,
        'redirect_uri': Constants.REDIRECT_URI
      }, headers: {
        'Authorization': 'Basic ${_getBase64Id()}'
      });

      Map<String, dynamic> map = jsonDecode(resp.body);

      return map['access_token'];
    } catch (ex) {
      return ex;
    }
  }

  //TODO: че-нибудь нагуглить про дженерики
  Future<List<Track>> getSavedTracks(String accessToken, String url) async {
    url = url == null
        ? Constants.SAVED_TRACKS_ENDPOINT + "?limit=50" + "&offset=0"
        : url;

    var resp = await http.get(url, headers: _getAuthHeader(accessToken));

    Map<String, dynamic> map = jsonDecode(resp.body);
    var model = SpotifyTracksModel.fromJson(map);

    model.items.forEach((element) => _cachedTracks.add(element.track));

    String nextUrl = model.next;

    if (nextUrl != null) await getSavedTracks(accessToken, nextUrl);

    return _cachedTracks;
  }

  Future<SpotifyCurrentPlaybackModel> getCurrentPlaybackInfo(
      String accessToken) async {
    var resp = await http.get(Constants.CURRENT_PLAYBACK_ENDPOINT,
        headers: _getAuthHeader(accessToken));

    Map<String, dynamic> map = jsonDecode(resp.body);

    return SpotifyCurrentPlaybackModel.fromJson(map);
  }

  Map<String, String> _getAuthHeader(String accessToken) {
    return {'Authorization': 'Bearer $accessToken'};
  }

  String _getBase64Id() {
    var res = "${Constants.CLIENT_ID}:197776909380429dac9d7263317b6811";
    var bytes = utf8.encode(res);

    return base64.encode(bytes);
  }
}
