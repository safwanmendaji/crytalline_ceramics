import 'package:flutter/material.dart';
import 'package:myshop_app/Helper/constants.dart';
import 'package:myshop_app/Helper/string_helper.dart';
import 'package:myshop_app/Models/product_model.dart';
import 'package:myshop_app/Screens/Product/product_detail_screen.dart';

class HomeProduct extends StatelessWidget {
  final List<Product> products;

  HomeProduct({required this.products});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: GridView.builder(
        shrinkWrap: true,
        physics: NeverScrollableScrollPhysics(),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          mainAxisSpacing: 10.0,
          crossAxisSpacing: 10.0,
          childAspectRatio: 0.8,
        ),
        itemCount: products.length,
        itemBuilder: (context, index) {
          final product = products[index];
          return GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ProductDetailsScreen(
                    id: product.id,
                    image: product.productImage,
                    name: product.productName,
                    description: product.productDescription,
                    variants: product.variants,
                    price: product.productPrice ?? 0.0,
                    technicalDataSheet: product.technicalDataSheet ?? '',
                  ),
                ),
              );
            },
            child: Card(
              elevation: 5,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20.0),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: ClipRRect(
                      borderRadius:
                          BorderRadius.vertical(top: Radius.circular(12.0)),
                      child: Container(
                        width: double.infinity,
                        child: Image.network(
                          "${ConstantHelper.imguri}images/" +
                              product.productImage,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) {
                            return Center(
                              child: Icon(Icons.broken_image,
                                  size: 50, color: Colors.grey),
                            );
                          },
                        ),
                      ),
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.all(8.0),
                    color: Colors.grey[330],
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          limitProductName(product.productName, 3),
                          style: TextStyle(
                            fontSize: 14.0,
                            fontWeight: FontWeight.bold,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        SizedBox(height: 4),
                        Text(
                          '\₹${product.productPrice}',
                          style: TextStyle(
                            fontSize: 12.0,
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
    );
  }
}
