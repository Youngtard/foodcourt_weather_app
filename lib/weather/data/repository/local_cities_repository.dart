import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:foodcourt_weather/utils/hive_constants.dart';
import 'package:foodcourt_weather/weather/domain/models/city.dart';
import 'package:hive/hive.dart';

import '../../../utils/constants.dart';

final localCitiesRepositoryProvider = Provider<LocalCitiesRepository>((ref) {
  return LocalCitiesRepository();
});

class LocalCitiesRepository {
  LocalCitiesRepository();

  final _citiesBox = Hive.box<List>(HiveConstants.citiesBox);

  Future<void> persistCities(List<City> cities) async {
    try {
      await _citiesBox.put(HiveConstants.citiesKey, cities);
    } catch (e) {
      throw kAnErrorOccurred;
    }
  }

  List<City>? getCities() {
    return _citiesBox.get(HiveConstants.citiesKey, defaultValue: [])?.cast<City>();
  }
}
