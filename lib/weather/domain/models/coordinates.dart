import 'package:equatable/equatable.dart';

class CoordinatesData extends Equatable {
  final double? lon;
  final double? lat;

  const CoordinatesData({
    this.lon,
    this.lat,
  });

  factory CoordinatesData.fromJson(Map<String, dynamic> json) => CoordinatesData(
        lon: json["lon"]?.toDouble(),
        lat: json["lat"]?.toDouble(),
      );

  Map<String, dynamic> toJson() => {
        "lon": lon,
        "lat": lat,
      };

  @override
  List<Object?> get props => [
        lon,
        lat,
      ];
}
