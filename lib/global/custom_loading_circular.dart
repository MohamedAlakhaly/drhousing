import 'package:apartment_rentals/core/constant/app_colors.dart';
import 'package:apartment_rentals/core/functions/helper_functions.dart';
import 'package:flutter/material.dart';
import 'package:get/route_manager.dart';

class CustomLoadingCircular extends StatelessWidget {
  const CustomLoadingCircular({super.key});

  @override
  Widget build(BuildContext context) {
    bool isDarkMode = HelperFunctions.isDarkMode(context);
    return Column(
      children: [
        SizedBox(height: Get.height / 3, width: double.infinity),
        Container(
          padding: EdgeInsets.all(20),
          decoration: BoxDecoration(
            color:isDarkMode? Colors.grey[900]:Colors.grey[200],
            borderRadius: BorderRadius.circular(12),
          ),
          child: CircularProgressIndicator(color: HelperFunctions.getPrimary(context)),
        ),
      ],
    );
  }
}
