import 'package:client/utils/form_checker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _userEmailTextFormKey = GlobalKey<FormState>();
  final _userPasswordTextFormKey = GlobalKey<FormState>();
  late TextEditingController _userEmailController;
  late TextEditingController _userPasswordController;

  @override
  void initState() {
    super.initState();
    _userEmailController = TextEditingController();
    _userPasswordController = TextEditingController();
  }

  @override
  void dispose() {
    _userEmailController.dispose();
    _userPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            "돌아온 것을 환영합니다!",
            style: Theme.of(context).textTheme.titleLarge,
          ),
          const SizedBox(height: 16),
          Form(
            key: _userEmailTextFormKey,
            child: TextFormField(
              validator: (value) => validateEmail(value),
              controller: _userEmailController,
              decoration: const InputDecoration(
                icon: Icon(Icons.account_circle),
                labelText: "email",
                hintText: "someone@example.com",
                // border: OutlineInputBorder(),
              ),
            ),
          ),
          const SizedBox(height: 8),
          Form(
            key: _userPasswordTextFormKey,
            child: TextFormField(
              validator: (value) => validatePassword(value),
              controller: _userPasswordController,
              obscureText: true,
              decoration: const InputDecoration(
                icon: Icon(Icons.key),
                labelText: "비밀번호",
                hintText: "********",
                // border: OutlineInputBorder(),
              ),
            ),
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: () {
              if (_userEmailTextFormKey.currentState!.validate() &&
                  _userPasswordTextFormKey.currentState!.validate()) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('로그인중')),
                );
                if (kDebugMode) {
                  print(_userEmailController.value.text);
                  print(_userPasswordController.value.text);
                }
              }
            },
            child: const Text("로그인"),
            style: ButtonStyle(
              foregroundColor: MaterialStateProperty.all<Color>(Colors.white),
              backgroundColor: MaterialStateProperty.all<Color>(Colors.orange),
              shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(18.0),
                  //side: BorderSide(color: Colors.red) // border line color
                ),
              ),
            ),
          ),
          const SizedBox(height: 16),
          Row(children: const <Widget>[
            Expanded(child: Divider(thickness: 2)),
            Text("또는 계정이 없다면"),
            Expanded(child: Divider(thickness: 2)),
          ]),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text("회원가입")),
              );
              if (kDebugMode) {
                print(_userEmailController.value.text);
                print(_userPasswordController.value.text);
              }
            },
            child: const Text("계정 만들기"),
            style: ButtonStyle(
              foregroundColor: MaterialStateProperty.all<Color>(Colors.white),
              backgroundColor: MaterialStateProperty.all<Color>(Colors.orange),
              shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(18.0),
                  //side: BorderSide(color: Colors.red) // border line color
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
