import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:myshop_app/APIs/exception_handlers.dart';
import 'package:myshop_app/Models/achivement_model.dart';
import 'package:myshop_app/Models/address_model.dart';
import 'package:myshop_app/Helper/constants.dart';
import 'package:myshop_app/Models/order_model.dart';
import 'package:myshop_app/Models/register_model.dart';
import 'package:myshop_app/Models/user_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ApiServices {
  Future<RegisterModel?> register(
    String fullname,
    String mobileno,
    String email,
    String confirmpassword,
    String password,
    String aadharno,
    String pancardno,
  ) async {
    try {
      var url = Uri.parse('${ConstantHelper.uri}api/userRegister');

      var response = await http.post(url,
          headers: {
            'Content-Type': 'application/json',
          },
          body: jsonEncode({
            "fullName": fullname,
            "mobileNo": mobileno,
            "email": email,
            "confirmPassword": confirmpassword,
            "password": password,
            "aadharNo": aadharno,
            "panCardNo": pancardno
          }));

      if (response.statusCode == 200) {
        return RegisterModel.fromJson(jsonDecode(response.body));
      } else {
        print('Failed to register user: ${response.statusCode}');
        return null;
      }
    } catch (e) {
      print('Error occurred: $e');
      return null;
    }
  }

  //Login Api
  Future<Map<String, dynamic>> loginUser(
      String mobileNo, String password) async {
    try {
      var url = Uri.parse('${ConstantHelper.uri}api/login');
      var response = await http.post(
        url,
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, String>{
          'mobileNo': mobileNo,
          'password': password,
        }),
      );

      if (response.statusCode == 200) {
        var jsonResponse = jsonDecode(response.body);
        LoginResponse loginResponse = LoginResponse.fromJson(jsonResponse);
        UserData userData = loginResponse.data;

        SharedPreferences prefs = await SharedPreferences.getInstance();
        await prefs.setString('user', jsonEncode(userData.toJson()));
        await prefs.setString("userid", userData.id.toString());
        await prefs.setInt(
            'loginTimestamp', DateTime.now().millisecondsSinceEpoch);

        return {
          'success': true,
          'message': jsonResponse['message'] ?? 'Login successful'
        };
      } else {
        var jsonResponse = jsonDecode(response.body);
        return {
          'success': false,
          'message': jsonResponse['message'] ?? 'An error occurred'
        };
      }
    } catch (e) {
      print('Error occurred: $e');
      return {
        'success': false,
        'message': 'An error occurred. Please try again later.'
      };
    }
  }

// Send OTP API
  Future<bool> sendOtp(String mobileNo) async {
    try {
      var url = Uri.parse('${ConstantHelper.uri}api/forgotPassword');

      var response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({"mobileNo": mobileNo}),
      );

      if (response.statusCode == 200) {
        return true; // OTP sent successfully
      } else {
        print('Failed to send OTP: ${response.statusCode}');
        return false; // Failed to send OTP
      }
    } catch (e) {
      print('Error occurred: $e');
      return false; // Error occurred during sending OTP
    }
  }

  // Reset Password API
  Future<bool> resetPassword(
      String mobileNo, String password, String confirmPassword) async {
    try {
      var url = Uri.parse('${ConstantHelper.uri}api/updatePassword');

      var response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          "mobileNo": mobileNo,
          "password": password,
          "confirmPassword": confirmPassword
        }),
      );

      if (response.statusCode == 200) {
        return true; // Password reset successful
      } else {
        print('Failed to reset password: ${response.statusCode}');
        return false; // Failed to reset password
      }
    } catch (e) {
      print('Error occurred: $e');
      return false; // Error occurred during password reset
    }
  }

  // verifyOtp(String mobileNumber, String otp) {}

  Future<bool> verifyOtp(String mobileNumber, String otp) async {
    final String apiUrl = '${ConstantHelper.uri}api/verifyOtp';

    final response = await http.post(
      Uri.parse(apiUrl),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, dynamic>{
        // Change String to dynamic for integer OTP
        'mobileNo': mobileNumber,
        'otp': otp,
      }),
    );

    if (response.statusCode == 200) {
      return true; // OTP verified successfully
    } else {
      return false; // OTP verification failed
    }
  }

  // BANNER LIST API
  final String baseUrl = "${ConstantHelper.uri}api/bannerList";

  Future<List<String>> fetchBanners() async {
    final Map<String, String> headers = {
      'Content-Type': 'application/json',
    };

    try {
      final response = await http.get(
        Uri.parse(baseUrl),
        headers: headers,
      );

      if (response.statusCode == 200) {
        List<dynamic> data = json.decode(response.body);
        List<String> images = data
            .map((item) => '${ConstantHelper.imguri}/${item['image']}')
            .toList();
        return images;
      } else {
        throw Exception('Failed to load banners: ${response.statusCode}');
      }
    } catch (e) {
      print('Error fetching banners: ${e}');
      throw ExceptionHandlers().getExceptionString(e);
    }
  }

