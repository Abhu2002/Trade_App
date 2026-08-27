import 'package:flutter/material.dart';

class NameDialog extends StatelessWidget {
  const NameDialog({
    super.key,
    required this.title,
    this.initial,
    this.controller,
  });

  final String title;
  final String? initial;
  final TextEditingController? controller;

  @override
  Widget build(BuildContext context) {
    final textController = controller ?? TextEditingController(text: initial);
    return AlertDialog(
      title: Text(title),
      content: TextField(
        controller: textController,
        autofocus: true,
        decoration: const InputDecoration(labelText: 'Name'),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancel'),
        ),
        FilledButton(
          onPressed: () => Navigator.pop(context, textController.text),
          child: const Text('Save'),
        ),
      ],
    );
  }
}
