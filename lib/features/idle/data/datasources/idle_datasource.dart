import 'package:hive_flutter/hive_flutter.dart';

abstract class IdleDataSource {
  Future<bool> isIdle();

  Future<void> saveLastIdle(DateTime lastIdle);
}

class IdleDataSourceImpl implements IdleDataSource {
  Box box;

  IdleDataSourceImpl(this.box);

  @override
  Future<bool> isIdle() async {
    final lastIdle = box.get('lastIdle');
    if (lastIdle == null) return false;

    final lastIdleTime = DateTime.tryParse(lastIdle);

    if (lastIdleTime == null) {
      box.delete('lastIdle');
      return false;
    }

    return DateTime.now().difference(lastIdleTime).inMilliseconds <=
        const Duration(minutes: 10000).inMilliseconds;
  }

  @override
  Future<void> saveLastIdle(DateTime lastIdle) async {
    await box.put('lastIdle', lastIdle.toIso8601String());
  }
}
