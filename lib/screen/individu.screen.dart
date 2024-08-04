import 'package:easy/Widget/userinfo.template.dart';
import 'package:easy/bloc/authentication_bloc.dart';
import 'package:easy/models/profile.model.dart';
import 'package:easy/models/user.model.dart';
import 'package:easy/repositories/profile.repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class IndividuScreen extends StatelessWidget {
  const IndividuScreen({super.key});

  static Route<void> route() =>
      MaterialPageRoute(builder: (_) => const IndividuScreen());

  Future<ProfileModel?> _getProfile(
      {required String nik, required UserModel user}) async {
    if (!user.isActive) {
      return Future.value(ProfileModel(
          alamat: "-",
          area: "Pusat",
          birthdate: "-",
          birthplace: "-",
          blood: "-",
          gender: user.gender,
          grade: "-",
          jamsostek: "-",
          ktp: "-",
          marital: "-",
          name: user.nama,
          npwp: "-",
          work: '-',
          position: user.jabatan,
          religion: '-',
          school: '-',
          strata: '-',
          tmt: '-',
          unit: '-'));
    }

    return ProfileRepository().getProfile(nik: nik);
  }

  @override
  Widget build(BuildContext context) {
    return UserInfoTemplate(
      child: BlocBuilder<AuthenticationBloc, AuthenticationState>(
        builder: (context, state) {
          if (state is Authenticated) {
            return FutureBuilder(
              future: _getProfile(nik: state.user.nik, user: state.user),
              initialData: null,
              builder: (BuildContext context, AsyncSnapshot snapshot) {
                if (snapshot.data == null) {
                  return const Center(
                    child: SizedBox(
                      width: 50,
                      height: 50,
                      child: CircularProgressIndicator(),
                    ),
                  );
                }
                return laporanItem(profileModel: snapshot.data);
              },
            );
          }

          return Container();
        },
      ),
    );
  }

  Widget laporanItem({required ProfileModel profileModel}) {
    var details = [
      ["NAMA", profileModel.name],
      ["JENIS KELAMIN", profileModel.gender],
      ["ALAMAT", profileModel.alamat],
      ["TEMPAT LAHIR", profileModel.birthplace],
      ["TANGGAL LAHIR", profileModel.birthdate],
      ["STATUS PERNIKAHAN", profileModel.marital],
      ["AGAMA", profileModel.religion],
      ["SEKOLAH", profileModel.school],
      ["STRATA", profileModel.strata],
      ["GOLONGAN DARAH", profileModel.blood],
      ["AREA", profileModel.area],
      ["GRADE", profileModel.grade],
      ["KTP", profileModel.ktp],
      ["JAMSOSTEK", profileModel.jamsostek],
      ["NPWP", profileModel.npwp],
      ["JABATAN", profileModel.position],
      ["TMT", profileModel.tmt],
      ["UNIT", profileModel.unit],
      ["STATUS PEGAWAI", profileModel.work],
    ];
    return Padding(
      padding: const EdgeInsets.only(left: 35, right: 35, bottom: 12, top: 12),
      child: SingleChildScrollView(
        child: Container(
          width: double.infinity,
          decoration: BoxDecoration(
              border: Border.all(color: Colors.black45),
              borderRadius: BorderRadius.circular(20)),
          child: ListView.separated(
            physics: const NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            itemCount: details.length,
            separatorBuilder: (BuildContext context, int index) {
              return Container(
                color: Colors.black45,
                height: 1,
              );
            },
            itemBuilder: (BuildContext context, int index) {
              return individuProfile(
                  title: details.elementAt(index).first,
                  value: details.elementAt(index).last);
            },
          ),
        ),
      ),
    );
  }

  Widget individuProfile({
    required String title,
    required String value,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 30),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("$title:", style: TextStyle(color: Colors.blueAccent[400])),
          Text(value),
        ],
      ),
    );
  }
}
