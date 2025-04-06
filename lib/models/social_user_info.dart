class SocialUser {
  final String id;
  final String email;

  SocialUser({
    required this.id,
    required this.email,
  });

  // JSON 데이터를 모델 객체로 변환하는 팩토리 메서드
  factory SocialUser.fromJson(Map<String, dynamic> json) {
    return SocialUser(
      id: json['id'].toString(),
      email: json['kakao_account']['email'] ?? '',
    );
  }

  // 모델 객체를 JSON으로 변환하는 메서드
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'email': email,
    };
  }
}
