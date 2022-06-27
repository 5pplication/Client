import 'package:client/globals.dart';
import 'package:client/ui/dialog/smooth_dialog.dart';
import 'package:client/ui/pages/feed.dart';
import 'package:client/ui/pages/register.dart';
import 'package:client/utils/form_checker.dart';
import 'package:client/utils/net/requester.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../utils/net/model/login.dart';

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

  late String? email;
  late String? password;
  late String emailString;
  late String passwordString;

  @override
  void initState() {
    super.initState();
    _userEmailController = TextEditingController();
    _userPasswordController = TextEditingController();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _checkSecureStorage();
    });
  }

  _checkSecureStorage() async {
    //read 함수를 통하여 key값에 맞는 정보를 불러오게 됩니다. 이때 불러오는 결과의 타입은 String 타입임을 기억해야 합니다.
    //(데이터가 없을때는 null을 반환을 합니다.)
    if (secureStorage == null) {
      initSecureStorage();
    }
    print(secureStorage);
    email = (await secureStorage?.read(key: "email"));
    password = (await secureStorage?.read(key: "password"));
    email == null ? emailString = "이메일 정보 없음" : emailString = email!;
    password == null ? passwordString = "암호 정보 없음" : passwordString = password!;
    print(emailString);
    print(passwordString);

    //user의 정보가 있다면 바로 로그아웃 페이지로 넝어가게 합니다.
    if (email != null && password != null) {
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => const Feed()),
        (route) => false,
      );
    }
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
              keyboardType: TextInputType.emailAddress,
              decoration: const InputDecoration(
                icon: Icon(FontAwesomeIcons.at),
                labelText: "이메일",
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
              keyboardType: TextInputType.visiblePassword,
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
            onPressed: () async {
              if (_userEmailTextFormKey.currentState!.validate() &&
                  _userPasswordTextFormKey.currentState!.validate()) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('로그인중')),
                );
                if (kDebugMode) {
                  print(_userEmailController.value.text);
                  print(_userPasswordController.value.text);
                }
                try {
                  String resultTitleString;
                  String resultMessageString;
                  bool success = false;
                  Login loginResult = await login(
                      _userEmailController.value.text,
                      _userPasswordController.value.text);
                  print(loginResult.message);

                  switch (loginResult.message) {
                    case "noId":
                      resultTitleString = "로그인 실패";
                      resultMessageString = "해당 계정이 존재하지 않습니다. 계정을 만들어 보세요.";
                      break;
                    case "wrongPassword":
                      resultTitleString = "로그인 실패";
                      resultMessageString = "암호가 일치하지 않습니다.";
                      break;
                    case "welcome":
                      success = true;
                      resultTitleString = "로그인 성공";
                      resultMessageString = "로그인 성공";
                      break;
                    default:
                      resultTitleString = "서버의 메세지";
                      resultMessageString = loginResult.message;
                  }
                  if (!success) {
                    createSmoothDialog(
                        context,
                        resultTitleString,
                        Text(resultMessageString),
                        TextButton(
                          child: const Text("닫기"),
                          onPressed: () async {
                            Navigator.pop(context);
                            try {
                              ScaffoldMessenger.of(context)
                                  .hideCurrentSnackBar();
                            } catch (e) {
                              return;
                            }
                            return;
                          },
                        ),
                        null,
                        false);
                  } else {
                    secureStorage?.write(
                        key: "email", value: _userEmailController.value.text);
                    secureStorage?.write(
                        key: "password",
                        value: _userPasswordController.value.text);
                    try {
                      ScaffoldMessenger.of(context).hideCurrentSnackBar();
                    } catch (e) {
                      return;
                    }
                    Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(builder: (context) => const Feed()),
                      (route) => false,
                    );
                  }
                } catch (e) {
                  if (kDebugMode) {
                    print("Server Connectioin Failed: \n" + e.toString());
                  }
                  createSmoothDialog(
                      context,
                      "어쩔티비",
                      const Text("서버 터짐 ㅅㄱ"),
                      TextButton(
                        child: const Text("닫기"),
                        onPressed: () async {
                          return Navigator.pop(context);
                        },
                      ),
                      null,
                      false);
                }
                if (kDebugMode) {
                  print(await secureStorage?.read(key: "email"));
                  print(await secureStorage?.read(key: "password"));
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
              Navigator.push(
                  context, MaterialPageRoute(builder: (_) => const Register()));
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
