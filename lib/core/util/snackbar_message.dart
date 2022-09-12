import 'package:flutter/material.dart';

class SnackBarMessage{
  void showSuccessSnackBar({required String message ,required BuildContext context}){
    ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                backgroundColor: Colors.green,
                content: Text(
                  message,
                  style: const TextStyle(
                    color: Colors.white ),
              ))
            );
  }

  void showErrorSnackBar({required String message ,required BuildContext context}){
    ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                backgroundColor: Colors.red,
                content: Text(
                  message,
                  style: const TextStyle(
                    color: Colors.white ),
              ))
            );
  }

}

