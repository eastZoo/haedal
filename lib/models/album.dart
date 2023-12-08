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
  final String albumBoardId;
  final String path;
  final String filename;

  FileData({
    required this.id,
    required this.albumBoardId,
    required this.path,
    required this.filename,
  });

  // Add a factory method to create a FileData object from a Map
  factory FileData.fromJson(Map<String, dynamic> json) {
    return FileData(
      id: json['id'],
      albumBoardId: json['albumBoardId'],
      path: json['path'],
      filename: json['filename'],
    );
  }
}

class AlbumBoard {
  final String? id;
  final String? userId;
  final String? coupleId;
  final String? title;
  final String? category;
  final dynamic
      content; // Change the type accordingly if content can be something other than null
  final String? lat;
  final String? lng;
  final String? address;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final User? user;
  final List<FileData>? files;

  AlbumBoard({
    this.id,
    this.userId,
    this.coupleId,
    this.title,
    this.category,
    this.content,
    this.lat,
    this.lng,
    this.address,
    this.createdAt,
    this.updatedAt,
    this.user,
    this.files,
  });

  // Add a factory method to create an AlbumBoard object from a Map
  factory AlbumBoard.fromJson(Map<String, dynamic> json) {
    return AlbumBoard(
      id: json['id'],
      userId: json['userId'],
      coupleId: json['coupleId'],
      title: json['title'],
      category: json['category'],
      content: json['content'],
      lat: json['lat'],
      lng: json['lng'],
      address: json['address'],
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt: DateTime.parse(json['updatedAt']),
      user: User.fromJson(json['user']),
      files: (json['files'] as List<dynamic>)
          .map((file) => FileData.fromJson(file))
          .toList(),
    );
  }
}
