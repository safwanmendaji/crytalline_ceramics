import 'package:flutter/material.dart';
import 'package:myshop_app/Screens/menu_screen.dart';
import 'package:url_launcher/url_launcher_string.dart';
import 'package:myshop_app/APIs/api_services.dart';
import 'package:myshop_app/Models/product_model.dart';
import 'package:myshop_app/Screens/Cart/cart_screen.dart';
import 'package:myshop_app/Navigation and AppBar/app_bar.dart';
import 'package:myshop_app/Navigation and AppBar/navigation_bar.dart';
import 'package:myshop_app/Widgets/back_button.dart';
import 'package:myshop_app/Helper/constants.dart';
import 'package:myshop_app/common/common.dart';
import 'package:myshop_app/Screens/HomeScreen/home_view.dart';
import 'package:myshop_app/Screens/Order/order_screen.dart';
import 'package:myshop_app/Models/user_model.dart';
import 'package:myshop_app/Screens/Compare/compare_screen.dart';

class ProductDetailsScreen extends StatefulWidget {
  final String image;
  final int id;
  final String name;
  final String description;
  final List<Variant> variants;
  final double price;
  final String technicalDataSheet;

  ProductDetailsScreen({
    required this.image,
    required this.name,
    required this.description,
    required this.variants,
    required this.price,
    required this.id,
    required this.technicalDataSheet,
  });

  @override
  _ProductDetailsScreenState createState() => _ProductDetailsScreenState();
}

class _ProductDetailsScreenState extends State<ProductDetailsScreen> {
  Variant? selectedVariant;
  VariantDetail? selectedVariantDetail;
  final ApiServices apiService = ApiServices();
  int _quantity = 1;
  double _totalPrice = 0.0;
  UserData? _userData;
  final TextEditingController _quantityController =
      TextEditingController(text: '1');
  bool isOutOfStock = false; // New variable to track stock status

