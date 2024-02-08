import 'package:barbershop/src/core/ui/barbershop_icons.dart';
import 'package:barbershop/src/core/ui/contants.dart';
import 'package:barbershop/src/core/ui/helpers/form_helper.dart';
import 'package:barbershop/src/core/ui/helpers/messages.dart';
import 'package:barbershop/src/core/ui/widgets/avatar_widget.dart';
import 'package:barbershop/src/core/ui/widgets/hours_panel.dart';
import 'package:barbershop/src/features/schedule/schedule_state.dart';
import 'package:barbershop/src/features/schedule/schedule_vm.dart';
import 'package:barbershop/src/features/schedule/widgets/schedule_calendart.dart';
import 'package:barbershop/src/model/user_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:validatorless/validatorless.dart';

class SchedulePage extends ConsumerStatefulWidget {
  const SchedulePage({super.key});

  @override
  ConsumerState<SchedulePage> createState() => _SchedulePageState();
}

class _SchedulePageState extends ConsumerState<SchedulePage> {
  final formKey = GlobalKey<FormState>();
  final clientEC = TextEditingController();
  final dateEC = TextEditingController();
  var showCalendar = false;
  var dateFormat = DateFormat('dd/MM/yyyy');
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    clientEC.dispose();
    dateEC.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final userModel = ModalRoute.of(context)?.settings.arguments as UserModel;
    final scheduleVM = ref.watch(scheduleVmProvider.notifier);

    final employeeData = switch (userModel) {
      UserModelAdm(:final workDays, :final workHours) => (
          workDays: workDays!,
          workHours: workHours!
        ),
      UserModelEmployee(:final workDays, :final workHours) => (
          workDays: workDays,
          workHours: workHours
        ),
      UserModel() => null,
    };

    ref.listen(scheduleVmProvider.select((state) => state.status), (_, status) {
      switch (status) {
        case ScheduleStateStatus.initial:
          break;
        case ScheduleStateStatus.success:
          Messages.showSuccessMessage(
              'Agendamento realizado com sucesso', context);
          Navigator.of(context).pop();
        case ScheduleStateStatus.error:
          Messages.showErrorMessage('Erro ao realizar agendamento', context);
      }
    });

    return Scaffold(
      appBar: AppBar(
        title: const Text('Agendar Cliente'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(5.0),
          child: Center(
            child: Form(
              key: formKey,
              child: Column(
                children: [
                  const AvatarWidget(hideUploadButton: true),
                  const SizedBox(
                    height: 24,
                  ),
                  Text(
                    userModel.name,
                    style: const TextStyle(
                        fontSize: 20, fontWeight: FontWeight.w500),
                  ),
                  TextFormField(
                    controller: clientEC,
                    onTapOutside: (_) => context.unfocus(),
                    validator: Validatorless.required('Nome é obrigatório'),
                    decoration: const InputDecoration(
                      labelText: 'Nome',
                    ),
                  ),
                  const SizedBox(
                    height: 24,
                  ),
                  TextFormField(
                    controller: dateEC,
                    readOnly: true,
                    validator: Validatorless.required('Data é obrigatória'),
                    onTap: () {
                      setState(() {
                        showCalendar = !showCalendar;
                        context.unfocus();
                      });
                    },
                    onTapOutside: (_) => context.unfocus(),
                    decoration: const InputDecoration(
                      labelText: 'Selecione uma data',
                      hintText: 'Selecione uma data',
                      floatingLabelBehavior: FloatingLabelBehavior.never,
                      suffixIcon: Icon(
                        BarbershopIcons.calendar,
                        color: Constants.brow,
                        size: 20,
                      ),
                    ),
                  ),
                  Offstage(
                    offstage: !showCalendar,
                    child: Column(
                      children: [
                        const SizedBox(
                          height: 24,
                        ),
                        ScheduleCalendart(
                          onCancel: () {
                            setState(() {
                              showCalendar = false;
                            });
                          },
                          workDays: employeeData?.workDays ?? [],
                          onSelectedValue: (DateTime value) {
                            setState(() {
                              dateEC.text = dateFormat.format(value);
                              scheduleVM.dateSelect(value);
                              showCalendar = false;
                            });
                          },
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 24,
                  ),
                  HoursPanel.singleSelection(
                    startTime: 6,
                    endTime: 24,
                    onHourPressed: scheduleVM.hourSelect,
                    enabledHours: employeeData?.workHours,
                  ),
                  const SizedBox(
                    height: 24,
                  ),
                  ElevatedButton(
                    onPressed: () {
                      switch (formKey.currentState?.validate()) {
                        case null || false:
                          Messages.showErrorMessage('Dados inválidos', context);
                          break;
                        case true:
                          final hourSelected = ref.watch(scheduleVmProvider
                              .select((state) => state.scheduleHour != null));
                          if (hourSelected) {
                            scheduleVM.register(
                                userModel: userModel,
                                clientName: clientEC.text);
                          } else {
                            Messages.showErrorMessage(
                                'Por favor selecione um horario de atendimento',
                                context);
                          }
                          break;
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      minimumSize: const Size.fromHeight(56),
                    ),
                    child: const Text('AGENDAR'),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
