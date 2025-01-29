import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:myshop_app/Helper/constants.dart';
import 'package:myshop_app/Screens/Cart/cart_screen.dart';
import 'package:myshop_app/Navigation%20and%20AppBar/app_bar.dart';
import 'package:myshop_app/Navigation%20and%20AppBar/navigation_bar.dart';
import 'package:myshop_app/Screens/Compare/compare_screen.dart';
import 'package:myshop_app/Screens/HomeScreen/home_view.dart';
import 'package:myshop_app/Screens/menu_screen.dart';
import 'package:myshop_app/Models/order_model.dart';
import 'package:myshop_app/APIs/api_services.dart';
import 'package:intl/intl.dart';

class OrderScreen extends StatefulWidget {
  @override
  _OrderScreenState createState() => _OrderScreenState();
}

class _OrderScreenState extends State<OrderScreen> {
  int _selectedIndex = 1;
  late Future<List<OrderData>> futureOrderList;
  ApiServices _apiServices = ApiServices();

  @override
  void initState() {
    super.initState();
    futureOrderList = _apiServices.fetchOrderList();
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;

      switch (index) {
        case 0:
          Navigator.push(
              context, MaterialPageRoute(builder: (context) => HomeView()));
          break;
        case 1:
          break;
        case 2:
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => CompareScreen(
                        products: [],
                      )));
          break;
        case 3:
          Navigator.push(
              context, MaterialPageRoute(builder: (context) => CartScreen()));
          break;
        case 4:
          Navigator.push(
              context, MaterialPageRoute(builder: (context) => MenuScreen()));
      }
    });
  }

  Color _getStatusColor(String status) {
    switch (status) {
      case 'delivered':
        return Colors.green;
      case 'pending':
        return Colors.orange;
      case 'cancellation':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  String _getStatus(String status) {
    switch (status) {
      case 'delivered':
        return 'DELIVERED';
      case 'pending':
        return 'PENDING';
      case 'cancellation':
        return 'CANCELLED';
      default:
        return '';
    }
  }

  String formatDateTime(DateTime dateTime) {
    return DateFormat('dd-MM-yyyy z – hh:mm:ss a').format(dateTime.toLocal());
    // print(dateTime);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(),
      body: FutureBuilder<List<OrderData>>(
        future: futureOrderList,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('No orders found'));
          } else {
            List<OrderData> orders = snapshot.data!;
            return ListView.builder(
              padding: EdgeInsets.all(16.0),
              itemCount: orders.length,
              itemBuilder: (context, index) {
                final order = orders[index];
                return Card(
                  elevation: 4.0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12.0),
                  ),
                  margin: EdgeInsets.symmetric(vertical: 8.0),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Order ID: ${order.id}',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 18.0,
                                color: Colors.teal,
                              ),
                            ),
                            Container(
                              padding: EdgeInsets.symmetric(
                                  vertical: 4.0, horizontal: 8.0),
                              decoration: BoxDecoration(
                                color: _getStatusColor(order.status),
                                borderRadius: BorderRadius.circular(8.0),
                              ),
                              child: Text(
                                _getStatus(order.status),
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 8.0),
                        Text(
                          'Total Amount: \₹${order.totalAmount.toStringAsFixed(2)}',
                          style: TextStyle(
                            fontSize: 16.0,
                            color: Colors.grey[700],
                          ),
                        ),
                        SizedBox(height: 8.0),
                        Text(
                          'Shipping Address:',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16.0,
                            color: Colors.teal,
                          ),
                        ),
                        Text(
                          '${order.addressInfo.fullname}, ${order.addressInfo.address}, ${order.addressInfo.city}, ${order.addressInfo.state} - ${order.addressInfo.pincode}',
                          style: TextStyle(
                            fontSize: 14.0,
                            color: Colors.grey[600],
                          ),
                        ),
                        Text(
                          'Mobile: ${order.addressInfo.mobileNumber}',
                          style: TextStyle(
                            fontSize: 14.0,
                            color: Colors.grey[600],
                          ),
                        ),
                        SizedBox(height: 16.0),
                        Text(
                          'Products:',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16.0,
                            color: Colors.teal,
                          ),
                        ),
                        ...order.orderResponseInfo.map((item) {
                          return Card(
                            elevation: 2.0,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8.0),
                            ),
                            margin: EdgeInsets.symmetric(vertical: 4.0),
                            child: ListTile(
                              title: Text(item.productInfo.productName),
                              subtitle: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text('Quantity: ${item.quantity}'),
                                  Text(
                                      'Variant: ${item.productVariant.colourId.name} - ${item.productVariant.variantId.name}'),
                                  Text(
                                    'Price: ${(item.productVariant.price)}',
                                  ),
                                  Text(
                                    'Order Date: ${formatDateTime(DateTime.parse(order.orderDate))}',
                                  ),
                                  SizedBox(height: 8.0),
                                ],
                              ),
                            ),
                          );
                        }).toList(),
                        SizedBox(
                          height: 16.0,
                        ),
                        Row(
                          children: [
                            ElevatedButton(
                              onPressed: () {
                                if (order.receipt != null) {
                                  showDialog(
                                    context: context,
                                    builder: (BuildContext context) {
                                      return AlertDialog(
                                        title: Center(
                                            child: Text(
                                          'Receipt',
                                          style: TextStyle(color: Colors.green),
                                        )),
                                        content: Column(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            Image.network(
                                              '${ConstantHelper.imguri}${order.receipt}',
                                              errorBuilder:
                                                  (context, error, stackTrace) {
                                                return Text(
                                                    'Failed to load receipt image.');
                                              },
                                            ),
                                          ],
                                        ),
                                        actions: [
                                          TextButton(
                                            onPressed: () {
                                              Navigator.of(context).pop();
                                            },
                                            child: Text('Close'),
                                          ),
                                          SizedBox(
                                            width: 10,
                                          ),
                                          // IconButton(
                                          //     onPressed: () {

                                          //     },
                                          //     icon: Icon(Icons.download))
                                        ],
                                      );
                                    },
                                  );
                                } else {
                                  // Show a message if the receipt is not available
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text('Receipt not available'),
                                      backgroundColor: Colors.red,
                                    ),
                                  );
                                }
                              },
                              child: Text('View Receipt'),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                );
              },
            );
          }
        },
      ),
      bottomNavigationBar: CustomBottomNavigationBar(
        selectedIndex: _selectedIndex,
        onTap: _onItemTapped,
      ),
    );
  }
}
