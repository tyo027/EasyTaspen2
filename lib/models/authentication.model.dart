import 'package:easy/models/user.model.dart';
import 'package:equatable/equatable.dart';

class AuthenticationModel extends Equatable {
  final String token;
  final UserModel user;

  const AuthenticationModel({
    required this.token,
    required this.user,
  });

  static AuthenticationModel fromJson(Map<String, dynamic> json) =>
      AuthenticationModel(
          token: json['_token'], user: UserModel.fromJson(json["status"]));

  @override
  List<Object> get props => [token, user];
}
