import 'dart:developer';
import 'package:apartment_rentals/models/static/apartment_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

final _supabase = Supabase.instance.client;

class ApartmentFormController extends GetxController {
  final ApartmentModel? existing;
  ApartmentFormController({this.existing});

  final formKey = GlobalKey<FormState>();

  // ── Language tabs ────────────────────────────────────────────────────────────
  static const langs = ['en', 'ar', 'fr', 'nl'];
  static const langLabels = {
    'en': 'English',
    'ar': 'عربي',
    'fr': 'Français',
    'nl': 'Nederlands',
  };
  final RxInt selectedLangIndex = 0.obs;

  late final Map<String, TextEditingController> titleCtrls;
  late final Map<String, TextEditingController> descCtrls;

  // ── Basic fields ─────────────────────────────────────────────────────────────
  late final TextEditingController priceCtrl;
  late final TextEditingController addressCtrl;
  late final TextEditingController bedCountCtrl;
  late final TextEditingController sqmCtrl;
  late final TextEditingController floorCtrl;

  // ── Status ───────────────────────────────────────────────────────────────────
  final RxString status = 'available'.obs;

  // ── Images ───────────────────────────────────────────────────────────────────
  final RxList<TextEditingController> imageCtrls = <TextEditingController>[].obs;

  // ── Amenities ────────────────────────────────────────────────────────────────
  final RxBool hasParking = false.obs;
  final RxBool hasLaundry = false.obs;
  final RxBool hasElevator = false.obs;
  final RxBool hasPets = false.obs;
  final RxBool hasBalcony = false.obs;

  // ── Rental terms ─────────────────────────────────────────────────────────────
  final RxBool acceptsHousingAssistance = false.obs;
  final RxBool acceptsCpasOrOcmw = false.obs;
  final RxBool isAllBillsIncluded = false.obs;

  final RxBool isLoading = false.obs;

  bool get isEditing => existing != null;

  String get selectedLang => langs[selectedLangIndex.value];
  bool isTitleFilled(String lang) => titleCtrls[lang]!.text.isNotEmpty;

  @override
  void onInit() {
    titleCtrls = {for (final l in langs) l: TextEditingController()};
    descCtrls = {for (final l in langs) l: TextEditingController()};
    priceCtrl = TextEditingController();
    addressCtrl = TextEditingController();
    bedCountCtrl = TextEditingController();
    sqmCtrl = TextEditingController();
    floorCtrl = TextEditingController();

    if (existing != null) _populate(existing!);

    if (imageCtrls.isEmpty) imageCtrls.add(TextEditingController());

    super.onInit();
  }

  void _populate(ApartmentModel apt) {
    for (final l in langs) {
      titleCtrls[l]!.text = apt.titleMap[l] ?? '';
      descCtrls[l]!.text = apt.descriptionMap[l] ?? '';
    }
    priceCtrl.text = apt.price.toString();
    addressCtrl.text = apt.address;
    bedCountCtrl.text = apt.bedCount.toString();
    sqmCtrl.text = apt.sqm.toString();
    floorCtrl.text = apt.floor ?? '';
    status.value = apt.status;
    hasParking.value = apt.hasParking;
    hasLaundry.value = apt.hasLaundry;
    hasElevator.value = apt.hasElevator;
    hasPets.value = apt.hasPets;
    hasBalcony.value = apt.hasBalcony;
    acceptsHousingAssistance.value = apt.acceptsHousingAssistance;
    acceptsCpasOrOcmw.value = apt.acceptsCpasOrOcmw;
    isAllBillsIncluded.value = apt.isAllBillsIncluded;

    imageCtrls.clear();
    if (apt.imageUrls.isNotEmpty) {
      for (final url in apt.imageUrls) {
        imageCtrls.add(TextEditingController(text: url));
      }
    } else {
      imageCtrls.add(TextEditingController());
    }
  }

  void addImageField() {
  imageCtrls.add(TextEditingController());
  update(); // ← أضف هذا
}

  void removeImageField(int index) {
    if (imageCtrls.length <= 1) return;
    imageCtrls[index].dispose();
    imageCtrls.removeAt(index);
    update();
  }

  Future<void> save() async {
    if (!formKey.currentState!.validate()) return;

    isLoading.value = true;
    try {
      final urlImages = imageCtrls
          .map((c) => c.text.trim())
          .where((u) => u.isNotEmpty)
          .toList();

      final payload = {
        'translations': {
          'title': {for (final l in langs) l: titleCtrls[l]!.text.trim()},
          'description': {for (final l in langs) l: descCtrls[l]!.text.trim()},
        },
        'image_urls': urlImages,
        'price': int.tryParse(priceCtrl.text.trim()) ?? 0,
        'address': addressCtrl.text.trim(),
        'bed_count': int.tryParse(bedCountCtrl.text.trim()) ?? 1,
        'sqm': int.tryParse(sqmCtrl.text.trim()) ?? 0,
        'floor': floorCtrl.text.trim().isEmpty ? null : floorCtrl.text.trim(),
        'status': status.value,
        'has_parking': hasParking.value,
        'has_laundry': hasLaundry.value,
        'has_elevator': hasElevator.value,
        'has_pets': hasPets.value,
        'has_balcony': hasBalcony.value,
        'accepts_housing_assistance': acceptsHousingAssistance.value,
        'accepts_cpas_or_ocmw': acceptsCpasOrOcmw.value,
        'is_all_bills_included': isAllBillsIncluded.value,
      };

      if (isEditing) {
        await _supabase
            .from('apartments')
            .update(payload)
            .eq('id', existing!.id);
      } else {
        await _supabase.from('apartments').insert(payload);
      }

      Get.back(result: true);
      Get.snackbar(
        isEditing ? 'admin_apt_updated_title'.tr : 'admin_apt_created_title'.tr,
        isEditing ? 'admin_apt_updated_msg'.tr : 'admin_apt_created_msg'.tr,
        backgroundColor: const Color(0xFF1E1E1E),
        colorText: const Color(0xFFCCFF00),
        duration: const Duration(seconds: 3),
      );
    } catch (e) {
      log('ApartmentFormController.save: $e');
      Get.snackbar('errorTitle'.tr, 'unexpectedError'.tr);
    } finally {
      isLoading.value = false;
    }
  }

  @override
  void onClose() {
    for (final c in titleCtrls.values) { c.dispose(); }
    for (final c in descCtrls.values) { c.dispose(); }
    priceCtrl.dispose();
    addressCtrl.dispose();
    bedCountCtrl.dispose();
    sqmCtrl.dispose();
    floorCtrl.dispose();
    for (final c in imageCtrls) { c.dispose(); }
    super.onClose();
  }
}
