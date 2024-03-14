class AppUser {
  final String id;
  final String fullName;

  final String email;
  final DateTime regTime;

  AppUser({
    required this.id,
    required this.fullName,
    required this.email,
    required this.regTime,
  });

  AppUser.fromMap(Map<String, dynamic> data)
      : id = data['id'] ?? "",
        fullName = data['fullName'] ?? "nil",
        email = data['email'] ?? "nil",
        regTime =
            data['regTime'] != null ? data['regTime'].toDate() : DateTime.now();

  Map<String, dynamic> toJson(keyword) {
    Map<String, dynamic> map = {
      'id': id,
      'fullName': fullName,
      'keyword': keyword,
      'email': email,
      'regTime': regTime,
    };
    
    return map;
  }
}
