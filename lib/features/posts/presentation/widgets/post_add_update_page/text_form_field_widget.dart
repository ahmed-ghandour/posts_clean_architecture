import 'package:flutter/material.dart';

class TextFormFieldWidget extends StatelessWidget {
  final TextEditingController controller;
  final String name;
  final bool multiline;

  const TextFormFieldWidget({Key? key, required this.controller, required this.name, required this.multiline}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
              padding: const EdgeInsets.symmetric(vertical: 10,horizontal: 20),
              child: TextFormField(
                controller: controller,
                maxLines: multiline ? 6 : 1,
                minLines :multiline ? 6 : 1,
                validator: (value) => value!.isEmpty ? "$name can not be empty" : null,
                decoration: InputDecoration(
                  hintText: name
                ),
              ),
            );
  }
}