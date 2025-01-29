import 'package:flutter/material.dart';
import 'package:myshop_app/APIs/api_services.dart';
import 'package:myshop_app/Helper/string_helper.dart';
import 'package:myshop_app/Screens/Login/login_page.dart';
import 'package:myshop_app/Helper/constants.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class ProfileScreen extends StatefulWidget {
  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen>
    with TickerProviderStateMixin {
  final _formKeyGeneral = GlobalKey<FormState>();

  final TextEditingController fullNameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController aadharNoController = TextEditingController();
  final TextEditingController panCardNoController = TextEditingController();
  final TextEditingController mobileNoController = TextEditingController();
  final TextEditingController refferenceCodeController =
      TextEditingController();

  String _apiMessage = "";
  int? userId;

  late AnimationController _animationController;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _loadUserId(); // Load user ID from local storage

    // Initialize animation controller
    _animationController = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    );

    _animation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.easeIn,
      ),
    );
  }

  Future<void> _loadUserId() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? userIdStr = prefs.getString('userid');
    if (userIdStr != null) {
      setState(() {
        userId = int.parse(userIdStr);
        _fetchUserData();
      });
    } else {
      setState(() {
        _apiMessage = "";
      });
    }
  }

  Future<void> _fetchUserData() async {
    if (userId != null) {
      final response = await http.get(
        Uri.parse('${ConstantHelper.uri}api/getUser/$userId'),
      );

      // print('Fetching user data for ID: $userId');

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        // print('API Response: $data'); // Debug print

        if (data['message'] == "User details retrieved successfully.") {
          final userData = data['data'];
          setState(() {
            fullNameController.text = userData['fullName'] ?? '';
            emailController.text = userData['email'] ?? '';
            aadharNoController.text = userData['aadharNo'] ?? '';
            panCardNoController.text = userData['panCardNo'] ?? '';
            mobileNoController.text = userData['mobileNo'] ?? '';
            refferenceCodeController.text = userData['refferenceCode'] ?? 'N/A';
          });
        } else {
          setState(() {
            _apiMessage = data['message'] ?? 'Failed to retrieve user data.';
          });
        }
      } else if (response.statusCode == 401) {
        setState(() {
          _apiMessage = "Unauthorized access. Please login again.";
        });
        _logout();
      } else {
        setState(() {
          _apiMessage = "Failed to fetch user data: ${response.reasonPhrase}";
        });
      }
    } else {
      setState(() {
        _apiMessage = "";
      });
    }
  }

  Future<void> _updateProfile() async {
    if (_formKeyGeneral.currentState?.validate() ?? false) {
      if (userId == null) {
        setState(() {
          _apiMessage = "User ID not found.";
        });
        return;
      }

      try {
        final response = await ApiServices.updateUserData(
          userId!,
          fullNameController.text,
          emailController.text,
          aadharNoController.text,
          panCardNoController.text,
        );

        print('Updating user data for ID: $userId'); // Debug print

        if (response != null &&
            response is Map<String, dynamic> &&
            response.containsKey('message')) {
          if (response['message'] == "User updated successfully.") {
            setState(() {
              _apiMessage = "Profile updated successfully!";
            });

            _animationController.forward().then((_) {
              Navigator.pop(context);
            });
          } else {
            setState(() {
              _apiMessage = response['message'] ?? 'Failed to update profile.';
            });
          }
        } else {
          setState(() {
            _apiMessage = 'Unexpected response format.';
          });
        }
      } catch (e) {
        print('Error updating profile: $e'); // Debug print
        setState(() {
          _apiMessage = 'An error occurred while updating the profile.';
        });
      }
    }
  }

  Future<void> _logout() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.clear();

    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => LoginPage()),
      (route) => false,
    );
  }

  @override
  void dispose() {
    fullNameController.dispose();
    emailController.dispose();
    aadharNoController.dispose();
    panCardNoController.dispose();
    mobileNoController.dispose();
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          StringHelper.profile,
          style: TextStyle(
            fontSize: 25,
            fontWeight: FontWeight.bold,
            color: Colors.brown[500],
          ),
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SizedBox(height: 20),
                    Image.asset(
                      'assets/CrystallineFinalLogo.png',
                      height: 150,
                      width: 150,
                    ),
                    SizedBox(height: 20),
                    Form(
                      key: _formKeyGeneral,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _buildTextField('Full Name', fullNameController),
                          _buildTextField('Email', emailController,
                              keyboardType: TextInputType.emailAddress),
                          _buildTextField('Aadhar No', aadharNoController,
                              maxLength: 12,
                              keyboardType: TextInputType.number),
                          _buildTextField('Pan Card No', panCardNoController,
                              maxLength: 10, keyboardType: TextInputType.text),
                          _buildTextField('Mobile No', mobileNoController,
                              keyboardType: TextInputType.phone,
                              enabled: false),
                          _buildTextField(
                              'Refference Code', refferenceCodeController,
                              maxLength: 10, keyboardType: TextInputType.text)
                        ],
                      ),
                    ),
                    SizedBox(height: 20),
                    Text(
                      _apiMessage,
                      style: TextStyle(color: Colors.green, fontSize: 18),
                    ),
                  ],
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: ElevatedButton(
              onPressed: _logout,
              child: Text(
                StringHelper.logout,
                style: TextStyle(color: Colors.black),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.brown[200],
                padding: EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                textStyle: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTextField(String label, TextEditingController controller,
      {TextInputType keyboardType = TextInputType.text,
      bool obscureText = false,
      int? maxLength,
      bool enabled = true}) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10.0),
      child: TextFormField(
        controller: controller,
        keyboardType: keyboardType,
        obscureText: obscureText,
        maxLength: maxLength,
        enabled: false,
        decoration: InputDecoration(
          labelText: label,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(30)),
          counterText: "",
        ),
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'Please enter $label';
          }
          if (maxLength != null && value.length != maxLength) {
            return 'Please enter a valid ${maxLength}-digit ${label}';
          }
          return null;
        },
      ),
    );
  }
}
