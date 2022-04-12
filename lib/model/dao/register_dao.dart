class RegisterDao {
  RegisterDao(this.username, this.email, this.password);

  RegisterDao.fromJson(Map<String, dynamic> json)
      : username = json['username'] as String,
        email = json['email'] as String,
        password = json['password'] as String;

  final String username;
  final String email;
  final String password;

  Map<String, dynamic> toJson() => <String, dynamic>{
        'username': username,
        'email': email,
        'password': password
      };
}
