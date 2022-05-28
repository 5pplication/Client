class Login {
  final String message;

  Login({required this.message});

  factory Login.fromJson(Map<String, dynamic> json) {
    return Login(
      message: json["message"] as String,
    );
  }
}
