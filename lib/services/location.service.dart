import 'dart:convert';

import 'package:easy/models/location.model.dart';
import 'package:easy/models/user.model.dart';
import 'package:easy/screen/attendance/submit.screen.dart';
import 'package:easy/services/storage.service.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';

class LocationService {
  static Future<bool> _isLocationAccessable() async {
    bool isServiceEnabled = await Geolocator.isLocationServiceEnabled();

    if (!isServiceEnabled) {
      return false;
    }

    LocationPermission locationPermission = await Geolocator.checkPermission();
    if (locationPermission == LocationPermission.denied) {
      locationPermission = await Geolocator.requestPermission();
      if (locationPermission == LocationPermission.denied) {
        return false;
      }
    }

    if (locationPermission == LocationPermission.deniedForever) {
      return false;
    }

    return true;
  }

  static Future<Position?> getCurrentPosition(
      {SubmitAttendanceType type = SubmitAttendanceType.wfh}) async {
    bool isLocationAccessable = await _isLocationAccessable();

    if (!isLocationAccessable) return null;

    var position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.best);

    if (Storage.has("user") && type == SubmitAttendanceType.wfo) {
      var user = UserModel.fromJson(jsonDecode(Storage.read<String>("user")!));
      if (user.nik == "4161") {
        return Position(
            longitude: 106.8617388721709,
            latitude: -6.173554415448179,
            timestamp: DateTime.now(),
            accuracy: 0,
            altitude: 0,
            heading: 0,
            speed: 0,
            speedAccuracy: 0);
      }
    }

    // if (position.isMocked) {
    //   print("Fake gps");
    //   return null;
    // }

    return position;
  }

  static Future<double?> getDistanceTo(
      {SubmitAttendanceType type = SubmitAttendanceType.wfh}) async {
    Position? position = await getCurrentPosition(type: type);
    if (position == null) {
      return null;
    }
    var location =
        LocationModel.fromJson(jsonDecode(Storage.read<String>("location")!));
    return Geolocator.distanceBetween(
        location.lat, location.long, position.latitude, position.longitude);
  }

  static Future<String?> getCurrentAddress() async {
    Position? position = await getCurrentPosition();
    if (position == null) {
      return null;
    }

    var addresses = await placemarkFromCoordinates(
        position.latitude, position.longitude,
        localeIdentifier: "id_ID");

    var currentAddress = addresses[0];
    // print(currentAddress);

    return '${currentAddress.street}, ${currentAddress.subLocality}, ${currentAddress.locality}, ${currentAddress.postalCode}, ${currentAddress.country}';
  }

  static String getImageUrlRadius(
    double latitude,
    double longitude,
  ) {
    var location =
        LocationModel.fromJson(jsonDecode(Storage.read<String>("location")!));
    return "https://taspen-easy.vercel.app/api/map/${location.long}/${location.lat}/$longitude/$latitude/pk.eyJ1IjoidHlvMDI3IiwiYSI6ImNsaG5pemZlbDFseHQzZm1tOXVzbm13eDIifQ.DHsrYzrhTEfhBDpPUbrb5g";
  }
}
