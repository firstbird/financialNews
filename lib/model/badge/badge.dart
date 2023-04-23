// 角标
class Badge {
  late String type;
  late int value;
  late String text;
  late bool show;
  late bool dot;

  Badge({this.type = "", this.value = 0, this.text = "", this.show = false, this.dot = false});

  Badge.fromJson(Map<String, dynamic> json) {
    type = json['type'];
    value = json['value'];
    text = json['text'];
    show = json['show'];
    dot = json['dot'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['type'] = this.type;
    data['value'] = this.value;
    data['text'] = this.text;
    data['show'] = this.show;
    data['dot'] = this.dot;
    return data;
  }
}
