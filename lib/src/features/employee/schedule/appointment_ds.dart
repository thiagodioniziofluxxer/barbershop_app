import 'package:barbershop/src/core/ui/contants.dart';
import 'package:barbershop/src/model/schedule_model.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';

class AppointmentDs extends CalendarDataSource {
  final List<ScheduleModel> schedules;
  AppointmentDs({
    required this.schedules,
  });

  @override
  List<dynamic>? get appointments {
    print(schedules);
    return schedules.map((e) {
      final ScheduleModel(
        date: DateTime(:year, :month, :day),
        :clientName,
        :hour
      ) = e;

      final startTime = DateTime(year, month, day, hour, 0, 0);
      final endTime = DateTime(year, month, day, hour + 1, 0, 0);
      print(startTime);
      print(endTime);
      return Appointment(
        startTime: startTime,
        endTime: endTime,
        subject: clientName,
        color: Constants.brow,
      );
    }).toList();
  }
}
