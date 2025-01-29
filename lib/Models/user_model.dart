// import 'dart:convert';

// The model class representing the entire response
class LoginResponse {
  final String message;
  final UserData data;

  LoginResponse({
    required this.message,
    required this.data,
  });

  // Factory method to create a LoginResponse from a JSON object
  factory LoginResponse.fromJson(Map<String, dynamic> json) {
    return LoginResponse(
      message: json['message'],
      data: UserData.fromJson(json['data']),
    );
  }
}

// The model class representing the 'data' field in the response
class UserData {
  final int id;
  final String fullName;
  final String mobileNo;
  final String email;
  final String password;
  final String aadharNo;
  final String panCardNo;
  final bool isVerified;
  final bool isActive;
  final String createdAt;
  final String updatedAt;

  UserData({
    required this.id,
    required this.fullName,
    required this.mobileNo,
    required this.email,
    required this.password,
    required this.aadharNo,
    required this.panCardNo,
    required this.isVerified,
    required this.isActive,
    required this.createdAt,
    required this.updatedAt,
  });

  // Method to convert UserData to a Map
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'fullName': fullName,
      'mobileNo': mobileNo,
      'email': email,
      'password': password,
      'aadharNo': aadharNo,
      'panCardNo': panCardNo,
      'is_verified': isVerified ? 1 : 0,
      'is_active': isActive ? 1 : 0,
      'created_at': createdAt,
      'updated_at': updatedAt,
    };
  }

  // Factory method to create UserData from a Map
  factory UserData.fromJson(Map<String, dynamic> json) {
    return UserData(
      id: json['id'],
      fullName: json['fullName'],
      mobileNo: json['mobileNo'],
      email: json['email'],
      password: json['password'],
      aadharNo: json['aadharNo'],
      panCardNo: json['panCardNo'],
      isVerified: json['is_verified'] == 1,
      isActive: json['is_active'] == 1,
      createdAt: json['created_at'],
      updatedAt: json['updated_at'],
    );
  }
}
