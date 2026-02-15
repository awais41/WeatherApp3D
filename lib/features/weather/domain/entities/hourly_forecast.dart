import 'package:equatable/equatable.dart';

class HourlyForecast extends Equatable {
  final DateTime time;
  final double temperatureC;
  final int weatherId;
  final String? iconCode;
  final double? rainChance;

  const HourlyForecast({
    required this.time,
    required this.temperatureC,
    required this.weatherId,
    this.iconCode,
    this.rainChance,
  });

  @override
  List<Object?> get props => [
    time,
    temperatureC,
    weatherId,
    iconCode,
    rainChance,
  ];
}
