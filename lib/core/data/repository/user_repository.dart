import 'package:fpdart/fpdart.dart';
import 'package:injectable/injectable.dart';
import 'package:logger/logger.dart';
import 'package:pasa/app/constants/enum.dart';
import 'package:pasa/app/helpers/extensions/int_ext.dart';
import 'package:pasa/app/helpers/injection.dart';
import 'package:pasa/core/data/dto/user.dto.dart';
import 'package:pasa/core/domain/entity/failure.dart';
import 'package:pasa/core/domain/entity/user.dart';
import 'package:pasa/core/domain/interface/i_user_repository.dart';
import 'package:supabase_flutter/supabase_flutter.dart' as supabase;

@LazySingleton(as: IUserRepository)
class UserRepository implements IUserRepository {
  const UserRepository(
    this._supabase,
  );

  final supabase.SupabaseClient _supabase;

  Logger get logger => getIt<Logger>();

  @override
  Future<Either<Failure, User>> get user async {
    try {
      final supabase.Session? session = _supabase.auth.currentSession;
      if (session != null) {
        final UserDTO userDTO = UserDTO.fromSupabase(session.user);
        return _validateUserData(userDTO);
      }
      return left(const Failure.sessionNotFound());
    } on supabase.AuthException catch (error) {
      return left(_onAuthError(error));
    } catch (error) {
      logger.e(error.toString());
      return left(Failure.unexpected(error.toString()));
    }
  }

  Failure _onAuthError(supabase.AuthException error) {
    logger.e(error.toString());
    final int? code = int.tryParse(error.statusCode ?? '');
    final StatusCode statusCode =
        code != null ? code.statusCode : StatusCode.http000;
    return Failure.serverError(statusCode, error.message);
  }

  Either<Failure, User> _validateUserData(UserDTO userDTO) {
    final User user = userDTO.toDomain();

    return user.failureOption.fold(() => right(user), left);
  }
}
