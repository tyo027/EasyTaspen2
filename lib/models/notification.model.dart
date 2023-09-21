import 'package:equatable/equatable.dart';

notificationModelFromJson(List<dynamic> list) => List<NotificationModel>.from(
    list.map((json) => NotificationModel.fromJson(json)));

class NotificationModel extends Equatable {
  final int id;
  final String nik;
  final String title;
  final String body;
  final String date;
  final String flag;

  const NotificationModel({
    required this.id,
    required this.nik,
    required this.title,
    required this.body,
    required this.date,
    required this.flag,
  });

  static NotificationModel fromJson(Map<String, dynamic> json) =>
      NotificationModel(
        id: json['id'],
        nik: json['nik'],
        title: json['title'],
        body: json['body'],
        date: json['date'],
        flag: json['flag'],
      );

  @override
  List<Object> get props => [
        id,
        nik,
        title,
        body,
        date,
        flag,
      ];
}

// var notifications = [
//   const NotificationModel(
//       id: '1',
//       nik: '4161',
//       title: 'Peringatan Absensi Bulanan',
//       body:
//           'Anda telah melewati batas lupa absen sebanyak x kali dalam bulan y wkwkwk',
//       date: '2023-10-01',
//       flag: '1'),
//   const NotificationModel(
//       id: '2',
//       nik: '4161',
//       title: 'Peringatan Absensi Bulanan',
//       body:
//           'Anda telah melewati batas lupa absen sebanyak x kali dalam bulan y wkwkwk',
//       date: '2023-10-02',
//       flag: '1'),
//   const NotificationModel(
//       id: '3',
//       nik: '4161',
//       title: 'Peringatan Absensi Bulanan',
//       body:
//           'Anda telah melewati batas lupa absen sebanyak x kali dalam bulan y wkwkwk',
//       date: '2023-10-03',
//       flag: '1'),
//   const NotificationModel(
//       id: '4',
//       nik: '4161',
//       title: 'Peringatan Absensi Bulanan',
//       body:
//           'Anda telah melewati batas lupa absen sebanyak x kali dalam bulan y wkwkwk',
//       date: '2023-10-04',
//       flag: '0'),
//   const NotificationModel(
//       id: '5',
//       nik: '4161',
//       title: 'Peringatan Absensi Bulanan',
//       body:
//           'Anda telah melewati batas lupa absen sebanyak x kali dalam bulan y wkwkwk',
//       date: '2023-10-04',
//       flag: '0')
// ];
