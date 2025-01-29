class RegisterModel {
  String? _message;
  Data? _data;

  RegisterModel({String? message, Data? data}) {
    if (message != null) {
      this._message = message;
    }
    if (data != null) {
      this._data = data;
    }
  }

  String? get message => _message;
  set message(String? message) => _message = message;
  Data? get data => _data;
  set data(Data? data) => _data = data;

  RegisterModel.fromJson(Map<String, dynamic> json) {
    _message = json['message'];
    _data = json['data'] != null ? new Data.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['message'] = this._message;
    if (this._data != null) {
      data['data'] = this._data!.toJson();
    }
    return data;
  }
}

class Data {
  String? _fullName;
  String? _mobileNo;
  String? _email;
  String? _password;
  String? _aadharNo;
  String? _panCardNo;
  String? _updatedAt;
  String? _createdAt;
  int? _id;

  Data(
      {String? fullName,
      String? mobileNo,
      String? email,
      String? password,
      String? aadharNo,
      String? panCardNo,
      String? updatedAt,
      String? createdAt,
      int? id}) {
    if (fullName != null) {
      this._fullName = fullName;
    }
    if (mobileNo != null) {
      this._mobileNo = mobileNo;
    }
    if (email != null) {
      this._email = email;
    }
    if (password != null) {
      this._password = password;
    }
    if (aadharNo != null) {
      this._aadharNo = aadharNo;
    }
    if (panCardNo != null) {
      this._panCardNo = panCardNo;
    }
    if (updatedAt != null) {
      this._updatedAt = updatedAt;
    }
    if (createdAt != null) {
      this._createdAt = createdAt;
    }
    if (id != null) {
      this._id = id;
    }
  }

  String? get fullName => _fullName;
  set fullName(String? fullName) => _fullName = fullName;
  String? get mobileNo => _mobileNo;
  set mobileNo(String? mobileNo) => _mobileNo = mobileNo;
  String? get email => _email;
  set email(String? email) => _email = email;
  String? get password => _password;
  set password(String? password) => _password = password;
  String? get aadharNo => _aadharNo;
  set aadharNo(String? aadharNo) => _aadharNo = aadharNo;
  String? get panCardNo => _panCardNo;
  set panCardNo(String? panCardNo) => _panCardNo = panCardNo;
  String? get updatedAt => _updatedAt;
  set updatedAt(String? updatedAt) => _updatedAt = updatedAt;
  String? get createdAt => _createdAt;
  set createdAt(String? createdAt) => _createdAt = createdAt;
  int? get id => _id;
  set id(int? id) => _id = id;

  Data.fromJson(Map<String, dynamic> json) {
    _fullName = json['fullName'];
    _mobileNo = json['mobileNo'];
    _email = json['email'];
    _password = json['password'];
    _aadharNo = json['aadharNo'];
    _panCardNo = json['panCardNo'];
    _updatedAt = json['updated_at'];
    _createdAt = json['created_at'];
    _id = json['id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['fullName'] = this._fullName;
    data['mobileNo'] = this._mobileNo;
    data['email'] = this._email;
    data['password'] = this._password;
    data['aadharNo'] = this._aadharNo;
    data['panCardNo'] = this._panCardNo;
    data['updated_at'] = this._updatedAt;
    data['created_at'] = this._createdAt;
    data['id'] = this._id;
    return data;
  }
}
