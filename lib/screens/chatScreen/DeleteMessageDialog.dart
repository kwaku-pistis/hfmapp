import 'package:flutter/material.dart';

class DeleteMessageDialog extends StatefulWidget {
  final String groupId;
  final String timestamp;

  const DeleteMessageDialog(
      {Key? key, required this.groupId, required this.timestamp})
      : super(key: key);

  @override
  State<StatefulWidget> createState() => DeleteMessageDialogState();
}

class DeleteMessageDialogState extends State<DeleteMessageDialog> {
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('delete'),
      content: const Text('do you want to delete this message?'),
      actions: <Widget>[
        ElevatedButton(
          child: const Text('delete'),
          onPressed: () {
            Navigator.pop(context);
            // _deleteMessage(timestamp, groupId);
          },
        ),
        ElevatedButton(
          child: const Text('cancel'),
          onPressed: () => Navigator.pop(context),
        )
      ],
    );
  }
}
