/// [Playback status](https://developers.google.com/youtube/iframe_api_reference#Playback_status).
enum PlayerState {
  unloaded(-100),
  unstarted(-1),
  ended(0),
  playing(1),
  paused(2),
  buffering(3),
  cued(5);

  const PlayerState(this._value);

  final int _value;

  static PlayerState? fromValue(int value) {
    for (final state in PlayerState.values) {
      if (state._value == value) {
        return state;
      }
    }
    return null;
  }
}
