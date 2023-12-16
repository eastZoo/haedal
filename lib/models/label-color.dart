class LabelColor {
  String id;
  String code;
  String name;

  LabelColor({
    required this.id,
    required this.code,
    required this.name,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'code': code,
      'name': name,
    };
  }

  factory LabelColor.fromJson(Map<String, dynamic> json) {
    return LabelColor(
      id: json['id'] as String,
      code: json['code'] as String,
      name: json['name'] as String,
    );
  }
}
