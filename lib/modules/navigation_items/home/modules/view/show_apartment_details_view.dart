import 'package:apartment_rentals/core/constant/app_colors.dart';
import 'package:apartment_rentals/core/controllers/user_controller.dart';
import 'package:apartment_rentals/core/functions/helper_functions.dart';
import 'package:apartment_rentals/models/static/apartment_model.dart';
import 'package:apartment_rentals/modules/navigation_items/home/controller/apartment_controller.dart';
import 'package:apartment_rentals/core/widgets/paywall_bottom_sheet.dart';
import 'package:apartment_rentals/modules/navigation_items/home/widget/pre_booking_validation.dart';
import 'package:apartment_rentals/modules/navigation_items/profile/modules/tenant_card_edit/controller/tenant_card_controller.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:like_button/like_button.dart';
import 'package:shimmer/shimmer.dart';

class ShowApartmentDetailsView extends StatelessWidget {
  final ApartmentModel apartmentModel;
  final UserController userController;
  const ShowApartmentDetailsView({
    super.key,
    required this.apartmentModel,
    required this.userController,
  });

  // ── Full screen image viewer ────────────────────────────────────────────────
  void _showFullImage(BuildContext context, int initialIndex) {
    showDialog(
      context: context,
      barrierColor: Colors.black.withValues(alpha: 0.95),
      builder: (_) => _FullScreenGallery(
        urls: apartmentModel.imageUrls,
        initialIndex: initialIndex,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final bool isDarkMode = HelperFunctions.isDarkMode(context);
    bool isLocked = !userController.isPremium;
    ApartmentController apartmentController = Get.find<ApartmentController>();
    Get.put(TenantCardController());

    return Scaffold(
      backgroundColor: isDarkMode ? AppColors.bgDark : AppColors.bgLight,
      body: CustomScrollView(
        slivers: [
          // ── Hero image ─────────────────────────────────────────────────────
          SliverAppBar(
            expandedHeight: 360,
            pinned: true,
            stretch: true,
            backgroundColor: Colors.black,
            automaticallyImplyLeading: false,
            titleSpacing: 0,
            title: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _CircleButton(
                    icon: Icons.arrow_back_ios_new_rounded,
                    onTap: () => Navigator.pop(context),
                  ),
                  Obx(
                    () => Container(
                      width: 42,
                      height: 42,
                      decoration: BoxDecoration(
                        color: Colors.black.withValues(alpha: 0.65),
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: Colors.white.withValues(alpha: 0.12),
                        ),
                      ),
                      child: Center(
                        child: LikeButton(
                          isLiked: apartmentModel.isFavorite.value,
                          size: 22,
                          circleColor: CircleColor(
                            start: AppColors.primary.withValues(alpha: 0.5),
                            end: AppColors.primary,
                          ),
                          bubblesColor: BubblesColor(
                            dotPrimaryColor: AppColors.primary,
                            dotSecondaryColor: Colors.orangeAccent,
                          ),
                          likeBuilder: (isLiked) => Icon(
                            isLiked
                                ? Icons.favorite_rounded
                                : Icons.favorite_border_rounded,
                            color: isLiked ? AppColors.primary : Colors.white,
                            size: 20,
                          ),
                          onTap: (isLiked) async {
                            apartmentController.toggleFavorite(apartmentModel);
                            return !isLiked;
                          },
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            flexibleSpace: FlexibleSpaceBar(
              stretchModes: const [StretchMode.zoomBackground],
              background: Stack(
                fit: StackFit.expand,
                children: [
                  // ── Main hero image with shimmer loader ──────────────────
                  GestureDetector(
                    onTap: apartmentModel.imageUrls.isNotEmpty
                        ? () => _showFullImage(context, 0)
                        : null,
                    child: apartmentModel.imageUrls.isNotEmpty
                        ? CachedNetworkImage(
                            imageUrl:
                                '${apartmentModel.imageUrls.first}?width=800&quality=80',
                            fit: BoxFit.cover,
                            // ── Shimmer placeholder ─────────────────────────
                            placeholder: (_, __) => Shimmer.fromColors(
                              baseColor: const Color(0xFF1A1A1A),
                              highlightColor: const Color(0xFF2E2E2E),
                              child: Container(color: Colors.white),
                            ),
                            // ── Fade in animation ───────────────────────────
                            imageBuilder: (ctx, imageProvider) => Container(
                              decoration: BoxDecoration(
                                image: DecorationImage(
                                  image: imageProvider,
                                  fit: BoxFit.cover,
                                ),
                              ),
                            )
                                .animate()
                                .fadeIn(duration: 500.ms)
                                .scale(
                                  begin: const Offset(1.04, 1.04),
                                  end: const Offset(1.0, 1.0),
                                  duration: 600.ms,
                                  curve: Curves.easeOut,
                                ),
                            errorWidget: (_, __, ___) => Container(
                              color: AppColors.bgCard,
                              child: const Icon(
                                Icons.image_outlined,
                                color: AppColors.textDim,
                                size: 48,
                              ),
                            ),
                          )
                        : Container(
                            color: AppColors.bgCard,
                            child: const Icon(
                              Icons.image_outlined,
                              color: AppColors.textDim,
                              size: 48,
                            ),
                          ),
                  ),

                  // ── Bottom gradient ─────────────────────────────────────
                  const DecoratedBox(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        stops: [0.45, 1.0],
                        colors: [Colors.transparent, Colors.black],
                      ),
                    ),
                  ),

                  // ── Top gradient ────────────────────────────────────────
                  DecoratedBox(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        stops: const [0.0, 0.3],
                        colors: [
                          Colors.black.withValues(alpha: 0.55),
                          Colors.transparent,
                        ],
                      ),
                    ),
                  ),

                  // ── Image count badge ───────────────────────────────────
                  if (apartmentModel.imageUrls.length > 1 && !isLocked)
                    Positioned(
                      bottom: 16,
                      right: 20,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 5,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.black.withValues(alpha: 0.65),
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(
                            color: Colors.white.withValues(alpha: 0.15),
                          ),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(
                              Icons.photo_library_outlined,
                              color: Colors.white,
                              size: 13,
                            ),
                            const SizedBox(width: 5),
                            Text(
                              '${apartmentModel.imageUrls.length}',
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ).animate().fadeIn(delay: 400.ms, duration: 300.ms),
                    ),

                  // ── Lock overlay ────────────────────────────────────────
                  if (isLocked)
                    Container(
                      color: Colors.black.withValues(alpha: 0.65),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const _LockBadge(),
                          const SizedBox(height: 12),
                          Text(
                            'premium_listing'.tr,
                            style: const TextStyle(
                              color: AppColors.textPrimary,
                              fontWeight: FontWeight.w700,
                              fontSize: 16,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'subscribe_to_unlock'.tr,
                            style: const TextStyle(
                              color: AppColors.textMuted,
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                    ),
                ],
              ),
            ),
          ),

          SliverToBoxAdapter(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // ── Price + title + location ──────────────────────────────
                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 22, 20, 0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(
                            HelperFunctions.formatPrice(apartmentModel.price),
                            style: TextStyle(
                              color: isDarkMode
                                  ? AppColors.primary
                                  : AppColors.textBlack,
                              fontSize: 34,
                              fontWeight: FontWeight.w800,
                              letterSpacing: -0.5,
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(bottom: 6, left: 4),
                            child: Text(
                              'per_month_short'.tr,
                              style: const TextStyle(
                                color: AppColors.textMuted,
                                fontSize: 14,
                              ),
                            ),
                          ),
                          const Spacer(),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 10,
                              vertical: 5,
                            ),
                            decoration: BoxDecoration(
                              color: AppColors.primaryBg,
                              borderRadius: BorderRadius.circular(20),
                              border: Border.all(
                                color: AppColors.primary.withValues(alpha: 0.35),
                              ),
                            ),
                            child: Row(
                              children: [
                                const Icon(
                                  Icons.verified_rounded,
                                  color: AppColors.primary,
                                  size: 13,
                                ),
                                const SizedBox(width: 4),
                                Text(
                                  'verified_label'.tr,
                                  style: const TextStyle(
                                    color: AppColors.primary,
                                    fontSize: 11,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ).animate().fadeIn(delay: 100.ms, duration: 400.ms),

                      const SizedBox(height: 8),

                      Text(
                        apartmentModel.title,
                        style: TextStyle(
                          color: isDarkMode
                              ? AppColors.textPrimary
                              : AppColors.textBlack,
                          fontSize: 22,
                          fontWeight: FontWeight.w700,
                          height: 1.2,
                        ),
                      ).animate().fadeIn(delay: 150.ms, duration: 400.ms),

                      const SizedBox(height: 8),

                      Row(
                        children: [
                          const Icon(
                            Icons.location_on_rounded,
                            color: AppColors.textMuted,
                            size: 14,
                          ),
                          const SizedBox(width: 4),
                          Expanded(
                            child: Text(
                              apartmentModel.address,
                              style: const TextStyle(
                                color: AppColors.textMuted,
                                fontSize: 13,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ).animate().fadeIn(delay: 200.ms, duration: 400.ms),
                    ],
                  ),
                ),

                const SizedBox(height: 24),

                // ── Stat chips ────────────────────────────────────────────
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Row(
                    children: [
                      _StatChip(
                        icon: Icons.bed,
                        label: apartmentModel.bedCount > 1
                            ? '${apartmentModel.bedCount} ${'rooms_label'.tr}'
                            : '${apartmentModel.bedCount} ${'room_label'.tr}',
                      ),
                      const SizedBox(width: 10),
                      _StatChip(
                        icon: Iconsax.maximize_3,
                        label: '${apartmentModel.sqm} ${'sqm_label'.tr}',
                      ),
                      const SizedBox(width: 10),
                      _StatChip(
                        icon: Iconsax.building,
                        label: '${apartmentModel.floor} ${'floor_label'.tr}',
                      ),
                    ],
                  ).animate().fadeIn(delay: 250.ms, duration: 400.ms),
                ),

                const SizedBox(height: 28),

                // ── Amenities ─────────────────────────────────────────────
                _SectionHeader(title: 'amenities_section'.tr),
                const SizedBox(height: 14),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: GridView.count(
                    crossAxisCount: 4,
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    crossAxisSpacing: 10,
                    mainAxisSpacing: 10,
                    children: [
                      _AmenityItem(icon: Iconsax.car, label: 'parking_label'.tr, color: apartmentModel.hasParking ? AppColors.primary : AppColors.dangerColor),
                      _AmenityItem(icon: Icons.local_laundry_service_rounded, label: 'laundry_label'.tr, color: apartmentModel.hasLaundry ? AppColors.primary : AppColors.dangerColor),
                      _AmenityItem(icon: Icons.elevator_rounded, label: 'elevator_label'.tr, color: apartmentModel.hasElevator ? AppColors.primary : AppColors.dangerColor),
                      _AmenityItem(icon: Icons.pets_rounded, label: 'pets_label'.tr, color: apartmentModel.hasPets ? AppColors.primary : AppColors.dangerColor),
                      _AmenityItem(icon: Iconsax.sun_1, label: 'balcony_label'.tr, color: apartmentModel.hasBalcony ? AppColors.primary : AppColors.dangerColor),
                    ],
                  ),
                ).animate().fadeIn(delay: 300.ms, duration: 400.ms),

                const SizedBox(height: 28),

                // ── Rental Terms ──────────────────────────────────────────
                _SectionHeader(title: 'rental_terms'.tr),
                const SizedBox(height: 14),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: _RentalTermsCard(
                    housingAssistance: apartmentModel.acceptsHousingAssistance,
                    cpasAccepted: apartmentModel.acceptsCpasOrOcmw,
                    billsIncluded: apartmentModel.isAllBillsIncluded,
                  ),
                ).animate().fadeIn(delay: 315.ms, duration: 400.ms),

                const SizedBox(height: 28),

                // ── Description ───────────────────────────────────────────
                _SectionHeader(title: 'description_section'.tr),
                const SizedBox(height: 12),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: _DescriptionBox(text: apartmentModel.localizedDescription),
                ).animate().fadeIn(delay: 350.ms, duration: 400.ms),

                const SizedBox(height: 28),

                // ── Gallery ───────────────────────────────────────────────
                if (apartmentModel.imageUrls.isNotEmpty) ...[
                  _SectionHeader(title: 'gallery_section'.tr),
                  const SizedBox(height: 14),
                  SizedBox(
                    height: 110,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      itemCount: apartmentModel.imageUrls.length,
                      itemBuilder: (_, i) => GestureDetector(
                        onTap: () => _showFullImage(context, i),
                        child: Container(
                          width: 140,
                          margin: const EdgeInsets.only(right: 10),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(14),
                            child: Stack(
                              fit: StackFit.expand,
                              children: [
                                // ── Shimmer ──────────────────────────────
                                Shimmer.fromColors(
                                  baseColor: const Color(0xFF1A1A1A),
                                  highlightColor: const Color(0xFF2E2E2E),
                                  child: Container(color: Colors.white),
                                ),
                                CachedNetworkImage(
                                  imageUrl:
                                      '${apartmentModel.imageUrls[i]}?width=300&quality=65',
                                  fit: BoxFit.cover,
                                  placeholder: (_, __) =>
                                      const SizedBox.shrink(),
                                  imageBuilder: (_, imageProvider) => Container(
                                    decoration: BoxDecoration(
                                      image: DecorationImage(
                                        image: imageProvider,
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                  )
                                      .animate()
                                      .fadeIn(duration: 400.ms),
                                  errorWidget: (_, __, ___) => Container(
                                    color: AppColors.bgCard,
                                    child: const Icon(
                                      Icons.image,
                                      color: AppColors.textMuted,
                                    ),
                                  ),
                                ),
                                // ── First image badge ─────────────────────
                                if (i == 0)
                                  Positioned(
                                    top: 6,
                                    left: 6,
                                    child: Container(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 6,
                                        vertical: 3,
                                      ),
                                      decoration: BoxDecoration(
                                        color: AppColors.primary,
                                        borderRadius: BorderRadius.circular(6),
                                      ),
                                      child: Text(
                                        'main_photo'.tr,
                                        style: const TextStyle(
                                          color: Colors.black,
                                          fontSize: 9,
                                          fontWeight: FontWeight.w700,
                                        ),
                                      ),
                                    ),
                                  ),
                              ],
                            ),
                          ),
                        )
                            .animate()
                            .fadeIn(
                              delay: Duration(milliseconds: 400 + (i * 60)),
                              duration: 350.ms,
                            )
                            .slideX(begin: 0.1, curve: Curves.easeOut),
                      ),
                    ),
                  ),
                  const SizedBox(height: 28),
                ],

                const SizedBox(height: 110),
              ],
            ),
          ),
        ],
      ),

      // ── Sticky bottom CTA ──────────────────────────────────────────────────
      bottomNavigationBar: Container(
        padding: EdgeInsets.fromLTRB(
          20,
          16,
          20,
          MediaQuery.of(context).padding.bottom + 16,
        ),
        decoration: BoxDecoration(
          color: isDarkMode ? const Color(0xff0f0f0f) : Colors.white,
          border: Border(
            top: BorderSide(
              color: isDarkMode ? AppColors.divider : AppColors.borderLight,
            ),
          ),
          boxShadow: isDarkMode
              ? null
              : [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.06),
                    blurRadius: 12,
                    offset: const Offset(0, -3),
                  ),
                ],
        ),
        child: isLocked
            ? _PrimaryButton(
                label: 'unlock_for_price'.tr,
                icon: Iconsax.lock,
                onTap: () => showPaywallBottomSheet(context),
              )
            : Obx(() {
                final isBooked = apartmentModel.isBooked;
                return _PrimaryButton(
                  label: isBooked ? 'already_booked'.tr : 'book_viewing'.tr,
                  icon: isBooked ? Iconsax.lock : Icons.calendar_month_rounded,
                  disabled: isBooked,
                  onTap: isBooked
                      ? null
                      : () => showBookingWithValidation(context, apartmentModel),
                );
              }),
      ),
    );
  }
}

