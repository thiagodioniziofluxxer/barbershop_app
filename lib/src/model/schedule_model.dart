class ScheduleModel {
  final int id;
  final int barbershopId;
  final int userId;
  final String clientName;
  final DateTime date;
  final int hour;

  ScheduleModel(
      {required this.id,
      required this.barbershopId,
      required this.userId,
      required this.clientName,
      required this.date,
      required this.hour});

  factory ScheduleModel.fromMap(Map<String, dynamic> json) {
    print(json);

    return switch (json) {
      {
        'id': int id,
        'barbershop_id': int barbershopId,
        'user_id': int userId,
        'client_name': String clientName,
        'date': String dateJson,
        'time': int hour,
      } =>
        ScheduleModel(
            id: id,
            barbershopId: barbershopId,
            userId: userId,
            clientName: clientName,
            date: DateTime.parse(dateJson),
            hour: hour),
      _ => throw Exception('Erro encontrado na conversao do agendamento'),
    };
  }
}
