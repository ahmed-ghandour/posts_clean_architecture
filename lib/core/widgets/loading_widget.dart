import 'package:flutter/material.dart';
import 'package:posts_clean_architecture/core/app_theme.dart';

class LoadingWidget extends StatelessWidget {
  const LoadingWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.symmetric(vertical: 20),
      child: Center(
          child: SizedBox(
              width: 30,
              height: 30,
              child: CircularProgressIndicator(
                color: secondaryColor,
              ))),
    );
  }
}