// ── Full screen gallery dialog ─────────────────────────────────────────────────
class _FullScreenGallery extends StatefulWidget {
  final List<String> urls;
  final int initialIndex;
  const _FullScreenGallery({required this.urls, required this.initialIndex});

  @override
  State<_FullScreenGallery> createState() => _FullScreenGalleryState();
}

class _FullScreenGalleryState extends State<_FullScreenGallery> {
  late int _currentIndex;
  late PageController _pageCtrl;

  @override
  void initState() {
    super.initState();
    _currentIndex = widget.initialIndex;
    _pageCtrl = PageController(initialPage: widget.initialIndex);
  }

  @override
  void dispose() {
    _pageCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.black,
      insetPadding: EdgeInsets.zero,
      child: Stack(
        children: [
          PageView.builder(
            controller: _pageCtrl,
            itemCount: widget.urls.length,
            onPageChanged: (i) => setState(() => _currentIndex = i),
            itemBuilder: (_, i) => InteractiveViewer(
              child: CachedNetworkImage(
                imageUrl: widget.urls[i],
                fit: BoxFit.contain,
                placeholder: (_, __) => const Center(
                  child: CircularProgressIndicator(
                    color: AppColors.primary,
                    strokeWidth: 2,
                  ),
                ),
              ),
            ),
          ),

          // Close button
          Positioned(
            top: MediaQuery.of(context).padding.top + 12,
            right: 16,
            child: GestureDetector(
              onTap: () => Get.back(),
              child: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.black.withValues(alpha: 0.6),
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: Colors.white.withValues(alpha: 0.2),
                  ),
                ),
                child: const Icon(Icons.close_rounded, color: Colors.white, size: 20),
              ),
            ),
          ),

