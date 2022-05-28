import 'package:client/ui/holder/zoomable_scaffold.dart';
import 'package:client/ui/view/register.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

class Register extends StatefulWidget {
  const Register({Key? key, this.title}) : super(key: key);

  final String? title;

  @override
  _RegisterState createState() => _RegisterState();
}

class _RegisterState extends State<Register> with TickerProviderStateMixin {
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
        headerText: "회원가입",
        contentScreen: Layout(
          contentBuilder: (cc) => Container(
            padding: const EdgeInsets.fromLTRB(16, 3, 16, 6),
            margin: const EdgeInsets.only(top: 8, left: 8, right: 8, bottom: 0),
            child: const RegisterPage(),
          ),
        ),
      ),
    );
  }
}
