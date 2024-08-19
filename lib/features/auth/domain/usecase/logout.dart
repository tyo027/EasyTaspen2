import 'package:easy/features/auth/domain/repository/auth_repository.dart';

class Logout {
  final AuthRepository authRepository;
  Logout(this.authRepository);

  Future<void> call() {
    return authRepository.logout();
  }
}
