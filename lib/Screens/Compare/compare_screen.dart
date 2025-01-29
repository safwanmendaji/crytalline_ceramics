import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:myshop_app/Helper/constants.dart';
import 'package:myshop_app/Screens/Cart/cart_screen.dart';
import 'package:myshop_app/Screens/HomeScreen/home_view.dart';
import 'package:myshop_app/Screens/Order/order_screen.dart';
import 'package:myshop_app/Screens/menu_screen.dart';
import 'package:myshop_app/Navigation%20and%20AppBar/app_bar.dart';
import 'package:myshop_app/Navigation%20and%20AppBar/navigation_bar.dart';
import 'package:myshop_app/components/searchBar.dart';

class CompareScreen extends StatefulWidget {
  final List<Map<String, dynamic>> products;

  CompareScreen({required this.products});

  @override
  _CompareScreenState createState() => _CompareScreenState();
}

class _CompareScreenState extends State<CompareScreen> {
  int _selectedIndex = 2;
  List<int> _selectedProducts = [];
  List<Map<String, dynamic>> _searchResults = [];
  List<Map<String, dynamic>> _recommendedProducts = [];
  bool _isLoadingRecommendedProducts = false;
  bool _isLoading = true;
  Map<String, dynamic>? _comparisonPoints;
  int page = 1;
  final int _perPage = 10;
  bool _hasMore = true;
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _fetchAllProducts();
    _scrollController.addListener(() {
      if (_scrollController.position.pixels ==
              _scrollController.position.maxScrollExtent &&
          !_isLoading &&
          _hasMore) {
        setState(() {
          _isLoading = true;
          page++;
        });
        _fetchAllProducts();
      }
    });
  }

  Future<void> _fetchAllProducts() async {
    try {
      final results = await _searchProducts('', page);
      setState(() {
        _searchResults.addAll(results);
        _isLoading = false;
        if (results.length < _perPage) {
          _hasMore = false;
        }
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      print('Error fetching products: $e');
    }
  }

  Future<List<Map<String, dynamic>>> _searchProducts(
      String query, int page) async {
    String url =
        '${ConstantHelper.uri}api/filterSearch?search=$query&per_page=$_perPage&page=$page';

    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      final Map<String, dynamic> jsonResponse = json.decode(response.body);
      return List<Map<String, dynamic>>.from(jsonResponse['data']['data']);
    } else {
      throw Exception('Failed to load products');
    }
  }

  Future<void> _fetchRecommendedProducts(String productId) async {
    String url =
        '${ConstantHelper.uri}api/findCompare_recommendProduct/$productId';
    setState(() {
      _isLoadingRecommendedProducts = true;
    });

    try {
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        final Map<String, dynamic> jsonResponse = json.decode(response.body);

        if (jsonResponse.containsKey('data') && jsonResponse['data'] != null) {
          final recommendedData = jsonResponse['data'] as Map<String, dynamic>;

          setState(() {
            _recommendedProducts = recommendedData.values
                .where((item) => item != null)
                .map((item) => Map<String, dynamic>.from(item))
                .toList();
          });
        } else {
          print('No "data" key found in response or data is null');
          setState(() {
            _recommendedProducts = [];
          });
        }
      } else {
        throw Exception('Failed to load recommended products');
      }
    } catch (e) {
      print('Failed to load recommended products: $e');
    } finally {
      setState(() {
        _isLoadingRecommendedProducts = false;
      });
    }
  }

  void _onSearch(String query) async {
    if (query.isNotEmpty) {
      setState(() {
        _searchResults = [];
        _isLoading = true;
      });

      try {
        final results =
            await _searchProducts(query, 1); // Reset page to 1 on new search
        if (results.isEmpty) {
          throw Exception('No products found');
        }
        setState(() {
          _searchResults = results;
          page = 1; // Reset page number
        });
        if (_selectedProducts.isNotEmpty) {
          await _fetchRecommendedProducts(
              _searchResults[_selectedProducts[0]]['id'].toString());
        }
      } catch (e) {
        setState(() {
          _searchResults = [];
        });
      } finally {
        setState(() {
          _isLoading = false;
        });
      }
    } else {
      setState(() {
        _searchResults = [];
        _isLoading = false;
      });
    }
  }

  void _toggleSelection(int index, {bool isRecommended = false}) {
    setState(() {
      if (isRecommended) {
        final product = _recommendedProducts[index];
        final searchIndex = _searchResults.indexWhere((element) =>
            element['id'] == product['id'] &&
            element['product_name'] == product['product_name']);

        if (searchIndex == -1) {
          // Product not found in search results, add it
          _searchResults.add(product);
          _selectedProducts.add(_searchResults.length - 1);
          if (_selectedProducts.length == 2) {
            // Remove the other products from the recommended list and only keep the selected one
            _recommendedProducts = [_recommendedProducts[index]];
          }
        } else {
          if (_selectedProducts.length < 2) {
            _selectedProducts.add(searchIndex);
            if (_selectedProducts.length == 2) {
              // Remove the other products from the recommended list and only keep the selected one
              _recommendedProducts = [_recommendedProducts[index]];
            }
          }
        }
      } else {
        if (_selectedProducts.contains(index)) {
          _selectedProducts.remove(index);
        } else {
          if (_selectedProducts.length < 2) {
            _selectedProducts.add(index);
            if (_selectedProducts.length == 1) {
              _fetchRecommendedProducts(
                  _searchResults[_selectedProducts[0]]['id'].toString());
            }
          }
        }
      }
    });
  }

  void _removeProduct(int index) {
    setState(() {
      _selectedProducts.remove(index);

      // Reset comparison points when a product is removed
      _comparisonPoints = null;

      if (_selectedProducts.isEmpty) {
        _recommendedProducts.clear();
        _isLoadingRecommendedProducts = false;
        _fetchAllProducts(); // Show all products again when both are removed
      } else if (_selectedProducts.length == 1) {
        _fetchRecommendedProducts(
            _searchResults[_selectedProducts[0]]['id'].toString());
      }
    });
  }

  Future<void> _compareProducts() async {
    if (_selectedProducts.length == 2) {
      final productId1 = _searchResults[_selectedProducts[0]]['id'];
      final productId2 = _searchResults[_selectedProducts[1]]['id'];

      String url =
          '${ConstantHelper.uri}api/compare_products?product_id1=$productId1&product_id2=$productId2';

      try {
        final response = await http.get(Uri.parse(url));
        if (response.statusCode == 200) {
          final Map<String, dynamic> jsonResponse = json.decode(response.body);
          final comparisonData = jsonResponse['data'];

          setState(() {
            _comparisonPoints = comparisonData;
          });
        } else {
          throw Exception('Failed to compare products');
        }
      } catch (e) {
        print('Failed to compare products: $e');
      }
    }
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
      switch (index) {
        case 0:
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => HomeView()),
          );
          break;
        case 1:
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => OrderScreen()),
          );
          break;
        case 2:
          break;
        case 3:
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => CartScreen()),
          );
          break;
        case 4:
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => MenuScreen()),
          );
          break;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(),
      body: SingleChildScrollView(
        controller: _scrollController,
        child: Column(
          children: [
            CustomSearchBar(onSearch: _onSearch),
            SizedBox(height: 8.0),
            if (_selectedProducts.isNotEmpty) _buildSelectedProductsCard(),
            SizedBox(height: 8.0),
            if (_comparisonPoints != null && _selectedProducts.length == 2)
              _buildComparisonPointsTable(),
            if (_selectedProducts.isEmpty) _buildSearchResultsGrid(),
            if (_selectedProducts.isNotEmpty || _comparisonPoints == null)
              _buildRecommendedProductsGrid(),
            if (_selectedProducts.length == 2)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 16.0),
                child: ElevatedButton(
                  onPressed: _compareProducts,
                  child: Text('Compare',
                      style: TextStyle(
                          fontWeight: FontWeight.normal, color: Colors.white)),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.brown,
                    padding:
                        EdgeInsets.symmetric(vertical: 12.0, horizontal: 20.0),
                    textStyle: TextStyle(fontSize: 16),
                  ),
                ),
              ),
          ],
        ),
      ),
      bottomNavigationBar: CustomBottomNavigationBar(
        selectedIndex: _selectedIndex,
        onTap: _onItemTapped,
      ),
    );
  }

  Widget _buildSelectedProductsCard() {
    return Container(
      padding: EdgeInsets.all(8.0),
      color: Colors.grey[200],
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Selected Products',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 8.0),
          Column(
            children: [
              for (var index in _selectedProducts)
                Card(
                  margin: EdgeInsets.symmetric(vertical: 4.0),
                  elevation: 2.0,
                  child: ListTile(
                    leading: Image.network(
                      '${ConstantHelper.imguri}images/${_searchResults[index]['product_image']}',
                      fit: BoxFit.cover,
                      width: 50,
                      height: 50,
                      loadingBuilder: (context, child, progress) {
                        if (progress == null) return child;
                        return Center(child: CircularProgressIndicator());
                      },
                    ),
                    title: Text(_searchResults[index]['product_name']),
                    trailing: IconButton(
                      icon: Icon(Icons.remove_circle),
                      onPressed: () => _removeProduct(index),
                    ),
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildComparisonPointsTable() {
    if (_comparisonPoints == null) {
      return Center(child: Text('No comparison data available.'));
    }

    final product1 = _comparisonPoints!['product1'];
    final product2 = _comparisonPoints!['product2'];

    // Extract comparison points from the response
    final points = [
      'point_1',
      'point_2',
      'point_3',
      'point_4',
      'point_5',
      'point_6'
    ];

    return Container(
      padding: EdgeInsets.all(8.0),
      child: Table(
        border: TableBorder.all(),
        columnWidths: {
          0: FlexColumnWidth(3),
          1: FlexColumnWidth(2),
          2: FlexColumnWidth(2),
        },
        children: [
          TableRow(
            children: [
              TableCell(
                child: Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Text('Attribute',
                      style: TextStyle(
                          fontWeight: FontWeight.bold, color: Colors.brown)),
                ),
              ),
              TableCell(
                child: Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Text(product1['product_name'] ?? 'Product 1',
                      style: TextStyle(
                          fontWeight: FontWeight.bold, color: Colors.brown)),
                ),
              ),
              TableCell(
                child: Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Text(product2['product_name'] ?? 'Product 2',
                      style: TextStyle(
                          fontWeight: FontWeight.bold, color: Colors.brown)),
                ),
              ),
            ],
          ),
          ...points.map((point) {
            final value1 =
                product1['comparision_point_details'][point] ?? 'N/A';
            final value2 =
                product2['comparision_point_details'][point] ?? 'N/A';

            return TableRow(
              children: [
                TableCell(
                  child: Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Text(point.replaceAll('point_', 'Point '),
                        style: TextStyle(
                            fontWeight: FontWeight.normal,
                            color: Colors.blueAccent)),
                  ),
                ),
                TableCell(
                  child: Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Text(value1,
                        style: TextStyle(fontWeight: FontWeight.normal)),
                  ),
                ),
                TableCell(
                  child: Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Text(value2,
                        style: TextStyle(fontWeight: FontWeight.normal)),
                  ),
                ),
              ],
            );
          }).toList(),
        ],
      ),
    );
  }

  Widget _buildSearchResultsGrid() {
    return _isLoading && _searchResults.isEmpty
        ? Center(child: CircularProgressIndicator())
        : GridView.builder(
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              childAspectRatio: 0.75,
            ),
            itemCount: _searchResults.length + (_hasMore ? 1 : 0),
            itemBuilder: (context, index) {
              if (index == _searchResults.length) {
                return Center(child: CircularProgressIndicator());
              }
              final product = _searchResults[index];
              return GestureDetector(
                onTap: () => _toggleSelection(index),
                child: Card(
                  elevation: 2.0,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Image.network(
                          '${ConstantHelper.imguri}images/${product['product_image']}',
                          fit: BoxFit.cover,
                          width: double.infinity,
                          loadingBuilder: (context, child, progress) {
                            if (progress == null) return child;
                            return Center(child: CircularProgressIndicator());
                          },
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Text(product['product_name']),
                      ),
                    ],
                  ),
                ),
              );
            },
          );
  }

  Widget _buildRecommendedProductsGrid() {
    return _isLoadingRecommendedProducts
        ? Center(child: CircularProgressIndicator())
        : GridView.builder(
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              childAspectRatio: 0.75,
            ),
            itemCount: _recommendedProducts.length,
            itemBuilder: (context, index) {
              final product = _recommendedProducts[index];
              final searchIndex = _searchResults.indexWhere((element) =>
                  element['id'] == product['id'] &&
                  element['product_name'] == product['product_name']);

              // Skip rendering this product if it's already selected
              if (_selectedProducts.contains(searchIndex)) {
                return Container();
              }

              return GestureDetector(
                onTap: () => _toggleSelection(index, isRecommended: true),
                child: Card(
                  elevation: 2.0,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Image.network(
                          '${ConstantHelper.imguri}images/${product['product_image']}',
                          fit: BoxFit.cover,
                          width: double.infinity,
                          loadingBuilder: (context, child, progress) {
                            if (progress == null) return child;
                            return Center(child: CircularProgressIndicator());
                          },
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Text(product['product_name']),
                      ),
                    ],
                  ),
                ),
              );
            },
          );
  }
}
