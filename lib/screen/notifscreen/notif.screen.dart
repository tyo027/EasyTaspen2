import 'package:easy/Widget/userinfo.template.dart';
import 'package:easy/bloc/authentication_bloc.dart';
import 'package:easy/models/notification.model.dart';
import 'package:easy/repositories/notification.repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class NotifScreen extends StatelessWidget {
  const NotifScreen({super.key});

  static Route<void> route() =>
      MaterialPageRoute(builder: (_) => const NotifScreen());

  Future<List<NotificationModel>?> _getNotification(
      {required String nik}) async {
    return NotificationRepository().getNotification(nik: nik);
  }

  @override
  Widget build(BuildContext context) {
    return UserInfoTemplate(
      showUserInfo: false,
      child: BlocBuilder<AuthenticationBloc, AuthenticationState>(
        builder: (context, state) {
          if (state is Authenticated) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                notifHeader(),
                FutureBuilder(
                  future: _getNotification(nik: state.user.nik),
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
                    print(snapshot.data);
                    if (snapshot.data.length == 0) {
                      return const Center(child: Text("Data Belum Tersedia"));
                    }
                    return Expanded(
                        child: ListView.separated(
                      itemCount: snapshot.data.length,
                      separatorBuilder: (BuildContext context, int index) {
                        return const Divider(
                          height: 0,
                          thickness: 1,
                        );
                      },
                      itemBuilder: (BuildContext context, int index) {
                        return notifFill(
                            notificationModel: snapshot.data[index]);
                      },
                    ));
                  },
                ),
              ],
            );
          }

          return Container();
        },
      ),
    );
  }

  Container notifFill({required NotificationModel notificationModel}) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 40),
      // margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 2),
      width: double.infinity,
      decoration: BoxDecoration(
          color: notificationModel.flag == "1" ? null : Colors.blueGrey[50]),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(notificationModel.title,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
              )),
          Text(notificationModel.date,
              style: const TextStyle(
                  //fontSize: 14,
                  // fontWeight: FontWeight.w500,
                  )),
          const SizedBox(
            height: 10,
          ),
          Text(notificationModel.body,
              style: const TextStyle(
                  //fontSize: 16,
                  // fontWeight: FontWeight.w500,
                  )),
        ],
      ),
    );
  }

  Widget notifHeader() {
    return Container(
      padding: const EdgeInsets.all(20),
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 2),
      width: double.infinity,
      child: const Text(
        "Notification",
        style: TextStyle(
          fontSize: 25,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }
}
