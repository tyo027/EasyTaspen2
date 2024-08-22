import 'package:easy/core/common/pages/auth_page.dart';
import 'package:easy/features/account/domain/entities/account.dart';
import 'package:easy/features/account/presentation/bloc/account_bloc.dart';
import 'package:fca/fca.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

class IndividuPage extends StatelessWidget {
  const IndividuPage({super.key});

  static String route = '/account/individu';

  @override
  Widget build(BuildContext context) {
    return AuthPage(
      title: "Profil Individu",
      builder: (context, user) {
        return [
          BaseConsumer<AccountBloc, Account>(
            builder: (context, state) {
              if (state is SuccessState<Account>) {
                return laporanItem(account: state.data);
              }
              return const Gap(0);
            },
          )
        ];
      },
    );
  }

  Widget laporanItem({required Account account}) {
    var details = [
      ["NAMA", account.name],
      ["JENIS KELAMIN", account.gender],
      ["ALAMAT", account.address],
      ["TEMPAT LAHIR", account.birthPlace],
      ["TANGGAL LAHIR", account.birthDate],
      ["STATUS PERNIKAHAN", account.marital],
      ["AGAMA", account.religion],
      ["SEKOLAH", account.school],
      ["STRATA", account.strata],
      ["GOLONGAN DARAH", account.blood],
      ["AREA", account.area],
      ["GRADE", account.grade],
      ["KTP", account.ktp],
      ["JAMSOSTEK", account.jamsostek],
      ["NPWP", account.npwp],
      ["JABATAN", account.position],
      ["TMT", account.tmt],
      ["UNIT", account.unit],
      ["STATUS PEGAWAI", account.work],
    ];
    return Padding(
      padding: const EdgeInsets.only(left: 24, right: 24, bottom: 12),
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(color: Colors.black45),
          borderRadius: BorderRadius.circular(20),
        ),
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
              value: details.elementAt(index).last,
            );
          },
        ),
      ),
    );
  }

  Widget individuProfile({
    required String title,
    required String value,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
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
