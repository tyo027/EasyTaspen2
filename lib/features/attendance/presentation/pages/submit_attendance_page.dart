import 'package:easy/core/common/pages/auth_page.dart';
import 'package:easy/core/common/widgets/button_widget.dart';
import 'package:easy/features/attendance/domain/entities/my_location.dart';
import 'package:easy/features/attendance/domain/entities/rule.dart';
import 'package:easy/features/attendance/domain/enums/attendance_type.dart';
import 'package:easy/features/attendance/presentation/bloc/attendance_bloc.dart';
import 'package:easy/features/attendance/presentation/bloc/my_location_bloc.dart';
import 'package:easy/features/attendance/presentation/bloc/rule_bloc.dart';
import 'package:easy/features/attendance/presentation/pages/submit_attendance_with_camera_page.dart';
import 'package:easy/features/home/presentation/pages/home_page.dart';
import 'package:fca/fca.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';

class SubmitAttendancePage extends StatelessWidget {
  final AttendanceType type;

  const SubmitAttendancePage({
    super.key,
    required this.type,
  });

  static String route = '/attendance/submit';

  @override
  Widget build(BuildContext context) {
    return AuthPage(
      title: type.name.toUpperCase(),
      bottomWidget: (context, user) {
        return BaseConsumer<AttendanceBloc, bool>(
          onFailure: (context, message) {
            if (message == 'BIOMETRIC_FAILED') {
              showDialog(
                context: context,
                builder: (context) {
                  return CupertinoAlertDialog(
                    title: const Text("Biometrik Gagal Direkam"),
                    content: const Text("Absen Dengan Foto"),
                    actions: [
                      CupertinoDialogAction(
                        child: const Text("YA"),
                        onPressed: () {
                          Navigator.pop(context);
                          context.pushReplacement(
                            SubmitAttendanceWithCameraPage.route,
                            extra: type,
                          );
                        },
                      ),
                      CupertinoDialogAction(
                        child: const Text("ULANG"),
                        onPressed: () {
                          Navigator.pop(context);
                        },
                      ),
                    ],
                  );
                },
              );
            }
          },
          onSuccess: (data) {
            showSnackBar(
              context,
              "Berhasil Absen",
              indicatorColor: Colors.green,
            );
            context.go(HomePage.route);
          },
          builder: (context, state) {
            return BlocBuilder<MyLocationBloc, BaseState>(
              builder: (context, state) {
                if (state is! SuccessState<MyLocation>) {
                  return const Gap(0);
                }

                if (!state.data.isInRange) {
                  return ButtonWidget.primary(
                    "Anda Tidak Berada Di Area Kantor",
                    onPressed: null,
                  );
                }

                return ButtonWidget.primary(
                  "Absen",
                  onPressed: () {
                    context.read<AttendanceBloc>().add(
                          Authenticate(
                            type: type,
                            nik: user.nik,
                            kodeCabang: user.ba,
                            latitude: state.data.latitude,
                            longitude: state.data.longitude,
                          ),
                        );
                  },
                );
              },
            );
          },
        );
      },
      builder: (context, user) {
        final ruleBloc = context.read<RuleBloc>();
        if (ruleBloc.state is! SuccessState) {
          ruleBloc.add(
            GetRuleData(
              codeCabang: user.ba,
              nik: user.nik,
            ),
          );
        }
        return [
          BaseConsumer<RuleBloc, Rule>(
            onFailure: (context, message) {},
            builder: (context, state) {
              if (state is FailureState) {
                final height = MediaQuery.of(context).size.height;
                return SizedBox(
                  height: height / 2,
                  child: Center(
                    child: Text(
                      state.message,
                    ),
                  ),
                );
              }
              if (state is! SuccessState<Rule>) {
                return const Gap(0);
              }

              final myLocationBloc = context.read<MyLocationBloc>();

              myLocationBloc.add(
                GetCurrentLocation(
                  centerLatitude: state.data.lat,
                  centerLongitude: state.data.long,
                  radius: state.data.jarak,
                  kodeCabang: user.ba,
                  type: type,
                  nik: user.nik,
                  allowMockLocation: state.data.isAllowMockLocation,
                ),
              );

              return BaseConsumer<MyLocationBloc, MyLocation>(
                builder: (context, state) {
                  if (state is SuccessState<MyLocation>) {
                    return Column(
                      children: [
                        Container(
                          margin: const EdgeInsets.symmetric(horizontal: 24),
                          width: 400,
                          height: 200,
                          clipBehavior: Clip.hardEdge,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20)),
                          child: Image.network(
                            state.data.imageSrc,
                            fit: BoxFit.cover,
                          ),
                        ),
                        const Gap(24),
                        Container(
                          padding: const EdgeInsets.all(20),
                          margin: const EdgeInsets.symmetric(horizontal: 24),
                          width: 400,
                          decoration: BoxDecoration(
                              color: Colors.amberAccent,
                              borderRadius: BorderRadius.circular(20)),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                  "Work From ${type == AttendanceType.wfo ? 'Office' : 'Anywhere'}"),
                              Text("Longitude : ${state.data.longitude}"),
                              Text("Latitude  : ${state.data.latitude}"),
                            ],
                          ),
                        ),
                      ],
                    );
                  }
                  return const Gap(0);
                },
              );
            },
          )
        ];
      },
    );
  }
}
