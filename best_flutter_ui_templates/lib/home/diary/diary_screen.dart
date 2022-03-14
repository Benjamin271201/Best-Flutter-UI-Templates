import 'package:best_flutter_ui_templates/fitness_app/ui_view/title_view.dart';
import 'package:best_flutter_ui_templates/home/diary/sleep.dart';
import 'package:best_flutter_ui_templates/home/diary/sleep_detail.dart';
import 'package:best_flutter_ui_templates/home/home_theme.dart';
import 'package:best_flutter_ui_templates/service/HttpService.dart';
import 'package:flutter/material.dart';
import 'package:month_picker_dialog/month_picker_dialog.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:intl/intl.dart';

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
  String? username;
  int month = 0, year = 0, userId = 6;
  var isLoaded = false;
  List<Widget> listViews = <Widget>[];
  final ScrollController scrollController = ScrollController();
  double topBarOpacity = 0.0;
  final DateFormat formatter = DateFormat('dd-MM-yyyy');
  TextEditingController dateinput = TextEditingController();

  @override
  void initState() {
    getUser();
    getSelectedMonthYear();
    dateinput.text = DateFormat('yyyy-MM').format(DateTime.now());
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

  Future<bool> getUser() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      userId = prefs.getInt("id")!;
      username = prefs.getString("username");
    });
    return true;
  }

  Future<bool> getDiary() async {
    Future.delayed(const Duration(milliseconds: 300), () async {
      if (await getUser()) {
        listSleep =
        await HttpService().getSleepDiaryByMonth(userId, month, year);
        if (listSleep != null)
          setState(() {
            isLoaded = true;
          });
      }
    });
    return true;
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
                      onTap: () => {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        SleepDetail(sleep: listSleep![index])))
                          },
                      child: Card(
                          color: Colors.white,
                          child: Row(children: <Widget>[
                            Expanded(
                                child: ListTile(
                                    title: Text(formatter
                                        .format(item.sleepDate)
                                        .toString()))),
                            SizedBox(
                              width: 100,
                              child: ListTile(
                                title: Text("Mood: " + item.mood.toString()),
                                textColor: Colors.red,
                              ),
                            ),
                            SizedBox(
                              width: 150,
                              child: ListTile(
                                  title: Text("Duration: " +
                                      convertToHours(item.sleepDuration)),
                                  textColor: Colors.green),
                            )
                          ])));
                },
              ));
        }
      },
    );
  }

  Future<bool> getSelectedMonthYear() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      month = prefs.getInt("month")!;
      year = prefs.getInt("year")!;
      userId = prefs.getInt("id")!;
    });
    getDiary();
    return true;
  }

  String convertToHours(int sleepTime) {
    int hours = sleepTime ~/ 60;
    int mins = sleepTime - (hours * 60);
    return hours.toString() + "h" + mins.toString();
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
                  InkWell(
                    onTap: () async {
                      DateTime? pickedDate = await showDatePicker(
                        context: context,
                        initialDate: DateTime.now(),
                        firstDate: DateTime(
                            2000), //DateTime.now() - not to allow to choose before today.
                        lastDate: DateTime(2101),
                        locale: null,
                      );

                      if (pickedDate != null) {
                        String formattedDate =
                        DateFormat('yyyy-MM').format(pickedDate);
                        setState(() {
                          dateinput.text = formattedDate;
                          year = int.parse(formattedDate.split("-")[0]);
                          month = int.parse(formattedDate.split("-")[1]);
                        });
                        getDiary();
                      } else {
                        String formattedDate =
                        DateFormat('yyyy-MM').format(DateTime.now());
                        setState(() {
                          dateinput.text = formattedDate;
                        });
                        getDiary();
                      }
                    },
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
                          dateinput.text,
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
                ],
              ),
            )
          ],
        ),
      ),
    ]);
  }
}
