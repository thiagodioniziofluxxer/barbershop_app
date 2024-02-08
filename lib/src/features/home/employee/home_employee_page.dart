import 'package:barbershop/src/core/providers/application_providers.dart';
import 'package:barbershop/src/core/ui/contants.dart';
import 'package:barbershop/src/core/ui/widgets/avatar_widget.dart';
import 'package:barbershop/src/core/ui/widgets/barbershop_loader.dart';
import 'package:barbershop/src/features/home/employee/home_employee_provider.dart';
import 'package:barbershop/src/features/home/widgets/home_header.dart';
import 'package:barbershop/src/model/user_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class HomeEmployeePage extends ConsumerStatefulWidget {
  const HomeEmployeePage({super.key});

  @override
  ConsumerState<HomeEmployeePage> createState() => _HomeEmployeePageState();
}

class _HomeEmployeePageState extends ConsumerState<HomeEmployeePage> {
  @override
  Widget build(BuildContext context) {
    final userModelAsync = ref.watch(getMeProvider);
    return SafeArea(
      child: Scaffold(
          body: userModelAsync.when(
              error: ((error, stackTrace) => const Center(
                    child: Text('Erro ao carregar dados'),
                  )),
              loading: () => const BarbershopLoader(),
              data: (user) {
                final UserModel(:id, :name) = user;
                return CustomScrollView(
                  slivers: [
                    const SliverToBoxAdapter(
                      child: HomeHeader(hideFilter: true),
                    ),
                    SliverFillRemaining(
                      hasScrollBody: false,
                      child: Padding(
                        padding: const EdgeInsets.all(24.0),
                        child: Column(
                          children: [
                            const SizedBox(
                              height: 20,
                            ),
                            const AvatarWidget(
                              hideUploadButton: true,
                            ),
                            Text(
                              name,
                              style: const TextStyle(
                                  fontWeight: FontWeight.w500, fontSize: 20),
                            ),
                            Container(
                              width: MediaQuery.of(context).size.width * .7,
                              height: 108,
                              decoration: BoxDecoration(
                                  border: Border.all(
                                    color: Constants.grey,
                                  ),
                                  borderRadius: BorderRadius.circular(8)),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Consumer(builder: (context, ref, child) {
                                    final totalAsync = ref.watch(
                                        getTotalSchedulesTodayProvider(id));
                                    return totalAsync.when(
                                        error: ((error, stackTrace) =>
                                            const Center(
                                              child: Text(
                                                  'Erro ao carregar dados'),
                                            )),
                                        loading: () => const BarbershopLoader(),
                                        skipLoadingOnRefresh: false,
                                        data: (total) {
                                          return Text(
                                            total.toString(),
                                            style: const TextStyle(
                                                color: Constants.brow,
                                                fontWeight: FontWeight.w700,
                                                fontSize: 36),
                                          );
                                        });
                                  }),
                                  const Text('Hoje',
                                      style: TextStyle(
                                          color: Constants.brow,
                                          fontWeight: FontWeight.w700,
                                          fontSize: 14)),
                                ],
                              ),
                            ),
                            const SizedBox(
                              height: 25,
                            ),
                            ElevatedButton(
                              onPressed: () async {
                                await Navigator.of(context)
                                    .pushNamed('/schedule', arguments: user);
                                ref.invalidate(getTotalSchedulesTodayProvider);
                              },
                              style: ElevatedButton.styleFrom(
                                minimumSize: const Size.fromHeight(56),
                              ),
                              child: const Text('AGENDAR'),
                            ),
                            const SizedBox(
                              height: 25,
                            ),
                            OutlinedButton(
                              onPressed: () {
                                Navigator.of(context).pushNamed(
                                    '/employee/schedule',
                                    arguments: user);
                              },
                              style: ElevatedButton.styleFrom(
                                minimumSize: const Size.fromHeight(56),
                              ),
                              child: const Text('VER AGENDA'),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                );
              })),
    );
  }
}
