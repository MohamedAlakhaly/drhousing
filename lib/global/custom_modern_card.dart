import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

class BuildModernCard extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final String title;
  final List<String> items;
  final String footerText;
  final Color borderColor;
  final bool isDarkMode;
  const BuildModernCard({
    super.key,
    required this.icon,
    required this.iconColor,
    required this.title,
    required this.items,
    required this.footerText,
    required this.borderColor,
    required this.isDarkMode,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: isDarkMode ? Colors.grey[900] : Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: borderColor.withValues(alpha: 0.25),
          width: 2,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
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
                      color: iconColor.withValues(alpha: 0.2),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(icon, color: iconColor, size: 28),
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
                child:
                    Text(
                          title,
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: isDarkMode ? Colors.white : Colors.black87,
                          ),
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

          ...items.asMap().entries.map((entry) {
            final index = entry.key;
            final item = entry.value;
            return Padding(
                  padding: const EdgeInsets.only(bottom: 10),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        margin: const EdgeInsets.only(top: 6),
                        width: 6,
                        height: 6,
                        decoration: BoxDecoration(
                          color: iconColor,
                          shape: BoxShape.circle,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          item,
                          style: TextStyle(
                            fontSize: 15,
                            height: 1.6,
                            color: Colors.grey[isDarkMode ? 300 : 700],
                          ),
                        ),
                      ),
                    ],
                  ),
                )
                .animate()
                .fadeIn(
                  duration: const Duration(milliseconds: 400),
                  delay: Duration(milliseconds: 200 + (index * 100)),
                )
                .slideX(
                  begin: -0.2,
                  end: 0,
                  duration: const Duration(milliseconds: 400),
                  delay: Duration(milliseconds: 200 + (index * 100)),
                );
          }),

          const SizedBox(height: 12),

          Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: iconColor.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  children: [
                    Icon(Icons.info_outline, color: iconColor, size: 18),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        footerText,
                        style: const TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                          fontStyle: FontStyle.italic,
                        ),
                      ),
                    ),
                  ],
                ),
              )
              .animate()
              .fadeIn(
                duration: const Duration(milliseconds: 400),
                delay: Duration(milliseconds: 200 + (items.length * 100)),
              )
              .slideY(
                begin: 0.2,
                end: 0,
                duration: const Duration(milliseconds: 400),
                delay: Duration(milliseconds: 200 + (items.length * 100)),
              ),
        ],
      ),
    );
  }
}
