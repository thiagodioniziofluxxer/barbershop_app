
import 'package:barbershop/src/core/exceptions/repository_exception.dart';
import 'package:barbershop/src/core/fp/either.dart';
import 'package:barbershop/src/core/providers/application_providers.dart';
import 'package:barbershop/src/model/schedule_model.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'employee_schedule_vm.g.dart';

@riverpod
class EmployeeScheduleVm extends _$EmployeeScheduleVm {
  @override
  Future<List<ScheduleModel>> build(int userId, DateTime date) async {
    var schedulesListResult = await _getSchedules(userId, date);
    return switch (schedulesListResult) {
      Success(value: final schedules) => schedules,
      Failure() => throw Exception('Erro ao buscar agendamentos'),
    };
  }

  Future<Either<RepositoryException, List<ScheduleModel>>> _getSchedules(
      int userId, DateTime date) {
    final repository = ref.read(scheduleRepositoryProvider);
    return repository.findSchedulebyDate((date: date, userId: userId));
  }

  Future<void> changeDate(int userId, DateTime date) async {
    var schedulesListResult = await _getSchedules(userId, date);
    state = switch (schedulesListResult) {
      Success(value: final schedules) => AsyncData(schedules),
      Failure(:final exception) => AsyncError(exception, StackTrace.current),
    };
  }
}
