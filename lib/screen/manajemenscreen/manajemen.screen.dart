import 'package:easy/Widget/userinfo.template.dart';
import 'package:easy/extension.dart';
import 'package:easy/models/attendance.model.dart';
import 'package:easy/models/cekstaff.model.dart';
import 'package:easy/models/rekapkehadiran.model.dart';
import 'package:easy/models/rekapkehadiranharian.model.dart';
import 'package:easy/screen/manajemenscreen/bloc/manajemen_bloc.dart';
import 'package:easy/utils/show_loading.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:month_picker_dialog/month_picker_dialog.dart';

class ManajemenScreen extends StatelessWidget {
  const ManajemenScreen({super.key});

  static Route<void> route() =>
      MaterialPageRoute(builder: (_) => const ManajemenScreen());

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ManajemenBloc(),
      child: UserInfoTemplate(
        builder: (context, user) {
          context.read<ManajemenBloc>().add(
                LoadManajemenUserData(nik: user.nik),
              );
          return BlocConsumer<ManajemenBloc, ManajemenState>(
            builder: (context, manajemenState) {
              return Container(
                margin: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 10,
                ),
                child: Column(
                  children: [
                    _pilihStaffDropdown(context, manajemenState),
                    const SizedBox(
                      height: 10,
                    ),
                    _pilihLaporanType(manajemenState, context),
                    const SizedBox(
                      height: 10,
                    ),
                    if (manajemenState is SuccessState &&
                        [
                          LaporanType.REKAP_KEHADIRAN,
                          LaporanType.KEHADIRAN_HARIAN_VERIFIED
                        ].contains(manajemenState.selectedType))
                      cariTgl(context, manajemenState),
                    if (manajemenState is SuccessState &&
                        [
                          LaporanType.REKAP_KEHADIRAN,
                          LaporanType.KEHADIRAN_HARIAN_VERIFIED
                        ].contains(manajemenState.selectedType))
                      const SizedBox(
                        height: 10,
                      ),
                    cariBtn(context, manajemenState),
                    const SizedBox(
                      height: 20,
                    ),
                    if (manajemenState is SuccessState &&
                        (manajemenState.attendances != null ||
                            manajemenState.rekapKehadiran != null ||
                            manajemenState.listKehadiranHarian != null))
                      result(manajemenState)
                  ],
                ),
              );
            },
            listener: (context, state) {
              if (state is SuccessState &&
                  state.isLoading != null &&
                  state.isLoading == true) {
                showLoading(context);
              } else {
                Navigator.pop(context);
              }
            },
          );
        },
      ),
    );
  }

  Container _pilihLaporanType(
      ManajemenState manajemenState, BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      width: double.infinity,
      decoration: BoxDecoration(
          color: Colors.blueGrey[50], borderRadius: BorderRadius.circular(10)),
      child: DropdownButton<LaporanType>(
        isExpanded: true,
        value: manajemenState is! SuccessState
            ? LaporanType.CEK_ABSEN_HARIAN
            : manajemenState.selectedType ?? LaporanType.CEK_ABSEN_HARIAN,
        elevation: 16,
        style: const TextStyle(color: Colors.black),
        underline: Container(
          height: 0,
        ),
        onChanged: (LaporanType? type) {
          context.read<ManajemenBloc>().add(UpdateState(
                selectedType: type,
                tglMulai: null,
                tglAkhir: null,
                thnBln: null,
              ));
        },
        items: LaporanType.values
            .map((type) => DropdownMenuItem(
                  value: type,
                  child: Text(type.name
                      .split('_')
                      .map((e) => e.capitalize())
                      .join(" ")),
                ))
            .toList(),
      ),
    );
  }

  Container _pilihStaffDropdown(
      BuildContext context, ManajemenState manajemenState) {
    return Container(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        width: double.infinity,
        decoration: BoxDecoration(
            color: Colors.blueGrey[50],
            borderRadius: BorderRadius.circular(10)),
        child: DropdownButton<CekStaffModel>(
            isExpanded: true,
            value: manajemenState is SuccessState
                ? manajemenState.selectedStaff
                : null,
            elevation: 16,
            style: const TextStyle(color: Colors.black),
            underline: Container(
              height: 0,
            ),
            onChanged: (value) {
              context.read<ManajemenBloc>().add(
                    UpdateState(
                      selectedStaff: value,
                    ),
                  );
            },
            items: [
              const DropdownMenuItem(child: Text('Pilih Staff')),
              ...(manajemenState is SuccessState && manajemenState.staff != null
                  ? manajemenState.staff!
                      .map((type) => DropdownMenuItem(
                            value: type,
                            child: Text("${type.nama} (${type.positionname})"),
                          ))
                      .toList()
                  : [])
            ]));
  }

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
      context.read<ManajemenBloc>().add(UpdateState(thnBln: selectedDate));
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

          context.read<ManajemenBloc>().add(UpdateState(
                tglMulai: selectedDate.start,
                tglAkhir: selectedDate.end,
              ));
        });
      }

      if (type == "BULAN") {
        monthPicker(context: context, initialDate: startDate)
            .then((selectedDate) {
          if (selectedDate == null) return;

          var startTime = selectedDate.copyWith(day: 1);
          var endTime = startTime.copyWith(month: startTime.month + 1, day: 0);

          context.read<ManajemenBloc>().add(UpdateState(
              tglMulai: startTime,
              tglAkhir:
                  DateTime.now().isBefore(endTime) ? DateTime.now() : endTime));
        });
      }
    });
  }

  Widget cariTgl(BuildContext context, SuccessState state) {
    return GestureDetector(
      onTap: () async {
        if (state.selectedType == LaporanType.REKAP_KEHADIRAN) {
          findMounthDialog(context, state.thnBln);
          return;
        }
        if (state.selectedType == LaporanType.KEHADIRAN_HARIAN_VERIFIED) {
          findDateRangeDialog(context, state.tglMulai, state.tglAkhir);
          return;
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
            Text(state.selectedType == LaporanType.REKAP_KEHADIRAN
                ? state.thnBln == null
                    ? "Bulan / Tahun "
                    : DateFormat("MMMM yyyy").format(state.thnBln!)
                : state.selectedType == LaporanType.KEHADIRAN_HARIAN_VERIFIED
                    ? state.tglMulai == null
                        ? 'Dari s/d Sampai'
                        : '${DateFormat("dd MMM yyyy").format(state.tglMulai!)} s/d ${DateFormat("dd MMM yyyy").format(state.tglAkhir!)}'
                    : ""),
            Icon(
              Icons.calendar_month_outlined,
              color: Colors.grey[700],
            ),
          ],
        ),
      ),
    );
  }

  Widget cariBtn(BuildContext context, ManajemenState manajemenState) {
    return GestureDetector(
      onTap: () {
        if (manajemenState is SuccessState &&
            manajemenState.selectedStaff != null &&
            manajemenState.selectedType != null &&
            (manajemenState.selectedType == LaporanType.REKAP_KEHADIRAN &&
                    manajemenState.thnBln != null ||
                manajemenState.selectedType ==
                        LaporanType.KEHADIRAN_HARIAN_VERIFIED &&
                    manajemenState.tglAkhir != null &&
                    manajemenState.tglMulai != null ||
                manajemenState.selectedType == LaporanType.CEK_ABSEN_HARIAN)) {
          context.read<ManajemenBloc>().add(Search());
        }
      },
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
            color: manajemenState is SuccessState &&
                    manajemenState.selectedStaff != null &&
                    manajemenState.selectedType != null &&
                    (manajemenState.selectedType ==
                                LaporanType.REKAP_KEHADIRAN &&
                            manajemenState.thnBln != null ||
                        manajemenState.selectedType ==
                                LaporanType.KEHADIRAN_HARIAN_VERIFIED &&
                            manajemenState.tglAkhir != null &&
                            manajemenState.tglMulai != null ||
                        manajemenState.selectedType ==
                            LaporanType.CEK_ABSEN_HARIAN)
                ? Colors.blue[300]
                : Colors.grey,
            borderRadius: BorderRadius.circular(10)),
        child: const Center(
          child: Text(style: TextStyle(fontWeight: FontWeight.bold), 'Cari'),
        ),
      ),
    );
  }

  Widget result(SuccessState manajemenState) {
    return Expanded(
      flex: 1,
      child: SingleChildScrollView(
        child: Container(
          width: double.infinity,
          margin: const EdgeInsets.only(bottom: 8),
          child: manajemenState.selectedType == LaporanType.CEK_ABSEN_HARIAN
              ? viewCekAbsensiHarian(manajemenState.attendances ?? [])
              : manajemenState.selectedType == LaporanType.REKAP_KEHADIRAN
                  ? viewRekapKehadiran(manajemenState.rekapKehadiran ?? [])
                  : manajemenState.selectedType ==
                          LaporanType.KEHADIRAN_HARIAN_VERIFIED
                      ? viewKehadiranHarian(
                          manajemenState.listKehadiranHarian ?? [])
                      : null,
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
          children: [
            Text("Waktu Absen: ${attendanceModel.attendanceTime}"),
            Text("Status SAP: ${attendanceModel.statusSap}"),
            Text("Absensi: ${attendanceModel.type.name.toUpperCase()}")
          ],
        ));
  }
}
