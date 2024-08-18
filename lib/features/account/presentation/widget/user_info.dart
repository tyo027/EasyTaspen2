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
          padding: const EdgeInsets.all(20),
          margin: const EdgeInsets.only(left: 24, right: 24, bottom: 24),
          width: double.infinity,
          decoration: BoxDecoration(
            color: Colors.amber[300],
            borderRadius: BorderRadius.circular(20),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Skeleton<SuccessState<Account>>(
                height: 80,
                width: 80,
                radius: 80,
                load: state is SuccessState<Account>,
                value: state,
                builder: (value) {
                  return Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(80),
                    ),
                    child: SvgWidget(
                      'assets/svgs/${value.data.gender == 'LAKI-LAKI' ? 'male' : 'female'}.svg',
                      useDefaultColor: true,
                      size: 80,
                    ),
                  );
                },
              ),
              const Gap(24),
              Flexible(
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
                          value.data.name.capitalize(),
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        );
                      },
                    ),
                    const Gap(5),
                    Skeleton<SuccessState<Account>>(
                      height: 14 * 1.5,
                      width: 80,
                      load: state is SuccessState<Account>,
                      value: state,
                      builder: (value) {
                        return Text(
                          value.data.position.capitalize(),
                          overflow: TextOverflow.ellipsis,
                        );
                      },
                    ),
                    const Gap(2),
                    Skeleton<SuccessState<Account>>(
                      height: 14 * 1.5,
                      width: 100,
                      load: state is SuccessState<Account>,
                      value: state,
                      builder: (value) {
                        return Text(
                          value.data.unit.capitalize(),
                          overflow: TextOverflow.ellipsis,
                        );
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
