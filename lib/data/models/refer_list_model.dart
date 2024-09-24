// To parse this JSON data, do
//
//     final referralList = referralListFromJson(jsonString);

import 'dart:convert';

ReferralList referralListFromJson(String str) => ReferralList.fromJson(json.decode(str));

String referralListToJson(ReferralList data) => json.encode(data.toJson());

class ReferralList {
    Message? message;

    ReferralList({
        this.message,
    });

    factory ReferralList.fromJson(Map<String, dynamic> json) => ReferralList(
        message: json["message"] == null ? null : Message.fromJson(json["message"]),
    );

    Map<String, dynamic> toJson() => {
        "message": message?.toJson(),
    };
}

class Message {
    List<ReferUser>? referUser;

    Message({
        this.referUser,
    });

    factory Message.fromJson(Map<String, dynamic> json) => Message(
        referUser: json["referUser"] == null ? [] : List<ReferUser>.from(json["referUser"]!.map((x) => ReferUser.fromJson(x))),
    );

    Map<String, dynamic> toJson() => {
        "referUser": referUser == null ? [] : List<dynamic>.from(referUser!.map((x) => x.toJson())),
    };
}

class ReferUser {
    dynamic id;
    dynamic firstname;
    dynamic lastname;
    dynamic email;
    dynamic phone;
    dynamic country;
    dynamic addressOne;
    dynamic addressTwo;
    dynamic image;
    dynamic join_date;

    ReferUser({
        this.id,
        this.firstname,
        this.lastname,
        this.email,
        this.phone,
        this.country,
        this.addressOne,
        this.addressTwo,
        this.image,
        this.join_date,
    });

    factory ReferUser.fromJson(Map<String, dynamic> json) => ReferUser(
        id: json["id"],
        firstname: json["firstname"],
        lastname: json["lastname"],
        email: json["email"],
        phone: json["phone"],
        country: json["country"],
        addressOne: json["address_one"],
        addressTwo: json["address_two"],
        image: json["image"],
        join_date: json["join_date"],
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "firstname": firstname,
        "lastname": lastname,
        "email": email,
        "phone": phone,
        "country": country,
        "address_one": addressOne,
        "address_two": addressTwo,
        "image": image,
        "join_date": join_date,
    };
}
