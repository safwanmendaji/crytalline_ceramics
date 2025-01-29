import 'package:flutter/material.dart';
import 'package:myshop_app/APIs/api_services.dart';
import 'package:myshop_app/Models/achivement_model.dart';
import 'package:myshop_app/Screens/HomeScreen/high_achievement.dart';
import 'package:myshop_app/Screens/HomeScreen/home_brand.dart';
import 'package:myshop_app/Screens/HomeScreen/home_carousel.dart';
import 'package:myshop_app/Models/product_model.dart';
import 'package:myshop_app/Screens/Cart/cart_screen.dart';
import 'package:myshop_app/Helper/string_helper.dart';
import 'package:myshop_app/Navigation%20and%20AppBar/app_bar.dart';
import 'package:myshop_app/Navigation%20and%20AppBar/navigation_bar.dart';
import 'package:myshop_app/Screens/Compare/compare_screen.dart';
import 'package:myshop_app/Screens/HomeScreen/new_target_acheivement.dart';
import 'package:myshop_app/Screens/HomeScreen/year_achievement.dart';
import 'package:myshop_app/Helper/constants.dart';
import 'package:myshop_app/Screens/Login/login_page.dart';
import 'package:myshop_app/Screens/menu_screen.dart';
import 'package:myshop_app/Screens/Order/order_screen.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class HomeView extends StatefulWidget {
  @override
  _HomeViewState createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  List<String> imgList = [];
  bool isLoading = true;
  List<Map<String, dynamic>> brands = [];
  List<Product> _products = [];
  List<Product> _allProducts = [];
  Map<String, dynamic> _achivement = {};
  late int _total_purchase_amount;
  int lastTargetAmount = 0;
  bool _isLoading = false;
  int _selectedIndex = 0;
  int _currentPage = 1;
  bool _hasMore = true;
  late ScrollController _scrollController;
  String _searchQuery = "";
  Map<String, dynamic> OfferInfo = {};
  List<OfferData> offerList = [];
  int userStatus = 1;
  double currentAmount = 0.0;

  @override
  void initState() {
    super.initState();
    _fetchBanners();
    _fetchBrandList();
    _scrollController = ScrollController()..addListener(_scrollListener);
    _fetchProducts();
    _getAchievement();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      try {
        await checkActiveStatus();
      } catch (e) {
        print("Error in checkActiveStatus: $e");
      }
    });
  }

  @override
  void dispose() {
    _scrollController.removeListener(_scrollListener);
    _scrollController.dispose();
    super.dispose();
  }

  Future<void> _getAchievement() async {
    final prefs = await SharedPreferences.getInstance();
    final userId =
        prefs.getString('userid') ?? '0'; // Ensure userId is a string.
    final url = Uri.parse('${ConstantHelper.uri}api/get_achievement/$userId');

    try {
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final Map<String, dynamic> decodedResponse = jsonDecode(response.body);
        _total_purchase_amount =
            decodedResponse['data']['offer_info']['total_purchase_amount'];
//this function is used to get last index targetamount
        final List<dynamic> dataList = decodedResponse['data']['data'];

        if (dataList.isNotEmpty) {
          final Map<String, dynamic> lastItem = dataList.last;
          lastTargetAmount = lastItem['target_amount'];
          //print(lastTargetAmount);

          //print('Last Target Amount: $lastTargetAmount');
        } else {
          print('Data array is empty.');
        }

        _achivement = getEligibleOffer(decodedResponse);
      } else {
        throw Exception('Failed to load achievement data');
      }
    } catch (e) {
      print('Error fetching achievement data: $e');
      throw Exception('Failed to load achievement data');
    }
  }

  Map<String, dynamic> getEligibleOffer(Map<String, dynamic> response) {
    final totalPurchaseAmount =
        response['data']['offer_info']['total_purchase_amount'];
    // print(totalPurchaseAmount);
    final offers = List<Map<String, dynamic>>.from(response['data']['data']);

    // Sort the offers based on the 'target_amount' field
    offers.sort((a, b) => (a['target_amount']).compareTo((b['target_amount'])));

    Map<String, dynamic>? eligibleOffer;

    for (var offer in offers) {
      if (totalPurchaseAmount >= offer['target_amount']) {
        eligibleOffer = offer;
      } else {
        break;
      }
    }

    return eligibleOffer ?? response['data']['data'][0];
  }

