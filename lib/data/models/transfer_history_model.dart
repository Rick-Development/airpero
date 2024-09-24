// To parse this JSON data, do
//
//     final transferHistoryModel = transferHistoryModelFromJson(jsonString);

import 'dart:convert';

TransferHistoryModel transferHistoryModelFromJson(String str) =>
    TransferHistoryModel.fromJson(json.decode(str));

String transferHistoryModelToJson(TransferHistoryModel data) =>
    json.encode(data.toJson());

class TransferHistoryModel {
  Message? message;

  TransferHistoryModel({
    this.message,
  });

  factory TransferHistoryModel.fromJson(Map<String, dynamic> json) =>
      TransferHistoryModel(
        message:
            json["message"] == null ? null : Message.fromJson(json["message"]),
      );

  Map<String, dynamic> toJson() => {
        "message": message?.toJson(),
      };
}

class Message {
  List<Transfer>? transfers;

  Message({
    this.transfers,
  });

  factory Message.fromJson(Map<String, dynamic> json) => Message(
        transfers: json["transfers"] == null
            ? []
            : List<Transfer>.from(
                json["transfers"]!.map((x) => Transfer.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "transfers": transfers == null
            ? []
            : List<dynamic>.from(transfers!.map((x) => x.toJson())),
      };
}

class Transfer {
  dynamic id;
  dynamic uuid;
  dynamic trx_id;
  dynamic recipientId;
  dynamic sendAmount;
  dynamic recipientGetAmount;
  dynamic senderCurrency;
  dynamic receiverCurrency;
  dynamic status;
  dynamic createdAt;
  Recipient? recipient;
  dynamic recipient_status;

  Transfer({
    this.id,
    this.uuid,
    this.trx_id,
    this.recipientId,
    this.sendAmount,
    this.recipientGetAmount,
    this.senderCurrency,
    this.receiverCurrency,
    this.status,
    this.createdAt,
    this.recipient,
    this.recipient_status,
  });

  factory Transfer.fromJson(Map<String, dynamic> json) => Transfer(
        id: json["id"],
        uuid: json["uuid"],
        trx_id: json["trx_id"],
        recipientId: json["recipient_id"],
        sendAmount: json["send_amount"],
        recipientGetAmount: json["recipient_get_amount"]?.toDouble(),
        senderCurrency: json["sender_currency"],
        receiverCurrency: json["receiver_currency"],
        status: json["status"],
        createdAt: json["created_at"],
        recipient_status: json["recipient_status"],
        recipient: json["recipient"] == null
            ? null
            : Recipient.fromJson(json["recipient"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "uuid": uuid,
        "trx_id": trx_id,
        "recipient_id": recipientId,
        "send_amount": sendAmount,
        "recipient_get_amount": recipientGetAmount,
        "sender_currency": senderCurrency,
        "receiver_currency": receiverCurrency,
        "status": status,
        "created_at": createdAt,
        "recipient_status": recipient_status,
        "recipient": recipient?.toJson(),
      };
}

class Recipient {
  dynamic id;
  dynamic name;
  dynamic email;

  Recipient({
    this.id,
    this.name,
    this.email,
  });

  factory Recipient.fromJson(Map<String, dynamic> json) => Recipient(
        id: json["id"],
        name: json["name"],
        email: json["email"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "email": email,
      };
}
