// To parse this JSON data, do
//
//     final virtualCardTransactionModel = virtualCardTransactionModelFromJson(jsonString);

import 'dart:convert';

VirtualCardTransactionModel virtualCardTransactionModelFromJson(String str) => VirtualCardTransactionModel.fromJson(json.decode(str));

String virtualCardTransactionModelToJson(VirtualCardTransactionModel data) => json.encode(data.toJson());

class VirtualCardTransactionModel {
    Message? message;

    VirtualCardTransactionModel({
        this.message,
    });

    factory VirtualCardTransactionModel.fromJson(Map<String, dynamic> json) => VirtualCardTransactionModel(
        message: json["message"] == null ? null : Message.fromJson(json["message"]),
    );

    Map<String, dynamic> toJson() => {
        "message": message?.toJson(),
    };
}

class Message {
    dynamic cardId;
    List<Transaction>? transactions;

    Message({
        this.cardId,
        this.transactions,
    });

    factory Message.fromJson(Map<String, dynamic> json) => Message(
        cardId: json["card_id"],
        transactions: json["transactions"] == null ? [] : List<Transaction>.from(json["transactions"]!.map((x) => Transaction.fromJson(x))),
    );

    Map<String, dynamic> toJson() => {
        "card_id": cardId,
        "transactions": transactions == null ? [] : List<dynamic>.from(transactions!.map((x) => x.toJson())),
    };
}

class Transaction {
    dynamic providerId;
    dynamic providerName;
    dynamic amount;
    dynamic currency;
    dynamic status;

    Transaction({
        this.providerId,
        this.providerName,
        this.amount,
        this.currency,
        this.status,
    });

    factory Transaction.fromJson(Map<String, dynamic> json) => Transaction(
        providerId: json["provider_id"],
        providerName: json["provider_name"],
        amount: json["amount"],
        currency: json["currency"],
        status: json["status"],
    );

    Map<String, dynamic> toJson() => {
        "provider_id": providerId,
        "provider_name": providerName,
        "amount": amount,
        "currency": currency,
        "status": status,
    };
}
