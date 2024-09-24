// To parse this JSON data, do
//
//     final recipientListModel = recipientListModelFromJson(jsonString);

import 'dart:convert';

RecipientListModel recipientListModelFromJson(String str) => RecipientListModel.fromJson(json.decode(str));

String recipientListModelToJson(RecipientListModel data) => json.encode(data.toJson());

class RecipientListModel {
    Message? message;

    RecipientListModel({
        this.message,
    });

    factory RecipientListModel.fromJson(Map<String, dynamic> json) => RecipientListModel(
        message: json["message"] == null ? null : Message.fromJson(json["message"]),
    );

    Map<String, dynamic> toJson() => {
        "message": message?.toJson(),
    };
}

class Message {
    List<Recipient>? recipients;

    Message({
        this.recipients,
    });

    factory Message.fromJson(Map<String, dynamic> json) => Message(
        recipients: json["recipients"] == null ? [] : List<Recipient>.from(json["recipients"]!.map((x) => Recipient.fromJson(x))),
    );

    Map<String, dynamic> toJson() => {
        "recipients": recipients == null ? [] : List<dynamic>.from(recipients!.map((x) => x.toJson())),
    };
}

class Recipient {
    dynamic id;
    dynamic uuid;
    dynamic type;
    dynamic name;
    dynamic email;
    dynamic currencyCode;
    dynamic currencyName;
    dynamic serviceName;
    dynamic countryImage;
    dynamic rUserId;
    dynamic rUserImage;
    dynamic favicon;

    Recipient({
        this.id,
        this.uuid,
        this.type,
        this.name,
        this.email,
        this.currencyCode,
        this.currencyName,
        this.serviceName,
        this.countryImage,
        this.rUserId,
        this.rUserImage,
        this.favicon,
    });

    factory Recipient.fromJson(Map<String, dynamic> json) => Recipient(
        id: json["id"],
        uuid: json["uuid"],
        type: json["type"],
        name: json["name"],
        email: json["email"],
        currencyCode: json["currency_code"],
        currencyName: json["currency_name"],
        serviceName: json["service_name"],
        countryImage: json["country_image"],
        rUserId: json["r_user_id"],
        rUserImage: json["r_user_image"],
        favicon: json["favicon"],
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "uuid": uuid,
        "type": type,
        "name": name,
        "email": email,
        "currency_code": currencyCode,
        "currency_name": currencyName,
        "service_name": serviceName,
        "country_image": countryImage,
        "r_user_id": rUserId,
        "r_user_image": rUserImage,
        "favicon": favicon,
    };
}
