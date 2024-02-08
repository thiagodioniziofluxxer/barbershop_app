import 'package:asyncstate/asyncstate.dart';
import 'package:barbershop/src/core/exceptions/services_exception.dart';
import 'package:barbershop/src/core/fp/either.dart';
import 'package:barbershop/src/core/providers/application_providers.dart';
import 'package:barbershop/src/features/auth/login/login_state.dart';
import 'package:barbershop/src/model/user_model.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
part 'login_vm.g.dart';

@riverpod
class LoginVm extends _$LoginVm {
  @override
  LoginState build() => LoginState.initial();

  Future<void> login(String email, String password) async {
    final loaderHandle = AsyncLoaderHandler()..start();
    final loginService = ref.watch(userLoginServiceProvider);
    final result = await loginService.execute(email, password);
    switch (result) {
      case Success():
        ref.invalidate(getMeProvider);
        ref.invalidate(getMyBarbershopProvider);
        final userModel = await ref.read(getMeProvider.future);
        switch (userModel) {
          case UserModelAdm():
            state = state.copyWith(
              status: LoginStateStatus.admLogin,
            );
            break;
          case UserModelEmployee():
            state = state.copyWith(
              status: LoginStateStatus.employeeLogin,
            );
            break;
        }
        break;
      case Failure(exception: ServicesException(:final message)):
        state = state.copyWith(
          status: LoginStateStatus.error,
          errorMessage: () => message,
        );
        break;
    }
    loaderHandle.close();
  }
}
