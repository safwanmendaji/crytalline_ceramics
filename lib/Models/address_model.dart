// Address model class
class Address {
  final int id;
  final int userId;
  final String address;
  final String addressType;
  final int isDefault;
  final DateTime createdAt;
  final DateTime updatedAt;

  Address({
    required this.id,
    required this.userId,
    required this.address,
    required this.addressType,
    required this.isDefault,
    required this.createdAt,
    required this.updatedAt,
  });

  // Factory method to create an Address instance from JSON
  factory Address.fromJson(Map<String, dynamic> json) {
    return Address(
      id: json['id'],
      userId: json['user_id'],
      address: json['address'],
      addressType: json['address_type'],
      isDefault: json['is_default'],
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: DateTime.parse(json['updated_at']),
    );
  }

  // Method to convert Address instance to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user_id': userId,
      'address': address,
      'address_type': addressType,
      'is_default': isDefault,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }
}

// Response model class
// Define the AddressResponse class
class AddressResponse {
  final String message;
  final List<Address> data;

  AddressResponse({
    required this.message,
    required this.data,
  });

  // Convert a JSON map to an AddressResponse object
  factory AddressResponse.fromJson(Map<String, dynamic> json) {
    return AddressResponse(
      message: json['message'],
      data:
          (json['data'] as List).map((item) => Address.fromJson(item)).toList(),
    );
  }

  // Convert an AddressResponse object to a JSON map
  Map<String, dynamic> toJson() {
    return {
      'message': message,
      'data': data.map((address) => address.toJson()).toList(),
    };
  }
}

class AddAddressModel {
  final String? id;
  final String userId;
  final String fullname;
  final String address;
  // final String? city; // Made nullable
  // final String? state; // Made nullable
  // final String? pincode; // Made nullable
  final String mobileNumber;
  final String addressType;
  final String? userLocation; // New field for location
  final bool isDefault;

  AddAddressModel({
    this.id,
    required this.userId,
    required this.fullname,
    required this.address,
    // this.city, // Made nullable
    // this.state, // Made nullable
    // this.pincode, // Made nullable
    required this.mobileNumber,
    required this.addressType,
    required this.isDefault,
    this.userLocation, // Nullable location
  });

  factory AddAddressModel.fromJson(Map<String, dynamic> json) {
    return AddAddressModel(
      id: json['id'],
      userId: json['userId'],
      fullname: json['fullname'],
      address: json['address'],
      // city: json['city'], // Nullable handling
      // state: json['state'], // Nullable handling
      // pincode: json['pincode'], // Nullable handling
      mobileNumber: json['mobileNumber'],
      addressType: json['addressType'],
      isDefault: json['isDefault'],
      userLocation: json['user_location'], // Nullable handling
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user_id': userId,
      'fullname': fullname,
      'address': address,
      // 'city': city, // Nullable handling
      // 'state': state, // Nullable handling
      // 'pincode': pincode, // Nullable handling
      'mobile_number': mobileNumber,
      'address_type': addressType,
      'is_default': isDefault ? 1 : 0,
      'user_location': userLocation, // Nullable handling
    };
  }
}
