import 'package:camera/camera.dart';
import 'package:easy/core/common/pages/auth_page.dart';
import 'package:easy/features/attendance/domain/enums/attendance_type.dart';
import 'package:fca/fca.dart';
import 'package:flutter/material.dart';

class SubmitAttendanceWithCameraPage extends StatefulWidget {
  final AttendanceType type;

  const SubmitAttendanceWithCameraPage({
    super.key,
    required this.type,
  });

  static route(AttendanceType type) => MaterialPageRoute(
        builder: (context) => SubmitAttendanceWithCameraPage(
          type: type,
        ),
      );

  @override
  State<SubmitAttendanceWithCameraPage> createState() =>
      _SubmitAttendanceWithCameraPageState();
}

class _SubmitAttendanceWithCameraPageState
    extends State<SubmitAttendanceWithCameraPage> {
  late CameraController _cameraController;

  @override
  void initState() {
    super.initState();
    _initializeCamera();
  }

  _initializeCamera() async {
    try {
      final cameraDescriptions = await availableCameras();

      final cameraDescription = cameraDescriptions.firstWhere(
        (element) => element.lensDirection == CameraLensDirection.front,
      );

      _cameraController = CameraController(
        cameraDescription,
        ResolutionPreset.medium,
        enableAudio: false,
      );

      _cameraController.initialize();
    } on CameraException catch (e) {
      showSnackBar(context, e.description ?? '');
    }
  }

  @override
  Widget build(BuildContext context) {
    return AuthPage(
      title: '${widget.type.name.toUpperCase()} - CAMERA',
      builder: (context, user) {
        return [];
      },
    );
  }
}
