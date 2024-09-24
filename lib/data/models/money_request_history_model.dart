// To parse this JSON data, do
//
//     final moneyRequestHistoryModel = moneyRequestHistoryModelFromJson(jsonString);

import 'dart:convert';

MoneyRequestHistoryModel moneyRequestHistoryModelFromJson(String str) =>
    MoneyRequestHistoryModel.fromJson(json.decode(str));

String moneyRequestHistoryModelToJson(MoneyRequestHistoryModel data) =>
    json.encode(data.toJson());

class MoneyRequestHistoryModel {
  Transactions? message;

  MoneyRequestHistoryModel({
    this.message,
  });

  factory MoneyRequestHistoryModel.fromJson(Map<String, dynamic> json) =>
      MoneyRequestHistoryModel(
        message: json["message"] == null
            ? null
            : Transactions.fromJson(json["message"]),
      );

  Map<String, dynamic> toJson() => {
        "message": message?.toJson(),
      };
}

class Transactions {
  List<Datum>? data;

  Transactions({
    this.data,
  });

  factory Transactions.fromJson(Map<String, dynamic> json) => Transactions(
        data: json["data"] == null
            ? []
            : List<Datum>.from(json["data"]!.map((x) => Datum.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "data": data == null
            ? []
            : List<dynamic>.from(data!.map((x) => x.toJson())),
      };
}

class Datum {
  dynamic id;
  dynamic requesterId;
  dynamic recipientId;
  dynamic walletUuid;
  dynamic amount;
  dynamic currency;
  dynamic status;
  dynamic trxId;
  dynamic createdAt;
  dynamic updatedAt;
  User? reqUser;
  User? rcpUser;

  Datum({
    this.id,
    this.requesterId,
    this.recipientId,
    this.walletUuid,
    this.amount,
    this.currency,
    this.status,
    this.trxId,
    this.createdAt,
    this.updatedAt,
    this.reqUser,
    this.rcpUser,
  });

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
        id: json["id"],
        requesterId: json["requester_id"],
        recipientId: json["recipient_id"],
        walletUuid: json["wallet_uuid"],
        amount: json["amount"],
        currency: json["currency"],
        status: json["status"],
        trxId: json["trx_id"],
        createdAt: json["created_at"] == null
            ? null
            : DateTime.parse(json["created_at"]),
        updatedAt: json["updated_at"] == null
            ? null
            : DateTime.parse(json["updated_at"]),
        reqUser:
            json["req_user"] == null ? null : User.fromJson(json["req_user"]),
        rcpUser:
            json["rcp_user"] == null ? null : User.fromJson(json["rcp_user"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "requester_id": requesterId,
        "recipient_id": recipientId,
        "wallet_uuid": walletUuid,
        "amount": amount,
        "currency": currency,
        "status": status,
        "trx_id": trxId,
        "created_at": createdAt?.toIso8601String(),
        "updated_at": updatedAt?.toIso8601String(),
        "req_user": reqUser?.toJson(),
        "rcp_user": rcpUser?.toJson(),
      };
}

class User {
  dynamic id;
  dynamic username;
  dynamic email;
  dynamic firstname;
  dynamic lastname;
  dynamic image;
  dynamic imageDriver;
  dynamic lastSeenActivity;

  User({
    this.id,
    this.username,
    this.email,
    this.firstname,
    this.lastname,
    this.image,
    this.imageDriver,
    this.lastSeenActivity,
  });

  factory User.fromJson(Map<String, dynamic> json) => User(
        id: json["id"],
        username: json["username"],
        email: json["email"],
        firstname: json["firstname"],
        lastname: json["lastname"],
        image: json["image"],
        imageDriver: json["image_driver"],
        lastSeenActivity: json["last-seen-activity"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "username": username,
        "email": email,
        "firstname": firstname,
        "lastname": lastname,
        "image": image,
        "image_driver": imageDriver,
        "last-seen-activity": lastSeenActivity,
      };
}
