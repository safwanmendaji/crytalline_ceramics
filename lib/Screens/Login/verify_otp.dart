import 'dart:async';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:myshop_app/Screens/Login/login_page.dart';
import 'package:myshop_app/Helper/constants.dart';

class OTPVerificationScreen extends StatefulWidget {
  // final String email;
  final String mobileNo; // Add mobileNo parameter

  OTPVerificationScreen({required this.mobileNo}); // Update constructor

  @override
  _OTPVerificationScreenState createState() => _OTPVerificationScreenState();
}

class _OTPVerificationScreenState extends State<OTPVerificationScreen> {
  List<TextEditingController> otpControllers =
      List.generate(6, (index) => TextEditingController());
  int _seconds = 60;
  bool _isResendButtonDisabled = true;
  late Timer _timer;

  @override
  void initState() {
    super.initState();
    _startTimer();
  }

  void _startTimer() {
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      if (_seconds == 0) {
        setState(() {
          _isResendButtonDisabled = false;
        });
        _timer.cancel();
      } else {
        setState(() {
          _seconds--;
        });
      }
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    for (var controller in otpControllers) {
      controller.dispose();
    }
    super.dispose();
  }

  void _verifyOTP() async {
    String otp = otpControllers.map((controller) => controller.text).join();
    if (otp.length == 6) {
      final response = await http.post(
        Uri.parse('${ConstantHelper.uri}api/verifyOtp'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, String>{
          'mobileNo': widget.mobileNo, // Send mobile number
          'otp': otp,
        }),
      );

      if (response.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Verify Successful')),
        );
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => LoginPage()),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Invalid OTP')),
        );
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please enter a valid 6-digit OTP')),
      );
    }
  }

  void _resendOTP() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('OTP Resent')),
    );
    setState(() {
      _seconds = 60;
      _isResendButtonDisabled = true;
      _startTimer();
    });
  }

  Widget _buildOTPBox(int index) {
    return SizedBox(
      width: 40,
      child: TextField(
        controller: otpControllers[index],
        keyboardType: TextInputType.number,
        textAlign: TextAlign.center,
        maxLength: 1,
        decoration: InputDecoration(
          counterText: "",
          border: OutlineInputBorder(),
        ),
        onChanged: (value) {
          if (value.length == 1 && index != otpControllers.length - 1) {
            FocusScope.of(context).nextFocus();
          } else if (value.isEmpty && index != 0) {
            FocusScope.of(context).previousFocus();
          }
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('OTP Verification'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(15.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              CircleAvatar(
                radius: 50,
                backgroundImage: AssetImage("assets/Crystallinelogo.jpg"),
              ),
              SizedBox(height: 20),
              Text(
                'Enter the 6-digit OTP sent to your mobile number',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: List.generate(6, (index) => _buildOTPBox(index)),
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: _verifyOTP,
                child: Text('Verify OTP'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.brown[200],
                  minimumSize:
                      Size(150, 40), // Set minimum size for smaller button
                ),
              ),
              SizedBox(height: 20),
              Text(
                'Resend OTP in $_seconds seconds',
                style: TextStyle(fontSize: 14),
              ),
              SizedBox(height: 10),
              ElevatedButton(
                onPressed: _isResendButtonDisabled ? null : _resendOTP,
                child: Text('Resend OTP'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.brown[200],
                  minimumSize:
                      Size(150, 40), // Set minimum size for smaller button
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
