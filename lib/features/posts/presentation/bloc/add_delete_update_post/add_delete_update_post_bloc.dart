import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:posts_clean_architecture/features/posts/domain/use_cases/add_post.dart';

import '../../../../../core/error/failures.dart';
import '../../../../../core/strings/done_messages.dart';
import '../../../../../core/strings/failures.dart';
import '../../../domain/entities/post.dart';
import '../../../domain/use_cases/delete_post.dart';
import '../../../domain/use_cases/update_post.dart';

part 'add_delete_update_post_event.dart';
part 'add_delete_update_post_state.dart';

class AddDeleteUpdatePostBloc
    extends Bloc<AddDeleteUpdatePostEvent, AddDeleteUpdatePostState> {
  final AddPostUseCase addPost;
  final UpdatePostUseCase updatePost;
  final DeletePostUseCase deletePost;
  AddDeleteUpdatePostBloc(
      {required this.addPost,
      required this.updatePost,
      required this.deletePost})
      : super(AddDeleteUpdatePostInitial()) {
    on<AddDeleteUpdatePostEvent>((event, emit) async {
      if (event is AddPostEvent) {
        emit(LoadingAddDeleteUpdatePostState());
        final failureOrDone = await addPost(event.post);
        emit(_eitherErrorOrDoneState(
            either: failureOrDone, message: ADD_SUCCESS_MESSAGE));
      } else if (event is UpdatePostEvent) {
        emit(LoadingAddDeleteUpdatePostState());
        final failureOrDone = await updatePost(event.post);
        emit(_eitherErrorOrDoneState(
            either: failureOrDone, message: UPDATE_SUCCESS_MESSAGE));
      } else if (event is DeletePostEvent) {
        emit(LoadingAddDeleteUpdatePostState());
        final failureOrDone = await deletePost(event.postId);
        emit(_eitherErrorOrDoneState(
            either: failureOrDone, message: DELETE_SUCCESS_MESSAGE));
      }
    });
  }

  AddDeleteUpdatePostState _eitherErrorOrDoneState(
      {required Either<Failure, Unit> either, required String message}) {
    return either.fold(
        (failure) => ErrorAddDeleteUpdatePostState(
            errorMessage: _mapMessageToFailure(failure)),
        (_) => SuccessAddDeleteUpdatePostState(successMessage: message));
  }

  String _mapMessageToFailure(Failure failure) {
    switch (failure.runtimeType) {
      case ServerFailure:
        return SERVER_FAILURE_MESSAGE;
      case OfflineFailure:
        return OFFLINE_FAILURE_MESSAGE;
      default:
        return "Unexpected error , please try again later";
    }
  }
}
