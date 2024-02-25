import 'package:fpdart/fpdart.dart';
import 'package:pasa/core/domain/entity/failure.dart';
import 'package:pasa/core/domain/entity/user.dart';

abstract interface class IUserRepository {
  Future<Either<Failure, User>> get user;
}
