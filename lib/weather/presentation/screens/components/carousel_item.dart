import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:foodcourt_weather/utils/constants.dart';
import 'package:foodcourt_weather/weather/domain/models/weather_data.dart';
import 'package:foodcourt_weather/weather/presentation/controllers/weather_data_controller.dart';

import '../../../../utils/utils.dart';
import '../../../domain/models/city.dart';

class CarouselItem extends ConsumerStatefulWidget {
  const CarouselItem({
    super.key,
    required this.index,
    required this.bgColor,
    required this.city,
  });

  final int index;
  final Color bgColor;
  final City city;

  @override
  ConsumerState<CarouselItem> createState() => _CarouselItemState();
}

class _CarouselItemState extends ConsumerState<CarouselItem> {
  late final _city = widget.city;

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      ref.read(weatherDataProvider(_city).notifier).fetchData(
            latitude: _city.latitude,
            longitude: _city.longitude,
          );
    });
  }

  @override
  Widget build(BuildContext context) {
    ref.listen<AsyncValue<WeatherData?>>(
      weatherDataProvider(_city),
      (_, state) => state.whenOrNull(
        error: (error, stack) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                error.toString(),
              ),
            ),
          );
        },
      ),
    );

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: widget.bgColor,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                _city.name,
                style: textTheme.headlineLarge!.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.w400,
                ),
              ),
              const SizedBox(
                width: 8,
              ),
              IconButton(
                onPressed: () {
                  WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
                    ref.read(weatherDataProvider(_city).notifier).fetchData(
                          latitude: _city.latitude,
                          longitude: _city.longitude,
                        );
                  });
                },
                icon: const Icon(
                  Icons.refresh_rounded,
                  color: Colors.white,
                ),
              ),
            ],
          ),
          const SizedBox(
            height: 12,
          ),
          ref.watch(weatherDataProvider(_city)).when(
                data: (data) {
                  if (data != null) {
                    final description = data.weather != null && data.weather!.isNotEmpty ? data.weather![0].description ?? "" : "";

                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "${data.main?.temp ?? kNotAvailable}°",
                          style: textTheme.headlineLarge!.copyWith(
                            fontSize: 48,
                            color: Colors.white,
                          ),
                        ),
                        Text(
                          description.capitalize(),
                          style: textTheme.bodyLarge!.copyWith(
                            color: Colors.white,
                          ),
                        ),
                        Text(
                          "Feels like: ${data.main?.feelsLike ?? kNotAvailable}°",
                          style: textTheme.bodyLarge!.copyWith(
                            color: Colors.white,
                          ),
                        ),
                      ],
                    );
                  }

                  return const SizedBox();
                },
                error: (e, s) => const SizedBox(),
                loading: () => const FittedBox(
                  child: SpinKitPulse(
                    color: Colors.white,
                  ),
                ),
              ),
        ],
      ),
    );
  }
}
