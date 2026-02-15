import 'package:equatable/equatable.dart';

class DailyForecast extends Equatable {
  final DateTime date;
  final double temperatureC;
  final int weatherId;

  const DailyForecast({
    required this.date,
    required this.temperatureC,
    required this.weatherId,
  });

  @override
  List<Object?> get props => [date, temperatureC, weatherId];
}
