// ignore_for_file: unused_import

import 'package:best_flutter_ui_templates/home/profile/profile_screen.dart';
import 'package:best_flutter_ui_templates/home/alram_clock/alram_clock_screen.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'bottom_bar_view.dart';
import 'home_theme.dart';
import 'diary/diary_screen.dart';
import 'stats/stats_screen.dart';
import 'models/tabIcon_data.dart';
import 'package:best_flutter_ui_templates/model/user.dart';

class HomeScreen extends StatefulWidget {

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with TickerProviderStateMixin {
  AnimationController? animationController;

  List<TabIconData> tabIconsList = TabIconData.tabIconsList;

  Widget tabBody = Container(
    color: HomeTheme.background,
  );
  @override
  void initState() {
    tabIconsList.forEach((TabIconData tab) {
      tab.isSelected = false;
    });
    tabIconsList[0].isSelected = true;

    animationController = AnimationController(
        duration: const Duration(milliseconds: 600), vsync: this);
    tabBody = StatsScreen(animationController: animationController);
    super.initState();
  }

  @override
  void dispose() {
    animationController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: HomeTheme.background,
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: FutureBuilder<bool>(
          future: getData(),
          builder: (BuildContext context, AsyncSnapshot<bool> snapshot) {
            if (!snapshot.hasData) {
              return const SizedBox();
            } else {
              return Stack(
                children: <Widget>[
                  tabBody,
                  bottomBar(),
                ],
              );
            }
          },
        ),
      ),
    );
  }

  Future<bool> getData() async {
    await Future<dynamic>.delayed(const Duration(milliseconds: 200));
    return true;
  }

  Widget bottomBar() {
    return Column(
      children: <Widget>[
        const Expanded(
          child: SizedBox(),
        ),
        BottomBarView(
            tabIconsList: tabIconsList,
            addClick: () {},
            changeIndex: (int index) {
              switch (index) {
                case 0:
                  animationController?.reverse().then<dynamic>((data) {
                    if (!mounted) {
                      return;
                    }
                    setState(() {
                      tabBody =
                          StatsScreen(animationController: animationController);
                    });
                  });
                  break;
                case 1:
                  animationController?.reverse().then<dynamic>((data) {
                    if (!mounted) {
                      return;
                    }
                    setState(() {
                      tabBody =
                          DiaryScreen(animationController: animationController);
                    });
                  });
                  break;
                case 2:
                  animationController?.reverse().then<dynamic>((data) {
                    if (!mounted) {
                      return;
                    }
                    setState(() {
                      tabBody =
                          AlarmClock(animationController: animationController);
                    });
                  });
                  break;
                case 3:
                  animationController?.reverse().then<dynamic>((data) {
                    if (!mounted) {
                      return;
                    }
                    setState(() {
                      tabBody = ProfileScreen();
                    });
                  });
                  break;
              }
            }),
      ],
    );
  }
}
