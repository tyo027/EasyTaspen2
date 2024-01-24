import 'package:easy/models/notification.model.dart';
import 'package:easy/repositories/repository.dart';

class NotificationRepository extends Repository {
  Future<List<NotificationModel>?> getNotification(
      {required String nik}) async {
    try {
      var response = await dio.post("absensi/1.0/NotificationEasyMobile/$nik");
      //print(response.data);
      return notificationModelFromJson(response.data);
    } catch (e) {
      //print(e);
      return [];
    }
  }

  Future<int> getCountNotification({required String nik}) async {
    try {
      var response =
          await dio.post("absensi/1.0/CountNotificationEasyMobile/$nik");
      return response.data['count'];
    } catch (e) {
      return 0;
    }
  }
}
