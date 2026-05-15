import 'package:get/get.dart';

class AdminBookingModel {
  final String id;
  final String userId;
  final String apartmentId;
  final String tenantName;
  final String tenantEmail;
  final String? tenantPhone;
  final DateTime bookingDate;
  final DateTime? bookingEndTime;
  final RxString status;
  final String apartmentTitle;

  AdminBookingModel({
    required this.id,
    required this.userId,
    required this.apartmentId,
    required this.tenantName,
    required this.tenantEmail,
    this.tenantPhone,
    required this.bookingDate,
    this.bookingEndTime,
    required String status,
    this.apartmentTitle = '',
  }) : status = status.obs;

  factory AdminBookingModel.fromJson(Map<String, dynamic> json) {
    final apartment = json['apartments'] as Map<String, dynamic>? ?? {};

    // ── Apartment title — يدعم translations الجديد والـ title_map القديم ──
    String apartmentTitle = '';
    final translations = apartment['translations'] as Map<String, dynamic>?;
    if (translations != null) {
      final titleMap = translations['title'] as Map<String, dynamic>?;
      final lang = Get.locale?.languageCode ?? 'en';
      apartmentTitle = titleMap?[lang] as String? ??
          titleMap?['en'] as String? ??
          '';
    } else {
      final rawTitleMap = apartment['title_map'] as Map?;
      if (rawTitleMap != null) {
        final lang = Get.locale?.languageCode ?? 'en';
        apartmentTitle = rawTitleMap[lang] as String? ??
            rawTitleMap['en'] as String? ??
            '';
      } else {
        apartmentTitle = apartment['title'] as String? ?? '';
      }
    }

    // ── Tenant info — يأتي مدمجاً من fetchBookings ──
    final tenantName = json['tenant_name'] as String? ??
        (json['profiles'] as Map?)?['full_name'] as String? ??
        'Unknown';
    final tenantEmail = json['tenant_email'] as String? ??
        (json['profiles'] as Map?)?['email'] as String? ??
        '';
    final tenantPhone = json['tenant_phone'] as String? ??
        (json['profiles'] as Map?)?['phone'] as String?;

    // ── Booking date — يدعم الأسماء القديمة والجديدة ──
    DateTime bookingDate;
    if (json['booking_date'] != null) {
      bookingDate = DateTime.parse(json['booking_date'] as String);
    } else if (json['available_from'] != null) {
      bookingDate = DateTime.parse(json['available_from'] as String);
    } else {
      bookingDate = DateTime.now();
    }

    DateTime? bookingEndTime;
    if (json['booking_end_time'] != null) {
      bookingEndTime = DateTime.tryParse(json['booking_end_time'] as String);
    } else if (json['available_to'] != null) {
      bookingEndTime = DateTime.tryParse(json['available_to'] as String);
    }

    return AdminBookingModel(
      id: json['id'] as String,
      userId: json['user_id'] as String,
      apartmentId: json['apartment_id'] as String,
      tenantName: tenantName,
      tenantEmail: tenantEmail,
      tenantPhone: tenantPhone,
      bookingDate: bookingDate,
      bookingEndTime: bookingEndTime,
      status: json['status'] as String? ?? 'pending',
      apartmentTitle: apartmentTitle,
    );
  }
}