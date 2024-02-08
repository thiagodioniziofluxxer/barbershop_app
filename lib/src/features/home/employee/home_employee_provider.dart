import 'package:barbershop/src/core/fp/either.dart';
import 'package:barbershop/src/core/providers/application_providers.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'home_employee_provider.g.dart';

@riverpod
Future<int> getTotalSchedulesToday(
    GetTotalSchedulesTodayRef ref, int userId) async {
  final DateTime(:year, :month, :day) = DateTime.now();

  final filter = (
    date: DateTime(year, month, day, 0, 0, 0),
    userId: userId,
  );

  final scheuleRepository = ref.read(scheduleRepositoryProvider);
  final scheduleResult = await scheuleRepository.findSchedulebyDate(filter);

  return switch (scheduleResult) {
    Success(value: List(length: final total)) => total,
    Failure() => 0,
  };
}
