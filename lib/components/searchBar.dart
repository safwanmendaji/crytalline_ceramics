import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:async';

import 'package:myshop_app/Helper/constants.dart';

class CustomSearchBar extends StatefulWidget {
  final void Function(String query) onSearch;

  const CustomSearchBar({Key? key, required this.onSearch}) : super(key: key);

  @override
  State<CustomSearchBar> createState() => _CustomSearchBarState();
}

class _CustomSearchBarState extends State<CustomSearchBar> {
  TextEditingController _searchController = TextEditingController();
  bool _isLoading = false;
  Timer? _debounce;

  Future<void> _searchItems(String query) async {
    if (query.isEmpty) {
      widget.onSearch('');
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      final response = await http.get(
          Uri.parse('${ConstantHelper.uri}api/filterSearch?search=$query'));

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        widget.onSearch(query);
      } else {
        _showError('Failed to load search results');
      }
    } catch (e) {
      _showError('Error occurred: $e');
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _onSearchChanged(String query) {
    if (_debounce?.isActive ?? false) _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 500), () {
      _searchItems(query);
    });
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  @override
  void initState() {
    super.initState();
    _searchController.addListener(() {
      _onSearchChanged(_searchController.text);
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    _debounce?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: TextField(
        controller: _searchController,
        decoration: InputDecoration(
          hintText: "Search",
          prefixIcon: Icon(Icons.search, color: Colors.brown[500]),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10.0),
          ),
          contentPadding: const EdgeInsets.symmetric(vertical: 10.0),
        ),
      ),
    );
  }
}
