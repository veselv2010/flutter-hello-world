import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:http/http.dart' as http;
import 'package:playlist_app/blocs/models/savedTrack.dart';
import 'package:playlist_app/spotifyApi/apiClient.dart';
import 'package:playlist_app/constants.dart' as Constants;

import 'dart:io';

class MockHttpClient extends Mock implements http.Client {}

MockHttpClient httpClient;
ApiClient apiClient;
String savedTracksJson;
String accessToken;

main() {
  setUp(() {
    httpClient = MockHttpClient();
    apiClient = ApiClient(httpClient: httpClient);
    savedTracksJson = _readJson('./test/testdata/SavedTracksResponse.json');
    accessToken = "123";
  });

  group('Get a serialized list of saved tracks', () {
    test('normal response test', () async {
      when(httpClient.get(
              Constants.SAVED_TRACKS_ENDPOINT + "?limit=50" + "&offset=0",
              headers: apiClient.getAuthHeader(accessToken)))
          .thenAnswer((_) async =>
              http.Response(savedTracksJson, 200));

      var resp = await apiClient.getSavedTracks(accessToken, null);

      expect(resp, isInstanceOf<List<SavedTrack>>());
      expect(resp, resp.length == 10);
      expect(resp[0], isInstanceOf<SavedTrack>());
      expect(resp[9].id, "17Vw9uuOYB7XYjPt0LNFN0");
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
