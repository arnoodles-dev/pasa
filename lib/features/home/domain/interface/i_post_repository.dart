import 'package:fpdart/fpdart.dart';
import 'package:pasa/core/domain/entity/failure.dart';
import 'package:pasa/features/home/domain/entity/post.dart';

abstract interface class IPostRepository {
  Future<Either<Failure, List<Post>>> getPosts();
}
