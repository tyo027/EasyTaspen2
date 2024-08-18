import 'package:easy/core/common/pages/auth_page.dart';
import 'package:easy/features/account/domain/entities/golongan.dart';
import 'package:easy/features/account/presentation/bloc/golongan_bloc.dart';
import 'package:fca/fca.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';

class GolonganPage extends StatelessWidget {
  const GolonganPage({super.key});

  static route() =>
      MaterialPageRoute(builder: (context) => const GolonganPage());

  @override
  Widget build(BuildContext context) {
    return AuthPage(
      title: "Golongan",
      builder: (context, user) {
        context.read<GolonganBloc>().add(GetGolongan(nik: user.nik));

        return [
          BaseConsumer<GolonganBloc, List<Golongan>>(
            builder: (context, state) {
              if (state is SuccessState<List<Golongan>>) {
                if (state.data.isEmpty) {
                  return const Center(child: Text("Data Belum Tersedia"));
                }
                return laporanItem(golongans: state.data);
              }
              return const Gap(0);
            },
          )
        ];
      },
    );
  }

  Widget laporanItem({required List<Golongan> golongans}) {
    return Padding(
      padding: const EdgeInsets.only(
        left: 24,
        right: 24,
        bottom: 12,
      ),
      child: ListView.separated(
        physics: const NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        itemCount: golongans.length,
        separatorBuilder: (BuildContext context, int index) {
          return Gap(10);
        },
        itemBuilder: (BuildContext context, int index) {
          return golongan(golongan: golongans[index]);
        },
      ),
    );
  }

  Widget golongan({required Golongan golongan}) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
      width: double.infinity,
      decoration: BoxDecoration(
        border: Border.all(color: Colors.black45),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Column(
            children: [
              const Text("Golongan"),
              Text(
                golongan.golongan,
                style: TextStyle(
                    color: Colors.amber[700],
                    fontSize: 20,
                    fontWeight: FontWeight.bold),
              ),
            ],
          ),
          const SizedBox(
            width: 40,
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("DARI: ${golongan.tglMulai}"),
              Text("SAMPAI: ${golongan.tglAkhir}"),
              Text("${golongan.tahun} Tahun, ${golongan.bulan} Bulan,"),
              Text("${golongan.hari} Hari")
            ],
          ),
        ],
      ),
    );
  }
}
