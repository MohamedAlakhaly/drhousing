import 'package:apartment_rentals/core/constant/app_colors.dart';
import 'package:apartment_rentals/core/constant/app_state.dart';
import 'package:apartment_rentals/core/constant/responsive.dart';
import 'package:apartment_rentals/core/controllers/user_controller.dart';
import 'package:apartment_rentals/core/functions/helper_functions.dart';
import 'package:apartment_rentals/global/custom_loading_circular.dart';
import 'package:apartment_rentals/global/subscription_modal.dart';
import 'package:apartment_rentals/models/static/apartment_model.dart';
import 'package:apartment_rentals/modules/navigation_items/home/controller/apartment_controller.dart';
import 'package:apartment_rentals/modules/navigation_items/home/modules/view/show_apartment_details_view.dart';
import 'package:apartment_rentals/modules/navigation_items/saved/controller/saved_apartments_controller.dart';
import 'package:blur/blur.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:like_button/like_button.dart';

class SavedView extends StatelessWidget {
  const SavedView({super.key});

  @override
  Widget build(BuildContext context) {
    final savedController = Get.put(SavedApartmentsController());
    final userController = Get.find<UserController>();
    final bool isDarkMode = HelperFunctions.isDarkMode(context);

    return Scaffold(
      backgroundColor: isDarkMode ? AppColors.bgDark : AppColors.bgLight,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ── Header ──────────────────────────────────────────────────────
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 20, 20, 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'saved_view_title'.tr,
                        style: TextStyle(
                          color: isDarkMode
                              ? AppColors.textPrimary
                              : AppColors.textBlack,
                          fontSize: 26,
                          fontWeight: FontWeight.w700,
                          letterSpacing: -0.5,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'saved_view_description'.tr,
                        style: TextStyle(
                          color: AppColors.textMuted,
                          fontSize: 13,
                        ),
                      ),
                    ],
                  ),
                  // Refresh button
                  GestureDetector(
                    onTap: savedController.fetchSavedApartments,
                    child: Container(
                      width: 42,
                      height: 42,
                      decoration: BoxDecoration(
                        color: isDarkMode ? AppColors.bgCard : AppColors.bgGrey,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Icon(
                        Iconsax.refresh,
                        color: isDarkMode
                            ? AppColors.textMuted
                            : AppColors.textBlack,
                        size: 20,
                      ),
                    ),
                  ),
                ],
              ),
            ).animate().fadeIn(duration: 400.ms).slideY(begin: -0.2),

            // ── Body ────────────────────────────────────────────────────────
            Expanded(
              child: Obx(() {
                if (savedController.isLoading.value) {
                  return const Center(child: CustomLoadingCircular());
                }

                if (savedController.hasError) {
                  return _ErrorState(
                    controller: savedController,
                    isDarkMode: isDarkMode,
                  );
                }

                if (savedController.isEmpty) {
                  return _EmptyState(isDarkMode: isDarkMode);
                }

                return RefreshIndicator(
                  color: HelperFunctions.getPrimary(context),
                  backgroundColor: isDarkMode ? AppColors.bgCard : Colors.white,
                  onRefresh: savedController.fetchSavedApartments,
                  child: Responsive.isMobile(context)
                      ? ListView.builder(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 8,
                          ),
                          itemCount: savedController.savedApartments.length,
                          itemBuilder: (context, index) => ApartmentCard(
                            apartmentModel:
                                savedController.savedApartments[index],
                            userController: userController,
                            savedController: savedController,
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
                                crossAxisCount: Responsive.isDesktop(context)
                                    ? 4
                                    : 2,
                                crossAxisSpacing: 16,
                                mainAxisSpacing: 16,
                                mainAxisExtent: 380,
                              ),
                          itemCount: savedController.savedApartments.length,
                          itemBuilder: (context, index) => ApartmentCard(
                            apartmentModel:
                                savedController.savedApartments[index],
                            userController: userController,
                            savedController: savedController,
                            index: index,
                            isDarkMode: isDarkMode,
                          ),
                        ),
                );
              }),
            ),
          ],
        ),
      ),
    );
  }
}

// ── Error state ───────────────────────────────────────────────────────────────

class _ErrorState extends StatelessWidget {
  const _ErrorState({required this.controller, required this.isDarkMode});

  final SavedApartmentsController controller;
  final bool isDarkMode;

  @override
  Widget build(BuildContext context) {
    return Center(
      child:
          Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: 76,
                    height: 76,
                    decoration: BoxDecoration(
                      color: isDarkMode ? AppColors.bgCard : Colors.white,
                      shape: BoxShape.circle,
                      boxShadow: isDarkMode
                          ? null
                          : [
                              BoxShadow(
                                color: Colors.black.withValues(alpha: 0.07),
                                blurRadius: 14,
                              ),
                            ],
                    ),
                    child: const Icon(
                      Icons.wifi_off_rounded,
                      color: AppColors.textMuted,
                      size: 32,
                    ),
                  ),
                  const SizedBox(height: 18),
                  Text(
                    'saved_view_error_state'.tr,
                    style: TextStyle(
                      color: isDarkMode
                          ? AppColors.textPrimary
                          : AppColors.textBlack,
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 40),
                    child: Text(
                      controller.errorMessage.value,
                      style: const TextStyle(
                        color: AppColors.textMuted,
                        fontSize: 13,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  const SizedBox(height: 22),
                  GestureDetector(
                    onTap: controller.fetchSavedApartments,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 28,
                        vertical: 14,
                      ),
                      decoration: BoxDecoration(
                        color: HelperFunctions.getPrimary(context),
                        borderRadius: BorderRadius.circular(14),
                        boxShadow: [
                          BoxShadow(
                            color: HelperFunctions.getPrimary(context).withValues(alpha: 0.35),
                            blurRadius: 14,
                            offset: const Offset(0, 5),
                          ),
                        ],
                      ),
                      child: Text(
                        'try_again_button'.tr,
                        style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.w700,
                          fontSize: 14,
                        ),
                      ),
                    ),
                  ),
                ],
              )
              .animate()
              .fadeIn(duration: 400.ms)
              .scale(begin: const Offset(0.92, 0.92)),
    );
  }
}

