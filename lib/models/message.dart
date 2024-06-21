class Message {
  final String content;

  Message(this.content);

  factory Message.fromJson(Map<String, dynamic> json) {
    return Message(json['content']);
  }
}
