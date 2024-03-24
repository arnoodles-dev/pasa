import 'dart:convert';

import 'package:dartx/dartx.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:pasa/core/domain/entity/user.dart';
import 'package:pasa/core/domain/entity/value_object.dart';
import 'package:supabase_flutter/supabase_flutter.dart' as supabase;

part 'user.dto.freezed.dart';
part 'user.dto.g.dart';

@freezed
class UserDTO with _$UserDTO {
  const factory UserDTO({
    @JsonKey(name: 'id') required String uid,
    required String createdAt,
    String? lastSignInAt,
    String? updatedAt,
    String? email,
    String? phoneNumber,
  }) = _UserDTO;

  const UserDTO._();

  factory UserDTO.fromJson(Map<String, dynamic> json) =>
      _$UserDTOFromJson(json);

  factory UserDTO.fromSupabase(supabase.User user) => UserDTO(
        uid: user.id,
        email: user.email,
        phoneNumber: user.phone,
        lastSignInAt: user.lastSignInAt,
        updatedAt: user.updatedAt,
        createdAt: user.createdAt,
      );

  factory UserDTO.fromDomain(User user) => UserDTO(
        uid: user.uid.getOrCrash(),
        email: user.email?.getOrCrash(),
        phoneNumber: user.phoneNumber?.getOrCrash(),
        lastSignInAt: user.lastSignInAt?.toIso8601String(),
        updatedAt: user.updatedAt?.toIso8601String(),
        createdAt: user.createdAt.toIso8601String(),
      );

  factory UserDTO.userDTOFromJson(String str) =>
      UserDTO.fromJson(json.decode(str) as Map<String, dynamic>);

  static String userDTOToJson(UserDTO data) => json.encode(data.toJson());

  User toDomain() => User(
        uid: UniqueId.fromUniqueString(uid),
        email: email.isNotNullOrBlank ? EmailAddress(email!) : null,
        phoneNumber:
            phoneNumber.isNotNullOrBlank ? PhoneNumber(phoneNumber!) : null,
        lastSignInAt: lastSignInAt.isNotNullOrBlank
            ? DateTime.tryParse(lastSignInAt!)
            : null,
        updatedAt:
            updatedAt.isNotNullOrBlank ? DateTime.tryParse(updatedAt!) : null,
        createdAt: DateTime.parse(createdAt),
      );
}
