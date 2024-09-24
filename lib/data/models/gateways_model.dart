class GatewayModel {
  Message? message;

  GatewayModel({this.message});

  GatewayModel.fromJson(Map<String, dynamic> json) {
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
  List<Gateways>? gateways;

  Message({this.gateways});

  Message.fromJson(Map<String, dynamic> json) {
    if (json['gateways'] != null) {
      gateways = <Gateways>[];
      json['gateways'].forEach((v) {
        gateways!.add(new Gateways.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.gateways != null) {
      data['gateways'] = this.gateways!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Gateways {
  dynamic id;
  dynamic code;
  dynamic name;
  dynamic image;
  dynamic description;
  List<dynamic>? supportedCurrency;
  List<ReceivableCurrencies>? receivableCurrencies;
  dynamic is_crypto;

  Gateways(
      {this.id,
      this.code,
      this.name,
      this.image,
      this.description,
      this.supportedCurrency,
      this.receivableCurrencies,
      this.is_crypto});

  Gateways.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    code = json['code'];
    name = json['name'];
    image = json['image'];
    description = json['description'];
    is_crypto = json['is_crypto'];
    supportedCurrency = json['supported_currency'].cast<String>();
    if (json['receivable_currencies'] != null &&
        json['receivable_currencies'] is List) {
      receivableCurrencies = <ReceivableCurrencies>[];
      json['receivable_currencies'].forEach((v) {
        receivableCurrencies!.add(new ReceivableCurrencies.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['code'] = this.code;
    data['name'] = this.name;
    data['image'] = this.image;
    data['description'] = this.description;
    data['is_crypto'] = this.is_crypto;
    data['supported_currency'] = this.supportedCurrency;
    if (this.receivableCurrencies != null) {
      data['receivable_currencies'] =
          this.receivableCurrencies!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class ReceivableCurrencies {
  dynamic name;
  dynamic currency;
  dynamic conversionRate;
  dynamic minLimit;
  dynamic maxLimit;
  dynamic percentageCharge;
  dynamic fixedCharge;

  ReceivableCurrencies(
      {this.name,
      this.currency,
      this.conversionRate,
      this.minLimit,
      this.maxLimit,
      this.percentageCharge,
      this.fixedCharge});

  ReceivableCurrencies.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    currency = json['currency'];
    conversionRate = json['conversion_rate'];
    minLimit = json['min_limit'];
    maxLimit = json['max_limit'];
    percentageCharge = json['percentage_charge'];
    fixedCharge = json['fixed_charge'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['name'] = this.name;
    data['currency'] = this.currency;
    data['conversion_rate'] = this.conversionRate;
    data['min_limit'] = this.minLimit;
    data['max_limit'] = this.maxLimit;
    data['percentage_charge'] = this.percentageCharge;
    data['fixed_charge'] = this.fixedCharge;
    return data;
  }
}
