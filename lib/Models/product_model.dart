class ProductResponse {
  final Data data;

  ProductResponse({required this.data});

  factory ProductResponse.fromJson(Map<String, dynamic> json) {
    return ProductResponse(
      data: Data.fromJson(json['data']),
    );
  }
}

class Data {
  final int currentPage;
  final List<Product> products;
  final int lastPage;

  Data(
      {required this.currentPage,
      required this.products,
      required this.lastPage});

  factory Data.fromJson(Map<String, dynamic> json) {
    return Data(
      currentPage: json['current_page'],
      products:
          List<Product>.from(json['data'].map((x) => Product.fromJson(x))),
      lastPage: json['last_page'],
    );
  }
}

class Product {
  final int id;
  final int brandId;
  final int categoryId;
  final String productName;
  final String productDescription;
  final String productImage;
  final DateTime createdAt;
  final DateTime updatedAt;
  final String? technicalDataSheet;
  final List<Variant> variants;

  Product({
    required this.id,
    required this.brandId,
    required this.categoryId,
    required this.productName,
    required this.productDescription,
    required this.productImage,
    required this.createdAt,
    required this.updatedAt,
    required this.technicalDataSheet,
    required this.variants,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['id'],
      brandId: json['brand_id'],
      categoryId: json['category_id'],
      productName: json['product_name'],
      productDescription: json['product_description'],
      productImage: json['product_image'],
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: DateTime.parse(json['updated_at']),
      technicalDataSheet: json['technical_data_sheet'],
      variants:
          List<Variant>.from(json['variants'].map((x) => Variant.fromJson(x)))
              .toList(),
    );
  }

  // Getter to retrieve the product price
  double? get productPrice {
    // If no variants or all variants have no price, return null
    if (variants.isEmpty) return null;

    // Extract prices from variants
    List<double> prices = variants
        .where((variant) => variant.colour?.variant.isNotEmpty ?? false)
        .expand((variant) => variant.colour?.variant ?? [])
        .map((variantDetail) => double.tryParse(variantDetail.price) ?? 0.0)
        .toList();

    // Return the lowest price, or null if no valid prices are found
    if (prices.isEmpty) return null;
    return prices.reduce((a, b) => a < b ? a : b);
  }
}

class Variant {
  final Colour colour;

  Variant({required this.colour});

  factory Variant.fromJson(Map<String, dynamic> json) {
    return Variant(
      // product_variant_id:
      // json['product_variant_id'] != null ? json['product_variant_id'] : 0,
      colour: Colour.fromJson(json['colour']),
    );
  }

  get price => null;
}

class Colour {
  final int? id;
  final String? colourName;
  final List<VariantDetail> variant;

  Colour({this.id, this.colourName, required this.variant});

  factory Colour.fromJson(Map<String, dynamic> json) {
    return Colour(
      id: json['id'],
      colourName: json['colour_name'],
      variant: List<VariantDetail>.from(
          json['variant'].map((x) => VariantDetail.fromJson(x))).toList(),
    );
  }
}

class VariantDetail {
  final int id;
  final String variantName;
  final String price;
  final int product_variant_id;
  final bool stockAvailable;

  VariantDetail(
      {required this.id,
      required this.variantName,
      required this.price,
      required this.product_variant_id,
      required this.stockAvailable});

  factory VariantDetail.fromJson(Map<String, dynamic> json) {
    return VariantDetail(
      id: json['id'],
      variantName: json['variant_name'],
      price: json['price'],
      product_variant_id: json['product_variant_id'],
      stockAvailable: json['stock_available'],
    );
  }
}

class Brand {
  final String id;
  final String name;

  Brand({required this.id, required this.name});

  factory Brand.fromJson(Map<String, dynamic> json) {
    return Brand(
      id: json['id'],
      name: json['name'],
    );
  }
}
