import 'package:client/ui/holder/zoomable_scaffold.dart';
import 'package:client/ui/view/feed.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import 'drawer_menu.dart';

class Feed extends StatefulWidget {
  const Feed({Key? key, this.title}) : super(key: key);

  final String? title;

  @override
  _FeedState createState() => _FeedState();
}

class _FeedState extends State<Feed> with TickerProviderStateMixin {
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
        headerText: "피드",
        menuScreen: const MenuScreen(),
        useSliver: false,
        contentScreen: Layout(
          contentBuilder: (cc) => const FeedPage(),
        ),
      ),
    );
  }
}
