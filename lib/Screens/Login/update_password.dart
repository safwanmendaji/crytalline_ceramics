import 'package:flutter/material.dart';
import 'package:myshop_app/APIs/api_services.dart';
import 'package:myshop_app/Screens/Login/login_page.dart'; // Import the login page

class UpdatePasswordPage extends StatefulWidget {
  final String mobileNumber;

  UpdatePasswordPage({required this.mobileNumber});

  @override
  _UpdatePasswordPageState createState() => _UpdatePasswordPageState();
}

class _UpdatePasswordPageState extends State<UpdatePasswordPage> {
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController =
      TextEditingController();
  final ApiServices apiServices = ApiServices();
  bool isLoading = false; // Added for loading indicator

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Update Password',
          style: TextStyle(
              fontSize: 25,
              fontWeight: FontWeight.bold,
              color: Colors.brown[300]),
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: passwordController,
              decoration: InputDecoration(
                labelText: 'Enter New Password',
                border:
                    OutlineInputBorder(borderRadius: BorderRadius.circular(25)),
              ),
              obscureText: true,
            ),
            SizedBox(height: 20),
            TextField(
              controller: confirmPasswordController,
              decoration: InputDecoration(
                labelText: 'Confirm New Password',
                border:
                    OutlineInputBorder(borderRadius: BorderRadius.circular(25)),
              ),
              obscureText: true,
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: isLoading
                  ? null
                  : _resetPassword, // Disable button when loading
              child: Text('Reset Password'),
            ),
            if (isLoading) // Show loading indicator if loading
              CircularProgressIndicator(),
          ],
        ),
      ),
    );
  }

  void _resetPassword() async {
    setState(() {
      isLoading = true;
    });

    String newPassword = passwordController.text;
    String confirmPassword = confirmPasswordController.text;

    if (newPassword != confirmPassword) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Passwords do not match')),
      );
      setState(() {
        isLoading = false;
      });
      return;
    }

    bool isReset = await apiServices.resetPassword(
      widget.mobileNumber,
      newPassword,
      confirmPassword,
    );

    setState(() {
      isLoading = false;
    });

    if (isReset) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Password reset successful')),
      );
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => LoginPage()),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to reset password')),
      );
    }
  }
}
