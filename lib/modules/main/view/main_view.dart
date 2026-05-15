import 'package:apartment_rentals/core/constant/app_state.dart';
import 'package:apartment_rentals/modules/main/widget/custom_navigation_bar.dart';
import 'package:apartment_rentals/modules/navigation_items/bookings/view/bookings_view.dart';
import 'package:apartment_rentals/modules/navigation_items/home/view/home_view.dart';
import 'package:apartment_rentals/modules/navigation_items/profile/view/profile_view.dart';
import 'package:apartment_rentals/modules/navigation_items/saved/view/saved_view.dart';
import 'package:flutter/material.dart';

class MainView extends StatelessWidget {
  final List<Widget> pages = const [
    HomeView(),
    SavedView(),
    BookingsView(),
    ProfileView(),
  ];

  const MainView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          ValueListenableBuilder(
            valueListenable: AppState.currentIndex,
            builder: (context, index, _) {
              return Padding(
                padding: const EdgeInsets.only(bottom: 80),
                child: pages[index],
              );
            },
          ),
          Positioned(
            bottom: 16,
            left: 0,
            right: 0,
            child: const CustomNavBar(),
          ),
        ],
      ),
    );
  }
}
