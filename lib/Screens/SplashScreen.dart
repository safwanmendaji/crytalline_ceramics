import 'package:flutter/material.dart';
import 'package:myshop_app/Screens/Login/login_page.dart';
import 'package:myshop_app/Screens/HomeScreen/home_view.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _checkLoginStatus();
  }

  Future<void> _checkLoginStatus() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? user = prefs.getString('user'); // Retrieve user data
    int? loginTimestamp =
        prefs.getInt('loginTimestamp'); // Retrieve login timestamp

    // Simulate a delay for splash screen display
    await Future.delayed(Duration(seconds: 2), () {
      if (user != null && loginTimestamp != null) {
        DateTime loginDateTime =
            DateTime.fromMillisecondsSinceEpoch(loginTimestamp);
        DateTime currentDateTime = DateTime.now();

        // Check if the login timestamp is within the last 15 days (15 days * 24 hours * 60 minutes * 60 seconds * 1000 milliseconds)
        if (currentDateTime.difference(loginDateTime).inDays <= 15) {
          // If user is found and session is valid, navigate to HomeView
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => HomeView()),
          );
        } else {
          // If session is expired, clear the data and navigate to LoginPage
          prefs.remove('user');
          prefs.remove('loginTimestamp');
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => LoginPage()),
          );
        }
      } else {
        // If no user is found, navigate to LoginPage
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => LoginPage()),
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              'assets/Crystallinelogo.jpg',
              height: 100,
              width: 100,
            ),
            SizedBox(height: 20),
            // Optionally add a CircularProgressIndicator here
          ],
        ),
      ),
    );
  }
}
