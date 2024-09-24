// To parse this JSON data, do
//
//     final recipientServicesModel = recipientServicesModelFromJson(jsonString);

import 'dart:convert';

RecipientServicesModel recipientServicesModelFromJson(String str) => RecipientServicesModel.fromJson(json.decode(str));

String recipientServicesModelToJson(RecipientServicesModel data) => json.encode(data.toJson());

class RecipientServicesModel {
    Message? message;

    RecipientServicesModel({
        this.message,
    });

    factory RecipientServicesModel.fromJson(Map<String, dynamic> json) => RecipientServicesModel(
        message: json["message"] == null ? null : Message.fromJson(json["message"]),
    );

    Map<String, dynamic> toJson() => {
        "message": message?.toJson(),
    };
}

class Message {
    List<Service>? services;

    Message({
        this.services,
    });

    factory Message.fromJson(Map<String, dynamic> json) => Message(
        services: json["services"] == null ? [] : List<Service>.from(json["services"]!.map((x) => Service.fromJson(x))),
    );

    Map<String, dynamic> toJson() => {
        "services": services == null ? [] : List<dynamic>.from(services!.map((x) => x.toJson())),
    };
}

class Service {
    dynamic id;
    dynamic name;
    List<Bank>? banks;

    Service({
        this.id,
        this.name,
        this.banks,
    });

    factory Service.fromJson(Map<String, dynamic> json) => Service(
        id: json["id"],
        name: json["name"],
        banks: json["banks"] == null ? [] : List<Bank>.from(json["banks"]!.map((x) => Bank.fromJson(x))),
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "banks": banks == null ? [] : List<dynamic>.from(banks!.map((x) => x.toJson())),
    };
}

class Bank {
    dynamic id;
    dynamic countryId;
    dynamic name;
    dynamic bankCode;
    dynamic operatorId;
    dynamic localMinAmount;
    dynamic localMaxAmount;
    dynamic serviceId;
    dynamic status;
    dynamic createdAt;
    dynamic updatedAt;

    Bank({
        this.id,
        this.countryId,
        this.name,
        this.bankCode,
        this.operatorId,
        this.localMinAmount,
        this.localMaxAmount,
        this.serviceId,
        this.status,
        this.createdAt,
        this.updatedAt,
    });

    factory Bank.fromJson(Map<String, dynamic> json) => Bank(
        id: json["id"],
        countryId: json["country_id"],
        name: json["name"],
        bankCode: json["bank_code"],
        operatorId: json["operatorId"],
        localMinAmount: json["localMinAmount"],
        localMaxAmount: json["localMaxAmount"],
        serviceId: json["service_id"],
        status: json["status"],
        createdAt: json["created_at"] == null ? null : DateTime.parse(json["created_at"]),
        updatedAt: json["updated_at"] == null ? null : DateTime.parse(json["updated_at"]),
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "country_id": countryId,
        "name": name,
        "bank_code": bankCode,
        "operatorId": operatorId,
        "localMinAmount": localMinAmount,
        "localMaxAmount": localMaxAmount,
        "service_id": serviceId,
        "status": status,
        "created_at": createdAt?.toIso8601String(),
        "updated_at": updatedAt?.toIso8601String(),
    };
}
