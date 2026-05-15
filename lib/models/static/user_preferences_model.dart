class UserPreferencesModel {
  final String id;
  final List<String> preferredCities;
  final double? budgetMax;
  final String? maritalStatus;
  final int? numberOfOccupants;
  final bool? pets;
  final DateTime? updatedAt;

  const UserPreferencesModel({
    required this.id,
    this.preferredCities = const [],
    this.budgetMax,
    this.maritalStatus,
    this.numberOfOccupants,
    this.pets,
    this.updatedAt,
  });

  factory UserPreferencesModel.fromJson(Map<String, dynamic> json) {
    return UserPreferencesModel(
      id: json['id'] as String,
      preferredCities: (json['preferred_cities'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          [],
      budgetMax: (json['budget_max'] as num?)?.toDouble(),
      maritalStatus: json['marital_status'] as String?,
      numberOfOccupants: json['number_of_occupants'] as int?,
      pets: json['pets'] as bool?,
      updatedAt: json['updated_at'] != null
          ? DateTime.tryParse(json['updated_at'] as String)
          : null,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'preferred_cities': preferredCities,
        'budget_max': budgetMax,
        'marital_status': maritalStatus,
        'number_of_occupants': numberOfOccupants,
        'pets': pets,
      };

  UserPreferencesModel copyWith({
    List<String>? preferredCities,
    double? budgetMax,
    String? maritalStatus,
    int? numberOfOccupants,
    bool? pets,
  }) {
    return UserPreferencesModel(
      id: id,
      preferredCities: preferredCities ?? this.preferredCities,
      budgetMax: budgetMax ?? this.budgetMax,
      maritalStatus: maritalStatus ?? this.maritalStatus,
      numberOfOccupants: numberOfOccupants ?? this.numberOfOccupants,
      pets: pets ?? this.pets,
      updatedAt: updatedAt,
    );
  }
}
