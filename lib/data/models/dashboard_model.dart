// To parse this JSON data, do
//
//     final dashboardModel = dashboardModelFromJson(jsonString);

import 'dart:convert';

DashboardModel dashboardModelFromJson(String str) =>
    DashboardModel.fromJson(json.decode(str));

String dashboardModelToJson(DashboardModel data) => json.encode(data.toJson());

class DashboardModel {
  Message? message;

  DashboardModel({
    this.message,
  });

  factory DashboardModel.fromJson(Map<String, dynamic> json) => DashboardModel(
        message:
            json["message"] == null ? null : Message.fromJson(json["message"]),
      );

  Map<String, dynamic> toJson() => {
        "message": message?.toJson(),
      };
}

class Message {
  dynamic baseCurrency;
  dynamic baseCurrencySymbol;
  List<Wallet>? wallets;
  List<Currency>? currency;

  Message({
    this.baseCurrency,
    this.baseCurrencySymbol,
    this.wallets,
    this.currency,
  });

  factory Message.fromJson(Map<String, dynamic> json) => Message(
        baseCurrency: json["baseCurrency"],
        baseCurrencySymbol: json["baseCurrencySymbol"],
        wallets: json["wallets"] == null
            ? []
            : List<Wallet>.from(
                json["wallets"]!.map((x) => Wallet.fromJson(x))),
        currency: json["currency"] == null
            ? []
            : List<Currency>.from(
                json["currency"]!.map((x) => Currency.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "baseCurrency": baseCurrency,
        "baseCurrencySymbol": baseCurrencySymbol,
        "wallets": wallets == null
            ? []
            : List<dynamic>.from(wallets!.map((x) => x.toJson())),
        "currency": currency == null
            ? []
            : List<dynamic>.from(currency!.map((x) => x.toJson())),
      };
}

class Currency {
  dynamic name;
  dynamic code;
  dynamic countryId;
  Country? country;

  Currency({
    this.name,
    this.code,
    this.countryId,
    this.country,
  });

  factory Currency.fromJson(Map<String, dynamic> json) => Currency(
        name: json["name"],
        code: json["code"],
        countryId: json["country_id"],
        country:
            json["country"] == null ? null : Country.fromJson(json["country"]),
      );

  Map<String, dynamic> toJson() => {
        "name": name,
        "code": code,
        "country_id": countryId,
        "country": country?.toJson(),
      };
}

class Country {
  dynamic id;
  dynamic name;
  dynamic image;
  dynamic imageDriver;

  Country({
    this.id,
    this.name,
    this.image,
    this.imageDriver,
  });

  factory Country.fromJson(Map<String, dynamic> json) => Country(
        id: json["id"],
        name: json["name"],
        image: json["image"],
        imageDriver: json["image_driver"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "image": image,
        "image_driver": imageDriver,
      };
}

class CurrencyRate {
  dynamic id;
  dynamic code;
  dynamic rate;

  CurrencyRate({
    this.id,
    this.code,
    this.rate,
  });

  factory CurrencyRate.fromJson(Map<String, dynamic> json) => CurrencyRate(
        id: json["id"],
        code: json["code"],
        rate: json["rate"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "code": code,
        "rate": rate,
      };
}

class Wallet {
  dynamic id;
  dynamic uuid;
  dynamic currencyCode;
  dynamic balance;
  dynamic status;
  dynamic walletDefault;
  CurrencyRate? currencyRate;

  Wallet({
    this.id,
    this.uuid,
    this.currencyCode,
    this.balance,
    this.status,
    this.walletDefault,
    this.currencyRate,
  });

  factory Wallet.fromJson(Map<String, dynamic> json) => Wallet(
        id: json["id"],
        uuid: json["uuid"],
        currencyCode: json["currency_code"],
        balance: json["balance"],
        status: json["status"],
        walletDefault: json["default"],
        currencyRate: json["currency"] == null
            ? null
            : CurrencyRate.fromJson(json["currency"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "uuid": uuid,
        "currency_code": currencyCode,
        "balance": balance,
        "status": status,
        "default": walletDefault,
        "currencies": currencyRate?.toJson(),
      };
}
