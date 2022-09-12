import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:posts_clean_architecture/core/error/failures.dart';
import 'package:posts_clean_architecture/features/posts/domain/entities/post.dart';
import 'package:posts_clean_architecture/features/posts/domain/use_cases/get_all_posts.dart';

import '../../../../../core/strings/failures.dart';

part 'posts_event.dart';
part 'posts_state.dart';

class PostsBloc extends Bloc<PostsEvent, PostsState> {
  final GetAllPostsUseCase getAllPosts;
  PostsBloc({required this.getAllPosts}) : super(PostsInitial()) {
    on<PostsEvent>((event, emit) async {
      if (event is GetAllPostsEvent) {
        emit(LoadingPostsState());
        final failuresOrPosts = await getAllPosts();
        emit(_mapFailureOrPostsToState(failuresOrPosts));
      } else if (event is RefreshPostsEvent) {
          emit(LoadingPostsState());
          final failuresOrPosts = await getAllPosts();
          emit(_mapFailureOrPostsToState(failuresOrPosts));
      }
    });
  }

  PostsState _mapFailureOrPostsToState(Either<Failure, List<Post>> either) {
    return either.fold(
        (failure) => ErrorPostsState(errorMessage: _mapMessageToFailure(failure)),
        ((posts) => SuccessPostsState(posts: posts))
    );
  }

  String _mapMessageToFailure(Failure failure) {
    switch (failure.runtimeType) {
      case ServerFailure:
        return SERVER_FAILURE_MESSAGE;
      case EmptyCasheFailure:
        return EMPTY_CACHE_FAILURE_MESSAGE;
      case OfflineFailure:
        return OFFLINE_FAILURE_MESSAGE;
      default:
        return "Unexxpected error , please try again later";
    }
  }
}
