import 'package:flutter/material.dart';
import 'package:myshop_app/Helper/string_helper.dart';
import 'package:myshop_app/Screens/BrandScreen/brand_productheaders.dart';
import 'package:myshop_app/Screens/BrandScreen/filter_button_brandscreen.dart';
import 'package:myshop_app/Models/product_model.dart';
import 'package:http/http.dart' as http;
import 'package:myshop_app/Screens/Cart/cart_screen.dart';
import 'package:myshop_app/Navigation%20and%20AppBar/app_bar.dart';
import 'package:myshop_app/Navigation%20and%20AppBar/navigation_bar.dart';
import 'package:myshop_app/Screens/Product/product_detail_screen.dart';
import 'package:myshop_app/Widgets/back_button.dart';
import 'package:myshop_app/Screens/Compare/compare_screen.dart';
import 'package:myshop_app/components/searchBar.dart';
import 'package:myshop_app/Helper/constants.dart';
import 'package:myshop_app/Screens/HomeScreen/home_view.dart';
import 'package:myshop_app/Screens/menu_screen.dart';
import 'package:myshop_app/Screens/Order/order_screen.dart';
import 'dart:convert';

class BrandProductsScreen extends StatefulWidget {
  final String brandId;

  BrandProductsScreen({required this.brandId});

  @override
  _BrandProductsScreenState createState() => _BrandProductsScreenState();
}

class _BrandProductsScreenState extends State<BrandProductsScreen> {
  List<Product> _products = [];
  List<Product> _allProducts = [];
  int _currentPage = 1;
  bool _isLoading = false;
  bool _hasMore = true;
  late ScrollController _scrollController;
  int _selectedIndex = 0;
  String _searchQuery = "";

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController()..addListener(_scrollListener);
    _fetchProducts();
  }

  @override
  void dispose() {
    _scrollController.removeListener(_scrollListener);
    _scrollController.dispose();
    super.dispose();
  }

  Future<ProductResponse> _getBrandProducts(String brandId, int page) async {
    String url =
        '${ConstantHelper.uri}api/filterSearch?brand_id=$brandId&per_page=10&page=$page';
    final response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      final Map<String, dynamic> jsonResponse = json.decode(response.body);
      return ProductResponse.fromJson(jsonResponse);
    } else {
      throw Exception('Failed to load products');
    }
  }

  void _scrollListener() {
    if (_scrollController.position.pixels ==
        _scrollController.position.maxScrollExtent) {
      _fetchProducts();
    }
  }

  Future<void> _fetchProducts() async {
    if (_isLoading || !_hasMore) return;

    setState(() {
      _isLoading = true;
    });

    try {
      final productResponse =
          await _getBrandProducts(widget.brandId, _currentPage);
      setState(() {
        _allProducts.addAll(productResponse.data.products);
        _filterProducts(_searchQuery);
        _currentPage++;
        _hasMore = _currentPage <= productResponse.data.lastPage;
      });
    } catch (e) {
      print(e);
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _filterProducts(String query) {
    setState(() {
      _searchQuery = query;
      if (query.isEmpty) {
        _products = _allProducts;
      } else {
        _products = _allProducts
            .where((product) =>
                product.productName
                    .toLowerCase()
                    .contains(query.toLowerCase()) ||
                product.productDescription
                    .toLowerCase()
                    .contains(query.toLowerCase()))
            .toList();
      }
    });
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
      switch (index) {
        case 0:
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => HomeView(),
            ),
          );
          break;
        case 1:
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => OrderScreen(),
            ),
          );
          break;
        case 2:
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => CompareScreen(products: []),
            ),
          );
          break;
        case 3:
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => CartScreen(),
            ),
          );
          break;
        case 4:
          Navigator.pushReplacement(
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(),
      body: Stack(
        children: [
          Column(
            children: [
              CustomSearchBar(
                onSearch: (query) {
                  _filterProducts(query);
                },
              ),
              BackButtonWidget(),
              Expanded(
                child: _products.isEmpty && _isLoading
                    ? Center(child: CircularProgressIndicator())
                    : _products.isEmpty
                        ? Center(child: Text('No products available'))
                        : Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              BrandProductHeader(),
                              Expanded(
                                child: GridView.builder(
                                  controller: _scrollController,
                                  gridDelegate:
                                      SliverGridDelegateWithFixedCrossAxisCount(
                                    crossAxisCount: 2, // Number of columns
                                    mainAxisSpacing: 10.0, // Space between rows
                                    crossAxisSpacing:
                                        10.0, // Space between columns
                                    childAspectRatio:
                                        0.8, // Adjust for card display
                                  ),
                                  itemCount:
                                      _products.length + (_isLoading ? 1 : 0),
                                  itemBuilder: (context, index) {
                                    if (index == _products.length) {
                                      return Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Center(
                                            child: CircularProgressIndicator()),
                                      );
                                    }

                                    final product = _products[index];
                                    return GestureDetector(
                                      onTap: () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) =>
                                                ProductDetailsScreen(
                                              image: product.productImage,
                                              name: product.productName,
                                              id: product.id,
                                              price:
                                                  product.productPrice ?? 0.0,
                                              variants: product.variants,
                                              description:
                                                  product.productDescription,
                                              technicalDataSheet:
                                                  product.technicalDataSheet ??
                                                      '',
                                            ),
                                          ),
                                        );
                                      },
                                      child: Card(
                                        elevation: 5,
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(20.0),
                                        ),
                                        child: Column(
                                          children: [
                                            Expanded(
                                              child: ClipRRect(
                                                borderRadius:
                                                    BorderRadius.vertical(
                                                        top: Radius.circular(
                                                            12.0)),
                                                child: Container(
                                                  width: double.infinity,
                                                  child: Image.network(
                                                    "${ConstantHelper.imguri}images/" +
                                                        product.productImage,
                                                    fit: BoxFit.cover,
                                                  ),
                                                ),
                                              ),
                                            ),
                                            Container(
                                              padding:
                                                  const EdgeInsets.all(8.0),
                                              color: Colors.grey[330],
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Text(
                                                    limitProductName(
                                                        product.productName, 3),
                                                    style: TextStyle(
                                                      fontSize: 14.0,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      overflow: TextOverflow
                                                          .ellipsis, // Handles long text
                                                    ),
                                                  ),
                                                  SizedBox(height: 4),
                                                  Text(
                                                    '\₹${product.productPrice}',
                                                    style: TextStyle(
                                                      fontSize:
                                                          12.0, // Smaller font size
                                                      color: Colors.grey[800],
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    );
                                  },
                                ),
                              ),
                              if (_isLoading)
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Center(
                                      child: CircularProgressIndicator()),
                                ),
                            ],
                          ),
              ),
            ],
          ),
          FilterButtonBrandScreen(),
        ],
      ),
      bottomNavigationBar: CustomBottomNavigationBar(
        selectedIndex: _selectedIndex,
        onTap: _onItemTapped,
      ),
    );
  }
}
