// ignore_for_file: public_member_api_docs, sort_constructors_first

import 'dart:developer';
import 'dart:io';

import 'package:barbershop/src/core/exceptions/auth_exception.dart';
import 'package:barbershop/src/core/exceptions/repository_exception.dart';
import 'package:barbershop/src/core/fp/either.dart';
import 'package:barbershop/src/core/fp/nil.dart';
import 'package:barbershop/src/core/restClient/rest_client.dart';
import 'package:barbershop/src/model/user_model.dart';
import 'package:barbershop/src/repositories/user/user_repository.dart';
import 'package:dio/dio.dart';

class UserRepositoryImpl implements UserRepository {
  final RestClient restClient;
  UserRepositoryImpl({
    required this.restClient,
  });

  @override
  Future<Either<AuthException, String>> login(
      String email, String password) async {
    try {
      final Response(:data) = await restClient.post(
        '/auth',
        data: {
          'email': email,
          'password': password,
        },
      );
      return Success(data['access_token']);
    } on DioException catch (e, s) {
      if (e.response != null) {
        if (e.response!.statusCode == HttpStatus.forbidden) {
          return Failure(AuthUnauthorizedException());
        }
      }
      log('Erro ao realizar login', error: e, stackTrace: s);
      return Failure(AuthError(message: 'Erro ao realizar login'));
    }
  }

  @override
  Future<Either<RepositoryException, UserModel>> me() async {
    try {
      final Response(:data) = await restClient.auth.get('/me');

      return Success(UserModel.fromMap(data));
    } on DioException catch (e, s) {
      log(' Erro ao buscar usuário logado', error: e, stackTrace: s);
      return Failure(
          RepositoryException(message: 'Erro ao buscar usuário logado'));
    } on ArgumentError catch (e, s) {
      log('Erro json error', error: e, stackTrace: s);
      return Failure(RepositoryException(message: e.message));
    }
  }

  @override
  Future<Either<RepositoryException, Nil>> registerAdmin(
      ({String email, String name, String password}) userData) async {
    try {
      await restClient.unAuth.post('/users', data: {
        'name': userData.name,
        'email': userData.email,
        'password': userData.password,
        'profile': 'ADM',
      });
      return Success(Nil());
    } on DioException catch (e, s) {
      log('Erro ao realizar cadastro', error: e, stackTrace: s);
      return Failure(RepositoryException(message: 'Erro ao realizar cadastro'));
    }
  }

  @override
  Future<Either<RepositoryException, List<UserModel>>> getEmployees(
      int barbershopId) async {
    try {
      final Response(:List data) =
          await restClient.auth.get('/users', queryParameters: {
        'barbershop_id': barbershopId,
      });
      final employees = data.map((e) => UserModelEmployee.fromMap(e)).toList();
      return Success(employees);
    } on DioException catch (e, s) {
      log('Erro ao buscar funcionários', error: e, stackTrace: s);
    } on ArgumentError catch (e, s) {
      log('Erro ao converter colaboradores', error: e, stackTrace: s);
    }
    return Failure(RepositoryException(message: 'Erro ao buscar funcionários'));
  }



  @override
  Future<Either<RepositoryException, Nil>> registerAdmAsEmployee(
      ({List<String> workDays, List<int> workHours}) userModel) async {
    try {
      final userModelResult = await me();
      final int userId;
      switch (userModelResult) {
        case Success(value: UserModel(:var id)):
          userId = id;
          break;
        case Failure(:var exception):
          return Failure(exception);
      }
      await restClient.auth.put('/users/$userId', data: {
        'work_days': userModel.workDays,
        'work_hours': userModel.workHours,
      });
      return Success(Nil());
    } on DioException catch (e, s) {
      log("Erro ao atualizar usuário", error: e, stackTrace: s);
      return Failure(RepositoryException(message: 'Erro ao atualizar usuário'));
    } on ArgumentError catch (e, s) {
      log("Erro ao atualizar usuário", error: e, stackTrace: s);
      return Failure(RepositoryException(message: 'Erro ao atualizar usuário'));
    }
  }

  @override
  Future<Either<RepositoryException, Nil>> registerAsEmployee(
      ({
        int barbershopId,
        String email,
        String name,
        String password,
        List<String> workDays,
        List<int> workHours
      }) userModel) async {
    try {
      await restClient.auth.post('/users', data: {
        'name': userModel.name,
        'email': userModel.email,
        'password': userModel.password,
        'barbershop_id': userModel.barbershopId,
        'profile': 'EMPLOYEE',
        'work_days': userModel.workDays,
        'work_hours': userModel.workHours,
      });
      return Success(Nil());
    } on DioException catch (e, s) {
      log("Erro ao atualizar usuário", error: e, stackTrace: s);
      return Failure(RepositoryException(message: 'Erro ao atualizar usuário'));
    } on ArgumentError catch (e, s) {
      log("Erro ao atualizar usuário", error: e, stackTrace: s);
      return Failure(RepositoryException(message: 'Erro ao atualizar usuário'));
    }
  }
}
