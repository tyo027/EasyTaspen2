import 'package:easy/Widget/templatecopyright.dart';
import 'package:easy/app.dart';
import 'package:easy/bloc/authentication_bloc.dart';
import 'package:easy/extension.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';

class UserInfoTemplate extends StatelessWidget {
  const UserInfoTemplate({super.key, this.child, this.canBack = true});

  final Widget? child;
  final bool canBack;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SafeArea(
      child: Templatecopyright(
          child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (canBack)
            GestureDetector(
              onTap: () => navigator.pop(),
              child: Container(
                padding: const EdgeInsets.all(6),
                margin: const EdgeInsets.symmetric(horizontal: 25),
                child: const Icon(Icons.arrow_back_rounded),
              ),
            ),
          if (!canBack)
            const SizedBox(
              height: 36,
            ),
          userInfo(),
          if (child != null)
            Flexible(fit: FlexFit.tight, child: Container(child: child!)),
        ],
      )),
    ));
  }

  Container userInfo() {
    return Container(
        padding: const EdgeInsets.all(20),
        margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        width: double.infinity,
        height: 120,
        decoration: BoxDecoration(
            color: Colors.amber[300], borderRadius: BorderRadius.circular(20)),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
                width: 80,
                height: 80,
                clipBehavior: Clip.hardEdge,
                decoration:
                    BoxDecoration(borderRadius: BorderRadius.circular(40)),
                child: BlocBuilder<AuthenticationBloc, AuthenticationState>(
                  builder: (context, state) {
                    if (state.user == null) {
                      return Container();
                    }

                    return SvgPicture.asset(state.user!.gender == "LAKI-LAKI"
                        ? "assets/svgs/male.svg"
                        : "assets/svgs/female.svg");
                  },
                )),
            const SizedBox(
              width: 20,
            ),
            Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                BlocBuilder<AuthenticationBloc, AuthenticationState>(
                  builder: (context, state) {
                    if (state.user == null) {
                      return Container();
                    }
                    return SizedBox(
                      child: Text(
                        state.user!.nama.capitalize(),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 16),
                      ),
                    );
                  },
                ),
                const SizedBox(
                  height: 5,
                ),
                BlocBuilder<AuthenticationBloc, AuthenticationState>(
                  builder: (context, state) {
                    if (state.user == null) {
                      return Container();
                    }
                    return SizedBox(
                      child: Text(
                        state.user!.jabatan.capitalize(),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(),
                      ),
                    );
                  },
                ),
                BlocBuilder<AuthenticationBloc, AuthenticationState>(
                  builder: (context, state) {
                    if (state.user == null) {
                      return Container();
                    }
                    return SizedBox(
                      child: Text(
                        state.user!.unitkerja.capitalize(),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(),
                      ),
                    );
                  },
                ),
              ],
            )
          ],
        ));
  }
}
