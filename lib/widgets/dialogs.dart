import 'package:flutter/cupertino.dart';

Future<void> showMessage(
  BuildContext context,
  String title,
  String message,
) async {
  await showCupertinoDialog<void>(
    context: context,
    builder: (dialogContext) => CupertinoAlertDialog(
      title: Text(title),
      content: Text(message),
      actions: [
        CupertinoDialogAction(
          onPressed: () => Navigator.of(dialogContext).pop(),
          child: const Text('Aceptar'),
        ),
      ],
    ),
  );
}

Widget pageTitle(String title, {String? subtitle}) => Padding(
  padding: const EdgeInsets.fromLTRB(20, 20, 20, 12),
  child: Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(
        title,
        style: const TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
      ),
      if (subtitle != null) ...[
        const SizedBox(height: 5),
        Text(
          subtitle,
          style: const TextStyle(
            fontSize: 14,
            color: CupertinoColors.secondaryLabel,
          ),
        ),
      ],
    ],
  ),
);
