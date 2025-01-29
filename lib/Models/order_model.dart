class OrderResponse {
  String message;
  List<OrderData> data;

  OrderResponse({required this.message, required this.data});

  factory OrderResponse.fromJson(Map<String, dynamic> json) {
    return OrderResponse(
      message: json['message'] ?? '',
      data: List<OrderData>.from(
          json['data']?.map((x) => OrderData.fromJson(x)) ?? []),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'message': message,
      'data': List<dynamic>.from(data.map((x) => x.toJson())),
    };
  }
}

class OrderData {
  final int id;
  final int userId;
  final double totalAmount;

  final String status;
  final String? receipt;

  final AddressInfo addressInfo;
  final List<OrderResponseInfo> orderResponseInfo;
  final String orderDate;
  final String deliveredDate;
  final String cancelDate;

  OrderData({
    required this.id,
    required this.userId,
    required this.totalAmount,
    required this.status,
    this.receipt,
    required this.addressInfo,
    required this.orderResponseInfo,
    required this.orderDate, // Required in constructor
    required this.deliveredDate, // Required in constructor
    required this.cancelDate, // Required in constructor
  });

  factory OrderData.fromJson(Map<String, dynamic> json) {
    return OrderData(
      id: json['id'] ?? 0,
      userId: json['user_id'] ?? 0,
      totalAmount: (json['total_amount'] as num).toDouble(),
      status: json['status'] ?? '',
      receipt: json['receipt'],

      addressInfo: AddressInfo.fromJson(json['address_info'] ?? {}),
      orderResponseInfo: List<OrderResponseInfo>.from(
          json['order_response_info']
                  ?.map((x) => OrderResponseInfo.fromJson(x)) ??
              []),
      orderDate: json['order_date'] ?? '', // Handle null value
      deliveredDate: json['delivered_date'] ?? '', // Handle null value
      cancelDate: json['cancel_date'] ?? '', // Handle null value
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user_id': userId,
      'total_amount': totalAmount,
      'status': status,
      'address_info': addressInfo.toJson(),
      'order_response_info':
          List<dynamic>.from(orderResponseInfo.map((x) => x.toJson())),
      'order_date': orderDate, // Add to JSON output
      'delivered_date': deliveredDate, // Add to JSON output
      'cancel_date': cancelDate, // Add to JSON output
    };
  }
}

class AddressInfo {
  final int id;
  final String fullname;
  final String address;
  final String? city;
  final String? state;
  final int? pincode;
  final String mobileNumber;
  final String addressType;

  AddressInfo({
    required this.id,
    required this.fullname,
    required this.address,
    required this.city,
    required this.state,
    required this.pincode,
    required this.mobileNumber,
    required this.addressType,
  });

  factory AddressInfo.fromJson(Map<String, dynamic> json) {
    return AddressInfo(
      id: json['id'] ?? 0,
      fullname: json['fullname'] ?? '',
      address: json['address'] ?? '',
      city: json['city'] ?? '',
      state: json['state'] ?? '',
      pincode: json['pincode'] ?? 0,
      mobileNumber: json['mobile_number']?.toString() ?? '',
      addressType: json['address_type'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'fullname': fullname,
      'address': address,
      'city': city,
      'state': state,
      'pincode': pincode,
      'mobile_number': mobileNumber,
      'address_type': addressType,
    };
  }
}

class OrderResponseInfo {
  final int id;
  final int quantity;
  final ProductInfo productInfo;
  final ProductVariant productVariant;

  OrderResponseInfo({
    required this.id,
    required this.quantity,
    required this.productInfo,
    required this.productVariant,
  });

  factory OrderResponseInfo.fromJson(Map<String, dynamic> json) {
    return OrderResponseInfo(
      id: json['id'] ?? 0,
      quantity: json['quantity'] ?? 0,
      productInfo: ProductInfo.fromJson(json['product_info'] ?? {}),
      productVariant: ProductVariant.fromJson(json['product_variant'] ?? {}),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'quantity': quantity,
      'product_info': productInfo.toJson(),
      'product_variant': productVariant.toJson(),
    };
  }
}

class ProductInfo {
  final int id;
  final Brand brandId;
  final Category categoryId;
  final String productName;
  final String productDescription;
  final String productImage;
  final DateTime createdAt;

  ProductInfo({
    required this.id,
    required this.brandId,
    required this.categoryId,
    required this.productName,
    required this.productDescription,
    required this.productImage,
    required this.createdAt,
  });

  factory ProductInfo.fromJson(Map<String, dynamic> json) {
    return ProductInfo(
      id: json['id'] ?? 0,
      brandId: Brand.fromJson(json['brand_id'] ?? {}),
      categoryId: Category.fromJson(json['category_id'] ?? {}),
      productName: json['product_name'] ?? '',
      productDescription: json['product_description'] ?? '',
      productImage: json['product_image'] ?? '',
      createdAt: json['created_at'] != null
          ? DateTime.tryParse(json['created_at']) ?? DateTime.now()
          : DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'brand_id': brandId.toJson(),
      'category_id': categoryId.toJson(),
      'product_name': productName,
      'product_description': productDescription,
      'product_image': productImage,
      'created_at': createdAt.toIso8601String(),
    };
  }
}

class Brand {
  final int id;
  final String name;

  Brand({required this.id, required this.name});

  factory Brand.fromJson(Map<String, dynamic> json) {
    return Brand(
      id: json['id'] ?? 0,
      name: json['name'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
    };
  }
}

class Category {
  final int id;
  final String name;

  Category({required this.id, required this.name});

  factory Category.fromJson(Map<String, dynamic> json) {
    return Category(
      id: json['id'] ?? 0,
      name: json['name'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
    };
  }
}

class ProductVariant {
  final int id;
  final Brand colourId;
  final Brand variantId;
  final String price;
  final int variantStatus;

  ProductVariant({
    required this.id,
    required this.colourId,
    required this.variantId,
    required this.price,
    required this.variantStatus,
  });

  factory ProductVariant.fromJson(Map<String, dynamic> json) {
    return ProductVariant(
      id: json['id'] ?? 0,
      colourId: Brand.fromJson(json['colour_id'] ?? {}),
      variantId: Brand.fromJson(json['variant_id'] ?? {}),
      price: json['price'] ?? '',
      variantStatus: json['variant_status'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'colour_id': colourId.toJson(),
      'variant_id': variantId.toJson(),
      'price': price,
      'variant_status': variantStatus,
    };
  }
}

class Colour {
  final int id;
  final String name;

  Colour({
    required this.id,
    required this.name,
  });

  factory Colour.fromJson(Map<String, dynamic> json) {
    return Colour(
      id: json['id'] ?? 0,
      name: json['name'] ?? 'Unknown',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
    };
  }
}

class Variant {
  final int id;
  final String name;

  Variant({
    required this.id,
    required this.name,
  });

  factory Variant.fromJson(Map<String, dynamic> json) {
    return Variant(
      id: json['id'] ?? 0,
      name: json['name'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
    };
  }
}
