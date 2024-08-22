import 'package:easy/features/attendance/domain/entities/my_location.dart';
import 'package:easy/features/attendance/domain/enums/attendance_type.dart';
import 'package:easy/features/attendance/domain/repositories/attendance_repository.dart';
import 'package:fca/fca.dart';
import 'package:fpdart/fpdart.dart';

class GetMyLocation implements UseCase<MyLocation, GetMyLocationParams> {
  final AttendanceRepository repository;

  GetMyLocation(this.repository);

  @override
  Future<Either<Failure, MyLocation>> call(GetMyLocationParams params) {
    return repository.getMyLocation(
      allowMockLocation: params.allowMockLocation,
      kodeCabang: params.kodeCabang,
      nik: params.nik,
      type: params.type,
      centerLatitude: params.centerLatitude,
      centerLongitude: params.centerLongitude,
      radius: params.radius,
    );
  }
}

final class GetMyLocationParams {
  final String kodeCabang;
  final AttendanceType type;
  final String nik;
  final bool allowMockLocation;
  final int radius;
  final double centerLatitude;
  final double centerLongitude;

  GetMyLocationParams({
    required this.radius,
    required this.centerLatitude,
    required this.centerLongitude,
    required this.allowMockLocation,
    required this.kodeCabang,
    required this.nik,
    required this.type,
  });
}
