import 'package:easy/features/home/domain/entities/home.dart';
import 'package:fca/fca.dart';
import 'package:fpdart/fpdart.dart';

abstract interface class HomeRepository {
  Future<Either<Failure, Home>> getHomeData({required String nik});
}
