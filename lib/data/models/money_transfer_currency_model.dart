// To parse this JSON data, do
//
//     final moneyTransferCurrencyModel = moneyTransferCurrencyModelFromJson(jsonString);

import 'dart:convert';

MoneyTransferCurrencyModel moneyTransferCurrencyModelFromJson(String str) =>
    MoneyTransferCurrencyModel.fromJson(json.decode(str));

String moneyTransferCurrencyModelToJson(MoneyTransferCurrencyModel data) =>
    json.encode(data.toJson());

class MoneyTransferCurrencyModel {
  Message? message;

  MoneyTransferCurrencyModel({
    this.message,
  });

  factory MoneyTransferCurrencyModel.fromJson(Map<String, dynamic> json) =>
      MoneyTransferCurrencyModel(
        message:
            json["message"] == null ? null : Message.fromJson(json["message"]),
      );

  Map<String, dynamic> toJson() => {
        "message": message?.toJson(),
      };
}

class Message {
  Limitations? limitations;
  List<SenderCurrency>? senderCurrencies;
  List<SenderCurrency>? receiverCurrencies;

  Message({
    this.limitations,
    this.senderCurrencies,
    this.receiverCurrencies,
  });

  factory Message.fromJson(Map<String, dynamic> json) => Message(
        limitations: json["limitations"] == null
            ? null
            : Limitations.fromJson(json["limitations"]),
        senderCurrencies: json["senderCurrencies"] == null
            ? []
            : List<SenderCurrency>.from(json["senderCurrencies"]!
                .map((x) => SenderCurrency.fromJson(x))),
        receiverCurrencies: json["receiverCurrencies"] == null
            ? []
            : List<SenderCurrency>.from(json["receiverCurrencies"]!
                .map((x) => SenderCurrency.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "limitations": limitations?.toJson(),
        "senderCurrencies": senderCurrencies == null
            ? []
            : List<dynamic>.from(senderCurrencies!.map((x) => x.toJson())),
        "receiverCurrencies": receiverCurrencies == null
            ? []
            : List<dynamic>.from(receiverCurrencies!.map((x) => x.toJson())),
      };
}

class Limitations {
  dynamic minimumAmount;
  dynamic maximumAmount;
  dynamic minimumTransferFee;
  dynamic maximumTransferFee;
  dynamic currency;

  Limitations({
    this.minimumAmount,
    this.maximumAmount,
    this.minimumTransferFee,
    this.maximumTransferFee,
    this.currency,
  });

  factory Limitations.fromJson(Map<String, dynamic> json) => Limitations(
        minimumAmount: json["minimum_amount"],
        maximumAmount: json["maximum_amount"],
        minimumTransferFee: json["minimum_transfer_fee"]?.toDouble(),
        maximumTransferFee: json["maximum_transfer_fee"],
        currency: json["currency"],
      );

  Map<String, dynamic> toJson() => {
        "minimum_amount": minimumAmount,
        "maximum_amount": maximumAmount,
        "minimum_transfer_fee": minimumTransferFee,
        "maximum_transfer_fee": maximumTransferFee,
        "currency": currency,
      };
}

class SenderCurrency {
  dynamic id;
  dynamic currencyCode;
  dynamic currency_name;
  dynamic countryName;
  dynamic countryImage;
  dynamic rate;
  dynamic sendTo;
  dynamic receiveFrom;

  SenderCurrency({
    this.id,
    this.currencyCode,
    this.currency_name,
    this.countryName,
    this.countryImage,
    this.rate,
    this.sendTo,
    this.receiveFrom,
  });

  factory SenderCurrency.fromJson(Map<String, dynamic> json) => SenderCurrency(
        id: json["id"],
        currencyCode: json["currency_code"],
        currency_name: json["currency_name"],
        countryName: json["country_name"],
        countryImage: json["country_image"],
        rate: json["rate"],
        sendTo: json["send_to"],
        receiveFrom: json["receive_from"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "currency_code": currencyCode,
        "currency_name": currency_name,
        "country_name": countryName,
        "country_image": countryImage,
        "rate": rate,
        "send_to": sendTo,
        "receive_from": receiveFrom,
      };
}
