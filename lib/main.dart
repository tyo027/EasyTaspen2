import 'package:easy/app.dart';
import 'package:easy/services/notification.service.dart';
import 'package:easy/services/storage.service.dart';
import 'package:flutter/material.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Storage.initialize();

  await NotificationService.init();
  await NotificationService.loadAllNotification();
  runApp(const App());
}
