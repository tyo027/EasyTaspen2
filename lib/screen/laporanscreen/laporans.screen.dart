import 'package:easy/Widget/userinfo.template.dart';
import 'package:easy/screen/laporanscreen/bloc/kehadiran_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:month_picker_dialog_2/month_picker_dialog_2.dart';

class LaporansScreen extends StatelessWidget {
  const LaporansScreen({super.key});

  static Route<void> route() =>
      MaterialPageRoute(builder: (_) => const LaporansScreen());

  Future<DateTime?> monthPicker(
          {required BuildContext context, DateTime? initialDate}) =>
      showMonthPicker(
        context: context,
        headerColor: Colors.amber,
        headerTextColor: Colors.black,
        initialDate: initialDate,
        lastDate: DateTime.now(),
        cancelText: const Text("Batal"),
        confirmText: const Text("Pilih"),
        roundedCornersRadius: 20,
        unselectedMonthTextColor: Colors.black,
        selectedMonthBackgroundColor: Colors.amber,
        selectedMonthTextColor: Colors.black,
      );

  void findMounthDialog(BuildContext context, DateTime? selected) {
    if (!context.mounted) return;

    monthPicker(context: context, initialDate: selected).then((selectedDate) {
      if (selectedDate == null) return;
      context.read<KehadiranBloc>().add(ThnBlnChanged(thnBln: selectedDate));
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

          context
              .read<KehadiranBloc>()
              .add(TglMulaiChanged(tglMulai: selectedDate.start));
          context
              .read<KehadiranBloc>()
              .add(TglAkhirChanged(tglAkhir: selectedDate.end));
        });
      }

      if (type == "BULAN") {
        monthPicker(context: context, initialDate: startDate)
            .then((selectedDate) {
          if (selectedDate == null) return;

          var startTime = selectedDate.copyWith(day: 1);
          var endTime = startTime.copyWith(month: startTime.month + 1, day: 0);

          context
              .read<KehadiranBloc>()
              .add(TglMulaiChanged(tglMulai: startTime));
          context.read<KehadiranBloc>().add(TglAkhirChanged(
              tglAkhir:
                  DateTime.now().isBefore(endTime) ? DateTime.now() : endTime));
        });
      }
    });
  }

  void findMonthly(BuildContext context, DateTime dateTime) {
    // TODO: LOGIC MONTHLY AMBIL API
  }

  void findDaily(BuildContext context, DateTime start, DateTime end) {
    // TODO: LOGIC DAILY AMBIL API
  }

  @override
  Widget build(BuildContext context) {
    return UserInfoTemplate(child: laporansMenu(context));
  }

  Widget laporansMenu(BuildContext context) {
    return BlocProvider(
      create: (context) => KehadiranBloc(),
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 24, vertical: 10),
        child: Column(
          mainAxisSize: MainAxisSize.max,
          children: [
            jenisRekap(),
            const SizedBox(
              height: 10,
            ),
            cariTgl(),
            const SizedBox(
              height: 10,
            ),
            cariBtn(),
            const SizedBox(
              height: 20,
            ),
            result()
          ],
        ),
      ),
    );
  }

  Widget cariTgl() {
    return BlocBuilder<KehadiranBloc, KehadiranState>(
      builder: (context, state) {
        return GestureDetector(
          onTap: () async {
            if (state.jenis == "REKAP_BULANAN") {
              findMounthDialog(context, state.thnBln);
            } else {
              findDateRangeDialog(context, state.tglMulai, state.tglAkhir);
            }

            // var date = await showMonthPicker(
            //   context: context,
            //   initialDate: DateTime.now().day < 25
            //       ? DateTime.now().add(const Duration(days: -25))
            //       : DateTime.now(),
            //   lastDate: DateTime.now().day < 25
            //       ? DateTime.now().add(const Duration(days: -25))
            //       : DateTime.now(),
            // );
            // if (date == null) return;
            // var thnbln = "${date.year}${date.month.toString().padLeft(2, '0')}";
            // showDialog(
            //   context: context,
            //   builder: (context) {
            //     return const Center(
            //       child: SizedBox(
            //           height: 50,
            //           width: 50,
            //           child: CircularProgressIndicator()),
            //     );
            //   },
            // );
            // context.read<KehadiranBloc>().add(
            //       TglMulaiChanged(tglMulai: tglMulai)
            //     );
            // var payslip = await _getRekapKehadiran(
            //   nik: state.user!.nik,
            //   tglMulai: tglMulai,
            // );

            // if (payslip == null) {
            //   ScaffoldMessenger.of(context).showSnackBar(
            //       const SnackBar(content: Text("Data tidak tersedia")));
            //   navigator.pop();
            //   return;
            // }
            // context.read<PayslipBloc>().add(
            //       TglMulaiChanged(tglMulai: tglMulai),
            //       TglAkhirChanged(tglAkhir: tglAkhir),
            //     );
            // navigator.pop();
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
                    return Text(state.jenis == 'REKAP_BULANAN'
                        ? state.thnBln == null
                            ? "Bulan / Tahun "
                            : DateFormat("MMMM yyyy").format(state.thnBln!)
                        : state.tglMulai == null
                            ? 'Dari s/d Sampai'
                            : '${DateFormat("dd MMM yyyy").format(state.tglMulai!)} s/d ${DateFormat("dd MMM yyyy").format(state.tglAkhir!)}');
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
            return DropdownButton<String>(
                isExpanded: true,
                value: state.jenis,
                elevation: 16,
                style: const TextStyle(color: Colors.black),
                underline: Container(
                  height: 0,
                ),
                onChanged: (String? value) {
                  if (value != null) {
                    context
                        .read<KehadiranBloc>()
                        .add(JenisChanged(jenis: value));
                  }
                },
                items: const [
                  DropdownMenuItem<String>(
                    value: "REKAP_BULANAN",
                    child: Text("Rekap Kehadiran Bulan"),
                  ),
                  DropdownMenuItem<String>(
                    value: "REKAP_HARIAN",
                    child: Text("Rekap Kehadiran Harian"),
                  )
                ]);
          },
        ));
  }

  Widget cariBtn() {
    return BlocBuilder<KehadiranBloc, KehadiranState>(
      builder: (context, state) {
        return GestureDetector(
          onTap: () {
            if (state.jenis == 'REKAP_BULANAN' && state.thnBln != null) {
              findMonthly(context, state.thnBln!);
            }
            if (state.jenis == 'REKAP_HARIAN' &&
                state.tglMulai != null &&
                state.tglAkhir != null) {
              findDaily(context, state.tglMulai!, state.tglAkhir!);
            }
          },
          child: Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
                color:
                    (state.jenis == 'REKAP_BULANAN' && state.thnBln != null) ||
                            (state.jenis == 'REKAP_HARIAN' &&
                                state.tglMulai != null &&
                                state.tglAkhir != null)
                        ? Colors.blue[300]
                        : Colors.grey,
                borderRadius: BorderRadius.circular(10)),
            child: const Center(
              child:
                  Text(style: TextStyle(fontWeight: FontWeight.bold), 'Cari'),
            ),
          ),
        );
      },
    );
  }

  Widget result() {
    return Expanded(
        flex: 1,
        child: Container(
          width: double.infinity,
          margin: const EdgeInsets.only(bottom: 8),
          color: Colors.amber,
          child: Text('Result here'),
        ));
  }
}
