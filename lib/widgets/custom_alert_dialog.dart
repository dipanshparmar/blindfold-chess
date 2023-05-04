import 'package:flutter/material.dart';

class CustomAlertDialog extends StatelessWidget {
  const CustomAlertDialog({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      title: Text(
        'Are you sure you want to exit?',
        style: Theme.of(context).textTheme.bodyMedium,
      ),
      actions: [
        GestureDetector(
          onTap: () {
            Navigator.of(context).pop(false);
          },
          child: Container(
            padding: const EdgeInsets.symmetric(
              horizontal: 15,
              vertical: 7.5,
            ),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.secondary,
              borderRadius: BorderRadius.circular(5),
            ),
            child: Text(
              'NO',
              style: Theme.of(context).textTheme.bodySmall,
            ),
          ),
        ),
        GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTap: () {
            Navigator.of(context).pop(true);
          },
          child: Container(
            padding: const EdgeInsets.symmetric(
              horizontal: 15,
              vertical: 7.5,
            ),
            child: Text('YES'),
          ),
        ),
      ],
    );
  }
}
