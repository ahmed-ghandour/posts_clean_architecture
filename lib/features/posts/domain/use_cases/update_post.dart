import 'package:dartz/dartz.dart';
import 'package:posts_clean_architecture/core/error/failures.dart';
import 'package:posts_clean_architecture/features/posts/domain/entities/post.dart';
import 'package:posts_clean_architecture/features/posts/domain/repositories/posts_repositories.dart';

class UpdatePostUseCase{
  final PostRepository repository;

  UpdatePostUseCase(this.repository);

  Future<Either<Failure,Unit>> call (Post post) async {

    return await repository.updatePost(post);
  
  }
}