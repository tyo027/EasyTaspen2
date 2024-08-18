part of 'dependencies.dart';

Future<void> initDependencies() async {
  await _initCore();

  _initAccount();
  _initAuth();
}

_initCore() async {
  await Hive.initFlutter();
  final authenticationBox = await Hive.openBox('authentication');

  Dependency.addRepository(authenticationBox);
  Dependency.addRepository(http.Client());
  Dependency.addRepository<InterceptedClient>(
    InterceptedClientImpl(
      client: Dependency.get(),
      box: Dependency.get(),
    ),
  );
  Dependency.addRepository(InternetConnection());
  Dependency.addRepository<ConnectionChecker>(
    ConnectionCheckerImpl(Dependency.get()),
  );
  Dependency.addBloc(AppUserCubit());
}

_initAuth() {
  Dependency.addDatasource<AuthRemoteDatasource>(
    AuthRemoteDatasourceImpl(
      Dependency.get(),
    ),
  );
  Dependency.addRepository<AuthRepository>(
    AuthRepositoryImpl(
      Dependency.get(),
      Dependency.get(),
      Dependency.get(),
      Dependency.get(),
    ),
  );
  Dependency.addUsecase(
    SignIn(Dependency.get()),
  );
  Dependency.addUsecase(
    CurrentUser(Dependency.get()),
  );
  Dependency.addBloc(
    AuthBloc(
      Dependency.get(),
      Dependency.get(),
      Dependency.get(),
    ),
  );
}

_initAccount() {
  Dependency.addDatasource<AccountRemoteDatasource>(
    AccountRemoteDatasourceImpl(Dependency.get()),
  );
}
