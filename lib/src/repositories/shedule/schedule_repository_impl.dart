import 'dart:developer';

import 'package:barbershop/src/core/exceptions/repository_exception.dart';
import 'package:barbershop/src/core/fp/either.dart';
import 'package:barbershop/src/core/fp/nil.dart';
import 'package:barbershop/src/core/restClient/rest_client.dart';
import 'package:barbershop/src/model/schedule_model.dart';
import 'package:barbershop/src/repositories/shedule/schedule_repository.dart';
import 'package:dio/dio.dart';

class ScheduleRepositoryImpl implements ScheduleRepository {
  final RestClient restClient;
  ScheduleRepositoryImpl({
    required this.restClient,
  });

  @override
  Future<Either<RepositoryException, Nil>> scheduleClient(
      ({
        int barbershopId,
        String clientName,
        DateTime date,
        int time,
        int userId
      }) scheduleData) async {
    try {
      await restClient.post(
        '/schedules',
        data: {
          'barbershop_id': scheduleData.barbershopId,
          'user_id': scheduleData.userId,
          'client_name': scheduleData.clientName,
          'date': scheduleData.date.toIso8601String(),
          'time': scheduleData.time,
        },
      );
      return Success(nil);
    } on DioException catch (e) {
      log('Erro ao registrar agendamento', error: e);
      return Failure(RepositoryException(
        message: 'Erro ao registrar agendamento',
      ));
    }
  }

  @override
  Future<Either<RepositoryException, List<ScheduleModel>>> findSchedulebyDate(
      ({DateTime date, int userId}) filter) async {
    try {
      final Response(:List data) = await restClient.get(
        '/schedules',
        queryParameters: {
          'date': filter.date.toIso8601String(),
          'user_id': filter.userId,
        },
      );
      final schedules = data.map((s) => ScheduleModel.fromMap(s)).toList();

      return Success(schedules);
    } on DioException catch (e) {
      log('Erro ao buscar agendamentos', error: e);
      return Failure(RepositoryException(
        message: 'Erro ao buscar agendamentos',
      ));
    } on ArgumentError catch (e, s) {
      log('Argumentos inválidos', error: e, stackTrace: s);
      return Failure(RepositoryException(
        message: 'Erro ao buscar agendamentos: $e',
      ));
    }
  }
}
