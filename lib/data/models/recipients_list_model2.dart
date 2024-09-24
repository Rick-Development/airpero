// To parse this JSON data, do
//
//     final recipientListModel2 = recipientListModel2FromJson(jsonString);

import 'dart:convert';

RecipientListModel2 recipientListModel2FromJson(String str) =>
    RecipientListModel2.fromJson(json.decode(str));

String recipientListModel2ToJson(RecipientListModel2 data) =>
    json.encode(data.toJson());

class RecipientListModel2 {
  Message? message;

  RecipientListModel2({
    this.message,
  });

  factory RecipientListModel2.fromJson(Map<String, dynamic> json) =>
      RecipientListModel2(
        message:
            json["message"] == null ? null : Message.fromJson(json["message"]),
      );

  Map<String, dynamic> toJson() => {
        "message": message?.toJson(),
      };
}

class Message {
  List<User>? users;

  Message({
    this.users,
  });

  factory Message.fromJson(Map<String, dynamic> json) => Message(
        users: json["users"] == null
            ? []
            : List<User>.from(json["users"]!.map((x) => User.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "users": users == null
            ? []
            : List<dynamic>.from(users!.map((x) => x.toJson())),
      };
}

class User {
  dynamic id;
  dynamic firstname;
  dynamic lastname;
  dynamic username;
  dynamic referralId;
  dynamic referBonus;
  dynamic languageId;
  dynamic email;
  dynamic countryCode;
  dynamic country;
  dynamic phoneCode;
  dynamic phone;
  dynamic image;
  dynamic imageDriver;
  dynamic state;
  dynamic city;
  dynamic zipCode;
  dynamic addressOne;
  dynamic addressTwo;
  dynamic provider;
  dynamic providerId;
  dynamic status;
  dynamic twoFa;
  dynamic twoFaVerify;
  dynamic twoFaCode;
  dynamic emailVerification;
  dynamic smsVerification;
  dynamic verifyCode;
  dynamic sentAt;
  dynamic lastLogin;
  dynamic lastSeen;
  dynamic timeZone;
  dynamic emailVerifiedAt;
  dynamic createdAt;
  dynamic updatedAt;
  dynamic deletedAt;
  dynamic lastSeenActivity;

  User({
    this.id,
    this.firstname,
    this.lastname,
    this.username,
    this.referralId,
    this.referBonus,
    this.languageId,
    this.email,
    this.countryCode,
    this.country,
    this.phoneCode,
    this.phone,
    this.image,
    this.imageDriver,
    this.state,
    this.city,
    this.zipCode,
    this.addressOne,
    this.addressTwo,
    this.provider,
    this.providerId,
    this.status,
    this.twoFa,
    this.twoFaVerify,
    this.twoFaCode,
    this.emailVerification,
    this.smsVerification,
    this.verifyCode,
    this.sentAt,
    this.lastLogin,
    this.lastSeen,
    this.timeZone,
    this.emailVerifiedAt,
    this.createdAt,
    this.updatedAt,
    this.deletedAt,
    this.lastSeenActivity,
  });

  factory User.fromJson(Map<String, dynamic> json) => User(
        id: json["id"],
        firstname: json["firstname"],
        lastname: json["lastname"],
        username: json["username"],
        referralId: json["referral_id"],
        referBonus: json["refer_bonus"],
        languageId: json["language_id"],
        email: json["email"],
        countryCode: json["country_code"],
        country: json["country"],
        phoneCode: json["phone_code"],
        phone: json["phone"],
        image: json["image"],
        imageDriver: json["image_driver"],
        state: json["state"],
        city: json["city"],
        zipCode: json["zip_code"],
        addressOne: json["address_one"],
        addressTwo: json["address_two"],
        provider: json["provider"],
        providerId: json["provider_id"],
        status: json["status"],
        twoFa: json["two_fa"],
        twoFaVerify: json["two_fa_verify"],
        twoFaCode: json["two_fa_code"],
        emailVerification: json["email_verification"],
        smsVerification: json["sms_verification"],
        verifyCode: json["verify_code"],
        sentAt: json["sent_at"],
        lastLogin: json["last_login"] == null
            ? null
            : DateTime.parse(json["last_login"]),
        lastSeen: json["last_seen"] == null
            ? null
            : DateTime.parse(json["last_seen"]),
        timeZone: json["time_zone"],
        emailVerifiedAt: json["email_verified_at"],
        createdAt: json["created_at"] == null
            ? null
            : DateTime.parse(json["created_at"]),
        updatedAt: json["updated_at"] == null
            ? null
            : DateTime.parse(json["updated_at"]),
        deletedAt: json["deleted_at"],
        lastSeenActivity: json["last-seen-activity"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "firstname": firstname,
        "lastname": lastname,
        "username": username,
        "referral_id": referralId,
        "refer_bonus": referBonus,
        "language_id": languageId,
        "email": email,
        "country_code": countryCode,
        "country": country,
        "phone_code": phoneCode,
        "phone": phone,
        "image": image,
        "image_driver": imageDriver,
        "state": state,
        "city": city,
        "zip_code": zipCode,
        "address_one": addressOne,
        "address_two": addressTwo,
        "provider": provider,
        "provider_id": providerId,
        "status": status,
        "two_fa": twoFa,
        "two_fa_verify": twoFaVerify,
        "two_fa_code": twoFaCode,
        "email_verification": emailVerification,
        "sms_verification": smsVerification,
        "verify_code": verifyCode,
        "sent_at": sentAt,
        "last_login": lastLogin?.toIso8601String(),
        "last_seen": lastSeen?.toIso8601String(),
        "time_zone": timeZone,
        "email_verified_at": emailVerifiedAt,
        "created_at": createdAt?.toIso8601String(),
        "updated_at": updatedAt?.toIso8601String(),
        "deleted_at": deletedAt,
        "last-seen-activity": lastSeenActivity,
      };
}
