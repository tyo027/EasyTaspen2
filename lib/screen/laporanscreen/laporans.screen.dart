import 'package:easy/Widget/userinfo.template.dart';
import 'package:easy/bloc/authentication_bloc.dart';
import 'package:easy/models/rekapkehadiran.model.dart';
import 'package:easy/repositories/attendance.repository.dart';
import 'package:easy/screen/laporanscreen/bloc/kehadiran_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:month_picker_dialog_2/month_picker_dialog_2.dart';

class LaporansScreen extends StatelessWidget {
  const LaporansScreen({super.key});

  static Route<void> route() =>
      MaterialPageRoute(builder: (_) => const LaporansScreen());

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
    return UserInfoTemplate(child: laporansMenu(context));
  }

  Widget laporansMenu(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          jenisRekap(),
          cariTgl(),
          cariBtn(),
        ],
      ),
    );
  }

  Widget cariTgl() {
    return BlocBuilder<AuthenticationBloc, AuthenticationState>(
      builder: (context, state) {
        return GestureDetector(
          onTap: () async {
            var date = await showMonthPicker(
              context: context,
              initialDate: DateTime.now().day < 25
                  ? DateTime.now().add(const Duration(days: -25))
                  : DateTime.now(),
              lastDate: DateTime.now().day < 25
                  ? DateTime.now().add(const Duration(days: -25))
                  : DateTime.now(),
            );
            if (date == null) return;
            var thnbln = "${date.year}${date.month.toString().padLeft(2, '0')}";
            showDialog(
              context: context,
              builder: (context) {
                return const Center(
                  child: SizedBox(
                      height: 50,
                      width: 50,
                      child: CircularProgressIndicator()),
                );
              },
            );
            context.read<KehadiranBloc>().add(
                  TglMulaiChanged(tglMulai: tglMulai),
                  TglAkhirChanged(tglAkhir: tglAkhir),
                );
            var payslip = await _getRekapKehadiran(
              nik: state.user!.nik,
              tglMulai: tglMulai,
            );

            if (payslip == null) {
              ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text("Data tidak tersedia")));
              navigator.pop();
              return;
            }
            context.read<PayslipBloc>().add(
                  TglMulaiChanged(tglMulai: tglMulai),
                  TglAkhirChanged(tglAkhir: tglAkhir),
                );
            navigator.pop();
          },
          child: Container(
            padding: const EdgeInsets.only(left: 20, top: 10, bottom: 10),
            margin: const EdgeInsets.symmetric(horizontal: 35, vertical: 10),
            width: double.infinity,
            decoration: BoxDecoration(
                color: Colors.blueGrey[50],
                // border: Border.all(color: Colors.black45),
                borderRadius: BorderRadius.circular(10)),
            child: Row(
              children: [
                Expanded(child: BlocBuilder<KehadiranBloc, KehadiranState>(
                  builder: (context, state) {
                    return Text(state.tglMulai == ""
                        ? "Dari/sampai"
                        : "${state.tglMulai.substring(0, 4)} / ${state.tglMulai.substring(4, 6)}");
                  },
                )),
                Icon(
                  Icons.calendar_month_outlined,
                  color: Colors.grey[700],
                ),
                const SizedBox(
                  width: 20,
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
        margin: const EdgeInsets.symmetric(horizontal: 35, vertical: 10),
        width: double.infinity,
        decoration: BoxDecoration(
            color: Colors.blueGrey[50],
            // border: Border.all(color: Colors.black45),
            borderRadius: BorderRadius.circular(10)),
        child: DropdownButton<String>(
            isExpanded: true,
            value: "1",
            // icon: const Icon(Icons.arrow_downward),
            elevation: 16,
            style: const TextStyle(color: Colors.black),
            underline: Container(
              height: 0,
            ),
            onChanged: (String? value) {
              // This is called when the user selects an item.
              // // setState(() {
              // //   dropdownValue = value!;
              // });
            },
            items: const [
              DropdownMenuItem<String>(
                value: "1",
                child: Text("Rekap Kehadiran Bulan"),
              ),
              DropdownMenuItem<String>(
                value: "2",
                child: Text("Rekap Kehadiran Harian"),
              )
            ]));
  }

  Widget cariBtn() {
    return Container(
      //padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      margin: const EdgeInsets.symmetric(horizontal: 35, vertical: 10),
      width: double.infinity,
      // decoration: BoxDecoration(
      //     border: Border.all(color: Colors.black45),
      //     borderRadius: BorderRadius.circular(20)),
      child: Flexible(
        child: GestureDetector(
          onTap: () async {
            //login(isFilled, context, state.userName, state.password);
          },
          child: Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
                color: Colors.blue[100],
                borderRadius: BorderRadius.circular(10)),
            child: const Center(
              child:
                  Text(style: TextStyle(fontWeight: FontWeight.bold), 'Cari'),
            ),
          ),
        ),
      ),
    );
  }
}
