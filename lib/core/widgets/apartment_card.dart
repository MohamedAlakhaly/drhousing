import 'package:apartment_rentals/core/constant/app_colors.dart';
import 'package:apartment_rentals/core/functions/helper_functions.dart';
import 'package:apartment_rentals/models/static/apartment_model.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';

// ─── Public widget ────────────────────────────────────────────────────────────

class ApartmentCard extends StatelessWidget {
  final ApartmentModel apartment;
  final VoidCallback onTap;
  final VoidCallback onFavoriteToggle;

  const ApartmentCard({
    super.key,
    required this.apartment,
    required this.onTap,
    required this.onFavoriteToggle,
  });

  @override
  Widget build(BuildContext context) {
    final bool isDark = HelperFunctions.isDarkMode(context);
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: isDark ? AppColors.bgCard : AppColors.bgCardLight,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isDark ? AppColors.divider : AppColors.borderLight,
          ),
          boxShadow: isDark
              ? null
              : [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.07),
                    blurRadius: 16,
                    offset: const Offset(0, 4),
                  ),
                ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _ImageSection(
              apartment: apartment,
              onFavoriteToggle: onFavoriteToggle,
            ),
            _InfoSection(apartment: apartment, isDark: isDark),
          ],
        ),
      ),
    );
  }
}

// ── Image section ─────────────────────────────────────────────────────────────

class _ImageSection extends StatelessWidget {
  final ApartmentModel apartment;
  final VoidCallback onFavoriteToggle;

  const _ImageSection({
    required this.apartment,
    required this.onFavoriteToggle,
  });

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
      child: SizedBox(
        height: 190,
        width: double.infinity,
        child: Stack(
          fit: StackFit.expand,
          children: [
            // ── Photo ──
            apartment.imageUrl != null
                ? CachedNetworkImage(
                    imageUrl: apartment.imageUrl!,
                    fit: BoxFit.cover,
                    placeholder: (_, _) => const _ImagePlaceholder(),
                    errorWidget: (_, _, _) => const _ImagePlaceholder(),
                  )
                : const _ImagePlaceholder(),

            // ── Bottom gradient ──
            Positioned.fill(
              child: DecoratedBox(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.transparent,
                      Colors.black.withValues(alpha: 0.55),
                    ],
                    stops: const [0.45, 1.0],
                  ),
                ),
              ),
            ),

            // ── Top-left badge: Booked takes priority over Bills incl. ──
            Positioned(
              top: 12,
              left: 12,
              child: Obx(() {
                if (apartment.isBooked) return const _StatusBadge.booked();
                if (apartment.isAllBillsIncluded) {
                  return const _StatusBadge.billsIncluded();
                }
                return const SizedBox.shrink();
              }),
            ),

            // ── Favorite button (top-right) ──
            Positioned(
              top: 10,
              right: 10,
              child: _FavoriteButton(
                apartment: apartment,
                onFavoriteToggle: onFavoriteToggle,
              ),
            ),

            // ── Price (bottom-left) ──
            Positioned(
              bottom: 12,
              left: 14,
              child: _PriceBadge(price: apartment.price),
            ),
          ],
        ),
      ),
    );
  }
}

// ── Image placeholder ─────────────────────────────────────────────────────────

class _ImagePlaceholder extends StatelessWidget {
  const _ImagePlaceholder();

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.bgSurface,
      child: const Center(
        child: Icon(Iconsax.building, color: AppColors.textDim, size: 44),
      ),
    );
  }
}

// ── Status badge (Booked / Bills included) ────────────────────────────────────

class _StatusBadge extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color bgColor;
  final Color textColor;
  final Color? borderColor;

  const _StatusBadge.booked()
      : icon = Iconsax.calendar_tick,
        label = 'Booked',
        bgColor = AppColors.primary,
        textColor = Colors.black,
        borderColor = null;

  const _StatusBadge.billsIncluded()
      : icon = Iconsax.electricity,
        label = 'Bills incl.',
        bgColor = const Color(0xCC000000),
        textColor = AppColors.primary,
        borderColor = AppColors.primary;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 4),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(20),
        border: borderColor != null
            ? Border.all(color: borderColor!.withValues(alpha: 0.55))
            : null,
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: textColor, size: 11),
          const SizedBox(width: 4),
          Text(
            label,
            style: TextStyle(
              color: textColor,
              fontSize: 10,
              fontWeight: FontWeight.w700,
              letterSpacing: 0.3,
            ),
          ),
        ],
      ),
    );
  }
}

// ── Favorite button ───────────────────────────────────────────────────────────

class _FavoriteButton extends StatelessWidget {
  final ApartmentModel apartment;
  final VoidCallback onFavoriteToggle;

  const _FavoriteButton({
    required this.apartment,
    required this.onFavoriteToggle,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onFavoriteToggle,
      child: Obx(() {
        final isFav = apartment.isFavorite.value;
        return AnimatedContainer(
          duration: const Duration(milliseconds: 220),
          width: 36,
          height: 36,
          decoration: BoxDecoration(
            color: isFav
                ? AppColors.primary.withValues(alpha: 0.18)
                : Colors.black.withValues(alpha: 0.50),
            shape: BoxShape.circle,
            border: Border.all(
              color: isFav
                  ? AppColors.primary.withValues(alpha: 0.60)
                  : Colors.white.withValues(alpha: 0.15),
            ),
          ),
          child: Icon(
            isFav ? Icons.favorite_rounded : Icons.favorite_border_rounded,
            color: isFav ? AppColors.primary : Colors.white,
            size: 17,
          ),
        );
      }),
    );
  }
}

