class TransactionModel {
  Message? message;

  TransactionModel({this.message});

  TransactionModel.fromJson(Map<String, dynamic> json) {
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
  List<Transactions>? transactions;

  Message({this.transactions});

  Message.fromJson(Map<String, dynamic> json) {
    if (json['transactions'] != null) {
      transactions = <Transactions>[];
      json['transactions'].forEach((v) {
        transactions!.add(new Transactions.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.transactions != null) {
      data['transactions'] = this.transactions!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Transactions {
  dynamic id;
  dynamic trxId;
  dynamic amount;
  dynamic base_amount;
  dynamic charge;
  dynamic remarks;
  dynamic createdAt;
  dynamic currency;
  dynamic trx_type;

  Transactions(
      {this.id,
      this.trxId,
      this.amount,
      this.base_amount,
      this.charge,
      this.remarks,
      this.createdAt,
      this.currency,
      this.trx_type});

  Transactions.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    trxId = json['trx_id'];
    amount = json['amount'];
    base_amount = json['base_amount'];
    charge = json['charge'];
    remarks = json['remarks'];
    createdAt = json['created_at'];
    currency = json['currency'];
    trx_type = json['trx_type'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['trx_id'] = this.trxId;
    data['amount'] = this.amount;
    data['base_amount'] = this.base_amount;
    data['charge'] = this.charge;
    data['remarks'] = this.remarks;
    data['created_at'] = this.createdAt;
    data['currency'] = this.currency;
    data['trx_type'] = this.trx_type;
    return data;
  }
}
