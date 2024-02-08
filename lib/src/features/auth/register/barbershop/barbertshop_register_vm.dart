import 'package:barbershop/src/core/fp/either.dart';
import 'package:barbershop/src/core/providers/application_providers.dart';
import 'package:barbershop/src/features/auth/register/barbershop/barbershop_register_state.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'barbertshop_register_vm.g.dart';

@riverpod
class BarbertshopRegisterVm extends _$BarbertshopRegisterVm {
  @override
  BarbershopRegisterState build() => BarbershopRegisterState.initial();

  void addOrRemoveOpenDays(String weekDay) {
    final openingDays = state.openingDays;
    if (openingDays.contains(weekDay)) {
      openingDays.remove(weekDay);
    } else {
      openingDays.add(weekDay);
    }
    state = state.copyWith(openingDays: openingDays);
  }

  void addOrRemoveOpenHours(int hour) {
    final openingHours = state.openingHours;
    if (openingHours.contains(hour)) {
      openingHours.remove(hour);
    } else {
      openingHours.add(hour);
    }
    state = state.copyWith(openingHours: openingHours);
  }

  Future<void> register({required String name, required String email}) async {
    final repository = ref.watch(barberShopRepositoryProvider);
    final BarbershopRegisterState(:openingDays, :openingHours) = state;

    final data = (
      name: name,
      email: email,
      openingDays: openingDays,
      openingHours: openingHours,
    );
    final registerResult = await repository.save(data);
    switch (registerResult) {
      case Success():
        ref.invalidate(getMyBarbershopProvider);
        state = state.copyWith(status: BarbershopRegisterStatus.success);
        break;
      case Failure():
        state = state.copyWith(status: BarbershopRegisterStatus.error);
        break;
    }
  }
}
