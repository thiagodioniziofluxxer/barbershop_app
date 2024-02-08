import 'package:barbershop/src/core/providers/application_providers.dart';
import 'package:barbershop/src/core/ui/barbershop_icons.dart';
import 'package:barbershop/src/core/ui/contants.dart';
import 'package:barbershop/src/core/ui/widgets/barbershop_loader.dart';
import 'package:barbershop/src/features/home/adm/home_adm_state.dart';
import 'package:barbershop/src/features/home/adm/home_adm_vm.dart';
import 'package:barbershop/src/features/home/adm/home_emploee_tile.dart';
import 'package:barbershop/src/features/home/widgets/home_header.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class HomeAdmPage extends ConsumerWidget {
  const HomeAdmPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final homeState = ref.watch(homeAdmVmProvider);

    return SafeArea(
      child: Scaffold(
        floatingActionButton: FloatingActionButton(
          onPressed: () async {
            await Navigator.of(context).pushNamed('/employee/register');
            ref.invalidate(getMeProvider);
            ref.invalidate(homeAdmVmProvider);
          },
          shape: const CircleBorder(),
          backgroundColor: Constants.brow,
          child: const CircleAvatar(
              backgroundColor: Constants.brow,
              maxRadius: 12,
              child: Icon(
                BarbershopIcons.addEmployee,
                color: Colors.white,
              )),
        ),
        body: homeState.when(data: (HomeAdmState data) {
          return CustomScrollView(slivers: [
            const SliverToBoxAdapter(
              child: HomeHeader(
                hideFilter: true,
              ),
            ),
            SliverList(
                delegate: SliverChildBuilderDelegate(
                    (context, index) =>
                        HomeEmploeeTile(employee: data.employees[index]),
                    childCount: data.employees.length))
          ]);
        }, error: (_, __) {
          return const Center(
            child: Text('Erro ao carregar dados'),
          );
        }, loading: () {
          return const BarbershopLoader();
        }),
      ),
    );
  }
}
