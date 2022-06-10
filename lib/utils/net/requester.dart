import 'dart:convert';

import 'package:client/utils/net/model/login.dart';
import 'package:http/http.dart' as http;

Future<Login> login(String email, String password) async {
  http.Response response = await http.post(
      Uri.parse("http://132.226.16.134:8080/login"),
      headers: {"Email": email, "Password": password});
  String responseBody = utf8.decoder.convert(response.bodyBytes);
  print(responseBody);
  return Login.fromJson(json.decode(responseBody));
}

Future<Login> register(String email, String password, String username) async {
  http.Response response = await http.post(
      Uri.parse("http://132.226.16.134:8080/signup"),
      headers: {"Email": email, "Password": password, "Nickname": username});
  String responseBody = utf8.decoder.convert(response.bodyBytes);
  print(responseBody);
  return Login.fromJson(json.decode(responseBody));
}
