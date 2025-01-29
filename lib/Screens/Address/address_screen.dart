import 'package:flutter/material.dart';
import 'package:myshop_app/APIs/api_services.dart';
import 'package:myshop_app/Navigation%20and%20AppBar/app_bar.dart';
import 'package:myshop_app/Navigation%20and%20AppBar/navigation_bar.dart';
import 'package:myshop_app/Screens/Cart/cart_screen.dart';
import 'package:myshop_app/Screens/Address/add_address.dart';
import 'package:myshop_app/Models/address_model.dart';
import 'package:myshop_app/Screens/Compare/compare_screen.dart';
import 'package:myshop_app/Screens/menu_screen.dart';
import 'package:myshop_app/Screens/Order/order_screen.dart';
import 'package:myshop_app/Widgets/back_button.dart';
import 'package:myshop_app/common/common.dart';
import 'package:myshop_app/Screens/Order/order_success.dart';
import 'package:myshop_app/Models/user_model.dart';

class AddressScreen extends StatefulWidget {
  final double totaalamount;
  AddressScreen({required this.totaalamount});

  @override
  _AddressScreenState createState() =>
      _AddressScreenState(totaalamount: totaalamount);
}

class _AddressScreenState extends State<AddressScreen> {
  final double totaalamount;
  _AddressScreenState({required this.totaalamount});
  AddressResponse? _addressResponse;
  ApiServices api = ApiServices();
  bool _isLoading = true;
  String _errorMessage = '';
  UserData? _userData;
  int? _selectedAddressId;
  int _selectedIndex = 0;
  List<Map<String, dynamic>> brands = [];

  @override
  void initState() {
    super.initState();
    fetchAddress();
  }

  Future<void> _fetchUserData() async {
    try {
      Common common = Common();
      UserData? userData = await common.getUser();
      setState(() {
        _userData = userData;
      });
    } catch (e) {
      print('Error fetching user data: $e');
    }
  }

  Future<void> fetchAddress() async {
    try {
      await _fetchUserData();
      AddressResponse? response = await api.fetchAddress(_userData?.id ?? 0);

      setState(() {
        _addressResponse = response;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
        _errorMessage = 'Error fetching address: $e';
      });
    }
  }

  Future<void> placeorder() async {
    try {
      await _fetchUserData();
      var response = await api.placeOrder(_selectedAddressId!, totaalamount);

      setState(() {
        SnackBar snackBar = SnackBar(
          content: Text("Order Placed Successfully"),
        );
        ScaffoldMessenger.of(context).showSnackBar(snackBar);
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => OrderSuccessScreen(),
          ),
        );
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
        _errorMessage = 'Error placing order: $e';
      });
    }
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
      switch (index) {
        case 0:
          break;
        case 1:
          Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => OrderScreen(),
              ));
          break;
        case 2:
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => CompareScreen(products: brands)));
          break;
        case 3:
          Navigator.push(
              context, MaterialPageRoute(builder: (context) => CartScreen()));
          break;
        case 4:
          Navigator.push(
              context, MaterialPageRoute(builder: (context) => MenuScreen()));
          break;
        default:
      }
    });
  }

  void _navigateToAddAddressScreen() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => AddAddress()),
    );

    if (result == true) {
      fetchAddress();
    }
  }

  void _navigateToEditAddressScreen(AddAddress address) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => AddAddress(),
      ),
    );

    if (result == true) {
      fetchAddress();
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('Address'),
        ),
        body: Center(child: CircularProgressIndicator()),
      );
    }

    if (_errorMessage.isNotEmpty) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('Address'),
        ),
        body: Center(child: Text(_errorMessage)),
      );
    }

    return Scaffold(
      appBar: CustomAppBarWithoutPerson(
          //
          ),
      body: Column(
        children: [
          BackButtonWidget(),
          Container(
            padding: EdgeInsets.all(16.0),
            color: Colors.grey[200],
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Heading Text
                Text(
                  'Select Address',
                  style: TextStyle(
                    fontSize: 24.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 16.0),

                Center(
                  child: ElevatedButton(
                    onPressed: _navigateToAddAddressScreen,
                    child: Text(
                      '+ Add New Address',
                      style: TextStyle(fontSize: 16.0),
                    ),
                    style: ElevatedButton.styleFrom(
                      foregroundColor: Colors.black,
                      backgroundColor: Colors.blue[300],
                      padding: EdgeInsets.symmetric(
                          vertical: 12.0, horizontal: 16.0),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: _addressResponse == null || _addressResponse!.data.isEmpty
                ? Center(child: Text('No addresses found'))
                : ListView.builder(
                    itemCount: _addressResponse!.data.length,
                    itemBuilder: (context, index) {
                      final address = _addressResponse!.data[index];
                      final isSelected = _selectedAddressId == address.id;
                      final isDefault = address.isDefault == 1;

                      return Card(
                        margin: EdgeInsets.symmetric(
                            vertical: 8.0, horizontal: 16.0),
                        elevation: 5.0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                        child: ListTile(
                          contentPadding: EdgeInsets.all(16.0),
                          tileColor:
                              isSelected ? Colors.blue.shade50 : Colors.white,
                          leading: Icon(
                            isSelected
                                ? Icons.check_circle
                                : Icons.radio_button_unchecked,
                            color: isSelected ? Colors.blue : Colors.grey,
                          ),
                          title: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Address',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16.0,
                                ),
                              ),
                              if (isDefault)
                                Padding(
                                  padding: const EdgeInsets.only(top: 4.0),
                                  child: Container(
                                    padding: EdgeInsets.symmetric(
                                        horizontal: 8.0, vertical: 4.0),
                                    decoration: BoxDecoration(
                                      color: Colors.green,
                                      borderRadius: BorderRadius.circular(12.0),
                                    ),
                                    child: Text(
                                      '${address.addressType} Address',
                                      style: TextStyle(
                                          color: Colors.white, fontSize: 12.0),
                                    ),
                                  ),
                                ),
                            ],
                          ),
                          subtitle: Padding(
                            padding: const EdgeInsets.only(top: 8.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('Address: ${address.address}'),
                                // Text('City: ${address.city}'),
                                // Text('State: ${address.state}'),
                              ],
                            ),
                          ),
                          trailing: IconButton(
                            icon: Icon(Icons.edit),
                            onPressed: () {
                              _navigateToEditAddressScreen(AddAddress());
                            },
                          ),
                          onTap: () {
                            setState(() {
                              _selectedAddressId = address.id;
                            });
                          },
                        ),
                      );
                    },
                  ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: ElevatedButton(
              onPressed: _selectedAddressId != null ? placeorder : null,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.brown[300],
                minimumSize: Size(double.infinity, 50),
                padding: EdgeInsets.symmetric(vertical: 12.0, horizontal: 16.0),
                textStyle: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                ),
              ),
              child: Text(
                "Place Order",
                style: TextStyle(
                  color: Colors.black,
                ),
              ),
            ),
          )
        ],
      ),
      bottomNavigationBar: CustomBottomNavigationBar(
          selectedIndex: _selectedIndex, onTap: _onItemTapped),
    );
  }
}
