class Foods {
  String? name;

  String? value;

  Foods({
    this.name,
    this.value,
  });

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'value': value,
    };
  }

  factory Foods.fromJson(Map<String, dynamic> json) {
    return Foods(
      name: json['name'] as String,
      value: json['value'] as String,
    );
  }
}
