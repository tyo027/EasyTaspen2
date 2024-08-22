import 'dart:convert';
import 'dart:io';
import 'dart:math';

import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:turf/helpers.dart' as turf;

class Location {
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

  static Future<PositionResult> getCurrentPosition({
    required bool allowMockLocation,
  }) async {
    try {
      bool isLocationAccessable = await _isLocationAccessable();

      if (!isLocationAccessable) return PositionNotFound();

      late LocationSettings locationSettings;

      if (Platform.isAndroid) {
        locationSettings = AndroidSettings();
      } else {
        locationSettings = AppleSettings();
      }

      var position = await Geolocator.getCurrentPosition(
        locationSettings: locationSettings,
      );

      if (!allowMockLocation && position.isMocked) {
        return FakePosition();
      }

      return HasPosition(position: position);
    } catch (e) {
      return PositionNotFound();
    }
  }

  static Future<double> getDistanceTo({
    required double latitude,
    required double longitude,
    required double fromLatitude,
    required double fromLongitude,
  }) async {
    return Geolocator.distanceBetween(
      fromLatitude,
      fromLongitude,
      latitude,
      longitude,
    );
  }

  static Future<String> getCurrentAddress({
    required double latitude,
    required double longitude,
  }) async {
    await setLocaleIdentifier("id_ID");

    var addresses = await placemarkFromCoordinates(
      latitude,
      longitude,
    );

    var currentAddress = addresses[0];

    return '${currentAddress.street}, ${currentAddress.subLocality}, ${currentAddress.locality}, ${currentAddress.postalCode}, ${currentAddress.country}';
  }

  static String getImageUrlRadius({
    required double latitude,
    required double longitude,
    required double centerLatitude,
    required double centerLongitude,
    required int radius,
  }) {
    var center = turf.Feature(
      id: 1,
      properties: {
        "marker-color": "#ff0000",
        "marker-size": "medium",
        "marker-symbol": "circle",
      },
      geometry: turf.Point(
          coordinates: turf.Position(
        centerLongitude,
        centerLatitude,
      )),
    );
    var circles = turf.Feature(
      id: 0,
      properties: {"fill-color": "#ff0000"},
      geometry: circle(
        latitude: centerLatitude,
        longitude: centerLongitude,
        radian: radius,
      ),
    );

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

    return 'https://api.mapbox.com/styles/v1/mapbox/streets-v12/static/geojson('
        '${Uri.encodeComponent(json.encode(collection.toJson()))}'
        ')/$centerLongitude,$centerLatitude,16'
        '/500x300?'
        'access_token=${dotenv.env['MAPBOX_TOKEN']}';
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
}

class PositionResult {}

class HasPosition extends PositionResult {
  final Position position;
  HasPosition({required this.position});
}

class FakePosition extends PositionResult {}

class PositionNotFound extends PositionResult {}
