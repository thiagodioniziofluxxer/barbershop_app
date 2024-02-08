import 'package:barbershop/src/core/constants/local_storage_keys.dart';
import 'package:barbershop/src/core/exceptions/auth_exception.dart';
import 'package:barbershop/src/core/exceptions/services_exception.dart';

import 'package:barbershop/src/core/fp/either.dart';

import 'package:barbershop/src/core/fp/nil.dart';
import 'package:barbershop/src/repositories/user/user_repository.dart';
import 'package:shared_preferences/shared_preferences.dart';

import './user_login_service.dart';

class UserLoginServiceImpl implements UserLoginService {
  final UserRepository userRepository;
  UserLoginServiceImpl({
    required this.userRepository,
  });
  @override
  Future<Either<ServicesException, Nil>> execute(
      String email, String password) async {
    final loginResult = await userRepository.login(email, password);
    switch (loginResult) {
      case Success(value: final acessToken):
        final sp = await SharedPreferences.getInstance();
        sp.setString(LocalStorageKeys.acessToken, acessToken);
        return Success(nil);
      case Failure(:final exception):
        return switch (exception) {
          AuthError() =>
            Failure(ServicesException(message: 'erro ao realizar login')),
          AuthUnauthorizedException() =>
            Failure(ServicesException(message: 'Usuário ou senha inválidos')),
        };
    }
  }
}
