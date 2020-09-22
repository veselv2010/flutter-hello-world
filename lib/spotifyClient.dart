import 'package:http/http.dart' as http;
import 'package:playlist_app/constants.dart' as Constants;
import 'dart:convert';
import 'savedTracksModel.dart';

class SpotifyClient {
  String _encodedAuth;
  List<Track> _cachedTracks;

  SpotifyClient() {
    _encodedAuth = _getBase64Header();
    _cachedTracks = List();
  }

  Future<String> getAccessToken(String code) async {
    try {
      var resp = await http.post(Constants.ACCESS_TOKEN_ENDPOINT, body: {
        'grant_type': 'authorization_code',
        'code': code,
        'redirect_uri': Constants.REDIRECT_URI
      }, headers: {
        'Authorization': 'Basic $_encodedAuth'
      });

      Map<String, dynamic> map = jsonDecode(resp.body);

      return map['access_token'];
    } catch (ex) {
      return ex;
    }
  }

  Future<List<Track>> getSavedTracks(String accessToken, String url) async {
    url = url == null
        ? Constants.SAVED_TRACKS_ENDPOINT + "?limit=50" + "&offset=0"
        : url;

    var resp =
        await http.get(url, headers: {'Authorization': 'Bearer $accessToken'});

    Map<String, dynamic> map = jsonDecode(resp.body);
    SavedTracksModel model = SavedTracksModel.fromJson(map);

    model.items.forEach((element) => _cachedTracks.add(element.track));

    String nextUrl = model.next;
    
    if (nextUrl != null) 
      await getSavedTracks(accessToken, nextUrl);

    return _cachedTracks;
  }

  String _getBase64Header() {
    var res = "${Constants.CLIENT_ID}:197776909380429dac9d7263317b6811";
    var bytes = utf8.encode(res);
    return base64.encode(bytes);
  }
}
