import 'package:easy/Widget/userinfo.template.dart';
import 'package:easy/bloc/authentication_bloc.dart';
import 'package:easy/models/golongan.model.dart';
import 'package:easy/repositories/profile.repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class GolonganScreen extends StatelessWidget {
  const GolonganScreen({super.key});

  static Route<void> route() =>
      MaterialPageRoute(builder: (_) => const GolonganScreen());

  Future<List<GolonganModel>?> _getGolongan({required String nik}) async {
    return ProfileRepository().getGolongan(nik: nik);
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
            future: _getGolongan(nik: state.user!.nik),
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
              if (snapshot.data.length == 0) {
                return const Center(child: Text("Data Belum Tersedia"));
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
                  return laporanItem(golonganModel: snapshot.data[index]);
                },
              );
            },
          );
        },
      ),
    );
  }

  Widget laporanItem({required GolonganModel golonganModel}) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 30),
      width: double.infinity,
      decoration: BoxDecoration(
          border: Border.all(color: Colors.black45),
          borderRadius: BorderRadius.circular(20)),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Column(
            children: [
              const Text("Golongan"),
              Text(
                golonganModel.golongan,
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
              Text("DARI: ${golonganModel.tglMulai}"),
              Text("SAMPAI: ${golonganModel.tglAkhir}"),
              Text(
                  "${golonganModel.tahun} Tahun, ${golonganModel.bulan} Bulan,"),
              Text("${golonganModel.hari} Hari")
            ],
          ),
        ],
      ),
    );
  }
}
