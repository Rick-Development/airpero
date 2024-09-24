// To parse this JSON data, do
//
//     final moneyRequestWalletModel = moneyRequestWalletModelFromJson(jsonString);

import 'dart:convert';

MoneyRequestWalletModel moneyRequestWalletModelFromJson(String str) => MoneyRequestWalletModel.fromJson(json.decode(str));

String moneyRequestWalletModelToJson(MoneyRequestWalletModel data) => json.encode(data.toJson());

class MoneyRequestWalletModel {
    Message? message;

    MoneyRequestWalletModel({
        this.message,
    });

    factory MoneyRequestWalletModel.fromJson(Map<String, dynamic> json) => MoneyRequestWalletModel(
        message: json["message"] == null ? null : Message.fromJson(json["message"]),
    );

    Map<String, dynamic> toJson() => {
        "message": message?.toJson(),
    };
}

class Message {
    List<Wallet>? wallets;
    Recipient? recipient;

    Message({
        this.wallets,
        this.recipient,
    });

    factory Message.fromJson(Map<String, dynamic> json) => Message(
        wallets: json["wallets"] == null ? [] : List<Wallet>.from(json["wallets"]!.map((x) => Wallet.fromJson(x))),
        recipient: json["recipient"] == null ? null : Recipient.fromJson(json["recipient"]),
    );

    Map<String, dynamic> toJson() => {
        "wallets": wallets == null ? [] : List<dynamic>.from(wallets!.map((x) => x.toJson())),
        "recipient": recipient?.toJson(),
    };
}

class Recipient {
    dynamic id;
    dynamic firstname;
    dynamic lastname;
    dynamic username;

    Recipient({
        this.id,
        this.firstname,
        this.lastname,
        this.username,
    });

    factory Recipient.fromJson(Map<String, dynamic> json) => Recipient(
        id: json["id"],
        firstname: json["firstname"],
        lastname: json["lastname"],
        username: json["username"],
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "firstname": firstname,
        "lastname": lastname,
        "username": username,
    };
}

class Wallet {
    dynamic id;
    dynamic uuid;
    dynamic userId;
    dynamic currencyCode;
    dynamic balance;
    dynamic status;
    dynamic walletDefault;
    dynamic createdAt;
    dynamic updatedAt;
    Currency? currency;

    Wallet({
        this.id,
        this.uuid,
        this.userId,
        this.currencyCode,
        this.balance,
        this.status,
        this.walletDefault,
        this.createdAt,
        this.updatedAt,
        this.currency,
    });

    factory Wallet.fromJson(Map<String, dynamic> json) => Wallet(
        id: json["id"],
        uuid: json["uuid"],
        userId: json["user_id"],
        currencyCode: json["currency_code"],
        balance: json["balance"],
        status: json["status"],
        walletDefault: json["default"],
        createdAt: json["created_at"] == null ? null : DateTime.parse(json["created_at"]),
        updatedAt: json["updated_at"] == null ? null : DateTime.parse(json["updated_at"]),
        currency: json["currency"] == null ? null : Currency.fromJson(json["currency"]),
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "uuid": uuid,
        "user_id": userId,
        "currency_code": currencyCode,
        "balance": balance,
        "status": status,
        "default": walletDefault,
        "created_at": createdAt?.toIso8601String(),
        "updated_at": updatedAt?.toIso8601String(),
        "currency": currency?.toJson(),
    };
}

class Currency {
    dynamic id;
    dynamic countryId;
    dynamic name;
    dynamic code;
    dynamic rate;
    dynamic currencyDefault;
    dynamic precision;
    dynamic symbol;
    dynamic symbolNative;
    dynamic symbolFirst;
    dynamic decimalMark;
    dynamic thousandsSeparator;
    dynamic createdAt;
    dynamic updatedAt;

    Currency({
        this.id,
        this.countryId,
        this.name,
        this.code,
        this.rate,
        this.currencyDefault,
        this.precision,
        this.symbol,
        this.symbolNative,
        this.symbolFirst,
        this.decimalMark,
        this.thousandsSeparator,
        this.createdAt,
        this.updatedAt,
    });

    factory Currency.fromJson(Map<String, dynamic> json) => Currency(
        id: json["id"],
        countryId: json["country_id"],
        name: json["name"],
        code: json["code"],
        rate: json["rate"],
        currencyDefault: json["default"],
        precision: json["precision"],
        symbol: json["symbol"],
        symbolNative: json["symbol_native"],
        symbolFirst: json["symbol_first"],
        decimalMark: json["decimal_mark"],
        thousandsSeparator: json["thousands_separator"],
        createdAt: json["created_at"] == null ? null : DateTime.parse(json["created_at"]),
        updatedAt: json["updated_at"] == null ? null : DateTime.parse(json["updated_at"]),
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "country_id": countryId,
        "name": name,
        "code": code,
        "rate": rate,
        "default": currencyDefault,
        "precision": precision,
        "symbol": symbol,
        "symbol_native": symbolNative,
        "symbol_first": symbolFirst,
        "decimal_mark": decimalMark,
        "thousands_separator": thousandsSeparator,
        "created_at": createdAt?.toIso8601String(),
        "updated_at": updatedAt?.toIso8601String(),
    };
}
