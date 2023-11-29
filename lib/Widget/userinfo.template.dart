import 'package:easy/Widget/templatecopyright.dart';
import 'package:easy/app.dart';
import 'package:easy/bloc/authentication_bloc.dart';
import 'package:easy/extension.dart';
import 'package:easy/repositories/notification.repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';

class UserInfoTemplate extends StatelessWidget {
  const UserInfoTemplate({
    super.key,
    this.child,
    this.canBack = true,
    this.showUserInfo = true,
  });

  final Widget? child;
  final bool canBack;
  final bool showUserInfo;

  Future<int> getCountNotification(String nik) {
    return NotificationRepository().getCountNotification(nik: nik);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SafeArea(
      child: Templatecopyright(
          child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            height: 30,
            child: Row(children: [
              if (canBack)
                GestureDetector(
                  onTap: () => navigator.pop(),
                  child: Container(
                    padding: const EdgeInsets.all(6),
                    margin: const EdgeInsets.symmetric(horizontal: 25),
                    child: const Icon(Icons.arrow_back_rounded),
                  ),
                ),
              const Spacer(),
              // if (!canBack)
              //   GestureDetector(
              //     onTap: () => navigator.push(NotifScreen.route()),
              //     child: Stack(
              //       children: [
              //         Container(
              //           padding: const EdgeInsets.all(6),
              //           margin: const EdgeInsets.symmetric(horizontal: 25),
              //           child: const Icon(Icons.notifications_none_rounded),
              //         ),
              //         BlocBuilder<AuthenticationBloc, AuthenticationState>(
              //           builder: (context, state) {
              //             if (state.user == null) {
              //               return Container();
              //             }
              //             return FutureBuilder(
              //               future: getCountNotification(state.user!.nik),
              //               initialData: 0,
              //               builder:
              //                   (BuildContext context, AsyncSnapshot snapshot) {
              //                 return Positioned(
              //                   left: 42,
              //                   child: Container(
              //                       width: 23,
              //                       height: 23,
              //                       // padding: const EdgeInsets.all(3),
              //                       // margin: const EdgeInsets.symmetric(horizontal: 0),
              //                       decoration: BoxDecoration(
              //                           color: Colors.red,
              //                           borderRadius:
              //                               BorderRadius.circular(100)),
              //                       child: Center(
              //                         child: Text(
              //                           "${snapshot.data}",
              //                           style: TextStyle(color: Colors.white),
              //                         ),
              //                       )),
              //                 );
              //               },
              //             );
              //           },
              //         ),
              //       ],
              //     ),
              //   )
            ]),
          ),
          if (showUserInfo) userInfo(),
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
                    if (state is Authenticated) {
                      return SvgPicture.asset(state.user.gender == "LAKI-LAKI"
                          ? "assets/svgs/male.svg"
                          : "assets/svgs/female.svg");
                    }
                    return Container();
                  },
                )),
            const SizedBox(
              width: 20,
            ),
            Flexible(
              child: SizedBox(
                child: SingleChildScrollView(
                  scrollDirection: Axis.vertical,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      BlocBuilder<AuthenticationBloc, AuthenticationState>(
                        builder: (context, state) {
                          if (state is Authenticated) {
                            return SizedBox(
                              child: Text(
                                state.user.nama.capitalize(),
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 16),
                              ),
                            );
                          }

                          return Container();
                        },
                      ),
                      const SizedBox(
                        height: 5,
                      ),
                      BlocBuilder<AuthenticationBloc, AuthenticationState>(
                        builder: (context, state) {
                          if (state is Authenticated) {
                            if (state.user.jabatan == "" ||
                                state.user.jabatan == null) {
                              return SizedBox.shrink();
                            } else {
                              return SizedBox(
                                child: Text(
                                  state.user.jabatan.capitalize(),
                                ),
                              );
                            }
                          }
                          return Container();
                        },
                      ),
                      BlocBuilder<AuthenticationBloc, AuthenticationState>(
                        builder: (context, state) {
                          if (state is Authenticated) {
                            if (state.user.unitkerja == "" ||
                                state.user.unitkerja == null) {
                              return SizedBox.shrink();
                            } else {
                              return SizedBox(
                                child: Text(
                                  state.user.unitkerja.capitalize(),
                                ),
                              );
                            }
                          }
                          return Container();
                        },
                      ),
                    ],
                  ),
                ),
              ),
            )
          ],
        ));
  }
}
