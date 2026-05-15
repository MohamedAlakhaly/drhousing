import 'package:apartment_rentals/core/constant/app_text_style.dart';
import 'package:apartment_rentals/models/data/on_boarding_data.dart';
import 'package:apartment_rentals/modules/auth/on_boarding/controller/on_boarding_controller.getx.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';

import 'package:flutter_animate/flutter_animate.dart';

class OnBoardingPageViewWidget extends StatelessWidget {
  const OnBoardingPageViewWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    OnBoardingControllerImp controller = Get.find();
    return SizedBox(
      height: 570,
      //! This is page view for on-boarding view
      child: PageView.builder(
          controller: controller.pageController,
          onPageChanged: (val) {
            controller.currentPage = val;
            controller.addPercent();
          },
          itemCount: onBoardingData.length,
          itemBuilder: (context, index) {
            return Column(
              children: [
                //! This section for add photo to page view with animation
                SvgPicture.asset(
                  onBoardingData[index].imagePath,
                  height: 380,
                  
                )
                    .animate()
                    .move(
                        delay: 300.ms,
                        duration: 600.ms,
                        begin: controller.currentPage == 2
                            ? const Offset(0, -50)
                            : const Offset(0, 50))
                    .fadeIn(duration: const Duration(milliseconds: 600)),
                const SizedBox(height: 10),
                //! This section to add title and subtitle to page view with animation
                Column(
                  children: [
                    Text(
                      textAlign: TextAlign.center,
                      onBoardingData[index].title.tr,
                      style: AppTextStyle.titleStyle,
                    )
                        .animate()
                        .move(
                            delay: 400.ms,
                            duration: 700.ms,
                            begin: controller.currentPage == 2
                                ? const Offset(0, -50)
                                : const Offset(0, 50))
                        .fadeIn(duration: const Duration(milliseconds: 700)),
                    const SizedBox(height: 10),
                    Text(
                      textAlign: TextAlign.center,
                      onBoardingData[index].content.tr,
                      style: AppTextStyle.contentStyle,
                    )
                        .animate()
                        .move(
                            delay: 500.ms,
                            duration: 800.ms,
                            begin: controller.currentPage == 2
                                ? const Offset(0, -50)
                                : const Offset(0, 50))
                        .fadeIn(duration: const Duration(milliseconds: 800)),
                  ],
                ),
              ],
            );
          }),
    );
  }
}
