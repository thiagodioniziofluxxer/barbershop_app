// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:developer';

import 'package:barbershop/src/core/exceptions/repository_exception.dart';
import 'package:barbershop/src/core/fp/either.dart';
import 'package:barbershop/src/core/fp/nil.dart';
import 'package:barbershop/src/core/restClient/rest_client.dart';
import 'package:barbershop/src/model/barbershop_model.dart';
import 'package:barbershop/src/model/user_model.dart';
import 'package:dio/dio.dart';

import './barbershop_repository.dart';

class BarbershopRepositoryImpl implements BarbershopRepository {
  final RestClient restClient;
  BarbershopRepositoryImpl({
    required this.restClient,
  });

  @override
  Future<Either<RepositoryException, BarbershopModel>> getMyBarbershop(
      UserModel userModel) async {
    switch (userModel) {
      case UserModelAdm():
        //é admin e dono da barbearia.
        // final Response(data: List(first: data)) = await restClient.get('/barbershop', queryParameters: {'user_id': userModel.id});
        //gambis pra pegar o id do usuario logado no backend
        final Response(data: List(first: data)) = await restClient.auth
            .get('/barbershop', queryParameters: {'user_id': "#userAuthRef"});
        return Success(BarbershopModel.fromMap(data));

      case UserModelEmployee():
        // é um funcionario da barbearia
        final Response(:data) =
            await restClient.auth.get('/barbershop/${userModel.barbershopId}');
        return Success(BarbershopModel.fromMap(data));
    }
    throw RepositoryException(message: 'Erro ao buscar user model');
  }

  @override
  Future<Either<RepositoryException, Nil>> save(
      ({
        String email,
        String name,
        List<String> openingDays,
        List<int> openingHours
      }) data) async {
    try {
      await restClient.auth.post('/barbershop', data: {
        'user_id': '#userAuthRef',
        'name': data.name,
        'email': data.email,
        'opening_days': data.openingDays,
        'opening_hours': data.openingHours,
      });
      return Success(Nil());
    } on DioException catch (e, s) {
      log('Erro ao cadastrar a barbearia', error: e, stackTrace: s);
      return Failure(
          RepositoryException(message: 'Erro ao cadastrar a barbearia'));
    }
  }
}
