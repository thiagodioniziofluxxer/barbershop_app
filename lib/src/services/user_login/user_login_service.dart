import 'package:barbershop/src/core/exceptions/services_exception.dart';
import 'package:barbershop/src/core/fp/either.dart';
import 'package:barbershop/src/core/fp/nil.dart';

abstract interface class UserLoginService {
  Future<Either<ServicesException, Nil>> execute(String email, String password);
}
