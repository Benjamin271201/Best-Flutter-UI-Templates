import 'package:best_flutter_ui_templates/home/stats/avg_sleep_card.dart';
import 'package:best_flutter_ui_templates/home/ui/title_view.dart';
import 'package:best_flutter_ui_templates/home/stats/mood_chart.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../home_theme.dart';
import 'mood_chart.dart';
import 'package:month_picker_dialog/month_picker_dialog.dart';

class StatsScreen extends StatefulWidget {
  final AnimationController? animationController;
  const StatsScreen({Key? key, this.animationController}) : super(key: key);

  @override
  _StatsScreenState createState() => _StatsScreenState();
}

class _StatsScreenState extends State<StatsScreen>
    with TickerProviderStateMixin {
  Animation<double>? topBarAnimation;
  int? month, year;
  DateTime? _selected;
  TextEditingController dateinput = TextEditingController();
  List<Widget> listViews = <Widget>[];
  final ScrollController scrollController = ScrollController();
  double topBarOpacity = 0.0;

  @override
  void initState() {
    dateinput.text = DateFormat('yyyy-MM').format(DateTime.now());
    setSelectedMonth(int.parse(dateinput.text.split("-")[1]));
    setSelectedYear(int.parse(dateinput.text.split("-")[0]));
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
        titleTxt: 'Mood Chart',
        animation: Tween<double>(begin: 0.0, end: 1.0).animate(CurvedAnimation(
            parent: widget.animationController!,
            curve:
                Interval((1 / count) * 0, 1.0, curve: Curves.fastOutSlowIn))),
        animationController: widget.animationController!,
      ),
    );
    listViews.add(
      MoodChart(),
    );
    listViews.add(
      TitleView(
        titleTxt: 'Sleep Stats',
        animation: Tween<double>(begin: 0.0, end: 1.0).animate(CurvedAnimation(
            parent: widget.animationController!,
            curve:
            Interval((1 / count) * 0, 1.0, curve: Curves.fastOutSlowIn))),
        animationController: widget.animationController!,
      ),
    );
    listViews.add(
      AverageSleep(),
    );
  }

  setSelectedMonth(int month) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setInt("month", month);
  }

  setSelectedYear(int year) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setInt("year", year);
  }

  Future<bool> getData() async {
    await Future<dynamic>.delayed(const Duration(milliseconds: 50));
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
            getMainListViewUI(),
            getAppBarUI(),
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
          return ListView.builder(
            controller: scrollController,
            padding: EdgeInsets.only(
              top: AppBar().preferredSize.height +
                  MediaQuery.of(context).padding.top +
                  24,
              bottom: 62 + MediaQuery.of(context).padding.bottom,
            ),
            itemCount: listViews.length,
            scrollDirection: Axis.vertical,
            itemBuilder: (BuildContext context, int index) {
              widget.animationController?.forward();
              return listViews[index];
            },
          );
        }
      },
    );
  }

  Widget getAppBarUI() {
    return Column(
      children: <Widget>[
        AnimatedBuilder(
          animation: widget.animationController!,
          builder: (BuildContext context, Widget? child) {
            return FadeTransition(
              opacity: topBarAnimation!,
              child: Transform(
                transform: Matrix4.translationValues(
                    0.0, 30 * (1.0 - topBarAnimation!.value), 0.0),
                child: Container(
                  decoration: BoxDecoration(
                    color: HomeTheme.white.withOpacity(topBarOpacity),
                    borderRadius: const BorderRadius.only(
                      bottomLeft: Radius.circular(32.0),
                    ),
                    boxShadow: <BoxShadow>[
                      BoxShadow(
                          color:
                              HomeTheme.grey.withOpacity(0.4 * topBarOpacity),
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
                                  'Stats',
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
                            // InkWell(
                            //     onTap: () async {
                            //       DateTime? pickedDate = await showMonthPicker(
                            //         context: context,
                            //         initialDate: DateTime.now(),
                            //         firstDate: DateTime(
                            //             2000), //DateTime.now() - not to allow to choose before today.
                            //         lastDate: DateTime(2101),
                            //         locale: null,
                            //       );
                            //
                            //       if (pickedDate != null) {
                            //         String formattedDate = DateFormat('yyyy-MM')
                            //             .format(pickedDate);
                            //         setState(() {
                            //           dateinput.text = formattedDate;
                            //           year = int.parse(
                            //               formattedDate.split("-")[0]);
                            //           month = int.parse(
                            //               formattedDate.split("-")[1]);
                            //         });
                            //         setSelectedMonth(month!);
                            //         setSelectedYear(year!);
                            //         setState(() {});
                            //       } else {
                            //         String formattedDate = DateFormat('yyyy-MM')
                            //             .format(DateTime.now());
                            //         setState(() {
                            //           dateinput.text = formattedDate;
                            //         });
                            //       }
                            //     },
                            //     child: Padding(
                            //       padding: const EdgeInsets.only(
                            //         left: 8,
                            //         right: 8,
                            //       ),
                            //       child: Row(
                            //         children: <Widget>[
                            //           Padding(
                            //               padding:
                            //                   const EdgeInsets.only(right: 8),
                            //               child: Icon(
                            //                 Icons.calendar_today,
                            //                 color: HomeTheme.grey,
                            //                 size: 18,
                            //               )),
                            //           Text(
                            //             dateinput.text,
                            //             textAlign: TextAlign.left,
                            //             style: TextStyle(
                            //               fontFamily: HomeTheme.fontName,
                            //               fontWeight: FontWeight.normal,
                            //               fontSize: 18,
                            //               letterSpacing: -0.2,
                            //               color: HomeTheme.darkerText,
                            //             ),
                            //           ),
                            //         ],
                            //       ),
                            //     )),
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              ),
            );
          },
        )
      ],
    );
  }

}
