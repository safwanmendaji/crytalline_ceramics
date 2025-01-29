import 'package:flutter/material.dart';
import 'package:myshop_app/Screens/Cart/cart_screen_list_product.dart';
import 'package:myshop_app/Screens/Cart/cart_screen_order_button.dart';
import 'package:myshop_app/Screens/Address/address_screen.dart';
import 'package:myshop_app/Widgets/back_button.dart';
import 'package:myshop_app/common/common.dart';
import 'package:myshop_app/Helper/constants.dart';
import 'package:myshop_app/Screens/menu_screen.dart';
import 'package:myshop_app/Screens/Order/order_screen.dart';
import 'package:myshop_app/Models/user_model.dart';
import 'package:provider/provider.dart';
import 'cart_provider.dart';
import 'package:myshop_app/Navigation%20and%20AppBar/app_bar.dart';
import 'package:myshop_app/Navigation%20and%20AppBar/navigation_bar.dart';
import 'package:myshop_app/Screens/Compare/compare_screen.dart';
import 'package:myshop_app/Screens/HomeScreen/home_view.dart';

class CartScreen extends StatefulWidget {
  @override
  _CartScreenState createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  final int _selectedIndex = 3;
  int? _selectedItemIndex;
  bool _isProcessing = false;
  UserData? _userData;
  double totaalamount = 0.0;

  @override
  void initState() {
    super.initState();
    _fetchUserData(); // Fetch user data first
  }

  Future<void> _fetchUserData() async {
    try {
      Common common = Common();
      UserData? userData = await common.getUser();
      setState(() {
        _userData = userData;
      });
      if (_userData != null) {
        // Fetch cart details only if user data is available
        final cartProvider = Provider.of<CartProvider>(context, listen: false);
        await cartProvider.refreshCart();
        await cartProvider.fetchCartDetails(_userData!.id);

        // Compute total amount here
        setState(() {
          totaalamount = cartProvider.cartItems.fold(
            0.0,
            (sum, item) => sum + (item['price'] * item['quantity']),
          );
        });
      }
    } catch (e) {
      print('Error fetching user data: $e');
    }
  }

  void _incrementQuantity(CartProvider cartProvider, int index) {
    setState(() {
      cartProvider.incrementQuantity(index);
    });
  }

  void _decrementQuantity(CartProvider cartProvider, int index) {
    setState(() {
      cartProvider.decrementQuantity(index);
    });
  }

  void _onItemTapped(int index) {
    final cartProvider = Provider.of<CartProvider>(context, listen: false);
    switch (index) {
      case 0:
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => HomeView(),
          ),
        );
        break;
      case 1:
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => OrderScreen(),
          ),
        );
        break;
      case 2:
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => CompareScreen(
              products: cartProvider.cartItems.map((product) {
                return {
                  'name': product['name'],
                  'price': product['price'],
                  'image': product['image'],
                  'color': product['color'],
                  'size': product['size'],
                };
              }).toList(),
            ),
          ),
        );
        break;
      case 3:
        // Do nothing for the cart screen
        break;
      case 4:
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => MenuScreen(),
          ),
        );
        break;
    }
  }

  Future<void> _handleOrderNow() async {
    setState(() {
      _isProcessing = true;
    });

    // Simulate order processing
    await Future.delayed(Duration(seconds: 2));

    setState(() {
      _isProcessing = false;
    });

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => AddressScreen(totaalamount: totaalamount),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final cartProvider = Provider.of<CartProvider>(context);

    return Scaffold(
      appBar: CustomAppBar(),
      body: cartProvider.isLoading
          ? Center(child: CircularProgressIndicator())
          : Container(
              color: Colors.grey[200],
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 8.0),
                    child: BackButtonWidget(),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Text(
                      'Cart',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  CartScreenListProduct(
                    selectedItemIndex: _selectedItemIndex,
                    onItemSelected: (index) {
                      setState(() {
                        _selectedItemIndex = index;
                      });
                    },
                  ),
                ],
              ),
            ),
      bottomNavigationBar: CustomBottomNavigationBar(
        selectedIndex: _selectedIndex,
        onTap: _onItemTapped,
      ),
      persistentFooterButtons: [
        CartScreenOrderButton(
          totaalamount: totaalamount,
          isProcessing: _isProcessing,
        ),
      ],
    );
  }
}
