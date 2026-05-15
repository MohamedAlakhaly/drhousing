import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

class CustomSectionForInternalRegulations extends StatelessWidget {
  const CustomSectionForInternalRegulations({
    super.key,
    required this.icon,
    required this.title,
    required this.description,
    required this.mainColor,
    required this.isDarkMode,
  });

  final IconData icon;
  final String title;
  final String description;
  final Color mainColor;
  final bool isDarkMode;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: isDarkMode ? Colors.grey[900] : Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: mainColor.withValues(alpha: 0.2)),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withValues(alpha: 0.1),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: mainColor.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(icon, color: mainColor, size: 28),
              )
                  .animate()
                  .fadeIn(duration: const Duration(milliseconds: 300))
                  .scale(
                    begin: const Offset(0.8, 0.8),
                    end: const Offset(1.0, 1.0),
                    duration: const Duration(milliseconds: 300),
                  ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  title,
                  style: const TextStyle(
                      fontSize: 20, fontWeight: FontWeight.bold),
                )
                    .animate()
                    .fadeIn(
                      duration: const Duration(milliseconds: 300),
                      delay: const Duration(milliseconds: 100),
                    )
                    .slideX(
                      begin: -0.2,
                      end: 0,
                      duration: const Duration(milliseconds: 300),
                      delay: const Duration(milliseconds: 100),
                    ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.grey[isDarkMode ? 850 : 100],
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: mainColor),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(Icons.check_circle, color: mainColor, size: 20)
                    .animate()
                    .fadeIn(
                      duration: const Duration(milliseconds: 300),
                      delay: const Duration(milliseconds: 300),
                    )
                    .scale(
                      begin: const Offset(0.5, 0.5),
                      end: const Offset(1.0, 1.0),
                      duration: const Duration(milliseconds: 300),
                      delay: const Duration(milliseconds: 300),
                    ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    description,
                    style: const TextStyle(fontSize: 15, height: 1.5),
                  )
                      .animate()
                      .fadeIn(
                        duration: const Duration(milliseconds: 400),
                        delay: const Duration(milliseconds: 400),
                      )
                      .slideX(
                        begin: -0.2,
                        end: 0,
                        duration: const Duration(milliseconds: 400),
                        delay: const Duration(milliseconds: 400),
                      ),
                ),
              ],
            ),
          )
              .animate()
              .fadeIn(
                duration: const Duration(milliseconds: 400),
                delay: const Duration(milliseconds: 200),
              )
              .slideY(
                begin: 0.2,
                end: 0,
                duration: const Duration(milliseconds: 400),
                delay: const Duration(milliseconds: 200),
              ),
        ],
      ),
    )
      ;
  }
}
