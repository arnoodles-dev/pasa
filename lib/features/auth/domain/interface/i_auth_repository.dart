import 'dart:async';

import 'package:fpdart/fpdart.dart';
import 'package:pasa/core/domain/entity/failure.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

abstract interface class IAuthRepository {
  StreamSubscription<AuthState> onAuthStateChange(
    void Function(AuthState)? onData,
  );

  Future<Either<Failure, AuthResponse>> loginWithProvider(
    OAuthProvider provider,
  );

  //TODO: implement this when sms provider is available
  // Future<Either<Failure, Unit>> loginWithPhoneNumber(
  //   PhoneNumber phone,
  // );

  Future<Either<Failure, Unit>> logout();
}
