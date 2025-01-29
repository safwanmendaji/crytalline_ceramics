import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:url_launcher/url_launcher.dart'; // Import url_launcher package
import 'package:myshop_app/APIs/api_services.dart';
import 'package:myshop_app/Helper/string_helper.dart';
import 'package:myshop_app/Screens/Login/forget_password.dart';
import 'package:myshop_app/Screens/Login/registration.dart';
import 'package:myshop_app/Screens/HomeScreen/home_view.dart';

class LoginPage extends StatelessWidget {
  final TextEditingController mobileNOController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final ApiServices apiServices = ApiServices();
  final String countryCode = '+91';
  final String adminPhoneNumber = '+919824452987'; // Admin phone number

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: false,
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          'Login Page',
          style: TextStyle(
            fontSize: 25,
            fontWeight: FontWeight.bold,
            color: Colors.brown[300],
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(height: 20),
              Image.asset(
                "assets/Crystallinelogo.jpg",
                fit: BoxFit.contain,
                height: 200,
                width: 200,
              ),
              SizedBox(height: 30),
              TextField(
                controller: mobileNOController,
                decoration: InputDecoration(
                  contentPadding: EdgeInsets.symmetric(horizontal: 20),
                  filled: true,
                  fillColor: Colors.transparent,
                  prefixText: '$countryCode ', // Static country code prefix
                  labelText: "Enter Mobile Number",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(20)),
                  ),
                ),
                keyboardType: TextInputType.phone,
                maxLength: 10,
                inputFormatters: [
                  FilteringTextInputFormatter.digitsOnly,
                ],
              ),
              SizedBox(height: 20),
              TextField(
                controller: passwordController,
                decoration: InputDecoration(
                  contentPadding: EdgeInsets.symmetric(horizontal: 20),
                  filled: true,
                  fillColor: Colors.transparent,
                  labelText: "Enter Password",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(20)),
                  ),
                ),
                obscureText: true,
              ),
              SizedBox(height: 20),
              Container(
                width: double.infinity,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    InkWell(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ForgotPasswordPage(
                              heading: "Forgot Password",
                            ),
                          ),
                        );
                      },
                      child: Text(
                        "Forgot Password?",
                        style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    InkWell(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ForgotPasswordPage(
                              heading: "Verify Registration Number",
                            ),
                          ),
                        );
                      },
                      child: Text(
                        "Verify Number?",
                        style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () async {
                  await _loginUser(context);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.brown[200],
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  padding: EdgeInsets.symmetric(horizontal: 40, vertical: 12),
                ),
                child: Text(
                  StringHelper.login,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
              ),
              SizedBox(height: 20),
              Divider(color: Colors.black),
              SizedBox(height: 20),
              ElevatedButton.icon(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => Registration()),
                  );
                },
                icon: Icon(Icons.account_circle, color: Colors.black),
                label: Text(
                  StringHelper.donthaveaccount,
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.brown[200],
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  padding: EdgeInsets.all(10.0),
                ),
              ),
              SizedBox(height: 15),
              Container(
                height: 50,
                width: 300,
                // decoration: BoxDecoration(
                //   borderRadius: BorderRadius.circular(28),
                //   color: Colors.brown[200],
                // ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.phone, color: Colors.green),
                    SizedBox(width: 10),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          StringHelper.anyIssueContactUS,
                          style: TextStyle(
                            fontSize: 15,
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        InkWell(
                          onTap: () async {
                            if (await canLaunchUrl(
                                Uri.parse('tel:$adminPhoneNumber'))) {
                              await launchUrl(
                                  Uri.parse('tel:$adminPhoneNumber'));
                            } else {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text('Cannot launch dialer')),
                              );
                            }
                          },
                          child: Text(
                            adminPhoneNumber,
                            style: TextStyle(
                              fontSize: 15,
                              color: Colors.brown,
                              fontWeight: FontWeight.bold,
                              decoration: TextDecoration.underline,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _loginUser(BuildContext context) async {
    String mobileNo = countryCode + mobileNOController.text.trim();
    String password = passwordController.text.trim();

    if (mobileNo.isEmpty || password.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please enter mobile number and password')),
      );
      return;
    }

    if (mobileNo.length != (countryCode.length + 10)) {
      // Validate the full number length
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please enter a valid 10-digit mobile number')),
      );
      return;
    }

    try {
      // Fetch the response from the API
      Map<String, dynamic> loginResult =
          await apiServices.loginUser(mobileNo, password);

      // Display the backend message
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(loginResult['message'])),
      );

      if (loginResult['success']) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => HomeView()),
        );
      }
    } catch (e) {
      print('Login failed: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Login failed. Please try again later.')),
      );
    }
  }
}
