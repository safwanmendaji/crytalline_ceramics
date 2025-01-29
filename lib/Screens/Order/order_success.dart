import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:myshop_app/Screens/HomeScreen/home_view.dart';

class OrderSuccessScreen extends StatefulWidget {
  @override
  _OrderSuccessScreenState createState() => _OrderSuccessScreenState();
}

class _OrderSuccessScreenState extends State<OrderSuccessScreen> {
  bool _showSuccessMessage = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Order Success'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Center(
              child: AnimatedSwitcher(
                duration: Duration(seconds: 1),
                child: _showSuccessMessage
                    ? Icon(
                        CupertinoIcons.check_mark_circled_solid,
                        color: Colors.green,
                        size: 100.0,
                        key: ValueKey<int>(1),
                      )
                    : Container(),
              ),
            ),
            SizedBox(height: 20),
            Center(
              child: AnimatedSwitcher(
                duration: Duration(milliseconds: 500),
                child: _showSuccessMessage
                    ? Text(
                        'Your order has been placed successfully!',
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                          color: Colors.green,
                        ),
                        key: ValueKey<int>(2),
                      )
                    : Container(),
              ),
            ),
            SizedBox(height: 40),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => HomeView()),
                );
              },
              child: Text(
                'Go to Home',
                style: TextStyle(fontSize: 18, color: Colors.brown[300]),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
