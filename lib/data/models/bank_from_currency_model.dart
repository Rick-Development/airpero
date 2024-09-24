class BankFromCurrencyModel {
  Message? message;

  BankFromCurrencyModel({this.message});

  BankFromCurrencyModel.fromJson(Map<String, dynamic> json) {
    message =
        json['message'] != null ? new Message.fromJson(json['message']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.message != null) {
      data['message'] = this.message!.toJson();
    }
    return data;
  }
}

class Message {
  List<Data>? data;

  Message({this.data});

  Message.fromJson(Map<String, dynamic> json) {
    if (json['data'] != null) {
      data = <Data>[];
      json['data'].forEach((v) {
        data!.add(new Data.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Data {
  dynamic id;
  dynamic name;
  dynamic slug;
  dynamic code;
  dynamic longcode;
  dynamic gateway;
  dynamic payWithBank;
  dynamic supportsTransfer;
  dynamic active;
  dynamic country;
  dynamic currency;
  dynamic type;
  dynamic isDeleted;
  dynamic createdAt;
  dynamic updatedAt;

  Data(
      {this.id,
      this.name,
      this.slug,
      this.code,
      this.longcode,
      this.gateway,
      this.payWithBank,
      this.supportsTransfer,
      this.active,
      this.country,
      this.currency,
      this.type,
      this.isDeleted,
      this.createdAt,
      this.updatedAt});

  Data.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    slug = json['slug'];
    code = json['code'];
    longcode = json['longcode'];
    gateway = json['gateway'];
    payWithBank = json['pay_with_bank'];
    supportsTransfer = json['supports_transfer'];
    active = json['active'];
    country = json['country'];
    currency = json['currency'];
    type = json['type'];
    isDeleted = json['is_deleted'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['slug'] = this.slug;
    data['code'] = this.code;
    data['longcode'] = this.longcode;
    data['gateway'] = this.gateway;
    data['pay_with_bank'] = this.payWithBank;
    data['supports_transfer'] = this.supportsTransfer;
    data['active'] = this.active;
    data['country'] = this.country;
    data['currency'] = this.currency;
    data['type'] = this.type;
    data['is_deleted'] = this.isDeleted;
    data['createdAt'] = this.createdAt;
    data['updatedAt'] = this.updatedAt;
    return data;
  }
}
