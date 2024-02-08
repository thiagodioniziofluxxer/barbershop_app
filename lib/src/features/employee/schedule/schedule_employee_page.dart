import 'package:barbershop/src/core/ui/contants.dart';
import 'package:barbershop/src/core/ui/widgets/barbershop_loader.dart';
import 'package:barbershop/src/features/employee/schedule/appointment_ds.dart';
import 'package:barbershop/src/features/employee/schedule/employee_schedule_vm.dart';
import 'package:barbershop/src/model/user_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';

class ScheduleEmployeePage extends ConsumerStatefulWidget {
  const ScheduleEmployeePage({super.key});

  @override
  ConsumerState<ScheduleEmployeePage> createState() =>
      _ScheduleEmployeePageState();
}

class _ScheduleEmployeePageState extends ConsumerState<ScheduleEmployeePage> {
  late DateTime dateSelected;
  var ignoreFirstLoad = true;
  @override
  void initState() {
    final DateTime(:year, :month, :day) = DateTime.now();
    dateSelected = DateTime(year, month, day);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final UserModel(id: userId, :name) =
        ModalRoute.of(context)?.settings.arguments as UserModel;

    final scheduleAsync =
        ref.watch(employeeScheduleVmProvider(userId, dateSelected));

    return Scaffold(
        appBar: AppBar(
          title: const Text('Agenda'),
        ),
        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              Text(
                name,
                style:
                    const TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
              ),
              const SizedBox(
                height: 44,
              ),
              scheduleAsync.when(
                  loading: () => const BarbershopLoader(),
                  error: (error, stackTrace) {
                    return const Center(
                      child: Text('Erro ao buscar agendamentos'),
                    );
                  },
                  data: (schedules) {
                    return Expanded(
                        child: SfCalendar(
                      allowViewNavigation: true,
                      view: CalendarView.day,
                      showNavigationArrow: true,
                      todayHighlightColor: Constants.brow,
                      showDatePickerButton: true,
                      showTodayButton: true,
                      dataSource: AppointmentDs(schedules: schedules),
                      onViewChanged: (viewChangedDetails) {
                        if (ignoreFirstLoad) {
                          ignoreFirstLoad = false;
                          return;
                        }
                        ref
                            .read(
                                employeeScheduleVmProvider(userId, dateSelected)
                                    .notifier)
                            .changeDate(
                                userId, viewChangedDetails.visibleDates.first);
                      },
                      onTap: (calendarTapDetails) => {
                        if (calendarTapDetails.appointments != null &&
                            calendarTapDetails.appointments!.isNotEmpty)
                          {
                            showModalBottomSheet(
                                context: context,
                                builder: (context) {
                                  final DateFormat dateFormat =
                                      DateFormat('dd/MM/yyyy HH:mm');
                                  return SizedBox(
                                    height: 200,
                                    child: Center(
                                      child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Text(
                                                'Cliente: ${calendarTapDetails.appointments?.first.subject}'),
                                            Text(
                                                'Horário: ${dateFormat.format(calendarTapDetails.date ?? DateTime.now())}'),
                                          ]),
                                    ),
                                  );
                                })
                          }
                      },
                    ));
                  }),
            ],
          ),
        ));
  }
}
