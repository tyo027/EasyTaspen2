// ignore_for_file: use_build_context_synchronously

import 'package:easy/Widget/userinfo.template.dart';
import 'package:easy/app.dart';
import 'package:easy/bloc/authentication_bloc.dart';
import 'package:easy/repositories/payslip.repository.dart';
import 'package:easy/screen/payslip/bloc/payslip_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:month_picker_dialog_2/month_picker_dialog_2.dart';

class PasySlipScreen extends StatelessWidget {
  const PasySlipScreen({super.key});

  static Route<void> route() =>
      MaterialPageRoute(builder: (_) => const PasySlipScreen());

  Future<String?> _getPaySlip(
      {required String nik, required String thnbln}) async {
    return PaySlipRepository().paySlipRepository(nik: nik, thnbln: thnbln);
  }

  @override
  Widget build(BuildContext context) {
    return UserInfoTemplate(child: paySlipMenu(context));
  }

  Widget paySlipMenu(BuildContext context) {
    return BlocProvider(
      create: (context) => PayslipBloc(),
      child: SingleChildScrollView(
        child: Column(
          children: [
            serachMontYear(),
            payslipView(),
          ],
        ),
      ),
    );
  }

  BlocBuilder<PayslipBloc, PayslipState> payslipView() {
    return BlocBuilder<PayslipBloc, PayslipState>(
      builder: (context, state) {
        if (state.thnbln == "" || state.payslip == "") {
          return Container();
        }
        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          margin: const EdgeInsets.symmetric(horizontal: 35, vertical: 10),
          width: double.infinity,
          decoration: BoxDecoration(
              border: Border.all(color: Colors.black45),
              borderRadius: BorderRadius.circular(20)),
          child: Html(data: state.payslip),
        );
      },
    );
  }

  Widget serachMontYear() {
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
            context.read<PayslipBloc>().add(ThnBlnChanged(thnbln: thnbln));
            var payslip = await _getPaySlip(
              nik: state.user!.nik,
              thnbln: thnbln,
            );

            if (payslip == null) {
              ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text("Data tidak tersedia")));
              return;
            }
            context.read<PayslipBloc>().add(PaySlipChanged(payslip: payslip));
            navigator.pop();
          },
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            margin: const EdgeInsets.symmetric(horizontal: 35, vertical: 10),
            width: double.infinity,
            decoration: BoxDecoration(
                border: Border.all(color: Colors.black45),
                borderRadius: BorderRadius.circular(20)),
            child: Row(
              children: [
                Icon(
                  Icons.calendar_month_outlined,
                  color: Colors.grey[600],
                ),
                const SizedBox(
                  width: 20,
                ),
                Expanded(child: BlocBuilder<PayslipBloc, PayslipState>(
                  builder: (context, state) {
                    return Text(state.thnbln == ""
                        ? "Bulan/Tahun"
                        : "${state.thnbln.substring(0, 4)} / ${state.thnbln.substring(4, 6)}");
                  },
                )),
              ],
            ),
          ),
        );
      },
    );
  }
}
