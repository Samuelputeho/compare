import 'package:compareitr/core/common/entities/user_entity.dart';

class UserModel extends UserEntity {
  UserModel({
    required super.name,
    required super.phoneNumber,
    required super.email,
    required super.id,
    required super.street,
    required super.location,
    required super.proPic,
  });

  factory UserModel.fromJson(Map<String, dynamic> map) {
    return UserModel(
      name: map['name'] ?? '',
      email: map['email'] ?? '',
      id: map['id'] ?? '',
      location: map['location'] ?? '',
      street: map['street'] ?? '',
      proPic: map['proPic'] ?? '',
      phoneNumber: map['phoneNumber'] is int
          ? map['phoneNumber']
          : int.tryParse(map['phoneNumber']?.toString() ?? '') ?? 0,
    );
  }

  UserModel copyWith({
    String? id,
    String? email,
    String? name,
    String? proPic,
    String? street,
    String? location,
    int? phoneNumber,
  }) {
    return UserModel(
      id: id ?? this.id,
      email: email ?? this.email,
      name: name ?? this.name,
      proPic: proPic ?? this.proPic,
      street: street ?? this.street,
      location: location ?? this.location,
      phoneNumber: phoneNumber ?? this.phoneNumber,
    );
  }
}
