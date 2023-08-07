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

  CameraController? _cameraController;

  _CameraState(this.user, this.position, this.type);

  @override
  void initState() {
    super.initState();

    if (cameraDescriptions.isEmpty) {
      return;
    }

    _initializeCamera(cameraDescriptions[0]);

    WidgetsBinding.instance.addObserver(this);
  }

  _initializeCamera(CameraDescription cameraDescription) {
    _cameraController =
        CameraController(cameraDescription, ResolutionPreset.medium);

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
      _initializeCamera(cameraDescriptions[0]);
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
            Expanded(
                child: Container(
              margin: const EdgeInsets.all(16),
              clipBehavior: Clip.hardEdge,
              decoration: BoxDecoration(
                  color: Colors.black, borderRadius: BorderRadius.circular(24)),
              child: Center(child: Text('')
                  // CameraPreview(_cameraController)
                  ),
            )),
            const Center(child: Text("Ambil foto wajah untuk absensi!")),
            BlocBuilder<AuthenticationBloc, AuthenticationState>(
              builder: (context, state) {
                return GestureDetector(
                  onTap: () => _submit(context),
                  child: Container(
                    padding: const EdgeInsets.all(20),
                    margin: const EdgeInsets.symmetric(
                        horizontal: 35, vertical: 30),
                    width: 400,
                    decoration: BoxDecoration(
                        color: Colors.grey,
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
    final CameraController? cameraController = _cameraController;

    if (cameraController == null || !cameraController.value.isInitialized) {
      print('Error: select a camera first.');
      return null;
    }

    if (cameraController.value.isTakingPicture) {
      // A capture is already pending, do nothing.
      return null;
    }

    showDialog(
      context: context,
      builder: (context) {
        return const Center(
          child: SizedBox(
              height: 50, width: 50, child: CircularProgressIndicator()),
        );
      },
    );

    try {
      final XFile file = await cameraController.takePicture();

      var isSubmitSucces = await AttendanceRepository().submit(
          user: user, position: position, type: type, imagePath: file.path);

      navigator.pop();
      if (!isSubmitSucces) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text("Absen Gagal Disimpan"),
        ));
        return;
      }
    } on CameraException catch (e) {
      print("Error: camera");
      return null;
    }

    NotificationService.showNotification(
        title: "Absen Berhasil Direkam",
        body: "Data Absen Anda Berhasil Direkam");
    navigator.pushAndRemoveUntil(HomeScreen.route(), (route) => false);
  }
}
