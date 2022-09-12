import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:posts_clean_architecture/core/widgets/loading_widget.dart';
import 'package:posts_clean_architecture/features/posts/presentation/bloc/posts/posts_bloc.dart';
import 'package:posts_clean_architecture/features/posts/presentation/pages/post_add_update_page.dart';
import '../widgets/post_page/message_display_widget.dart';
import '../widgets/post_page/post_list_widget.dart';

class Postspage extends StatelessWidget {
  const Postspage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(),
      body: _buildBody(),
      floatingActionButton: _buildFloatingBtn(context),
    );
    
  }

  AppBar _buildAppBar() {
    return AppBar(
          title: const Text("Posts"));
  }

  Widget _buildBody(){
    return Padding(
      padding: const EdgeInsets.all(10),
      child: BlocBuilder<PostsBloc,PostsState>(
        builder: (context, state) {
          if (state is LoadingPostsState){
            return const LoadingWidget();
          }else if (state is SuccessPostsState){
            return RefreshIndicator(
              onRefresh:() => _onRefresh(context) ,
              child: PostListWidget(posts : state.posts));
          }else if(state is ErrorPostsState){
            return MessageDisplayWidget(message : state.errorMessage);
          }
          return const LoadingWidget();
      }
    ));
  }

  Widget _buildFloatingBtn(BuildContext context){
    return FloatingActionButton(
      onPressed: (){
        Navigator.push(context, MaterialPageRoute(builder: (_)=> const PostAddUpdatePage(isUpdate: false)));
      },
      child: const Icon(Icons.add));
  }

   Future<void> _onRefresh(BuildContext context) async{
    BlocProvider.of<PostsBloc>(context).add(RefreshPostsEvent());
   }
}