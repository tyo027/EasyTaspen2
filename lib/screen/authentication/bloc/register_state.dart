part of 'register_bloc.dart';

class RegisterState extends Equatable {
  final String fullname;
  final String userName;
  final String password;
  final String gender;
  final String phone;
  final String job;

  const RegisterState(
      {this.fullname = "",
      this.userName = "",
      this.password = "",
      this.gender = "",
      this.phone = "",
      this.job = ""});

  RegisterState copyWith({
    String? fullname,
    String? userName,
    String? password,
    String? gender,
    String? job,
    String? phone,
  }) =>
      RegisterState(
        fullname: fullname ?? this.fullname,
        userName: userName ?? this.userName,
        password: password ?? this.password,
        gender: gender ?? this.gender,
        job: job ?? this.job,
        phone: phone ?? this.phone,
      );

  @override
  List<Object?> get props => [userName, password, fullname, gender, job, phone];
}
