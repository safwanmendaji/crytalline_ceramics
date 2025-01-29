import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

class NetworkConnection extends StatelessWidget {
  const NetworkConnection({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.wifi_off_rounded,
            size: 200,
            color: Colors.redAccent,
          ),
          const SizedBox(height: 20),
          const Text(
            "No Internet Connection",
            style: TextStyle(fontSize: 15, color: Colors.black),
          ),
          ElevatedButton(
              onPressed: () {},
              child: Text(
                "Try again",
                style: TextStyle(fontSize: 20),
              ))
        ],
      ),
    );
  }
}
