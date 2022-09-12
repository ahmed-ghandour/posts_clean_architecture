import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:posts_clean_architecture/core/util/snackbar_message.dart';
import 'package:posts_clean_architecture/core/widgets/loading_widget.dart';
import 'package:posts_clean_architecture/features/posts/presentation/bloc/add_delete_update_post/add_delete_update_post_bloc.dart';
import 'package:posts_clean_architecture/features/posts/presentation/pages/posts_page.dart';
import 'package:posts_clean_architecture/features/posts/presentation/widgets/post_add_update_page/form_widget.dart';

import '../../domain/entities/post.dart';

class PostAddUpdatePage extends StatelessWidget {
  final Post? post;
  final bool isUpdate;
  const PostAddUpdatePage({Key? key, this.post, required this.isUpdate}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(),
      body: _buildBody(),
      );
    
  }

  AppBar _buildAppBar() => AppBar(title: Text(isUpdate? "Update Post" : "Add Post"));
  Widget _buildBody (){
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: BlocConsumer<AddDeleteUpdatePostBloc,AddDeleteUpdatePostState>(
          listener: (context,state)
          {
            if(state is SuccessAddDeleteUpdatePostState){
              SnackBarMessage().showSuccessSnackBar(message: state.successMessage, context: context);
              Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(
                builder:(_)=> const Postspage() ), (route) => false);
            }else if(state is ErrorAddDeleteUpdatePostState){
              SnackBarMessage().showErrorSnackBar(message: state.errorMessage, context: context);
            }
          },
          builder: (context,state)
          {
            if(state is LoadingAddDeleteUpdatePostState)
            {
              return const LoadingWidget();
            } 
            return FormWidget(isUpdatePost: isUpdate, post: post);
          }
          
          ),
        ),
    );
  }
}