import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../../core/util/snackbar_message.dart';
import '../../../../../core/widgets/loading_widget.dart';
import '../../bloc/add_delete_update_post/add_delete_update_post_bloc.dart';
import '../../pages/posts_page.dart';
import 'delete_dialog_widget.dart';

class DeletePostBtnWidget extends StatelessWidget {
  final int postId;
  const DeletePostBtnWidget({Key? key, required this.postId}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton.icon(
        style:
            ButtonStyle(backgroundColor: MaterialStateProperty.all(Colors.red)),
        onPressed: () => deleteDialog(context,postId),
        label: const Text("Delete"),
        icon: const Icon(Icons.delete));
  }

  void deleteDialog(BuildContext context, int postId){
showDialog(
  context: context,
  builder:(context){
    return BlocConsumer<AddDeleteUpdatePostBloc,AddDeleteUpdatePostState>(
      listener: (context,state){
        if(state is SuccessAddDeleteUpdatePostState){
          SnackBarMessage().showSuccessSnackBar(message: state.successMessage,context: context);
          Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (_)=>const Postspage()), (route) => false);
        }else if(state is ErrorAddDeleteUpdatePostState){
          SnackBarMessage().showErrorSnackBar(message: state.errorMessage, context: context);
        }
      },
      builder: (context,state){
        if(state is LoadingAddDeleteUpdatePostState){
          return const AlertDialog(title: LoadingWidget());
        }
        return DeleteDialogWidget(postId: postId);
      },
    );
  } 
);
}

}