          // Page indicator
          if (widget.urls.length > 1)
            Positioned(
              bottom: MediaQuery.of(context).padding.bottom + 24,
              left: 0,
              right: 0,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(
                  widget.urls.length,
                  (i) => AnimatedContainer(
                    duration: const Duration(milliseconds: 250),
                    margin: const EdgeInsets.symmetric(horizontal: 3),
                    width: _currentIndex == i ? 20 : 6,
                    height: 6,
                    decoration: BoxDecoration(
                      color: _currentIndex == i
                          ? AppColors.primary
                          : Colors.white.withValues(alpha: 0.4),
                      borderRadius: BorderRadius.circular(3),
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}

// ── Circle button ──────────────────────────────────────────────────────────────
class _CircleButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;
  const _CircleButton({required this.icon, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 42,
        height: 42,
        decoration: BoxDecoration(
          color: Colors.black.withValues(alpha: 0.65),
          shape: BoxShape.circle,
          border: Border.all(color: Colors.white.withValues(alpha: 0.12)),
        ),
        child: Icon(icon, color: Colors.white, size: 18),
      ),
    );
  }
}

// ── Lock badge ─────────────────────────────────────────────────────────────────
class _LockBadge extends StatelessWidget {
  const _LockBadge();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.primaryBg,
        shape: BoxShape.circle,
        border: Border.all(color: AppColors.primary.withValues(alpha: 0.4), width: 1.5),
      ),
      child: const Icon(Iconsax.lock, color: AppColors.primary, size: 28),
    );
  }
}

