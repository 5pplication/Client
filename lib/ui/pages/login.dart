import 'package:client/ui/holder/zoomable_scaffold.dart';
import 'package:client/ui/view/login.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

class Login extends StatefulWidget {
  const Login({Key? key, this.title}) : super(key: key);

  final String? title;

  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> with TickerProviderStateMixin {
  late MenuController menuController;

  @override
  void initState() {
    super.initState();

    menuController = MenuController(
      vsync: this,
    )..addListener(
        () => {
          if (mounted) {setState(() {})}
        },
      );
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations(
      [
        DeviceOrientation.portraitUp,
        DeviceOrientation.portraitDown,
      ],
    );
    return ChangeNotifierProvider(
      create: (context) => menuController,
      child: ZoomableScaffold(
        showButton: false,
        // bodyBackgroundColor: const Color.fromARGB(255, 157, 218, 166),
        headerText: "로그인",
        contentScreen: Layout(
          contentBuilder: (cc) => Container(
            padding: const EdgeInsets.fromLTRB(16, 3, 16, 6),
            margin: const EdgeInsets.only(top: 8, left: 8, right: 8, bottom: 0),
            child: const LoginPage(),
          ),
        ),
      ),
    );
  }
}
