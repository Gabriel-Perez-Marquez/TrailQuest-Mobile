class AuthResponse {
  final String username;
  final String token;

  AuthResponse({
    required this.username,
    required this.token,
  });

  factory AuthResponse.fromJson(Map<String, dynamic> json) {
    return AuthResponse(
      username: json['username'],
      token: json['accessToken'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'username': username,
      'token': token,
    };
  }
}