// ── Stat chip ──────────────────────────────────────────────────────────────────
class _StatChip extends StatelessWidget {
  final IconData icon;
  final String label;
  const _StatChip({required this.icon, required this.label});

  @override
  Widget build(BuildContext context) {
    final isDarkMode = HelperFunctions.isDarkMode(context);
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 14),
        decoration: BoxDecoration(
          color: isDarkMode ? AppColors.bgCard : AppColors.bgCardLight,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: isDarkMode ? AppColors.divider : AppColors.borderLight),
          boxShadow: isDarkMode ? null : [BoxShadow(color: Colors.black.withValues(alpha: 0.05), blurRadius: 8, offset: const Offset(0, 2))],
        ),
        child: Column(
          children: [
            Icon(icon, color: AppColors.primary, size: 22),
            const SizedBox(height: 6),
            Text(label, style: TextStyle(color: isDarkMode ? AppColors.textMuted : const Color(0xff666666), fontSize: 12, fontWeight: FontWeight.w500), textAlign: TextAlign.center, maxLines: 1, overflow: TextOverflow.ellipsis),
          ],
        ),
      ),
    );
  }
}

// ── Section header ─────────────────────────────────────────────────────────────
class _SectionHeader extends StatelessWidget {
  final String title;
  const _SectionHeader({required this.title});

