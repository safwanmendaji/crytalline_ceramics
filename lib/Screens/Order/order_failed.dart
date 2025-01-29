import 'package:flutter/material.dart';

class OrderFailureScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Order Failed'),
      ),
      body: Center(
        child: Text(
          'Failed to place your order. Please try again.',
          style: TextStyle(fontSize: 18, color: Colors.red),
        ),
      ),
    );
  }
}
