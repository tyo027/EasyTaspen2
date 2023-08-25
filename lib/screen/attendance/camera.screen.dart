import 'dart:io';
import 'dart:math' as math;
import 'package:camera/camera.dart';
import 'package:easy/app.dart';
import 'package:easy/bloc/authentication_bloc.dart';
import 'package:easy/main.dart';
import 'package:easy/models/user.model.dart';
import 'package:easy/repositories/attendance.repository.dart';
import 'package:easy/screen/attendance/submit.screen.dart';
import 'package:easy/screen/home.screen.dart';
import 'package:easy/services/notification.service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geolocator/geolocator.dart';
import 'package:image/image.dart' as img;

class Camera extends StatefulWidget {
  final UserModel user;
  final Position position;
  final SubmitAttendanceType type;

  const Camera(
      {super.key,
      required this.user,
      required this.position,
      required this.type});

  static Route<void> route(
          {required UserModel user,
          required Position position,
          required SubmitAttendanceType type}) =>
      MaterialPageRoute(
          builder: (_) => Camera(
                user: user,
                position: position,
                type: type,
              ));

  @override
  // ignore: no_logic_in_create_state
  State<Camera> createState() => _CameraState(user, position, type);
}

class _CameraState extends State<Camera> with WidgetsBindingObserver {
  final UserModel user;
  final Position position;
  final SubmitAttendanceType type;
  String? _filePath;
  CameraController? _cameraController;

  _CameraState(this.user, this.position, this.type);

  @override
  void initState() {
    super.initState();

    _initializeCamera();

    WidgetsBinding.instance.addObserver(this);
  }

  _initializeCamera() {
    if (cameraDescriptions.isEmpty) {
      return;
    }

    CameraDescription? cameraDescription = null;
    cameraDescriptions.forEach(
      (element) {
        if (element.lensDirection == CameraLensDirection.front) {
          cameraDescription = element;
        }
      },
    );

    if (cameraDescription == null) {
      return;
    }
    _cameraController = CameraController(
      cameraDescription!,
      ResolutionPreset.medium,
    );

    _cameraController!.initialize().then((_) {
      if (!mounted) {
        print("camera not mounted");
        return;
      }
      setState(() {});
    }).catchError((Object e) {
      if (e is CameraException) {
        switch (e.code) {
          case 'CameraAccessDenied':
            break;
          default:
            // Handle other errors here.
            break;
        }
      }
    });
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    final CameraController? cameraController = _cameraController;

    // App state changed before we got the chance to initialize.
    if (cameraController == null || !cameraController.value.isInitialized) {
      return;
    }

    if (state == AppLifecycleState.inactive) {
      cameraController.dispose();
    } else if (state == AppLifecycleState.resumed) {
      _initializeCamera();
    }
  }

  @override
  void dispose() {
    _cameraController?.dispose();
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: cameraDescriptions.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text("No Supported Camera!"),
                  const SizedBox(
                    height: 8,
                  ),
                  ElevatedButton(
                      onPressed: () {
                        navigator.pop();
                      },
                      child: const Text("Back"))
                ],
              ),
            )
          : _cameraController != null && _cameraController!.value.isInitialized
              ? _cameraPreview()
              : Container(),
    );
  }

  Widget _cameraPreview() => SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            GestureDetector(
              onTap: () => navigator.pop(),
              child: Container(
                padding: const EdgeInsets.all(6),
                margin: const EdgeInsets.symmetric(horizontal: 25),
                child: const Icon(Icons.arrow_back_rounded),
              ),
            ),
            Container(
              margin: const EdgeInsets.all(16),
              clipBehavior: Clip.hardEdge,
              decoration: BoxDecoration(
                  color: Colors.black, borderRadius: BorderRadius.circular(24)),
              child: Center(
                  child: _filePath == null
                      ? CameraPreview(_cameraController!)
                      : Image.file(File(_filePath!))),
            ),
            Spacer(),
            GestureDetector(
              onTap: () async {
                if (_filePath != null) {
                  _filePath = null;
                  setState(() {});
                  return;
                }
                final CameraController? cameraController = _cameraController;

                if (cameraController == null ||
                    !cameraController.value.isInitialized) {
                  print('Error: select a camera first.');
                  return null;
                }

                if (cameraController.value.isTakingPicture) {
                  // A capture is already pending, do nothing.
                  return null;
                }

                try {
                  final XFile file = await cameraController.takePicture();
                  _filePath = file.path;
                  await (img.Command()
                        ..decodeImageFile(_filePath!)
                        ..flip(direction: img.FlipDirection.horizontal)
                        ..writeToFile(_filePath!))
                      .executeThread();
                  setState(() {});
                } on CameraException catch (e) {
                  print("Error: camera");
                  return null;
                }
              },
              child: Container(
                padding: const EdgeInsets.all(20),
                margin: const EdgeInsets.symmetric(horizontal: 35),
                width: 400,
                decoration: BoxDecoration(
                    color: Colors.amberAccent,
                    borderRadius: BorderRadius.circular(20)),
                child:
                    Center(child: Text(_filePath == null ? "Foto" : "Ulang")),
              ),
            ),
            BlocBuilder<AuthenticationBloc, AuthenticationState>(
              builder: (context, state) {
                return GestureDetector(
                  onTap: () => _filePath == null ? null : _submit(context),
                  child: Container(
                    padding: const EdgeInsets.all(20),
                    margin: const EdgeInsets.symmetric(
                        horizontal: 35, vertical: 30),
                    width: 400,
                    decoration: BoxDecoration(
                        color: _filePath == null
                            ? Colors.grey
                            : Colors.amberAccent,
                        borderRadius: BorderRadius.circular(20)),
                    child: const Center(child: Text("Attendance")),
                  ),
                );
              },
            ),
          ],
        ),
      );

  _submit(BuildContext context) async {
    showDialog(
      context: context,
      builder: (context) {
        return const Center(
          child: SizedBox(
              height: 50, width: 50, child: CircularProgressIndicator()),
        );
      },
    );

    var isSubmitSucces = await AttendanceRepository().submit(
        user: user, position: position, type: type, imagePath: _filePath);

    navigator.pop();
    if (!isSubmitSucces) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text("Absen Gagal Disimpan"),
      ));
      return;
    }

    NotificationService.showNotification(
        title: "Absen Berhasil Direkam",
        body: "Data Absen Anda Berhasil Direkam");
    navigator.pushAndRemoveUntil(HomeScreen.route(), (route) => false);
  }
}