  @override
  Widget build(BuildContext context) {
    final isDarkMode = HelperFunctions.isDarkMode(context);
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Text(title, style: TextStyle(color: isDarkMode ? AppColors.textPrimary : AppColors.textBlack, fontSize: 17, fontWeight: FontWeight.w700, letterSpacing: -0.2)),
    );
  }
}

// ── Amenity item ───────────────────────────────────────────────────────────────
class _AmenityItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;
  const _AmenityItem({required this.icon, required this.label, required this.color});

  @override
  Widget build(BuildContext context) {
    final isDarkMode = HelperFunctions.isDarkMode(context);
    return Container(
      decoration: BoxDecoration(
        color: isDarkMode ? AppColors.bgCard : AppColors.bgCardLight,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: isDarkMode ? AppColors.divider : AppColors.borderLight),
        boxShadow: isDarkMode ? null : [BoxShadow(color: Colors.black.withValues(alpha: 0.04), blurRadius: 6, offset: const Offset(0, 2))],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, color: color, size: 22),
          const SizedBox(height: 5),
          Text(label, style: TextStyle(color: isDarkMode ? AppColors.textMuted : const Color(0xff666666), fontSize: 10, fontWeight: FontWeight.w500), textAlign: TextAlign.center, maxLines: 1, overflow: TextOverflow.ellipsis),
        ],
      ),
    );
  }
}

