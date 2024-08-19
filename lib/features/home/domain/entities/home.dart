import 'package:easy/core/common/entities/employee.dart';

class Home {
  final bool isAdmin;
  final List<Employee>? employee;

  Home({
    required this.isAdmin,
    this.employee,
  });

  bool get hasEmployee => employee?.isNotEmpty ?? false;
}
