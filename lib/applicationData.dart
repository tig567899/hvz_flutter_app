import 'playerData.dart';

class ApplicationData {
  static final ApplicationData _singleton = ApplicationData._internal();

  PlayerInfo info = PlayerInfo();
  bool loggedIn = false;

  factory ApplicationData() {
    return _singleton;
  }

/*  set info(PlayerInfo info) {
    _playerInfo = info;
  }

  get info {
    return _playerInfo;
  }*/

  ApplicationData._internal();
}