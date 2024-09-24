class FundHistoryModel {
  Message? message;

  FundHistoryModel({this.message});

  FundHistoryModel.fromJson(Map<String, dynamic> json) {
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
  List<Funds>? funds;

  Message({this.funds});

  Message.fromJson(Map<String, dynamic> json) {
    if (json['funds'] != null) {
      funds = <Funds>[];
      json['funds'].forEach((v) {
        funds!.add(new Funds.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.funds != null) {
      data['funds'] = this.funds!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Funds {
  dynamic id;
  dynamic transactionId;
  dynamic amount;
  dynamic charge;
  dynamic paymentMethodCurrency;
  dynamic status;
  dynamic createdAt;
  dynamic gateway;

  Funds(
      {this.id,
      this.transactionId,
      this.amount,
      this.charge,
      this.paymentMethodCurrency,
      this.status,
      this.createdAt,
      this.gateway});

  Funds.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    transactionId = json['transactionId'];
    amount = json['amount'];
    charge = json['charge'];
    paymentMethodCurrency = json['payment_method_currency'];
    status = json['status'];
    createdAt = json['created_at'];
    gateway = json['gateway'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['transactionId'] = this.transactionId;
    data['amount'] = this.amount;
    data['charge'] = this.charge;
    data['payment_method_currency'] = this.paymentMethodCurrency;
    data['status'] = this.status;
    data['created_at'] = this.createdAt;
    data['gateway'] = this.gateway;
    return data;
  }
}
