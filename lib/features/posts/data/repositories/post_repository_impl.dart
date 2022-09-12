import 'package:posts_clean_architecture/core/error/exceptions.dart';
import 'package:posts_clean_architecture/core/network/network_info.dart';
import 'package:posts_clean_architecture/features/posts/data/data_sources/post_local_data_source.dart';
import 'package:posts_clean_architecture/features/posts/data/data_sources/post_remote_data_source.dart';
import 'package:posts_clean_architecture/features/posts/data/models/post_model.dart';
import 'package:posts_clean_architecture/features/posts/domain/entities/post.dart';
import 'package:posts_clean_architecture/core/error/failures.dart';
import 'package:dartz/dartz.dart';
import 'package:posts_clean_architecture/features/posts/domain/repositories/posts_repositories.dart';

typedef DeleteOrUpdateOrAddPost = Future<Unit> Function();

class PostsRepositoryImpl implements PostRepository
{
  final PostRemoteDataSource remoteDataSource;
  final PostLocalDataSource localDataSource;
  final NetworkInfo networkInfo;
  PostsRepositoryImpl({required this.networkInfo,required this.remoteDataSource, required this.localDataSource});

  @override
  Future<Either<Failure , List<Post>>> getAllPosts() async {
  
    if(await networkInfo.isConnected)
    {
      try
      {
        final remotePosts = await remoteDataSource.getAllPosts(); 
        localDataSource.cashPosts(remotePosts);
        return Right(remotePosts);
      }
      on ServerException
      {
        return Left(ServerFailure());
      }
      }else
      {
        try
        {
          final localPosts = await localDataSource.getCashedPosts();
          return Right(localPosts);  
        }
        on EmptyCasheException
        {
          return Left(EmptyCasheFailure());
        }
      }
  }

  @override
  Future<Either<Failure, Unit>> addPost(Post post) async {
    final PostModel postModel = PostModel(
      title: post.title, 
      body: post.body
    );

    return await _getMessage((){
      return remoteDataSource.addPost(postModel);
    });
  }

  @override
  Future<Either<Failure , Unit>> deletePost(int postId) async {
    return await _getMessage((){
      return remoteDataSource.deletePost(postId);
    });
  }

  @override
  Future<Either<Failure, Unit>> updatePost(Post post) async {
   final PostModel postModel = PostModel(
      id: post.id,
      title: post.title, 
      body: post.body
    );

    return await _getMessage((){
      return remoteDataSource.updatePost(postModel);
    });
  }

  Future<Either<Failure, Unit>> _getMessage (DeleteOrUpdateOrAddPost deleteOrUpdateOrAddPost ) async
  {
    if(await networkInfo.isConnected)
    {
      try
      {
        deleteOrUpdateOrAddPost;
        return const Right(unit);
      }on ServerException
      {
        return Left(ServerFailure());
      }

    }else{
      return Left(OfflineFailure());
    }
  }
  
}