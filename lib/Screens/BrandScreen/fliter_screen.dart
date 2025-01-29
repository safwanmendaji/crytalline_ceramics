import 'package:flutter/material.dart';
import 'package:myshop_app/APIs/api_services.dart';
import 'package:myshop_app/Navigation%20and%20AppBar/navigation_bar.dart';
import 'package:myshop_app/Screens/BrandScreen/results_page.dart';
import 'package:myshop_app/Helper/string_helper.dart';
import 'package:myshop_app/Navigation%20and%20AppBar/app_bar.dart';
import 'package:myshop_app/Screens/Cart/cart_screen.dart';
import 'package:myshop_app/Screens/Compare/compare_screen.dart';
import 'package:myshop_app/Screens/Order/order_screen.dart';
import 'package:myshop_app/Screens/menu_screen.dart';
import 'package:myshop_app/Widgets/back_button.dart';

class FilterScreen extends StatefulWidget {
  @override
  _FilterScreenState createState() => _FilterScreenState();
}

class _FilterScreenState extends State<FilterScreen> {
  List<String> selectedBrandIds = [];
  List<Map<String, dynamic>> allBrands = [];
  List<Map<String, dynamic>> brands = [];
  List<String> selectedCategoryIds = [];
  List<Map<String, dynamic>> categories = [];
  bool isBrandDropdownOpen = false;
  bool isCategoryDropdownOpen = false;
  bool isLoading = false;
  int _selectedIndex = 0;
  @override
  void initState() {
    super.initState();
    _fetchBrands();
    _fetchCategories();
  }

  Future<void> _fetchBrands() async {
    try {
      List<Map<String, dynamic>> brands = await ApiServices.fetchBrandList();
      setState(() {
        allBrands = brands;
      });
    } catch (e) {
      _showErrorSnackBar('Error fetching brands');
    }
  }

  Future<void> _fetchCategories() async {
    try {
      List<Map<String, dynamic>> categoriesData =
          await ApiServices.fetchCategoryList();
      setState(() {
        categories = categoriesData;
      });
    } catch (e) {
      _showErrorSnackBar('Error fetching categories');
    }
  }

  void _showErrorSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  void _toggleSelection(List<String> selectedList, String id) {
    setState(() {
      if (selectedList.contains(id)) {
        selectedList.remove(id);
      } else {
        selectedList.add(id);
      }
    });
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

  Future<void> _applyFilters() async {
    setState(() {
      isLoading = true;
    });

    try {
      final result = await ApiServices.fetchFilterSearch(
        brandIds: selectedBrandIds,
        categoryIds: selectedCategoryIds,
        search: '',
        perPage: 10,
        page: 1,
      );

      setState(() {
        isLoading = false;
      });

      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => ResultScreen(results: result['data']['data']),
        ),
      );
    } catch (e) {
      _showErrorSnackBar('Error applying filters');
      setState(() {
        isLoading = false;
      });
    }
  }

  Widget _buildDropdown({
    required String title,
    required bool isOpen,
    required List<Map<String, dynamic>> items,
    required List<String> selectedItems,
    required ValueChanged<bool> onTap,
  }) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey),
        borderRadius: BorderRadius.circular(4.0),
      ),
      child: Column(
        children: [
          ListTile(
            title: Text(title, style: TextStyle(fontSize: 20)),
            trailing:
                Icon(isOpen ? Icons.arrow_drop_up : Icons.arrow_drop_down),
            onTap: () => onTap(!isOpen),
          ),
          if (isOpen)
            Column(
              children: items.map<Widget>((item) {
                return CheckboxListTile(
                  title: Text(item['name'] as String),
                  value: selectedItems.contains(item['id'] as String),
                  onChanged: (bool? value) {
                    if (value != null) {
                      _toggleSelection(selectedItems, item['id'] as String);
                    }
                  },
                );
              }).toList(),
            ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: CustomAppBar(),
        body: isLoading
            ? Center(child: CircularProgressIndicator())
            : Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  BackButtonWidget(),
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Text(
                      'Filter',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  Expanded(
                    child: SingleChildScrollView(
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _buildDropdown(
                              title: StringHelper.brand,
                              isOpen: isBrandDropdownOpen,
                              items: allBrands,
                              selectedItems: selectedBrandIds,
                              onTap: (value) {
                                setState(() {
                                  isBrandDropdownOpen = value;
                                });
                              },
                            ),
                            SizedBox(height: 20),
                            _buildDropdown(
                              title: 'Categories',
                              isOpen: isCategoryDropdownOpen,
                              items: categories,
                              selectedItems: selectedCategoryIds,
                              onTap: (value) {
                                setState(() {
                                  isCategoryDropdownOpen = value;
                                });
                              },
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        ElevatedButton(
                          onPressed: _applyFilters,
                          child: isLoading
                              ? CircularProgressIndicator()
                              : Text('Apply'),
                          style: ElevatedButton.styleFrom(
                            foregroundColor: Colors.white,
                            backgroundColor: Colors.brown,
                          ),
                        ),
                        ElevatedButton(
                          onPressed: () {
                            setState(() {
                              selectedBrandIds.clear();
                              selectedCategoryIds.clear();
                              isBrandDropdownOpen = false;
                              isCategoryDropdownOpen = false;
                            });
                          },
                          child: Text('Reset'),
                          style: ElevatedButton.styleFrom(
                            foregroundColor: Colors.white,
                            backgroundColor: Colors.grey,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
        bottomNavigationBar: CustomBottomNavigationBar(
            selectedIndex: _selectedIndex, onTap: _onItemTapped),
      ),
    );
  }
}