// ── Price badge ───────────────────────────────────────────────────────────────

class _PriceBadge extends StatelessWidget {
  final int price;
  const _PriceBadge({required this.price});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: Colors.black.withValues(alpha: 0.65),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.primary.withValues(alpha: 0.40)),
      ),
      child: RichText(
        text: TextSpan(
          children: [
            TextSpan(
              text: '€$price',
              style: const TextStyle(
                color: AppColors.primary,
                fontSize: 16,
                fontWeight: FontWeight.w800,
                letterSpacing: -0.5,
              ),
            ),
            const TextSpan(
              text: '/mo',
              style: TextStyle(
                color: AppColors.textMuted,
                fontSize: 11,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ── Info section ──────────────────────────────────────────────────────────────

class _InfoSection extends StatelessWidget {
  final ApartmentModel apartment;
  final bool isDark;

  const _InfoSection({required this.apartment, required this.isDark});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(14, 12, 14, 14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ── Title ──
          Text(
            apartment.title,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              color: isDark ? AppColors.textPrimary : AppColors.textBlack,
              fontSize: 15,
              fontWeight: FontWeight.w700,
              letterSpacing: -0.3,
            ),
          ),

          const SizedBox(height: 5),

          // ── Address ──
          Row(
            children: [
              const Icon(
                Iconsax.location,
                color: AppColors.textMuted,
                size: 12,
              ),
              const SizedBox(width: 4),
              Expanded(
                child: Text(
                  apartment.address,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: AppColors.textMuted,
                    fontSize: 12,
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 10),

          // ── Stats row ──
          Row(
            children: [
              _StatChip(
                icon: Iconsax.house,
                label: '${apartment.bedCount} bd',
              ),
              const SizedBox(width: 8),
              _StatChip(
                icon: Iconsax.maximize_2,
                label: '${apartment.sqm} m²',
              ),
              if (apartment.floor != null) ...[
                const SizedBox(width: 8),
                _StatChip(
                  icon: Iconsax.building,
                  label: 'Fl. ${apartment.floor}',
                ),
              ],
            ],
          ),

          // ── Amenity chips ──
          if (apartment.activeAmenities.isNotEmpty) ...[
            const SizedBox(height: 10),
            _AmenityRow(amenities: apartment.activeAmenities),
          ],
        ],
      ),
    );
  }
}

// ── Stat chip ─────────────────────────────────────────────────────────────────

class _StatChip extends StatelessWidget {
  final IconData icon;
  final String label;

  const _StatChip({required this.icon, required this.label});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: AppColors.bgSurface,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: AppColors.divider),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: AppColors.primary, size: 11),
          const SizedBox(width: 4),
          Text(
            label,
            style: const TextStyle(
              color: AppColors.textMuted,
              fontSize: 11,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}

// ── Amenity chips (max 3, overflow badge) ─────────────────────────────────────

class _AmenityRow extends StatelessWidget {
  final List<String> amenities;
  const _AmenityRow({required this.amenities});

  static const _max = 3;

  @override
  Widget build(BuildContext context) {
    final visible = amenities.take(_max).toList();
    final overflow = amenities.length - _max;

    return Wrap(
      spacing: 6,
      runSpacing: 4,
      children: [
        ...visible.map(
          (a) => Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
            decoration: BoxDecoration(
              color: AppColors.primaryBg,
              borderRadius: BorderRadius.circular(6),
              border: Border.all(
                color: AppColors.primary.withValues(alpha: 0.22),
              ),
            ),
            child: Text(
              a,
              style: const TextStyle(
                color: AppColors.primary,
                fontSize: 10,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ),
        if (overflow > 0)
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
            decoration: BoxDecoration(
              color: AppColors.bgSurface,
              borderRadius: BorderRadius.circular(6),
              border: Border.all(color: AppColors.divider),
            ),
            child: Text(
              '+$overflow more',
              style: const TextStyle(
                color: AppColors.textMuted,
                fontSize: 10,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
      ],
    );
  }
}

/*
════════════════════════════════════════════════════════════════
  USAGE EXAMPLE
════════════════════════════════════════════════════════════════

  final ApartmentController c = Get.find();

  ListView.builder(
    padding: const EdgeInsets.symmetric(horizontal: 16),
    itemCount: c.filteredApartments.length,
    itemBuilder: (context, i) {
      final apartment = c.filteredApartments[i];
      return Padding(
        padding: const EdgeInsets.only(bottom: 16),
        child: ApartmentCard(
          apartment: apartment,
          onTap: () => Get.to(() => ShowApartmentDetailsView(apartment: apartment)),
          onFavoriteToggle: () => c.toggleFavorite(apartment),
        ),
      );
    },
  );

════════════════════════════════════════════════════════════════
*/
