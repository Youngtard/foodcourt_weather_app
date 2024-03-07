import 'package:collection/collection.dart';
import 'package:equatable/equatable.dart';
import 'package:hive/hive.dart';

part 'city.g.dart';

@HiveType(typeId: 0)
class City extends Equatable {
  @HiveField(0)
  final String name;

  @HiveField(1)
  final double latitude;

  @HiveField(2)
  final double longitude;

  const City({
    required this.name,
    required this.latitude,
    required this.longitude,
  });

  @override
  List<Object?> get props => [
        name,
        latitude,
        longitude,
      ];
}

final cities = List<City>.unmodifiable(
  const [
    City(
      name: "Lagos",
      latitude: 6.4550,
      longitude: 3.3841,
    ),
    City(
      name: "Kano",
      latitude: 12.0000,
      longitude: 8.5167,
    ),
    City(
      name: "Abuja",
      latitude: 9.0667,
      longitude: 7.4833,
    ),
    City(
      name: "Ibadan",
      latitude: 7.3964,
      longitude: 3.9167,
    ),
    City(
      name: "Port Harcourt",
      latitude: 4.8242,
      longitude: 7.0336,
    ),
    City(
      name: "Aba",
      latitude: 5.1167,
      longitude: 7.3667,
    ),
    City(
      name: "Onitsha",
      latitude: 6.1667,
      longitude: 6.7833,
    ),
    City(
      name: "Maiduguri",
      latitude: 11.8333,
      longitude: 13.1500,
    ),
    City(
      name: "Benin City",
      latitude: 6.3333,
      longitude: 5.6222,
    ),
    City(
      name: "Shagamu",
      latitude: 6.8333,
      longitude: 3.6500,
    ),
    City(
      name: "Ikare",
      latitude: 7.5167,
      longitude: 5.7500,
    ),
    City(
      name: "Ogbomoso",
      latitude: 8.1333,
      longitude: 4.2500,
    ),
    City(
      name: "Owerri",
      latitude: 5.4833,
      longitude: 7.0333,
    ),
    City(
      name: "Ikeja",
      latitude: 6.6186,
      longitude: 3.3426,
    ),
    City(
      name: "Osogbo",
      latitude: 7.7667,
      longitude: 4.5667,
    ),
  ].sorted(
    (a, b) => a.name.compareTo(b.name),
  ),
);
