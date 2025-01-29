import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:myshop_app/APIs/api_services.dart';
import 'package:myshop_app/Screens/Login/verify_otp.dart';
import 'package:myshop_app/Models/register_model.dart';

class Registration extends StatefulWidget {
  @override
  State<Registration> createState() => _RegistrationState();
}

class _RegistrationState extends State<Registration> {
  TextEditingController fullName = TextEditingController();
  TextEditingController mobileNo = TextEditingController();
  TextEditingController email = TextEditingController();
  TextEditingController password = TextEditingController();
  TextEditingController confirmPassword = TextEditingController();
  TextEditingController aadharNo = TextEditingController();
  TextEditingController panCardNo = TextEditingController();
  TextEditingController refrenceCode = TextEditingController();

  RegisterModel? registerModel;
  final String countryCode = '+91';

  bool _isPasswordVisible = false;
  bool _isConfirmPasswordVisible = false;
  bool _isAadharVisible = false;
  bool _isPanVisible = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'REGISTRATION',
          style: TextStyle(fontSize: 20, color: Colors.brown),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(15.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Image.asset(
                "assets/Crystallinelogo.jpg",
                fit: BoxFit.contain,
                width: 100,
                height: 100, // Adjust height as needed
              ),
              SizedBox(height: 20),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Welcome to Crystalline',
                    style: TextStyle(
                      fontSize: 25,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                  SizedBox(height: 5),
                  Text(
                    'Complete the sign up to get started',
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.black,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 20),
              _buildTextField(
                fullName,
                "Enter Full Name",
                inputFormatters: [
                  FilteringTextInputFormatter.allow(RegExp(r'^[a-zA-Z\s]+$')),
                ],
              ),
              _buildTextField(
                mobileNo,
                "Enter Mobile No",
                inputType: TextInputType.phone,
                maxLength: 10, // Set max length to 10
                prefixText: '$countryCode ', // Static country code prefix
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
              ),
              _buildTextField(
                email,
                "Enter Email",
                inputType: TextInputType.emailAddress,
              ),
              _buildTextField(
                password,
                "Enter Password",
                obscureText: !_isPasswordVisible,
                onToggleVisibility: () {
                  setState(() {
                    _isPasswordVisible = !_isPasswordVisible;
                  });
                },
              ),
              _buildTextField(
                confirmPassword,
                "Enter Confirm Password",
                obscureText: !_isConfirmPasswordVisible,
                onToggleVisibility: () {
                  setState(() {
                    _isConfirmPasswordVisible = !_isConfirmPasswordVisible;
                  });
                },
              ),
              _buildTextField(
                aadharNo,
                "Enter Aadhar Card No",
                inputType: TextInputType.number,
                maxLength: 12, // Set max length to 12
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                obscureText: !_isAadharVisible,
                onToggleVisibility: () {
                  setState(() {
                    _isAadharVisible = !_isAadharVisible;
                  });
                },
              ),
              _buildTextField(
                panCardNo,
                "Enter PanCard No",
                inputType: TextInputType.text,
                maxLength: 10, // Set max length to 10
                inputFormatters: [
                  FilteringTextInputFormatter.allow(RegExp(r'^[A-Z0-9]+$')),
                ],
                obscureText: !_isPanVisible,
                onToggleVisibility: () {
                  setState(() {
                    _isPanVisible = !_isPanVisible;
                  });
                },
              ),
              _buildTextField(
                refrenceCode,
                "Enter Reference Code",
                inputType: TextInputType.text,
                inputFormatters: [
                  FilteringTextInputFormatter.allow(RegExp(r'^[a-zA-Z0-9]+$')),
                ],
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton(
                    onPressed: () {
                      _registerUser();
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor:
                          Colors.brown[200], // Background color of the button
                      shape: RoundedRectangleBorder(
                        borderRadius:
                            BorderRadius.circular(20), // Rounded corners
                      ),
                      padding: EdgeInsets.all(10), // Padding inside the button
                    ),
                    child: Text(
                      "Sign Up",
                      style: TextStyle(
                        fontSize: 20, // Increase the font size
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Padding _buildTextField(
    TextEditingController controller,
    String labelText, {
    bool obscureText = false,
    TextInputType inputType = TextInputType.text,
    int? maxLength,
    String? prefixText,
    List<TextInputFormatter>? inputFormatters,
    VoidCallback? onToggleVisibility,
  }) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: TextField(
        controller: controller,
        decoration: InputDecoration(
          contentPadding: EdgeInsets.symmetric(horizontal: 20),
          filled: true,
          fillColor: Colors.transparent,
          labelText: labelText,
          prefixText: prefixText,
          suffixIcon: obscureText
              ? IconButton(
                  icon: Icon(
                    obscureText ? Icons.visibility_off : Icons.visibility,
                  ),
                  onPressed: onToggleVisibility,
                )
              : null,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(20)),
          ),
        ),
        obscureText: obscureText,
        keyboardType: inputType,
        maxLength: maxLength,
        inputFormatters: inputFormatters,
      ),
    );
  }

  void _registerUser() {
    String mobileNumber = mobileNo.text.trim();
    if (mobileNumber.length != 10) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Mobile number must be 10 digits')),
      );
      return;
    }

    ApiServices()
        .register(
      fullName.text,
      '$countryCode$mobileNumber',
      email.text,
      confirmPassword.text,
      password.text,
      aadharNo.text,
      panCardNo.text,
    )
        .then((value) {
      setState(() {
        registerModel = value;
      });
      if (registerModel != null) {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => OTPVerificationScreen(
              // email: email.text,
              mobileNo: '$countryCode$mobileNumber',
            ),
          ),
        );
      } else {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text('Registration Failed')));
      }
    });
  }
}
