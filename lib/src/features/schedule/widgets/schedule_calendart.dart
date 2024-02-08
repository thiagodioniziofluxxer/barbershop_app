// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:developer';

import 'package:barbershop/src/core/ui/helpers/messages.dart';
import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';

import 'package:barbershop/src/core/ui/contants.dart';

class ScheduleCalendart extends StatefulWidget {
  final VoidCallback onCancel;
  final ValueChanged<DateTime> onSelectedValue;

  final List<String> workDays;
  const ScheduleCalendart({
    Key? key,
    required this.onCancel,
    required this.onSelectedValue,
    required this.workDays,
  }) : super(key: key);

  @override
  State<ScheduleCalendart> createState() => _ScheduleCalendartState();
}

class _ScheduleCalendartState extends State<ScheduleCalendart> {
  DateTime? _selectedDay;
  late final List<int> weekDaysEnabled;

  int convertWeekDay(String weekDay) {
    return switch (weekDay.toLowerCase()) {
      'seg' => DateTime.monday,
      'ter' => DateTime.tuesday,
      'qua' => DateTime.wednesday,
      'qui' => DateTime.thursday,
      'sex' => DateTime.friday,
      'sab' => DateTime.saturday,
      'dom' => DateTime.sunday,
      _ => DateTime.monday,
    };
  }

  @override
  void initState() {
    weekDaysEnabled = widget.workDays.map((e) => convertWeekDay(e)).toList();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: const Color(0XFFE6E2E9),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        children: [
          TableCalendar(
            availableGestures: AvailableGestures.none,
            headerStyle: const HeaderStyle(titleCentered: true),
            focusedDay: DateTime.now(),
            firstDay: DateTime.now(),
            lastDay: DateTime.now().add(const Duration(days: 365)),
            calendarFormat: CalendarFormat.month,
            locale: 'pt_BR',
            enabledDayPredicate: (day) {
              return weekDaysEnabled.contains(day.weekday);
            },
            availableCalendarFormats: const {
              CalendarFormat.month: 'Month',
            },
            calendarStyle: CalendarStyle(
              selectedDecoration: const BoxDecoration(
                color: Constants.brow,
                shape: BoxShape.circle,
              ),
              todayDecoration: BoxDecoration(
                color: Constants.brow.withOpacity(0.5),
                shape: BoxShape.circle,
              ),
              todayTextStyle: const TextStyle(color: Colors.white),
            ),
            onDaySelected: (selectedDay, focusedDay) {
              setState(() {
                _selectedDay = selectedDay;
              });
            },
            selectedDayPredicate: (day) {
              return isSameDay(_selectedDay, day);
            },
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              TextButton(
                onPressed: () {
                  widget.onCancel();
                },
                child: const Text(
                  'Cancelar',
                  style: TextStyle(
                      color: Constants.brow,
                      fontWeight: FontWeight.w400,
                      fontSize: 14),
                ),
              ),
              TextButton(
                onPressed: () {
                  log(_selectedDay.toString());
                  if (_selectedDay == null) {
                    Messages.showErrorMessage(
                        'Por favor selecione um dia', context);
                    return;
                  }

                  widget.onSelectedValue(_selectedDay!);
                },
                child: const Text(
                  'OK',
                  style: TextStyle(
                      color: Constants.brow,
                      fontWeight: FontWeight.bold,
                      fontSize: 14),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
