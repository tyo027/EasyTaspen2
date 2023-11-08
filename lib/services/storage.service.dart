// ignore: depend_on_referenced_packages
import 'package:get_storage/get_storage.dart';

class Storage {
  static GetStorage? _storage;
  static const _lastActive = "LAST_ACTIVE";

  static initialize() async {
    await GetStorage.init();
    _storage ??= GetStorage();
  }

  static bool has(key) {
    if (_storage == null) {
      return false;
    }
    return _storage!.hasData(key);
  }

  static T? read<T>(key) {
    if (_storage == null) {
      return null;
    }
    if (!_storage!.hasData(key)) return null;
    return _storage!.read(key);
  }

  static write(String key, dynamic value) async {
    if (_storage == null) {
      return null;
    }
    _storage!.write(key, value);
  }

  static remove(String key) {
    if (_storage == null) {
      return null;
    }
    _storage!.remove(key);
  }

  static activate() async {
    if (_storage == null) {
      return;
    }
    await _storage!.write(_lastActive, DateTime.now().microsecondsSinceEpoch);
  }

  static deactivate() async {
    if (_storage == null) {
      return;
    }
    await _storage!.remove(_lastActive);
  }

  static bool status() {
    if (_storage == null) {
      return false;
    }
    var lastActive = _storage!.read<int>(_lastActive);
    return lastActive != null
        ? DateTime.fromMicrosecondsSinceEpoch(lastActive)
            .isAfter(DateTime.now().add(const Duration(seconds: -10)))
        : false;
  }
}
