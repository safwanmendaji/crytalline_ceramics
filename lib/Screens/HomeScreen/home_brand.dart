import 'package:flutter/material.dart';
import 'package:myshop_app/Screens/BrandScreen/brand_screen.dart';

class HomeBrand extends StatefulWidget {
  final List<Map<String, dynamic>> brands;
  HomeBrand({required this.brands});

  @override
  _HomeBrandState createState() => _HomeBrandState();
}

class _HomeBrandState extends State<HomeBrand> {
  final ScrollController _scrollController = ScrollController();
  bool _isAtStart = true;
  bool _isAtEnd = false;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_scrollListener);
  }

  void _scrollListener() {
    setState(() {
      _isAtStart = _scrollController.offset <= 0;
      _isAtEnd = _scrollController.position.maxScrollExtent ==
          _scrollController.offset;
    });
  }

  void _scrollLeft() {
    if (!_isAtStart) {
      _scrollController.animateTo(
        _scrollController.offset - 200,
        duration: Duration(milliseconds: 300),
        curve: Curves.ease,
      );
    }
  }

  void _scrollRight() {
    if (!_isAtEnd) {
      _scrollController.animateTo(
        _scrollController.offset + 400,
        duration: Duration(milliseconds: 300),
        curve: Curves.ease,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        SizedBox(
          height: 90,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            controller: _scrollController,
            itemCount: widget.brands.length,
            itemBuilder: (context, index) {
              return InkWell(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => BrandProductsScreen(
                        brandId: widget.brands[index]['id'],
                      ),
                    ),
                  );
                },
                child: Container(
                  margin: EdgeInsets.symmetric(horizontal: 5.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Container(
                        width: 60,
                        height: 60,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          image: DecorationImage(
                            image: NetworkImage(widget.brands[index]['image']),
                            fit: BoxFit.contain,
                          ),
                        ),
                      ),
                      SizedBox(height: 5),
                      Text(
                        widget.brands[index]['name'],
                        style: TextStyle(
                          fontSize: 9,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),

        // Left scroll button - hidden if at the start
        if (!_isAtStart)
          Positioned(
            left: 0,
            top: 0,
            bottom: 0,
            child: IconButton(
              icon: Icon(Icons.arrow_back_ios),
              onPressed: _scrollLeft,
            ),
          ),

        // Right scroll button - hidden if at the end
        if (!_isAtEnd)
          Positioned(
            right: 0,
            top: 0,
            bottom: 0,
            child: IconButton(
              icon: Icon(Icons.arrow_forward_ios),
              onPressed: _scrollRight,
            ),
          ),
      ],
    );
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }
}
