// To parse this JSON data, do
//
//     final virtualCardModel = virtualCardModelFromJson(jsonString);

import 'dart:convert';

VirtualCardModel virtualCardModelFromJson(String str) => VirtualCardModel.fromJson(json.decode(str));

String virtualCardModelToJson(VirtualCardModel data) => json.encode(data.toJson());

class VirtualCardModel {
    Message? message;

    VirtualCardModel({
        this.message,
    });

    factory VirtualCardModel.fromJson(Map<String, dynamic> json) => VirtualCardModel(
        message: json["message"] == null ? null : Message.fromJson(json["message"]),
    );

    Map<String, dynamic> toJson() => {
        "message": message?.toJson(),
    };
}

class Message {
    CardOrder? cardOrder;
    List<CardOrder>? approveCards;
    dynamic orderLock;

    Message({
        this.cardOrder,
        this.approveCards,
        this.orderLock,
    });

    factory Message.fromJson(Map<String, dynamic> json) => Message(
        cardOrder: json["cardOrder"] == null ? null : CardOrder.fromJson(json["cardOrder"]),
        approveCards: json["approveCards"] == null ? [] : List<CardOrder>.from(json["approveCards"]!.map((x) => CardOrder.fromJson(x))),
        orderLock: json["orderLock"],
    );

    Map<String, dynamic> toJson() => {
        "cardOrder": cardOrder?.toJson(),
        "approveCards": approveCards == null ? [] : List<dynamic>.from(approveCards!.map((x) => x.toJson())),
        "orderLock": orderLock,
    };
}

class CardOrder {
    dynamic id;
    dynamic virtualCardMethodId;
    dynamic userId;
    dynamic currency;
    dynamic status;
    dynamic fundAmount;
    dynamic fundCharge;
    dynamic reason;
    dynamic resubmitted;
    dynamic charge;
    dynamic chargeCurrency;
    dynamic cardInfo;
    dynamic balance;
    dynamic cvv;
    dynamic cardNumber;
    dynamic expiryDate;
    dynamic brand;
    dynamic nameOnCard;
    dynamic cardId;
    dynamic lastError;
    dynamic test;
    dynamic createdAt;
    dynamic updatedAt;
    dynamic isActive;

    CardOrder({
        this.id,
        this.virtualCardMethodId,
        this.userId,
        this.currency,
        this.status,
        this.fundAmount,
        this.fundCharge,
        this.reason,
        this.resubmitted,
        this.charge,
        this.chargeCurrency,
        this.cardInfo,
        this.balance,
        this.cvv,
        this.cardNumber,
        this.expiryDate,
        this.brand,
        this.nameOnCard,
        this.cardId,
        this.lastError,
        this.test,
        this.createdAt,
        this.updatedAt,
        this.isActive,
    });

    factory CardOrder.fromJson(Map<String, dynamic> json) => CardOrder(
        id: json["id"],
        virtualCardMethodId: json["virtual_card_method_id"],
        userId: json["user_id"],
        currency: json["currency"],
        status: json["status"],
        fundAmount: json["fund_amount"],
        fundCharge: json["fund_charge"],
        reason: json["reason"],
        resubmitted: json["resubmitted"],
        charge: json["charge"],
        chargeCurrency: json["charge_currency"],
        cardInfo: json["card_info"],
        balance: json["balance"],
        cvv: json["cvv"],
        cardNumber: json["card_number"],
        expiryDate: json["expiry_date"],
        brand: json["brand"],
        nameOnCard: json["name_on_card"],
        cardId: json["card_Id"],
        lastError: json["last_error"],
        test: json["test"],
        createdAt: json["created_at"] == null ? null : DateTime.parse(json["created_at"]),
        updatedAt: json["updated_at"] == null ? null : DateTime.parse(json["updated_at"]),
        isActive: json["is_active"],
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "virtual_card_method_id": virtualCardMethodId,
        "user_id": userId,
        "currency": currency,
        "status": status?.toJson(),
        "fund_amount": fundAmount,
        "fund_charge": fundCharge,
        "reason": reason,
        "resubmitted": resubmitted,
        "charge": charge,
        "charge_currency": chargeCurrency,
        "card_info": cardInfo,
        "balance": balance,
        "cvv": cvv,
        "card_number": cardNumber,
        "expiry_date": expiryDate,
        "brand": brand,
        "name_on_card": nameOnCard,
        "card_Id": cardId,
        "last_error": lastError,
        "test": test,
        "created_at": createdAt?.toIso8601String(),
        "updated_at": updatedAt?.toIso8601String(),
        "is_active": isActive,
    };
}
