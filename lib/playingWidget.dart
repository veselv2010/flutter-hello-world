import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:playlist_app/models/currentPlaybackModel.dart';
import 'package:playlist_app/apiClient.dart';
import 'dart:async';
import 'package:playlist_app/constants.dart' as Constants;

class PlayingWidget extends StatefulWidget {
  ApiClient client;
  PlayingWidget(ApiClient client) {
    this.client = client;
  }

  @override
  State<StatefulWidget> createState() => _PlayingWidgetState(client);
}

class _PlayingWidgetState extends State<PlayingWidget> {
  CurrentPlaybackModel _playback;
  ApiClient _client;
  var playbackUpdateTimer;

  _PlayingWidgetState(ApiClient client) {
    playbackUpdateTimer = new Timer.periodic(Duration(seconds: 1), (timer) {
      timerCallback();
    });
  }

  void timerCallback() async {
    var playback = await _client.getCurrentPlaybackInfo(Constants.accessToken);
    setState(() {
      _playback = playback;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Padding(padding: EdgeInsets.all(16)),
          Image.network(_playback.item.album.images[0].url),
          LinearProgressIndicator(
              minHeight: 3, backgroundColor: Colors.black, value: 10),
          Row(
            children: [
              Text(ApiClient.getFormattedDuration(_playback.item.durationMs)),
              Spacer(),
              Text(_getRemainingTime(
                  _playback.progressMs, _playback.item.durationMs)),
            ],
          ),
          Text(_playback.item.name),
          Text(_getAllArtists(_playback.item.artists)),
          Text(" -- "),
          Text(_playback.item.album.name),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.skip_previous, size: 64),
              Icon(Icons.pause, size: 64),
              Icon(Icons.skip_next, size: 64),
            ],
          ),
          Row(
            children: [
              Icon(Icons.computer),
              Text('Current device: '),
              Text(_playback.device.name),
            ],
          )
        ],
      ),
    );
  }

  String _getAllArtists(List<Artists> artists) {
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
}
