// import 'dart:ui';
// import 'package:apartment_rentals/core/constant/app_colors.dart';
// import 'package:apartment_rentals/core/constant/app_state.dart';
// import 'package:apartment_rentals/core/functions/helper_functions.dart';
// import 'package:flutter/material.dart';
// import 'package:iconsax/iconsax.dart';

// class CustomNavBar extends StatelessWidget {
//   const CustomNavBar({super.key});

//   @override
//   Widget build(BuildContext context) {
//     bool isDarkMode = HelperFunctions.isDarkMode(context);
//     return ValueListenableBuilder(
//       valueListenable: AppState.currentIndex,
//       builder: (context, index, _) {
//         return Padding(
//           padding: const EdgeInsets.all(16),
//           child: ClipRRect(
//             borderRadius: BorderRadius.circular(30),
//             child: BackdropFilter(
//               filter: ImageFilter.blur(sigmaX: 15, sigmaY: 15),
//               child: Container(
//                 padding: EdgeInsets.symmetric(vertical: 12),
//                 color: isDarkMode
//                     ? Colors.white.withValues(alpha: 0.2)
//                     : Colors.black.withValues(alpha: 0.08),
//                 child: Row(
//                   mainAxisAlignment: MainAxisAlignment.spaceAround,
//                   children: [
//                     _navItem(Iconsax.home, 0, index, isDarkMode),
//                     _navItem(Iconsax.heart, 1, index, isDarkMode),
//                     // _navItem(Iconsax.search_normal, 2, index, isDarkMode),
//                     _navItem(Iconsax.user, 2, index, isDarkMode),
//                   ],
//                 ),
//               ),
//             ),
//           ),
//         );
//       },
//     );
//   }

//   Widget _navItem(IconData icon, int i, int currentIndex, bool isDarkMode) {
//     final isSelected = i == currentIndex;

//     return GestureDetector(
//       onTap: () {
//         AppState.currentIndex.value = i;
//       },
//       child: AnimatedContainer(
//         duration: Duration(milliseconds: 300),
//         padding: EdgeInsets.all(10),
//         decoration: BoxDecoration(
//           color: isSelected ? AppColors.primary : Colors.transparent,
//           borderRadius: BorderRadius.circular(50),
//         ),
//         child: Icon(
//           icon,
//           size: isSelected ? 28 : 24,
//           color: isSelected
//               ? Colors.black
//               : isDarkMode
//               ? Colors.grey[200]
//               : Colors.grey[700],
//         ),
//       ),
//     );
//   }
// }

import 'dart:ui';
import 'package:apartment_rentals/core/constant/app_colors.dart';
import 'package:apartment_rentals/core/constant/app_state.dart';
import 'package:apartment_rentals/core/functions/helper_functions.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';

class CustomNavBar extends StatelessWidget {
  const CustomNavBar({super.key});


  @override
  Widget build(BuildContext context) {
   List items = [
    (icon: Iconsax.home_2, label: 'navigation_menu_home'.tr),
    (icon: Iconsax.heart, label: 'navigation_menu_saved'.tr),
    (icon: Iconsax.calendar, label: 'navigation_menu_bookings'.tr),
    (icon: Iconsax.user, label: 'navigation_menu_profile'.tr),
  ];


    bool isDarkMode = HelperFunctions.isDarkMode(context);
    return ValueListenableBuilder(
      valueListenable: AppState.currentIndex,
      builder: (context, currentIndex, _) {
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(30),
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
              child: Container(
                padding: const EdgeInsets.symmetric(
                  vertical: 10,
                  horizontal: 8,
                ),
                decoration: BoxDecoration(
                  color: Colors.black.withValues(alpha: isDarkMode ? 0.75 : 0.90),
                  borderRadius: BorderRadius.circular(30),
                  border: Border.all(
                    color: Colors.white.withValues(alpha: 0.06),
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: List.generate(
                    items.length,
                    (i) => _NavItem(
                      icon: items[i].icon,
                      label: items[i].label,
                      index: i,
                      currentIndex: currentIndex,
                    ),
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

class _NavItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final int index;
  final int currentIndex;

  const _NavItem({
    required this.icon,
    required this.label,
    required this.index,
    required this.currentIndex,
  });

  @override
  Widget build(BuildContext context) {
    final isSelected = index == currentIndex;

    return GestureDetector(
      onTap: () => AppState.currentIndex.value = index,
      behavior: HitTestBehavior.opaque,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 280),
        curve: Curves.easeOutCubic,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.primary : Colors.transparent,
          borderRadius: BorderRadius.circular(22),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              size: isSelected ? 20 : 22,
              color: isSelected ? Colors.black : Colors.grey[500],
            ),
            if (isSelected) ...[
              const SizedBox(width: 6),
              Text(
                label,
                style: const TextStyle(
                  color: Colors.black,
                  fontSize: 13,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
