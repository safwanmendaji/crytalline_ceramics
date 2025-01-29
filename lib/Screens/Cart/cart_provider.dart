import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:myshop_app/APIs/api_services.dart';
import 'package:myshop_app/Helper/constants.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CartProvider with ChangeNotifier {
  List<Map<String, dynamic>> _cartItems = [];
  bool _isLoading = false;

  List<Map<String, dynamic>> get cartItems => _cartItems;
  bool get isLoading => _isLoading;
  ApiServices apiService = ApiServices();

  Future<void> refreshCart() async {
    _cartItems = [];
    notifyListeners();
  }

  Future<void> fetchCartDetails(int userId) async {
    _isLoading = true;
    notifyListeners();

    final url = "${ConstantHelper.uri}api/getCartById/$userId";
    try {
      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        final responseData = json.decode(response.body);

        if (responseData['message'] == 'Cart details retrieved successfully.') {
          final List<dynamic> data = responseData['data'] ?? [];

          _cartItems = data.map<Map<String, dynamic>>((item) {
            final product = item['product'];
            final List<dynamic> variants = product['variants'] ?? [];
            final variant = variants.firstWhere(
                (v) => v['id'] == item['product_variant_id'],
                orElse: () => {});

            return {
              'id': item['id'],
              'user_id': item['user_id'],
              'product_id': item['product_id'],
              'product_variant_id': item['product_variant_id'],
              'quantity': item['quantity'],
              'name': product['product_name'] ?? 'Unknown',
              'description': product['product_description'] ?? 'No Description',
              'image': product['product_image'] ?? 'No Image',
              'price':
                  double.tryParse(variant['price']?.toString() ?? '0') ?? 0.0,
              'color': variant['colour']?['colour_name'] ?? 'Unknown',
              'variant_name': variant['variant']?['variant_name'] ?? 'Unknown',
              'size': variant['size'] ?? 'Unknown',
              'discount': variant['discount'] ?? 0.0,
            };
          }).toList();
        }
      } else {
        print('Failed to load cart details');
      }
    } catch (error) {
      print('Error fetching cart details: $error');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void removeItem(int index, int itemId) {
    _cartItems.removeAt(index);
    apiService.deleteItem(itemId);
    notifyListeners();
  }

  Future<double> get totalPrice async {
    double total = 0.0;
    for (var item in _cartItems) {
      total += (item['price'] as double) * (item['quantity'] as int);
    }

    final prefs = await SharedPreferences.getInstance();
    await prefs.setDouble('totalPrice', total);

    return total;
  }

  void incrementQuantity(int index) {
    int currentQuantity = _cartItems[index]['quantity'];
    int newQuantity = currentQuantity + 1;
    var cartId = _cartItems[index]['id'];

    _cartItems[index]['quantity'] = newQuantity;
    notifyListeners();

    apiService.updateCartItemQuantity(cartId, newQuantity);
  }

  void decrementQuantity(int index) {
    int currentQuantity = _cartItems[index]['quantity'];
    if (currentQuantity > 1) {
      int newQuantity = currentQuantity - 1;
      var cartId = _cartItems[index]['id'];

      _cartItems[index]['quantity'] = newQuantity;
      notifyListeners();

      apiService.updateCartItemQuantity(cartId, newQuantity);
    }
  }
}
