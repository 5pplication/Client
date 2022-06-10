import 'package:client/globals.dart';
import 'package:client/ui/dialog/smooth_dialog.dart';
import 'package:client/ui/holder/zoomable_scaffold.dart';
import 'package:client/ui/pages/dummy.dart';
import 'package:client/ui/pages/feed.dart';
import 'package:client/ui/pages/login.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';

class MenuScreen extends StatelessWidget {
  const MenuScreen({Key? key}) : super(key: key);

  // final List<MenuItem> options = [
  //   MenuItem(FontAwesomeIcons.clock, '시계'),
  //   MenuItem(Icons.alarm, '알람'),
  //   MenuItem(Icons.timer, '타이머'),
  //   MenuItem(FontAwesomeIcons.stopwatch, '스톱워치'),
  // ];

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onPanUpdate: (details) {
        //on swiping left
        if (details.delta.dx < -6) {
          Provider.of<MenuController>(context, listen: false).toggle();
        }
      },
      child: Container(
        padding: EdgeInsets.only(
            top: 62,
            left: 32,
            bottom: 8,
            right: MediaQuery.of(context).size.width / 2.9),
        color: const Color(0XFF3F51b5),
        child: Column(
          children: <Widget>[
            const Spacer(
              flex: 2,
            ),
            Expanded(
              flex: 7,
              child: Center(
                child: SingleChildScrollView(
                  physics: const ClampingScrollPhysics(),
                  child: Column(children: <Widget>[
                    ListTile(
                      title: const Text(
                        "피드",
                        style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: Colors.white),
                      ),
                      leading: const Icon(
                        Icons.feed,
                        color: Colors.white,
                        size: 20,
                      ),
                      onTap: () => {
                        Navigator.of(context).pushReplacement(
                          MaterialPageRoute(
                            builder: (BuildContext context) => const Feed(),
                          ),
                        ),
                      },
                    ),
                    ListTile(
                      title: const Text(
                        " 알람",
                        style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: Colors.white),
                      ),
                      leading: const Icon(
                        Icons.alarm,
                        color: Colors.white,
                        size: 20,
                      ),
                      onTap: () => {
                        Navigator.of(context).pushReplacement(
                          MaterialPageRoute(
                            builder: (BuildContext context) => const Alarm(),
                          ),
                        ),
                      },
                    ),
                    ListTile(
                      title: const Text(
                        " 타이머",
                        style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: Colors.white),
                      ),
                      leading: const Icon(
                        Icons.timer,
                        color: Colors.white,
                        size: 20,
                      ),
                      onTap: () {
                        // Navigator.of(context).pop();
                        // Navigator.of(context).push(new MaterialPageRoute(builder: (BuildContext context)=> new Demo1()));
                      },
                    ),
                    ListTile(
                      title: const Text(
                        " 스톱워치",
                        style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: Colors.white),
                      ),
                      leading: const Icon(
                        FontAwesomeIcons.stopwatch,
                        color: Colors.white,
                        size: 20,
                      ),
                      onTap: () {
                        // Navigator.of(context).pop();
                        // Navigator.of(context).push(new MaterialPageRoute(builder: (BuildContext context)=> new Demo1()));
                      },
                    ),
                  ]),
                ),
              ),
            ),
            const Spacer(
              flex: 2,
            ),
            ListTile(
              onTap: () async {
                await secureStorage?.delete(key: "email");
                await secureStorage?.delete(key: "password");
                createSmoothDialog(
                    context,
                    "로그아웃됨",
                    const Text("로그아웃 되었습니다."),
                    TextButton(
                      child: const Text("확인"),
                      onPressed: () async {
                        Navigator.pop(context);
                        Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const Login()),
                          (route) => false,
                        );
                      },
                    ),
                    const Icon(Icons.logout),
                    false);
              },
              leading: const Icon(
                Icons.logout,
                color: Colors.white,
                size: 20,
              ),
              title: const Text(
                '로그아웃',
                style: TextStyle(
                  fontSize: 14,
                  color: Color.fromRGBO(229, 57, 53, 1),
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            // THIS IS DUMMY
            ListTile(
              onTap: () {},
              title: const Text(' ',
                  style: TextStyle(fontSize: 14, color: Colors.white)),
            ),
          ],
        ),
      ),
    );
  }
}

class MenuItem {
  String title;
  IconData icon;

  MenuItem(this.icon, this.title);
}
