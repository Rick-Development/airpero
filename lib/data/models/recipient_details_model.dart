// To parse this JSON data, do
//
//     final recipientDetailsModel = recipientDetailsModelFromJson(jsonString);

import 'dart:convert';

RecipientDetailsModel recipientDetailsModelFromJson(String str) => RecipientDetailsModel.fromJson(json.decode(str));

String recipientDetailsModelToJson(RecipientDetailsModel data) => json.encode(data.toJson());

class RecipientDetailsModel {
    Message? message;

    RecipientDetailsModel({
        this.message,
    });

    factory RecipientDetailsModel.fromJson(Map<String, dynamic> json) => RecipientDetailsModel(
        message: json["message"] == null ? null : Message.fromJson(json["message"]),
    );

    Map<String, dynamic> toJson() => {
        "message": message?.toJson(),
    };
}

class Message {
    Recipient? recipient;

    Message({
        this.recipient,
    });

    factory Message.fromJson(Map<String, dynamic> json) => Message(
        recipient: json["recipient"] == null ? null : Recipient.fromJson(json["recipient"]),
    );

    Map<String, dynamic> toJson() => {
        "recipient": recipient?.toJson(),
    };
}

class Recipient {
    dynamic id;
    dynamic name;
    dynamic type;
    dynamic currencyCode;
    dynamic currencyName;
    dynamic countryName;
    dynamic countryImage;
    dynamic serviceName;
    dynamic bankName;

    Recipient({
        this.id,
        this.name,
        this.type,
        this.currencyCode,
        this.currencyName,
        this.countryName,
        this.countryImage,
        this.serviceName,
        this.bankName,
    });

    factory Recipient.fromJson(Map<String, dynamic> json) => Recipient(
        id: json["id"],
        name: json["name"],
        type: json["type"],
        currencyCode: json["currency_code"],
        currencyName: json["currency_name"],
        countryName: json["country_name"],
        countryImage: json["country_image"],
        serviceName: json["service_name"],
        bankName: json["bank_name"],
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "type": type,
        "currency_code": currencyCode,
        "currency_name": currencyName,
        "country_name": countryName,
        "country_image": countryImage,
        "service_name": serviceName,
        "bank_name": bankName,
    };
}


