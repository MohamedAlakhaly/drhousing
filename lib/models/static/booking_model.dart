import 'package:apartment_rentals/models/static/apartment_model.dart';
import 'package:get/get.dart';

class BookingModel {
  final String id;
  final String userId;
  final String apartmentId;
  final DateTime bookingDate;
  final DateTime? bookingEndTime;
  final RxString status;
  final ApartmentModel? apartment;

  BookingModel({
    required this.id,
    required this.userId,
    required this.apartmentId,
    required this.bookingDate,
    this.bookingEndTime,
    required String status,
    this.apartment,
  }) : status = status.obs;

  factory BookingModel.fromJson(Map<String, dynamic> json) {
    final apartmentJson = json['apartments'] as Map<String, dynamic>?;
    return BookingModel(
      id: json['id'] as String,
      userId: json['user_id'] as String,
      apartmentId: json['apartment_id'] as String,
      bookingDate: DateTime.parse(json['available_from']),
      bookingEndTime: json['available_to'] != null
          ? DateTime.parse(json['available_to'])
          : null,
      status: (json['status'] as String?) ?? 'pending',
      apartment: apartmentJson != null
          ? ApartmentModel.fromJson(apartmentJson)
          : null,
    );
  }
}
