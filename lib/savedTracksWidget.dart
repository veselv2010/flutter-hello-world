import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:playlist_app/blocs/models/savedTrack.dart';
import 'package:playlist_app/blocs/savedTracksBloc.dart';
import 'package:playlist_app/blocs/savedTracksEvents.dart';

class SavedTracksWidget extends StatelessWidget {
  final SavedTracksBloc _bloc = SavedTracksBloc();

  SavedTracksWidget() {
    _bloc.savedTracksEventSink.add(SavedTracksInitialized());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: StreamBuilder(
          stream: _bloc.savedTracks,
          initialData: [],
          builder: (context, snapshot) => ListView.builder(
            itemCount: snapshot.data.length,
            itemBuilder: (context, index) =>
                TrackListItem(snapshot.data[index]),
          ),
        ),
      ),
    );
  }
}

class TrackListItem extends StatelessWidget {
  final SavedTrack track;

  TrackListItem(this.track);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(track.name),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(track.formattedArtists),
              Text(track.formattedDuration),
            ],
          ),
        ],
      ),
    );
  }
}
