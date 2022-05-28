import 'package:client/constants/theme.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ZoomableScaffold extends StatefulWidget {
  const ZoomableScaffold({
    Key? key,
    required this.contentScreen,
    required this.headerText,
    required this.showButton,
    this.headerBackgroundColor,
    this.bodyBackgroundColor,
    this.menuScreen,
  }) : super(key: key);

  final Widget? menuScreen;
  final Layout contentScreen;
  final String headerText;
  final bool showButton;
  final Color? bodyBackgroundColor;
  final Color? headerBackgroundColor;

  @override
  _ZoomableScaffoldState createState() => _ZoomableScaffoldState();
}

class _ZoomableScaffoldState extends State<ZoomableScaffold>
    with TickerProviderStateMixin {
  _footerMargin() {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.only(bottom: 16),
      height: 0,
      child: Center(
        child: Text(
          '',
          style: TextStyle(
            fontWeight: FontWeight.w700,
            color: Colors.blue[900],
            fontSize: 16,
          ),
        ),
      ),
    );
  }

  Curve scaleDownCurve = const Interval(0.0, 0.3, curve: Curves.easeOut);
  Curve scaleUpCurve = const Interval(0.0, 1.0, curve: Curves.easeOut);
  Curve slideOutCurve = const Interval(0.0, 1.0, curve: Curves.easeOut);
  Curve slideInCurve = const Interval(0.0, 1.0, curve: Curves.easeOut);

  createContentDisplay() {
    return zoomAndSlideContent(
      ScaffoldMessenger(
        child: Scaffold(
          backgroundColor:
              widget.headerBackgroundColor ?? const Color(0XFF3F51B5),
          bottomNavigationBar: _footerMargin(),
          body: SafeArea(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                const SizedBox(
                  height: 32,
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 32),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Text(
                        widget.headerText,
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                          fontSize: 28,
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: Container(
                    width: double.infinity,
                    margin: const EdgeInsets.only(top: 32),
                    decoration: BoxDecoration(
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(40),
                        topRight: Radius.circular(40),
                      ),
                      color: widget.bodyBackgroundColor ?? CustomColors.clockBG,
                    ),
                    padding:
                        const EdgeInsets.symmetric(horizontal: 24, vertical: 0),
                    child: widget.contentScreen.contentBuilder(context),
                  ),
                ),
              ],
            ),
          ),
          appBar: AppBar(
              backgroundColor:
                  widget.headerBackgroundColor ?? const Color(0XFF3F51B5),
              elevation: 0.0,
              leading: widget.showButton
                  ? IconButton(
                      icon: const Icon(
                        Icons.menu,
                        color: Colors.white,
                      ),
                      onPressed: () {
                        Provider.of<MenuController>(context, listen: false)
                            .toggle();
                      },
                    )
                  : null),
        ),
      ),
    );
  }

  zoomAndSlideContent(Widget content) {
    double slidePercent, scalePercent;

    switch (Provider.of<MenuController>(context, listen: true).state) {
      case MenuState.closed:
        slidePercent = 0.0;
        scalePercent = 0.0;
        break;
      case MenuState.open:
        slidePercent = 1.0;
        scalePercent = 1.0;
        break;
      case MenuState.opening:
        slidePercent = slideOutCurve.transform(
            Provider.of<MenuController>(context, listen: true).percentOpen);
        scalePercent = scaleDownCurve.transform(
            Provider.of<MenuController>(context, listen: true).percentOpen);
        break;
      case MenuState.closing:
        slidePercent = slideInCurve.transform(
            Provider.of<MenuController>(context, listen: true).percentOpen);
        scalePercent = scaleUpCurve.transform(
            Provider.of<MenuController>(context, listen: true).percentOpen);
        break;
    }

    final slideAmount = 275.0 * slidePercent;
    final contentScale = 1.0 - (0.2 * scalePercent);
    final cornerRadius =
        16.0 * Provider.of<MenuController>(context, listen: true).percentOpen;

    return Transform(
      transform: Matrix4.translationValues(slideAmount, 0.0, 0.0)
        ..scale(contentScale, contentScale),
      alignment: Alignment.centerLeft,
      child: Container(
        decoration: const BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: Colors.black12,
              offset: Offset(0.0, 5.0),
              blurRadius: 15.0,
              spreadRadius: 10.0,
            ),
          ],
        ),
        child: ClipRRect(
            borderRadius: BorderRadius.circular(cornerRadius), child: content),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          color: widget.bodyBackgroundColor ?? const Color(0XFF3F51B5),
          child: Scaffold(
            body: widget.menuScreen,
          ),
        ),
        createContentDisplay()
      ],
    );
  }
}

class ZoomScaffoldMenuController extends StatefulWidget {
  final ZoomScaffoldBuilder builder;

  const ZoomScaffoldMenuController({
    required this.builder,
  });

  @override
  ZoomScaffoldMenuControllerState createState() {
    return ZoomScaffoldMenuControllerState();
  }
}

class ZoomScaffoldMenuControllerState
    extends State<ZoomScaffoldMenuController> {
  @override
  Widget build(BuildContext context) {
    return widget.builder(
        context, Provider.of<MenuController>(context, listen: true));
  }
}

typedef ZoomScaffoldBuilder = Widget Function(
    BuildContext context, MenuController menuController);

class Layout {
  final WidgetBuilder contentBuilder;

  Layout({
    required this.contentBuilder,
  });
}

class MenuController extends ChangeNotifier {
  final TickerProvider vsync;
  final AnimationController _animationController;
  MenuState state = MenuState.closed;

  MenuController({
    required this.vsync,
  }) : _animationController = AnimationController(vsync: vsync) {
    _animationController
      ..duration = const Duration(milliseconds: 250)
      ..addListener(
        () {
          notifyListeners();
        },
      )
      ..addStatusListener(
        (AnimationStatus status) {
          switch (status) {
            case AnimationStatus.forward:
              state = MenuState.opening;
              break;
            case AnimationStatus.reverse:
              state = MenuState.closing;
              break;
            case AnimationStatus.completed:
              state = MenuState.open;
              break;
            case AnimationStatus.dismissed:
              state = MenuState.closed;
              break;
          }
          notifyListeners();
        },
      );
  }

  @override
  dispose() {
    _animationController.dispose();
    super.dispose();
  }

  get percentOpen {
    return _animationController.value;
  }

  open() {
    _animationController.forward();
  }

  close() {
    _animationController.reverse();
  }

  toggle() {
    if (state == MenuState.open) {
      close();
    } else if (state == MenuState.closed) {
      open();
    }
  }
}

enum MenuState {
  closed,
  opening,
  open,
  closing,
}