// ── Description box ────────────────────────────────────────────────────────────
class _DescriptionBox extends StatefulWidget {
  final String text;
  const _DescriptionBox({required this.text});

  @override
  State<_DescriptionBox> createState() => _DescriptionBoxState();
}

class _DescriptionBoxState extends State<_DescriptionBox> {
  bool _expanded = false;

  @override
  Widget build(BuildContext context) {
    final isDarkMode = HelperFunctions.isDarkMode(context);
    return GestureDetector(
      onTap: () => setState(() => _expanded = !_expanded),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AnimatedCrossFade(
            duration: const Duration(milliseconds: 250),
            crossFadeState: _expanded ? CrossFadeState.showSecond : CrossFadeState.showFirst,
            firstChild: Text(widget.text, maxLines: 3, overflow: TextOverflow.ellipsis, style: TextStyle(color: isDarkMode ? AppColors.textMuted : const Color(0xff555555), fontSize: 13, height: 1.65)),
            secondChild: Text(widget.text, style: TextStyle(color: isDarkMode ? AppColors.textMuted : const Color(0xff555555), fontSize: 13, height: 1.65)),
          ),
          const SizedBox(height: 6),
          Text(
            _expanded ? 'show_less'.tr : 'read_more'.tr,
            style: const TextStyle(color: AppColors.primary, fontSize: 13, fontWeight: FontWeight.w600),
          ),
        ],
      ),
    );
  }
}

// ── Primary button ─────────────────────────────────────────────────────────────
class _PrimaryButton extends StatelessWidget {
  final String label;
  final IconData? icon;
  final VoidCallback? onTap;
  final bool disabled;

