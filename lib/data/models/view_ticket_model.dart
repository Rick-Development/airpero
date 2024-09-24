class ViewTicketModel {
  Message? message;

  ViewTicketModel({this.message});

  ViewTicketModel.fromJson(Map<String, dynamic> json) {
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
  Tickets? tickets;

  Message({this.tickets});

  Message.fromJson(Map<String, dynamic> json) {
    tickets =
        json['tickets'] != null ? new Tickets.fromJson(json['tickets']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.tickets != null) {
      data['tickets'] = this.tickets!.toJson();
    }
    return data;
  }
}

class Tickets {
  dynamic id;
  dynamic ticket;
  dynamic subject;
  dynamic status;
  List<Messages>? messages;

  Tickets({this.id, this.ticket, this.subject, this.messages});

  Tickets.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    ticket = json['ticket'];
    subject = json['subject'];
    status = json['status'];
    if (json['messages'] != null) {
      messages = <Messages>[];
      json['messages'].forEach((v) {
        messages!.add(new Messages.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['ticket'] = this.ticket;
    data['subject'] = this.subject;
    data['status'] = this.status;
    if (this.messages != null) {
      data['messages'] = this.messages!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Messages {
  dynamic id;
  dynamic supportTicketId;
  dynamic adminId;
  dynamic adminImage;
  dynamic message;
  dynamic createdAt;
  dynamic updatedAt;
  List<Attachments>? attachments;

  Messages(
      {this.id,
      this.supportTicketId,
      this.adminId,
      this.adminImage,
      this.message,
      this.createdAt,
      this.updatedAt,
      this.attachments});

  Messages.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    supportTicketId = json['support_ticket_id'];
    adminId = json['admin_id'];
    adminImage = json['adminImage'];
    message = json['message'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    if (json['attachments'] != null) {
      attachments = <Attachments>[];
      json['attachments'].forEach((v) {
        attachments!.add(new Attachments.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['support_ticket_id'] = this.supportTicketId;
    data['admin_id'] = this.adminId;
    data['adminImage'] = this.adminImage;
    data['message'] = this.message;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    if (this.attachments != null) {
      data['attachments'] = this.attachments!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Attachments {
  dynamic id;
  dynamic supportTicketMessageId;
  dynamic file;
  dynamic file_name;

  Attachments({this.id, this.supportTicketMessageId, this.file,this.file_name});

  Attachments.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    supportTicketMessageId = json['support_ticket_message_id'];
    file = json['file'];
    file_name = json['file_name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['support_ticket_message_id'] = this.supportTicketMessageId;
    data['file'] = this.file;
    data['file_name'] = this.file_name;
    return data;
  }
}
