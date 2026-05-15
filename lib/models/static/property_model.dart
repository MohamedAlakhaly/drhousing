class PropertyModel {
  final String id;
  final String title;
  final String city;
  final double price;
  final int bedrooms;
  final bool isLocked;
  final String imageUrl;

  const PropertyModel({
    required this.id,
    required this.title,
    required this.city,
    required this.price,
    required this.bedrooms,
    required this.isLocked,
    required this.imageUrl,
  });

  factory PropertyModel.fromJson(Map<String, dynamic> json) => PropertyModel(
    id: json['id']?.toString() ?? '',
    title: json['title'] ?? '',
    city: json['city'] ?? '',
    price: (json['price'] as num?)?.toDouble() ?? 0,
    bedrooms: (json['bedrooms'] as num?)?.toInt() ?? 0,
    isLocked: json['is_locked'] ?? true,
    imageUrl: json['image_url'] ?? '',
  );
}
