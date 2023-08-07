import 'package:camera/camera.dart';
import 'package:easy/app.dart';
import 'package:easy/services/notification.service.dart';
import 'package:easy/services/storage.service.dart';
import 'package:flutter/material.dart';

late List<CameraDescription> cameraDescriptions;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Storage.initialize();

  await NotificationService.init();
  await NotificationService.loadAllNotification();

  cameraDescriptions = await availableCameras();

  runApp(const App());
}
