import 'package:flutter/material.dart';

class ReceiptViewScreen extends StatelessWidget {
  final String receiptUrl;

  const ReceiptViewScreen({Key? key, required this.receiptUrl})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Receipt'),
      ),
      body: Center(
        child: receiptUrl.isNotEmpty
            ? Image.network(receiptUrl)
            : Text('No receipt available'),
      ),
    );
  }
}
