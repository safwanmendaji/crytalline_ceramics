import 'package:flutter/material.dart';

class BackButtonWidget extends StatelessWidget {
  final VoidCallback? onPressed;

  BackButtonWidget({this.onPressed});

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.topLeft,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: onPressed ?? () => Navigator.of(context).pop(),
          ),
          Text(
            'Back',
            style: TextStyle(fontSize: 18),
          ),
        ],
      ),
    );
  }
}