//BRAND API
  // static const String brandUrl = "${ConstantHelper.uri}api/";

  static Future<List<Map<String, dynamic>>> fetchBrandList() async {
    final response =
        await http.get(Uri.parse("${ConstantHelper.uri}api/brandList"));
    // print(response);

    if (response.statusCode == 200) {
      List<dynamic> data = await json.decode(response.body)['data'];
      List<Map<String, dynamic>> brand = data.map((item) {
        // print("${ConstantHelper.uri}/${item['id']}");
        // flutter run -d chrome --web-renderer html
        return {
          "name": item['brand_name'],
          "image":
              "https://crystallineceramic.in/public/${item['brand_image']}",
          "id": item['id'].toString()
        };
      }).toList();
      return brand;
    } else {
      throw Exception('Failed to load brands: ${response.statusCode}');
    }
  }

//AADD TO CART API
  addToCart(
      int userId, int productId, int productVariantId, int quantity) async {
    final url = Uri.parse('${ConstantHelper.uri}api/cartRegister');
    // print(url);
    final data = {
      "user_id": userId,
      "product_id": productId,
      "product_variant_id": productVariantId,
      "quantity": quantity
    };
    final jsonEncodedData = jsonEncode(data);
    print(jsonEncodedData);
    final response = await http.post(
      url,
      headers: {
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncodedData,
      // body: jsonEncode({
      //   'user_id': userId,
      //   'product_id': productId,
      //   'product_variant_id': productVariantId,
      //   'quantity': quantity,
      // }),
    );
    print(await response);
    return response.statusCode == 200;
  }

// DELETE ITEM API
  Future<void> deleteItem(int id) async {
    final response =
        await http.get(Uri.parse('${ConstantHelper.uri}api/deleteCrad/$id'));

    if (response.statusCode == 200) {
      // Item deleted successfully
      print('Item deleted successfully');
    } else {
      // Error deleting item
      throw Exception('Failed to delete item');
    }
  }

  //Address api
  Future<AddressResponse> fetchAddress(int userId) async {
    // print('New api call ${userId}');
    final response = await http
        .get(Uri.parse('${ConstantHelper.uri}api/getAddress/$userId'));
    // print('New api call Response ${response.statusCode}');

    if (response.statusCode == 200) {
      final Map<String, dynamic> jsonResponse = json.decode(response.body);
      return AddressResponse.fromJson(jsonResponse);
      //print(response);
    } else {
      throw Exception('Failed to load address');
    }
  }

//PLACE ORDER API
  Future<bool> placeOrder(int addressId, double totalAmount) async {
    // print(addressId);
    // print(totalAmount);
    SharedPreferences shareds = await SharedPreferences.getInstance();
    final url = '${ConstantHelper.uri}api/orderRegister';
    final response = await http.post(
      Uri.parse(url),
      headers: {'Content-Type': 'application/json'},
      body: json.encode({
        'user_id': int.parse(shareds.getString('userid').toString()),
        'address_id': addressId,
        'total_amount': totalAmount,
      }),
    );
    //print(response.statusCode);
    if (response.statusCode == 200) {
      final responseData = json.decode(response.body);
      // Check if the API response indicates success
      //print(response.body);
      return responseData['message'] == 'Order placed successfully.';
      // print()
    } else {
      return false; // Order failed
    }
  }

  //catregory api
  static Future<List<Map<String, dynamic>>> fetchCategoryList() async {
    final response =
        await http.get(Uri.parse("${ConstantHelper.uri}api/categoryList"));
    if (response.statusCode == 200) {
      List<dynamic> data = await json.decode(response.body)['data'];
      List<Map<String, dynamic>> categories = data.map((item) {
        return {"name": item['category_name'], "id": item['id'].toString()};
      }).toList();
      return categories;
    } else {
      throw Exception('Failed to load categories: ${response.statusCode}');
    }
  }

  //ORDER LIST API

  Future<List<OrderData>> fetchOrderList() async {
    SharedPreferences shareds = await SharedPreferences.getInstance();
    int userId = int.parse(shareds.getString('userid').toString());
    final response =
        await http.get(Uri.parse("${ConstantHelper.uri}api/orderList/$userId"));
    //print(userId);

    if (response.statusCode == 200) {
      final jsonResponse = json.decode(response.body);
      List<OrderData> orderList = List<OrderData>.from(
          jsonResponse['data'].map((x) => OrderData.fromJson(x)));
      return orderList;
    } else {
      throw Exception('Failed to load order list');
    }
  }

//UPDATE CART ITEM QUANTITY
  Future<void> updateCartItemQuantity(int id, int quantity) async {
    final url = '${ConstantHelper.uri}api/updateCartItemQty';
    final headers = {'Content-Type': 'application/json'};
    print('id: $id, quantity: $quantity');
    final body = jsonEncode({'id': id, 'quantity': quantity});

    try {
      final response = await http.put(
        Uri.parse(url),
        headers: headers,
        body: body,
      );
      // print(response);
      if (response.statusCode == 200) {
        print('Cart item updated successfully');
      } else {
        print('Failed to update cart item');
      }
    } catch (error) {
      print('Error updating cart item: $error');
    }
  }

//ADD ADDRESS API
  Future<bool> registerAddress(AddAddressModel addressModel) async {
    final url = Uri.parse('${ConstantHelper.uri}api/registerAddress');

    final response = await http.post(
      url,
      headers: {
        'Content-Type': 'application/json',
      },
      body: json.encode(addressModel.toJson()),
    );

    if (response.statusCode == 200) {
      final responseData = json.decode(response.body);
      print('Address registered successfully: ${responseData['message']}');
      return true;
    } else {
      print('Failed to register address. Status code: ${response.statusCode}');
      print('Response body: ${response.body}');
      return false;
    }
  }

  //update address api
  Future<bool> updateAddress(AddAddressModel addressModel) async {
    final url = Uri.parse('${ConstantHelper.uri}api/updateAddress');

    final response = await http.put(
      url,
      headers: {'Content-Type': 'application/json'},
      body: json.encode(addressModel.toJson()),
    );

    if (response.statusCode == 200) {
      final responseData = json.decode(response.body);
      print('Address updated successfully: ${responseData['message']}');
      return true;
    } else {
      print('Failed to update address. Status code: ${response.statusCode}');
      print('Response body: ${response.body}');
      return false;
    }
  }

  static Future<Map<String, dynamic>> fetchFilterSearch({
    required List<String> brandIds,
    required List<String> categoryIds,
    required String search,
    required int perPage,
    required int page,
  }) async {
    final String baseUrl = '${ConstantHelper.uri}api/filterSearch';
    final String brandIdsStr = brandIds.isEmpty ? '' : brandIds.join(',');
    final String categoryIdsStr =
        categoryIds.isEmpty ? '' : categoryIds.join(',');

    final response = await http.get(Uri.parse(
        '$baseUrl?brand_id=$brandIdsStr&category_id=$categoryIdsStr&search=$search&per_page=$perPage&page=$page'));

    if (response.statusCode == 200) {
      return json.decode(response.body);
      // print(response.body);
    } else {
      throw Exception('Failed to load data');
    }
  }

//UPDATE PROFILE API
  //final String profileUrl = "${ConstantHelper.uri}/api/updateUserInfo";

  // Future<String> updateUserProfile(Map<String, dynamic> userData) async {
  //   SharedPreferences shareds = await SharedPreferences.getInstance();
  //   int userId = int.parse(shareds.getString('userid').toString());

  //   final response = await http.put(
  //     Uri.parse("${ConstantHelper.uri}/api/updateUserInfo"),
  //     body: jsonEncode(userData),
  //     headers: {"Content-Type": "application/json"},
  //   );

  //   if (response.statusCode == 200) {
  //     final Map<String, dynamic> responseData = jsonDecode(response.body);
  //     return responseData['message'];
  //   } else {
  //     throw Exception('Failed to update user profile');
  //   }
  // }

  static Future<Map<String, dynamic>> updateUserData(
    int userId,
    String fullName,
    String email,
    String aadharNo,
    String panCardNo,
  ) async {
    final url = Uri.parse('${ConstantHelper.uri}api/updateUserInfo');

    final response = await http.put(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'id': userId,
        'fullName': fullName,
        'email': email,
        'aadharNo': aadharNo,
        'panCardNo': panCardNo,
      }),
    );

    print('Request URL: $url'); // Debug print
    print('Request Body: ${jsonEncode({
          'id': userId,
          'fullName': fullName,
          'email': email,
          'aadharNo': aadharNo,
          'panCardNo': panCardNo,
        })}'); // Debug print

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      return {
        'success': false,
        'message': 'Failed to update user data: ${response.reasonPhrase}',
      };
    }
  }

  // Future<void> netWorkCall(
  //   String urlEnd,
  //   dynamic? data,
  //   String method,
  // ) async {
  //   switch (method) {
  //     case "Get":
  //       getCall();
  //       break;
  //     case "Post":
  //       postCall();
  //       break;
  //     default:
  //   }
  // }

  Future<Map<String, dynamic>> resendOtp(String mobileNo) async {
    final url = Uri.parse('$baseUrl/resendOtp');
    final headers = {
      'Content-Type': 'application/json',
    };
    final body = jsonEncode({
      'key': 'mobileNo',
      'value': mobileNo,
      'description': '',
      'type': 'text',
      'enabled': true,
    });

    try {
      final response = await http.post(
        url,
        headers: headers,
        body: body,
      );

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        throw Exception('Failed to resend OTP');
      }
    } catch (e) {
      print('Error: $e');
      throw Exception('Failed to resend OTP');
    }
  }

  Future<Map<String, dynamic>> getAchievementData(int userId) async {
    final url = Uri.parse('${ConstantHelper.uri}get_achievement/$userId');

    try {
      final response = await http.get(url);

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        throw Exception('Failed to load achievement data');
      }
    } catch (e) {
      print('Error fetching achievement data: $e');
      throw Exception('Failed to load achievement data');
    }
  }
}
