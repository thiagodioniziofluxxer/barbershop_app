import 'package:asyncstate/asyncstate.dart';
import 'package:barbershop/src/core/exceptions/repository_exception.dart';
import 'package:barbershop/src/core/fp/either.dart';
import 'package:barbershop/src/core/fp/nil.dart';
import 'package:barbershop/src/core/providers/application_providers.dart';
import 'package:barbershop/src/features/employee/register/employee_register_state.dart';
import 'package:barbershop/src/model/barbershop_model.dart';
import 'package:barbershop/src/repositories/user/user_repository.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'employee_register_vm.g.dart';

@riverpod
class EmployeeRegisterVm extends _$EmployeeRegisterVm {
  @override
  EmployeeRegisterState build() => EmployeeRegisterState.initial();

  void setRegisterAdm(bool value) {
    state = state.copyWith(registerAdm: value);
  }

  addOrRemoveWorkDay(String day) {
    final EmployeeRegisterState(:workDays) = state;
    if (workDays.contains(day)) {
      workDays.remove(day);
    } else {
      workDays.add(day);
    }
    state = state.copyWith(workDays: workDays);
  }

  addOrRemoveWorkHour(int hour) {
    final EmployeeRegisterState(:workHours) = state;
    if (workHours.contains(hour)) {
      workHours.remove(hour);
    } else {
      workHours.add(hour);
    }
    state = state.copyWith(workHours: workHours);
  }

  Future<void> registerEmployee(
      {String? name, String? email, String? password}) async {
    final EmployeeRegisterState(:registerAdm, :workDays, :workHours) = state;
    final asyncLoaderHandler = AsyncLoaderHandler()..start();
    final UserRepository(:registerAdmAsEmployee, :registerAsEmployee) =
        ref.read(userRepositoryProvider);
    final Either<RepositoryException, Nil> resultRegister;

    if (registerAdm) {
      final dto = (workDays: workDays, workHours: workHours);
      resultRegister = await registerAdmAsEmployee(dto);
    } else {
      final BarbershopModel(:id) =
          await ref.watch(getMyBarbershopProvider.future);

      final dto = (
        barbershopId: id,
        name: name!,
        email: email!,
        password: password!,
        workDays: workDays,
        workHours: workHours
      );
      resultRegister = await registerAsEmployee(dto);
    }
    switch (resultRegister) {
      case Success():
        state = state.copyWith(status: EmployeeRegisterStateStatus.success);
        break;
      case Failure():
        state = state.copyWith(status: EmployeeRegisterStateStatus.error);
        break;
    }
    asyncLoaderHandler.close();
  }
}
