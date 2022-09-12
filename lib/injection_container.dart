import 'package:get_it/get_it.dart';
import 'package:http/http.dart' as http;
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:posts_clean_architecture/core/network/network_info.dart';
import 'package:posts_clean_architecture/features/posts/data/data_sources/post_remote_data_source.dart';
import 'package:posts_clean_architecture/features/posts/data/repositories/post_repository_impl.dart';
import 'package:posts_clean_architecture/features/posts/domain/repositories/posts_repositories.dart';
import 'package:posts_clean_architecture/features/posts/domain/use_cases/add_post.dart';
import 'package:posts_clean_architecture/features/posts/domain/use_cases/get_all_posts.dart';
import 'package:posts_clean_architecture/features/posts/presentation/bloc/add_delete_update_post/add_delete_update_post_bloc.dart';
import 'package:posts_clean_architecture/features/posts/presentation/bloc/posts/posts_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'features/posts/data/data_sources/post_local_data_source.dart';
import 'features/posts/domain/use_cases/delete_post.dart';
import 'features/posts/domain/use_cases/update_post.dart';

final sl = GetIt.instance;

Future<void> init() async {
  //! Features posts

  //Bloc
  sl.registerFactory(() => PostsBloc(getAllPosts: sl()));
  sl.registerFactory(() => AddDeleteUpdatePostBloc(
      addPost: sl(), updatePost: sl(), deletePost: sl()));

  //UseCases
  sl.registerLazySingleton(() => GetAllPostsUseCase(sl()));
  sl.registerLazySingleton(() => AddPostUseCase(sl()));
  sl.registerLazySingleton(() => UpdatePostUseCase(sl()));
  sl.registerLazySingleton(() => DeletePostUseCase(sl()));

  //Repository
  sl.registerLazySingleton<PostRepository>(() => PostsRepositoryImpl(
      networkInfo: sl(),
      remoteDataSource: sl(),
      localDataSource: sl()));
  
  
  //DataSources
  sl.registerLazySingleton<PostRemoteDataSource>(() => PostRemoteDataSourceImpl(client: sl()));
  sl.registerLazySingleton<PostLocalDataSource>(() => PostLocalDataSourceImpl(sharedPreferences: sl()));

  //!Core
  sl.registerLazySingleton<NetworkInfo>(() => NetworkInfoImpl(sl()));


  //! External
  final sharedPreferences = await SharedPreferences.getInstance();
  sl.registerLazySingleton(() => sharedPreferences );
  sl.registerLazySingleton(() => http.Client());
  sl.registerLazySingleton(() => InternetConnectionChecker());


}
