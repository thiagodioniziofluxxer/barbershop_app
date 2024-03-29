import 'package:asyncstate/asyncstate.dart';
import 'package:barbershop/src/core/fp/either.dart';
import 'package:barbershop/src/core/providers/application_providers.dart';
import 'package:barbershop/src/features/home/adm/home_adm_state.dart';
import 'package:barbershop/src/model/barbershop_model.dart';
import 'package:barbershop/src/model/user_model.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'home_adm_vm.g.dart';

@riverpod
class HomeAdmVm extends _$HomeAdmVm {
  @override
  Future<HomeAdmState> build() async {
    final repository = ref.read(userRepositoryProvider);
    final me = await ref.watch(getMeProvider.future);
    final BarbershopModel(id: barbershopId) =
        await ref.read(getMyBarbershopProvider.future);
    final employeesResult = await repository.getEmployees(barbershopId);
    switch (employeesResult) {
      case Success(value: var employeesData):
        final employees = <UserModel>[];

        if (me case UserModelAdm(workDays: _?, workHours: _?)) {
          employees.add(me);
        }
        employees.addAll(employeesData);
        return HomeAdmState(
          state: HomeAdmStateStatus.loaded,
          employees: employees,
        );
      case Failure():
        return HomeAdmState(
          state: HomeAdmStateStatus.error,
          employees: [],
        );
    }
  }

  Future<void> loggout() => ref.read(loggoutProvider.future).asyncLoader();
}
