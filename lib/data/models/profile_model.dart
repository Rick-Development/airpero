class ProfileModel {
  Message? message;

  ProfileModel({ this.message});

  ProfileModel.fromJson(Map<String, dynamic> json) {
    message =
        json['message'] != null ? new Message.fromJson(json['message']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.message != null) {
      data['message'] = this.message!.toJson();
    }
    return data;
  }
}

class Message {
  Profile? profile;

  Message({this.profile});

  Message.fromJson(Map<String, dynamic> json) {
    profile =
        json['profile'] != null ? new Profile.fromJson(json['profile']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.profile != null) {
      data['profile'] = this.profile!.toJson();
    }
    return data;
  }
}

class Profile {
  dynamic id;
  dynamic firstname;
  dynamic lastname;
  dynamic username;
  dynamic email;
  dynamic phone;
  dynamic addressOne;
  dynamic addressTwo;
  dynamic image;
  dynamic userJoinDate;
  dynamic language_id;
  dynamic languageName;
  dynamic phone_code;
  dynamic country;
  dynamic country_code;

  Profile(
      {this.id,
      this.firstname,
      this.lastname,
      this.username,
      this.email,
      this.phone,
      this.addressOne,
      this.addressTwo,
      this.image,
      this.userJoinDate,
      this.language_id,
      this.languageName,
      this.phone_code,
      this.country,
      this.country_code,
      });

  Profile.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    firstname = json['firstname'];
    lastname = json['lastname'];
    username = json['username'];
    email = json['email'];
    phone = json['phone'];
    addressOne = json['address_one'] ?? "";
    addressTwo = json['address_two'] ?? "";
    image = json['image'];
    userJoinDate = json['userJoinDate'];
    language_id = json['language_id'];
    languageName = json['Language'];
    phone_code = json['phone_code'] ?? "";
    country = json['country'] ?? "";
    country_code = json['country_code'] ?? "";
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['firstname'] = this.firstname;
    data['lastname'] = this.lastname;
    data['username'] = this.username;
    data['email'] = this.email;
    data['phone'] = this.phone;
    data['address_one'] = this.addressOne;
    data['address_two'] = this.addressTwo;
    data['image'] = this.image;
    data['userJoinDate'] = this.userJoinDate;
    data['language_id'] = this.language_id;
    data['Language'] = this.languageName;
    data['phone_code'] = this.phone_code;
    data['country'] = this.country;
    data['country_code'] = this.country_code;
    return data;
  }
}
