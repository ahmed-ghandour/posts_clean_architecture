import 'package:dartz/dartz.dart';
import 'package:posts_clean_architecture/core/error/failures.dart';
import 'package:posts_clean_architecture/features/posts/domain/repositories/posts_repositories.dart';

import '../entities/post.dart';

class AddPostUseCase{
  final PostRepository repository;

  AddPostUseCase(this.repository);
  Future<Either<Failure,Unit>> call (Post post) async {
    return await repository.addPost(post);
  }
}