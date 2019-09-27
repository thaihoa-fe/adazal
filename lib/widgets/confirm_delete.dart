import 'package:flutter/material.dart';

class ConfirmDismiss extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      content: Text('Do you want to remove this item?'),
      actions: <Widget>[
        FlatButton(
          child: Text(
            'Yes',
            style: TextStyle(
              color: Colors.blue,
            ),
          ),
          onPressed: () {
            Navigator.of(context).pop(true);
          },
        ),
        FlatButton(
          child: Text(
            'No',
            style: TextStyle(
              color: Colors.blue,
            ),
          ),
          onPressed: () {
            Navigator.of(context).pop(false);
          },
        )
      ],
    );
  }
}