//Check active user api call
  Future<void> checkActiveStatus() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final userId = prefs.getString('userid');

      if (userId == null) {
        await clearSession();
        _redirectToLogin();
        return;
      }

      final url =
          Uri.parse("${ConstantHelper.uri}api/user_active_status/$userId");

      final response = await http.get(url);

      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData = json.decode(response.body);
        // print(responseData);
        final userStatus = responseData['data']['user_status'];
        // print(userStatus);

        if (userStatus != 1) {
          await clearSession();
          _redirectToLogin();
        }
      } else {
        print("API Error: Status Code ${response.statusCode}");
      }
    } catch (e) {
      print("Error checking active status: $e");
    }
  }

//Redirect To Login Page
  void _redirectToLogin() {
    Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (context) => LoginPage()));
  }

//Fetch Product
  Future<ProductResponse> _getBrandProducts(int page) async {
    String url = '${ConstantHelper.uri}api/filterSearch?per_page=10&page=$page';

    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      final Map<String, dynamic> jsonResponse = json.decode(response.body);
      return ProductResponse.fromJson(jsonResponse);
    } else {
      throw Exception('Failed to load products');
    }
  }

//Clear local Storage data
  Future<void> clearSession() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
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
      final productResponse = await _getBrandProducts(_currentPage);
      setState(() {
        _allProducts.addAll(productResponse.data.products.where((product) {
          return product.variants.every((variant) => variant.colour != null);
        }).toList());
        _currentPage++;
        _hasMore = _currentPage <= productResponse.data.lastPage;
        _filterProducts(_searchQuery);
      });
    } catch (e) {
      print(e);
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _fetchBrandList() async {
    try {
      List<Map<String, dynamic>> fetchedBrands =
          await ApiServices.fetchBrandList();
      setState(() {
        brands = fetchedBrands;
      });
    } catch (e) {
      print('Error fetching brands: $e');
    }
  }

  Future<void> _fetchBanners() async {
    ApiServices apiService = ApiServices();
    try {
      List<String> images = await apiService.fetchBanners();
      setState(() {
        imgList = images;
        isLoading = false;
      });
    } catch (e) {
      print('Error fetching banners: $e');
      setState(() {
        isLoading = false;
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

  void _addToCart(Map<String, dynamic> product) {
    setState(() {});
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("${product['name']} added to cart")),
    );
  }

  void _filterProducts(String query) {
    if (query.isEmpty) {
      setState(() {
        _products = _allProducts;
      });
    } else {
      setState(() {
        _products = _allProducts
            .where((product) =>
                product.productName
                    .toLowerCase()
                    .contains(query.toLowerCase()) ||
                product.productDescription
                    .toLowerCase()
                    .contains(query.toLowerCase()))
            .toList();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : Container(
              color: Colors.white,
              child: SingleChildScrollView(
                controller: _scrollController,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    HomeCarousel(imgList: imgList),
                    Divider(
                      thickness: 2,
                      color: Colors.black,
                    ),
                    Padding(
                      padding: const EdgeInsets.all(6.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            StringHelper.brand,
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            ),
                          ),
                          // Icon(
                          //   Icons.arrow_forward,
                          //   size: 18,
                          //   color: Colors.black,
                          // ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 10.0),
                      child: HomeBrand(brands: brands),
                    ),
                    SizedBox(
                      height: 3,
                    ),
                    Divider(
                      thickness: 2,
                      color: Colors.black,
                    ),
                    Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Text(
                        'Goals & Achievement',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    AchievementProgressBar(
                      achievedPercentage: _achivement['achieved_percentage'],
                      currentAmount: _total_purchase_amount,
                      targetAmount: _achivement['target_amount'],
                      remainingAmount: _achivement['remaining_amount'],
                    ),
                    YearAchievement(
                      highestTargetAmount: lastTargetAmount,
                      totalPurchaseAmount: _total_purchase_amount,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(right: 18),
                          child: InkWell(
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        NewTargetAchievement(),
                                  ));
                            },
                            child: Container(
                              height: 50,
                              width: 150,
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  colors: [
                                    // Color(0xFF00C6FF),
                                    // Color(0xFF0072FF)
                                    Colors.orange,
                                    Colors.green
                                  ],
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                ),
                                borderRadius: BorderRadius.only(
                                  bottomRight: Radius.circular(50),
                                  topLeft: Radius.circular(50),
                                ),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.3),
                                    blurRadius: 10,
                                    offset: Offset(0, 6),
                                  ),
                                ],
                              ),
                              child: Center(
                                child: Text(
                                  StringHelper.showMore,
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 15,
                                    //color: Colors.white),
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
      bottomNavigationBar: CustomBottomNavigationBar(
        selectedIndex: _selectedIndex,
        onTap: _onItemTapped,
      ),
    );
  }
}
