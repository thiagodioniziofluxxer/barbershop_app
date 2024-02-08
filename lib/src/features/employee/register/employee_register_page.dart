import 'dart:developer';

import 'package:barbershop/src/core/providers/application_providers.dart';
import 'package:barbershop/src/core/ui/helpers/form_helper.dart';
import 'package:barbershop/src/core/ui/helpers/messages.dart';
import 'package:barbershop/src/core/ui/widgets/avatar_widget.dart';
import 'package:barbershop/src/core/ui/widgets/barbershop_loader.dart';
import 'package:barbershop/src/core/ui/widgets/hours_panel.dart';
import 'package:barbershop/src/features/employee/register/employee_register_state.dart';
import 'package:barbershop/src/features/employee/register/employee_register_vm.dart';
import 'package:barbershop/src/model/barbershop_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:validatorless/validatorless.dart';

import '../../../core/ui/widgets/weekdays_panel.dart';

class EmployeeRegisterPage extends ConsumerStatefulWidget {
  const EmployeeRegisterPage({super.key});

  @override
  ConsumerState<EmployeeRegisterPage> createState() =>
      _EmployeeRegisterPageState();
}

class _EmployeeRegisterPageState extends ConsumerState<EmployeeRegisterPage> {
  final formKey = GlobalKey<FormState>();
  final nameEC = TextEditingController();
  final emailEC = TextEditingController();
  final passwordEC = TextEditingController();
  var registerAdm = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    nameEC.dispose();
    emailEC.dispose();
    passwordEC.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final employeeRegisterVm = ref.watch(employeeRegisterVmProvider.notifier);
    final barberShopAsyncValue = ref.watch(getMyBarbershopProvider);

    ref.listen(employeeRegisterVmProvider.select((state) => state.status),
        (_, status) {
      switch (status) {
        case EmployeeRegisterStateStatus.initial:
          break;
        case EmployeeRegisterStateStatus.success:
          Messages.showSuccessMessage(
              'Colaborador cadastrado com sucesso', context);
          Navigator.of(context).pop();
          
        case EmployeeRegisterStateStatus.error:
          Messages.showErrorMessage('Erro ao cadastrar colaborador', context);
          break;
        default:
          break;
      }
    });

    return SafeArea(
      child: Scaffold(
          appBar: AppBar(
            title: const Text('Cadastrar colaborador'),
          ),
          body: barberShopAsyncValue.when(
              error: (error, stack) {
                log("Erro ao carregar a pagina",
                    error: error, stackTrace: stack);
                return const Center(
                  child: Text('Erro ao carregar a pagina'),
                );
              },
              loading: () => const BarbershopLoader(),
              data: (barbershopModel) {
                final BarbershopModel(:openingDays, :openingHours) =
                    barbershopModel;

                return SingleChildScrollView(
                  // ignore: unnecessary_const
                  child: Padding(
                    padding: const EdgeInsets.all(15.0),
                    child: Center(
                      child: Form(
                        key: formKey,
                        child: Column(children: [
                          const AvatarWidget(),
                          const SizedBox(
                            height: 32,
                          ),
                          Row(
                            children: [
                              Checkbox.adaptive(
                                  value: registerAdm,
                                  onChanged: (value) {
                                    setState(() {
                                      registerAdm = !registerAdm;
                                      employeeRegisterVm
                                          .setRegisterAdm(registerAdm);
                                    });
                                  }),
                              const Expanded(
                                child: Text(
                                  'Sou administrador e quero me cadastrar como colaborador',
                                  style: TextStyle(fontSize: 14),
                                ),
                              )
                            ],
                          ),
                          Offstage(
                            offstage: registerAdm,
                            child: Column(
                              children: [
                                TextFormField(
                                  controller: nameEC,
                                  onTapOutside: (_) => context.unfocus(),
                                  validator: registerAdm
                                      ? null
                                      : Validatorless.required(
                                          'Nome é obrigatório'),
                                  decoration: const InputDecoration(
                                    labelText: 'Nome',
                                  ),
                                ),
                                const SizedBox(
                                  height: 24,
                                ),
                                TextFormField(
                                  controller: emailEC,
                                  onTapOutside: (_) => context.unfocus(),
                                  validator: registerAdm
                                      ? null
                                      : Validatorless.multiple([
                                          Validatorless.required(
                                              'Email é obrigatório'),
                                          Validatorless.email('Email inválido'),
                                        ]),
                                  decoration: const InputDecoration(
                                    labelText: 'Email',
                                  ),
                                ),
                                const SizedBox(
                                  height: 24,
                                ),
                                TextFormField(
                                  controller: passwordEC,
                                  obscureText: true,
                                  onTapOutside: (_) => context.unfocus(),
                                  validator: registerAdm
                                      ? null
                                      : Validatorless.multiple([
                                          Validatorless.required(
                                              'Senha é obrigatória'),
                                          Validatorless.min(
                                              6, 'Senha muito curta'),
                                        ]),
                                  decoration: const InputDecoration(
                                    labelText: 'Senha',
                                  ),
                                ),
                                const SizedBox(
                                  height: 24,
                                ),
                              ],
                            ),
                          ),
                          WeekdaysPanel(
                            enabledDays: openingDays,
                            onDayPressed: employeeRegisterVm.addOrRemoveWorkDay,
                          ),
                          const SizedBox(
                            height: 24,
                          ),
                          HoursPanel(
                            enabledHours: openingHours,
                            startTime: 6,
                            endTime: 20,
                            onHourPressed:
                                employeeRegisterVm.addOrRemoveWorkHour,
                          ),
                          const SizedBox(
                            height: 24,
                          ),
                          ElevatedButton(
                            onPressed: () {
                              switch (formKey.currentState?.validate()) {
                                case null || false:
                                  Messages.showErrorMessage(
                                      'Dados inválidos', context);
                                  break;
                                case true:
                                  final EmployeeRegisterState(
                                    workDays: List(isNotEmpty: hasWorkDays),
                                    workHours: List(isNotEmpty: hasWorkHours),
                                  ) = ref.watch(employeeRegisterVmProvider);
                                  if (!hasWorkDays || !hasWorkHours) {
                                    Messages.showErrorMessage(
                                        'Selecione pelo menos um dia e um horário de trabalho',
                                        context);
                                    return;
                                  }

                                  employeeRegisterVm.registerEmployee(
                                    name: nameEC.text,
                                    email: emailEC.text,
                                    password: passwordEC.text,
                                  );
                                  break;
                              }
                            },
                            style: ElevatedButton.styleFrom(
                              minimumSize: const Size.fromHeight(56),
                            ),
                            child: const Text('CADASTRAR MEU ESTABELECIMENTO'),
                          ),
                        ]),
                      ),
                    ),
                  ),
                );
              })),
    );
  }
}
