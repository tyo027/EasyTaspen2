import 'package:easy/Widget/userinfo.template.dart';
import 'package:easy/bloc/authentication_bloc.dart';
import 'package:easy/models/attendance.model.dart';
import 'package:easy/models/rekapkehadiran.model.dart';
import 'package:easy/repositories/attendance.repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class LaporanxScreen extends StatelessWidget {
  const LaporanxScreen({super.key});

  static Route<void> route() =>
      MaterialPageRoute(builder: (_) => const LaporanxScreen());

  // Future<List<AttendanceModel>> _getAttendances({required String nik}) async {
  //   return AttendanceRepository().getAttendances(nik: nik);
  // }

  Future<Future<RekapKehadiranModel?>> _getRekapKehadiran(
      {required String nik,
      required String tglMulai,
      required String tglAkhir}) async {
    return AttendanceRepository().getRekapKehadiran(
      nik: nik,
      tglMulai: tglMulai,
      tglAkhir: tglAkhir,
    );
  }

  @override
  Widget build(BuildContext context) {
    return UserInfoTemplate(
      child: BlocBuilder<AuthenticationBloc, AuthenticationState>(
        builder: (context, state) {
          if (state.user == null) {
            return Container();
          }

          if (!state.user!.isActive) {
            return const Center(
              child: Text("Data belum tersedia"),
            );
          }

          return FutureBuilder(
            future: _getRekapKehadiran(
              nik: state.user!.nik,
              tglMulai: '2023-01-01',
              tglAkhir: '2023-02-01',
            ),
            initialData: null,
            builder: (BuildContext context, AsyncSnapshot snapshot) {
              if (!snapshot.hasData) {
                return const Center(
                  child: SizedBox(
                    width: 50,
                    height: 50,
                    child: CircularProgressIndicator(),
                  ),
                );
              }
              return ListView.separated(
                padding:
                    const EdgeInsets.symmetric(horizontal: 35, vertical: 12),
                itemCount: snapshot.data.length,
                separatorBuilder: (BuildContext context, int index) {
                  return const SizedBox(
                    height: 20,
                  );
                },
                itemBuilder: (BuildContext context, int index) {
                  return laporanItem(attendanceModel: snapshot.data[index]);
                },
              );
            },
          );
        },
      ),
    );
  }

  Widget laporanItem({required AttendanceModel attendanceModel}) {
    return Container(
        padding: const EdgeInsets.symmetric(vertical: 20),
        width: double.infinity,
        decoration: BoxDecoration(
            border: Border.all(color: Colors.black45),
            borderRadius: BorderRadius.circular(20)),
        child: Column(
          // crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Waktu Absen: ${attendanceModel.attendanceTime}"),
            Text("Status SAP: ${attendanceModel.statusSap}"),
            Text("Absensi: ${attendanceModel.type.name.toUpperCase()}")
          ],
        ));
  }
}
