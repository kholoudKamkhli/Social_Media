class Message {
  static const String COLLECTION_NAME = "Message";
  String content;
  String recieverId;
  int dateTime;
  String senderId;

  Message({
    required this.content,
    required this.dateTime,
    required this.senderId,
    required this.recieverId,
  });

  Message.fromJson(Map<String, dynamic> json)
      : this(
    content: json["content"],
    recieverId: json["recieverId"],
    dateTime: json["dateTime"],
    senderId: json["senderId"],
  );

  Map<String, dynamic> toJson() {
    return {
      "content": content,
      "dateTime": dateTime,
      "senderId": senderId,
      "recieverId": recieverId,
    };
  }
}
