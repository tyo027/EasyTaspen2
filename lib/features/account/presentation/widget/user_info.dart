import 'package:easy/core/common/entities/user.dart';
import 'package:easy/core/common/widgets/svg_widget.dart';
import 'package:easy/extension.dart';
import 'package:easy/features/account/domain/entities/account.dart';
import 'package:easy/features/account/presentation/bloc/account_bloc.dart';
import 'package:fca/fca.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';

class UserInfo extends StatefulWidget {
  final User user;
  const UserInfo({
    super.key,
    required this.user,
  });

  @override
  State<UserInfo> createState() => _UserInfoState();
}

class _UserInfoState extends State<UserInfo> {
  @override
  void initState() {
    super.initState();

    final accountBloc = context.read<AccountBloc>();

    if (accountBloc.state is InitialState) {
      accountBloc.add(GetAccount(nik: widget.user.nik));
    }
  }

  @override
  Widget build(BuildContext context) {
    return BaseConsumer<AccountBloc, Account>(
      loading: false,
      builder: (context, state) {
        return Container(
          height: 100,
          padding: const EdgeInsets.all(16),
          margin: const EdgeInsets.only(left: 24, right: 24, top: 8),
          width: double.infinity,
          decoration: BoxDecoration(
            color: Colors.amber[300],
            borderRadius: BorderRadius.circular(20),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Skeleton<SuccessState<Account>>(
                height: 68,
                width: 68,
                radius: 68,
                load: state is SuccessState<Account>,
                value: state,
                builder: (value) {
                  return Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(68),
                    ),
                    child: SvgWidget(
                      'assets/svgs/${value.data.gender == 'LAKI-LAKI' ? 'male' : 'female'}.svg',
                      useDefaultColor: true,
                      size: 68,
                    ),
                  );
                },
              ),
              const Gap(16),
              Expanded(
                child: SingleChildScrollView(
                  scrollDirection: Axis.vertical,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Skeleton<SuccessState<Account>>(
                        height: 16 * 1.5,
                        width: 160,
                        load: state is SuccessState<Account>,
                        value: state,
                        builder: (value) {
                          return Text(
                            value.data.name.isEmpty
                                ? widget.user.nama.capitalize()
                                : value.data.name.capitalize(),
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          );
                        },
                      ),
                      const Gap(4),
                      Skeleton<SuccessState<Account>>(
                        height: 14 * 1.5,
                        width: 80,
                        load: state is SuccessState<Account>,
                        value: state,
                        builder: (value) {
                          return Text(
                            value.data.position.isEmpty
                                ? widget.user.jabatan.capitalize()
                                : value.data.position.capitalize(),
                          );
                        },
                      ),
                      const Gap(1),
                      Skeleton<SuccessState<Account>>(
                        height: 14 * 1.5,
                        width: 100,
                        load: state is SuccessState<Account>,
                        value: state,
                        builder: (value) {
                          return Text(
                            value.data.unit.isEmpty
                                ? widget.user.unitKerja.capitalize()
                                : value.data.unit.capitalize(),
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
