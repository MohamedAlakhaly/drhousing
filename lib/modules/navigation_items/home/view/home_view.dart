import 'package:apartment_rentals/core/constant/app_colors.dart';
import 'package:apartment_rentals/core/constant/responsive.dart';
import 'package:apartment_rentals/core/controllers/user_controller.dart';
import 'package:apartment_rentals/core/functions/helper_functions.dart';
import 'package:apartment_rentals/global/custom_loading_circular.dart';
import 'package:apartment_rentals/core/services/payment_service.dart';
import 'package:apartment_rentals/models/static/apartment_model.dart';
import 'package:apartment_rentals/modules/navigation_items/home/controller/apartment_controller.dart';
import 'package:apartment_rentals/modules/navigation_items/home/modules/view/show_apartment_details_view.dart';
import 'package:apartment_rentals/modules/navigation_items/home/widget/filter_bottom_sheet.dart';
import 'package:apartment_rentals/modules/navigation_items/home/widget/search_bar_widget.dart';
import 'package:blur/blur.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:like_button/like_button.dart';

class HomeView extends StatelessWidget {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    final ApartmentController apartmentController = Get.put(
      ApartmentController(),
    );
    final UserController userController = Get.find<UserController>();
    final bool isDarkMode = HelperFunctions.isDarkMode(context);

    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            // Ambient lime glow — top left
            Positioned(
              top: -80,
              left: -90,
              child: Container(
                width: 300,
                height: 300,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: RadialGradient(
                    colors: [
                      AppColors.primary.withValues(alpha: 0.20),
                      AppColors.primary.withValues(alpha: 0.10),
                      Colors.transparent,
                    ],
                  ),
                ),
              ),
            ),

            Obx(() {
              if (apartmentController.isLoading.value) {
                return Center(child: CustomLoadingCircular());
              }

              if (apartmentController.hasError) {
                return ErrorWidget(apartmentController.errorMessage.value);
              }

              if (apartmentController.isEmpty) {
                return Center(child: Text('no_apartments_found'.tr));
              }

              final filtered = apartmentController.filteredApartments;

              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildHeader(isDarkMode, userController)
                      .animate()
                      .fadeIn(duration: 500.ms)
                      .slideY(begin: -0.2, curve: Curves.easeOut),
                  _buildSearchRow(context, isDarkMode, apartmentController)
                      .animate()
                      .fadeIn(delay: 150.ms, duration: 400.ms)
                      .slideX(begin: -0.1, curve: Curves.easeOut),
                  _buildSectionLabel().animate().fadeIn(
                    delay: 250.ms,
                    duration: 400.ms,
                  ),
                  if (filtered.isEmpty)
                    Expanded(
                      child: _buildFilterEmptyState(
                        context,
                        apartmentController,
                      ),
                    )
                  else
                    // بدل ListView.builder
                    Expanded(
                      child: Responsive.isMobile(context)
                          ? ListView.builder(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 16,
                                vertical: 8,
                              ),
                              itemCount: filtered.length,
                              itemBuilder: (context, index) => _apartmentCard(
                                context: context,
                                userController: userController,
                                apartmentModel: filtered[index],
                                apartmentController: apartmentController,
                                index: index,
                                isDarkMode: isDarkMode,
                              ),
                            )
                          : GridView.builder(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 16,
                                vertical: 8,
                              ),
                              gridDelegate:
                                  SliverGridDelegateWithFixedCrossAxisCount(
                                    crossAxisCount:
                                        Responsive.isDesktop(context) ? 4 : 2,
                                    crossAxisSpacing: 16,
                                    mainAxisSpacing: 16,
                                    mainAxisExtent:
                                        380,
                                  ),
                              itemCount: filtered.length,
                              itemBuilder: (context, index) => _apartmentCard(
                                context: context,
                                userController: userController,
                                apartmentModel: filtered[index],
                                apartmentController: apartmentController,
                                index: index,
                                isDarkMode: isDarkMode,
                              ),
                            ),
                    ),
                ],
              );
            }),
          ],
        ),
      ),
    );
  }

  // ─── Header ─────────────────────────────────────────────────────────────────

  Widget _buildHeader(bool isDarkMode, UserController userController) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'welcome_back_home'.tr,
                  style: const TextStyle(
                    color: AppColors.textMuted,
                    fontSize: 12,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  userController.displayName,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: isDarkMode
                        ? AppColors.textPrimary
                        : AppColors.textBlack,
                    fontSize: 22,
                    fontWeight: FontWeight.w700,
                    letterSpacing: -0.4,
                  ),
                ),
              ],
            ),
          ),
          // Container(
          //   width: 42,
          //   height: 42,
          //   decoration: BoxDecoration(
          //     color: isDarkMode ? AppColors.bgCard : AppColors.bgGrey,
          //     borderRadius: BorderRadius.circular(12),
          //   ),
          //   child: Icon(
          //     Iconsax.notification,
          //     color: isDarkMode ? AppColors.textMuted : AppColors.textBlack,
          //     size: 20,
          //   ),
          // ),
        ],
      ),
    );
  }

  // ─── Search row with live filter bar + filter button ────────────────────────

  Widget _buildSearchRow(
    BuildContext context,
    bool isDarkMode,
    ApartmentController apartmentController,
  ) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 4),
      child: Row(
        children: [
          const Expanded(child: SearchBarWidget()),
          const SizedBox(width: 10),
          Obx(() {
            final active = apartmentController.isFiltered;
            return GestureDetector(
              onTap: () => showFilterBottomSheet(context),
              child: Stack(
                clipBehavior: Clip.none,
                children: [
                  AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    width: 52,
                    height: 52,
                    decoration: BoxDecoration(
                      color: active
                          ? AppColors.primaryBg
                          : (isDarkMode ? AppColors.bgCard : AppColors.bgGrey),
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        color: active
                            ? AppColors.primary
                            : (isDarkMode
                                  ? AppColors.primary.withValues(alpha: 0.35)
                                  : Colors.grey.shade400),
                      ),
                    ),
                    child: Icon(
                      Icons.tune_rounded,
                      color: active
                          ? AppColors.primary
                          : (isDarkMode
                                ? AppColors.textMuted
                                : AppColors.textBlack),
                      size: 20,
                    ),
                  ),
                  if (active)
                    Positioned(
                      top: -3,
                      right: -3,
                      child: Container(
                        width: 10,
                        height: 10,
                        decoration: const BoxDecoration(
                          color: AppColors.primary,
                          shape: BoxShape.circle,
                        ),
                      ),
                    ),
                ],
              ),
            );
          }),
        ],
      ),
    );
  }

  // ─── Section label ───────────────────────────────────────────────────────────

  Widget _buildSectionLabel() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 4),
      child: Text(
        'featured_listings'.tr,
        style: const TextStyle(
          color: AppColors.textMuted,
          fontSize: 11,
          fontWeight: FontWeight.w600,
          letterSpacing: 0.9,
        ),
      ),
    );
  }

  // ─── Filter empty state ──────────────────────────────────────────────────────

  Widget _buildFilterEmptyState(
    BuildContext context,
    ApartmentController controller,
  ) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(
            Icons.search_off_rounded,
            color: AppColors.textMuted,
            size: 64,
          ),
          const SizedBox(height: 16),
          Text(
            'no_apartments_match_filters'.tr,
            style: const TextStyle(
              color: AppColors.textMuted,
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 20),
          GestureDetector(
            onTap: controller.resetFilters,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              decoration: BoxDecoration(
                color: AppColors.primaryBg,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: AppColors.primary),
              ),
              child: Text(
                'reset_filters'.tr,
                style: const TextStyle(
                  color: AppColors.primary,
                  fontWeight: FontWeight.w600,
                  fontSize: 14,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ─── Property card ────────────────────────────────────────────────────────────

  Widget _apartmentCard({
    required BuildContext context,
    required ApartmentModel apartmentModel,
    required UserController userController,
    required ApartmentController apartmentController,
    required int index,
    required bool isDarkMode,
  }) {
    final isLocked = !userController.isPremium;
    return GestureDetector(
      onTap: () => PaymentService.requirePremium(
        context,
        () => Get.to(
          () => ShowApartmentDetailsView(
            apartmentModel: apartmentModel,
            userController: userController,
          ),
        ),
      ),
      child:
          Container(
                margin: const EdgeInsets.only(bottom: 16),
                decoration: BoxDecoration(
                  color: isDarkMode ? AppColors.bgCard : AppColors.bgGrey,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Image section
                    Stack(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(8),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(16),
                            child: Blur(
                              blur: isLocked ? 15 : 0,
                              colorOpacity: 0,
                              child: apartmentModel.imageUrl != null
                                  ? CachedNetworkImage(
                                      // Transform API — يرجع صورة مضغوطة من Supabase
                                      imageUrl:
                                          '${apartmentModel.imageUrl}'
                                          '?width=600&height=200&resize=cover&quality=70',
                                      height: 200,
                                      width: double.infinity,
                                      fit: BoxFit.cover,

                                      placeholder: (ctx, url) => Container(
                                        height: 200,
                                        color: isDarkMode
                                            ? AppColors.bgSurface
                                            : AppColors.bgLight,
                                        child: const Center(
                                          child: CircularProgressIndicator(
                                            color: AppColors.primary,
                                            strokeWidth: 2,
                                          ),
                                        ),
                                      ),
                                      errorWidget: (ctx, url, err) => Container(
                                        height: 200,
                                        color: isDarkMode
                                            ? AppColors.bgSurface
                                            : AppColors.bgLight,
                                        child: const Icon(
                                          Icons.image_outlined,
                                          color: AppColors.textDim,
                                          size: 50,
                                        ),
                                      ),
                                    )
                                  : Container(
                                      height: 200,
                                      color: isDarkMode
                                          ? AppColors.bgSurface
                                          : AppColors.bgLight,
                                      child: const Icon(
                                        Icons.image_outlined,
                                        color: AppColors.textDim,
                                        size: 50,
                                      ),
                                    ),
                            ),
                          ),
                        ), // Lock / status badge

                        Positioned(
                          top: 20,
                          left: 20,
                          child:
                              Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 12,
                                      vertical: 6,
                                    ),
                                    decoration: BoxDecoration(
                                      color: AppColors.primary,
                                      borderRadius: BorderRadius.circular(30),
                                    ),
                                    child: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Icon(
                                          isLocked
                                              ? Iconsax.lock
                                              : Icons.lock_open_rounded,
                                          size: 13,
                                          color: Colors.black,
                                        ),
                                        const SizedBox(width: 5),
                                        Text(
                                          isLocked
                                              ? 'locked_label'.tr
                                              : 'unlocked_label'.tr,
                                          style: const TextStyle(
                                            color: Colors.black,
                                            fontSize: 12,
                                            fontWeight: FontWeight.w700,
                                          ),
                                        ),
                                      ],
                                    ),
                                  )
                                  .animate()
                                  .fadeIn(
                                    delay: Duration(
                                      milliseconds: 700 + (index * 150),
                                    ),
                                  )
                                  .slideX(begin: -0.3)
                                  .then()
                                  .shimmer(
                                    duration: 2000.ms,
                                    color: Colors.white.withValues(alpha: 0.25),
                                  ),
                        ),

                        Positioned(
                          top: 12,
                          right: 12,
                          child: Obx(
                            () => Container(
                              padding: const EdgeInsets.all(6),
                              decoration: BoxDecoration(
                                color: Colors.black.withValues(alpha: 0.5),
                                shape: BoxShape.circle,
                              ),
                              child: LikeButton(
                                isLiked: apartmentModel.isFavorite.value,
                                size: 22,
                                circleColor: CircleColor(
                                  start: AppColors.primary.withValues(
                                    alpha: 0.5,
                                  ),
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
                                  color: isLiked
                                      ? AppColors.primary
                                      : Colors.white,
                                  size: 20,
                                ),
                                onTap: (isLiked) async {
                                  if (isLocked) {
                                    return Future.value();
                                  }
                                  apartmentController.toggleFavorite(
                                    apartmentModel,
                                  );
                                  HapticFeedback.heavyImpact();
                                  return !isLiked;
                                },
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),

                    // Details
                    Padding(
                      padding: const EdgeInsets.fromLTRB(16, 4, 16, 16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [
                                  const Icon(
                                    Icons.location_on_outlined,
                                    color: AppColors.textMuted,
                                    size: 14,
                                  ),
                                  const SizedBox(width: 3),
                                  Text(
                                    apartmentModel.address,
                                    style: const TextStyle(
                                      color: AppColors.textMuted,
                                      fontSize: 13,
                                    ),
                                  ),
                                ],
                              ),
                              Text(
                                HelperFunctions.formatPrice(
                                  apartmentModel.price,
                                ),
                                style: TextStyle(
                                  color: isDarkMode
                                      ? AppColors.primary
                                      : AppColors.primaryBg,
                                  fontSize: 20,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 6),
                          Text(
                            apartmentModel.title,
                            style: TextStyle(
                              color: isDarkMode
                                  ? AppColors.textPrimary
                                  : AppColors.textBlack,
                              fontSize: 17,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const SizedBox(height: 12),
                          SizedBox(
                            height: 44,
                            child: SingleChildScrollView(
                              scrollDirection: Axis.horizontal,
                              child: Row(
                                children: [
                                  _featureChip(
                                    Icons.layers_outlined,
                                    '${apartmentModel.floor!} ${'floor_label'.tr}',
                                    isDarkMode,
                                  ),
                                  const SizedBox(width: 8),
                                  _featureChip(
                                    Icons.square_foot,
                                    '${apartmentModel.sqm} ${'sqm_label'.tr}',
                                    isDarkMode,
                                  ),
                                  const SizedBox(width: 8),
                                  _featureChip(
                                    Icons.bed_outlined,
                                    '${apartmentModel.bedCount} ${'room_label'.tr}',
                                    isDarkMode,
                                  ),
                                  const SizedBox(width: 16),
                                  _contactButton(isDarkMode),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              )
              .animate()
              .fadeIn(
                delay: Duration(milliseconds: 350 + (index * 150)),
                duration: 500.ms,
              )
              .slideY(begin: 0.15, curve: Curves.easeOut),
    );
  }

  Widget _featureChip(IconData icon, String text, bool isDarkMode) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: isDarkMode ? AppColors.bgSurface : Colors.grey[400],
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          Icon(
            icon,
            color: isDarkMode ? AppColors.textMuted : AppColors.textDim,
            size: 13,
          ),
          const SizedBox(width: 4),
          Text(
            text,
            style: TextStyle(
              color: isDarkMode ? AppColors.textMuted : AppColors.textDim,
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }

  Widget _contactButton(bool isDarkMode) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      decoration: BoxDecoration(
        color: isDarkMode ? AppColors.bgLight : AppColors.bgSurface,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: AppColors.divider),
      ),
      child: Row(
        children: [
          Icon(
            Icons.phone_outlined,
            color: isDarkMode ? Colors.black : AppColors.textPrimary,
            size: 14,
          ),
          const SizedBox(width: 6),
          Text(
            'contact_label'.tr,
            style: TextStyle(
              color: isDarkMode ? Colors.black : AppColors.textPrimary,
              fontWeight: FontWeight.w600,
              fontSize: 13,
            ),
          ),
        ],
      ),
    );
  }
}
