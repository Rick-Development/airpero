class PayoutModel {
  Message? message;

  PayoutModel({this.message});

  PayoutModel.fromJson(Map<String, dynamic> json) {
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
  List<PayoutMethods>? payoutMethods;

  Message({this.payoutMethods});

  Message.fromJson(Map<String, dynamic> json) {
    if (json['payoutMethods'] != null) {
      payoutMethods = <PayoutMethods>[];
      json['payoutMethods'].forEach((v) {
        payoutMethods!.add(new PayoutMethods.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.payoutMethods != null) {
      data['payoutMethods'] =
          this.payoutMethods!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class PayoutMethods {
  dynamic id;
  dynamic code;
  dynamic name;
  dynamic currency;
  dynamic currencySymbol;
  dynamic image;
  dynamic description;
  List<dynamic>? supportedCurrency;
  List<PayoutCurrencies>? payoutCurrencies;

  PayoutMethods(
      {this.id,
      this.code,
      this.name,
      this.currency,
      this.currencySymbol,
      this.image,
      this.description,
      this.supportedCurrency,
      this.payoutCurrencies});

  PayoutMethods.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    code = json['code'];
    name = json['name'];
    currency = json['currency'];
    currencySymbol = json['currencySymbol'];
    image = json['image'];
    description = json['description'];
    supportedCurrency = json['supportedCurrency'].cast<String>();
    if (json['payoutCurrencies'] != null) {
      payoutCurrencies = <PayoutCurrencies>[];
      json['payoutCurrencies'].forEach((v) {
        payoutCurrencies!.add(new PayoutCurrencies.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['code'] = this.code;
    data['name'] = this.name;
    data['currency'] = this.currency;
    data['currencySymbol'] = this.currencySymbol;
    data['image'] = this.image;
    data['description'] = this.description;
    data['supportedCurrency'] = this.supportedCurrency;
    if (this.payoutCurrencies != null) {
      data['payoutCurrencies'] =
          this.payoutCurrencies!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class PayoutCurrencies {
  dynamic name;
  dynamic currencySymbol;
  dynamic conversionRate;
  dynamic minLimit;
  dynamic maxLimit;
  dynamic percentageCharge;
  dynamic fixedCharge;

  PayoutCurrencies(
      {this.name,
      this.currencySymbol,
      this.conversionRate,
      this.minLimit,
      this.maxLimit,
      this.percentageCharge,
      this.fixedCharge});

  PayoutCurrencies.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    currencySymbol = json['currency_symbol'];
    conversionRate = json['conversion_rate'];
    minLimit = json['min_limit'];
    maxLimit = json['max_limit'];
    percentageCharge = json['percentage_charge'];
    fixedCharge = json['fixed_charge'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['name'] = this.name;
    data['currency_symbol'] = this.currencySymbol;
    data['conversion_rate'] = this.conversionRate;
    data['min_limit'] = this.minLimit;
    data['max_limit'] = this.maxLimit;
    data['percentage_charge'] = this.percentageCharge;
    data['fixed_charge'] = this.fixedCharge;
    return data;
  }
}
