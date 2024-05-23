class UserInfo {
  String userEmail;
  String name;
  // int age;
  String sex;

  UserInfo({
    required this.userEmail,
    required this.name,
    // required this.age,
    required this.sex,
  });
  Map<String, dynamic> toJson() {
    return {
      'userEmail': userEmail,
      'name': name,
      // 'age': age,
      'sex': sex,
    };
  }

  factory UserInfo.fromJson(Map<String, dynamic> json) {
    return UserInfo(
      userEmail: json['userEmail'] as String,
      name: json['name'] as String,
      // age: json['age'] as int,
      sex: json['sex'] as String,
    );
  }
}
