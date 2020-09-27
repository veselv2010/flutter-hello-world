import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:playlist_app/blocs/playbackEvents.dart';
import 'package:playlist_app/blocs/playbackBloc.dart';
import 'package:playlist_app/blocs/models/playback.dart';

class PlayingWidget extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _PlayingWidgetState();
}

class _PlayingWidgetState extends State<PlayingWidget> {
  final _bloc = PlaybackBloc();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Padding(padding: EdgeInsets.all(16)),
          StreamBuilder(
            stream: _bloc.playback,
            initialData: null,
            builder: (BuildContext context, AsyncSnapshot<Playback> snapshot) {
              return Column(
                children: [
                  Container(
                    child: Column(
                      children: [
                        Container(
                          child: ClipRRect(
                              child: Image.network(snapshot.data.albumCoverUrl),
                              borderRadius: BorderRadius.circular(10)),
                        ),
                        Padding(
                          child: LinearProgressIndicator(
                              minHeight: 3,
                              backgroundColor: Colors.grey[350],
                              valueColor: AlwaysStoppedAnimation<Color>(
                                  Colors.grey[500]),
                              value: (snapshot.data.progressMs /
                                  snapshot.data.durationMs)),
                          padding: EdgeInsets.only(top: 20, bottom: 2),
                        ),
                        Row(
                          children: [
                            Text('${snapshot.data.duration}',
                                style: TextStyle(color: Colors.grey[600])),
                            Spacer(),
                            Text('${snapshot.data.progress}',
                                style: TextStyle(color: Colors.grey[600])),
                          ],
                        ),
                        Container(
                            padding: EdgeInsets.only(top: 10, bottom: 20),
                            child: Column(children: [
                              Text(
                                '${snapshot.data.name}',
                                style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 22,
                                    fontWeight: FontWeight.bold),
                                textAlign: TextAlign.center,
                              ),
                              Text(
                                  '${snapshot.data.formattedArtists} — ${snapshot.data.album}',
                                  style: TextStyle(
                                      color: Theme.of(context).primaryColor,
                                      fontSize: 22),
                                  textAlign: TextAlign.center),
                            ])),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            InkWell(
                                onTap: () => _bloc.playbackEventSink
                                    .add(PrevTrackEvent()),
                                child: Icon(Icons.skip_previous, size: 64),
                                borderRadius: BorderRadius.circular(32)),
                            InkWell(
                                onTap: () => _bloc.playbackEventSink
                                    .add(ChangeIsPlayingStateEvent()),
                                child: _getPlaybackStateIcon(snapshot.data.isPlaying),
                                borderRadius: BorderRadius.circular(32)),
                            InkWell(
                                onTap: () => _bloc.playbackEventSink
                                    .add(NextTrackEvent()),
                                child: Icon(Icons.skip_next, size: 64),
                                borderRadius: BorderRadius.circular(32)),
                          ],
                        ),
                        Padding(
                            child: Row(
                              children: [
                                Icon(Icons.computer),
                                Text(' ${snapshot.data.currentDevice}'),
                              ],
                            ),
                            padding: EdgeInsets.only(top: 20)),
                      ],
                    ),
                    margin: EdgeInsets.only(left: 30, right: 30),
                  ),
                ],
              );
            },
          ),
        ],
      ),
    );
  }

  Icon _getPlaybackStateIcon(bool isPlaying) =>
      isPlaying ? Icon(Icons.pause, size: 64) : Icon(Icons.play_arrow, size: 64);
}
