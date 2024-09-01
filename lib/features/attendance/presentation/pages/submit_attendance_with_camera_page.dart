import 'dart:io';

import 'package:camera/camera.dart';
import 'package:easy/core/common/pages/auth_page.dart';
import 'package:easy/core/common/widgets/button_widget.dart';
import 'package:easy/core/themes/app_pallete.dart';
import 'package:easy/features/attendance/domain/entities/my_location.dart';
import 'package:easy/features/attendance/domain/enums/attendance_type.dart';
import 'package:easy/features/attendance/presentation/bloc/attendance_bloc.dart';
import 'package:easy/features/attendance/presentation/bloc/my_location_bloc.dart';
import 'package:easy/features/home/presentation/pages/home_page.dart';
import 'package:fca/fca.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:image/image.dart' as img;

class SubmitAttendanceWithCameraPage extends StatefulWidget {
  final AttendanceType type;

  const SubmitAttendanceWithCameraPage({
    super.key,
    required this.type,
  });

  static String route = '/attendance/submit-with-camera';

  @override
  State<SubmitAttendanceWithCameraPage> createState() =>
      _SubmitAttendanceWithCameraPageState();
}

class _SubmitAttendanceWithCameraPageState
    extends State<SubmitAttendanceWithCameraPage> with WidgetsBindingObserver {
  late CameraController _cameraController;
  bool loading = false;

  String? _filePath;

  @override
  void initState() {
    super.initState();

    _initializeCamera(
      onError: (exception) {
        showSnackBar(
          context,
          exception.description ?? exception.code,
        );
        context.pop();
      },
      onSuccess: () {
        setState(() {
          loading = true;
        });
      },
    );

    WidgetsBinding.instance.addObserver(this);
  }

  _initializeCamera({
    required Function(CameraException exception) onError,
    required Function() onSuccess,
  }) async {
    try {
      final cameraDescriptions = await availableCameras();

      if (cameraDescriptions.isEmpty) {
        throw CameraException('NO_CAMERA', 'No Camera Available');
      }

      final cameraDescription = cameraDescriptions.firstWhere(
        (element) => element.lensDirection == CameraLensDirection.front,
      );

      _cameraController = CameraController(
        cameraDescription,
        ResolutionPreset.medium,
        enableAudio: false,
      );

      await _cameraController.initialize();

      onSuccess();
    } on CameraException catch (exception) {
      onError(exception);
    }
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (!_cameraController.value.isInitialized) {
      return;
    }

    if (state == AppLifecycleState.inactive) {
      _cameraController.dispose();
      setState(() {
        loading = false;
      });
    } else if (state == AppLifecycleState.resumed) {
      _initializeCamera(
        onError: (exception) {
          showSnackBar(
            context,
            exception.description ?? exception.code,
          );
          context.pop();
        },
        onSuccess: () {
          setState(() {
            loading = true;
          });
        },
      );
    }
  }

  @override
  void dispose() {
    _cameraController.dispose();
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AuthPage(
      title: '${widget.type.name.toUpperCase()} - CAMERA',
      bottomWidget: (context, user) => Row(
        children: [
          if (_filePath == null)
            Expanded(
              child: ButtonWidget.primary(
                'Foto',
                onPressed: loading
                    ? () {
                        showLoading(context);
                        _takePicture(
                          onSuccess: (path) {
                            Navigator.pop(context);
                            setState(() {
                              _filePath = path;
                            });
                          },
                          onError: (exception) {
                            Navigator.pop(context);
                            setState(() {
                              _filePath = null;
                            });
                          },
                        );
                      }
                    : null,
              ),
            ),
          if (_filePath != null)
            Expanded(
              child: ButtonWidget.primary(
                'Ulang',
                onPressed: loading
                    ? () {
                        setState(() {
                          _filePath = null;
                        });
                      }
                    : null,
              ),
            ),
          if (_filePath != null) const Gap(24),
          if (_filePath != null)
            Expanded(
              child: BlocBuilder<MyLocationBloc, BaseState>(
                builder: (context, state) {
                  return ButtonWidget.primary(
                    'Absen',
                    backgroundColor: AppPallete.text,
                    foregroundColor: Colors.white,
                    onPressed: loading && state is SuccessState<MyLocation>
                        ? () {
                            context.read<AttendanceBloc>().add(
                                  Authenticate(
                                    type: widget.type,
                                    nik: user.nik,
                                    kodeCabang: user.ba,
                                    latitude: state.data.latitude,
                                    longitude: state.data.longitude,
                                    filePath: _filePath,
                                  ),
                                );
                          }
                        : null,
                  );
                },
              ),
            ),
        ],
      ),
      builder: (context, user) {
        return [
          BaseConsumer<AttendanceBloc, dynamic>(
            onSuccess: (data) {
              showSnackBar(
                context,
                "Berhasil Absen",
                indicatorColor: Colors.green,
              );
              context.go(HomePage.route);
            },
            builder: (context, state) {
              return Container(
                margin: const EdgeInsets.symmetric(horizontal: 24),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(24),
                  color: AppPallete.shadow,
                ),
                clipBehavior: Clip.hardEdge,
                child: loading
                    ? _filePath != null
                        ? Image.file(File(_filePath!))
                        : CameraPreview(_cameraController)
                    : const SizedBox(),
              );
            },
          )
        ];
      },
    );
  }

  _takePicture({
    required Function(CameraException exception) onError,
    required Function(String path) onSuccess,
  }) async {
    try {
      final XFile file = await _cameraController.takePicture();

      final command = img.Command();
      command.decodeImageFile(file.path);
      command.flip(direction: img.FlipDirection.horizontal);
      command.writeToFile(file.path);

      await command.executeThread();

      onSuccess(file.path);
    } on CameraException catch (_) {
      onError(_);
    }
  }
}
