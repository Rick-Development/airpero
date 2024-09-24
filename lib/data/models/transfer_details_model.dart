// To parse this JSON data, do
//
//     final transferDetails = transferDetailsFromJson(jsonString);

import 'dart:convert';

TransferDetails transferDetailsFromJson(String str) => TransferDetails.fromJson(json.decode(str));

String transferDetailsToJson(TransferDetails data) => json.encode(data.toJson());

class TransferDetails {
    Message? message;

    TransferDetails({
        this.message,
    });

    factory TransferDetails.fromJson(Map<String, dynamic> json) => TransferDetails(
        message: json["message"] == null ? null : Message.fromJson(json["message"]),
    );

    Map<String, dynamic> toJson() => {
        "message": message?.toJson(),
    };
}

class Message {
    TransferDetailsClass? transferDetails;

    Message({
        this.transferDetails,
    });

    factory Message.fromJson(Map<String, dynamic> json) => Message(
        transferDetails: json["transferDetails"] == null ? null : TransferDetailsClass.fromJson(json["transferDetails"]),
    );

    Map<String, dynamic> toJson() => {
        "transferDetails": transferDetails?.toJson(),
    };
}

class TransferDetailsClass {
    dynamic id;
    dynamic uuid;
    dynamic sendAmount;
    dynamic transferFee;
    dynamic sendTotal;
    dynamic exchangeRate;
    dynamic receiverAmount;
    dynamic trxId;
    ErCurrency? senderCurrency;
    ErCurrency? receiverCurrency;
    RecipientDetails? recipientDetails;
    dynamic rejectReason;
    dynamic resubmitted;
    dynamic status;

    TransferDetailsClass({
        this.id,
        this.uuid,
        this.sendAmount,
        this.transferFee,
        this.sendTotal,
        this.exchangeRate,
        this.receiverAmount,
        this.trxId,
        this.senderCurrency,
        this.receiverCurrency,
        this.recipientDetails,
        this.rejectReason,
        this.resubmitted,
        this.status,
    });

    factory TransferDetailsClass.fromJson(Map<String, dynamic> json) => TransferDetailsClass(
        id: json["id"],
        uuid: json["uuid"],
        sendAmount: json["send_amount"],
        transferFee: json["transfer_fee"]?.toDouble(),
        sendTotal: json["send_total"]?.toDouble(),
        exchangeRate: json["exchange_rate"]?.toDouble(),
        receiverAmount: json["receiver_amount"],
        trxId: json["trx_id"],
        senderCurrency: json["sender_currency"] == null ? null : ErCurrency.fromJson(json["sender_currency"]),
        receiverCurrency: json["receiver_currency"] == null ? null : ErCurrency.fromJson(json["receiver_currency"]),
        recipientDetails: json["recipient_details"] == null ? null : RecipientDetails.fromJson(json["recipient_details"]),
        rejectReason: json["Reject Reason"],
        resubmitted: json["resubmitted"],
        status: json["status"],
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "uuid": uuid,
        "send_amount": sendAmount,
        "transfer_fee": transferFee,
        "send_total": sendTotal,
        "exchange_rate": exchangeRate,
        "receiver_amount": receiverAmount,
        "trx_id": trxId,
        "sender_currency": senderCurrency?.toJson(),
        "receiver_currency": receiverCurrency?.toJson(),
        "recipient_details": recipientDetails?.toJson(),
        "Reject Reason": rejectReason,
        "resubmitted": resubmitted,
        "status": status,
    };
}

class ErCurrency {
    dynamic id;
    dynamic name;
    dynamic code;
    dynamic rate;
    dynamic symbol;
    dynamic symbolNative;
    dynamic precision;

    ErCurrency({
        this.id,
        this.name,
        this.code,
        this.rate,
        this.symbol,
        this.symbolNative,
        this.precision,
    });

    factory ErCurrency.fromJson(Map<String, dynamic> json) => ErCurrency(
        id: json["id"],
        name: json["name"],
        code: json["code"],
        rate: json["rate"],
        symbol: json["symbol"],
        symbolNative: json["symbol_native"],
        precision: json["precision"],
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "code": code,
        "rate": rate,
        "symbol": symbol,
        "symbol_native": symbolNative,
        "precision": precision,
    };
}

class RecipientDetails {
    dynamic name;
    dynamic email;
    dynamic sendTo;
    dynamic service;

    RecipientDetails({
        this.name,
        this.email,
        this.sendTo,
        this.service,
    });

    factory RecipientDetails.fromJson(Map<String, dynamic> json) => RecipientDetails(
        name: json["name"],
        email: json["email"],
        sendTo: json["send_to"],
        service: json["service"],
    );

    Map<String, dynamic> toJson() => {
        "name": name,
        "email": email,
        "send_to": sendTo,
        "service": service,
    };
}