  @override
  void initState() {
    super.initState();
    if (widget.variants.isNotEmpty) {
      selectedVariant = widget.variants[0];
      if (selectedVariant!.colour.variant.isNotEmpty) {
        selectedVariantDetail = selectedVariant!.colour.variant[0];
        isOutOfStock = selectedVariantDetail?.stockAvailable ?? false
            ? false
            : true; // Check stock status
      }
    }
    _updateTotalPrice();
    _fetchUserData();
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

  void _incrementQuantity() {
    setState(() {
      _quantity++;
      _updateTotalPrice();
      _quantityController.text = _quantity.toString();
    });
  }

  void _decrementQuantity() {
    setState(() {
      if (_quantity > 1) {
        _quantity--;
        _updateTotalPrice();
        _quantityController.text = _quantity.toString();
      }
    });
  }

  void _updateTotalPrice() {
    setState(() {
      double basePrice = widget.price;
      double variantPrice = 0.0;

      if (selectedVariantDetail != null) {
        variantPrice =
            double.tryParse(selectedVariantDetail!.price.toString()) ?? 0.0;
      }

      _totalPrice = (variantPrice) * _quantity;
      isOutOfStock = selectedVariantDetail?.stockAvailable ?? false
          ? false
          : true; // Update stock status
    });
  }

  void _onQuantityChanged(String value) {
    final int? newQuantity = int.tryParse(value);
    if (newQuantity != null && newQuantity > 0) {
      setState(() {
        _quantity = newQuantity;
        _updateTotalPrice();
      });
    }
  }

  void _downloadSheet() {
    final url =
        widget.technicalDataSheet; // Use widget to access technicalDataSheet
    if (url != null && url.isNotEmpty) {
      _launchURL(url);
    } else {
      _showSheetNotAvailableDialog(); // Show dialog if sheet is not available
    }
  }

  void _launchURL(String url) async {
    try {
      if (await canLaunchUrlString(url)) {
        await launchUrlString(url,
            mode: LaunchMode
                .externalApplication); // Use external application mode
      } else {
        throw 'Could not launch $url';
      }
    } catch (e) {
      print('Error launching URL: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Could not open the URL')),
      );
    }
  }

  void _showSheetNotAvailableDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Sheet Not Available'),
          content: Text(
              'The technical data sheet is not available for this product.'),
          actions: <Widget>[
            TextButton(
              child: Text('OK'),
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
            ),
          ],
        );
      },
    );
  }

  void _onBottomNavigationBarTap(int index) {
    switch (index) {
      case 0:
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (context) => HomeView()));
        break;
      case 1:
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (context) => OrderScreen()));
        break;
      case 2:
        Navigator.pushReplacement(
            context,
            MaterialPageRoute(
                builder: (context) => CompareScreen(
                      products: [],
                    )));
        break;
      case 3:
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (context) => CartScreen()));
        break;
      case 4:
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (context) => MenuScreen()));
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(),
      body: Column(
        children: [
          BackButtonWidget(),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Center(
                      child: Image.network(
                        "${ConstantHelper.imguri}images/" + widget.image,
                        fit: BoxFit.cover,
                        height: 300,
                        width: double.infinity,
                      ),
                    ),
                    SizedBox(height: 16),
                    Divider(thickness: 1),
                    Text(
                      "Product Name:\n",
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      widget.name,
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 8),
                    Divider(thickness: 1),
                    Text(
                      'Price: ₹${_totalPrice.toStringAsFixed(2)}',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 16),
                    Divider(thickness: 1),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Color:',
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              DropdownButton<Variant>(
                                value: selectedVariant,
                                items: widget.variants.map((Variant variant) {
                                  return DropdownMenuItem<Variant>(
                                    value: variant,
                                    child: Text(variant.colour.colourName ??
                                        'No color name'),
                                  );
                                }).toList(),
                                onChanged: (Variant? newValue) {
                                  setState(() {
                                    selectedVariant = newValue;
                                    selectedVariantDetail =
                                        newValue?.colour.variant.isNotEmpty ==
                                                true
                                            ? newValue?.colour.variant[0]
                                            : null;
                                    _updateTotalPrice();
                                  });
                                },
                              ),
                              SizedBox(height: 16),
                              Text(
                                'Size:',
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              DropdownButton<VariantDetail>(
                                value: selectedVariantDetail,
                                items: selectedVariant?.colour.variant
                                    .map((VariantDetail detail) {
                                  return DropdownMenuItem<VariantDetail>(
                                    value: detail,
                                    child: Text(detail.variantName),
                                  );
                                }).toList(),
                                onChanged: (VariantDetail? newValue) {
                                  setState(() {
                                    selectedVariantDetail = newValue;
                                    _updateTotalPrice();
                                  });
                                },
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 16),
                    Center(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Text(
                            "Quantity: ",
                            style: TextStyle(
                                fontSize: 20, fontWeight: FontWeight.bold),
                          ),
                          IconButton(
                            onPressed: _decrementQuantity,
                            icon: Icon(Icons.remove),
                          ),
                          SizedBox(
                            width: 80,
                            child: TextField(
                              controller: _quantityController,
                              keyboardType: TextInputType.number,
                              textAlign: TextAlign.center,
                              decoration: InputDecoration(
                                border: OutlineInputBorder(),
                                contentPadding:
                                    EdgeInsets.symmetric(vertical: 0),
                              ),
                              onChanged: _onQuantityChanged,
                            ),
                          ),
                          IconButton(
                            onPressed: _incrementQuantity,
                            icon: Icon(Icons.add),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 15),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Text(
                          "Technical Data Sheet:",
                          style: TextStyle(
                              fontSize: 20, fontWeight: FontWeight.bold),
                        ),
                        IconButton(
                          icon: Icon(Icons.download),
                          onPressed: _downloadSheet,
                        ),
                      ],
                    ),
                    SizedBox(height: 16), // Add spacing if necessary
                    Divider(thickness: 1),
                    Text(
                      "Description:\n",
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(widget.description),
                  ],
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Center(
              child: isOutOfStock
                  ? Text(
                      'Out of Stock',
                      style: TextStyle(fontSize: 18, color: Colors.red),
                    )
                  : TextButton(
                      onPressed: () async {
                        int userId = _userData?.id ?? 0;
                        int productId = widget.id;
                        int productVariantId =
                            selectedVariantDetail?.product_variant_id ?? 0;
                        int quantity = _quantity;

                        try {
                          bool success = await apiService.addToCart(
                            userId,
                            productId,
                            productVariantId,
                            quantity,
                          );
                          if (success) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text('Product added to cart')),
                            );
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                  content: Text(
                                      'This product is already in the cart')),
                            );
                          }
                        } catch (e) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text('An error occurred: $e')),
                          );
                        }
                      },
                      child: Text(
                        'Add to Cart',
                        style: TextStyle(fontSize: 14),
                      ),
                      style: TextButton.styleFrom(
                        foregroundColor: Colors.black,
                        padding:
                            EdgeInsets.symmetric(horizontal: 120, vertical: 15),
                        backgroundColor: Colors.brown[300],
                      ),
                    ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: CustomBottomNavigationBar(
        selectedIndex: 0,
        onTap: _onBottomNavigationBarTap,
      ),
    );
  }
}
