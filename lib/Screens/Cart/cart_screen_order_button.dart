import 'package:flutter/material.dart';
import 'package:myshop_app/Screens/Address/address_screen.dart';
import 'package:provider/provider.dart';
import 'cart_provider.dart';

class CartScreenOrderButton extends StatelessWidget {
  final double totaalamount;
  final bool isProcessing;

  CartScreenOrderButton({
    required this.totaalamount,
    required this.isProcessing,
  });

  @override
  Widget build(BuildContext context) {
    final cartProvider = Provider.of<CartProvider>(context);

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: FutureBuilder<double>(
        future: cartProvider.totalPrice,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          } else {
            final totalPrice = snapshot.data ?? 0.0;
            return Column(
              children: [
                Text(
                  'Total Price: ₹${totalPrice.toStringAsFixed(2)}',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 10),
                AnimatedSwitcher(
                  duration: Duration(milliseconds: 300),
                  child: isProcessing
                      ? Icon(
                          Icons.check_circle_outline,
                          color: Colors.blue,
                          size: 50,
                          key: ValueKey('checkmark'),
                        )
                      : ElevatedButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => AddressScreen(
                                  totaalamount: totaalamount,
                                ),
                              ),
                            );
                          },
                          child: Text(
                            'Order Now',
                            style: TextStyle(fontSize: 14),
                          ),
                          style: ElevatedButton.styleFrom(
                            foregroundColor: Colors.black,
                            backgroundColor: Colors.brown[300],
                            padding: EdgeInsets.symmetric(
                                horizontal: 120, vertical: 15),
                            minimumSize: Size(double.infinity, 50),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                          ),
                          key: ValueKey('order_button'),
                        ),
                ),
              ],
            );
          }
        },
      ),
    );
  }
}
