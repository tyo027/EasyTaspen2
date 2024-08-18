import 'dart:convert';

import 'package:easy/core/common/models/user_model.dart';
import 'package:easy/core/constants/constants.dart';
import 'package:easy/features/account/data/remote_datasource/account_remote_datasource.dart';
import 'package:easy/features/auth/data/datasources/auth_remote_datasource.dart';
import 'package:easy/features/auth/domain/repository/auth_repository.dart';
import 'package:fca/fca.dart';
import 'package:fpdart/fpdart.dart';
import 'package:hive_flutter/hive_flutter.dart';

class AuthRepositoryImpl implements AuthRepository {
  final Box box;
  final ConnectionChecker connectionChecker;
  final AuthRemoteDatasource authRemoteDatasource;
  final AccountRemoteDatasource accountRemoteDatasource;
  final IdleDataSource idleDataSource;

  AuthRepositoryImpl(
    this.box,
    this.connectionChecker,
    this.authRemoteDatasource,
    this.accountRemoteDatasource,
    this.idleDataSource,
  );

  Future<UserModel> authenticate({
    required String username,
    required String password,
  }) async {
    final auth = await authRemoteDatasource.signIn(
      username: username,
      password: password,
    );

    final user = UserModel(
      nik: auth.nik,
      nama: auth.nama,
      jabatan: auth.jabatan,
      ba: auth.ba,
      unitKerja: auth.unitKerja,
      perty: auth.perty,
    );

    await box.put('token', auth.token);
    await box.put('username', Secure.secureText(username));
    await box.put('password', Secure.secureText(password));
    await box.put('user', jsonEncode(user.toJson()));

    await idleDataSource.saveLastIdle(DateTime.now());

    return user;
  }

  @override
  Future<Either<Failure, UserModel>> signIn({
    required String username,
    required String password,
  }) async {
    try {
      if (!await (connectionChecker.isConnected)) {
        return left(Failure(Constants.noConnectionErrorMessage));
      }

      final user = await authenticate(username: username, password: password);

      return right(user);
    } on ServerException catch (e) {
      return left(Failure(e.message));
    }
  }

  @override
  Future<Either<Failure, UserModel>> currentUser() async {
    try {
      if (!await (connectionChecker.isConnected)) {
        return left(Failure(Constants.noConnectionErrorMessage));
      }

      final userData = box.get('user');

      if (userData == null) {
        return left(Failure(Constants.unAuthenticated));
      }

      final secureUsername = box.get('username');
      final securePassword = box.get('password');

      if (secureUsername == null || securePassword == null) {
        return left(Failure(Constants.unAuthenticated));
      }

      final user = UserModel.fromJson(jsonDecode(userData));

      return right(user);
    } on ServerException catch (e) {
      print(e.message);
      return left(Failure(e.message));
    }
  }
}
