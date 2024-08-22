import 'package:flutter_dotenv/flutter_dotenv.dart';

class Api {
  static final String _baseUrl = dotenv.env['API_BASE_URL'] ?? '';

  static final String login = "$_baseUrl/loginAD/1.0/ApiLoginADPublic";
  static final String deviceId = "$_baseUrl/absensi/1.0/DeviceId";

  static final String profile = "$_baseUrl/InternalSDM/1.0/ApiIdentitas";
  static final String position = "$_baseUrl/InternalSDM/1.0/ApiJabatan";
  static final String golongan = "$_baseUrl/InternalSDM/1.0/ApiGolongan";

  static final String rule = "$_baseUrl/absensi/1.0/rules";
  static final String mpp = "$_baseUrl/absensi/1.0/CekAbsenCustom";

  static final String employee = "$_baseUrl/absensi/1.0/employeeBawahan";

  static final String isAdmin = "$_baseUrl/absensi/1.0/GetUserAdmin";

  static final String submitAttendance = "$_baseUrl/absensi/1.0/SbmtAbsnNw";
  static final String dailyAttendance = "$_baseUrl/absensi/1.0/cekAbsenHarian";
  static final String attendanceRecap = "$_baseUrl/absensi/1.0/rekapKehadiran";
  static final String dailyRecap = "$_baseUrl/absensi/1.0/rekapKehadiranHarian";
}
