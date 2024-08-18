import 'package:easy/core/common/cubit/app_user_cubit.dart';
import 'package:easy/core/network/intercepted_client_impl.dart';
import 'package:easy/features/account/data/remote_datasource/account_remote_datasource.dart';
import 'package:easy/features/auth/data/datasources/auth_remote_datasource.dart';
import 'package:easy/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:easy/features/auth/domain/repository/auth_repository.dart';
import 'package:easy/features/auth/domain/usecase/current_user.dart';
import 'package:easy/features/auth/domain/usecase/sign_in.dart';
import 'package:easy/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:fca/fca.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';

part 'dependencies_main.dart';
