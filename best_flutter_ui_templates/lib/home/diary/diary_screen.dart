import 'package:best_flutter_ui_templates/fitness_app/ui_view/body_measurement.dart';
import 'package:best_flutter_ui_templates/fitness_app/ui_view/glass_view.dart';
import 'package:best_flutter_ui_templates/fitness_app/ui_view/mediterranean_diet_view.dart';
import 'package:best_flutter_ui_templates/fitness_app/ui_view/title_view.dart';
import 'package:best_flutter_ui_templates/home/diary/sleep.dart';
import 'package:best_flutter_ui_templates/home/home_theme.dart';
import 'package:best_flutter_ui_templates/fitness_app/my_diary/meals_list_view.dart';
import 'package:best_flutter_ui_templates/fitness_app/my_diary/water_view.dart';
import 'package:best_flutter_ui_templates/service/HttpService.dart';
import 'package:flutter/material.dart';

class DiaryScreen extends StatefulWidget {
  const DiaryScreen({Key? key, this.animationController}) : super(key: key);

  final AnimationController? animationController;
  @override
  _DiaryScreenState createState() => _DiaryScreenState();
}

class _DiaryScreenState extends State<DiaryScreen>
    with TickerProviderStateMixin {
  Animation<double>? topBarAnimation;

  List<Sleep>? listSleep;
  var isLoaded = false;
  List<Widget> listViews = <Widget>[];
  final ScrollController scrollController = ScrollController();
  double topBarOpacity = 0.0;

  @override
  void initState() {
    getDiary();
    topBarAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
        CurvedAnimation(
            parent: widget.animationController!,
            curve: Interval(0, 0.5, curve: Curves.fastOutSlowIn)));
    addAllListData();

    scrollController.addListener(() {
      if (scrollController.offset >= 24) {
        if (topBarOpacity != 1.0) {
          setState(() {
            topBarOpacity = 1.0;
          });
        }
      } else if (scrollController.offset <= 24 &&
          scrollController.offset >= 0) {
        if (topBarOpacity != scrollController.offset / 24) {
          setState(() {
            topBarOpacity = scrollController.offset / 24;
          });
        }
      } else if (scrollController.offset <= 0) {
        if (topBarOpacity != 0.0) {
          setState(() {
            topBarOpacity = 0.0;
          });
        }
      }
    });
    super.initState();
  }

  void addAllListData() {
    const int count = 9;

    listViews.add(
      TitleView(
        titleTxt: 'Diary',
        animation: Tween<double>(begin: 0.0, end: 1.0).animate(CurvedAnimation(
            parent: widget.animationController!,
            curve:
                Interval((1 / count) * 0, 1.0, curve: Curves.fastOutSlowIn))),
        animationController: widget.animationController!,
      ),
    );
  }

  Future<bool> getData() async {
    await Future<dynamic>.delayed(const Duration(milliseconds: 50));
    return true;
  }

  getDiary() async {
    listSleep = await HttpService().getSleepDiaryByMonth(6, 3, 2022);
    if (listSleep != null)
      setState(() {
        isLoaded = true;
      });
  }

  void _showSleepDetail() {
    //TODO: show sleep detail code
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: HomeTheme.background,
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: Stack(
          children: <Widget>[
            getAppBarUI(),
            getMainListViewUI(),
            SizedBox(
              height: MediaQuery.of(context).padding.bottom,
            )
          ],
        ),
      ),
    );
  }

  Widget getMainListViewUI() {
    return FutureBuilder<bool>(
      future: getData(),
      builder: (BuildContext context, AsyncSnapshot<bool> snapshot) {
        if (!snapshot.hasData) {
          return const SizedBox();
        } else {
          return Visibility(
              visible: isLoaded,
              child: ListView.builder(
                controller: scrollController,
                padding: EdgeInsets.only(
                  top: AppBar().preferredSize.height +
                      MediaQuery.of(context).padding.top +
                      24,
                  bottom: 62 + MediaQuery.of(context).padding.bottom,
                ),
                itemCount: listSleep?.length,
                scrollDirection: Axis.vertical,
                itemBuilder: (BuildContext context, int index) {
                  final item = listSleep![index];
                  return InkWell(
                      onTap: _showSleepDetail,
                      child: ListTile(title: Text(item.mood)));
                },
              ));
        }
      },
    );
  }

  Widget getAppBarUI() {
    return Column(children: <Widget>[
      Container(
        decoration: BoxDecoration(
          color: HomeTheme.white.withOpacity(topBarOpacity),
          borderRadius: const BorderRadius.only(
            bottomLeft: Radius.circular(32.0),
          ),
          boxShadow: <BoxShadow>[
            BoxShadow(
                color: HomeTheme.grey.withOpacity(0.4 * topBarOpacity),
                offset: const Offset(1.1, 1.1),
                blurRadius: 10.0),
          ],
        ),
        child: Column(
          children: <Widget>[
            SizedBox(
              height: MediaQuery.of(context).padding.top,
            ),
            Padding(
              padding: EdgeInsets.only(
                  left: 16,
                  right: 16,
                  top: 16 - 8.0 * topBarOpacity,
                  bottom: 12 - 8.0 * topBarOpacity),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        'My Diary',
                        textAlign: TextAlign.left,
                        style: TextStyle(
                          fontFamily: HomeTheme.fontName,
                          fontWeight: FontWeight.w700,
                          fontSize: 22 + 6 - 6 * topBarOpacity,
                          letterSpacing: 1.2,
                          color: HomeTheme.darkerText,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 38,
                    width: 38,
                    child: InkWell(
                      highlightColor: Colors.transparent,
                      borderRadius:
                          const BorderRadius.all(Radius.circular(32.0)),
                      onTap: () {},
                      child: Center(
                        child: Icon(
                          Icons.keyboard_arrow_left,
                          color: HomeTheme.grey,
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(
                      left: 8,
                      right: 8,
                    ),
                    child: Row(
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.only(right: 8),
                          child: Icon(
                            Icons.calendar_today,
                            color: HomeTheme.grey,
                            size: 18,
                          ),
                        ),
                        Text(
                          '15 May',
                          textAlign: TextAlign.left,
                          style: TextStyle(
                            fontFamily: HomeTheme.fontName,
                            fontWeight: FontWeight.normal,
                            fontSize: 18,
                            letterSpacing: -0.2,
                            color: HomeTheme.darkerText,
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 38,
                    width: 38,
                    child: InkWell(
                      highlightColor: Colors.transparent,
                      borderRadius:
                          const BorderRadius.all(Radius.circular(32.0)),
                      onTap: () {},
                      child: Center(
                        child: Icon(
                          Icons.keyboard_arrow_right,
                          color: HomeTheme.grey,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    ]);
  }
}
