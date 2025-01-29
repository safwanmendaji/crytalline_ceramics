import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:myshop_app/Screens/Cart/cart_provider.dart';
import 'package:myshop_app/Helper/constants.dart'; // Adjust the import based on your actual file structure

class CartScreenListProduct extends StatelessWidget {
  final int? selectedItemIndex;
  final void Function(int index) onItemSelected;

  CartScreenListProduct({
    this.selectedItemIndex,
    required this.onItemSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Consumer<CartProvider>(
      builder: (context, cartProvider, child) {
        return Expanded(
          child: ListView.builder(
            itemCount: cartProvider.cartItems.length,
            itemBuilder: (context, index) {
              final item = cartProvider.cartItems[index];
              return GestureDetector(
                onTap: () {
                  onItemSelected(index);
                },
                child: Container(
                  color: selectedItemIndex == index
                      ? Colors.green[100]
                      : Colors.green[20],
                  padding: EdgeInsets.all(8.0),
                  child: Row(
                    children: [
                      Image.network(
                        '${ConstantHelper.imguri}images/${item['image']}',
                        width: 100,
                        height: 100,
                        fit: BoxFit.cover,
                      ),
                      SizedBox(width: 8.0),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              item['name'],
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                            Text('Color: ${item['color']}'),
                            Text('Variant: ${item['variant_name']}'),
                            LayoutBuilder(
                              builder: (context, constraints) {
                                bool isRow = constraints.maxWidth > 200;
                                return isRow
                                    ? Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Text(
                                            "Quantity: ",
                                            style: TextStyle(
                                                fontSize: 16,
                                                fontWeight: FontWeight.bold),
                                          ),
                                          IconButton(
                                            onPressed: () => cartProvider
                                                .decrementQuantity(index),
                                            icon: Icon(Icons.remove, size: 16),
                                          ),
                                          Text(
                                            '${item['quantity']}',
                                            style: TextStyle(
                                                fontSize: 16,
                                                fontWeight: FontWeight.bold),
                                          ),
                                          IconButton(
                                            onPressed: () => cartProvider
                                                .incrementQuantity(index),
                                            icon: Icon(Icons.add, size: 16),
                                          ),
                                        ],
                                      )
                                    : Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Text(
                                            "Quantity: ",
                                            style: TextStyle(
                                                fontSize: 16,
                                                fontWeight: FontWeight.bold),
                                          ),
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              IconButton(
                                                onPressed: () => cartProvider
                                                    .decrementQuantity(index),
                                                icon: Icon(Icons.remove,
                                                    size: 16),
                                              ),
                                              Text(
                                                '${item['quantity']}',
                                                style: TextStyle(
                                                    fontSize: 16,
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                              IconButton(
                                                onPressed: () => cartProvider
                                                    .incrementQuantity(index),
                                                icon: Icon(Icons.add, size: 16),
                                              ),
                                            ],
                                          ),
                                        ],
                                      );
                              },
                            )
                          ],
                        ),
                      ),
                      Column(
                        children: [
                          Text(
                            '₹${(item['price'] * item['quantity']).toStringAsFixed(2)}',
                            style: TextStyle(
                                fontSize: 16, fontWeight: FontWeight.bold),
                          ),
                          IconButton(
                            icon: Icon(Icons.delete),
                            onPressed: () {
                              cartProvider.removeItem(index, item['id']);
                            },
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        );
      },
    );
  }
}
