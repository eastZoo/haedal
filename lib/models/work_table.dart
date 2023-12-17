class User {
  final String? id;
  final String? name;
  final String? coupleId;
  final String? userEmail;
  final String? password;
  final DateTime? birth;
  final String? age;
  final String? sex;
  final String? phoneNumber;
  final DateTime? firstDay;
  final int? connectState;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  User({
    this.id,
    this.name,
    this.coupleId,
    this.userEmail,
    this.password,
    this.birth,
    this.age,
    this.sex,
    this.phoneNumber,
    this.firstDay,
    this.connectState,
    this.createdAt,
    this.updatedAt,
  });

  // Add a factory method to create a User object from a Map
  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      name: json['name'],
      coupleId: json['coupleId'],
      userEmail: json['userEmail'],
      password: json['password'],
      birth: DateTime.parse(json['birth']),
      age: json['age'],
      sex: json['sex'],
      phoneNumber: json['phoneNumber'],
      firstDay: DateTime.parse(json['firstDay']),
      connectState: json['connectState'],
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt: DateTime.parse(json['updatedAt']),
    );
  }
}

class FileData {
  final String id;
  final String workScheduleId;
  final String path;
  final String filename;

  FileData({
    required this.id,
    required this.workScheduleId,
    required this.path,
    required this.filename,
  });

  // Add a factory method to create a FileData object from a Map
  factory FileData.fromJson(Map<String, dynamic> json) {
    return FileData(
      id: json['id'],
      workScheduleId: json['workScheduleId'],
      path: json['path'],
      filename: json['filename'],
    );
  }
}

class WorkTable {
  final String? id;
  final String? userId;
  final String? coupleId;
  final DateTime? workMonth;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final User? user;
  final List<FileData>? workScheduleFile;
  WorkTable({
    this.id,
    this.userId,
    this.coupleId,
    this.workMonth,
    this.createdAt,
    this.updatedAt,
    this.user,
    this.workScheduleFile,
  });

  // Add a factory method to create an WorkTable object from a Map
  factory WorkTable.fromJson(Map<String, dynamic> json) {
    return WorkTable(
      id: json['id'],
      userId: json['userId'],
      coupleId: json['coupleId'],
      workMonth: DateTime.parse(json['workMonth']),
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt: DateTime.parse(json['updatedAt']),
      user: User.fromJson(json['user']),
      workScheduleFile: (json['workScheduleFile'] as List<dynamic>)
          .map((file) => FileData.fromJson(file))
          .toList(),
    );
  }
}
