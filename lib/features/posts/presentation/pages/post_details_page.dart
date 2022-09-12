import 'package:flutter/material.dart';
import 'package:posts_clean_architecture/features/posts/presentation/widgets/post_details_page/post_details_widget.dart';

import '../../domain/entities/post.dart';

class PostDetail extends StatelessWidget {
  final Post post;
  const PostDetail({Key? key, required this.post}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(),
      body: _buildBody(),
    );
  }

  AppBar _buildAppBar() => AppBar(title: const Text("Post Details"));

  Widget _buildBody() {
    return Center(
    child: Padding(
      padding: const EdgeInsets.all(8.0),
      child: PostDetailWidget(post: post),
    ),
    );
  }
}