import 'package:easy/core/common/pages/auth_page.dart';
import 'package:easy/features/account/domain/entities/position.dart';
import 'package:easy/features/account/presentation/bloc/position_bloc.dart';
import 'package:fca/fca.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';

class PositionPage extends StatelessWidget {
  const PositionPage({super.key});

  static route() =>
      MaterialPageRoute(builder: (context) => const PositionPage());

  @override
  Widget build(BuildContext context) {
    return AuthPage(
      title: "Jabatan",
      builder: (context, user) {
        context.read<PositionBloc>().add(GetPosition(nik: user.nik));

        return [
          BaseConsumer<PositionBloc, List<Position>>(
            builder: (context, state) {
              if (state is SuccessState<List<Position>>) {
                if (state.data.isEmpty) {
                  return const Center(child: Text("Data Belum Tersedia"));
                }
                return laporanItem(positions: state.data);
              }
              return const Gap(0);
            },
          )
        ];
      },
    );
  }

  Widget laporanItem({required List<Position> positions}) {
    return Padding(
      padding: const EdgeInsets.only(
        left: 24,
        right: 24,
        bottom: 12,
      ),
      child: ListView.separated(
        physics: const NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        itemCount: positions.length,
        separatorBuilder: (BuildContext context, int index) {
          return Container(
            color: Colors.black45,
            height: 1,
          );
        },
        itemBuilder: (BuildContext context, int index) {
          return position(position: positions[index]);
        },
      ),
    );
  }

  Widget position({required Position position}) {
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
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text("DARI:"),
              Text("${position.tglMulai}\n"),
              const Text("SAMPAI:"),
              Text(position.tglAkhir),
            ],
          ),
          const SizedBox(
            width: 35,
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  position.namaJabatan,
                  style: TextStyle(
                      color: Colors.amber[700],
                      fontSize: 20,
                      fontWeight: FontWeight.bold),
                  overflow: TextOverflow.fade,
                  maxLines: 4,
                  softWrap: true,
                ),
                Text(
                  position.unitKerja,
                  overflow: TextOverflow.fade,
                  maxLines: 5,
                  softWrap: true,
                ),
                Text(
                    "${position.tahunKerja} Tahun, ${position.bulanKerja} Bulan,",
                    style: TextStyle(
                      color: Colors.amber[700],
                    )),
                Text("${position.hariKerja} Hari",
                    style: TextStyle(
                      color: Colors.amber[700],
                    )),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
