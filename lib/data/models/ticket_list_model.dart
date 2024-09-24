class TicketListModel {
  Message? message;

  TicketListModel({ this.message});

  TicketListModel.fromJson(Map<String, dynamic> json) {
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
  List<Tickets>? tickets;

  Message({this.tickets});

  Message.fromJson(Map<String, dynamic> json) {
    if (json['tickets'] != null) {
      tickets = <Tickets>[];
      json['tickets'].forEach((v) {
        tickets!.add(new Tickets.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.tickets != null) {
      data['tickets'] = this.tickets!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Tickets {
  dynamic id;
  dynamic userId;
  dynamic ticket;
  dynamic subject;
  dynamic status;
  dynamic lastReply;
  dynamic createdAt;
  dynamic updatedAt;

  Tickets(
      {this.id,
      this.userId,
      this.ticket,
      this.subject,
      this.status,
      this.lastReply,
      this.createdAt,
      this.updatedAt});

  Tickets.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    userId = json['user_id'];
    ticket = json['ticket'];
    subject = json['subject'];
    status = json['status'];
    lastReply = json['last_reply'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['user_id'] = this.userId;
    data['ticket'] = this.ticket;
    data['subject'] = this.subject;
    data['status'] = this.status;
    data['last_reply'] = this.lastReply;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    return data;
  }
}
