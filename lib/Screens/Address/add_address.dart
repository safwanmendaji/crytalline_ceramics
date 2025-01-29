// lib/add_address.dart

import 'package:flutter/material.dart';
import 'package:myshop_app/APIs/api_services.dart';
import 'package:myshop_app/Screens/HomeScreen/home_view.dart';
import 'package:myshop_app/Models/address_model.dart';
import 'package:myshop_app/Navigation%20and%20AppBar/navigation_bar.dart';
import 'package:myshop_app/Screens/Cart/cart_screen.dart';
import 'package:myshop_app/Screens/Compare/compare_screen.dart';
import 'package:myshop_app/Screens/menu_screen.dart';
import 'package:myshop_app/Screens/Order/order_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:myshop_app/Navigation%20and%20AppBar/app_bar.dart';
import 'package:myshop_app/Widgets/back_button.dart';

class AddAddress extends StatefulWidget {
  final AddAddressModel?
      existingAddress; // Optional parameter for existing address

  AddAddress({this.existingAddress});

  @override
  _AddAddressState createState() => _AddAddressState();
}

class _AddAddressState extends State<AddAddress> {
  final _fullnameController = TextEditingController();
  final _addressController = TextEditingController();
  final _cityController = TextEditingController();
  final _stateController = TextEditingController();
  final _pincodeController = TextEditingController();
  final _mobileNumberController = TextEditingController();
  final _locationController = TextEditingController(); // Location controller
  String _addressType = 'Home';
  bool _isDefault = false;
  bool _isLoading = false;
  String? _errorMessage;
  String? _userId;
  int _selectedIndex = 0;
  List<Map<String, dynamic>> brands = [];

  @override
  void initState() {
    super.initState();
    _loadUserId();
    _populateExistingAddress();
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
      switch (index) {
        case 0:
          Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => HomeView(),
              ));
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
              builder: (context) => CompareScreen(products: brands),
            ),
          );
          break;
        case 3:
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => CartScreen(),
            ),
          );
          break;
        case 4:
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => MenuScreen(),
            ),
          );
          break;
        default:
      }
    });
  }

  Future<void> _loadUserId() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _userId = prefs.getString("userid");
    });
  }

  void _populateExistingAddress() {
    if (widget.existingAddress != null) {
      _fullnameController.text = widget.existingAddress!.fullname;
      _addressController.text = widget.existingAddress!.address;
      // _cityController.text = widget.existingAddress!.city ?? '';
      // _stateController.text = widget.existingAddress!.state ?? '';
      // _pincodeController.text = widget.existingAddress!.pincode ?? '';
      _mobileNumberController.text = widget.existingAddress!.mobileNumber;
      _addressType = widget.existingAddress!.addressType;
      _isDefault = widget.existingAddress!.isDefault;
    }
  }

  Future<void> _saveAddress() async {
    if (_userId == null) {
      setState(() {
        _errorMessage = 'User not logged in.';
      });
      return;
    }

    setState(() {
      _isLoading = true;
    });

    final addressModel = AddAddressModel(
      id: widget.existingAddress?.id, // Include ID for updates
      userId: _userId!,
      fullname: _fullnameController.text,
      address: _addressController.text,
      // city: _cityController.text,
      // state: _stateController.text,
      // pincode: _pincodeController.text,
      mobileNumber: _mobileNumberController.text,
      userLocation: _locationController.text, // Include location field
      addressType: _addressType,
      isDefault: _isDefault,
    );

    final api = ApiServices();
    final success = widget.existingAddress == null
        ? await api.registerAddress(addressModel)
        : await api.updateAddress(addressModel); // Use appropriate API call

    setState(() {
      _isLoading = false;
      if (success) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Address ${widget.existingAddress == null ? 'added' : 'updated'} successfully!',
            ),
          ),
        );
        Navigator.pop(context, true); // Return true to indicate success
      } else {
        _errorMessage =
            'Failed to ${widget.existingAddress == null ? 'add' : 'update'} address. Please try again.';
      }
    });
  }

  @override
  void dispose() {
    _fullnameController.dispose();
    _addressController.dispose();
    _cityController.dispose();
    _stateController.dispose();
    _pincodeController.dispose();
    _mobileNumberController.dispose();
    _locationController.dispose(); // Dispose location controller
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBarWithoutPerson(),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              BackButtonWidget(),
              SizedBox(height: 16.0),
              Text(
                widget.existingAddress == null
                    ? 'Add New Address'
                    : 'Edit Address',
                style: TextStyle(
                    fontSize: 24.0,
                    fontWeight: FontWeight.bold,
                    color: Colors.brown),
              ),
              SizedBox(height: 16.0),
              TextField(
                controller: _fullnameController,
                decoration: InputDecoration(
                  labelText: 'Full Name',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
              ),
              SizedBox(height: 16.0),
              TextField(
                controller: _addressController,
                maxLines: 3,
                decoration: InputDecoration(
                  labelText: 'Address',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
              ),
              SizedBox(height: 16.0),
              // Location text field
              TextField(
                controller: _locationController,
                decoration: InputDecoration(
                  labelText: 'User-Location',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
              ),
              SizedBox(height: 16.0),
              TextField(
                controller: _mobileNumberController,
                decoration: InputDecoration(
                  labelText: 'Mobile Number',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
                keyboardType: TextInputType.phone,
              ),
              SizedBox(height: 16.0),
              DropdownButtonFormField<String>(
                value: _addressType,
                onChanged: (newValue) {
                  setState(() {
                    _addressType = newValue!;
                  });
                },
                items: ['Home', 'Office', 'Other']
                    .map((type) => DropdownMenuItem(
                          child: Text(type),
                          value: type,
                        ))
                    .toList(),
                decoration: InputDecoration(
                  labelText: 'Address Type',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
              ),
              SizedBox(height: 16.0),
              Row(
                children: [
                  Checkbox(
                    value: _isDefault,
                    onChanged: (bool? newValue) {
                      setState(() {
                        _isDefault = newValue ?? false;
                      });
                    },
                  ),
                  Text('Set as default'),
                ],
              ),
              SizedBox(height: 16.0),
              if (_isLoading)
                Center(child: CircularProgressIndicator())
              else
                ElevatedButton(
                  onPressed: _saveAddress,
                  child: Text(widget.existingAddress == null
                      ? 'Add Address'
                      : 'Update Address'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.brown[400],
                    minimumSize: Size(double.infinity, 50),
                    padding:
                        EdgeInsets.symmetric(vertical: 12.0, horizontal: 16.0),
                    textStyle:
                        TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                  ),
                ),
              if (_errorMessage != null)
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: Text(
                    _errorMessage!,
                    style: TextStyle(color: Colors.red),
                  ),
                ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.receipt),
            label: 'Orders',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.compare_arrows),
            label: 'Compare',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.shopping_cart),
            label: 'Cart',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.menu),
            label: 'Menu',
          ),
        ],
      ),
    );
  }
}
