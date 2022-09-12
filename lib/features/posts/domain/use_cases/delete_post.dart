import 'package:dartz/dartz.dart';
import 'package:posts_clean_architecture/features/posts/domain/repositories/posts_repositories.dart';

import '../../../../core/error/failures.dart';

class DeletePostUseCase {
  final PostRepository repository;

  DeletePostUseCase(this.repository);

  Future<Either<Failure,Unit>> call(int id) async {
    return await repository.deletePost(id);
  }
}