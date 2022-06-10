import 'package:client/globals.dart';
import 'package:client/ui/dialog/smooth_dialog.dart';
import 'package:client/ui/pages/clock.dart';
import 'package:client/ui/pages/register.dart';
import 'package:client/utils/form_checker.dart';
import 'package:client/utils/net/requester.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

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
        MaterialPageRoute(builder: (context) => const Clock()),
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
                  await login(_userEmailController.value.text,
                          _userPasswordController.value.text)
                      .then(
                    (result) => {
                      createSmoothDialog(
                          context,
                          "서버의 메세지",
                          Text(result.message),
                          TextButton(
                            child: const Text("닫기"),
                            onPressed: () async {
                              return Navigator.pop(context);
                            },
                          ),
                          null,
                          false)
                    },
                  );
                } catch (e) {
                  print("서버 터짐 티비");
                  print(e);
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
                await secureStorage?.write(
                    key: "email", value: _userEmailController.value.text);
                await secureStorage?.write(
                    key: "password", value: _userPasswordController.value.text);

                print(await secureStorage?.read(key: "email"));
                print(await secureStorage?.read(key: "password"));

                // 이거 로그인 성공시로 옮기기
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (context) => const Clock()),
                  (route) => false,
                );
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
