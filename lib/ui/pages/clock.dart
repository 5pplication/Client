import 'package:client/ui/holder/zoomable_scaffold.dart';
import 'package:client/ui/view/clock.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import 'drawer_menu.dart';

class Clock extends StatefulWidget {
  const Clock({Key? key, this.title}) : super(key: key);

  final String? title;

  @override
  _ClockState createState() => _ClockState();
}

class _ClockState extends State<Clock> with TickerProviderStateMixin {
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
        showButton: true,
        headerText: "시계",
        menuScreen: const MenuScreen(),
        contentScreen: Layout(
          contentBuilder: (cc) => Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Container(
                padding: const EdgeInsets.fromLTRB(16, 3, 16, 6),
                margin:
                    const EdgeInsets.only(top: 8, left: 8, right: 8, bottom: 0),
                child: ClockPage(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
