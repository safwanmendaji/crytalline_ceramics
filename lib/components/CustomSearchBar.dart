// import 'package:flutter/material.dart'; // For Flutter UI components and widgets
// import 'package:myshop_app/Helper/constants.dart'; // For ConstantHelper class or other constants

// class CustomSearchBar extends StatelessWidget {
//   final Function(String) onSearch;
//   final List<Map<String, dynamic>> selectedProducts;

//   CustomSearchBar({required this.onSearch, this.selectedProducts = const []});

//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       children: [
//         TextField(
//           onChanged: onSearch,
//           decoration: InputDecoration(
//             hintText: 'Search for products',
//             suffixIcon: Icon(Icons.search),
//           ),
//         ),
//         SizedBox(height: 8.0),
//         if (selectedProducts.isNotEmpty) ...[
//           Text('Selected Products',
//               style: TextStyle(fontWeight: FontWeight.bold)),
//           // Display selected products
//           Container(
//             height: 100,
//             child: ListView.builder(
//               scrollDirection: Axis.horizontal,
//               itemCount: selectedProducts.length,
//               itemBuilder: (context, index) {
//                 final product = selectedProducts[index];
//                 return Card(
//                   child: Row(
//                     children: [
//                       Image.network(
//                         '${ConstantHelper.uri}/images/${product['product_image']}',
//                         width: 60,
//                         height: 60,
//                         fit: BoxFit.cover,
//                       ),
//                       SizedBox(width: 8.0),
//                       Text(product['product_name'] ?? 'No Name'),
//                     ],
//                   ),
//                 );
//               },
//             ),
//           ),
//         ],
//       ],
//     );
//   }
// }
