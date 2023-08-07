// ignore_for_file: use_build_context_synchronously

import 'package:easy/Widget/userinfo.template.dart';
import 'package:easy/app.dart';
import 'package:easy/bloc/authentication_bloc.dart';
import 'package:easy/models/user.model.dart';
import 'package:easy/repositories/attendance.repository.dart';
import 'package:easy/screen/attendance/camera.screen.dart';
import 'package:easy/screen/home.screen.dart';
import 'package:easy/services/biometric.service.dart';
import 'package:easy/services/location.service.dart';
import 'package:easy/services/notification.service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geolocator/geolocator.dart';

enum SubmitAttendanceType { wfa, wfo }

class SubmitAttendance extends StatelessWidget {
  const SubmitAttendance({super.key, required this.type});
  final SubmitAttendanceType type;

  static Route<void> route(SubmitAttendanceType type) => MaterialPageRoute(
      builder: (_) => SubmitAttendance(
            type: type,
          ));

  Future cancelNotification() async {
    var now = DateTime.now();
    if (now.hour <= 8) {
      await NotificationService.cancelNotifications("NOTIF_MASUK_KERJA");
    } else if (now.hour >= 12) {
      await NotificationService.cancelNotifications("NOTIF_PULANG_KERJA");
    }
  }

  Future submit(
    bool enable,
    BuildContext context,
    UserModel user,
    Position position,
  ) async {
    if (!enable) return;
    await cancelNotification();
    var authenticate = await BiometricService.authenticate();
    if (!authenticate) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text("Data Biometric Tidak Sesuai"),
      ));
      navigator.push(Camera.route(user: user, position: position, type: type));
      return;
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

    if (user.isActive) {
      var isSubmitSucces = await AttendanceRepository()
          .submit(user: user, position: position, type: type);
      navigator.pop();
      if (!isSubmitSucces) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text("Absen Gagal Disimpan"),
        ));
        return;
      }
    } else {
      await Future.delayed(const Duration(seconds: 2));
    }

    NotificationService.showNotification(
        title: "Absen Berhasil Direkam",
        body: "Data Absen Anda Berhasil Direkam");
    navigator.pushAndRemoveUntil(HomeScreen.route(), (route) => false);
  }

  @override
  Widget build(BuildContext context) {
    return UserInfoTemplate(
        child: FutureBuilder(
            future: LocationService.getCurrentPosition(type: type),
            builder: (context, snapshot) {
              if (!snapshot.hasData) return Container();
              var location = snapshot.data!;
              return Column(
                children: [
                  Container(
                      margin: const EdgeInsets.symmetric(horizontal: 35),
                      width: 400,
                      height: 200,
                      clipBehavior: Clip.hardEdge,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20)),
                      child: Image.network(
                        LocationService.getImageUrlRadius(
                            snapshot.data!.latitude, snapshot.data!.longitude),
                        fit: BoxFit.cover,
                      )),
                  const SizedBox(height: 30),
                  Container(
                    padding: const EdgeInsets.all(20),
                    margin: const EdgeInsets.symmetric(horizontal: 35),
                    width: 400,
                    decoration: BoxDecoration(
                        color: Colors.amberAccent,
                        borderRadius: BorderRadius.circular(20)),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                            "Work From ${type == SubmitAttendanceType.wfo ? 'Office' : 'Anywhere'}"),
                        Text("Longitude: ${snapshot.data!.longitude}"),
                        Text("Latitude: ${snapshot.data!.latitude}"),
                      ],
                    ),
                  ),
                  const Spacer(),
                  FutureBuilder(
                      future: LocationService.getDistanceTo(type: type),
                      builder: (context, snapshot) {
                        var outOfRange =
                            snapshot.hasData ? (snapshot.data! > 100) : true;
                        var enable =
                            (!outOfRange && type == SubmitAttendanceType.wfo) ||
                                type == SubmitAttendanceType.wfa;
                        return Column(
                          children: [
                            if (outOfRange && !enable)
                              const Text("Anda Tidak Berada Di Area Kantor"),
                            BlocBuilder<AuthenticationBloc,
                                AuthenticationState>(
                              builder: (context, state) {
                                return GestureDetector(
                                  onTap: () {
                                    submit(
                                      enable,
                                      context,
                                      state.user!,
                                      location,
                                    );
                                  },
                                  child: Container(
                                    padding: const EdgeInsets.all(20),
                                    margin: const EdgeInsets.symmetric(
                                        horizontal: 35, vertical: 30),
                                    width: 400,
                                    decoration: BoxDecoration(
                                        color: enable
                                            ? Colors.amberAccent
                                            : Colors.grey,
                                        borderRadius:
                                            BorderRadius.circular(20)),
                                    child:
                                        const Center(child: Text("Attendance")),
                                  ),
                                );
                              },
                            ),
                          ],
                        );
                      }),
                ],
              );
            }));
  }
}