// ── Empty state ───────────────────────────────────────────────────────────────

class _EmptyState extends StatelessWidget {
  const _EmptyState({required this.isDarkMode});

  final bool isDarkMode;

  @override
  Widget build(BuildContext context) {
    return Center(
      child:
          Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: 90,
                    height: 90,
                    decoration: BoxDecoration(
                      color: isDarkMode ? AppColors.bgCard : Colors.white,
                      shape: BoxShape.circle,
                      boxShadow: isDarkMode
                          ? null
                          : [
                              BoxShadow(
                                color: Colors.black.withValues(alpha: 0.07),
                                blurRadius: 14,
                                spreadRadius: 1,
                              ),
                            ],
                    ),
                    child: const Icon(
                      Iconsax.heart,
                      color: AppColors.textMuted,
                      size: 38,
                    ),
                  ),
                  const SizedBox(height: 20),
                  Text(
                    'saved_view_empty_state_title'.tr,
                    style: TextStyle(
                      color: isDarkMode
                          ? AppColors.textPrimary
                          : AppColors.textBlack,
                      fontSize: 17,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'saved_view_empty_state_content'.tr,
                    style: TextStyle(color: AppColors.textMuted, fontSize: 13),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 28),
                  GestureDetector(
                    onTap: () => AppState.currentIndex.value = 0,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 32,
                        vertical: 15,
                      ),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            HelperFunctions.getPrimary(context),
                            HelperFunctions.getPrimary(context).withValues(alpha: 0.80),
                          ],
                        ),
                        borderRadius: BorderRadius.circular(14),
                        boxShadow: [
                          BoxShadow(
                            color: HelperFunctions.getPrimary(context).withValues(alpha: 0.35),
                            blurRadius: 16,
                            offset: const Offset(0, 6),
                          ),
                        ],
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Iconsax.home, color: Colors.black, size: 18),
                          SizedBox(width: 8),
                          Text(
                            'go_browse_button'.tr,
                            style: TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.w700,
                              fontSize: 15,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              )
              .animate()
              .fadeIn(delay: 200.ms, duration: 500.ms)
              .scale(begin: const Offset(0.9, 0.9)),
    );
  }
}

// ── Apartment card ────────────────────────────────────────────────────────────

class ApartmentCard extends StatelessWidget {
  const ApartmentCard({
    super.key,
    required this.apartmentModel,
    required this.userController,
    this.savedController,
    this.apartmentController,
    required this.index,
    required this.isDarkMode,
  });

  final ApartmentModel apartmentModel;
  final UserController userController;
  final SavedApartmentsController? savedController;
  final ApartmentController? apartmentController;
  final int index;
  final bool isDarkMode;

  @override
  Widget build(BuildContext context) {
    final bool isLocked = !userController.isPremium;

    return GestureDetector(
      onTap: () {
        isLocked
            ? showSubscriptionModal(context)
            : Get.to(
                () => ShowApartmentDetailsView(
                  apartmentModel: apartmentModel,
                  userController: userController,
                ),
              );
      },
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
                    // ── Image section ───────────────────────────────────────────────
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
                                        child: Center(
                                          child: CircularProgressIndicator(
                                            color: HelperFunctions.getPrimary(context),
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
                        ),
                        // Lock / status badge
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
                                      color: HelperFunctions.getPrimary(context),
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
                                  start: HelperFunctions.getPrimary(context).withValues(
                                    alpha: 0.5,
                                  ),
                                  end: HelperFunctions.getPrimary(context),
                                ),
                                bubblesColor: BubblesColor(
                                  dotPrimaryColor: HelperFunctions.getPrimary(context),
                                  dotSecondaryColor: Colors.orangeAccent,
                                ),
                                likeBuilder: (isLiked) => Icon(
                                  isLiked
                                      ? Icons.favorite_rounded
                                      : Icons.favorite_border_rounded,
                                  color: isLiked
                                      ? HelperFunctions.getPrimary(context)
                                      : Colors.white,
                                  size: 20,
                                ),
                                onTap: (isLiked) async {
                                  savedController!.unfavorite(apartmentModel);
                                  return !isLiked;
                                },
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),

                    // ── Details ─────────────────────────────────────────────────────
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
                                      ? HelperFunctions.getPrimary(context)
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
                                  ),
                                  if(apartmentModel.sqm !=0)
                                  const SizedBox(width: 8),
                                  if(apartmentModel.sqm !=0)
                                  _featureChip(
                                    Icons.square_foot,
                                    '${apartmentModel.sqm} ${'sqm_label'.tr}',
                                  ),
                                  const SizedBox(width: 8),
                                  _featureChip(
                                    Icons.bed_outlined,
                                    '${apartmentModel.bedCount} ${'room_label'.tr}',
                                  ),
                                  const SizedBox(width: 16),
                                  _contactButton(),
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
                delay: Duration(milliseconds: 200 + (index * 120)),
                duration: 500.ms,
              )
              .slideY(begin: 0.15, curve: Curves.easeOut),
    );
  }

  Widget _featureChip(IconData icon, String text) {
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

  Widget _contactButton() {
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
