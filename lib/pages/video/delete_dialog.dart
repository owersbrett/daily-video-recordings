import 'package:flutter/material.dart';

class DeleteDialog extends StatelessWidget {
  const DeleteDialog({super.key, required this.title, required this.description, this.onDelete, this.onCancel});
  final String title;
  final String description;
  final Function()? onDelete;
  final Function()? onCancel;


  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title:  Text(
        title,
        style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
      ),
      content:  Text(description),
      actions: [
        TextButton(
            onPressed: () {
              onCancel?.call();
            },
            child: const Text(
              "Cancel",
              style: TextStyle(color: Colors.black),
            )),
        TextButton(
            onPressed: () {
              onDelete?.call();
            },
            child: const Text(
              "Delete",
              style: TextStyle(color: Colors.red),
            ))
      ],
    );
  }
}
