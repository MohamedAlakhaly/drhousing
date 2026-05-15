import 'package:get/get.dart';

class ApartmentModel {
  final String id;
  final DateTime createdAt;

  //! Multi-language content
  final Map<String, String> titleMap;
  final Map<String, String> descriptionMap;

  //! Basic Info
  final int price;
  final String address;
  final int bedCount;
  final int sqm;
  final String? floor;

  //! Images
  final List<String> imageUrls;

  //! Status
  final String status;

  //! Amenities
  final bool hasParking;
  final bool hasLaundry;
  final bool hasElevator;
  final bool hasPets;
  final bool hasBalcony;

  //! Rental Terms
  final bool acceptsHousingAssistance;
  final bool acceptsCpasOrOcmw;
  final bool isAllBillsIncluded;

  //! Reactive states
  final RxBool isFavorite;
  final RxString bookingStatus;

  ApartmentModel({
    required this.id,
    required this.createdAt,
    required this.titleMap,
    this.descriptionMap = const {},
    required this.price,
    required this.address,
    required this.bedCount,
    required this.sqm,
    this.floor,
    this.imageUrls = const [],
    this.status = 'available',
    required this.hasParking,
    required this.hasLaundry,
    required this.hasElevator,
    required this.hasPets,
    required this.hasBalcony,
    required this.acceptsHousingAssistance,
    required this.acceptsCpasOrOcmw,
    required this.isAllBillsIncluded,
    bool isFavorite = false,
    String bookingStatus = '',
  })  : isFavorite = isFavorite.obs,
        bookingStatus = bookingStatus.obs;

  // ── Localized getters ──────────────────────────────────────
  String get localizedTitle {
    final lang = Get.locale?.languageCode ?? 'en';
    return titleMap[lang]?.isNotEmpty == true
        ? titleMap[lang]!
        : (titleMap['en'] ?? titleMap.values.firstOrNull ?? '');
  }

  String get localizedDescription {
    final lang = Get.locale?.languageCode ?? 'en';
    return descriptionMap[lang]?.isNotEmpty == true
        ? descriptionMap[lang]!
        : (descriptionMap['en'] ?? descriptionMap.values.firstOrNull ?? '');
  }

  // title يرجع localizedTitle دائماً
  String get title => localizedTitle;
  String get description => localizedDescription;
  String? get imageUrl => imageUrls.isNotEmpty ? imageUrls.first : null;

  factory ApartmentModel.fromJson(
    Map<String, dynamic> json, {
    bool isFavorite = false,
    String bookingStatus = '',
  }) {
    // ── translations JSONB ─────────────────────────────────
    // يدعم الهيكل الجديد: translations: {title: {ar,en,fr,nl}, description: {...}}
    // والهيكل القديم: title_map, description_map
    Map<String, String> titleMap = {};
    Map<String, String> descriptionMap = {};

    final rawTranslations = json['translations'];
    if (rawTranslations is Map) {
      final titleRaw = rawTranslations['title'];
      final descRaw = rawTranslations['description'];
      if (titleRaw is Map) {
        titleMap = Map<String, String>.from(
          titleRaw.map((k, v) => MapEntry(k.toString(), v?.toString() ?? '')),
        );
      }
      if (descRaw is Map) {
        descriptionMap = Map<String, String>.from(
          descRaw.map((k, v) => MapEntry(k.toString(), v?.toString() ?? '')),
        );
      }
    } else {
      // fallback للهيكل القديم
      final rawTitleMap = json['title_map'];
      if (rawTitleMap is Map) {
        titleMap = Map<String, String>.from(
          rawTitleMap.map((k, v) => MapEntry(k.toString(), v?.toString() ?? '')),
        );
      } else {
        titleMap = {'en': json['title'] as String? ?? ''};
      }

      final rawDescMap = json['description_map'];
      if (rawDescMap is Map) {
        descriptionMap = Map<String, String>.from(
          rawDescMap.map((k, v) => MapEntry(k.toString(), v?.toString() ?? '')),
        );
      } else {
        descriptionMap = {'en': json['description'] as String? ?? ''};
      }
    }

    // ── image_urls ─────────────────────────────────────────
    final rawImageUrls = json['image_urls'];
    final List<String> imageUrls;
    if (rawImageUrls is List && rawImageUrls.isNotEmpty) {
      imageUrls = rawImageUrls.map((e) => e.toString()).toList();
    } else if (json['image_url'] is String &&
        (json['image_url'] as String).isNotEmpty) {
      imageUrls = [json['image_url'] as String];
    } else {
      imageUrls = [];
    }

    return ApartmentModel(
      id: json['id'] as String,
      createdAt: DateTime.parse(json['created_at'] as String),
      titleMap: titleMap,
      descriptionMap: descriptionMap,
      price: json['price'] as int? ?? 0,
      address: json['address'] as String? ?? '',
      bedCount: json['bed_count'] as int? ?? 1,
      sqm: json['sqm'] as int? ?? 0,
      floor: json['floor'] as String?,
      imageUrls: imageUrls,
      status: json['status'] as String? ?? 'available',
      hasParking: json['has_parking'] as bool? ?? false,
      hasLaundry: json['has_laundry'] as bool? ?? false,
      hasElevator: json['has_elevator'] as bool? ?? false,
      hasPets: json['has_pets'] as bool? ?? false,
      hasBalcony: json['has_balcony'] as bool? ?? false,
      acceptsHousingAssistance:
          json['accepts_housing_assistance'] as bool? ?? false,
      acceptsCpasOrOcmw: json['accepts_cpas_or_ocmw'] as bool? ?? false,
      isAllBillsIncluded: json['is_all_bills_included'] as bool? ?? false,
      isFavorite: isFavorite,
      bookingStatus: bookingStatus,
    );
  }

  Map<String, dynamic> toJson() => {
        'translations': {
          'title': titleMap,
          'description': descriptionMap,
        },
        'price': price,
        'address': address,
        'bed_count': bedCount,
        'sqm': sqm,
        'floor': floor,
        'image_urls': imageUrls,
        'status': status,
        'has_parking': hasParking,
        'has_laundry': hasLaundry,
        'has_elevator': hasElevator,
        'has_pets': hasPets,
        'has_balcony': hasBalcony,
        'accepts_housing_assistance': acceptsHousingAssistance,
        'accepts_cpas_or_ocmw': acceptsCpasOrOcmw,
        'is_all_bills_included': isAllBillsIncluded,
      };

  //! Helpers
  bool get isAvailable => status == 'available';
  bool get isRented => status == 'rented';
  bool get isBooked =>
      bookingStatus.value == 'pending' || bookingStatus.value == 'confirmed';

  List<String> get activeAmenities {
    final list = <String>[];
    if (hasParking) list.add('Parking');
    if (hasLaundry) list.add('Laundry');
    if (hasElevator) list.add('Elevator');
    if (hasPets) list.add('Pets allowed');
    if (hasBalcony) list.add('Balcony');
    return list;
  }

  List<String> get activeRentalTerms {
    final list = <String>[];
    if (acceptsHousingAssistance) list.add('Housing Assistance');
    if (acceptsCpasOrOcmw) list.add('CPAS / OCMW');
    if (isAllBillsIncluded) list.add('All Bills Included');
    return list;
  }
}