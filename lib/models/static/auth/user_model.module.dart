class UserModel {
  final String id;
  final String fullName;
  final String email;
  final String? phone;
  final bool isPremium;
  final DateTime? premiumActivatedAt;
  final DateTime? premiumExpiresAt;
  final String? jobTitle;
  final String? employmentStatus;
  final String role;
  final bool isBlocked; // ← أضفناه
  final DateTime? createdAt;
  final DateTime? updatedAt;

  const UserModel({
    required this.id,
    required this.fullName,
    required this.email,
    this.phone,
    required this.isPremium,
    this.premiumActivatedAt,
    this.premiumExpiresAt,
    this.jobTitle,
    this.employmentStatus,
    this.role = 'tenant',
    this.isBlocked = false,
    this.createdAt,
    this.updatedAt,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'] as String,
      fullName: json['full_name'] as String? ?? '',
      email: json['email'] as String? ?? '',
      phone: json['phone'] as String?,
      isPremium: json['is_premium'] as bool? ?? false,
      premiumActivatedAt: json['premium_activated_at'] != null
          ? DateTime.tryParse(json['premium_activated_at'] as String)
          : null,
          premiumExpiresAt: json['premium_expires_at'] != null
    ? DateTime.tryParse(json['premium_expires_at'] as String)
    : null,
      jobTitle: json['job_title'] as String?,
      employmentStatus: json['employment_status'] as String?,
      role: json['role'] as String? ?? 'tenant',
      isBlocked: json['is_blocked'] as bool? ?? false, // ← أضفناه
      createdAt: json['created_at'] != null
          ? DateTime.tryParse(json['created_at'] as String)
          : null,
      updatedAt: json['updated_at'] != null
          ? DateTime.tryParse(json['updated_at'] as String)
          : null,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'full_name': fullName,
        'email': email,
        'phone': phone,
        'is_premium': isPremium,
        'job_title': jobTitle,
        'employment_status': employmentStatus,
        'role': role,
        'is_blocked': isBlocked,
      };

  // ── Getters ──────────────────────────────────────────────
  bool get isPremiumActive {
  if (!isPremium) return false;
  if (premiumExpiresAt == null) return true;
  return premiumExpiresAt!.isAfter(DateTime.now());
}

  int get daysRemaining {
    if (premiumExpiresAt == null) return 0;
    final diff = premiumExpiresAt!.difference(DateTime.now()).inDays;
    return diff < 0 ? 0 : diff;
  }

  bool get isPremiumExpired =>
      isPremium && premiumExpiresAt != null &&
      premiumExpiresAt!.isBefore(DateTime.now());

  UserModel copyWith({
    String? fullName,
    String? email,
    String? phone,
    bool? isPremium,
    String? jobTitle,
    String? employmentStatus,
    String? role,
    bool? isBlocked,
  }) {
    return UserModel(
      id: id,
      fullName: fullName ?? this.fullName,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      isPremium: isPremium ?? this.isPremium,
      jobTitle: jobTitle ?? this.jobTitle,
      employmentStatus: employmentStatus ?? this.employmentStatus,
      role: role ?? this.role,
      isBlocked: isBlocked ?? this.isBlocked,
      createdAt: createdAt,
      updatedAt: updatedAt,
    );
  }
}