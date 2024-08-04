// ignore_for_file: constant_identifier_names

import 'package:easy/Widget/userinfo.template.dart';
import 'package:easy/bloc/authentication_bloc.dart';
import 'package:easy/extension.dart';
import 'package:easy/models/attendance.model.dart';
import 'package:easy/models/cekstaff.model.dart';
import 'package:easy/models/rekapkehadiran.model.dart';
import 'package:easy/models/rekapkehadiranharian.model.dart';
import 'package:easy/repositories/attendance.repository.dart';
import 'package:easy/repositories/cekstaff.repository.dart';
import 'package:easy/screen/laporanscreen/bloc/kehadiran_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:month_picker_dialog/month_picker_dialog.dart';
// import 'package:intl/intl.dart';
// import 'package:month_picker_dialog_2/month_picker_dialog_2.dart';

enum LaporanType {
  CEK_ABSEN_HARIAN,
  REKAP_KEHADIRAN,
  KEHADIRAN_HARIAN_VERIFIED,
}

class ManajemenScreen extends StatelessWidget {
  const ManajemenScreen({super.key});

  static Route<void> route() =>
      MaterialPageRoute(builder: (_) => const ManajemenScreen());

  Future<DateTime?> monthPicker(
          {required BuildContext context, DateTime? initialDate}) =>
      showMonthPicker(
        context: context,
        headerColor: Colors.amber,
        headerTextColor: Colors.black,
        initialDate: initialDate,
        lastDate: DateTime.now(),
        cancelWidget: const Text(
          "Batal",
          style: TextStyle(color: Colors.black38),
        ),
        confirmWidget: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          decoration: BoxDecoration(
              color: Colors.amber, borderRadius: BorderRadius.circular(10)),
          child: const Text(
            "Pilih",
            style: TextStyle(color: Colors.black),
          ),
        ),
        roundedCornersRadius: 20,
        unselectedMonthTextColor: Colors.black,
        selectedMonthBackgroundColor: Colors.amber,
        selectedMonthTextColor: Colors.black,
      );

  void findMounthDialog(BuildContext context, DateTime? selected) {
    if (!context.mounted) return;

    monthPicker(context: context, initialDate: selected).then((selectedDate) {
      if (selectedDate == null) return;
      context
          .read<KehadiranBloc>()
          .add(RekapKehadiranEvent(thnBln: selectedDate));
    });
  }

  void findDateRangeDialog(
      BuildContext context, DateTime? startDate, DateTime? endDate) {
    if (!context.mounted) return;

    showDialog<String?>(
      context: context,
      builder: (context) => SimpleDialog(
        title: const Text('Berdasarkan'),
        children: [
          SimpleDialogOption(
            child: const Text("Pilih range tanggal"),
            onPressed: () {
              Navigator.pop(context, "RANGE_TANGGAL");
            },
          ),
          SimpleDialogOption(
            child: const Text("Pilih bulan"),
            onPressed: () {
              Navigator.pop(context, "BULAN");
            },
          )
        ],
      ),
    ).then((type) {
      if (type == null) return;

      if (type == "RANGE_TANGGAL") {
        showDateRangePicker(
          context: context,
          firstDate: DateTime.utc(1980),
          lastDate: DateTime.now(),
          initialDateRange: startDate != null && endDate != null
              ? DateTimeRange(start: startDate, end: endDate)
              : null,
          initialEntryMode: DatePickerEntryMode.calendarOnly,
          saveText: "Pilih",
        ).then((selectedDate) {
          if (selectedDate == null) return;

          context.read<KehadiranBloc>().add(KehadiranHarianVerifiedEvent(
              tglMulai: selectedDate.start,
              tglAkhir: selectedDate.end,
              isLoading: false));
        });
      }

      if (type == "BULAN") {
        monthPicker(context: context, initialDate: startDate)
            .then((selectedDate) {
          if (selectedDate == null) return;

          var startTime = selectedDate.copyWith(day: 1);
          var endTime = startTime.copyWith(month: startTime.month + 1, day: 0);

          context.read<KehadiranBloc>().add(KehadiranHarianVerifiedEvent(
              tglMulai: startTime,
              tglAkhir:
                  DateTime.now().isBefore(endTime) ? DateTime.now() : endTime));
        });
      }
    });
  }

  void findMonthly(BuildContext context, String? nik, DateTime thnBln) {
    if (nik == null) return;

    context.read<KehadiranBloc>().add(RekapKehadiranEvent(
        isLoading: true, rekapKehadiran: const [], thnBln: thnBln));

    var startTime = thnBln.copyWith(day: 1);
    var endTime = startTime.copyWith(month: startTime.month + 1, day: 0);

    AttendanceRepository()
        .getRekapKehadiran(
            nik: nik,
            tglMulai: startTime.toString().substring(0, 10),
            tglAkhir: endTime.toString().substring(0, 10))
        .then((value) {
      if (value != null) {
        context.read<KehadiranBloc>().add(RekapKehadiranEvent(
            rekapKehadiran: value, isLoading: false, thnBln: thnBln));
        return;
      }
      context.read<KehadiranBloc>().add(RekapKehadiranEvent(
          isLoading: false, rekapKehadiran: const [], thnBln: thnBln));
    });
  }

  void findDaily(
      BuildContext context, String? nik, DateTime tglMulai, DateTime tglAkhir) {
    if (nik == null) return;
    context.read<KehadiranBloc>().add(KehadiranHarianVerifiedEvent(
        tglMulai: tglMulai,
        tglAkhir: tglAkhir,
        kehadiranHarian: const [],
        isLoading: true));

    AttendanceRepository()
        .getRekapKehadiranHarian(
            nik: nik,
            tglMulai: tglMulai.toString().substring(0, 10),
            tglAkhir: tglAkhir.toString().substring(0, 10))
        .then((value) {
      if (value != null) {
        context.read<KehadiranBloc>().add(KehadiranHarianVerifiedEvent(
            tglMulai: tglMulai,
            tglAkhir: tglAkhir,
            kehadiranHarian: value,
            isLoading: false));
        return;
      }

      context.read<KehadiranBloc>().add(KehadiranHarianVerifiedEvent(
          tglMulai: tglMulai,
          tglAkhir: tglAkhir,
          kehadiranHarian: const [],
          isLoading: false));
    });
  }

  void getAttendances({required BuildContext context, required String? nik}) {
    if (nik == null) return;

    context
        .read<KehadiranBloc>()
        .add(CekAbsenHarianEvent(isLoading: true, attandances: const []));

    AttendanceRepository().getAttendances(nik: nik).then((attandences) {
      context
          .read<KehadiranBloc>()
          .add(CekAbsenHarianEvent(isLoading: false, attandances: attandences));
      return;
    });
  }

  @override
  Widget build(BuildContext context) {
    return UserInfoTemplate(child: laporansMenu(context));
  }

  Widget laporansMenu(BuildContext context) {
    return BlocProvider(
      create: (context) => KehadiranBloc(const CekAbsenHarian()),
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 24, vertical: 10),
        child: BlocBuilder<KehadiranBloc, KehadiranState>(
          builder: (context, state) {
            return Column(
              mainAxisSize: MainAxisSize.max,
              children: [
                pegawaiRekap(),
                const SizedBox(
                  height: 10,
                ),
                jenisRekap(),
                const SizedBox(
                  height: 10,
                ),
                if (state is RekapKehadiran || state is KehadiranHarianVerified)
                  cariTgl(),
                if (state is RekapKehadiran || state is KehadiranHarianVerified)
                  const SizedBox(
                    height: 10,
                  ),
                cariBtn(),
                const SizedBox(
                  height: 20,
                ),
                result()
              ],
            );
          },
        ),
      ),
    );
  }

  Widget cariTgl() {
    return BlocBuilder<KehadiranBloc, KehadiranState>(
      builder: (context, state) {
        return GestureDetector(
          onTap: () async {
            if (state is RekapKehadiran) {
              findMounthDialog(context, state.thnBln);
              return;
            }
            if (state is KehadiranHarianVerified) {
              findDateRangeDialog(context, state.tglMulai, state.tglAkhir);
            }
          },
          child: Container(
            padding:
                const EdgeInsets.only(left: 20, top: 10, bottom: 10, right: 20),
            height: 45,
            decoration: BoxDecoration(
                color: Colors.blueGrey[50],
                borderRadius: BorderRadius.circular(10)),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                BlocBuilder<KehadiranBloc, KehadiranState>(
                  builder: (context, state) {
                    return Text(state is RekapKehadiran
                        ? state.thnBln == null
                            ? "Bulan / Tahun "
                            : DateFormat("MMMM yyyy").format(state.thnBln!)
                        : state is KehadiranHarianVerified
                            ? state.tglMulai == null
                                ? 'Dari s/d Sampai'
                                : '${DateFormat("dd MMM yyyy").format(state.tglMulai!)} s/d ${DateFormat("dd MMM yyyy").format(state.tglAkhir!)}'
                            : "");
                  },
                ),
                Icon(
                  Icons.calendar_month_outlined,
                  color: Colors.grey[700],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget jenisRekap() {
    return Container(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        width: double.infinity,
        decoration: BoxDecoration(
            color: Colors.blueGrey[50],
            borderRadius: BorderRadius.circular(10)),
        child: BlocBuilder<KehadiranBloc, KehadiranState>(
          builder: (context, state) {
            return DropdownButton<LaporanType>(
                isExpanded: true,
                value: state is RekapKehadiran
                    ? LaporanType.REKAP_KEHADIRAN
                    : state is KehadiranHarianVerified
                        ? LaporanType.KEHADIRAN_HARIAN_VERIFIED
                        : LaporanType.CEK_ABSEN_HARIAN,
                elevation: 16,
                style: const TextStyle(color: Colors.black),
                underline: Container(
                  height: 0,
                ),
                onChanged: (LaporanType? type) {
                  if (type != null) {
                    if (type == LaporanType.REKAP_KEHADIRAN) {
                      context.read<KehadiranBloc>().add(RekapKehadiranEvent());
                    }

                    if (type == LaporanType.KEHADIRAN_HARIAN_VERIFIED) {
                      context
                          .read<KehadiranBloc>()
                          .add(KehadiranHarianVerifiedEvent());
                    }

                    if (type == LaporanType.CEK_ABSEN_HARIAN) {
                      context.read<KehadiranBloc>().add(CekAbsenHarianEvent());
                    }
                  }
                },
                items: LaporanType.values
                    .map((type) => DropdownMenuItem(
                          value: type,
                          child: Text(type.name
                              .split('_')
                              .map((e) => e.capitalize())
                              .join(" ")),
                        ))
                    .toList());
          },
        ));
  }

  Widget pegawaiRekap() {
    return Container(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        width: double.infinity,
        decoration: BoxDecoration(
            color: Colors.blueGrey[50],
            borderRadius: BorderRadius.circular(10)),
        child: BlocBuilder<AuthenticationBloc, AuthenticationState>(
          builder: (context, state) {
            return FutureBuilder<List<CekStaffModel>>(
              future: CekStaff().getStaff(nik: "3130"),
              initialData: null,
              builder: (BuildContext context, AsyncSnapshot snapshot) {
                return DropdownButton<CekStaffModel>(
                    isExpanded: true,
                    value: snapshot.hasData
                        ? null
                        : const CekStaffModel(
                            nik: "nik",
                            nama: "Sedang Memuat Data",
                            positionname: "positionname"),
                    elevation: 16,
                    style: const TextStyle(color: Colors.black),
                    underline: Container(
                      height: 0,
                    ),
                    onChanged: (value) {},
                    items: snapshot.hasData
                        ? (snapshot.data as List<CekStaffModel>)
                            .map((type) => DropdownMenuItem(
                                  value: type,
                                  child: Text(type.nama),
                                ))
                            .toList()
                        : [
                            const DropdownMenuItem(
                              value: CekStaffModel(
                                  nik: "nik",
                                  nama: "Sedang Memuat Data",
                                  positionname: "positionname"),
                              child: Text("SEDANG MEMUAT DATA"),
                            )
                          ]);
              },
            );
          },
        ));
  }

  Widget cariBtn() {
    return BlocBuilder<AuthenticationBloc, AuthenticationState>(
      builder: (context, auth) {
        return BlocBuilder<KehadiranBloc, KehadiranState>(
          builder: (context, state) {
            if (auth is Authenticated) {
              return GestureDetector(
                onTap: () {
                  if (state.isLoading) return;
                  print(CekStaff().getStaff(nik: auth.user.nik));
                  if (state is RekapKehadiran && state.thnBln != null) {
                    findMonthly(context, auth.user.nik, state.thnBln!);
                  }

                  if (state is KehadiranHarianVerified &&
                      state.tglMulai != null &&
                      state.tglAkhir != null) {
                    findDaily(context, auth.user.nik, state.tglMulai!,
                        state.tglAkhir!);
                  }

                  if (state is CekAbsenHarian) {
                    getAttendances(context: context, nik: auth.user.nik);
                  }
                },
                child: Container(
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                      color: state.isEnabled ? Colors.blue[300] : Colors.grey,
                      borderRadius: BorderRadius.circular(10)),
                  child: Center(
                    child: state.isLoading
                        ? const SizedBox(
                            height: 17,
                            width: 17,
                            child: CircularProgressIndicator())
                        : const Text(
                            style: TextStyle(fontWeight: FontWeight.bold),
                            'Cari'),
                  ),
                ),
              );
            }
            return Container();
          },
        );
      },
    );
  }

  Widget result() {
    return Expanded(
      flex: 1,
      child: SingleChildScrollView(
        child: Container(
          width: double.infinity,
          margin: const EdgeInsets.only(bottom: 8),
          child: BlocBuilder<KehadiranBloc, KehadiranState>(
            builder: (context, state) {
              if (state.isLoading) return Container();

              if (state is RekapKehadiran &&
                  state.rekapKehadiran != null &&
                  state.rekapKehadiran!.isNotEmpty) {
                return viewRekapKehadiran(state.rekapKehadiran!);
              }

              if (state is KehadiranHarianVerified &&
                  state.kehadiranHarian != null &&
                  state.kehadiranHarian!.isNotEmpty) {
                return viewKehadiranHarian(state.kehadiranHarian!);
              }

              if (state is CekAbsenHarian &&
                  state.attandances != null &&
                  state.attandances!.isNotEmpty) {
                return viewCekAbsensiHarian(state.attandances!);
              }

              return Container();
            },
          ),
        ),
      ),
    );
  }

  Table viewRekapKehadiran(List<RekapKehadiranModel> rekapKehadiran) {
    return Table(
      columnWidths: const {1: FixedColumnWidth(80)},
      children: [
        TableRow(
            decoration: BoxDecoration(color: Colors.grey[200]),
            children: ['Keterangan', 'Jumlah']
                .map((e) => Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        e,
                        textAlign: e == 'Jumlah' ? TextAlign.center : null,
                        style: const TextStyle(fontWeight: FontWeight.w600),
                      ),
                    ))
                .toList()),
        ...(rekapKehadiran
            .where((element) => element.ATEXT.isNotEmpty)
            .toList()
            .asMap()
            .entries
            .map((e) {
          var value = e.value;
          return TableRow(
              decoration: e.key % 2 == 1
                  ? BoxDecoration(color: Colors.grey[100])
                  : null,
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(value.ATEXT),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    value.JUMLAH_HARI,
                    textAlign: TextAlign.center,
                  ),
                ),
              ]);
        }).toList())
      ],
    );
  }

  Table viewKehadiranHarian(List<RekapKehadiranHarianModel> kehadiranHarian) {
    return Table(
      defaultVerticalAlignment: TableCellVerticalAlignment.middle,
      columnWidths: const {
        1: FixedColumnWidth(80),
        2: FixedColumnWidth(80),
        3: FixedColumnWidth(80)
      },
      children: [
        TableRow(
            decoration: BoxDecoration(color: Colors.grey[200]),
            children: ['Hari', 'Absen', 'Status']
                .map((e) => Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        e,
                        textAlign: e != 'Hari' ? TextAlign.center : null,
                        style: const TextStyle(fontWeight: FontWeight.w600),
                      ),
                    ))
                .toList()),
        ...(kehadiranHarian.asMap().entries.map((e) {
          var value = e.value;
          return TableRow(
              decoration: e.key % 2 == 1
                  ? BoxDecoration(color: Colors.grey[100])
                  : null,
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child:
                      Text("${value.DAYTXT} \n${value.LDATE} ${value.LTIME}"),
                ),
                // Padding(
                //   padding: const EdgeInsets.all(8.0),
                //   child: Text(
                //     value.SATZA,
                //     textAlign: TextAlign.center,
                //   ),
                // ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    value.SCHKZ,
                    textAlign: TextAlign.center,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    value.STATUS,
                    textAlign: TextAlign.center,
                  ),
                ),
              ]);
        }).toList())
      ],
    );
  }

  Widget viewCekAbsensiHarian(List<AttendanceModel> list) {
    return ListView.separated(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      // padding: const EdgeInsets.symmetric(horizontal: 35, vertical: 12),
      itemCount: list.length,
      separatorBuilder: (BuildContext context, int index) {
        return const SizedBox(
          height: 20,
        );
      },
      itemBuilder: (BuildContext context, int index) {
        return laporanItem(attendanceModel: list[index]);
      },
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
