import 'package:flutter/material.dart';

class Notification {
  final int id;
  final String title;
  final String message;
  final TimeOfDay timeOfDay;

  Notification({
    required this.id,
    required this.title,
    required this.message,
    required this.timeOfDay,
  });
}
