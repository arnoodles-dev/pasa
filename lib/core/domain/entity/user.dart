import 'package:fpdart/fpdart.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:pasa/core/domain/entity/failure.dart';
import 'package:pasa/core/domain/entity/value_object.dart';

part 'user.freezed.dart';

@freezed
class User with _$User {
  const factory User({
    required UniqueId uid,
    required DateTime createdAt,
    DateTime? lastSignInAt,
    DateTime? updatedAt,
    EmailAddress? email,
    PhoneNumber? phoneNumber,
  }) = _User;

  const User._();

  Option<Failure> get failureOption => uid.failureOrUnit
      .andThen(
        () => email == null ? right(unit) : email!.failureOrUnit,
      )
      .andThen(
        () => phoneNumber == null ? right(unit) : phoneNumber!.failureOrUnit,
      )
      .fold(some, (_) => none());
}
