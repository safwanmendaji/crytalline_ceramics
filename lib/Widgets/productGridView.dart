import 'package:flutter/material.dart';
import 'package:myshop_app/Models/product_model.dart';
import 'package:myshop_app/Helper/constants.dart';
import 'package:myshop_app/Widgets/productGridView.dart';

class ProductGridView extends StatelessWidget {
  final List<Product> products;
  final Function(int) onProductSelected;
  final List<int> selectedProducts;

  ProductGridView({
    required this.products,
    required this.onProductSelected,
    this.selectedProducts = const [],
  });

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        mainAxisSpacing: 10.0,
        crossAxisSpacing: 10.0,
      ),
      itemCount: products.length,
      itemBuilder: (context, index) {
        final product = products[index];
        final isSelected =
            selectedProducts.contains(product.id); // Adjusted to use product ID

        return GestureDetector(
          onTap: () => onProductSelected(index),
          child: Card(
            elevation: 4,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10.0),
            ),
            color: isSelected
                ? Colors.blueAccent
                : Colors.white, // Highlight selected products
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: ClipRRect(
                    borderRadius:
                        BorderRadius.vertical(top: Radius.circular(10)),
                    child: product.productImage.isNotEmpty
                        ? Image.network(
                            "${ConstantHelper.imguri}images/${product.productImage}",
                            fit: BoxFit.cover,
                            width: double.infinity,
                            errorBuilder: (context, error, stackTrace) {
                              return Center(
                                child: Icon(Icons.broken_image,
                                    size: 50, color: Colors.grey),
                              );
                            },
                          )
                        : Center(
                            child: Icon(Icons.image_not_supported,
                                size: 50, color: Colors.grey),
                          ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        product.productName.isNotEmpty
                            ? product.productName
                            : 'No Name',
                        style: TextStyle(
                            fontSize: 16.0, fontWeight: FontWeight.bold),
                      ),
                      SizedBox(height: 4),
                      Text(
                        product.productPrice != null
                            ? '\₹${product.productPrice}'
                            : 'Price Unavailable',
                        style:
                            TextStyle(fontSize: 14.0, color: Colors.grey[800]),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
