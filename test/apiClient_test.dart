import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:http/http.dart' as http;
import 'package:playlist_app/blocs/models/savedTrack.dart';
import 'package:playlist_app/spotifyApi/apiClient.dart';
import 'package:playlist_app/constants.dart' as Constants;
import 'apiClientTestTypes.dart';

import 'dart:io';

import 'package:playlist_app/spotifyApi/models/currentPlaybackModel.dart';

class MockHttpClient extends Mock implements http.Client {}

MockHttpClient httpClient;
ApiClient apiClient;
String savedTracksJson;
String playbackJson;
String accessToken;

main() {
  setUp(() {
    httpClient = MockHttpClient();
    apiClient = ApiClient(httpClient: httpClient);
    savedTracksJson = _readJson('./test/testdata/SavedTracksResponse.json');
    playbackJson = _readJson('./test/testdata/Playback.json');
    accessToken = "123";
  });

  group('Get a serialized list of saved tracks', () {
    String url = Constants.SAVED_TRACKS_ENDPOINT + "?limit=50" + "&offset=0";
    test(testTypes[TestType.normal], () async {
      _registerResponse(url, savedTracksJson);

      var resp = await apiClient.getSavedTracks(accessToken, null);

      expect(resp, isInstanceOf<List<SavedTrack>>());
      expect(resp.length, 2);
      expect(resp[0], isInstanceOf<SavedTrack>());
      expect(resp[1].id, "761FbINDmXnNgXCpPe50NQ");
    });

    test(testTypes[TestType.noContent], () async {
      _registerResponse(url, "", code: 204);

      var resp = await apiClient.getSavedTracks(accessToken, null);

      expect(resp, null);
    });
  });

  group('Get current playback info', () {
    String url = Constants.CURRENT_PLAYBACK_ENDPOINT;
    test(testTypes[TestType.normal], () async {
      _registerResponse(url, playbackJson);

      var resp = await apiClient.getCurrentPlaybackInfo(accessToken);

      expect(resp, isInstanceOf<CurrentPlaybackModel>());
      expect(resp.item.id, "01uNiHrm8217g2H3IUlBfT");
    });

    test(testTypes[TestType.noContent], () async {
      _registerResponse(url, "", code: 204);

      var resp = await apiClient.getCurrentPlaybackInfo(accessToken);

      expect(resp, null);
    });
  });

  group('Header methods', () {
    test('Base64 id test', () async {
      var result = apiClient.getBase64Id();

      expect(result,
          'MjI2M2UwOGZlY2IwNDBmZmJiYWE0N2ZiYjg2Nzk3MmE6MTk3Nzc2OTA5MzgwNDI5ZGFjOWQ3MjYzMzE3YjY4MTE=');
    });

    test('Authorization header option test', () async {
      var result = apiClient.getAuthHeader('123');

      expect(result, {'Authorization': 'Bearer $accessToken'});
    });
  });

  tearDown(() {
    httpClient.close();
  });
}

String _readJson(String path) {
  String data = new File(path).readAsStringSync();
  return data;
}

void _registerResponse(String url, String content, {int code = 200}) {
  when(httpClient.get(url, headers: apiClient.getAuthHeader(accessToken)))
      .thenAnswer((_) async => http.Response(content, code));
}
