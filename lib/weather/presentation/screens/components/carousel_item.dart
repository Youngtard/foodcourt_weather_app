import 'package:flutter/material.dart';

import '../../../../utils/app_colors.dart';
import '../../../../utils/utils.dart';

class CarouselItem extends StatelessWidget {
  const CarouselItem({
    super.key,
    required this.index,
    required this.title,
    required this.degree,
    required this.description,
  });

  final int index;
  final String title, degree, description;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: index == 0
            ? kBlueColor
            : index == 1
                ? kOrangeColor
                : index == 2
                    ? kRedColor
                    : null,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: textTheme.headlineLarge!.copyWith(
              color: Colors.white,
              fontWeight: FontWeight.w400,
            ),
          ),
          const SizedBox(
            height: 24,
          ),
          Text(
            degree,
            style: textTheme.headlineLarge!.copyWith(
              fontSize: 48,
              color: Colors.white,
            ),
          ),
          Text(
            description,
            style: textTheme.bodyLarge!.copyWith(
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }
}
