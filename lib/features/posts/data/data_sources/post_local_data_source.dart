// ignore_for_file: constant_identifier_names

import 'dart:convert';
import 'package:dartz/dartz.dart';
import 'package:posts_clean_architecture/core/error/exceptions.dart';
import 'package:posts_clean_architecture/features/posts/data/models/post_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

abstract class PostLocalDataSource {
  Future<List<PostModel>> getCashedPosts();
  Future<Unit> cashPosts(List<PostModel> posts);
}

const CASHED_POSTS = "CASHED_POSTS";

class PostLocalDataSourceImpl implements PostLocalDataSource {
  final SharedPreferences sharedPreferences;

  PostLocalDataSourceImpl({required this.sharedPreferences});
  @override
  Future<Unit> cashPosts(List<PostModel> postModels) {
    List postModelsToJson = postModels
        .map<Map<String, dynamic>>((element) => element.toJson())
        .toList();
    sharedPreferences.setString(CASHED_POSTS, json.encode(postModelsToJson));
    return Future.value(unit);
  }

  @override
  Future<List<PostModel>> getCashedPosts() {
    final jsonDataPosts = sharedPreferences.getString(CASHED_POSTS);
    if (jsonDataPosts != null) {
      List decodedJsonDataPosts = json.decode(jsonDataPosts);
      List<PostModel> decodedJsonPostModels = decodedJsonDataPosts
          .map<PostModel>((jsonPostModel) => PostModel.fromJson(jsonPostModel))
          .toList();
      return Future.value(decodedJsonPostModels);    
    }else
    {
      throw EmptyCasheException();
    }
  }
}
