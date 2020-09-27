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
                        Image.network(snapshot.data.albumCoverUrl),
                        LinearProgressIndicator(
                            minHeight: 3,
                            backgroundColor: Colors.black,
                            value: 10),
                        Row(
                          children: [
                            Text('${snapshot.data.duration}'),
                            Spacer(),
                            Text('${snapshot.data.progress}'),
                          ],
                        ),
                        Text('${snapshot.data.name}'),
                        Text('${snapshot.data.formattedArtists}'),
                        Text(" -- "),
                        Text('${snapshot.data.album}'),
                        Row(
                          children: [
                            Container(
                              child: GestureDetector(
                                onTap: () => _bloc.playbackEventSink
                                    .add(PrevTrackEvent()),
                                child: Icon(Icons.skip_previous, size: 64),
                              ),
                            ),
                            Container(
                              child: GestureDetector(
                                onTap: () => _bloc.playbackEventSink
                                    .add(ChangeIsPlayingStateEvent()),
                                child: Icon(Icons.pause, size: 64),
                              ),
                            ),
                            Container(
                              child: GestureDetector(
                                onTap: () => _bloc.playbackEventSink
                                    .add(NextTrackEvent()),
                                child: Icon(Icons.skip_next, size: 64),
                              ),
                            ),
                          ],
                        ),
                        Row(
                          children: [
                            Icon(Icons.computer),
                            Text(
                                'Current device: ${snapshot.data.currentDevice}'),
                          ],
                        )
                      ],
                    ),
                  margin: EdgeInsets.only(left: 20, right: 20),),
                ],
              );
            },
          ),
        ],
      ),
    );
  }
}
