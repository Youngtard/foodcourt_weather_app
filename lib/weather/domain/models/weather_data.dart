import 'package:equatable/equatable.dart';
import 'package:foodcourt_weather/weather/domain/models/coordinates.dart';
import 'package:foodcourt_weather/weather/domain/models/weather.dart';

class WeatherData extends Equatable {
  final CoordinatesData? coordinates;
  final List<Weather>? weather;
  final String? base;
  final Main? main;
  final int? visibility;
  final int? dt;
  final int? timezone;
  final int? id;
  final String? name;
  final int? cod;

  const WeatherData({
    this.coordinates,
    this.weather,
    this.base,
    this.main,
    this.visibility,
    this.dt,
    this.timezone,
    this.id,
    this.name,
    this.cod,
  });

  factory WeatherData.fromJson(Map<String, dynamic> json) => WeatherData(
    coordinates: json["coord"] == null ? null : CoordinatesData.fromJson(json["coord"]),
    weather: json["weather"] == null ? [] : List<Weather>.from(json["weather"]!.map((x) => Weather.fromJson(x))),
    base: json["base"],
    main: json["main"] == null ? null : Main.fromJson(json["main"]),
    visibility: json["visibility"],
    dt: json["dt"],
    timezone: json["timezone"],
    id: json["id"],
    name: json["name"],
    cod: json["cod"],
  );

  Map<String, dynamic> toJson() => {
    "coord": coordinates?.toJson(),
    "weather": weather == null ? [] : List<dynamic>.from(weather!.map((x) => x.toJson())),
    "base": base,
    "main": main?.toJson(),
    "visibility": visibility,
    "dt": dt,
    "timezone": timezone,
    "id": id,
    "name": name,
    "cod": cod,
  };

  @override
  List<Object?> get props => [
        coordinates,
        weather,
        base,
        main,
        visibility,
        dt,
        timezone,
        id,
        name,
        cod,
      ];
}

class Main extends Equatable {
  final double? temp;
  final double? feelsLike;
  final double? tempMin;
  final double? tempMax;
  final int? pressure;
  final int? humidity;
  final int? seaLevel;
  final int? grndLevel;

  const Main({
    this.temp,
    this.feelsLike,
    this.tempMin,
    this.tempMax,
    this.pressure,
    this.humidity,
    this.seaLevel,
    this.grndLevel,
  });

  factory Main.fromJson(Map<String, dynamic> json) => Main(
    temp: json["temp"]?.toDouble(),
    feelsLike: json["feels_like"]?.toDouble(),
    tempMin: json["temp_min"]?.toDouble(),
    tempMax: json["temp_max"]?.toDouble(),
    pressure: json["pressure"],
    humidity: json["humidity"],
    seaLevel: json["sea_level"],
    grndLevel: json["grnd_level"],
  );

  Map<String, dynamic> toJson() => {
    "temp": temp,
    "feels_like": feelsLike,
    "temp_min": tempMin,
    "temp_max": tempMax,
    "pressure": pressure,
    "humidity": humidity,
    "sea_level": seaLevel,
    "grnd_level": grndLevel,
  };

  @override
  List<Object?> get props => [
        temp,
        feelsLike,
        tempMin,
        tempMax,
        pressure,
        humidity,
        seaLevel,
        grndLevel,
      ];
}
