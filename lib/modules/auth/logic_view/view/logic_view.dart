import 'package:apartment_rentals/core/constant/app_colors.dart';
import 'package:apartment_rentals/core/functions/helper_functions.dart';
import 'package:apartment_rentals/modules/auth/logic_view/controller/logic_auth_controller.getx.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class LogicView extends StatelessWidget {
  const LogicView({super.key});

  @override
  Widget build(BuildContext context) {
    Get.put(LogicAuthControllerImp());
    bool isDarkMode = HelperFunctions.isDarkMode(context);

    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const SizedBox(width: double.infinity),
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: isDarkMode ? Colors.grey[900] : Colors.grey[300],
              borderRadius: BorderRadius.circular(12),
            ),
            child: CircularProgressIndicator(color: AppColors.primary),
          ),
        ],
      ),
    );
  }
}