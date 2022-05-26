import 'package:client/ui/pages/login.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(
    const Client(),
  );
}

class Client extends StatelessWidget {
  const Client({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'client',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
        brightness: Brightness.dark,
      ),
      // home: const Clock(title: 'client'),
      home: const Login(title: 'client'),
    );
  }
}
