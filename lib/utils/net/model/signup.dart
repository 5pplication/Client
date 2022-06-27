class SignUp {
  final String message;

  SignUp({required this.message});

  factory SignUp.fromJson(Map<String, dynamic> json) {
    return SignUp(
      message: json["message"] as String,
    );
  }
}
