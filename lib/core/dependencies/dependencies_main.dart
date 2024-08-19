part of 'dependencies.dart';

Future<void> initDependencies() async {
  await _initCore();

  _initAccount();
  _initIdle();
  _initAuth();

  _initHome();

  _initAttendance();
}

_initCore() async {
  await Hive.initFlutter();
  final authenticationBox = await Hive.openBox('authentication');

  Dependency.addRepository(authenticationBox);
  Dependency.addRepository(http.Client());
  Dependency.addDatasource<AuthRemoteDatasource>(
    AuthRemoteDatasourceImpl(
      Dependency.get(),
    ),
  );
  Dependency.addRepository<InterceptedClient>(
    InterceptedClientImpl(
      client: Dependency.get(),
      box: Dependency.get(),
      authRemoteDatasource: Dependency.get(),
    ),
  );
  Dependency.addRepository(InternetConnection());
  Dependency.addRepository<ConnectionChecker>(
    ConnectionCheckerImpl(Dependency.get()),
  );
  Dependency.addBloc(AppUserCubit());
}

_initAuth() {
  Dependency.addRepository<AuthRepository>(
    AuthRepositoryImpl(
      Dependency.get(),
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
  Dependency.addUsecase(
    ReAuthenticate(Dependency.get()),
  );
  Dependency.addUsecase(
    Logout(Dependency.get()),
  );
  Dependency.addBloc(
    AuthBloc(
      Dependency.get(),
      Dependency.get(),
      Dependency.get(),
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
  Dependency.addRepository<AccountRepository>(
    AccountRepositoryImpl(
      Dependency.get(),
      Dependency.get(),
    ),
  );
  Dependency.addUsecase(
    GetCurrentAccount(
      Dependency.get(),
    ),
  );
  Dependency.addUsecase(
    GetCurrentPosition(
      Dependency.get(),
    ),
  );
  Dependency.addUsecase(
    GetCurrentGolongan(
      Dependency.get(),
    ),
  );
  Dependency.addBloc(
    AccountBloc(
      Dependency.get(),
    ),
  );
  Dependency.addBloc(
    PositionBloc(
      Dependency.get(),
    ),
  );
  Dependency.addBloc(
    GolonganBloc(
      Dependency.get(),
    ),
  );
}

_initIdle() {
  Dependency.addDatasource<IdleDataSource>(
    IdleDataSourceImpl(Dependency.get()),
  );
  Dependency.addRepository<IdleRepository>(
    IdleRepositoryImpl(Dependency.get()),
  );
  Dependency.addUsecase(
    GetIdleStatus(Dependency.get()),
  );
  Dependency.addUsecase(
    ActivateIdle(Dependency.get()),
  );
  Dependency.addBloc(IdleBloc(
    Dependency.get(),
    Dependency.get(),
  ));
}

_initHome() {
  Dependency.addRepository<HomeRepository>(
    HomeRepositoryImpl(Dependency.get(), Dependency.get()),
  );
  Dependency.addUsecase(GetHomeData(Dependency.get()));
  Dependency.addBloc(HomeBloc(Dependency.get()));
}

_initAttendance() {
  Dependency.addDatasource<AttendanceRemoteDatasource>(
    AttendanceRemoteDatasourceImpl(Dependency.get()),
  );
  Dependency.addRepository<AttendanceRepository>(
    AttendanceRepositoryImpl(
      Dependency.get(),
      Dependency.get(),
    ),
  );
  Dependency.addUsecase(
    GetRule(
      Dependency.get(),
    ),
  );
  Dependency.addBloc(
    RuleBloc(
      Dependency.get(),
    ),
  );
}