  const _PrimaryButton({required this.label, required this.onTap, this.icon, this.disabled = false});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: disabled ? null : onTap,
      child: Container(
        height: 56,
        decoration: BoxDecoration(
          color: disabled ? AppColors.bgCard : AppColors.primary,
          borderRadius: BorderRadius.circular(16),
          border: disabled ? Border.all(color: AppColors.divider) : null,
          boxShadow: disabled ? null : [BoxShadow(color: AppColors.primary.withValues(alpha: 0.35), blurRadius: 20, spreadRadius: 1, offset: const Offset(0, 4))],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (icon != null) ...[
              Icon(icon, color: disabled ? AppColors.textMuted : Colors.black, size: 18),
              const SizedBox(width: 8),
            ],
            Text(label, style: TextStyle(color: disabled ? AppColors.textMuted : Colors.black, fontWeight: FontWeight.w700, fontSize: 15)),
          ],
        ),
      ),
    );
  }
}

// ── Rental terms card ──────────────────────────────────────────────────────────
class _RentalTermsCard extends StatelessWidget {
  final bool housingAssistance;
  final bool cpasAccepted;
  final bool billsIncluded;

  const _RentalTermsCard({required this.housingAssistance, required this.cpasAccepted, required this.billsIncluded});

  @override
  Widget build(BuildContext context) {
    final isDarkMode = HelperFunctions.isDarkMode(context);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 4),
      decoration: BoxDecoration(
        color: isDarkMode ? AppColors.bgCard : AppColors.bgCardLight,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: isDarkMode ? AppColors.divider : AppColors.borderLight),
        boxShadow: isDarkMode ? null : [BoxShadow(color: Colors.black.withValues(alpha: 0.05), blurRadius: 12, offset: const Offset(0, 3))],
      ),
      child: Column(
        children: [
          _TermRow(icon: Icons.home_work_rounded, label: 'housing_assistance'.tr, sublabel: 'housing_assistance_sublabel'.tr, isActive: housingAssistance, badgeText: housingAssistance ? 'accepted_label'.tr : 'not_accepted_label'.tr),
          Divider(color: isDarkMode ? AppColors.divider : AppColors.borderLight, height: 1),
          _TermRow(icon: Icons.volunteer_activism_rounded, label: 'cpas_guarantee'.tr, sublabel: 'cpas_sublabel'.tr, isActive: cpasAccepted, badgeText: cpasAccepted ? 'accepted_label'.tr : 'not_accepted_label'.tr),
          Divider(color: isDarkMode ? AppColors.divider : AppColors.borderLight, height: 1),
          _TermRow(icon: Icons.bolt_rounded, label: billsIncluded ? 'all_bills_included'.tr : 'bills_extra'.tr, sublabel: billsIncluded ? 'utilities_list'.tr : 'utilities_separate'.tr, isActive: billsIncluded, badgeText: billsIncluded ? 'charges_incl'.tr : 'charges_excl'.tr),
        ],
      ),
    );
  }
}

class _TermRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final String sublabel;
  final bool isActive;
  final String badgeText;

  const _TermRow({required this.icon, required this.label, required this.sublabel, required this.isActive, required this.badgeText});

  @override
  Widget build(BuildContext context) {
    final isDarkMode = HelperFunctions.isDarkMode(context);
    final Color accent = isActive ? AppColors.primary : AppColors.dangerColor;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 14),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: isActive ? AppColors.primaryBg : AppColors.dangerColor.withValues(alpha: 0.08),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: accent, size: 20),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(label, style: TextStyle(color: isDarkMode ? AppColors.textPrimary : AppColors.textBlack, fontWeight: FontWeight.w600, fontSize: 13.5)),
                const SizedBox(height: 2),
                Text(sublabel, style: const TextStyle(color: AppColors.textMuted, fontSize: 11)),
              ],
            ),
          ),
          const SizedBox(width: 10),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            decoration: BoxDecoration(
              color: isActive ? AppColors.primaryBg : AppColors.dangerColor.withValues(alpha: 0.08),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: isActive ? AppColors.primary.withValues(alpha: 0.4) : AppColors.dangerColor.withValues(alpha: 0.35)),
            ),
            child: Text(badgeText, style: TextStyle(color: accent, fontSize: 11, fontWeight: FontWeight.w600)),
          ),
        ],
      ),
    );
  }
}