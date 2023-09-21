import 'dart:convert';
import 'dart:math';
import 'dart:developer' as developer;
import 'package:easy/models/user.model.dart';
import 'package:easy/screen/attendance/submit.screen.dart';
import 'package:easy/services/storage.service.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:turf/helpers.dart' as turf;

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
      {SubmitAttendanceType type = SubmitAttendanceType.wfa}) async {
    bool isLocationAccessable = await _isLocationAccessable();

    if (!isLocationAccessable) return null;

    var position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.best);

    if (_user() != null && type == SubmitAttendanceType.wfo) {
      if (_user()!.nik == "4161") {
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

      if (position.isMocked && !_user()!.allowMock) {
        print("Fake gps");
        return null;
      }
    }

    return position;
  }

  static Future<double?> getDistanceTo(
      {SubmitAttendanceType type = SubmitAttendanceType.wfa}) async {
    Position? position = await getCurrentPosition(type: type);
    if (position == null) {
      return null;
    }

    if (_user() == null) {
      return null;
    }

    return Geolocator.distanceBetween(_user()!.latitude, _user()!.longitude,
        position.latitude, position.longitude);
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

  static String? getImageUrlRadius(
    double latitude,
    double longitude,
  ) {
    if (_user() == null) return null;
    var center = turf.Feature(
      id: 1,
      properties: {
        "marker-color": "#ff0000",
        "marker-size": "medium",
        "marker-symbol": "circle",
      },
      geometry: turf.Point(
          coordinates: turf.Position(
        _user()!.longitude,
        _user()!.latitude,
      )),
    );
    var circles = turf.Feature(
        id: 0,
        properties: {"fill-color": "#ff0000"},
        geometry: circle(
            latitude: _user()!.latitude,
            longitude: _user()!.longitude,
            radian: _user()!.radius));

    var curent = turf.Feature(
      id: 2,
      properties: {
        "marker-color": "#00b3ff",
        "marker-size": "large",
        "marker-symbol": "circle",
      },
      geometry: turf.Point(
          coordinates: turf.Position(
        longitude,
        latitude,
      )),
    );
    var collection = turf.FeatureCollection(features: [
      circles,
      center,
      curent,
    ]);
    //print(collection.toJson());
    return "https://api.mapbox.com/styles/v1/mapbox/streets-v12/static/geojson(${Uri.encodeComponent(json.encode(collection.toJson()))})/$longitude,$latitude,16/500x300?access_token=pk.eyJ1IjoidHlvMDI3IiwiYSI6ImNsaG5pemZlbDFseHQzZm1tOXVzbm13eDIifQ.DHsrYzrhTEfhBDpPUbrb5g";
    // developer.log(url);
    // developer.log(json.encode(collection.toJson()));
    // return "https://taspen-easy.vercel.app/api/map/${_user()!.longitude}/${_user()!.latitude}/$longitude/$latitude/${_user()!.radius}/pk.eyJ1IjoidHlvMDI3IiwiYSI6ImNsaG5pemZlbDFseHQzZm1tOXVzbm13eDIifQ.DHsrYzrhTEfhBDpPUbrb5g";
  }

  static turf.Polygon circle({
    required double latitude,
    required double longitude,
    required int radian,
  }) {
    var latitude1 = turf.degreesToRadians(latitude);
    var longitude1 = turf.degreesToRadians(longitude);
    List<turf.Position> coordinates = [];
    var steps = 100;
    for (var i = 0; i < steps; i++) {
      var bearingRad = turf.degreesToRadians(i * (-360) / steps);
      var radians = turf.lengthToRadians(radian, turf.Unit.meters);
      var latitude2 = asin(sin(latitude1) * cos(radians) +
          cos(latitude1) * sin(radians) * cos(bearingRad));
      var longitude2 = longitude1 +
          atan2(sin(bearingRad) * sin(radians) * cos(latitude1),
              cos(radians) - sin(latitude1) * sin(latitude2));
      var lng = turf.radiansToDegrees(longitude2);
      var lat = turf.radiansToDegrees(latitude2);
      coordinates.add(turf.Position(lng, lat));
    }
    coordinates.add(coordinates.first);
    return turf.Polygon(coordinates: [coordinates]);
  }

  static UserModel? _userData;

  static UserModel? _user() {
    if (_userData != null) return _userData;

    if (Storage.has("user")) {
      return UserModel.fromJson(jsonDecode(Storage.read<String>("user")!));
    }

    return null;
  }

  static void reset() {
    _userData = null;
  }
}
