import 'package:hive_flutter/hive_flutter.dart';

part 'user_model.g.dart';

/// A model representing a user in the Health Tracker application
///
/// Contains user's personal information, dietary preferences, and allergies
@HiveType(typeId: 20)
class UserModel extends HiveObject {
  UserModel({
    required this.uid,
    required this.name,
    required this.email,
    required this.accountCreationDate,
    this.phoneNumber,
    this.address,
    this.accessLevel = 'user',
    this.dietaryPreferences = const [],
    this.allergies = const [],
    this.profileImageUrl,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      uid: json['uid'] as String,
      name: json['name'] as String,
      email: json['email'] as String,
      accountCreationDate: DateTime.parse(
        json['account_creation_date'] as String,
      ),
      phoneNumber: json['phone_number'] as String?,
      address: json['address'] as String?,
      accessLevel: json['access_level'] as String? ?? 'user',
      dietaryPreferences: List<String>.from(
        json['dietary_preferences'] as List? ?? [],
      ),
      allergies: List<String>.from(json['allergies'] as List? ?? []),
      profileImageUrl: json['profile_image_url'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'uid': uid,
      'name': name,
      'email': email,
      'account_creation_date': accountCreationDate.toIso8601String(),
      'phone_number': phoneNumber,
      'address': address,
      'access_level': accessLevel,
      'dietary_preferences': dietaryPreferences,
      'allergies': allergies,
      'profile_image_url': profileImageUrl,
    };
  }

  /// The unique identifier for the user
  @HiveField(0)
  final String uid;

  /// The user's full name
  @HiveField(1)
  final String name;

  /// The user's email address (used for login)
  @HiveField(2)
  final String email;

  /// The date when the user created their account
  @HiveField(3)
  final DateTime accountCreationDate;

  /// The user's phone number (optional)
  @HiveField(4)
  final String? phoneNumber;

  /// The user's address (optional)
  @HiveField(5)
  final String? address;

  /// The user's access level (user or admin)
  @HiveField(6)
  final String accessLevel;

  /// The user's dietary preferences (e.g., vegan, gluten-free)
  @HiveField(7)
  final List<String> dietaryPreferences;

  /// The user's food allergies
  @HiveField(8)
  final List<String> allergies;

  /// URL to the user's profile image (optional)
  @HiveField(9)
  final String? profileImageUrl;
}
