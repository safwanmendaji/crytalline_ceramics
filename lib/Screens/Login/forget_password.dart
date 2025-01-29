import 'package:flutter/material.dart';
import 'package:myshop_app/APIs/api_services.dart';
import 'package:myshop_app/Screens/Login/update_password.dart'; // Import the update password page

class ForgotPasswordPage extends StatefulWidget {
  final String heading;
  ForgotPasswordPage({required this.heading});
  @override
  _ForgotPasswordPageState createState() => _ForgotPasswordPageState();
}

class _ForgotPasswordPageState extends State<ForgotPasswordPage> {
  final TextEditingController mobileController = TextEditingController();
  final TextEditingController otpController = TextEditingController();
  final ApiServices apiServices = ApiServices();

  bool isOtpSent = false;
  bool isOtpVerified = false;
  bool isLoading = false; // Added for loading indicator

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.heading,
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
            if (!isOtpSent) ...[
              Text(
                "Enter your Registered Mobile Number",
                style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.normal,
                    color: Colors.brown),
              ),
              SizedBox(
                height: 15,
              ),
              TextField(
                controller: mobileController,

                decoration: InputDecoration(
                  labelText: 'Enter Mobile Number',
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(20))),
                ),
                keyboardType: TextInputType.phone,
                // Adding initial value with +91 if not already present
                onChanged: (value) {
                  if (!value.startsWith('+91')) {
                    mobileController.text = '+91$value';
                    mobileController.selection = TextSelection.fromPosition(
                      TextPosition(offset: mobileController.text.length),
                    );
                  }
                },
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: isLoading ? null : _sendOtp,
                child: Text('Send OTP'),
              ),
            ] else if (!isOtpVerified) ...[
              TextField(
                controller: otpController,
                decoration: InputDecoration(
                  labelText: 'Enter OTP',
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(20))),
                ),
                keyboardType: TextInputType.number,
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: isLoading ? null : _verifyOtp,
                child: Text('Verify OTP'),
              ),
            ],
            if (isLoading) CircularProgressIndicator(),
          ],
        ),
      ),
    );
  }

  void _sendOtp() async {
    setState(() {
      isLoading = true;
    });

    String mobileNumber = mobileController.text;

    // Ensure the mobile number starts with +91
    if (!mobileNumber.startsWith('+91')) {
      mobileNumber = '+91$mobileNumber';
    }

    bool isSent = await apiServices.sendOtp(mobileNumber);

    setState(() {
      isLoading = false;
    });

    if (isSent) {
      setState(() {
        isOtpSent = true;
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to send OTP')),
      );
    }
  }

  void _verifyOtp() async {
    setState(() {
      isLoading = true;
    });

    String mobileNumber = mobileController.text;

    // Ensure the mobile number starts with +91
    if (!mobileNumber.startsWith('+91')) {
      mobileNumber = '+91$mobileNumber';
    }

    String otp = otpController.text; // Keep OTP as a string

    bool isVerified = await apiServices.verifyOtp(mobileNumber, otp);

    setState(() {
      isLoading = false;
    });

    if (isVerified) {
      setState(() {
        isOtpVerified = true;
      });

      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => UpdatePasswordPage(mobileNumber: mobileNumber),
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Invalid OTP'),
      ));
    }
  }
}
