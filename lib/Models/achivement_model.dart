class AchievementModel {
  String message;
  Data data;

  AchievementModel({required this.message, required this.data});

  factory AchievementModel.fromJson(Map<String, dynamic> json) {
    return AchievementModel(
      message: json['message'],
      data: Data.fromJson(json['data']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'message': message,
      'data': data.toJson(),
    };
  }
}

class Data {
  OfferInfo offerInfo;
  List<OfferData> offerData;

  Data({required this.offerInfo, required this.offerData});

  factory Data.fromJson(Map<String, dynamic> json) {
    return Data(
      offerInfo: OfferInfo.fromJson(json['offer_info']),
      offerData: List<OfferData>.from(
          json['data'].map((offer) => OfferData.fromJson(offer))),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'offer_info': offerInfo.toJson(),
      'data': offerData.map((offer) => offer.toJson()).toList(),
    };
  }
}

class OfferInfo {
  int id;
  String offerCreateDate;
  String offerExpiryDate;
  int totalPurchaseAmount;

  OfferInfo({
    required this.id,
    required this.offerCreateDate,
    required this.offerExpiryDate,
    required this.totalPurchaseAmount,
  });

  factory OfferInfo.fromJson(Map<String, dynamic> json) {
    return OfferInfo(
      id: json['id'],
      offerCreateDate: json['offer_createDate'],
      offerExpiryDate: json['offer_expiryDate'],
      totalPurchaseAmount: json['total_purchase_amount'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'offer_createDate': offerCreateDate,
      'offer_expiryDate': offerExpiryDate,
      'total_purchase_amount': totalPurchaseAmount,
    };
  }
}

class OfferData {
  int id;
  int offerId;
  int targetAmount;
  String offer;
  String description;
  String status;
  int achievedPercentage;
  int remainingAmount;

  OfferData({
    required this.id,
    required this.offerId,
    required this.targetAmount,
    required this.offer,
    required this.description,
    required this.status,
    required this.achievedPercentage,
    required this.remainingAmount,
  });

  factory OfferData.fromJson(Map<String, dynamic> json) {
    return OfferData(
      id: json['id'],
      offerId: json['offer_id'],
      targetAmount: json['target_amount'],
      offer: json['offer'],
      description: json['description'],
      status: json['status'],
      achievedPercentage: json['achieved_percentage'],
      remainingAmount: json['remaining_amount'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'offer_id': offerId,
      'target_amount': targetAmount.toString(),
      'offer': offer,
      'description': description,
      'status': status,
      'achieved_percentage': achievedPercentage,
      'remaining_amount': remainingAmount,
    };
  }
}
