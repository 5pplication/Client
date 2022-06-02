import 'package:client/i18n/pw_validator.dart';
import 'package:client/ui/dialog/smooth_dialog.dart';
import 'package:client/utils/form_checker.dart';
import 'package:client/utils/net/requester.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_pw_validator/flutter_pw_validator.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({Key? key}) : super(key: key);

  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  bool _canRegister = false;

  final _userEmailTextFormKey = GlobalKey<FormState>();
  final _userPasswordTextFormKey = GlobalKey<FormState>();
  final _userPasswordConfirmTextFormKey = GlobalKey<FormState>();
  final _userUserNameTextFormKey = GlobalKey<FormState>();

  late TextEditingController _userEmailController;
  late TextEditingController _userPasswordController;
  late TextEditingController _userPasswordConfirmController;
  late TextEditingController _userUserNameController;

  @override
  void initState() {
    super.initState();
    _userEmailController = TextEditingController();
    _userPasswordController = TextEditingController();
    _userPasswordConfirmController = TextEditingController();
    _userUserNameController = TextEditingController();
  }

  @override
  void dispose() {
    _userEmailController.dispose();
    _userPasswordController.dispose();
    _userPasswordConfirmController.dispose();
    _userUserNameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              "만나서 반갑습니다!",
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 16),
            Form(
              key: _userUserNameTextFormKey,
              child: TextFormField(
                validator: (value) => validateUserName(value),
                controller: _userUserNameController,
                decoration: const InputDecoration(
                  icon: Icon(FontAwesomeIcons.addressCard),
                  labelText: "사용자 이름",
                  hintText: "username",
                  // border: OutlineInputBorder(),
                ),
              ),
            ),
            const SizedBox(height: 8),
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
            const SizedBox(height: 8),
            Form(
              key: _userPasswordConfirmTextFormKey,
              child: TextFormField(
                validator: (value) => validatePasswordConfirm(
                    value, _userPasswordController.value.text),
                controller: _userPasswordConfirmController,
                keyboardType: TextInputType.visiblePassword,
                obscureText: true,
                decoration: const InputDecoration(
                  icon: Icon(Icons.key),
                  labelText: "비밀번호 확인",
                  hintText: "********",
                  // border: OutlineInputBorder(),
                ),
              ),
            ),
            const SizedBox(
              height: 32,
            ),
            FlutterPwValidator(
                controller: _userPasswordController,
                strings: KoreanStrings(),
                minLength: 8,
                uppercaseCharCount: 1,
                numericCharCount: 3,
                specialCharCount: 1,
                width: 400,
                height: 150,
                onSuccess: () {
                  setState(() {
                    _canRegister = true;
                  });
                },
                onFail: () {
                  setState(() {
                    _canRegister = false;
                  });
                }),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () async {
                if (_userUserNameTextFormKey.currentState!.validate() &&
                    _userEmailTextFormKey.currentState!.validate() &&
                    _userPasswordTextFormKey.currentState!.validate() &&
                    _userPasswordConfirmTextFormKey.currentState!.validate() &&
                    _canRegister) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('회원가입중')),
                  );
                  if (kDebugMode) {
                    print(_userEmailController.value.text);
                    print(_userPasswordController.value.text);
                  }
                  final result = await register(
                      _userEmailController.value.text,
                      _userPasswordController.value.text,
                      _userUserNameController.value.text);
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
                      false);
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                        content: Text('필드의 일부 또는 전체가 조건을 충족하지 않습니다.')),
                  );
                }
              },
              child: const Text("회원가입"),
              style: ButtonStyle(
                foregroundColor: MaterialStateProperty.all<Color>(Colors.white),
                backgroundColor:
                    MaterialStateProperty.all<Color>(Colors.orange),
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
      ),
    );
  }
}
