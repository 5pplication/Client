import 'dart:convert';

import 'package:client/utils/net/model/article.dart';
import 'package:client/utils/net/model/login.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

import 'model/signup.dart';

const String host = "http://132.226.16.134:8080";

Future<Login> login(String email, String password) async {
  http.Response response = await http.post(Uri.parse("$host/login"),
      headers: {"Email": email, "Password": password});
  String responseBody = utf8.decoder.convert(response.bodyBytes);
  if (kDebugMode) {
    print(responseBody);
  }
  return Login.fromJson(json.decode(responseBody));
}

Future<SignUp> register(String email, String password, String username) async {
  http.Response response = await http.post(Uri.parse("$host/signup"),
      headers: {"Email": email, "Password": password, "Nickname": username});
  String responseBody = utf8.decoder.convert(response.bodyBytes);
  if (kDebugMode) {
    print(responseBody);
  }
  return SignUp.fromJson(json.decode(responseBody));
}

Future<List<Article>> getArticleByPos(String lat, String long) async {
  List<Article> result = [];
  http.Response response =
      await http.get(Uri.parse("$host/article/get?lat=$lat&long=$long"));
  String responseBody = utf8.decoder.convert(response.bodyBytes);
  if (kDebugMode) {
    print(responseBody);
  }
  final List t = json.decode(response.body);
  final List<Article> portasAbertasList =
      t.map((item) => Article.fromJson(item)).toList();
  return portasAbertasList;
}

Future<Article> getArticleByArticleNo(String articleNo) async {
  http.Response response =
      await http.get(Uri.parse("$host/article/get?atclNo=$articleNo"));
  String responseBody = utf8.decoder.convert(response.bodyBytes);
  if (kDebugMode) {
    print(responseBody);
  }
  return Article.fromJson(json.decode(responseBody));
}

String getImageUrl(String imageNo) {
  String url = host + "/image?imageNo=" + imageNo;
  print("'$url'");
  return url;
}
