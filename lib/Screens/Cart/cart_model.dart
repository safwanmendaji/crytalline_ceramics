class Brand {
  int id;
  String brandName;
  String brandImage;
  DateTime createdAt;
  DateTime updatedAt;

  Brand({
    required this.id,
    required this.brandName,
    required this.brandImage,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Brand.fromJson(Map<String, dynamic> json) {
    return Brand(
      id: json['id'],
      brandName: json['brand_name'],
      brandImage: json['brand_image'],
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: DateTime.parse(json['updated_at']),
    );
  }
}

class Category {
  int id;
  String categoryName;
  DateTime createdAt;
  DateTime updatedAt;

  Category({
    required this.id,
    required this.categoryName,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Category.fromJson(Map<String, dynamic> json) {
    return Category(
      id: json['id'],
      categoryName: json['category_name'],
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: DateTime.parse(json['updated_at']),
    );
  }
}

class Colour {
  int id;
  String colourName;
  DateTime createdAt;
  DateTime updatedAt;

  Colour({
    required this.id,
    required this.colourName,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Colour.fromJson(Map<String, dynamic> json) {
    return Colour(
      id: json['id'],
      colourName: json['colour_name'],
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: DateTime.parse(json['updated_at']),
    );
  }
}

class VariantDetail {
  int id;
  String variantName;
  DateTime createdAt;
  DateTime updatedAt;

  VariantDetail({
    required this.id,
    required this.variantName,
    required this.createdAt,
    required this.updatedAt,
  });

  factory VariantDetail.fromJson(Map<String, dynamic> json) {
    return VariantDetail(
      id: json['id'],
      variantName: json['variant_name'],
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: DateTime.parse(json['updated_at']),
    );
  }
}

class Variant {
  int id;
  int productId;
  int colourId;
  int variantId;
  double price;
  DateTime createdAt;
  DateTime updatedAt;
  Colour colour;
  VariantDetail variant;

  Variant({
    required this.id,
    required this.productId,
    required this.colourId,
    required this.variantId,
    required this.price,
    required this.createdAt,
    required this.updatedAt,
    required this.colour,
    required this.variant,
  });

  factory Variant.fromJson(Map<String, dynamic> json) {
    return Variant(
      id: json['id'],
      productId: json['product_id'],
      colourId: json['colour_id'],
      variantId: json['variant_id'],
      price: double.parse(json['price']),
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: DateTime.parse(json['updated_at']),
      colour: Colour.fromJson(json['colour']),
      variant: VariantDetail.fromJson(json['variant']),
    );
  }
}

class Product {
  int id;
  int brandId;
  int categoryId;
  String productName;
  String productDescription;
  String productImage;
  DateTime createdAt;
  DateTime updatedAt;
  Brand brand;
  Category category;
  List<Variant> variants;

  Product({
    required this.id,
    required this.brandId,
    required this.categoryId,
    required this.productName,
    required this.productDescription,
    required this.productImage,
    required this.createdAt,
    required this.updatedAt,
    required this.brand,
    required this.category,
    required this.variants,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    var variantList = json['variants'] as List;
    List<Variant> variants =
        variantList.map((i) => Variant.fromJson(i)).toList();

    return Product(
      id: json['id'],
      brandId: json['brand_id'],
      categoryId: json['category_id'],
      productName: json['product_name'],
      productDescription: json['product_description'],
      productImage: json['product_image'],
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: DateTime.parse(json['updated_at']),
      brand: Brand.fromJson(json['brand']),
      category: Category.fromJson(json['category']),
      variants: variants,
    );
  }
}

class CartItem {
  int id;
  int userId;
  int productId;
  int productVariantId;
  int quantity;
  DateTime createdAt;
  DateTime updatedAt;
  Product product;

  CartItem({
    required this.id,
    required this.userId,
    required this.productId,
    required this.productVariantId,
    required this.quantity,
    required this.createdAt,
    required this.updatedAt,
    required this.product,
  });

  factory CartItem.fromJson(Map<String, dynamic> json) {
    return CartItem(
      id: json['id'],
      userId: json['user_id'],
      productId: json['product_id'],
      productVariantId: json['product_variant_id'],
      quantity: json['quantity'],
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: DateTime.parse(json['updated_at']),
      product: Product.fromJson(json['product']),
    );
  }
}

class CartResponse {
  String message;
  List<CartItem> data;

  CartResponse({required this.message, required this.data});

  factory CartResponse.fromJson(Map<String, dynamic> json) {
    var list = json['data'] as List;
    List<CartItem> cartItemsList =
        list.map((i) => CartItem.fromJson(i)).toList();

    return CartResponse(
      message: json['message'],
      data: cartItemsList,
    );
  }
}
