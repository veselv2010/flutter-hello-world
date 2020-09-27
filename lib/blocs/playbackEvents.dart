import 'dart:developer';

abstract class PlaybackEvent{}

class NextTrackEvent extends PlaybackEvent{}
class PrevTrackEvent extends PlaybackEvent{}
class ChangeIsPlayingStateEvent extends PlaybackEvent{}
class PlaybackUpdateEvent extends PlaybackEvent{}
