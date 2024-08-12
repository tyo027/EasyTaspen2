import 'package:camera/camera.dart';
import 'package:easy/app.dart';
import 'package:easy/services/alarm_service.dart';
import 'package:easy/services/fcm.service.dart';
import 'package:easy/services/storage.service.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

late List<CameraDescription> cameraDescriptions;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Storage.initialize();

  cameraDescriptions = await availableCameras();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  await FcmService.initialize();
  await AlarmService.init();

  runApp(const App());
}
