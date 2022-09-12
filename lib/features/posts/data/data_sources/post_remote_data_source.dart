import 'dart:convert';
import 'package:dartz/dartz.dart';
import 'package:posts_clean_architecture/core/error/exceptions.dart';
import 'package:posts_clean_architecture/features/posts/data/models/post_model.dart';
import '../../domain/entities/post.dart';
import 'package:http/http.dart' as http;

abstract class PostRemoteDataSource {
  Future<List<PostModel>> getAllPosts();
  Future<Unit> addPost(Post post);
  Future<Unit> updatePost(Post post);
  Future<Unit> deletePost(int postId);
}

// ignore: constant_identifier_names
const BASE_URL = "https://jsonplaceholder.typicode.com";

class PostRemoteDataSourceImpl implements PostRemoteDataSource {
  final http.Client client;

  PostRemoteDataSourceImpl({required this.client});

  @override
  Future<List<PostModel>> getAllPosts() async {
    final response = await client.get(
      Uri.parse("$BASE_URL/posts/"),
      headers: {"Content-Type": "application/json"},
    );

    if (response.statusCode == 200) {
      final List decodedJson = json.decode(response.body);
      final List<PostModel> postModels = decodedJson
          .map<PostModel>((element) => PostModel.fromJson(element))
          .toList();
      return postModels;    
    }else
    {
      throw ServerException();
    }
  }

  @override
  Future<Unit> addPost(Post post) async {
    final body = {
      "title":post.title,
      "body" : post.body
    };
    final response = await client.post(Uri.parse("$BASE_URL/posts/"), body: body);
    if(response.statusCode == 201)
    {
      return Future.value(unit);
    }else
    {
      throw ServerException();
    }
  }

  @override
  Future<Unit> deletePost(int postId) async {
    final response = await client.delete(
      Uri.parse('$BASE_URL/posts/${postId.toString()}'),
      headers:{"Content-Type": "application/json"});
    if(response.statusCode == 200)
    {
      return Future.value(unit);
    }else
    {
      throw ServerException();
    }
  }

  @override
  Future<Unit> updatePost(Post post) async {
    final postId = post.id.toString();
    final body = {
      "title" : post.title,
      "body" :post.body
    };
    final reponse = await client.patch(
      Uri.parse("$BASE_URL/posts/$postId"),
      body: body
      );
    if(reponse.statusCode == 200)
    {
      return Future.value(unit);
    }else
    {
      throw ServerException();
    }
  }
}
