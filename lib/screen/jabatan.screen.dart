import 'package:easy/Widget/userinfo.template.dart';
import 'package:easy/bloc/authentication_bloc.dart';
import 'package:easy/models/jabatan.model.dart';
import 'package:easy/repositories/profile.repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class JabatanScreen extends StatelessWidget {
  const JabatanScreen({super.key});

  static Route<void> route() =>
      MaterialPageRoute(builder: (_) => const JabatanScreen());

  Future<List<JabatanModel>?> _getJabatan({required String nik}) async {
    return ProfileRepository().getJabatan(nik: nik);
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
            future: _getJabatan(nik: state.user!.nik),
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
                  return laporanItem(jabatanModel: snapshot.data[index]);
                },
              );
            },
          );
        },
      ),
    );
  }

  Widget laporanItem({required JabatanModel jabatanModel}) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
      width: double.infinity,
      decoration: BoxDecoration(
          border: Border.all(color: Colors.black45),
          borderRadius: BorderRadius.circular(20)),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text("DARI:"),
              Text("${jabatanModel.tglMulai}\n"),
              const Text("SAMPAI:"),
              Text(jabatanModel.tglAkhir),
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
                  jabatanModel.namaJabatan,
                  style: TextStyle(
                      color: Colors.amber[700],
                      fontSize: 20,
                      fontWeight: FontWeight.bold),
                  overflow: TextOverflow.fade,
                  maxLines: 4,
                  softWrap: true,
                ),
                Text(
                  jabatanModel.unitKerja,
                  overflow: TextOverflow.fade,
                  maxLines: 5,
                  softWrap: true,
                ),
                // Text("${jabatanModel.nama_jabatan}",
                //     maxLines: 2,
                //     softWrap: true,
                //     overflow: TextOverflow.visible,
                //     style: TextStyle(
                //         color: Colors.amber[700],
                //         fontSize: 20,
                //         fontWeight: FontWeight.bold)),
                // Text(
                //   "${jabatanModel.unit_kerja}",
                //   maxLines: 2,
                //   softWrap: true,
                // ),
                Text(
                    "${jabatanModel.tahunKerja} Tahun, ${jabatanModel.bulanKerja} Bulan,",
                    style: TextStyle(
                      color: Colors.amber[700],
                    )),
                Text("${jabatanModel.hariKerja} Hari",
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
