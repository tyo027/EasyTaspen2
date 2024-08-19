import 'package:easy/features/home/domain/entities/home.dart';
import 'package:easy/features/home/domain/repositories/home_repository.dart';
import 'package:fca/fca.dart';
import 'package:fpdart/fpdart.dart';

class GetHomeData implements UseCase<Home, GetHomeDataParams> {
  final HomeRepository homeRepository;

  GetHomeData(this.homeRepository);

  @override
  Future<Either<Failure, Home>> call(GetHomeDataParams params) async {
    return homeRepository.getHomeData(nik: params.nik);
  }
}

class GetHomeDataParams {
  final String nik;

  GetHomeDataParams({required this.nik});
}
