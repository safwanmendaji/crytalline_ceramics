import 'package:flutter/material.dart';
import 'package:myshop_app/Screens/BrandScreen/fliter_screen.dart';

class FilterButtonBrandScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Positioned(
      right: 15,
      bottom: 20,
      child: ElevatedButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => FilterScreen()),
          );
        },
        child: Text('Filter'),
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.white,
          foregroundColor: Colors.brown,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12.0),
          ),
        ),
      ),
    );
  }
}
