// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:barbershop/src/model/user_model.dart';

enum HomeAdmStateStatus {
  loaded,
  error,
}

class HomeAdmState {
  final HomeAdmStateStatus state;
  final List<UserModel> employees;
  HomeAdmState({
    required this.state,
    required this.employees,
  });

  HomeAdmState copyWith({
    HomeAdmStateStatus? state,
    List<UserModel>? employees,
  }) {
    return HomeAdmState(
      state: state ?? this.state,
      employees: employees ?? this.employees,
    );
  }
}
